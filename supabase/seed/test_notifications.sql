-- ═══════════════════════════════════════════════════════════════════
-- بيانات اختبار لتبويب الإشعارات
--
-- شغّليها من Supabase Dashboard → SQL Editor.
-- بتنشئ إشعار من كل نوع بتبعته الـ edge function، عشان تتأكدي إنّ
-- القائمة والعناوين والتواريخ وعدّاد غير المقروء كلهم شغّالين.
--
-- الأعمدة هون لازم تطابق يلي بتكتبه
-- supabase/functions/send-notifications/index.ts
-- ═══════════════════════════════════════════════════════════════════

-- 1) بدّلي البريد ببريد حسابك بالتطبيق
with me as (
  select id from auth.users where email = 'ضعي-بريدك-هنا@example.com'
),
-- 2) بناخد أحدث عميل (إن وُجد) عشان الضغط على الإشعار يفتح ملفه.
--    لو ما في عملاء، بينحفظ الإشعار بدون ربط والضغط بيفتح التطبيق بس.
newest_client as (
  select id, full_name
  from subscribers
  where trainer_id = (select id from me)
  order by created_at desc
  limit 1
)
insert into notifications
  (trainer_id, subscriber_id, type, title, message, is_read, created_at)
select
  (select id from me),
  (select id from newest_client),
  t.type,
  t.title,
  replace(t.message, '{name}',
          coalesce((select full_name from newest_client), 'العميل')),
  t.is_read,
  t.created_at
from (values
  ('subscription_expiry',
   'تنبيه انتهاء اشتراك ⚠️',
   'اشتراك المشترك {name} سينتهي غداً.',
   false, now()),

  ('overdue_measurement',
   'قياسات متأخرة 📏',
   'لم يتم تسجيل قياسات {name} لهذا الشهر — تأخرت 3 أيام.',
   false, now() - interval '3 hours'),

  ('new_program_needed',
   'برنامج تدريبي جديد 🏋️',
   'مر 28 يوم على برنامج {name} التدريبي — يحتاج مراجعة خطة جديدة.',
   false, now() - interval '1 day'),

  -- واحد مقروء عشان نتأكد إنّ عدّاد غير المقروء بيستثنيه
  ('progress_update',
   'تقدّم ممتاز 🎉',
   '{name}: تقدم ممتاز هذا الشهر',
   true, now() - interval '4 days'),

  -- بلا عنوان وبلا نوع: بيفحص العنوان الاحتياطي بالتطبيق
  (null, null, 'إشعار بدون عنوان — لفحص القيمة الاحتياطية', false, now() - interval '8 days')
) as t(type, title, message, is_read, created_at);


-- ═══════════════════════════════════════════════════════════════════
-- للتنظيف بعد الفحص (بيمسح بيانات الاختبار بس)
-- ═══════════════════════════════════════════════════════════════════
-- delete from notifications
-- where trainer_id = (select id from auth.users
--                     where email = 'ضعي-بريدك-هنا@example.com')
--   and (title in ('تنبيه انتهاء اشتراك ⚠️', 'قياسات متأخرة 📏',
--                  'برنامج تدريبي جديد 🏋️', 'تقدّم ممتاز 🎉')
--        or message = 'إشعار بدون عنوان — لفحص القيمة الاحتياطية');
