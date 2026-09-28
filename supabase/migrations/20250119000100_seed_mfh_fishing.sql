-- Maldives Fishing and Holiday Pvt Ltd (MFH) — real fishing charter and
-- package operator, sourced from the owner-supplied rate sheets (valid
-- until 31 December 2027). GENERATED FILE — do not hand-edit.
-- Source of truth:
--   data/maldives/fishing/mfh-charters.json
--   data/maldives/fishing/mfh-packages.json
--   data/maldives/fishing/SOURCES-mfh.md
-- Regenerate with: node scripts/generate-mfh-seed.mjs
--
-- Website prices = source PDF price - USD 20 (owner's explicit pricing
-- rule), computed once outside this script and carried in the JSON above
-- as price_from (website) / price_from_source (PDF) — never recomputed
-- here. No new tables/columns — reuses nodes/providers/accommodations/
-- activities/packages/package_itinerary_* exactly as seeded by Tasks 5-11.

-- Provider
insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'maldives-fishing-and-holiday', 'Maldives Fishing and Holiday Pvt Ltd', 'Maldives Fishing and Holiday Pvt Ltd operates fishing charters and fishing holiday packages from Maamendhoo, Gaafu Alifu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id, website_url, contact_email, contact_phone, legal_name, license_number, is_verified)
select id, 'https://www.maldivesfishing.com/', 'safooh@maldivesfishing.com', '+960 7444509', 'Maldives Fishing and Holiday Pvt Ltd', 'C40602025', true
from nodes where node_type = 'provider' and slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

-- Accommodation (guesthouse)
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('accommodation', 'maldives-fishing-and-holidays-lodge', 'Maldives Fishing and Holidays Lodge', 'Maldives Fishing and Holidays Lodge is a guesthouse on Maamendhoo, Gaafu Alifu Atoll, run by Maldives Fishing and Holiday Pvt Ltd, offering full-board rooms for up to 2 guests alongside the operator''s own private fishing charters.', 'published', 'Maldives Fishing and Holidays Lodge | Maldives Guesthouses | MTG', 'Maldives Fishing and Holidays Lodge is a guesthouse on Maamendhoo, Gaafu Alifu Atoll, offering full-board rooms alongside private fishing charters.', now())
on conflict (node_type, slug) do nothing;

insert into accommodations (id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas)
select n.id, 'guesthouse', p.id, null, null, true, false from nodes n, nodes p where n.node_type = 'accommodation' and n.slug = 'maldives-fishing-and-holidays-lodge' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'accommodation' and n.slug = 'maldives-fishing-and-holidays-lodge' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'maldives-fishing-and-holidays-lodge'
on conflict (id) do nothing;

-- Charter activity: Private Full-Day Fishing Charter
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'private-full-day-fishing-charter', 'Private Full-Day Fishing Charter', 'Private Full-Day Fishing Charter is a private full-day fishing charter aboard "Emperor", a 32-foot fishing boat (Twin 200 HP outboard engines), departing from Maamendhoo, Gaafu Alifu Atoll. Operated by Maldives Fishing and Holiday Pvt Ltd. From USD 1380 per boat per full day (source rate USD 1400).', 'published', 'Private Full-Day Fishing Charter | Maldives Fishing | MTG', 'Private Full-Day Fishing Charter is a private full-day fishing charter aboard "Emperor", a 32-foot fishing boat (Twin 200 HP outboard engines), departing from Maamendhoo, Gaafu Alifu Atoll. Operated by Maldives Fishing and Holiday Pvt Ltd. From USD 1380 per boat per full day (source rate USD 1400).', now())
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency, max_participants)
select n.id, 'fishing', p.id, 480, 1380, 'USD', 5
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'private-full-day-fishing-charter' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'private-full-day-fishing-charter' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency, max_guests)
select id, 'inquiry', 1380, 'USD', 5 from nodes where node_type = 'activity' and slug = 'private-full-day-fishing-charter'
on conflict (id) do nothing;

