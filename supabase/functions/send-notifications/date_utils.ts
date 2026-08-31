/// دوال التواريخ النقية — بملف منفصل عشان الاختبارات تقدر تستوردها
/// بدون ما تشغّل `Deno.serve` الموجود بـ index.ts.

const MS_PER_DAY = 86_400_000

/// بترجع تاريخ (UTC) بدون وقت — عشان كل المقارنات تصير على مستوى اليوم.
export function toUtcDay(value: string | Date): Date {
  const date = typeof value === 'string' ? new Date(value) : value
  return new Date(
    Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()),
  )
}

export function isoDate(date: Date): string {
  return date.toISOString().split('T')[0]
}

export function daysBetween(from: Date, to: Date): number {
  return Math.floor((to.getTime() - from.getTime()) / MS_PER_DAY)
}

/// موعد القياس المفروض لهاد الشهر = نفس يوم بدء الاشتراك، ومحدود بآخر
/// يوم بالشهر (اشتراك بدأ يوم 31 وشهر فيه 30 يوم → الموعد يوم 30).
export function measurementDueDate(
  subscriptionStart: Date,
  year: number,
  month: number,
): Date {
  const startDay = subscriptionStart.getUTCDate()
  const lastDayOfMonth = new Date(Date.UTC(year, month + 1, 0)).getUTCDate()
  return new Date(Date.UTC(year, month, Math.min(startDay, lastDayOfMonth)))
}

/// آخر موعد قياس استحق فعليًا (اليوم أو قبله) — وهو "الدورة الحالية".
///
/// ما بنحسبه من شهر اليوم مباشرة: اشتراك بلّش يوم 31 موعده آخر الشهر،
/// والتذكير المفروض ينبعت أول وتالت يوم بالشهر اللي بعده. بس بهديك
/// اللحظة شهر اليوم بيكون تغيّر، فحساب الموعد من شهر اليوم بيعطي موعد
/// بالمستقبل و`daysOverdue` بتطلع بالسالب — والتذكير ما بينبعت أبدًا.
/// النتيجة كانت: أي مشترك بلّش يوم 29 أو 30 أو 31 ما بيوصله تذكير
/// تأخير (يوم 31 = صفر تذكير بالسنة كلها).
export function currentCycleDueDate(subscriptionStart: Date, today: Date): Date {
  const thisMonth = measurementDueDate(
    subscriptionStart,
    today.getUTCFullYear(),
    today.getUTCMonth(),
  )
  if (thisMonth.getTime() <= today.getTime()) return thisMonth

  // موعد هالشهر لسا ما إجا — يعني الدورة المفتوحة هي تبعت الشهر السابق.
  // Date.UTC بيتعامل مع month = -1 كديسمبر السنة اللي قبل تلقائيًا.
  return measurementDueDate(
    subscriptionStart,
    today.getUTCFullYear(),
    today.getUTCMonth() - 1,
  )
}
