import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import JWT from 'https://esm.sh/google-auth-library@9.0.0'

// لازم تطابق NotificationTypeValues بـ lib/core/constants/supabase_constants.dart
const NOTIFICATION_TYPE_SUBSCRIPTION_EXPIRY = 'subscription_expiry'

const TABLE_SUBSCRIBERS = 'subscribers'
const TABLE_TRAINERS = 'trainers'
const TABLE_NOTIFICATIONS = 'notifications'

const FCM_SCOPE = 'https://www.googleapis.com/auth/firebase.messaging'
const FCM_ENDPOINT = 'https://fcm.googleapis.com/v1/projects'

const SUBSCRIPTION_EXPIRY_TITLE = 'تنبيه انتهاء اشتراك ⚠️'
const subscriptionExpiryBody = (name: string) =>
  `اشتراك المشترك ${name} سينتهي غداً.`

Deno.serve(async (req) => {
  try {
    const serviceAccountSecret = Deno.env.get('FCM_SERVICE_ACCOUNT')
    if (!serviceAccountSecret) {
      throw new Error('FCM_SERVICE_ACCOUNT secret is not configured')
    }
    const serviceAccount = JSON.parse(serviceAccountSecret)

    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const client = new JWT.JWT({
      email: serviceAccount.client_email,
      key: serviceAccount.private_key,
      scopes: [FCM_SCOPE],
    })
    const tokens = await client.getRequestHeaders()
    const accessToken = tokens.Authorization

    const today = new Date()
    today.setHours(0, 0, 0, 0)
    let totalProcessed = 0
    const failures: { subscriberId: string; reason: string }[] = []

    // 1. التواريخ: فحص المشتركين الذين ينتهي اشتراكهم غداً
    const tomorrow = new Date(today)
    tomorrow.setDate(tomorrow.getDate() + 1)
    const tomorrowStr = tomorrow.toISOString().split('T')[0]

    // جلب المشتركين المنتهية اشتراكاتهم بدون عمل JOIN لتفادي مشكلة العلاقات
    const { data: expiringSubscribers, error: subError } = await supabaseClient
      .from(TABLE_SUBSCRIBERS)
      .select('id, full_name, subscription_end_date, trainer_id')
      .eq('subscription_end_date', tomorrowStr)

    if (subError) throw subError

    if (expiringSubscribers && expiringSubscribers.length > 0) {
      for (const sub of expiringSubscribers) {
        const msgText = subscriptionExpiryBody(sub.full_name)

        // أ) حفظ الإشعار في جدول notifications
        await supabaseClient.from(TABLE_NOTIFICATIONS).insert({
          trainer_id: sub.trainer_id,
          subscriber_id: sub.id,
          type: NOTIFICATION_TYPE_SUBSCRIPTION_EXPIRY,
          message: msgText,
          is_read: false
        })

        // ب) جلب الـ fcm_token مباشرة من جدول trainers للمدرب المطلوب
        if (sub.trainer_id) {
          const { data: trainer } = await supabaseClient
            .from(TABLE_TRAINERS)
            .select('fcm_token')
            .eq('id', sub.trainer_id)
            .maybeSingle()

          const fcmToken = trainer?.fcm_token

          if (fcmToken) {
            try {
              await sendFcmNotification(
                accessToken,
                serviceAccount.project_id,
                fcmToken,
                SUBSCRIPTION_EXPIRY_TITLE,
                msgText,
                String(sub.id)
              )
              totalProcessed++
            } catch (sendErr: any) {
              // توكن ميت لمدرب واحد ما بيوقف الإرسال للباقين
              failures.push({ subscriberId: String(sub.id), reason: sendErr.message })
            }
          } else {
            failures.push({ subscriberId: String(sub.id), reason: 'no fcm_token stored for trainer' })
          }
        }
      }
    }

    return new Response(JSON.stringify({ success: true, processed: totalProcessed, failures }), {
      headers: { 'Content-Type': 'application/json' },
      status: 200,
    })

  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), {
      headers: { 'Content-Type': 'application/json' },
      status: 500,
    })
  }
})

async function sendFcmNotification(
  accessToken: string,
  projectId: string,
  fcmToken: string,
  title: string,
  body: string,
  subscriberId: string
) {
  const fcmPayload = {
    message: {
      token: fcmToken,
      notification: { title, body },
      data: { subscriberId },
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
    }
  )

  if (!response.ok) {
    const errorBody = await response.text()
    throw new Error(`FCM rejected the message (${response.status}): ${errorBody}`)
  }
}