-- Charter activity: Private Half-Day Fishing Charter
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'private-half-day-fishing-charter', 'Private Half-Day Fishing Charter', 'Private Half-Day Fishing Charter is a private half-day fishing charter aboard "Emperor", a 32-foot fishing boat (Twin 200 HP outboard engines), departing from Maamendhoo, Gaafu Alifu Atoll. Operated by Maldives Fishing and Holiday Pvt Ltd. From USD 980 per boat per half day (source rate USD 1000).', 'published', 'Private Half-Day Fishing Charter | Maldives Fishing | MTG', 'Private Half-Day Fishing Charter is a private half-day fishing charter aboard "Emperor", a 32-foot fishing boat (Twin 200 HP outboard engines), departing from Maamendhoo, Gaafu Alifu Atoll. Operated by Maldives Fishing and Holiday Pvt Ltd. From USD 980 per boat per half day (source rate USD 1000).', now())
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency, max_participants)
select n.id, 'fishing', p.id, 240, 980, 'USD', 5
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'private-half-day-fishing-charter' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'private-half-day-fishing-charter' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency, max_guests)
select id, 'inquiry', 980, 'USD', 5 from nodes where node_type = 'activity' and slug = 'private-half-day-fishing-charter'
on conflict (id) do nothing;

-- Package: 2-Night Maldives Fishing Package — Full-Day Fishing
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '2-night-maldives-fishing-package-full-day-fishing', '2-Night Maldives Fishing Package — Full-Day Fishing', '2-Night Maldives Fishing Package — Full-Day Fishing is a 2-night, 1-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and full-day private fishing charters. From USD 825 per person (5 guests sharing the boat (best value tier); source rate USD 845).', 'published', '2-Night Maldives Fishing Package — Full-Day Fishing | Maldives Fishing Packages | MTG', '2-Night Maldives Fishing Package — Full-Day Fishing is a 2-night, 1-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and full-day private fishing charters. From USD 825 per person (5 guests sharing the boat (best value tier); source rate USD 845).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 2, 825, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '2-night-maldives-fishing-package-full-day-fishing' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 825, 'USD' from nodes where node_type = 'package' and slug = '2-night-maldives-fishing-package-full-day-fishing'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '2-night-maldives-fishing-package-full-day-fishing' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '2-night-maldives-fishing-package-full-day-fishing' and c.node_type = 'category' and c.slug = 'custom'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '2-night-maldives-fishing-package-full-day-fishing' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 2, 2, 'Maldives Fishing and Holidays Lodge', '2 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll, with 1 day of full-day private fishing aboard "Emperor". Full-board meals, airport meet and greet, return domestic flight, and boat transfer included.', 1
from nodes where node_type = 'package' and slug = '2-night-maldives-fishing-package-full-day-fishing'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select '70e8815f-eea6-f634-81a4-c9b9a989b04d'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '2-night-maldives-fishing-package-full-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'dde555c5-b3a0-9b45-c69e-d2d6904ab39b'::uuid, s.id, 'node', comp.id, 'activity', 1, '1 day of fishing during the stay.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'private-full-day-fishing-charter'
where p.node_type = 'package' and p.slug = '2-night-maldives-fishing-package-full-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 3, 3, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '2-night-maldives-fishing-package-full-day-fishing'
on conflict (package_id, stage_number) do nothing;

-- Package: 3-Night Maldives Fishing Package — Full-Day Fishing
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '3-night-maldives-fishing-package-full-day-fishing', '3-Night Maldives Fishing Package — Full-Day Fishing', '3-Night Maldives Fishing Package — Full-Day Fishing is a 3-night, 2-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and full-day private fishing charters. From USD 1235 per person (5 guests sharing the boat (best value tier); source rate USD 1255).', 'published', '3-Night Maldives Fishing Package — Full-Day Fishing | Maldives Fishing Packages | MTG', '3-Night Maldives Fishing Package — Full-Day Fishing is a 3-night, 2-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and full-day private fishing charters. From USD 1235 per person (5 guests sharing the boat (best value tier); source rate USD 1255).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 3, 1235, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '3-night-maldives-fishing-package-full-day-fishing' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 1235, 'USD' from nodes where node_type = 'package' and slug = '3-night-maldives-fishing-package-full-day-fishing'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '3-night-maldives-fishing-package-full-day-fishing' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '3-night-maldives-fishing-package-full-day-fishing' and c.node_type = 'category' and c.slug = '3-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '3-night-maldives-fishing-package-full-day-fishing' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 3, 3, 'Maldives Fishing and Holidays Lodge', '3 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll, with 2 days of full-day private fishing aboard "Emperor". Full-board meals, airport meet and greet, return domestic flight, and boat transfer included.', 1
from nodes where node_type = 'package' and slug = '3-night-maldives-fishing-package-full-day-fishing'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select '4c15d56d-ca24-88d5-a6fa-2bb6a3e40dab'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '3-night-maldives-fishing-package-full-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'c67331c9-eb23-59de-a530-6856ec4e5a9f'::uuid, s.id, 'node', comp.id, 'activity', 2, '2 days of fishing during the stay.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'private-full-day-fishing-charter'
where p.node_type = 'package' and p.slug = '3-night-maldives-fishing-package-full-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 4, 4, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '3-night-maldives-fishing-package-full-day-fishing'
on conflict (package_id, stage_number) do nothing;

