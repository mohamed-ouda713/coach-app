create extension if not exists pg_cron;
create extension if not exists pg_net;

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
