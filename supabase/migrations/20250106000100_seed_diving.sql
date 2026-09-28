-- MTG: diving vertical seed (Task 8).
-- GENERATED FILE — do not hand-edit. Source of truth:
--   data/maldives/diving/activities.json
--   data/maldives/diving/dive_sites.json
--   data/maldives/diving/SOURCES.md
-- Regenerate with: node scripts/generate-diving-seed.mjs
--
-- Idempotent (ON CONFLICT DO NOTHING, keyed by slug). Diving activities use
-- the same `activities` table as every other activity (activity_category =
-- 'diving'); diving TYPE is a categories/node_categories tag (category_group =
-- 'activity-type'), not a column, matching Task 7 §2. Dive SITES are physical
-- locations (location_type = 'dive_site', parented under their atoll) — they
-- are never activities and never get a bookable_products row. Providers are
-- reused from Task 5/6/7 by exact name match where they apply (harmless no-op
-- insert against the existing row).

-- Diving-type taxonomy (category_group = 'activity-type') — only the types
-- actually used by a sourced activity below (new or pre-existing) are seeded.
insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'fun-diving', 'Fun Diving', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'fun_diving'::ltree from nodes where node_type = 'category' and slug = 'fun-diving'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'dive-courses', 'Dive Courses', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'dive_courses'::ltree from nodes where node_type = 'category' and slug = 'dive-courses'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'discover-scuba-diving', 'Discover Scuba Diving', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'discover_scuba_diving'::ltree from nodes where node_type = 'category' and slug = 'discover-scuba-diving'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'night-diving', 'Night Diving', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'night_diving'::ltree from nodes where node_type = 'category' and slug = 'night-diving'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'reef-diving', 'Reef Diving', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'reef_diving'::ltree from nodes where node_type = 'category' and slug = 'reef-diving'
on conflict (id) do nothing;

-- Providers (reused from Task 5/6/7 where the name matches exactly, else new)
insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'maafushi-dive-and-water-sports', 'Maafushi Dive and Water Sports', 'Maafushi Dive and Water Sports operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'maafushi-dive-and-water-sports'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'divers-baros-maldives', 'Divers Baros Maldives', 'Divers Baros Maldives operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'divers-baros-maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'soleni-dive-center', 'Soleni Dive Center', 'Soleni Dive Center operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'soleni-dive-center'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'deep-blue-divers', 'Deep Blue Divers', 'Deep Blue Divers operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'deep-blue-divers'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'immersion-dive-centre', 'Immersion Dive Centre', 'Immersion Dive Centre operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'immersion-dive-centre'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'sea-star-diving', 'Sea Star Diving', 'Sea Star Diving operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'sea-star-diving'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'feenaa-diving-thulusdhoo', 'Feenaa Diving Thulusdhoo', 'Feenaa Diving Thulusdhoo operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'feenaa-diving-thulusdhoo'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'euro-divers-kurumba', 'Euro-Divers Kurumba', 'Euro-Divers Kurumba operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'euro-divers-kurumba'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'ocean-paradise-dive-centre', 'Ocean Paradise Dive Centre', 'Ocean Paradise Dive Centre operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'ocean-paradise-dive-centre'
on conflict (id) do nothing;

-- Diving activities
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'fun-dive-single-tank', 'Fun Dive (Single Tank)', 'Fun Dive (Single Tank) is a fun diving activity on Maafushi, Kaafu Atoll. It is operated by Maafushi Dive and Water Sports.', 'published', 'Fun Dive (Single Tank) | Maldives Diving | MTG', 'Fun Dive (Single Tank) is a fun diving activity on Maafushi, Kaafu Atoll. It is operated by Maafushi Dive and Water Sports.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'maafushi-dive-and-water-sports'),
  null, null, null, 50, null