-- Package: 4-Night Maldives Fishing Package — Full-Day Fishing
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '4-night-maldives-fishing-package-full-day-fishing', '4-Night Maldives Fishing Package — Full-Day Fishing', '4-Night Maldives Fishing Package — Full-Day Fishing is a 4-night, 3-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and full-day private fishing charters. From USD 1620 per person (5 guests sharing the boat (best value tier); source rate USD 1640).', 'published', '4-Night Maldives Fishing Package — Full-Day Fishing | Maldives Fishing Packages | MTG', '4-Night Maldives Fishing Package — Full-Day Fishing is a 4-night, 3-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and full-day private fishing charters. From USD 1620 per person (5 guests sharing the boat (best value tier); source rate USD 1640).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 4, 1620, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '4-night-maldives-fishing-package-full-day-fishing' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 1620, 'USD' from nodes where node_type = 'package' and slug = '4-night-maldives-fishing-package-full-day-fishing'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '4-night-maldives-fishing-package-full-day-fishing' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '4-night-maldives-fishing-package-full-day-fishing' and c.node_type = 'category' and c.slug = '4-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '4-night-maldives-fishing-package-full-day-fishing' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 4, 4, 'Maldives Fishing and Holidays Lodge', '4 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll, with 3 days of full-day private fishing aboard "Emperor". Full-board meals, airport meet and greet, return domestic flight, and boat transfer included.', 1
from nodes where node_type = 'package' and slug = '4-night-maldives-fishing-package-full-day-fishing'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select '03ef0704-1839-4910-fc4f-50856e61d34a'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '4-night-maldives-fishing-package-full-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '75709fb7-fcce-47db-d4be-907da1e55142'::uuid, s.id, 'node', comp.id, 'activity', 3, '3 days of fishing during the stay.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'private-full-day-fishing-charter'
where p.node_type = 'package' and p.slug = '4-night-maldives-fishing-package-full-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 5, 5, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '4-night-maldives-fishing-package-full-day-fishing'
on conflict (package_id, stage_number) do nothing;

-- Package: 5-Night Maldives Fishing Package — Full-Day Fishing
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '5-night-maldives-fishing-package-full-day-fishing', '5-Night Maldives Fishing Package — Full-Day Fishing', '5-Night Maldives Fishing Package — Full-Day Fishing is a 5-night, 4-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and full-day private fishing charters. From USD 2005 per person (5 guests sharing the boat (best value tier); source rate USD 2025).', 'published', '5-Night Maldives Fishing Package — Full-Day Fishing | Maldives Fishing Packages | MTG', '5-Night Maldives Fishing Package — Full-Day Fishing is a 5-night, 4-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and full-day private fishing charters. From USD 2005 per person (5 guests sharing the boat (best value tier); source rate USD 2025).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 5, 2005, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '5-night-maldives-fishing-package-full-day-fishing' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 2005, 'USD' from nodes where node_type = 'package' and slug = '5-night-maldives-fishing-package-full-day-fishing'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '5-night-maldives-fishing-package-full-day-fishing' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '5-night-maldives-fishing-package-full-day-fishing' and c.node_type = 'category' and c.slug = '5-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '5-night-maldives-fishing-package-full-day-fishing' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 5, 5, 'Maldives Fishing and Holidays Lodge', '5 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll, with 4 days of full-day private fishing aboard "Emperor". Full-board meals, airport meet and greet, return domestic flight, and boat transfer included.', 1
from nodes where node_type = 'package' and slug = '5-night-maldives-fishing-package-full-day-fishing'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select 'b545e550-09c4-704f-8529-642c78b4a95a'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '5-night-maldives-fishing-package-full-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '263a10ae-3f5d-d71a-d05d-3959ce74e57f'::uuid, s.id, 'node', comp.id, 'activity', 4, '4 days of fishing during the stay.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'private-full-day-fishing-charter'
where p.node_type = 'package' and p.slug = '5-night-maldives-fishing-package-full-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 6, 6, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '5-night-maldives-fishing-package-full-day-fishing'
on conflict (package_id, stage_number) do nothing;

