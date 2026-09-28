-- Supabase notice (Oct 30 cutoff): from that date, Supabase stops
-- auto-granting Data API (PostgREST) access to new tables in the public
-- schema. Existing tables keep their current grants forever -- nothing
-- breaks on the live project today. But every table this project has ever
-- created was created relying on that auto-grant; none of the 35
-- migrations that `create table` in this schema ever issued an explicit
-- GRANT. That means replaying this migration history on any NEW Supabase
-- project after Oct 30 -- a fresh disaster-recovery project, a preview
-- branch, anything created from `supabase db reset` -- would leave every
-- one of those tables unreachable through supabase-js/PostgREST, with no
-- code-level symptom until the first query 403s.
--
-- Fixes it two ways:
--   1. Explicit grants on every table that exists today, so a full replay
--      is safe regardless of when it runs.
--   2. ALTER DEFAULT PRIVILEGES, so any table a *future* migration creates
--      gets these same grants automatically -- removing the need to
--      remember to add a GRANT block to every future create-table
--      migration by hand.
--
-- Privilege shape mirrors exactly what Supabase auto-grants today and
-- what this schema's RLS policies (20250101001400_rls_policies.sql
-- onward) already assume: anon is read-only at the table level (every
-- anon write goes through a SECURITY DEFINER RPC like
-- create_booking_inquiry/submit_review, already granted separately in
-- 20250101001300_functions_triggers.sql); authenticated/service_role get
-- the full set, with RLS -- not this GRANT -- doing the actual per-row
-- enforcement, same as it does today.

grant usage on schema public to anon, authenticated, service_role;

grant select on all tables in schema public to anon;
grant select, insert, update, delete on all tables in schema public to authenticated;
grant select, insert, update, delete on all tables in schema public to service_role;

grant usage, select on all sequences in schema public to anon, authenticated, service_role;

alter default privileges in schema public
  grant select on tables to anon;
alter default privileges in schema public
  grant select, insert, update, delete on tables to authenticated;
alter default privileges in schema public
  grant select, insert, update, delete on tables to service_role;
alter default privileges in schema public
  grant usage, select on sequences to anon, authenticated, service_role;
