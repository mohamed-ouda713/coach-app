-- supabase/migrations/20250820120000_create_partners_table.sql
-- جدول الشركاء (قسمة الربح) — Feature: Financial (F5)
create table if not exists partners (
  id uuid primary key default gen_random_uuid(),
  trainer_id uuid not null references trainers(id) on delete cascade,
  name text not null,
  share_percentage numeric not null check (share_percentage >= 0 and share_percentage <= 100),
  created_at timestamptz not null default now()
);

alter table partners enable row level security;

create policy "trainers manage own partners"
  on partners
  for all
  using (trainer_id = auth.uid())
  with check (trainer_id = auth.uid());

create index if not exists partners_trainer_id_idx on partners (trainer_id);
create index if not exists expenses_trainer_id_date_idx on expenses (trainer_id, date);