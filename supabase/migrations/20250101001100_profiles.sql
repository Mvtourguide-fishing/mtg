-- MTG foundation: user profiles. Identity stays in auth.users; profiles
-- carries only public/app-specific fields plus the role used by RLS.

create table profiles (
  id             uuid primary key references auth.users(id) on delete cascade,
  display_name   text,
  avatar_url     text,
  bio            text,
  home_country   text,
  role           text not null default 'user' check (role in ('user','editor','admin')),
  created_at     timestamptz not null default now()
);
-- Self-escalation guard (profiles.role) is added in the functions/triggers
-- migration, alongside the is_staff()/is_admin() RLS helpers.
