-- MTG: correct is_inhabited for two islands whose communities have
-- relocated — verified via Wikipedia/press reporting (WebSearch, since
-- direct fetch to en.wikipedia.org is blocked by this environment's
-- egress policy), not from MTG's own legacy content, which never covered
-- either island.
--
-- Kalhaidhoo (Laamu Atoll): the community fled to Gan during the 2004
-- tsunami; the government declared the island permanently uninhabited a
-- week later. Population 0 since.
--
-- Gaadhoo (Laamu Atoll): an active, ongoing government-organized
-- resettlement to Fonadhoo in the same atoll (38+ families already
-- moved, island administration being wound down).
--
-- The original seed migration (20250102000100_seed_maldives_locations.sql,
-- regenerated from the same source data this migration reflects) uses
-- `on conflict do nothing`, so it cannot retroactively correct these two
-- rows on an already-seeded database — this explicit UPDATE is the fix
-- for a live deployment. Idempotent: re-running it after is_inhabited is
-- already false is a no-op.
update locations
set is_inhabited = false
where id in (select id from nodes where node_type = 'location' and slug in ('gaadhoo', 'kalhaidhoo'))
  and is_inhabited is distinct from false;
