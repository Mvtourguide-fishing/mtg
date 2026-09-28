-- MTG: packages seed (Task 11).
-- GENERATED FILE — do not hand-edit. Source of truth:
--   data/maldives/packages/packages.json
--   data/maldives/packages/SOURCES.md
-- Regenerate with: node scripts/generate-package-seed.mjs
--
-- Idempotent. Package nodes use ON CONFLICT (node_type, slug) DO NOTHING as
-- usual. Stages use the schema's own (package_id, stage_number) unique
-- constraint. package_itinerary_items has no natural unique key, so each
-- item's id is a deterministic hash of (package, stage, sort_order, role) —
-- see this script's own header comment for why, mirroring Task 10's identical
-- transfer_services trick. Every referenced accommodation/activity/transfer
-- service must already exist (from Tasks 5-10) — nothing here creates new
-- entity data, only references it.

-- Package: 5-Night Maafushi Local Island Escape
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '5-night-maafushi-local-island-escape', '5-Night Maafushi Local Island Escape', 'A budget-friendly 5-night stay on Maafushi, a popular local island in Kaafu Atoll, combining a guesthouse-style hotel stay with a real diving session and a sunset fishing trip.', 'published', '5-Night Maafushi Local Island Escape | Maldives Packages | MTG', 'A budget-friendly 5-night stay on Maafushi, a popular local island in Kaafu Atoll, combining a guesthouse-style hotel stay with a real diving session and a sunset fishing trip.', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select id, 5, null, null, null
from nodes where node_type = 'package' and slug = '5-night-maafushi-local-island-escape'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'package' and slug = '5-night-maafushi-local-island-escape'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = '5-night-maafushi-local-island-escape'
  and c.node_type = 'category' and c.slug = 'budget'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = '5-night-maafushi-local-island-escape'
  and c.node_type = 'category' and c.slug = 'local-island'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = '5-night-maafushi-local-island-escape'
  and c.node_type = 'category' and c.slug = 'beach-holiday'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = '5-night-maafushi-local-island-escape'
  and c.node_type = 'category' and c.slug = '5-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'package' and n.slug = '5-night-maafushi-local-island-escape'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 5, 5, 'Maafushi', 'Five nights on Maafushi, one of the Maldives'' best-known local islands for independent, budget-conscious travel — public beaches, guesthouses, and easy access to reef diving and fishing trips.', 1
from nodes where node_type = 'package' and slug = '5-night-maafushi-local-island-escape'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, transfer_service_id, component_role, quantity, notes, sort_order)
select '6c60c67a-37c7-b8fe-740a-7ecec71f6de8'::uuid, s.id, 'transfer_service', '2e8c4b0d-2637-9ed9-ced8-e7a25dc12ea7'::uuid, 'transfer', 1, 'Arrival transfer, arranged directly through Kaani Beach Hotel.', 1
from package_itinerary_stages s
join nodes p on p.id = s.package_id
where p.node_type = 'package' and p.slug = '5-night-maafushi-local-island-escape' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '2ed15def-7e5a-653f-9940-2d31e8d8b178'::uuid, s.id, 'node', comp.id, 'accommodation', 1, null, 2
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'kaani-beach-hotel'
where p.node_type = 'package' and p.slug = '5-night-maafushi-local-island-escape' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'cb240d74-31e2-ebde-b703-dd914fbb2360'::uuid, s.id, 'node', comp.id, 'activity', 1, 'One single-tank dive, run by Maafushi Dive and Water Sports.', 3
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'activity' and comp.slug = 'fun-dive-single-tank'
where p.node_type = 'package' and p.slug = '5-night-maafushi-local-island-escape' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'ae60f271-d93f-5edf-c152-321e82d9ebc1'::uuid, s.id, 'node', comp.id, 'activity', 1, 'Sunset fishing trip, run by Kaani Hotels.', 4
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'activity' and comp.slug = 'sunset-fishing-trip-maafushi'
where p.node_type = 'package' and p.slug = '5-night-maafushi-local-island-escape' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 5, 5, 0, 'Departure', 'Return transfer to Velana International Airport for your onward flight. No specific return service is tracked in this dataset — arrange the return leg with Kaani Beach Hotel or a local operator on Maafushi.', 2
from nodes where node_type = 'package' and slug = '5-night-maafushi-local-island-escape'
on conflict (package_id, stage_number) do nothing;

