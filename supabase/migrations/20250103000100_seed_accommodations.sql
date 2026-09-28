-- MTG: accommodation + provider seed (Task 5).
-- GENERATED FILE — do not hand-edit. Source of truth:
--   data/maldives/accommodations/accommodations.json
--   data/maldives/accommodations/providers.json
--   data/maldives/accommodations/SOURCES.md
-- Regenerate with: node scripts/generate-accommodation-seed.mjs
--
-- Idempotent (ON CONFLICT DO NOTHING, keyed by slug). Some accommodations
-- are on private/resort islands that Task 4 deliberately excluded (it only
-- seeded INHABITED islands); this migration adds those specific resort
-- islands as real, sourced location rows (is_inhabited = false) rather than
-- inventing an accommodation-specific location — see data/maldives/
-- accommodations/SOURCES.md for how each was verified.

-- Providers
insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'universal-resorts', 'Universal Resorts', 'Universal Resorts operates accommodation properties in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id, website_url)
select id, 'https://universalresorts.com/' from nodes where node_type = 'provider' and slug = 'universal-resorts'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'soneva-management-bvi-limited', 'Soneva Management (BVI) Limited', 'Soneva Management (BVI) Limited operates accommodation properties in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id, website_url)
select id, 'https://soneva.com' from nodes where node_type = 'provider' and slug = 'soneva-management-bvi-limited'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'six-senses', 'Six Senses', 'Six Senses operates accommodation properties in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id, website_url)
select id, 'https://www.sixsenses.com' from nodes where node_type = 'provider' and slug = 'six-senses'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'kaani-hotels', 'Kaani Hotels', 'Kaani Hotels operates accommodation properties in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id, website_url)
select id, null from nodes where node_type = 'provider' and slug = 'kaani-hotels'
on conflict (id) do nothing;

-- Resort/private islands not covered by the Task 4 inhabited-islands seed
insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'vihamanaafushi', 'Vihamanaafushi', 'Vihamanaafushi is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vihamanaafushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vihamanaafushi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kunfunadhoo', 'Kunfunadhoo', 'Kunfunadhoo is a resort island in Baa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kunfunadhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kunfunadhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'velassaru', 'Velassaru', 'Velassaru is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'velassaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'velassaru'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'olhuveli', 'Olhuveli', 'Olhuveli is a resort island in Laamu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'olhuveli'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'olhuveli'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'baros', 'Baros', 'Baros is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'baros'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'baros'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'lankanfushi', 'Lankanfushi', 'Lankanfushi is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'lankanfushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'lankanfushi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

-- Accommodations
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'kurumba-maldives', 'Kurumba Maldives', 'Kurumba Maldives is a resort on Vihamanaafushi, Kaafu Atoll. It is a 5-star property. It is operated by Universal Resorts.', 'published', 'Kurumba Maldives | Maldives Resorts | MTG', 'Kurumba Maldives is a resort on Vihamanaafushi, Kaafu Atoll. It is a 5-star property. It is operated by Universal Resorts.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas
)
select
  n.id, 'resort',
  (select id from nodes where node_type = 'provider' and slug = 'universal-resorts'),
  5, 180, null, false
from nodes n where n.node_type = 'accommodation' and n.slug = 'kurumba-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'kurumba-maldives'
  and l.node_type = 'location' and l.slug = 'vihamanaafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'kurumba-maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'soneva-fushi', 'Soneva Fushi', 'Soneva Fushi is a resort on Kunfunadhoo, Baa Atoll. It is operated by Soneva Management (BVI) Limited.', 'published', 'Soneva Fushi | Maldives Resorts | MTG', 'Soneva Fushi is a resort on Kunfunadhoo, Baa Atoll. It is operated by Soneva Management (BVI) Limited.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas
)
select
  n.id, 'resort',
  (select id from nodes where node_type = 'provider' and slug = 'soneva-management-bvi-limited'),
  null, 64, true, true
