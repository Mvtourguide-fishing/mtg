-- MTG: activity + provider seed (Task 6).
-- GENERATED FILE — do not hand-edit. Source of truth:
--   data/maldives/activities/activities.json
--   data/maldives/activities/SOURCES.md
-- Regenerate with: node scripts/generate-activity-seed.mjs
--
-- Idempotent (ON CONFLICT DO NOTHING, keyed by slug). Providers reuse the
-- exact Task 5 provider names where an activity's operator matches one
-- (the insert becomes a harmless no-op against the existing row); a genuinely
-- new operator gets a new provider node. No new locations are created here —
-- every activity resolves to an island already seeded by Task 4 or Task 5.

-- Providers (reused from Task 5 where the name matches exactly, else new)
insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'icom-tours', 'iCom Tours', 'iCom Tours operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'icom-tours'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'universal-resorts', 'Universal Resorts', 'Universal Resorts operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'universal-resorts'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'the-perfect-wave-cokes-surf-camp', 'The Perfect Wave Cokes Surf Camp', 'The Perfect Wave Cokes Surf Camp operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'the-perfect-wave-cokes-surf-camp'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'maafushi-dive-and-water-sports', 'Maafushi Dive and Water Sports', 'Maafushi Dive and Water Sports operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'maafushi-dive-and-water-sports'
on conflict (id) do nothing;

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
values ('provider', 'divers-baros-maldives', 'Divers Baros Maldives', 'Divers Baros Maldives operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'divers-baros-maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'soneva-management-bvi-limited', 'Soneva Management (BVI) Limited', 'Soneva Management (BVI) Limited operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'soneva-management-bvi-limited'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'six-senses', 'Six Senses', 'Six Senses operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'six-senses'
on conflict (id) do nothing;

-- Activities
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'snorkeling-dolphin-watching-sandbank-package', 'Snorkeling, Dolphin Watching & Sandbank Package', 'Snorkeling, Dolphin Watching & Sandbank Package is a excursion on Maafushi, Kaafu Atoll. It is operated by iCom Tours.', 'published', 'Snorkeling, Dolphin Watching & Sandbank Package | Maldives Activities | MTG', 'Snorkeling, Dolphin Watching & Sandbank Package is a excursion on Maafushi, Kaafu Atoll. It is operated by iCom Tours.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'excursion',
  (select id from nodes where node_type = 'provider' and slug = 'icom-tours'),
  null, null, null, 25, null
from nodes n where n.node_type = 'activity' and n.slug = 'snorkeling-dolphin-watching-sandbank-package'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'snorkeling-dolphin-watching-sandbank-package'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'snorkeling-dolphin-watching-sandbank-package'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'sunset-dolphin-cruise', 'Sunset Dolphin Cruise', 'Sunset Dolphin Cruise is a excursion on Vihamanaafushi, Kaafu Atoll. Duration: 120 minutes. It is operated by Universal Resorts.', 'published', 'Sunset Dolphin Cruise | Maldives Activities | MTG', 'Sunset Dolphin Cruise is a excursion on Vihamanaafushi, Kaafu Atoll. Duration: 120 minutes. It is operated by Universal Resorts.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'excursion',
  (select id from nodes where node_type = 'provider' and slug = 'universal-resorts'),
  120, null, null, 65, null
from nodes n where n.node_type = 'activity' and n.slug = 'sunset-dolphin-cruise'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'sunset-dolphin-cruise'
  and l.node_type = 'location' and l.slug = 'vihamanaafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'sunset-dolphin-cruise'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'sandbank-picnic', 'Sandbank Picnic', 'Sandbank Picnic is a activity on Vihamanaafushi, Kaafu Atoll. It is operated by Universal Resorts.', 'published', 'Sandbank Picnic | Maldives Activities | MTG', 'Sandbank Picnic is a activity on Vihamanaafushi, Kaafu Atoll. It is operated by Universal Resorts.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'general',
  (select id from nodes where node_type = 'provider' and slug = 'universal-resorts'),
  null, 10, null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'sandbank-picnic'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'sandbank-picnic'
  and l.node_type = 'location' and l.slug = 'vihamanaafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'sandbank-picnic'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'male-guided-tour', 'Malé Guided Tour', 'Malé Guided Tour is a cultural experience on Vihamanaafushi, Kaafu Atoll. Duration: 180 minutes. It is operated by Universal Resorts.', 'published', 'Malé Guided Tour | Maldives Activities | MTG', 'Malé Guided Tour is a cultural experience on Vihamanaafushi, Kaafu Atoll. Duration: 180 minutes. It is operated by Universal Resorts.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'culture',
  (select id from nodes where node_type = 'provider' and slug = 'universal-resorts'),
  180, null, null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'male-guided-tour'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'male-guided-tour'
  and l.node_type = 'location' and l.slug = 'vihamanaafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'male-guided-tour'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'private-surf-lesson-cokes', 'Private Surf Lesson (Cokes)', 'Private Surf Lesson (Cokes) is a surf session on Thulusdhoo, Kaafu Atoll. Duration: 60 minutes. It is operated by The Perfect Wave Cokes Surf Camp.', 'published', 'Private Surf Lesson (Cokes) | Maldives Activities | MTG', 'Private Surf Lesson (Cokes) is a surf session on Thulusdhoo, Kaafu Atoll. Duration: 60 minutes. It is operated by The Perfect Wave Cokes Surf Camp.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'surfing',
  (select id from nodes where node_type = 'provider' and slug = 'the-perfect-wave-cokes-surf-camp'),
  60, null, null, 75, null
from nodes n where n.node_type = 'activity' and n.slug = 'private-surf-lesson-cokes'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'private-surf-lesson-cokes'
  and l.node_type = 'location' and l.slug = 'thulusdhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'private-surf-lesson-cokes'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'discover-scuba-diving-dsd', 'Discover Scuba Diving (DSD)', 'Discover Scuba Diving (DSD) is a dive on Maafushi, Kaafu Atoll. It is operated by Maafushi Dive and Water Sports.', 'published', 'Discover Scuba Diving (DSD) | Maldives Activities | MTG', 'Discover Scuba Diving (DSD) is a dive on Maafushi, Kaafu Atoll. It is operated by Maafushi Dive and Water Sports.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'maafushi-dive-and-water-sports'),
  null, null, 'beginner', 75, null