-- Package: 7-Night Kurumba Resort Escape
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', '7-night-kurumba-resort-escape', '7-Night Kurumba Resort Escape', 'Seven nights at Kurumba Maldives, the country''s first resort, a short speedboat ride from Velana International Airport, with a PADI Open Water course and a sunset reef fishing trip.', 'published', '7-Night Kurumba Resort Escape | Maldives Packages | MTG', 'Seven nights at Kurumba Maldives, the country''s first resort, a short speedboat ride from Velana International Airport, with a PADI Open Water course and a sunset reef fishing trip.', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select id, 7, null, null, null
from nodes where node_type = 'package' and slug = '7-night-kurumba-resort-escape'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'package' and slug = '7-night-kurumba-resort-escape'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = '7-night-kurumba-resort-escape'
  and c.node_type = 'category' and c.slug = 'couple'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = '7-night-kurumba-resort-escape'
  and c.node_type = 'category' and c.slug = 'resort'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = '7-night-kurumba-resort-escape'
  and c.node_type = 'category' and c.slug = 'diving'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = '7-night-kurumba-resort-escape'
  and c.node_type = 'category' and c.slug = 'beach-holiday'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = '7-night-kurumba-resort-escape'
  and c.node_type = 'category' and c.slug = '7-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'package' and n.slug = '7-night-kurumba-resort-escape'
  and l.node_type = 'location' and l.slug = 'vihamanaafushi'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 7, 7, 'Kurumba Maldives', 'Seven nights at Kurumba Maldives on Vihamanaafushi island — one of the shortest resort transfers in the country at around 5 minutes by speedboat.', 1
from nodes where node_type = 'package' and slug = '7-night-kurumba-resort-escape'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, transfer_service_id, component_role, quantity, notes, sort_order)
select 'bea6fa8f-3f37-49c1-e928-ae069a53c7e6'::uuid, s.id, 'transfer_service', '9984e0c5-26c1-f89e-e184-fe77c528ef2b'::uuid, 'transfer', 1, null, 1
from package_itinerary_stages s
join nodes p on p.id = s.package_id
where p.node_type = 'package' and p.slug = '7-night-kurumba-resort-escape' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '65d7a464-3d66-d66f-6003-ce3921c9673e'::uuid, s.id, 'node', comp.id, 'accommodation', 1, null, 2
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'kurumba-maldives'
where p.node_type = 'package' and p.slug = '7-night-kurumba-resort-escape' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'c9bc1de7-b81b-d464-4167-77d4a49f2f71'::uuid, s.id, 'node', comp.id, 'activity', 1, 'Run by Euro-Divers Kurumba, the resort''s onsite dive centre.', 3
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'activity' and comp.slug = 'padi-open-water-diver-course-vihamanaafushi'
where p.node_type = 'package' and p.slug = '7-night-kurumba-resort-escape' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'f89838e7-019c-a671-f04b-f931fb1d888b'::uuid, s.id, 'node', comp.id, 'activity', 1, 'Run by Universal Resorts.', 4
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'activity' and comp.slug = 'sunset-reef-fishing'
where p.node_type = 'package' and p.slug = '7-night-kurumba-resort-escape' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 7, 7, 0, 'Departure', 'Return speedboat transfer to Velana International Airport. No specific return service is tracked in this dataset — arrange the return leg with Kurumba Maldives.', 2
from nodes where node_type = 'package' and slug = '7-night-kurumba-resort-escape'
on conflict (package_id, stage_number) do nothing;

-- Package: Maldives Honeymoon Escape — Soneva Fushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', 'maldives-honeymoon-escape-soneva-fushi', 'Maldives Honeymoon Escape — Soneva Fushi', 'Five nights at the all-inclusive Soneva Fushi in Baa Atoll, reached by shared seaplane, with a guided reef dive through the resort''s own dive centre.', 'published', 'Maldives Honeymoon Escape — Soneva Fushi | Maldives Packages | MTG', 'Five nights at the all-inclusive Soneva Fushi in Baa Atoll, reached by shared seaplane, with a guided reef dive through the resort''s own dive centre.', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select id, 5, null, null, null
from nodes where node_type = 'package' and slug = 'maldives-honeymoon-escape-soneva-fushi'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'package' and slug = 'maldives-honeymoon-escape-soneva-fushi'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-honeymoon-escape-soneva-fushi'
  and c.node_type = 'category' and c.slug = 'honeymoon'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-honeymoon-escape-soneva-fushi'
  and c.node_type = 'category' and c.slug = 'resort'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-honeymoon-escape-soneva-fushi'
  and c.node_type = 'category' and c.slug = 'romantic'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-honeymoon-escape-soneva-fushi'
  and c.node_type = 'category' and c.slug = 'beach-holiday'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-honeymoon-escape-soneva-fushi'
  and c.node_type = 'category' and c.slug = 'all-inclusive'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-honeymoon-escape-soneva-fushi'
  and c.node_type = 'category' and c.slug = '5-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'package' and n.slug = 'maldives-honeymoon-escape-soneva-fushi'
  and l.node_type = 'location' and l.slug = 'kunfunadhoo'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 5, 5, 'Soneva Fushi', 'Five all-inclusive nights at Soneva Fushi, Kunfunadhoo island, Baa Atoll — a UNESCO Biosphere Reserve — reached by the resort''s own shared seaplane transfer.', 1