from nodes n where n.node_type = 'activity' and n.slug = 'fun-dive-single-tank'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'fun-dive-single-tank'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'fun-dive-single-tank'
  and c.node_type = 'category' and c.slug = 'fun-diving'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'fun-dive-single-tank'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'advanced-open-water-diver-course', 'Advanced Open Water Diver Course', 'Advanced Open Water Diver Course is a dive courses activity on Maafushi, Kaafu Atoll. It is operated by Maafushi Dive and Water Sports.', 'published', 'Advanced Open Water Diver Course | Maldives Diving | MTG', 'Advanced Open Water Diver Course is a dive courses activity on Maafushi, Kaafu Atoll. It is operated by Maafushi Dive and Water Sports.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'maafushi-dive-and-water-sports'),
  null, null, null, 400, null
from nodes n where n.node_type = 'activity' and n.slug = 'advanced-open-water-diver-course'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'advanced-open-water-diver-course'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'advanced-open-water-diver-course'
  and c.node_type = 'category' and c.slug = 'dive-courses'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'advanced-open-water-diver-course'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'night-diver-specialty-course', 'Night Diver Specialty Course', 'Night Diver Specialty Course is a dive courses activity on Maafushi, Kaafu Atoll. It is operated by Maafushi Dive and Water Sports.', 'published', 'Night Diver Specialty Course | Maldives Diving | MTG', 'Night Diver Specialty Course is a dive courses activity on Maafushi, Kaafu Atoll. It is operated by Maafushi Dive and Water Sports.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'maafushi-dive-and-water-sports'),
  null, 12, null, 330, null
from nodes n where n.node_type = 'activity' and n.slug = 'night-diver-specialty-course'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'night-diver-specialty-course'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'night-diver-specialty-course'
  and c.node_type = 'category' and c.slug = 'dive-courses'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'night-diver-specialty-course'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'discover-scuba-diving', 'Discover Scuba Diving', 'Discover Scuba Diving is a discover scuba diving activity on Baros, Kaafu Atoll. It is operated by Divers Baros Maldives.', 'published', 'Discover Scuba Diving | Maldives Diving | MTG', 'Discover Scuba Diving is a discover scuba diving activity on Baros, Kaafu Atoll. It is operated by Divers Baros Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'divers-baros-maldives'),
  null, null, 'beginner', 195, null
from nodes n where n.node_type = 'activity' and n.slug = 'discover-scuba-diving'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'discover-scuba-diving'
  and l.node_type = 'location' and l.slug = 'baros'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'discover-scuba-diving'
  and c.node_type = 'category' and c.slug = 'discover-scuba-diving'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'discover-scuba-diving'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'fluo-night-diving', 'Fluo Night Diving', 'Fluo Night Diving is a night diving activity on Baros, Kaafu Atoll. It is operated by Divers Baros Maldives.', 'published', 'Fluo Night Diving | Maldives Diving | MTG', 'Fluo Night Diving is a night diving activity on Baros, Kaafu Atoll. It is operated by Divers Baros Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'divers-baros-maldives'),
  null, null, null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'fluo-night-diving'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'fluo-night-diving'
  and l.node_type = 'location' and l.slug = 'baros'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'fluo-night-diving'
  and c.node_type = 'category' and c.slug = 'night-diving'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'fluo-night-diving'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'fun-dive', 'Fun Dive', 'Fun Dive is a fun diving activity on Kunfunadhoo, Baa Atoll. It is operated by Soleni Dive Center.', 'published', 'Fun Dive | Maldives Diving | MTG', 'Fun Dive is a fun diving activity on Kunfunadhoo, Baa Atoll. It is operated by Soleni Dive Center.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'soleni-dive-center'),
  null, null, null, 89, null
from nodes n where n.node_type = 'activity' and n.slug = 'fun-dive'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'fun-dive'
  and l.node_type = 'location' and l.slug = 'kunfunadhoo'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'fun-dive'
  and c.node_type = 'category' and c.slug = 'fun-diving'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'fun-dive'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'padi-open-water-diver-course-kunfunadhoo', 'PADI Open Water Diver Course', 'PADI Open Water Diver Course is a dive courses activity on Kunfunadhoo, Baa Atoll. It is operated by Soleni Dive Center.', 'published', 'PADI Open Water Diver Course | Maldives Diving | MTG', 'PADI Open Water Diver Course is a dive courses activity on Kunfunadhoo, Baa Atoll. It is operated by Soleni Dive Center.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'soleni-dive-center'),
  null, null, 'beginner', 1090, null
