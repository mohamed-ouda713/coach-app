-- ═══════════════════════════════════════════════════════════════════
-- تشخيص: ليش تبويب الإشعارات فاضي؟
-- شغّليها من Supabase → SQL Editor بعد ما تبدّلي البريد.
-- ═══════════════════════════════════════════════════════════════════

with me as (
  select id from auth.users where email = 'ضعي-بريدك-هنا@example.com'
)

-- ١) في عملاء أصلاً؟ ولو في، إيمتى بينستحق أول إشعار لكل واحد؟
select
  'العملاء وموعد أول إشعار' as "الفحص",
  s.full_name                as "العميل",
  s.subscription_end_date    as "ينتهي",
  (s.subscription_end_date - interval '1 day')::date
                             as "إشعار الانتهاء",
  (s.subscription_start_date + interval '28 days')::date
                             as "إشعار البرنامج الجديد",
  case
    when exists (
      select 1 from measurements m
      where m.subscriber_id = s.id
        and date_trunc('month', m.measurement_month) = date_trunc('month', now())
    ) then 'مسجّل — ما في تذكير قياس'
    else 'ناقص — ممكن ينبعت تذكير'
  end                        as "قياس هذا الشهر"
from subscribers s
where s.trainer_id = (select id from me)
order by s.created_at desc;


-- ٢) في إشعارات محفوظة؟
-- select count(*) as "عدد الإشعارات"
-- from notifications where trainer_id = (select id from auth.users
--                                        where email = 'ضعي-بريدك-هنا@example.com');


-- ٣) عمود title موجود؟ (الـ edge function صارت تكتبه — لو ناقص الإدخال بيفشل كله)
-- select column_name, data_type
-- from information_schema.columns
-- where table_name = 'notifications'
-- order by ordinal_position;


-- ٤) توكن الإشعارات محفوظ للمدرب؟ (بدونه بينحفظ الإشعار بالجدول
--    بس الـ push ما بيوصل — الدالة بتسجّل "no fcm_token stored for trainer")
-- select id, email, (fcm_token is not null) as "عنده توكن"
-- from trainers where id = (select id from auth.users
--                           where email = 'ضعي-بريدك-هنا@example.com');