from nodes where node_type = 'package' and slug = 'maldives-honeymoon-escape-soneva-fushi'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, transfer_service_id, component_role, quantity, notes, sort_order)
select '6353c49a-45d0-7222-7618-7a35949c136f'::uuid, s.id, 'transfer_service', '9f87ee9c-d98a-5cd5-c00c-fcbce174b99f'::uuid, 'transfer', 1, 'Seasonal fare — see the transfer route page for current pricing.', 1
from package_itinerary_stages s
join nodes p on p.id = s.package_id
where p.node_type = 'package' and p.slug = 'maldives-honeymoon-escape-soneva-fushi' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '4636168e-082a-dd06-0b92-ab3ad74be157'::uuid, s.id, 'node', comp.id, 'accommodation', 1, 'All-inclusive.', 2
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'soneva-fushi'
where p.node_type = 'package' and p.slug = 'maldives-honeymoon-escape-soneva-fushi' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'e6772330-3e71-3de8-ee86-ef7f123810b4'::uuid, s.id, 'node', comp.id, 'activity', 1, 'Run by Soleni Dive Center, the resort''s onsite dive centre.', 3
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'activity' and comp.slug = 'fun-dive'
where p.node_type = 'package' and p.slug = 'maldives-honeymoon-escape-soneva-fushi' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 5, 5, 0, 'Departure', 'Return seaplane transfer to Velana International Airport. No specific return service is tracked in this dataset — arrange the return leg with Soneva Fushi.', 2
from nodes where node_type = 'package' and slug = 'maldives-honeymoon-escape-soneva-fushi'
on conflict (package_id, stage_number) do nothing;

-- Package: Maldives Diving Holiday — Baros
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', 'maldives-diving-holiday-baros', 'Maldives Diving Holiday — Baros', 'Five nights at Baros Maldives with two real dives — a Discover Scuba Diving session and a fluorescence night dive — through the resort''s own long-established dive centre.', 'published', 'Maldives Diving Holiday — Baros | Maldives Packages | MTG', 'Five nights at Baros Maldives with two real dives — a Discover Scuba Diving session and a fluorescence night dive — through the resort''s own long-established dive centre.', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select id, 5, null, null, null
from nodes where node_type = 'package' and slug = 'maldives-diving-holiday-baros'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'package' and slug = 'maldives-diving-holiday-baros'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-diving-holiday-baros'
  and c.node_type = 'category' and c.slug = 'couple'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-diving-holiday-baros'
  and c.node_type = 'category' and c.slug = 'resort'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-diving-holiday-baros'
  and c.node_type = 'category' and c.slug = 'diving'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-diving-holiday-baros'
  and c.node_type = 'category' and c.slug = '5-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'package' and n.slug = 'maldives-diving-holiday-baros'
  and l.node_type = 'location' and l.slug = 'baros'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 5, 5, 'Baros Maldives', 'Five nights at Baros Maldives, Kaafu Atoll, home to Divers Baros Maldives, a long-established PADI Five Star Gold Palm dive centre.', 1
from nodes where node_type = 'package' and slug = 'maldives-diving-holiday-baros'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, transfer_service_id, component_role, quantity, notes, sort_order)
select '17409d50-29a0-e8ba-38f3-193fcbed7f91'::uuid, s.id, 'transfer_service', 'beaa2dfc-bdf2-f72a-090d-10e73abcc1fd'::uuid, 'transfer', 1, null, 1
from package_itinerary_stages s
join nodes p on p.id = s.package_id
where p.node_type = 'package' and p.slug = 'maldives-diving-holiday-baros' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'bb924160-9780-694c-ce5a-242eaad410fc'::uuid, s.id, 'node', comp.id, 'accommodation', 1, null, 2
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'baros-maldives'
where p.node_type = 'package' and p.slug = 'maldives-diving-holiday-baros' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'a3761ac4-d5ff-7405-3c80-9bfdd707d5a7'::uuid, s.id, 'node', comp.id, 'activity', 1, 'Run by Divers Baros Maldives.', 3
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'activity' and comp.slug = 'discover-scuba-diving'
where p.node_type = 'package' and p.slug = 'maldives-diving-holiday-baros' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'e4d97447-22d0-282b-2327-9554514418d9'::uuid, s.id, 'node', comp.id, 'activity', 1, 'A fluorescence night dive, run by Divers Baros Maldives.', 4
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'activity' and comp.slug = 'fluo-night-diving'
where p.node_type = 'package' and p.slug = 'maldives-diving-holiday-baros' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 5, 5, 0, 'Departure', 'Return speedboat transfer to Velana International Airport. No specific return service is tracked in this dataset — arrange the return leg with Baros Maldives.', 2
from nodes where node_type = 'package' and slug = 'maldives-diving-holiday-baros'
on conflict (package_id, stage_number) do nothing;

