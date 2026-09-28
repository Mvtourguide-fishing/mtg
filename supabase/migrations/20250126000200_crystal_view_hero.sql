-- Manual fix: "Crystal View Maldives Guest House" (seeded in Task 5's
-- original 14-property batch, 20250103000100_seed_accommodations.sql) is
-- the same real property as "Crystal Beach" (owner-confirmed) — the
-- legacy scrape's Crystal Beach images were deliberately left unlinked
-- by the later 148-property seed pass because 3 different real
-- guesthouses share that name and it couldn't be resolved automatically
-- (see 20250123000200_seed_stays_properties.sql's header comment). The
-- media_assets rows already exist from the full legacy image library;
-- this just adds the missing node_media link, reusing the existing
-- media_asset id rather than creating a duplicate.
insert into node_media (node_id, media_id, role, sort_order)
select id, 'b9293402-7aa5-a1b7-4e61-0fe0462f99ba', 'hero', 0
from nodes
where node_type = 'accommodation' and slug = 'crystal-view-maldives-guest-house'
on conflict (node_id, media_id, role) do nothing;
