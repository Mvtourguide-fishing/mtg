-- Supabase Advisor CRITICAL security findings: accommodation_rooms and
-- accommodation_room_media (added in 20250123000100_stays_ecosystem_schema.sql)
-- were never given RLS policies, so with the table owner's default grants
-- they were readable AND writable by anyone using the public anon key --
-- the same key that ships in every page's JS bundle. Fixes the gap using
-- the exact pattern every other node-child table in this schema already
-- follows (see 20250101001400_rls_policies.sql): public read gated on the
-- parent node's published status, staff-only write.

alter table accommodation_rooms enable row level security;
create policy accommodation_rooms_public_read on accommodation_rooms for select
  using (exists (select 1 from nodes n where n.id = accommodation_rooms.accommodation_id and n.status = 'published'));
create policy accommodation_rooms_staff_all on accommodation_rooms for all
  using (is_staff()) with check (is_staff());

-- accommodation_room_media has no direct FK to accommodations/nodes -- it's
-- one hop further out (room_id -> accommodation_rooms -> accommodation_id ->
-- nodes), so the gate joins through accommodation_rooms rather than the
-- single `exists` used for a direct node child.
alter table accommodation_room_media enable row level security;
create policy accommodation_room_media_public_read on accommodation_room_media for select
  using (exists (
    select 1 from accommodation_rooms r
    join nodes n on n.id = r.accommodation_id
    where r.id = accommodation_room_media.room_id and n.status = 'published'
  ));
create policy accommodation_room_media_staff_all on accommodation_room_media for all
  using (is_staff()) with check (is_staff());