-- Package: Family Maldives Holiday — Velassaru
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', 'family-maldives-holiday-velassaru', 'Family Maldives Holiday — Velassaru', 'Seven nights at Velassaru Maldives with a Discover Scuba Diving session and a big game fishing trip — real activities bookable through the resort''s own operators.', 'published', 'Family Maldives Holiday — Velassaru | Maldives Packages | MTG', 'Seven nights at Velassaru Maldives with a Discover Scuba Diving session and a big game fishing trip — real activities bookable through the resort''s own operators.', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select id, 7, null, null, null
from nodes where node_type = 'package' and slug = 'family-maldives-holiday-velassaru'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'package' and slug = 'family-maldives-holiday-velassaru'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'family-maldives-holiday-velassaru'
  and c.node_type = 'category' and c.slug = 'family'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'family-maldives-holiday-velassaru'
  and c.node_type = 'category' and c.slug = 'resort'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'family-maldives-holiday-velassaru'
  and c.node_type = 'category' and c.slug = 'family-activities'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'family-maldives-holiday-velassaru'
  and c.node_type = 'category' and c.slug = '7-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'package' and n.slug = 'family-maldives-holiday-velassaru'
  and l.node_type = 'location' and l.slug = 'velassaru'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 7, 7, 'Velassaru Maldives', 'Seven nights at Velassaru Maldives, Kaafu Atoll. The resort''s airport transfer is mandatory and resort-operated (third-party transfers are not permitted).', 1
from nodes where node_type = 'package' and slug = 'family-maldives-holiday-velassaru'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, transfer_service_id, component_role, quantity, notes, sort_order)
select '30582cf8-2e68-deca-508e-946691a15a67'::uuid, s.id, 'transfer_service', '2de88296-2603-8e9c-ac9b-c64624b1dfa6'::uuid, 'transfer', 1, 'Mandatory resort transfer — flight details required at least 72 hours before arrival.', 1
from package_itinerary_stages s
join nodes p on p.id = s.package_id
where p.node_type = 'package' and p.slug = 'family-maldives-holiday-velassaru' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'c54296d6-de1e-27dc-1a4c-6f06a9585f31'::uuid, s.id, 'node', comp.id, 'accommodation', 1, null, 2
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'velassaru-maldives'
where p.node_type = 'package' and p.slug = 'family-maldives-holiday-velassaru' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '7bcb0b88-0094-31dd-bd6f-65bb878084dd'::uuid, s.id, 'node', comp.id, 'activity', 1, 'Run by Immersion Dive Centre, in the resort''s own lagoon.', 3
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'activity' and comp.slug = 'discover-scuba-diving-velassaru'
where p.node_type = 'package' and p.slug = 'family-maldives-holiday-velassaru' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select 'a8c9c5c3-60fd-fc85-f164-ca90d352fabc'::uuid, s.id, 'node', comp.id, 'activity', 1, 'Run by Universal Resorts.', 4
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'activity' and comp.slug = 'big-game-fishing-trip'
where p.node_type = 'package' and p.slug = 'family-maldives-holiday-velassaru' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 7, 7, 0, 'Departure', 'Return mandatory speedboat transfer to Velana International Airport. No specific return service is tracked in this dataset — arrange the return leg with Velassaru Maldives.', 2
from nodes where node_type = 'package' and slug = 'family-maldives-holiday-velassaru'
on conflict (package_id, stage_number) do nothing;

-- Package: Maldives Fishing & Island Hopping Package
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('package', 'maldives-fishing-island-hopping-package', 'Maldives Fishing & Island Hopping Package', 'A 4-night trip combining Malé and the local island of Maafushi, connected by the real MTCC public ferry network, with a night fishing trip on Maafushi.', 'published', 'Maldives Fishing & Island Hopping Package | Maldives Packages | MTG', 'A 4-night trip combining Malé and the local island of Maafushi, connected by the real MTCC public ferry network, with a night fishing trip on Maafushi.', now())
on conflict (node_type, slug) do nothing;

insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)
select id, 4, null, null, null
from nodes where node_type = 'package' and slug = 'maldives-fishing-island-hopping-package'
on conflict (id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'package' and slug = 'maldives-fishing-island-hopping-package'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-fishing-island-hopping-package'
  and c.node_type = 'category' and c.slug = 'group'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-fishing-island-hopping-package'
  and c.node_type = 'category' and c.slug = 'island-hopping'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-fishing-island-hopping-package'
  and c.node_type = 'category' and c.slug = 'fishing'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-fishing-island-hopping-package'
  and c.node_type = 'category' and c.slug = 'island-hopping-theme'
on conflict (node_id, category_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'package' and n.slug = 'maldives-fishing-island-hopping-package'
  and c.node_type = 'category' and c.slug = '4-nights'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'package' and n.slug = 'maldives-fishing-island-hopping-package'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'package' and n.slug = 'maldives-fishing-island-hopping-package'
  and l.node_type = 'location' and l.slug = 'male'
on conflict (node_id, location_id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 1, 1, 1, 0, 'Arrival — Malé', 'Arrive at Velana International Airport and take the airport ferry across to Malé for the day before continuing to Maafushi on the afternoon public ferry.', 1
from nodes where node_type = 'package' and slug = 'maldives-fishing-island-hopping-package'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, transfer_service_id, component_role, quantity, notes, sort_order)
select 'ade26891-fd1b-4666-2a86-94b76e092420'::uuid, s.id, 'transfer_service', '6ed4cc96-d8b1-e4ef-61a4-6ae306cbfdbb'::uuid, 'transfer', 1, null, 1
from package_itinerary_stages s
join nodes p on p.id = s.package_id
where p.node_type = 'package' and p.slug = 'maldives-fishing-island-hopping-package' and s.stage_number = 1
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 2, 1, 4, 3, 'Maafushi', 'Three nights on Maafushi, reached by the government-run MTCC public ferry (route 309) from Malé — departs Malé at 15:00, does not run on Fridays.', 2
from nodes where node_type = 'package' and slug = 'maldives-fishing-island-hopping-package'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, transfer_service_id, component_role, quantity, notes, sort_order)
select '53389762-b423-d32c-1d8c-5d73df293d59'::uuid, s.id, 'transfer_service', '0405b40e-74b8-f08d-cd41-09580acd2a6a'::uuid, 'transfer', 1, null, 1
from package_itinerary_stages s
join nodes p on p.id = s.package_id
where p.node_type = 'package' and p.slug = 'maldives-fishing-island-hopping-package' and s.stage_number = 2
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '20074293-e8f1-a7a7-2bcf-d1376906facf'::uuid, s.id, 'node', comp.id, 'accommodation', 1, null, 2
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'accommodation' and comp.slug = 'kaani-beach-hotel'
where p.node_type = 'package' and p.slug = 'maldives-fishing-island-hopping-package' and s.stage_number = 2
on conflict (id) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)
select '7b2bb621-7ffc-018f-9a6d-fcbe47a1ea8a'::uuid, s.id, 'node', comp.id, 'activity', 1, 'Run by iCom Tours.', 3
from package_itinerary_stages s
join nodes p on p.id = s.package_id
join nodes comp on comp.node_type = 'activity' and comp.slug = 'night-fishing-trip'
where p.node_type = 'package' and p.slug = 'maldives-fishing-island-hopping-package' and s.stage_number = 2
on conflict (id) do nothing;

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)
select id, 3, 4, 4, 0, 'Departure', 'Public ferry back to Malé, then onward to Velana International Airport for departure. The Malé-to-airport leg is not separately tracked in this dataset.', 3
from nodes where node_type = 'package' and slug = 'maldives-fishing-island-hopping-package'
on conflict (package_id, stage_number) do nothing;

insert into package_itinerary_items (id, stage_id, component_type, transfer_service_id, component_role, quantity, notes, sort_order)
select 'bd30ca8e-c98f-7e97-56dd-c6e4122a544c'::uuid, s.id, 'transfer_service', '48c46eb8-02db-8e19-be36-92e9b202d73b'::uuid, 'transfer', 1, null, 1
from package_itinerary_stages s
join nodes p on p.id = s.package_id
where p.node_type = 'package' and p.slug = 'maldives-fishing-island-hopping-package' and s.stage_number = 3
on conflict (id) do nothing;