-- Package: 6-Night Maldives Fishing Package — Full-Day Fishing
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '6-night-maldives-fishing-package-full-day-fishing', '6-Night Maldives Fishing Package — Full-Day Fishing', '6-Night Maldives Fishing Package — Full-Day Fishing is a 6-night, 5-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and full-day private fishing charters. From USD 2390 per person (5 guests sharing the boat (best value tier); source rate USD 2410).', 'published', '6-Night Maldives Fishing Package — Full-Day Fishing | Maldives Fishing Packages | MTG', '6-Night Maldives Fishing Package — Full-Day Fishing is a 6-night, 5-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and full-day private fishing charters. From USD 2390 per person (5 guests sharing the boat (best value tier); source rate USD 2410).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 6, 2390, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '6-night-maldives-fishing-package-full-day-fishing' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 2390, 'USD' from nodes where node_type = 'package' and slug = '6-night-maldives-fishing-package-full-day-fishing'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '6-night-maldives-fishing-package-full-day-fishing' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '6-night-maldives-fishing-package-full-day-fishing' and c.node_type = 'category' and c.slug = 'custom'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '6-night-maldives-fishing-package-full-day-fishing' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 6, 6, 'Maldives Fishing and Holidays Lodge', '6 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll, with 5 days of full-day private fishing aboard "Emperor". Full-board meals, airport meet and greet, return domestic flight, and boat transfer included.', 1
from nodes where node_type = 'package' and slug = '6-night-maldives-fishing-package-full-day-fishing'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select 'c998439c-a2d8-8c46-1a12-7d90f7863d65'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '6-night-maldives-fishing-package-full-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '84c57d87-4063-0f08-baed-e9c5fa784fa1'::uuid, s.id, 'node', comp.id, 'activity', 5, '5 days of fishing during the stay.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'private-full-day-fishing-charter'
where p.node_type = 'package' and p.slug = '6-night-maldives-fishing-package-full-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 7, 7, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '6-night-maldives-fishing-package-full-day-fishing'
on conflict (package_id, stage_number) do nothing;

-- Package: 7-Night Maldives Fishing Package — Full-Day Fishing
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '7-night-maldives-fishing-package-full-day-fishing', '7-Night Maldives Fishing Package — Full-Day Fishing', '7-Night Maldives Fishing Package — Full-Day Fishing is a 7-night, 6-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and full-day private fishing charters. From USD 2750 per person (5 guests sharing the boat (best value tier); source rate USD 2770).', 'published', '7-Night Maldives Fishing Package — Full-Day Fishing | Maldives Fishing Packages | MTG', '7-Night Maldives Fishing Package — Full-Day Fishing is a 7-night, 6-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and full-day private fishing charters. From USD 2750 per person (5 guests sharing the boat (best value tier); source rate USD 2770).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 7, 2750, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '7-night-maldives-fishing-package-full-day-fishing' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 2750, 'USD' from nodes where node_type = 'package' and slug = '7-night-maldives-fishing-package-full-day-fishing'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '7-night-maldives-fishing-package-full-day-fishing' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '7-night-maldives-fishing-package-full-day-fishing' and c.node_type = 'category' and c.slug = '7-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '7-night-maldives-fishing-package-full-day-fishing' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 7, 7, 'Maldives Fishing and Holidays Lodge', '7 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll, with 6 days of full-day private fishing aboard "Emperor". Full-board meals, airport meet and greet, return domestic flight, and boat transfer included.', 1
from nodes where node_type = 'package' and slug = '7-night-maldives-fishing-package-full-day-fishing'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select '64977d59-3256-5051-cec4-c0aedaace8c9'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '7-night-maldives-fishing-package-full-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'fa86f9ec-dcba-d835-d563-9f36a9cef093'::uuid, s.id, 'node', comp.id, 'activity', 6, '6 days of fishing during the stay.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'private-full-day-fishing-charter'
where p.node_type = 'package' and p.slug = '7-night-maldives-fishing-package-full-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 8, 8, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '7-night-maldives-fishing-package-full-day-fishing'
on conflict (package_id, stage_number) do nothing;