from nodes n where n.node_type = 'accommodation' and n.slug = 'soneva-fushi'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'soneva-fushi'
  and l.node_type = 'location' and l.slug = 'kunfunadhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'soneva-fushi'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'velassaru-maldives', 'Velassaru Maldives', 'Velassaru Maldives is a resort on Velassaru, Kaafu Atoll. It is a 5-star property. It is operated by Universal Resorts.', 'published', 'Velassaru Maldives | Maldives Resorts | MTG', 'Velassaru Maldives is a resort on Velassaru, Kaafu Atoll. It is a 5-star property. It is operated by Universal Resorts.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas
)
select
  n.id, 'resort',
  (select id from nodes where node_type = 'provider' and slug = 'universal-resorts'),
  5, null, null, true
from nodes n where n.node_type = 'accommodation' and n.slug = 'velassaru-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'velassaru-maldives'
  and l.node_type = 'location' and l.slug = 'velassaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'velassaru-maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'six-senses-laamu', 'Six Senses Laamu', 'Six Senses Laamu is a resort on Olhuveli, Laamu Atoll. It is operated by Six Senses.', 'published', 'Six Senses Laamu | Maldives Resorts | MTG', 'Six Senses Laamu is a resort on Olhuveli, Laamu Atoll. It is operated by Six Senses.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas
)
select
  n.id, 'resort',
  (select id from nodes where node_type = 'provider' and slug = 'six-senses'),
  null, 94, null, true
from nodes n where n.node_type = 'accommodation' and n.slug = 'six-senses-laamu'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'six-senses-laamu'
  and l.node_type = 'location' and l.slug = 'olhuveli'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'six-senses-laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'baros-maldives', 'Baros Maldives', 'Baros Maldives is a resort on Baros, Kaafu Atoll. It is a 5-star property.', 'published', 'Baros Maldives | Maldives Resorts | MTG', 'Baros Maldives is a resort on Baros, Kaafu Atoll. It is a 5-star property.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas
)
select
  n.id, 'resort',
  null,
  5, 75, null, true
from nodes n where n.node_type = 'accommodation' and n.slug = 'baros-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'baros-maldives'
  and l.node_type = 'location' and l.slug = 'baros'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'baros-maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'gili-lankanfushi', 'Gili Lankanfushi', 'Gili Lankanfushi is a resort on Lankanfushi, Kaafu Atoll. It is a 5-star property.', 'published', 'Gili Lankanfushi | Maldives Resorts | MTG', 'Gili Lankanfushi is a resort on Lankanfushi, Kaafu Atoll. It is a 5-star property.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas
)
select
  n.id, 'resort',
  null,
  5, 45, null, true
from nodes n where n.node_type = 'accommodation' and n.slug = 'gili-lankanfushi'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'gili-lankanfushi'
  and l.node_type = 'location' and l.slug = 'lankanfushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'gili-lankanfushi'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'arena-beach-hotel', 'Arena Beach Hotel', 'Arena Beach Hotel is a hotel on Maafushi, Kaafu Atoll. It is a 4-star property.', 'published', 'Arena Beach Hotel | Maldives Hotels | MTG', 'Arena Beach Hotel is a hotel on Maafushi, Kaafu Atoll. It is a 4-star property.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas
)
select
  n.id, 'hotel',
  null,
  4, null, null, null
from nodes n where n.node_type = 'accommodation' and n.slug = 'arena-beach-hotel'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'arena-beach-hotel'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'arena-beach-hotel'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'kaani-beach-hotel', 'Kaani Beach Hotel', 'Kaani Beach Hotel is a hotel on Maafushi, Kaafu Atoll. It is operated by Kaani Hotels.', 'published', 'Kaani Beach Hotel | Maldives Hotels | MTG', 'Kaani Beach Hotel is a hotel on Maafushi, Kaafu Atoll. It is operated by Kaani Hotels.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas
)
select
  n.id, 'hotel',
  (select id from nodes where node_type = 'provider' and slug = 'kaani-hotels'),
  null, 18, null, null
