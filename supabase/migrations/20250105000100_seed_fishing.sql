-- MTG: fishing vertical seed (Task 7).
-- GENERATED FILE — do not hand-edit. Source of truth:
--   data/maldives/fishing/activities.json
--   data/maldives/fishing/fishing_spots.json (currently empty — see SOURCES.md)
--   data/maldives/fishing/SOURCES.md
-- Regenerate with: node scripts/generate-fishing-seed.mjs
--
-- Idempotent (ON CONFLICT DO NOTHING, keyed by slug). Fishing activities use
-- the same `activities` table as every other activity (activity_category =
-- 'fishing') — no new tables. Fishing *type* is a categories/node_categories
-- tag (category_group = 'activity-type'), not a column, matching Task 7 §2.
-- Providers are reused from Task 5/6 by exact name match where they apply
-- (harmless no-op insert against the existing row); no new locations are
-- created — every activity resolves to an island already seeded by Task 4/5.

-- No fishing-specific site/ground locations seeded: no individually-named,
-- multiply-cited fishing ground was found (see SOURCES.md). Fishing
-- activities are geographically anchored to their departure island instead,
-- which the existing location architecture already supports.

-- Fishing-type taxonomy (category_group = 'activity-type') — only the types
-- actually used by a sourced activity below are seeded.
insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'handline-fishing', 'Handline Fishing', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'handline_fishing'::ltree from nodes where node_type = 'category' and slug = 'handline-fishing'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'sport-fishing', 'Sport Fishing', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'sport_fishing'::ltree from nodes where node_type = 'category' and slug = 'sport-fishing'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'night-fishing', 'Night Fishing', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'night_fishing'::ltree from nodes where node_type = 'category' and slug = 'night-fishing'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'big-game-fishing', 'Big Game Fishing', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'big_game_fishing'::ltree from nodes where node_type = 'category' and slug = 'big-game-fishing'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'reef-fishing', 'Reef Fishing', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'reef_fishing'::ltree from nodes where node_type = 'category' and slug = 'reef-fishing'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'traditional-fishing', 'Traditional Fishing', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'traditional_fishing'::ltree from nodes where node_type = 'category' and slug = 'traditional-fishing'
on conflict (id) do nothing;

-- Providers (reused from Task 5/6 where the name matches exactly, else new)
insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'active-watersports-maafushi', 'Active Watersports Maafushi', 'Active Watersports Maafushi operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'active-watersports-maafushi'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'kaani-hotels', 'Kaani Hotels', 'Kaani Hotels operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'kaani-hotels'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'icom-tours', 'iCom Tours', 'iCom Tours operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'icom-tours'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'knight-at-sea', 'Knight At Sea', 'Knight At Sea operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'knight-at-sea'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'universal-resorts', 'Universal Resorts', 'Universal Resorts operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'universal-resorts'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'soneva-management-bvi-limited', 'Soneva Management (BVI) Limited', 'Soneva Management (BVI) Limited operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'soneva-management-bvi-limited'
on conflict (id) do nothing;

-- Fishing activities
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'sunset-fishing-trip', 'Sunset Fishing Trip', 'Sunset Fishing Trip is a handline fishing trip on Maafushi, Kaafu Atoll. Duration: 180 minutes. It is operated by Active Watersports Maafushi.', 'published', 'Sunset Fishing Trip | Maldives Fishing | MTG', 'Sunset Fishing Trip is a handline fishing trip on Maafushi, Kaafu Atoll. Duration: 180 minutes. It is operated by Active Watersports Maafushi.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, price_from, max_participants
)
select
  n.id, 'fishing',
  (select id from nodes where node_type = 'provider' and slug = 'active-watersports-maafushi'),
  180, 30, null
from nodes n where n.node_type = 'activity' and n.slug = 'sunset-fishing-trip'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'sunset-fishing-trip'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'sunset-fishing-trip'
  and c.node_type = 'category' and c.slug = 'handline-fishing'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'sunset-fishing-trip'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'private-sport-fishing-trip', 'Private Sport Fishing Trip', 'Private Sport Fishing Trip is a sport fishing trip on Maafushi, Kaafu Atoll. It is operated by Active Watersports Maafushi.', 'published', 'Private Sport Fishing Trip | Maldives Fishing | MTG', 'Private Sport Fishing Trip is a sport fishing trip on Maafushi, Kaafu Atoll. It is operated by Active Watersports Maafushi.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, price_from, max_participants
)
select
  n.id, 'fishing',
  (select id from nodes where node_type = 'provider' and slug = 'active-watersports-maafushi'),
  null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'private-sport-fishing-trip'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'private-sport-fishing-trip'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'private-sport-fishing-trip'
  and c.node_type = 'category' and c.slug = 'sport-fishing'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'private-sport-fishing-trip'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'sunset-fishing-trip-maafushi', 'Sunset Fishing Trip', 'Sunset Fishing Trip is a fishing trip on Maafushi, Kaafu Atoll. It is operated by Kaani Hotels.', 'published', 'Sunset Fishing Trip | Maldives Fishing | MTG', 'Sunset Fishing Trip is a fishing trip on Maafushi, Kaafu Atoll. It is operated by Kaani Hotels.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, price_from, max_participants
)
select
  n.id, 'fishing',
  (select id from nodes where node_type = 'provider' and slug = 'kaani-hotels'),
  null, 25, null