-- Package: 8-Night Maldives Fishing Package — Full-Day Fishing
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '8-night-maldives-fishing-package-full-day-fishing', '8-Night Maldives Fishing Package — Full-Day Fishing', '8-Night Maldives Fishing Package — Full-Day Fishing is a 8-night, 7-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and full-day private fishing charters. From USD 3110 per person (5 guests sharing the boat (best value tier); source rate USD 3130).', 'published', '8-Night Maldives Fishing Package — Full-Day Fishing | Maldives Fishing Packages | MTG', '8-Night Maldives Fishing Package — Full-Day Fishing is a 8-night, 7-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and full-day private fishing charters. From USD 3110 per person (5 guests sharing the boat (best value tier); source rate USD 3130).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 8, 3110, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '8-night-maldives-fishing-package-full-day-fishing' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 3110, 'USD' from nodes where node_type = 'package' and slug = '8-night-maldives-fishing-package-full-day-fishing'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '8-night-maldives-fishing-package-full-day-fishing' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '8-night-maldives-fishing-package-full-day-fishing' and c.node_type = 'category' and c.slug = 'custom'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '8-night-maldives-fishing-package-full-day-fishing' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 8, 8, 'Maldives Fishing and Holidays Lodge', '8 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll, with 7 days of full-day private fishing aboard "Emperor". Full-board meals, airport meet and greet, return domestic flight, and boat transfer included.', 1
from nodes where node_type = 'package' and slug = '8-night-maldives-fishing-package-full-day-fishing'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select 'de7439ce-e60c-3aff-4859-1b4506d70882'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '8-night-maldives-fishing-package-full-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '2137028d-a9e1-bce1-c008-d87d89c72257'::uuid, s.id, 'node', comp.id, 'activity', 7, '7 days of fishing during the stay.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'private-full-day-fishing-charter'
where p.node_type = 'package' and p.slug = '8-night-maldives-fishing-package-full-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 9, 9, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '8-night-maldives-fishing-package-full-day-fishing'
on conflict (package_id, stage_number) do nothing;

-- Package: 2-Night Maldives Fishing Package — Half-Day Fishing
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '2-night-maldives-fishing-package-half-day-fishing', '2-Night Maldives Fishing Package — Half-Day Fishing', '2-Night Maldives Fishing Package — Half-Day Fishing is a 2-night, 1-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and half-day private fishing charters. From USD 765 per person (5 guests sharing the boat (best value tier); source rate USD 785).', 'published', '2-Night Maldives Fishing Package — Half-Day Fishing | Maldives Fishing Packages | MTG', '2-Night Maldives Fishing Package — Half-Day Fishing is a 2-night, 1-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and half-day private fishing charters. From USD 765 per person (5 guests sharing the boat (best value tier); source rate USD 785).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 2, 765, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '2-night-maldives-fishing-package-half-day-fishing' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 765, 'USD' from nodes where node_type = 'package' and slug = '2-night-maldives-fishing-package-half-day-fishing'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '2-night-maldives-fishing-package-half-day-fishing' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '2-night-maldives-fishing-package-half-day-fishing' and c.node_type = 'category' and c.slug = 'custom'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '2-night-maldives-fishing-package-half-day-fishing' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 2, 2, 'Maldives Fishing and Holidays Lodge', '2 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll, with 1 day of half-day private fishing aboard "Emperor". Full-board meals, airport meet and greet, return domestic flight, and boat transfer included.', 1
from nodes where node_type = 'package' and slug = '2-night-maldives-fishing-package-half-day-fishing'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select 'ab88a621-b118-504f-73a8-ff82e636ea9e'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '2-night-maldives-fishing-package-half-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '1a73825b-517f-1c1d-c09a-f88a251d1d03'::uuid, s.id, 'node', comp.id, 'activity', 1, '1 day of fishing during the stay.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'private-half-day-fishing-charter'
where p.node_type = 'package' and p.slug = '2-night-maldives-fishing-package-half-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 3, 3, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '2-night-maldives-fishing-package-half-day-fishing'
on conflict (package_id, stage_number) do nothing;