from nodes n where n.node_type = 'accommodation' and n.slug = 'kaani-beach-hotel'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'kaani-beach-hotel'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'kaani-beach-hotel'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'go-surf-maldives', 'Go Surf Maldives', 'Go Surf Maldives is a guesthouse on Thulusdhoo, Kaafu Atoll.', 'published', 'Go Surf Maldives | Maldives Guesthouses | MTG', 'Go Surf Maldives is a guesthouse on Thulusdhoo, Kaafu Atoll.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas
)
select
  n.id, 'guesthouse',
  null,
  null, null, null, null
from nodes n where n.node_type = 'accommodation' and n.slug = 'go-surf-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'go-surf-maldives'
  and l.node_type = 'location' and l.slug = 'thulusdhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'go-surf-maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'sealavie-inn', 'SeaLaVie Inn', 'SeaLaVie Inn is a guesthouse on Ukulhas, Alif Alif Atoll.', 'published', 'SeaLaVie Inn | Maldives Guesthouses | MTG', 'SeaLaVie Inn is a guesthouse on Ukulhas, Alif Alif Atoll.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas
)
select
  n.id, 'guesthouse',
  null,
  null, 5, null, null
from nodes n where n.node_type = 'accommodation' and n.slug = 'sealavie-inn'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'sealavie-inn'
  and l.node_type = 'location' and l.slug = 'ukulhas'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'sealavie-inn'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'whaleshark-beach', 'Whaleshark Beach', 'Whaleshark Beach is a guesthouse on Dhigurah, Alif Dhaalu Atoll.', 'published', 'Whaleshark Beach | Maldives Guesthouses | MTG', 'Whaleshark Beach is a guesthouse on Dhigurah, Alif Dhaalu Atoll.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas
)
select
  n.id, 'guesthouse',
  null,
  null, 23, null, null
from nodes n where n.node_type = 'accommodation' and n.slug = 'whaleshark-beach'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'whaleshark-beach'
  and l.node_type = 'location' and l.slug = 'dhigurah'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'whaleshark-beach'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'dhaankolhu-rasdhoo', 'Dhaankolhu Rasdhoo', 'Dhaankolhu Rasdhoo is a guesthouse on Rasdhoo, Alif Alif Atoll.', 'published', 'Dhaankolhu Rasdhoo | Maldives Guesthouses | MTG', 'Dhaankolhu Rasdhoo is a guesthouse on Rasdhoo, Alif Alif Atoll.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas
)
select
  n.id, 'guesthouse',
  null,
  null, 9, null, null
from nodes n where n.node_type = 'accommodation' and n.slug = 'dhaankolhu-rasdhoo'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'dhaankolhu-rasdhoo'
  and l.node_type = 'location' and l.slug = 'rasdhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'dhaankolhu-rasdhoo'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'crystal-view-maldives-guest-house', 'Crystal View Maldives Guest House', 'Crystal View Maldives Guest House is a guesthouse on Gulhi, Kaafu Atoll.', 'published', 'Crystal View Maldives Guest House | Maldives Guesthouses | MTG', 'Crystal View Maldives Guest House is a guesthouse on Gulhi, Kaafu Atoll.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas
)
select
  n.id, 'guesthouse',
  null,
  null, null, null, null
from nodes n where n.node_type = 'accommodation' and n.slug = 'crystal-view-maldives-guest-house'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'crystal-view-maldives-guest-house'
  and l.node_type = 'location' and l.slug = 'gulhi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'crystal-view-maldives-guest-house'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'coral-grand-beach-spa', 'Coral Grand Beach & Spa', 'Coral Grand Beach & Spa is a hotel on Hulhumalé, Malé City.', 'published', 'Coral Grand Beach & Spa | Maldives Hotels | MTG', 'Coral Grand Beach & Spa is a hotel on Hulhumalé, Malé City.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas
)
select
  n.id, 'hotel',
  null,
  null, 20, null, null
from nodes n where n.node_type = 'accommodation' and n.slug = 'coral-grand-beach-spa'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'coral-grand-beach-spa'
  and l.node_type = 'location' and l.slug = 'hulhumale'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'coral-grand-beach-spa'
on conflict (id) do nothing;