from nodes n where n.node_type = 'activity' and n.slug = 'discover-scuba-diving-dsd'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'discover-scuba-diving-dsd'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'discover-scuba-diving-dsd'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'padi-open-water-diver-course', 'PADI Open Water Diver Course', 'PADI Open Water Diver Course is a dive on Maafushi, Kaafu Atoll. It is operated by Maafushi Dive and Water Sports.', 'published', 'PADI Open Water Diver Course | Maldives Activities | MTG', 'PADI Open Water Diver Course is a dive on Maafushi, Kaafu Atoll. It is operated by Maafushi Dive and Water Sports.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'maafushi-dive-and-water-sports'),
  null, null, 'beginner', 475, null
from nodes n where n.node_type = 'activity' and n.slug = 'padi-open-water-diver-course'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'padi-open-water-diver-course'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'padi-open-water-diver-course'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'private-snorkeling-trip', 'Private Snorkeling Trip', 'Private Snorkeling Trip is a watersports activity on Maafushi, Kaafu Atoll. It is operated by Maafushi Dive and Water Sports.', 'published', 'Private Snorkeling Trip | Maldives Activities | MTG', 'Private Snorkeling Trip is a watersports activity on Maafushi, Kaafu Atoll. It is operated by Maafushi Dive and Water Sports.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'watersports',
  (select id from nodes where node_type = 'provider' and slug = 'maafushi-dive-and-water-sports'),
  null, null, null, 150, null
from nodes n where n.node_type = 'activity' and n.slug = 'private-snorkeling-trip'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'private-snorkeling-trip'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'private-snorkeling-trip'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'private-dolphin-cruise', 'Private Dolphin Cruise', 'Private Dolphin Cruise is a excursion on Maafushi, Kaafu Atoll. Duration: 60 minutes. It is operated by Active Watersports Maafushi.', 'published', 'Private Dolphin Cruise | Maldives Activities | MTG', 'Private Dolphin Cruise is a excursion on Maafushi, Kaafu Atoll. Duration: 60 minutes. It is operated by Active Watersports Maafushi.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'excursion',
  (select id from nodes where node_type = 'provider' and slug = 'active-watersports-maafushi'),
  60, null, null, null, 2
from nodes n where n.node_type = 'activity' and n.slug = 'private-dolphin-cruise'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'private-dolphin-cruise'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'private-dolphin-cruise'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'full-day-snorkeling-island-hopping-tour', 'Full-Day Snorkeling & Island Hopping Tour', 'Full-Day Snorkeling & Island Hopping Tour is a island-hopping trip on Maafushi, Kaafu Atoll.', 'published', 'Full-Day Snorkeling & Island Hopping Tour | Maldives Activities | MTG', 'Full-Day Snorkeling & Island Hopping Tour is a island-hopping trip on Maafushi, Kaafu Atoll.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'island_hopping',
  null,
  null, null, null, 90, null