from nodes n where n.node_type = 'activity' and n.slug = 'sunset-fishing-trip-maafushi'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'sunset-fishing-trip-maafushi'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'sunset-fishing-trip-maafushi'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'night-fishing-trip', 'Night Fishing Trip', 'Night Fishing Trip is a night fishing trip on Maafushi, Kaafu Atoll. It is operated by iCom Tours.', 'published', 'Night Fishing Trip | Maldives Fishing | MTG', 'Night Fishing Trip is a night fishing trip on Maafushi, Kaafu Atoll. It is operated by iCom Tours.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, price_from, max_participants
)
select
  n.id, 'fishing',
  (select id from nodes where node_type = 'provider' and slug = 'icom-tours'),
  null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'night-fishing-trip'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'night-fishing-trip'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'night-fishing-trip'
  and c.node_type = 'category' and c.slug = 'night-fishing'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'night-fishing-trip'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'marlin-big-game-fishing-charter', 'Marlin & Big Game Fishing Charter', 'Marlin & Big Game Fishing Charter is a big game fishing trip on Hulhumalé, Malé City. It is operated by Knight At Sea.', 'published', 'Marlin & Big Game Fishing Charter | Maldives Fishing | MTG', 'Marlin & Big Game Fishing Charter is a big game fishing trip on Hulhumalé, Malé City. It is operated by Knight At Sea.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, price_from, max_participants
)
select
  n.id, 'fishing',
  (select id from nodes where node_type = 'provider' and slug = 'knight-at-sea'),
  null, null, 4
from nodes n where n.node_type = 'activity' and n.slug = 'marlin-big-game-fishing-charter'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'marlin-big-game-fishing-charter'
  and l.node_type = 'location' and l.slug = 'hulhumale'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'marlin-big-game-fishing-charter'
  and c.node_type = 'category' and c.slug = 'big-game-fishing'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'marlin-big-game-fishing-charter'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'sunset-reef-fishing', 'Sunset Reef Fishing', 'Sunset Reef Fishing is a reef fishing trip on Vihamanaafushi, Kaafu Atoll. It is operated by Universal Resorts.', 'published', 'Sunset Reef Fishing | Maldives Fishing | MTG', 'Sunset Reef Fishing is a reef fishing trip on Vihamanaafushi, Kaafu Atoll. It is operated by Universal Resorts.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, price_from, max_participants
)
select
  n.id, 'fishing',
  (select id from nodes where node_type = 'provider' and slug = 'universal-resorts'),
  null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'sunset-reef-fishing'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'sunset-reef-fishing'
  and l.node_type = 'location' and l.slug = 'vihamanaafushi'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'sunset-reef-fishing'
  and c.node_type = 'category' and c.slug = 'reef-fishing'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'sunset-reef-fishing'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'big-game-fishing-trip', 'Big Game Fishing Trip', 'Big Game Fishing Trip is a big game fishing trip on Velassaru, Kaafu Atoll. Duration: 240 minutes. It is operated by Universal Resorts.', 'published', 'Big Game Fishing Trip | Maldives Fishing | MTG', 'Big Game Fishing Trip is a big game fishing trip on Velassaru, Kaafu Atoll. Duration: 240 minutes. It is operated by Universal Resorts.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, price_from, max_participants
)
select
  n.id, 'fishing',
  (select id from nodes where node_type = 'provider' and slug = 'universal-resorts'),
  240, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'big-game-fishing-trip'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'big-game-fishing-trip'
  and l.node_type = 'location' and l.slug = 'velassaru'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'big-game-fishing-trip'
  and c.node_type = 'category' and c.slug = 'big-game-fishing'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'big-game-fishing-trip'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'big-game-fishing-trip-lankanfushi', 'Big Game Fishing Trip', 'Big Game Fishing Trip is a big game fishing trip on Lankanfushi, Kaafu Atoll.', 'published', 'Big Game Fishing Trip | Maldives Fishing | MTG', 'Big Game Fishing Trip is a big game fishing trip on Lankanfushi, Kaafu Atoll.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, price_from, max_participants
)
select
  n.id, 'fishing',
  null,
  null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'big-game-fishing-trip-lankanfushi'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'big-game-fishing-trip-lankanfushi'
  and l.node_type = 'location' and l.slug = 'lankanfushi'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'big-game-fishing-trip-lankanfushi'
  and c.node_type = 'category' and c.slug = 'big-game-fishing'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'big-game-fishing-trip-lankanfushi'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'fishing-is-a-family-matter', 'Fishing is a Family Matter', 'Fishing is a Family Matter is a traditional fishing trip on Kunfunadhoo, Baa Atoll. It is operated by Soneva Management (BVI) Limited.', 'published', 'Fishing is a Family Matter | Maldives Fishing | MTG', 'Fishing is a Family Matter is a traditional fishing trip on Kunfunadhoo, Baa Atoll. It is operated by Soneva Management (BVI) Limited.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, price_from, max_participants
)
select
  n.id, 'fishing',
  (select id from nodes where node_type = 'provider' and slug = 'soneva-management-bvi-limited'),
  null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'fishing-is-a-family-matter'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'fishing-is-a-family-matter'
  and l.node_type = 'location' and l.slug = 'kunfunadhoo'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'fishing-is-a-family-matter'
  and c.node_type = 'category' and c.slug = 'traditional-fishing'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'fishing-is-a-family-matter'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'golden-reel-adventure', 'Golden Reel Adventure', 'Golden Reel Adventure is a fishing trip on Baros, Kaafu Atoll.', 'published', 'Golden Reel Adventure | Maldives Fishing | MTG', 'Golden Reel Adventure is a fishing trip on Baros, Kaafu Atoll.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, price_from, max_participants
)
select
  n.id, 'fishing',
  null,
  null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'golden-reel-adventure'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'golden-reel-adventure'
  and l.node_type = 'location' and l.slug = 'baros'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'golden-reel-adventure'
on conflict (id) do nothing;

