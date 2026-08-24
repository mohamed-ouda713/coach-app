import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import JWT from 'https://esm.sh/google-auth-library@9.0.0'

// لازم تطابق NotificationTypeValues بـ lib/core/constants/supabase_constants.dart
const NOTIFICATION_TYPE_SUBSCRIPTION_EXPIRY = 'subscription_expiry'
const NOTIFICATION_TYPE_OVERDUE_MEASUREMENT = 'overdue_measurement'
const NOTIFICATION_TYPE_NEW_PROGRAM_NEEDED = 'new_program_needed'

const TABLE_SUBSCRIBERS = 'subscribers'
const TABLE_TRAINERS = 'trainers'
const TABLE_NOTIFICATIONS = 'notifications'
const TABLE_MEASUREMENTS = 'measurements'

const FCM_SCOPE = 'https://www.googleapis.com/auth/firebase.messaging'
const FCM_ENDPOINT = 'https://fcm.googleapis.com/v1/projects'

const MS_PER_DAY = 86_400_000

/// بعد كم يوم من موعد القياس المفروض منبعت تذكير (Feature 6).
const OVERDUE_MEASUREMENT_REMINDER_DAYS = [1, 3]

/// بعد كم يوم من آخر تحديث برنامج بيصير المشترك محتاج برنامج جديد.
const NEW_PROGRAM_AFTER_DAYS = 28

/// شو بنرجع فيه لورا وقت ما نفحص الإشعارات المرسلة سابقاً (منع التكرار).
const DEDUPE_LOOKBACK_DAYS = 60

const SUBSCRIPTION_EXPIRY_TITLE = 'تنبيه انتهاء اشتراك ⚠️'
const subscriptionExpiryBody = (name: string) =>
  `اشتراك المشترك ${name} سينتهي غداً.`

const OVERDUE_MEASUREMENT_TITLE = 'قياسات متأخرة 📏'
const overdueMeasurementBody = (name: string, days: number) =>
  `لم يتم تسجيل قياسات ${name} لهذا الشهر — تأخرت ${days} ${
    days === 1 ? 'يوم' : 'أيام'
  }.`

const NEW_PROGRAM_NEEDED_TITLE = 'برنامج تدريبي جديد 🏋️'
const newProgramNeededBody = (name: string, days: number) =>
  `مر ${days} يوم على برنامج ${name} التدريبي — يحتاج مراجعة خطة جديدة.`

interface Subscriber {
  id: string
  full_name: string
  trainer_id: string | null
  subscription_start_date: string
  subscription_end_date: string
  last_program_update: string | null
}

interface PendingNotification {
  trainerId: string
  subscriberId: string
  type: string
  title: string
  message: string
  /// للأنواع يلي بتنبعت "مرة وحدة لكل دورة" (برنامج جديد): ما منبعت إذا
  /// كان في إشعار من نفس النوع انبعت بتاريخ بعد هاد التاريخ.
  /// لو تركناها فاضية، القاعدة بتصير "إشعار واحد باليوم" (انتهاء اشتراك،
  /// وتذكير القياسات — لأن تذكير اليوم الأول والتالت بيصيروا بيومين مختلفين).
  onlyIfNoneSince?: Date
}

/// بترجع تاريخ (UTC) بدون وقت — عشان كل المقارنات تصير على مستوى اليوم.
function toUtcDay(value: string | Date): Date {
  const date = typeof value === 'string' ? new Date(value) : value
  return new Date(
    Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()),
  )
}

function isoDate(date: Date): string {
  return date.toISOString().split('T')[0]
}

function daysBetween(from: Date, to: Date): number {
  return Math.floor((to.getTime() - from.getTime()) / MS_PER_DAY)
}

/// موعد القياس المفروض لهاد الشهر = نفس يوم بدء الاشتراك، ومحدود بآخر
/// يوم بالشهر (اشتراك بدأ يوم 31 وشهر فيه 30 يوم → الموعد يوم 30).
function measurementDueDate(
  subscriptionStart: Date,
  year: number,
  month: number,
): Date {
  const startDay = subscriptionStart.getUTCDate()
  const lastDayOfMonth = new Date(Date.UTC(year, month + 1, 0)).getUTCDate()
  return new Date(Date.UTC(year, month, Math.min(startDay, lastDayOfMonth)))
}