-- Package: 3-Night Maldives Fishing Package — Half-Day Fishing
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '3-night-maldives-fishing-package-half-day-fishing', '3-Night Maldives Fishing Package — Half-Day Fishing', '3-Night Maldives Fishing Package — Half-Day Fishing is a 3-night, 2-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and half-day private fishing charters. From USD 1025 per person (5 guests sharing the boat (best value tier); source rate USD 1045).', 'published', '3-Night Maldives Fishing Package — Half-Day Fishing | Maldives Fishing Packages | MTG', '3-Night Maldives Fishing Package — Half-Day Fishing is a 3-night, 2-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and half-day private fishing charters. From USD 1025 per person (5 guests sharing the boat (best value tier); source rate USD 1045).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 3, 1025, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '3-night-maldives-fishing-package-half-day-fishing' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 1025, 'USD' from nodes where node_type = 'package' and slug = '3-night-maldives-fishing-package-half-day-fishing'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '3-night-maldives-fishing-package-half-day-fishing' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '3-night-maldives-fishing-package-half-day-fishing' and c.node_type = 'category' and c.slug = '3-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '3-night-maldives-fishing-package-half-day-fishing' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 3, 3, 'Maldives Fishing and Holidays Lodge', '3 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll, with 2 days of half-day private fishing aboard "Emperor". Full-board meals, airport meet and greet, return domestic flight, and boat transfer included.', 1
from nodes where node_type = 'package' and slug = '3-night-maldives-fishing-package-half-day-fishing'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select '944e5da5-b50f-8086-5611-b5595a79ae69'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '3-night-maldives-fishing-package-half-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '1f9b59cc-247d-daaf-b853-b1628c9e3517'::uuid, s.id, 'node', comp.id, 'activity', 2, '2 days of fishing during the stay.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'private-half-day-fishing-charter'
where p.node_type = 'package' and p.slug = '3-night-maldives-fishing-package-half-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 4, 4, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '3-night-maldives-fishing-package-half-day-fishing'
on conflict (package_id, stage_number) do nothing;

-- Package: 4-Night Maldives Fishing Package — Half-Day Fishing
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '4-night-maldives-fishing-package-half-day-fishing', '4-Night Maldives Fishing Package — Half-Day Fishing', '4-Night Maldives Fishing Package — Half-Day Fishing is a 4-night, 3-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and half-day private fishing charters. From USD 1260 per person (5 guests sharing the boat (best value tier); source rate USD 1280).', 'published', '4-Night Maldives Fishing Package — Half-Day Fishing | Maldives Fishing Packages | MTG', '4-Night Maldives Fishing Package — Half-Day Fishing is a 4-night, 3-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and half-day private fishing charters. From USD 1260 per person (5 guests sharing the boat (best value tier); source rate USD 1280).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 4, 1260, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '4-night-maldives-fishing-package-half-day-fishing' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 1260, 'USD' from nodes where node_type = 'package' and slug = '4-night-maldives-fishing-package-half-day-fishing'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '4-night-maldives-fishing-package-half-day-fishing' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '4-night-maldives-fishing-package-half-day-fishing' and c.node_type = 'category' and c.slug = '4-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '4-night-maldives-fishing-package-half-day-fishing' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 4, 4, 'Maldives Fishing and Holidays Lodge', '4 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll, with 3 days of half-day private fishing aboard "Emperor". Full-board meals, airport meet and greet, return domestic flight, and boat transfer included.', 1
from nodes where node_type = 'package' and slug = '4-night-maldives-fishing-package-half-day-fishing'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select '9ac828f3-492e-2480-f2fa-6605bf201518'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '4-night-maldives-fishing-package-half-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '674d0025-b88d-58bb-0a9a-99cd30472348'::uuid, s.id, 'node', comp.id, 'activity', 3, '3 days of fishing during the stay.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'private-half-day-fishing-charter'
where p.node_type = 'package' and p.slug = '4-night-maldives-fishing-package-half-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 5, 5, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '4-night-maldives-fishing-package-half-day-fishing'
on conflict (package_id, stage_number) do nothing;

