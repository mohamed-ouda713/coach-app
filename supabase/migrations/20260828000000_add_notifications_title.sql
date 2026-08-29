-- Adds the `title` column the edge function computes but currently discards.
--
-- Without it the app falls back to a per-type title, so the push notification
-- and the in-app list show different text for the same event.
--
-- Safe to run on a live database: the column is nullable with no default, so
-- existing rows are untouched and existing inserts keep working.
--
-- AFTER running this, uncomment the `title: item.title,` line in
-- supabase/functions/send-notifications/index.ts and redeploy.

alter table notifications
  add column if not exists title text;

comment on column notifications.title is
  'Notification headline written by send-notifications. Nullable: older rows '
  'predate this column and the app falls back to a per-type title.';