from nodes n where n.node_type = 'activity' and n.slug = 'padi-open-water-diver-course-kunfunadhoo'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'padi-open-water-diver-course-kunfunadhoo'
  and l.node_type = 'location' and l.slug = 'kunfunadhoo'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'padi-open-water-diver-course-kunfunadhoo'
  and c.node_type = 'category' and c.slug = 'dive-courses'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'padi-open-water-diver-course-kunfunadhoo'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'padi-bubble-maker', 'PADI Bubble Maker', 'PADI Bubble Maker is a dive courses activity on Olhuveli, Laamu Atoll. It is operated by Deep Blue Divers.', 'published', 'PADI Bubble Maker | Maldives Diving | MTG', 'PADI Bubble Maker is a dive courses activity on Olhuveli, Laamu Atoll. It is operated by Deep Blue Divers.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'deep-blue-divers'),
  null, 8, null, 150, null
from nodes n where n.node_type = 'activity' and n.slug = 'padi-bubble-maker'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'padi-bubble-maker'
  and l.node_type = 'location' and l.slug = 'olhuveli'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'padi-bubble-maker'
  and c.node_type = 'category' and c.slug = 'dive-courses'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'padi-bubble-maker'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'discover-scuba-diving-velassaru', 'Discover Scuba Diving', 'Discover Scuba Diving is a discover scuba diving activity on Velassaru, Kaafu Atoll. It is operated by Immersion Dive Centre.', 'published', 'Discover Scuba Diving | Maldives Diving | MTG', 'Discover Scuba Diving is a discover scuba diving activity on Velassaru, Kaafu Atoll. It is operated by Immersion Dive Centre.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'immersion-dive-centre'),
  null, null, 'beginner', null, null
from nodes n where n.node_type = 'activity' and n.slug = 'discover-scuba-diving-velassaru'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'discover-scuba-diving-velassaru'
  and l.node_type = 'location' and l.slug = 'velassaru'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'discover-scuba-diving-velassaru'
  and c.node_type = 'category' and c.slug = 'discover-scuba-diving'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'discover-scuba-diving-velassaru'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'padi-open-water-diver-course-thulusdhoo', 'PADI Open Water Diver Course', 'PADI Open Water Diver Course is a dive courses activity on Thulusdhoo, Kaafu Atoll. It is operated by Sea Star Diving.', 'published', 'PADI Open Water Diver Course | Maldives Diving | MTG', 'PADI Open Water Diver Course is a dive courses activity on Thulusdhoo, Kaafu Atoll. It is operated by Sea Star Diving.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'sea-star-diving'),
  null, 15, 'beginner', null, null
from nodes n where n.node_type = 'activity' and n.slug = 'padi-open-water-diver-course-thulusdhoo'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'padi-open-water-diver-course-thulusdhoo'
  and l.node_type = 'location' and l.slug = 'thulusdhoo'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'padi-open-water-diver-course-thulusdhoo'
  and c.node_type = 'category' and c.slug = 'dive-courses'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'padi-open-water-diver-course-thulusdhoo'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'discover-scuba-diving-thulusdhoo', 'Discover Scuba Diving', 'Discover Scuba Diving is a discover scuba diving activity on Thulusdhoo, Kaafu Atoll. It is operated by Feenaa Diving Thulusdhoo.', 'published', 'Discover Scuba Diving | Maldives Diving | MTG', 'Discover Scuba Diving is a discover scuba diving activity on Thulusdhoo, Kaafu Atoll. It is operated by Feenaa Diving Thulusdhoo.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'feenaa-diving-thulusdhoo'),
  null, null, 'beginner', 100, null