Deno.serve(async (_req) => {
  try {
    const serviceAccountSecret = Deno.env.get('FCM_SERVICE_ACCOUNT')
    if (!serviceAccountSecret) {
      throw new Error('FCM_SERVICE_ACCOUNT secret is not configured')
    }
    const serviceAccount = JSON.parse(serviceAccountSecret)

    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
    )

    const client = new JWT.JWT({
      email: serviceAccount.client_email,
      key: serviceAccount.private_key,
      scopes: [FCM_SCOPE],
    })
    const tokens = await client.getRequestHeaders()
    const accessToken = tokens.Authorization

    const today = toUtcDay(new Date())
    const failures: { subscriberId: string; reason: string }[] = []

    // ── 1. جلب كل المشتركين مرة وحدة بدل استعلام لكل نوع إشعار ────
    const { data: subscribersData, error: subError } = await supabaseClient
      .from(TABLE_SUBSCRIBERS)
      .select(
        'id, full_name, trainer_id, subscription_start_date, subscription_end_date, last_program_update',
      )

    if (subError) throw subError
    const subscribers = (subscribersData ?? []) as Subscriber[]

    if (subscribers.length === 0) {
      return jsonResponse({ success: true, processed: 0, failures: [] })
    }

    // ── 2. مين سجّل قياس هالشهر؟ استعلام واحد للكل ────────────────
    const monthStart = new Date(
      Date.UTC(today.getUTCFullYear(), today.getUTCMonth(), 1),
    )
    const nextMonthStart = new Date(
      Date.UTC(today.getUTCFullYear(), today.getUTCMonth() + 1, 1),
    )

    const { data: monthMeasurements, error: measurementsError } =
      await supabaseClient
        .from(TABLE_MEASUREMENTS)
        .select('subscriber_id')
        .gte('measurement_month', isoDate(monthStart))
        .lt('measurement_month', isoDate(nextMonthStart))

    if (measurementsError) throw measurementsError

    const measuredThisMonth = new Set(
      (monthMeasurements ?? []).map((row: { subscriber_id: string }) =>
        String(row.subscriber_id)
      ),
    )

    // ── 3. بناء قائمة الإشعارات المستحقة اليوم ────────────────────
    const pending: PendingNotification[] = []

    for (const sub of subscribers) {
      if (!sub.trainer_id) continue

      const endDate = toUtcDay(sub.subscription_end_date)
      const startDate = toUtcDay(sub.subscription_start_date)

      // أ) انتهاء الاشتراك — بكرا بالضبط
      if (daysBetween(today, endDate) === 1) {
        pending.push({
          trainerId: sub.trainer_id,
          subscriberId: sub.id,
          type: NOTIFICATION_TYPE_SUBSCRIPTION_EXPIRY,
          title: SUBSCRIPTION_EXPIRY_TITLE,
          message: subscriptionExpiryBody(sub.full_name),
        })
      }

      // الاشتراكات المنتهية ما بيهمنا قياساتها ولا برنامجها
      const isActive = daysBetween(today, endDate) >= 0
      if (!isActive) continue

      // ب) قياسات متأخرة — بعد يوم وبعد 3 أيام من موعد الشهر
      if (!measuredThisMonth.has(String(sub.id))) {
        const dueDate = measurementDueDate(
          startDate,
          today.getUTCFullYear(),
          today.getUTCMonth(),
        )
        const daysOverdue = daysBetween(dueDate, today)
        // ما منذكّر قبل ما يبلّش الاشتراك أصلاً
        const subscriptionStarted = daysBetween(startDate, today) >= 0

        if (
          subscriptionStarted &&
          OVERDUE_MEASUREMENT_REMINDER_DAYS.includes(daysOverdue)
        ) {
          pending.push({
            trainerId: sub.trainer_id,
            subscriberId: sub.id,
            type: NOTIFICATION_TYPE_OVERDUE_MEASUREMENT,
            title: OVERDUE_MEASUREMENT_TITLE,
            message: overdueMeasurementBody(sub.full_name, daysOverdue),
          })
        }
      }

      // ج) يحتاج برنامج جديد — 28 يوم من آخر تحديث (أو من بداية الاشتراك)
      const programReference = sub.last_program_update
        ? toUtcDay(sub.last_program_update)
        : startDate
      const daysSinceProgram = daysBetween(programReference, today)

      if (daysSinceProgram >= NEW_PROGRAM_AFTER_DAYS) {
        pending.push({
          trainerId: sub.trainer_id,
          subscriberId: sub.id,
          type: NOTIFICATION_TYPE_NEW_PROGRAM_NEEDED,
          title: NEW_PROGRAM_NEEDED_TITLE,
          message: newProgramNeededBody(sub.full_name, daysSinceProgram),
          // إشعار واحد لكل "دورة برنامج" — ما بيتكرر كل يوم بعد الـ 28،
          // وبيرجع يشتغل من جديد لما يتحدّث تاريخ البرنامج
          onlyIfNoneSince: programReference,
        })
      }
    }

    if (pending.length === 0) {
      return jsonResponse({ success: true, processed: 0, failures: [] })
    }

    // ── 4. استبعاد يلي انبعت قبل (منع التكرار) ────────────────────
    const lookbackStart = new Date(
      today.getTime() - DEDUPE_LOOKBACK_DAYS * MS_PER_DAY,
    )
    const { data: sentData, error: sentError } = await supabaseClient
      .from(TABLE_NOTIFICATIONS)
      .select('subscriber_id, type, created_at')
      .gte('created_at', lookbackStart.toISOString())

    if (sentError) throw sentError

    // آخر يوم انبعت فيه كل تركيبة (مشترك + نوع إشعار)
    const lastSentDay = new Map<string, Date>()
    for (
      const row of (sentData ?? []) as {
        subscriber_id: string | null
        type: string | null
        created_at: string
      }[]
    ) {
      if (!row.subscriber_id || !row.type) continue
      const key = `${row.subscriber_id}|${row.type}`
      const sentAt = toUtcDay(row.created_at)
      const previous = lastSentDay.get(key)
      if (!previous || sentAt > previous) lastSentDay.set(key, sentAt)
    }

    const toSend = pending.filter((item) => {
      const lastSent = lastSentDay.get(`${item.subscriberId}|${item.type}`)
      if (!lastSent) return true

      if (item.onlyIfNoneSince) {
        // مرة وحدة لكل دورة: بنبعت بس إذا آخر إشعار كان قبل بداية الدورة
        return lastSent < item.onlyIfNoneSince
      }
      // الباقي: إشعار واحد باليوم — بيمنع التكرار لو الدالة انشغّلت مرتين
      return lastSent.getTime() !== today.getTime()
    })

    if (toSend.length === 0) {
      return jsonResponse({ success: true, processed: 0, failures: [] })
    }

    // ── 5. حفظ الإشعارات بالجدول ──────────────────────────────────
    const { error: insertError } = await supabaseClient
      .from(TABLE_NOTIFICATIONS)
      .insert(
        toSend.map((item) => ({
          trainer_id: item.trainerId,
          subscriber_id: item.subscriberId,
          type: item.type,
          message: item.message,
          is_read: false,
        })),
      )

    if (insertError) throw insertError

    // ── 6. جلب توكنات المدربين مرة وحدة وإرسال الـ push ───────────
    const trainerIds = [...new Set(toSend.map((item) => item.trainerId))]
    const { data: trainersData } = await supabaseClient
      .from(TABLE_TRAINERS)
      .select('id, fcm_token')
      .in('id', trainerIds)

    const tokenByTrainer = new Map<string, string>()
    for (const trainer of (trainersData ?? []) as {
      id: string
      fcm_token: string | null
    }[]) {
      if (trainer.fcm_token) tokenByTrainer.set(trainer.id, trainer.fcm_token)
    }

    let totalProcessed = 0
    for (const item of toSend) {
      const fcmToken = tokenByTrainer.get(item.trainerId)
      if (!fcmToken) {
        failures.push({
          subscriberId: item.subscriberId,
          reason: 'no fcm_token stored for trainer',
        })
        continue
      }

      try {
        await sendFcmNotification(
          accessToken,
          serviceAccount.project_id,
          fcmToken,
          item.title,
          item.message,
          item.subscriberId,
          item.type,
        )
        totalProcessed++
      } catch (sendErr) {
        // توكن ميت لمدرب واحد ما بيوقف الإرسال للباقين
        failures.push({
          subscriberId: item.subscriberId,
          reason: (sendErr as Error).message,
        })
      }
    }

    return jsonResponse({
      success: true,
      processed: totalProcessed,
      saved: toSend.length,
      failures,
    })
  } catch (err) {
    return jsonResponse({ error: (err as Error).message }, 500)
  }
})

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    headers: { 'Content-Type': 'application/json' },
    status,
  })
}

async function sendFcmNotification(
  accessToken: string,
  projectId: string,
  fcmToken: string,
  title: string,
  body: string,
  subscriberId: string,
  type: string,
) {
  const fcmPayload = {
    message: {
      token: fcmToken,
      notification: { title, body },
      data: { subscriberId, type },
    },
  }

  const response = await fetch(
    `${FCM_ENDPOINT}/${projectId}/messages:send`,
    {
      method: 'POST',
      headers: {
        'Authorization': accessToken,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(fcmPayload),
    },
  )

  if (!response.ok) {
    const errorBody = await response.text()
    throw new Error(`FCM rejected the message (${response.status}): ${errorBody}`)
  }
}
