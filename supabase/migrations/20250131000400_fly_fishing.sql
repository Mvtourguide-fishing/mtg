-- Task 17 follow-up (site owner request): add a Fly Fishing charter and
-- two Fly Fishing Holiday packages. Same provider/boat/location as the
-- existing Private Full-Day/Half-Day charters (20250119000100), a new
-- distinct product at the site owner's stated prices (not from a PDF rate
-- sheet like the other MFH charters, so no "source rate" comparison is
-- claimed here). Fly fishing needs specialized tackle most guests won't
-- have on a general charter, so "included" deliberately does NOT list
-- "basic fishing gear" the way the general charters do.

-- Real photos the site owner uploaded directly for this feature
-- (assets/uploads/fishing/images/gallery/maldives-fly-fishing.jpeg and
-- maldives-fly-fishing-packages.jpeg) — media_assets ids/storage paths use
-- the exact same deterministicUuid("uploaded-media::" + relativePath) /
-- storagePathForUpload() scheme as scripts/attach-fishing-uploads.mjs, so
-- if that script (or attach-uploaded-media.mjs) is ever re-run over this
-- same gallery/ folder, it computes these identical ids and no-ops
-- instead of creating a duplicate row.
insert into media_assets (id, media_type, storage_path, alt_text) values ('df242384-66bf-6063-1664-5c69a9e14f73', 'image', 'uploads/assets/uploads/fishing/images/gallery/maldives-fly-fishing.jpeg', 'maldives fly fishing — Maldives fishing') on conflict (id) do nothing;
insert into media_assets (id, media_type, storage_path, alt_text) values ('0f934170-314e-c46a-d2e4-7899963d850f', 'image', 'uploads/assets/uploads/fishing/images/gallery/maldives-fly-fishing-packages.jpeg', 'maldives fly fishing packages — Maldives fishing') on conflict (id) do nothing;

-- Fly Fishing activity-type taxonomy tag, so it's filterable alongside the
-- existing big-game/sport/reef/handline/night/traditional types.
insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'fly-fishing', 'Fly Fishing', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'fly_fishing'::ltree from nodes where node_type = 'category' and slug = 'fly-fishing'
on conflict (id) do nothing;

-- Charter activity: Fly Fishing Full-Day Charter
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'fly-fishing-full-day-charter', 'Fly Fishing Full-Day Charter', 'Fly Fishing Full-Day Charter is a private full-day fly fishing charter aboard "Emperor", a 32-foot fishing boat (Twin 200 HP outboard engines), departing from Maamendhoo, Gaafu Alifu Atoll. Operated by Maldives Fishing and Holiday Pvt Ltd. From USD 1300 per boat per full day.', 'published', 'Fly Fishing Full-Day Charter | Maldives Fishing | MTG', 'Fly Fishing Full-Day Charter is a private full-day fly fishing charter aboard "Emperor", a 32-foot fishing boat (Twin 200 HP outboard engines), departing from Maamendhoo, Gaafu Alifu Atoll. Operated by Maldives Fishing and Holiday Pvt Ltd. From USD 1300 per boat per full day.', now())
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency, max_participants)
select n.id, 'fishing', p.id, 480, 1300, 'USD', 5
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'fly-fishing-full-day-charter' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'fly-fishing-full-day-charter' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency, max_guests)
select id, 'inquiry', 1300, 'USD', 5 from nodes where node_type = 'activity' and slug = 'fly-fishing-full-day-charter'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'activity' and n.slug = 'fly-fishing-full-day-charter' and c.node_type = 'category' and c.slug = 'fly-fishing'
on conflict (node_id, category_id) do nothing;

insert into node_media (node_id, media_id, role, sort_order)
select id, 'df242384-66bf-6063-1664-5c69a9e14f73', 'hero', 0 from nodes where node_type = 'activity' and slug = 'fly-fishing-full-day-charter'
on conflict (node_id, media_id, role) do nothing;

-- Charter activity: Fly Fishing Half-Day Charter
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'fly-fishing-half-day-charter', 'Fly Fishing Half-Day Charter', 'Fly Fishing Half-Day Charter is a private half-day fly fishing charter aboard "Emperor", a 32-foot fishing boat (Twin 200 HP outboard engines), departing from Maamendhoo, Gaafu Alifu Atoll. Operated by Maldives Fishing and Holiday Pvt Ltd. From USD 800 per boat per half day.', 'published', 'Fly Fishing Half-Day Charter | Maldives Fishing | MTG', 'Fly Fishing Half-Day Charter is a private half-day fly fishing charter aboard "Emperor", a 32-foot fishing boat (Twin 200 HP outboard engines), departing from Maamendhoo, Gaafu Alifu Atoll. Operated by Maldives Fishing and Holiday Pvt Ltd. From USD 800 per boat per half day.', now())
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency, max_participants)
select n.id, 'fishing', p.id, 240, 800, 'USD', 5
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'fly-fishing-half-day-charter' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'fly-fishing-half-day-charter' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency, max_guests)
select id, 'inquiry', 800, 'USD', 5 from nodes where node_type = 'activity' and slug = 'fly-fishing-half-day-charter'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'activity' and n.slug = 'fly-fishing-half-day-charter' and c.node_type = 'category' and c.slug = 'fly-fishing'
on conflict (node_id, category_id) do nothing;

insert into node_media (node_id, media_id, role, sort_order)
select id, 'df242384-66bf-6063-1664-5c69a9e14f73', 'hero', 0 from nodes where node_type = 'activity' and slug = 'fly-fishing-half-day-charter'
on conflict (node_id, media_id, role) do nothing;