from nodes n where n.node_type = 'activity' and n.slug = 'discover-scuba-diving-thulusdhoo'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'discover-scuba-diving-thulusdhoo'
  and l.node_type = 'location' and l.slug = 'thulusdhoo'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'discover-scuba-diving-thulusdhoo'
  and c.node_type = 'category' and c.slug = 'discover-scuba-diving'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'discover-scuba-diving-thulusdhoo'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'fun-dive-single-tank-thulusdhoo', 'Fun Dive (Single Tank)', 'Fun Dive (Single Tank) is a fun diving activity on Thulusdhoo, Kaafu Atoll. It is operated by Feenaa Diving Thulusdhoo.', 'published', 'Fun Dive (Single Tank) | Maldives Diving | MTG', 'Fun Dive (Single Tank) is a fun diving activity on Thulusdhoo, Kaafu Atoll. It is operated by Feenaa Diving Thulusdhoo.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'feenaa-diving-thulusdhoo'),
  null, null, null, 65, null
from nodes n where n.node_type = 'activity' and n.slug = 'fun-dive-single-tank-thulusdhoo'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'fun-dive-single-tank-thulusdhoo'
  and l.node_type = 'location' and l.slug = 'thulusdhoo'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'fun-dive-single-tank-thulusdhoo'
  and c.node_type = 'category' and c.slug = 'fun-diving'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'fun-dive-single-tank-thulusdhoo'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'padi-open-water-diver-course-vihamanaafushi', 'PADI Open Water Diver Course', 'PADI Open Water Diver Course is a dive courses activity on Vihamanaafushi, Kaafu Atoll. It is operated by Euro-Divers Kurumba.', 'published', 'PADI Open Water Diver Course | Maldives Diving | MTG', 'PADI Open Water Diver Course is a dive courses activity on Vihamanaafushi, Kaafu Atoll. It is operated by Euro-Divers Kurumba.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'euro-divers-kurumba'),
  null, null, 'beginner', null, null
from nodes n where n.node_type = 'activity' and n.slug = 'padi-open-water-diver-course-vihamanaafushi'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'padi-open-water-diver-course-vihamanaafushi'
  and l.node_type = 'location' and l.slug = 'vihamanaafushi'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'padi-open-water-diver-course-vihamanaafushi'
  and c.node_type = 'category' and c.slug = 'dive-courses'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'padi-open-water-diver-course-vihamanaafushi'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'discover-scuba-diving-lankanfushi', 'Discover Scuba Diving', 'Discover Scuba Diving is a discover scuba diving activity on Lankanfushi, Kaafu Atoll. It is operated by Ocean Paradise Dive Centre.', 'published', 'Discover Scuba Diving | Maldives Diving | MTG', 'Discover Scuba Diving is a discover scuba diving activity on Lankanfushi, Kaafu Atoll. It is operated by Ocean Paradise Dive Centre.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'ocean-paradise-dive-centre'),
  null, null, 'beginner', null, null
from nodes n where n.node_type = 'activity' and n.slug = 'discover-scuba-diving-lankanfushi'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'discover-scuba-diving-lankanfushi'
  and l.node_type = 'location' and l.slug = 'lankanfushi'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'discover-scuba-diving-lankanfushi'
  and c.node_type = 'category' and c.slug = 'discover-scuba-diving'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'discover-scuba-diving-lankanfushi'
on conflict (id) do nothing;

-- Diving-type tags for the pre-existing Task 6 diving activities (named
-- unambiguously by their own product titles — no new facts introduced).
insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'discover-scuba-diving-dsd'
  and c.node_type = 'category' and c.slug = 'discover-scuba-diving'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'padi-open-water-diver-course'
  and c.node_type = 'category' and c.slug = 'dive-courses'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'guided-reef-dive'
  and c.node_type = 'category' and c.slug = 'reef-diving'
on conflict (node_id, category_id) do nothing;

