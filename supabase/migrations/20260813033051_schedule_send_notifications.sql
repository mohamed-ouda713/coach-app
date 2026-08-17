create extension if not exists pg_cron;
create extension if not exists pg_net;

-- الرابط مكتوب ثابت لأنه مربوط بمرجع المشروع (project ref)، وما في إعداد
-- قياسي بسوبابيز يعطينا إياه من جوا SQL. لو انعمل مشروع staging، لازم
-- يتعدّل هون.
-- cron.schedule بتعمل upsert على الاسم، فإعادة التشغيل بتحدّث نفس المهمة
-- ولا بتنشئ وحدة تانية تبعت إشعارات مكررة.
select cron.schedule(
  'send-daily-notifications',
  '0 9 * * *',
  $$
  select net.http_post(
    url := 'https://lsscqfxaultbslaozklw.supabase.co/functions/v1/send-notifications',
    headers := '{"Content-Type": "application/json"}'::jsonb
  ) as request_id;
  $$
);