-- Package: 5-Night Maldives Fishing Package — Half-Day Fishing
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '5-night-maldives-fishing-package-half-day-fishing', '5-Night Maldives Fishing Package — Half-Day Fishing', '5-Night Maldives Fishing Package — Half-Day Fishing is a 5-night, 4-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and half-day private fishing charters. From USD 1495 per person (5 guests sharing the boat (best value tier); source rate USD 1515).', 'published', '5-Night Maldives Fishing Package — Half-Day Fishing | Maldives Fishing Packages | MTG', '5-Night Maldives Fishing Package — Half-Day Fishing is a 5-night, 4-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and half-day private fishing charters. From USD 1495 per person (5 guests sharing the boat (best value tier); source rate USD 1515).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 5, 1495, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '5-night-maldives-fishing-package-half-day-fishing' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 1495, 'USD' from nodes where node_type = 'package' and slug = '5-night-maldives-fishing-package-half-day-fishing'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '5-night-maldives-fishing-package-half-day-fishing' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '5-night-maldives-fishing-package-half-day-fishing' and c.node_type = 'category' and c.slug = '5-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '5-night-maldives-fishing-package-half-day-fishing' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 5, 5, 'Maldives Fishing and Holidays Lodge', '5 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll, with 4 days of half-day private fishing aboard "Emperor". Full-board meals, airport meet and greet, return domestic flight, and boat transfer included.', 1
from nodes where node_type = 'package' and slug = '5-night-maldives-fishing-package-half-day-fishing'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select '22f7010e-0977-3dbe-27a4-48ab63a513da'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '5-night-maldives-fishing-package-half-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'db6abe59-079a-896b-2f97-2a738f7d852f'::uuid, s.id, 'node', comp.id, 'activity', 4, '4 days of fishing during the stay.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'private-half-day-fishing-charter'
where p.node_type = 'package' and p.slug = '5-night-maldives-fishing-package-half-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 6, 6, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '5-night-maldives-fishing-package-half-day-fishing'
on conflict (package_id, stage_number) do nothing;

-- Package: 6-Night Maldives Fishing Package — Half-Day Fishing
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '6-night-maldives-fishing-package-half-day-fishing', '6-Night Maldives Fishing Package — Half-Day Fishing', '6-Night Maldives Fishing Package — Half-Day Fishing is a 6-night, 5-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and half-day private fishing charters. From USD 1730 per person (5 guests sharing the boat (best value tier); source rate USD 1750).', 'published', '6-Night Maldives Fishing Package — Half-Day Fishing | Maldives Fishing Packages | MTG', '6-Night Maldives Fishing Package — Half-Day Fishing is a 6-night, 5-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and half-day private fishing charters. From USD 1730 per person (5 guests sharing the boat (best value tier); source rate USD 1750).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 6, 1730, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '6-night-maldives-fishing-package-half-day-fishing' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 1730, 'USD' from nodes where node_type = 'package' and slug = '6-night-maldives-fishing-package-half-day-fishing'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '6-night-maldives-fishing-package-half-day-fishing' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '6-night-maldives-fishing-package-half-day-fishing' and c.node_type = 'category' and c.slug = 'custom'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '6-night-maldives-fishing-package-half-day-fishing' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 6, 6, 'Maldives Fishing and Holidays Lodge', '6 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll, with 5 days of half-day private fishing aboard "Emperor". Full-board meals, airport meet and greet, return domestic flight, and boat transfer included.', 1
from nodes where node_type = 'package' and slug = '6-night-maldives-fishing-package-half-day-fishing'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select 'fcc6cbc4-b049-3447-ef85-578ddd02abeb'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '6-night-maldives-fishing-package-half-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '511821aa-d917-ab8a-029b-346f01ef5038'::uuid, s.id, 'node', comp.id, 'activity', 5, '5 days of fishing during the stay.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'private-half-day-fishing-charter'
where p.node_type = 'package' and p.slug = '6-night-maldives-fishing-package-half-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 7, 7, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '6-night-maldives-fishing-package-half-day-fishing'
on conflict (package_id, stage_number) do nothing;

