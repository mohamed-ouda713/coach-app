import { assertEquals } from 'https://deno.land/std@0.224.0/assert/mod.ts'
import {
  currentCycleDueDate,
  daysBetween,
  measurementDueDate,
  toUtcDay,
} from './date_utils.ts'

const day = (iso: string) => toUtcDay(iso)
const REMINDER_DAYS = [1, 3]

/// هل بينبعت تذكير تأخير بهاد اليوم؟ (نفس شرط الدالة الأصلية)
function remindsOn(startIso: string, todayIso: string): boolean {
  const start = day(startIso)
  const today = day(todayIso)
  const due = currentCycleDueDate(start, today)
  return REMINDER_DAYS.includes(daysBetween(due, today))
}

Deno.test('measurementDueDate clamps to the last day of short months', () => {
  const start = day('2025-01-31')
  assertEquals(measurementDueDate(start, 2026, 1), day('2026-02-28'))
  assertEquals(measurementDueDate(start, 2026, 3), day('2026-04-30'))
  assertEquals(measurementDueDate(start, 2026, 0), day('2026-01-31'))
})

Deno.test('currentCycleDueDate returns the last due date that has passed', () => {
  const start = day('2025-01-31')

  // آخر الشهر: الموعد هو نفس اليوم
  assertEquals(currentCycleDueDate(start, day('2026-04-30')), day('2026-04-30'))

  // أول الشهر اللي بعده: الدورة المفتوحة لسا تبعت الشهر السابق
  assertEquals(currentCycleDueDate(start, day('2026-05-01')), day('2026-04-30'))
  assertEquals(currentCycleDueDate(start, day('2026-05-03')), day('2026-04-30'))

  // بعد ما يوصل موعد الشهر الجديد بينتقل عليه
  assertEquals(currentCycleDueDate(start, day('2026-05-31')), day('2026-05-31'))
})

Deno.test('cycle rolls back across the year boundary', () => {
  const start = day('2025-01-31')
  assertEquals(currentCycleDueDate(start, day('2027-01-02')), day('2026-12-31'))
})

Deno.test('a subscription starting on the 31st still gets reminders', () => {
  // الانحدار: قبل الإصلاح كان الموعد بينحسب من شهر اليوم، فبأول أيام
  // الشهر الجديد بيطلع بالمستقبل و daysOverdue بالسالب — صفر تذكير أبدًا.
  assertEquals(remindsOn('2025-01-31', '2026-05-01'), true)
  assertEquals(remindsOn('2025-01-31', '2026-05-03'), true)
  assertEquals(remindsOn('2025-01-31', '2026-05-02'), false)
  assertEquals(remindsOn('2025-01-31', '2026-04-30'), false)
})

Deno.test('every start day gets exactly two reminders per cycle', () => {
  for (const startDay of [1, 5, 15, 28, 29, 30, 31]) {
    const start = day(`2025-01-${String(startDay).padStart(2, '0')}`)
    let hits = 0
    for (let d = day('2026-02-01'); d < day('2026-12-01');) {
      const due = currentCycleDueDate(start, d)
      if (REMINDER_DAYS.includes(daysBetween(due, d))) hits++
      d = new Date(d.getTime() + 86_400_000)
    }
    // ١٠ شهور × تذكيرين
    assertEquals(hits, 20, `start day ${startDay} should get 2 per cycle`)
  }
})

Deno.test('subscription expiry fires exactly one day before', () => {
  const today = day('2026-08-28')
  assertEquals(daysBetween(today, day('2026-08-29')), 1)
  assertEquals(daysBetween(today, day('2026-08-30')), 2)
  assertEquals(daysBetween(today, day('2026-08-28')), 0)
})