-- Dive sites: physical locations, location_type = 'dive_site'. These are
-- never activities and never get a bookable_products row.
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'banana-reef', 'Banana Reef', 'Banana Reef is a reef in Kaafu Atoll, Maldives. Depth ranges from approximately 3m to 30m.', 'published', 'Banana Reef | Maldives Dive Sites | MTG', 'Banana Reef is a reef in Kaafu Atoll, Maldives. Depth ranges from approximately 3m to 30m.', '{"site_type":"reef","depth_min_meters":3,"depth_max_meters":30,"experience_level":"all levels","current_notes":"Generally gentle to moderate and considered beginner-friendly, but can turn strong at times, with occasional turbulence around the reef''s overhangs.","marine_life_notes":"Groupers, sharks, jacks, blue-striped snapper and barracuda commonly seen among the coral formations; turtles are seen occasionally."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'dive_site', p.id, (p_loc.path || 'banana_reef'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'banana-reef'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'hp-reef', 'HP Reef', 'HP Reef is a thila in Kaafu Atoll, Maldives. Depth ranges from approximately 5m to 30m.', 'published', 'HP Reef | Maldives Dive Sites | MTG', 'HP Reef is a thila in Kaafu Atoll, Maldives. Depth ranges from approximately 5m to 30m.', '{"site_type":"thila","depth_min_meters":5,"depth_max_meters":30,"experience_level":"advanced","current_notes":"Strong currents are common, especially during the southwest monsoon; recommended for advanced divers.","marine_life_notes":"Grey reef sharks, eagle rays, barracuda, dog-toothed tuna and various angelfish/bannerfish species; manta rays are seen occasionally. Soft corals, gorgonian fans and sea whips cover the reef top."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'dive_site', p.id, (p_loc.path || 'hp_reef'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hp-reef'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'location' and n.slug = 'hp-reef'
  and l.node_type = 'location' and l.slug = 'himmafushi'
on conflict (node_id, location_id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'lankan-manta-point', 'Lankan Manta Point', 'Lankan Manta Point is a reef in Kaafu Atoll, Maldives. Depth ranges from approximately 15m to 25m.', 'published', 'Lankan Manta Point | Maldives Dive Sites | MTG', 'Lankan Manta Point is a reef in Kaafu Atoll, Maldives. Depth ranges from approximately 15m to 25m.', '{"site_type":"reef","depth_min_meters":15,"depth_max_meters":25,"current_notes":"Moderate to strong current at the outer-reef cleaning stations; divers are recommended to be comfortable with current and drift diving.","marine_life_notes":"Manta rays are commonly seen at the site''s cleaning stations, with sources describing daily sightings in peak season (roughly mid-August through November) and year-round presence with a second reported peak Nov-May; never described as guaranteed."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'dive_site', p.id, (p_loc.path || 'lankan_manta_point'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'lankan-manta-point'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'location' and n.slug = 'lankan-manta-point'
  and l.node_type = 'location' and l.slug = 'lankanfushi'
on conflict (node_id, location_id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'fish-head-mushimasmingili-thila', 'Fish Head (Mushimasmingili Thila)', 'Fish Head (Mushimasmingili Thila) is a thila in Alif Dhaalu Atoll, Maldives. Depth ranges from approximately 5m to 30m.', 'published', 'Fish Head (Mushimasmingili Thila) | Maldives Dive Sites | MTG', 'Fish Head (Mushimasmingili Thila) is a thila in Alif Dhaalu Atoll, Maldives. Depth ranges from approximately 5m to 30m.', '{"site_type":"thila","depth_min_meters":5,"depth_max_meters":30,"experience_level":"advanced","current_notes":"Forceful tidal currents that can range from moderate to powerful, making it a thrilling drift dive; not recommended for novice divers.","marine_life_notes":"Notable for a consistent, often large presence of grey reef sharks (sometimes reported in groups of 20+) patrolling the deeper sections, along with whitetip reef sharks and abundant reef fish."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'dive_site', p.id, (p_loc.path || 'fish_head_mushimasmingili_thila'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fish-head-mushimasmingili-thila'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'location' and n.slug = 'fish-head-mushimasmingili-thila'
  and l.node_type = 'location' and l.slug = 'maamingili'
on conflict (node_id, location_id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'kuda-rah-thila', 'Kuda Rah Thila', 'Kuda Rah Thila is a thila in Alif Dhaalu Atoll, Maldives. Depth ranges from approximately 12m to 30m.', 'published', 'Kuda Rah Thila | Maldives Dive Sites | MTG', 'Kuda Rah Thila is a thila in Alif Dhaalu Atoll, Maldives. Depth ranges from approximately 12m to 30m.', '{"site_type":"thila","depth_min_meters":12,"depth_max_meters":30,"experience_level":"advanced","current_notes":"Strong, swirling incoming current makes this an advanced dive.","marine_life_notes":"Densely covered in soft coral and sea fans; frequented by groupers, snapper, fusiliers, trevally, reef sharks and eagle rays."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'dive_site', p.id, (p_loc.path || 'kuda_rah_thila'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kuda-rah-thila'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'guraidhoo-kandu', 'Guraidhoo Kandu', 'Guraidhoo Kandu is a channel in Kaafu Atoll, Maldives. Depth reaches approximately 35m.', 'published', 'Guraidhoo Kandu | Maldives Dive Sites | MTG', 'Guraidhoo Kandu is a channel in Kaafu Atoll, Maldives. Depth reaches approximately 35m.', '{"site_type":"channel","depth_max_meters":35,"experience_level":"advanced","current_notes":"Strong currents suitable only for advanced, experienced divers; can pull divers off the reef, with frequent underwater turbulence. December-May usually brings the clearest channel conditions.","marine_life_notes":"Grey reef sharks are common when the current is incoming, along with eagle rays, jacks, tuna, barracuda, turtles, snappers and fusiliers."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'dive_site', p.id, (p_loc.path || 'guraidhoo_kandu'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'guraidhoo-kandu'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'location' and n.slug = 'guraidhoo-kandu'
  and l.node_type = 'location' and l.slug = 'guraidhoo'
on conflict (node_id, location_id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'kandooma-thila', 'Kandooma Thila', 'Kandooma Thila is a thila in Kaafu Atoll, Maldives. Depth ranges from approximately 12m to 40m.', 'published', 'Kandooma Thila | Maldives Dive Sites | MTG', 'Kandooma Thila is a thila in Kaafu Atoll, Maldives. Depth ranges from approximately 12m to 40m.', '{"site_type":"thila","depth_min_meters":12,"depth_max_meters":40,"experience_level":"advanced","current_notes":"Strong outgoing current runs west to east through the channel between the thila and the reef; suitable only for experienced divers.","marine_life_notes":"A focal point for eagle rays, dogtooth tuna, bluefin trevally and loose groups of grey reef sharks (sometimes 50+ in favorable current); also whitetip sharks and green turtles. A shark cleaning station is the site''s main attraction."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'dive_site', p.id, (p_loc.path || 'kandooma_thila'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kandooma-thila'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'maaya-thila', 'Maaya Thila', 'Maaya Thila is a thila in Alif Dhaalu Atoll, Maldives. Depth ranges from approximately 6m to 30m.', 'published', 'Maaya Thila | Maldives Dive Sites | MTG', 'Maaya Thila is a thila in Alif Dhaalu Atoll, Maldives. Depth ranges from approximately 6m to 30m.', '{"site_type":"thila","depth_min_meters":6,"depth_max_meters":30,"current_notes":"Current is highly changeable: in little or no current the site can suit all diver levels, but conditions are often unstable/unpredictable and it is then unsuitable for novice-level divers, so crew judgment on the day matters.","marine_life_notes":"Famous as a night-dive site for actively hunting whitetip reef sharks; by day and night also hosts grey reef sharks (sometimes numbering into the teens), turtles, moray eels, stingrays, frogfish, teira batfish and blue-faced angelfish."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'dive_site', p.id, (p_loc.path || 'maaya_thila'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maaya-thila'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'rasdhoo-madivaru', 'Rasdhoo Madivaru', 'Rasdhoo Madivaru is a channel in Alif Alif Atoll, Maldives. Depth ranges from approximately 20m to 28m.', 'published', 'Rasdhoo Madivaru | Maldives Dive Sites | MTG', 'Rasdhoo Madivaru is a channel in Alif Alif Atoll, Maldives. Depth ranges from approximately 20m to 28m.', '{"site_type":"channel","depth_min_meters":20,"depth_max_meters":28,"experience_level":"advanced","current_notes":"Strong currents are common; treated as an advanced, current-sensitive drift dive along the outer atoll wall.","marine_life_notes":"Best known for resident scalloped hammerhead sharks (typically seen on early-dawn dives, no strong seasonality reported), plus jacks, barracuda, tuna, whitetip and grey reef sharks, and eagle rays."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'dive_site', p.id, (p_loc.path || 'rasdhoo_madivaru'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'rasdhoo-madivaru'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'location' and n.slug = 'rasdhoo-madivaru'
  and l.node_type = 'location' and l.slug = 'rasdhoo'
on conflict (node_id, location_id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'kuda-giri-wreck', 'Kuda Giri Wreck', 'Kuda Giri Wreck is a wreck in Kaafu Atoll, Maldives. Depth ranges from approximately 18m to 32m.', 'published', 'Kuda Giri Wreck | Maldives Dive Sites | MTG', 'Kuda Giri Wreck is a wreck in Kaafu Atoll, Maldives. Depth ranges from approximately 18m to 32m.', '{"site_type":"wreck","depth_min_meters":18,"depth_max_meters":32,"current_notes":"Generally very little current at this site.","marine_life_notes":"Colorful sponges, tube corals and orange cup corals cover the wreck; batfish, glassfish, gobies, shrimp and triggerfish are common, with turtles, wrasses, eels and octopus also reported."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'dive_site', p.id, (p_loc.path || 'kuda_giri_wreck'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kuda-giri-wreck'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'location' and n.slug = 'kuda-giri-wreck'
  and l.node_type = 'location' and l.slug = 'gulhi'
on conflict (node_id, location_id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'okobe-thila', 'Okobe Thila', 'Okobe Thila is a thila in Kaafu Atoll, Maldives. Depth ranges from approximately 12m to 32m.', 'published', 'Okobe Thila | Maldives Dive Sites | MTG', 'Okobe Thila is a thila in Kaafu Atoll, Maldives. Depth ranges from approximately 12m to 32m.', '{"site_type":"thila","depth_min_meters":12,"depth_max_meters":32,"experience_level":"advanced","current_notes":"Current conditions mean the site is considered necessary for experienced divers when exploring North Male Atoll.","marine_life_notes":"Bluestripe snapper, oriental sweetlips and fusiliers school around the reef''s north end; barracuda, Napoleon wrasse, tuna, trevally and white-tip reef sharks are also reported, amid dense soft coral cover."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'dive_site', p.id, (p_loc.path || 'okobe_thila'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'okobe-thila'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'location' and n.slug = 'okobe-thila'
  and l.node_type = 'location' and l.slug = 'lankanfushi'
on conflict (node_id, location_id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'vaadhoo-caves', 'Vaadhoo Caves', 'Vaadhoo Caves is a cave in Kaafu Atoll, Maldives. Depth ranges from approximately 7m to 30m.', 'published', 'Vaadhoo Caves | Maldives Dive Sites | MTG', 'Vaadhoo Caves is a cave in Kaafu Atoll, Maldives. Depth ranges from approximately 7m to 30m.', '{"site_type":"cave","depth_min_meters":7,"depth_max_meters":30,"experience_level":"intermediate","current_notes":"Current is usually light, which also makes the area popular for snorkeling.","marine_life_notes":"Spectacular soft coral growth and abundant fish life on the southwest side of the house reef; the nearby channel occasionally brings in pelagic visitors such as eagle rays, mobula rays, tuna and grey reef sharks."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'dive_site', p.id, (p_loc.path || 'vaadhoo_caves'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vaadhoo-caves'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