-- Package: 3-Night Maldives Fly Fishing Holiday
-- Price is per person, flight + food + accommodation only (USD 400 return
-- domestic flight + USD 75/night food & accommodation, per the site
-- owner's own figures) — unlike the sibling MFH fishing packages, this
-- does NOT fold a shared-boat fishing rate into the headline price, since
-- no guest-sharing tier for the new fly fishing charter was given. Fly
-- fishing (linked below) is a real add-on booked and paid separately,
-- not a fabricated inclusion.
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '3-night-maldives-fly-fishing-holiday', '3-Night Maldives Fly Fishing Holiday', '3-Night Maldives Fly Fishing Holiday is a 3-night stay at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation and a return domestic flight. From USD 625 per person (accommodation and flight only — fly fishing charters are booked and paid separately, per boat, shared among your own group).', 'published', '3-Night Maldives Fly Fishing Holiday | Maldives Fishing Packages | MTG', '3-Night Maldives Fly Fishing Holiday is a 3-night stay at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation and a return domestic flight. From USD 625 per person (accommodation and flight only — fly fishing charters are booked and paid separately, per boat, shared among your own group).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 3, 625, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '3-night-maldives-fly-fishing-holiday' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 625, 'USD' from nodes where node_type = 'package' and slug = '3-night-maldives-fly-fishing-holiday'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '3-night-maldives-fly-fishing-holiday' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '3-night-maldives-fly-fishing-holiday' and c.node_type = 'category' and c.slug = '3-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '3-night-maldives-fly-fishing-holiday' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 3, 3, 'Maldives Fishing and Holidays Lodge', '3 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll. Full-board meals, airport meet and greet, and return domestic flight included. Add up to 2 days of fly fishing during your stay — booked separately, from USD 1300/day (full-day) or USD 800/day (half-day) per boat, shared among your own group.', 1
from nodes where node_type = 'package' and slug = '3-night-maldives-fly-fishing-holiday'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select 'cc4d8478-c989-48ec-a44c-9094811d0b7b'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '3-night-maldives-fly-fishing-holiday' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'fb90741c-7136-4310-8b93-da2743afdb92'::uuid, s.id, 'node', comp.id, 'activity', 2, 'Optional add-on, booked and paid separately — not included in the package price above.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'fly-fishing-full-day-charter'
where p.node_type = 'package' and p.slug = '3-night-maldives-fly-fishing-holiday' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 4, 4, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '3-night-maldives-fly-fishing-holiday'
on conflict (package_id, stage_number) do nothing;

-- Package: 5-Night Maldives Fly Fishing Holiday
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '5-night-maldives-fly-fishing-holiday', '5-Night Maldives Fly Fishing Holiday', '5-Night Maldives Fly Fishing Holiday is a 5-night stay at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation and a return domestic flight. From USD 775 per person (accommodation and flight only — fly fishing charters are booked and paid separately, per boat, shared among your own group).', 'published', '5-Night Maldives Fly Fishing Holiday | Maldives Fishing Packages | MTG', '5-Night Maldives Fly Fishing Holiday is a 5-night stay at Maldives Fishing and Holidays Lodge on Maamendhoo, Gaafu Alifu Atoll, including full-board accommodation and a return domestic flight. From USD 775 per person (accommodation and flight only — fly fishing charters are booked and paid separately, per boat, shared among your own group).', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select n.id, 5, 775, 'USD', p.id from nodes n, nodes p where n.node_type = 'package' and n.slug = '5-night-maldives-fly-fishing-holiday' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 775, 'USD' from nodes where node_type = 'package' and slug = '5-night-maldives-fly-fishing-holiday'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '5-night-maldives-fly-fishing-holiday' and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'package' and n.slug = '5-night-maldives-fly-fishing-holiday' and c.node_type = 'category' and c.slug = '5-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'package' and n.slug = '5-night-maldives-fly-fishing-holiday' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 5, 5, 'Maldives Fishing and Holidays Lodge', '5 nights at Maldives Fishing and Holidays Lodge, Maamendhoo, Gaafu Alifu Atoll. Full-board meals, airport meet and greet, and return domestic flight included. Add up to 4 days of fly fishing during your stay — booked separately, from USD 1300/day (full-day) or USD 800/day (half-day) per boat, shared among your own group.', 1
from nodes where node_type = 'package' and slug = '5-night-maldives-fly-fishing-holiday'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, sort_order)
select '244f1191-1e0c-4c99-9c27-8cc7155997fb'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 0
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'maldives-fishing-and-holidays-lodge'
where p.node_type = 'package' and p.slug = '5-night-maldives-fly-fishing-holiday' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '6baa17b8-fb1d-47dc-8f3f-19f2798f5242'::uuid, s.id, 'node', comp.id, 'activity', 4, 'Optional add-on, booked and paid separately — not included in the package price above.', 1
from package_itinerary_stages s join nodes p on p.id = s.package_id join nodes comp on comp.node_type = 'activity' and comp.slug = 'fly-fishing-full-day-charter'
where p.node_type = 'package' and p.slug = '5-night-maldives-fly-fishing-holiday' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 6, 6, 0, 'Departure', 'Boat transfer to the domestic airport and return domestic flight to Velana International Airport, timed around the guest''s international flight.', 2
from nodes where node_type = 'package' and slug = '5-night-maldives-fly-fishing-holiday'
on conflict (package_id, stage_number) do nothing;
