-- Bootstrap-admin fix: prevent_profile_role_self_escalation() (from
-- 20250101001300_functions_triggers.sql) blocked ANY profiles.role change
-- unless the request already came from a logged-in admin — but
-- scripts/bootstrap-admin.mjs (the only legitimate way to create MTG's
-- very first admin) deliberately runs with no logged-in user at all, using
-- the service-role key instead. That's a genuine chicken-and-egg case the
-- original trigger never accounted for, so it also blocked the one
-- operation it exists specifically to enable.
--
-- Fix: also allow the change when the request's JWT role is
-- 'service_role'. This is safe to add — RLS already restricts who can
-- reach this trigger at all (profiles_self_update requires auth.uid() =
-- id; profiles_admin_all requires an existing admin), so the only way a
-- request with no auth.uid() at all (which is what a bare service_role
-- check without an is_admin() match implies) ever reaches this trigger is
-- the service-role key bypassing RLS entirely — i.e. a trusted
-- operational script, never an anonymous end-user request.
create or replace function prevent_profile_role_self_escalation() returns trigger as $$
begin
  if new.role is distinct from old.role and auth.role() is distinct from 'service_role' and not is_admin() then
    raise exception 'only an admin may change profiles.role';
  end if;
  return new;
end;
$$ language plpgsql set search_path = public, pg_temp;
