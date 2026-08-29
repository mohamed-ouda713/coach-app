-- Removes the duplicate test notifications created while verifying the
-- pipeline. Replace the email, then run in Supabase → SQL Editor.
--
-- Deletes ONLY subscription-expiry rows created today for this trainer.
-- Run the SELECT first to see exactly what will go.

-- 1) Preview
select id, subscriber_id, type, message, created_at
from notifications
where trainer_id = (select id from auth.users where email = 'your-email@example.com')
  and type = 'subscription_expiry'
  and created_at::date = current_date
order by created_at;

-- 2) Delete (uncomment once the preview looks right)
-- delete from notifications
-- where trainer_id = (select id from auth.users where email = 'your-email@example.com')
--   and type = 'subscription_expiry'
--   and created_at::date = current_date;