from nodes n where n.node_type = 'activity' and n.slug = 'full-day-snorkeling-island-hopping-tour'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'full-day-snorkeling-island-hopping-tour'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'full-day-snorkeling-island-hopping-tour'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'sandbank-snorkeling-dolphin-watching-excursions', 'Sandbank, Snorkeling & Dolphin Watching Excursions', 'Sandbank, Snorkeling & Dolphin Watching Excursions is a excursion on Maafushi, Kaafu Atoll. It is operated by Kaani Hotels.', 'published', 'Sandbank, Snorkeling & Dolphin Watching Excursions | Maldives Activities | MTG', 'Sandbank, Snorkeling & Dolphin Watching Excursions is a excursion on Maafushi, Kaafu Atoll. It is operated by Kaani Hotels.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'excursion',
  (select id from nodes where node_type = 'provider' and slug = 'kaani-hotels'),
  null, null, null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'sandbank-snorkeling-dolphin-watching-excursions'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'sandbank-snorkeling-dolphin-watching-excursions'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'sandbank-snorkeling-dolphin-watching-excursions'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'guided-reef-dive', 'Guided Reef Dive', 'Guided Reef Dive is a dive on Baros, Kaafu Atoll. It is operated by Divers Baros Maldives.', 'published', 'Guided Reef Dive | Maldives Activities | MTG', 'Guided Reef Dive is a dive on Baros, Kaafu Atoll. It is operated by Divers Baros Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'diving',
  (select id from nodes where node_type = 'provider' and slug = 'divers-baros-maldives'),
  null, null, null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'guided-reef-dive'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'guided-reef-dive'
  and l.node_type = 'location' and l.slug = 'baros'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'guided-reef-dive'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'sunset-dolphin-cruise-kunfunadhoo', 'Sunset Dolphin Cruise', 'Sunset Dolphin Cruise is a excursion on Kunfunadhoo, Baa Atoll. It is operated by Soneva Management (BVI) Limited.', 'published', 'Sunset Dolphin Cruise | Maldives Activities | MTG', 'Sunset Dolphin Cruise is a excursion on Kunfunadhoo, Baa Atoll. It is operated by Soneva Management (BVI) Limited.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'excursion',
  (select id from nodes where node_type = 'provider' and slug = 'soneva-management-bvi-limited'),
  null, null, null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'sunset-dolphin-cruise-kunfunadhoo'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'sunset-dolphin-cruise-kunfunadhoo'
  and l.node_type = 'location' and l.slug = 'kunfunadhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'sunset-dolphin-cruise-kunfunadhoo'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'soneva-soul-60-minute-spa-treatment', 'Soneva Soul 60-Minute Spa Treatment', 'Soneva Soul 60-Minute Spa Treatment is a spa experience on Kunfunadhoo, Baa Atoll. Duration: 60 minutes. It is operated by Soneva Management (BVI) Limited.', 'published', 'Soneva Soul 60-Minute Spa Treatment | Maldives Activities | MTG', 'Soneva Soul 60-Minute Spa Treatment is a spa experience on Kunfunadhoo, Baa Atoll. Duration: 60 minutes. It is operated by Soneva Management (BVI) Limited.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'spa',
  (select id from nodes where node_type = 'provider' and slug = 'soneva-management-bvi-limited'),
  60, null, null, 195, null
from nodes n where n.node_type = 'activity' and n.slug = 'soneva-soul-60-minute-spa-treatment'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'soneva-soul-60-minute-spa-treatment'
  and l.node_type = 'location' and l.slug = 'kunfunadhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'soneva-soul-60-minute-spa-treatment'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'traditional-handline-fishing-trip', 'Traditional Handline Fishing Trip', 'Traditional Handline Fishing Trip is a fishing trip on Olhuveli, Laamu Atoll. It is operated by Six Senses.', 'published', 'Traditional Handline Fishing Trip | Maldives Activities | MTG', 'Traditional Handline Fishing Trip is a fishing trip on Olhuveli, Laamu Atoll. It is operated by Six Senses.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'fishing',
  (select id from nodes where node_type = 'provider' and slug = 'six-senses'),
  null, null, null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'traditional-handline-fishing-trip'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'traditional-handline-fishing-trip'
  and l.node_type = 'location' and l.slug = 'olhuveli'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'traditional-handline-fishing-trip'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'night-fishing-excursion', 'Night Fishing Excursion', 'Night Fishing Excursion is a fishing trip on Velassaru, Kaafu Atoll. It is operated by Universal Resorts.', 'published', 'Night Fishing Excursion | Maldives Activities | MTG', 'Night Fishing Excursion is a fishing trip on Velassaru, Kaafu Atoll. It is operated by Universal Resorts.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'fishing',
  (select id from nodes where node_type = 'provider' and slug = 'universal-resorts'),
  null, null, null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'night-fishing-excursion'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'night-fishing-excursion'
  and l.node_type = 'location' and l.slug = 'velassaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'night-fishing-excursion'
on conflict (id) do nothing;

