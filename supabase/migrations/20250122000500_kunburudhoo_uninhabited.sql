-- MTG: correct is_inhabited for Kunburudhoo (Haa Dhaalu Atoll) — found
-- while researching the remaining no-legacy-content islands. Population
-- reached 0 by the 2014 census; residents relocated to Nolhivaranfaru
-- under the government's 2009 consolidation program, driven partly by
-- severe coastal erosion (verified via Wikipedia/press reporting).
--
-- Same rationale/mechanism as 20250122000300_mark_relocated_islands_uninhabited.sql
-- for Kalhaidhoo/Gaadhoo: the idempotent seed migration uses
-- `on conflict do nothing` and cannot retroactively fix an already-seeded
-- row, so this explicit UPDATE is the actual fix for a live deployment.
-- Distinct from Kunburudhoo in Alif Dhaalu Atoll, a different island
-- which remains genuinely inhabited and unaffected by this migration.
update locations
set is_inhabited = false
where id in (
  select l.id from locations l
  join nodes n on n.id = l.id
  where n.node_type = 'location' and n.slug = 'kunburudhoo' and l.location_type = 'island'
)
and is_inhabited is distinct from false;