-- Package: 7-Night Maldives Fishing Package — Half-Day Fishing
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '7-night-maldives-fishing-package-half-day-fishing', '7-Night Maldives Fishing Package — Half-Day Fishing', '7-Night Maldives Fishing Package — Half-Day Fishing is a 7-night, 6-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and half-day private fishing charters. From USD 1940 per person (5 guests sharing the boat (best value tier); source rate USD 1960).', 'published', '7-Night Maldives Fishing Package — Half-Day Fishing | Maldives Fishing Packages | MTG', '7-Night Maldives Fishing Package — Half-Day Fishing is a 7-night, 6-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and half-day private fishing charters. From USD 1940 per person (5 guests sharing the boat (best value tier); source rate USD 1960).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 7, 1940, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '7-night-maldives-fishing-package-half-day-fishing' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 1940, 'USD' from nodes where node_type = 'package' and slug = '7-night-maldives-fishing-package-half-day-fishing'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '7-night-maldives-fishing-package-half-day-fishing' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '7-night-maldives-fishing-package-half-day-fishing' and c.node_type = 'category' and c.slug = '7-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '7-night-maldives-fishing-package-half-day-fishing' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 7, 7, 'Maldives Fishing and Holidays Lodge', '7 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll, with 6 days of half-day private fishing aboard "Emperor". Full-board meals, airport meet and greet, return domestic flight, and boat transfer included.', 1
from nodes where node_type = 'package' and slug = '7-night-maldives-fishing-package-half-day-fishing'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select '73e6cc59-7e26-a4fa-1ce0-87b41928da76'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '7-night-maldives-fishing-package-half-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'a09be7ef-0946-5399-4c18-80bdf03a2873'::uuid, s.id, 'node', comp.id, 'activity', 6, '6 days of fishing during the stay.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'private-half-day-fishing-charter'
where p.node_type = 'package' and p.slug = '7-night-maldives-fishing-package-half-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 8, 8, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '7-night-maldives-fishing-package-half-day-fishing'
on conflict (package_id, stage_number) do nothing;

-- Package: 8-Night Maldives Fishing Package — Half-Day Fishing
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '8-night-maldives-fishing-package-half-day-fishing', '8-Night Maldives Fishing Package — Half-Day Fishing', '8-Night Maldives Fishing Package — Half-Day Fishing is a 8-night, 7-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and half-day private fishing charters. From USD 2150 per person (5 guests sharing the boat (best value tier); source rate USD 2170).', 'published', '8-Night Maldives Fishing Package — Half-Day Fishing | Maldives Fishing Packages | MTG', '8-Night Maldives Fishing Package — Half-Day Fishing is a 8-night, 7-day fishing holiday at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation, return domestic flight, boat transfer, and half-day private fishing charters. From USD 2150 per person (5 guests sharing the boat (best value tier); source rate USD 2170).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 8, 2150, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '8-night-maldives-fishing-package-half-day-fishing' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 2150, 'USD' from nodes where node_type = 'package' and slug = '8-night-maldives-fishing-package-half-day-fishing'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '8-night-maldives-fishing-package-half-day-fishing' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '8-night-maldives-fishing-package-half-day-fishing' and c.node_type = 'category' and c.slug = 'custom'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '8-night-maldives-fishing-package-half-day-fishing' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 8, 8, 'Maldives Fishing and Holidays Lodge', '8 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll, with 7 days of half-day private fishing aboard "Emperor". Full-board meals, airport meet and greet, return domestic flight, and boat transfer included.', 1
from nodes where node_type = 'package' and slug = '8-night-maldives-fishing-package-half-day-fishing'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select '52ff5d65-d090-045a-32fb-9afe524c1598'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '8-night-maldives-fishing-package-half-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '6e4ca729-e626-fc6d-4dd4-6f4f787ef722'::uuid, s.id, 'node', comp.id, 'activity', 7, '7 days of fishing during the stay.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'private-half-day-fishing-charter'
where p.node_type = 'package' and p.slug = '8-night-maldives-fishing-package-half-day-fishing' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 9, 9, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '8-night-maldives-fishing-package-half-day-fishing'
on conflict (package_id, stage_number) do nothing;

