-- MTG: transfers seed (Task 10).
-- GENERATED FILE — do not hand-edit. Source of truth:
--   data/maldives/transfers/routes.json
--   data/maldives/transfers/schedules.json
--   data/maldives/transfers/SOURCES.md
-- Regenerate with: node scripts/generate-transfer-seed.mjs
--
-- Idempotent. Node-backed rows (the airport location, each transfer_routes
-- node) use ON CONFLICT (node_type, slug) DO NOTHING as usual. transfer_services
-- has no natural unique key, so each service's id is a deterministic hash of a
-- stable (route, operator, product) key instead of a fresh random uuid — see
-- this script's own header comment for why. transfer_service_schedules uses the
-- schema's own real unique constraint (transfer_service_id, day_of_week,
-- departure_time). transfer_services are NEVER inserted into bookable_products —
-- they are not nodes; see src/lib/transfers/repository.ts's header comment for
-- how they connect to booking instead (bookings.transfer_service_id, already
-- built in Task 2/3, unchanged here).

-- New location: the one airport this task's brief allows (Hulhulé, the real
-- island Velana International Airport sits on, is uninhabited and was
-- deliberately excluded from the Task 4 islands dataset).
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'velana-international-airport', 'Velana International Airport', 'Velana International Airport is the Maldives'' main international gateway airport.', 'published', 'Velana International Airport | Maldives Transfers | MTG', 'Velana International Airport is the Maldives'' main international gateway airport.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'airport', p.id, (p_loc.path || 'velana_international_airport'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'velana-international-airport'
  and p.node_type = 'location' and p.slug = 'male-city'
on conflict (id) do nothing;

-- Providers (reused from Task 5/6/7/8/9 where the name matches exactly, else new)
insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'maldives-transport-and-contracting-company-mtcc', 'Maldives Transport and Contracting Company (MTCC)', 'Maldives Transport and Contracting Company (MTCC) operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'maldives-transport-and-contracting-company-mtcc'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'maldives-ports-limited-mpl', 'Maldives Ports Limited (MPL)', 'Maldives Ports Limited (MPL) operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'maldives-ports-limited-mpl'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'universal-resorts', 'Universal Resorts', 'Universal Resorts operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'universal-resorts'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'baros-maldives', 'Baros Maldives', 'Baros Maldives operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'baros-maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'gili-lankanfushi', 'Gili Lankanfushi', 'Gili Lankanfushi operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'gili-lankanfushi'
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

-- Transfer routes (directional) and their services
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('transfer_route', 'male-to-maafushi', 'Malé to Maafushi', 'Transfer route from Malé to Maafushi.', 'published', 'Malé to Maafushi Transfers | Maldives Tour Guide', 'Transfer route from Malé to Maafushi.', now())
on conflict (node_type, slug) do nothing;

insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)
select n.id, o.id, d.id, 27, 90
from nodes n, nodes o, nodes d
where n.node_type = 'transfer_route' and n.slug = 'male-to-maafushi'
  and o.node_type = 'location' and o.slug = 'male'
  and d.node_type = 'location' and d.slug = 'maafushi'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  '0405b40e-74b8-f08d-cd41-09580acd2a6a'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'male-to-maafushi'),
  (select id from nodes where node_type = 'provider' and slug = 'maldives-transport-and-contracting-company-mtcc'),
  'ferry', 'Passenger ferry', 'shared',
  90, 22, 'MVR', null,
  null, 'active',
  'Departs from the MTCC public ferry terminal in Malé (route 309, via Gulhi and Guraidhoo). Tickets are cash-only, bought at the terminal counter before departure; no online booking.', 'Arrives at the public jetty on Maafushi island.',
  'No advance booking; arrive at least 15 minutes before the scheduled departure. Does not run on Fridays.', null,
  'The government-run MTCC public ferry linking Malé to the popular local-tourism island of Maafushi, Kaafu Atoll, on route 309.'
on conflict (id) do nothing;

insert into transfer_service_schedules (
  transfer_service_id, day_of_week, departure_time, arrival_time, duration_minutes, status
)
values ('0405b40e-74b8-f08d-cd41-09580acd2a6a'::uuid, null, '15:00', null, 90, 'active')
on conflict (transfer_service_id, day_of_week, departure_time) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('transfer_route', 'maafushi-to-male', 'Maafushi to Malé', 'Transfer route from Maafushi to Malé.', 'published', 'Maafushi to Malé Transfers | Maldives Tour Guide', 'Transfer route from Maafushi to Malé.', now())
on conflict (node_type, slug) do nothing;

insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)
select n.id, o.id, d.id, 27, 90
from nodes n, nodes o, nodes d
where n.node_type = 'transfer_route' and n.slug = 'maafushi-to-male'
  and o.node_type = 'location' and o.slug = 'maafushi'
  and d.node_type = 'location' and d.slug = 'male'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  '48c46eb8-02db-8e19-be36-92e9b202d73b'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'maafushi-to-male'),
  (select id from nodes where node_type = 'provider' and slug = 'maldives-transport-and-contracting-company-mtcc'),
  'ferry', 'Passenger ferry', 'shared',
  90, 22, 'MVR', null,
  null, 'active',
  'Departs from the public jetty on Maafushi island.', 'Arrives at the MTCC public ferry terminal in Malé.',
  'No advance booking; cash-only ticket bought at the jetty. Does not run on Fridays.', null,
  'The return leg of the government-run MTCC public ferry between Maafushi (Kaafu Atoll) and Malé, route 309.'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('transfer_route', 'male-to-guraidhoo', 'Malé to Guraidhoo', 'Transfer route from Malé to Guraidhoo.', 'published', 'Malé to Guraidhoo Transfers | Maldives Tour Guide', 'Transfer route from Malé to Guraidhoo.', now())
on conflict (node_type, slug) do nothing;

insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)
select n.id, o.id, d.id, null, 135
from nodes n, nodes o, nodes d
where n.node_type = 'transfer_route' and n.slug = 'male-to-guraidhoo'
  and o.node_type = 'location' and o.slug = 'male'
  and d.node_type = 'location' and d.slug = 'guraidhoo'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  '256e6307-2009-dff8-1591-c901886a6ea3'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'male-to-guraidhoo'),
  (select id from nodes where node_type = 'provider' and slug = 'maldives-transport-and-contracting-company-mtcc'),
  'ferry', 'Passenger ferry', 'shared',
  135, 22, 'MVR', null,
  null, 'active',
  'Departs from the MTCC public ferry terminal in Malé, route 309 (via Gulhi, continuing to Guraidhoo).', 'Arrives at the public jetty on Guraidhoo island, Kaafu Atoll (distinct from the same-named island in Thaa Atoll).',
  'No advance booking; cash-only ticket at the terminal. Does not run on Fridays.', null,
  'The MTCC public ferry (route 309) from Malé to Guraidhoo, Kaafu Atoll — a 2 hour 15 minute run.'
on conflict (id) do nothing;

insert into transfer_service_schedules (
  transfer_service_id, day_of_week, departure_time, arrival_time, duration_minutes, status
)
values ('256e6307-2009-dff8-1591-c901886a6ea3'::uuid, null, '15:00', null, 135, 'active')
on conflict (transfer_service_id, day_of_week, departure_time) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('transfer_route', 'guraidhoo-to-male', 'Guraidhoo to Malé', 'Transfer route from Guraidhoo to Malé.', 'published', 'Guraidhoo to Malé Transfers | Maldives Tour Guide', 'Transfer route from Guraidhoo to Malé.', now())
on conflict (node_type, slug) do nothing;

insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)
select n.id, o.id, d.id, null, 135
from nodes n, nodes o, nodes d
where n.node_type = 'transfer_route' and n.slug = 'guraidhoo-to-male'
  and o.node_type = 'location' and o.slug = 'guraidhoo'
  and d.node_type = 'location' and d.slug = 'male'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  '3318e021-38cc-81e6-e0dd-0a0ce43b7c41'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'guraidhoo-to-male'),
  (select id from nodes where node_type = 'provider' and slug = 'maldives-transport-and-contracting-company-mtcc'),
  'ferry', 'Passenger ferry', 'shared',
  135, 22, 'MVR', null,
  null, 'active',
  'Departs from the public jetty on Guraidhoo island, Kaafu Atoll, Saturday–Thursday at approximately 07:00.', 'Arrives at the MTCC public ferry terminal in Malé.',
  'No advance booking; cash-only ticket. Does not run on Fridays.', null,
  'The return leg of the MTCC route-309 public ferry, Guraidhoo to Malé.'
on conflict (id) do nothing;

insert into transfer_service_schedules (
  transfer_service_id, day_of_week, departure_time, arrival_time, duration_minutes, status
)
values ('3318e021-38cc-81e6-e0dd-0a0ce43b7c41'::uuid, null, '07:00', null, 135, 'active')
on conflict (transfer_service_id, day_of_week, departure_time) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('transfer_route', 'male-to-himmafushi', 'Malé to Himmafushi', 'Transfer route from Malé to Himmafushi.', 'published', 'Malé to Himmafushi Transfers | Maldives Tour Guide', 'Transfer route from Malé to Himmafushi.', now())
on conflict (node_type, slug) do nothing;

insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)
select n.id, o.id, d.id, null, 40
from nodes n, nodes o, nodes d
where n.node_type = 'transfer_route' and n.slug = 'male-to-himmafushi'
  and o.node_type = 'location' and o.slug = 'male'
  and d.node_type = 'location' and d.slug = 'himmafushi'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  '36e368a3-b6a6-9f16-3c0c-74dfc2882d8e'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'male-to-himmafushi'),
  (select id from nodes where node_type = 'provider' and slug = 'maldives-transport-and-contracting-company-mtcc'),
  'ferry', 'Passenger ferry', 'shared',
  40, 2, 'USD', null,
  null, 'active',
  'Departs from the MTCC public ferry terminal in Malé, route 308, daily except Friday at 14:30.', 'Arrives at the public jetty on Himmafushi island, Kaafu Atoll, at approximately 15:10.',
  'No advance booking; cash-only ticket at the terminal. Does not run on Fridays.', null,
  'The MTCC public ferry (route 308, which also continues to Huraa, Thulusdhoo and Dhiffushi) from Malé to Himmafushi, Kaafu Atoll.'
on conflict (id) do nothing;

insert into transfer_service_schedules (
  transfer_service_id, day_of_week, departure_time, arrival_time, duration_minutes, status
)
values ('36e368a3-b6a6-9f16-3c0c-74dfc2882d8e'::uuid, null, '14:30', '15:10', 40, 'active')
on conflict (transfer_service_id, day_of_week, departure_time) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('transfer_route', 'velana-international-airport-to-male', 'Velana International Airport to Malé', 'Transfer route from Velana International Airport to Malé.', 'published', 'Velana International Airport to Malé Transfers | Maldives Tour Guide', 'Transfer route from Velana International Airport to Malé.', now())
on conflict (node_type, slug) do nothing;

insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)
select n.id, o.id, d.id, 2, 10
from nodes n, nodes o, nodes d
where n.node_type = 'transfer_route' and n.slug = 'velana-international-airport-to-male'
  and o.node_type = 'location' and o.slug = 'velana-international-airport'
  and d.node_type = 'location' and d.slug = 'male'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  '6ed4cc96-d8b1-e4ef-61a4-6ae306cbfdbb'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'velana-international-airport-to-male'),
  (select id from nodes where node_type = 'provider' and slug = 'maldives-transport-and-contracting-company-mtcc'),
  'ferry', 'Passenger ferry', 'shared',
  10, 15, 'MVR', null,
  'Up to 3 pieces of luggage free per passenger; an extra ticket must be purchased for each additional piece.', 'active',
  'Ferry jetty adjacent to the arrivals area at Velana International Airport, on Hulhulé island.', 'Arrives at the Malé ferry terminal, a short walk from the city centre.',
  'No booking; buy a ticket at the jetty booth in cash (MVR or USD generally accepted) and board the next departure.', null,
  'The short public ferry shuttle connecting Velana International Airport (on the uninhabited island of Hulhulé, administratively part of Malé City) directly to Malé island.'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('transfer_route', 'male-to-hulhumale', 'Malé to Hulhumalé', 'Transfer route from Malé to Hulhumalé.', 'published', 'Malé to Hulhumalé Transfers | Maldives Tour Guide', 'Transfer route from Malé to Hulhumalé.', now())
on conflict (node_type, slug) do nothing;

insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)
select n.id, o.id, d.id, null, null
from nodes n, nodes o, nodes d
where n.node_type = 'transfer_route' and n.slug = 'male-to-hulhumale'
  and o.node_type = 'location' and o.slug = 'male'
  and d.node_type = 'location' and d.slug = 'hulhumale'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  '4930cd75-9c8c-299c-bf3e-28195bfa4207'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'male-to-hulhumale'),
  (select id from nodes where node_type = 'provider' and slug = 'maldives-ports-limited-mpl'),
  'land_transfer', 'Public bus', 'shared',
  null, 10, 'MVR', null,
  null, 'active',
  'Bus terminus in Malé; the route crosses the Sinamalé Bridge via Hulhulé (the airport island).', 'Bus terminus in Hulhumalé.',
  'Fare paid via a rechargeable bus card, purchasable at the ferry terminal/bus terminus in Malé or Hulhumalé; cash is not accepted on board per the sourced report.', null,
  'The public bus service across the Sinamalé Bridge connecting Malé, the airport island of Hulhulé, and the reclaimed suburb of Hulhumalé — the land-based alternative to the ferry.'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('transfer_route', 'velana-international-airport-to-vihamanaafushi', 'Velana International Airport to Vihamanaafushi', 'Transfer route from Velana International Airport to Vihamanaafushi.', 'published', 'Velana International Airport to Vihamanaafushi Transfers | Maldives Tour Guide', 'Transfer route from Velana International Airport to Vihamanaafushi.', now())
on conflict (node_type, slug) do nothing;

insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)
select n.id, o.id, d.id, null, 5
from nodes n, nodes o, nodes d
where n.node_type = 'transfer_route' and n.slug = 'velana-international-airport-to-vihamanaafushi'
  and o.node_type = 'location' and o.slug = 'velana-international-airport'
  and d.node_type = 'location' and d.slug = 'vihamanaafushi'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  '9984e0c5-26c1-f89e-e184-fe77c528ef2b'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'velana-international-airport-to-vihamanaafushi'),
  (select id from nodes where node_type = 'provider' and slug = 'universal-resorts'),
  'speedboat', 'Speedboat', 'shared',
  5, 49.5, 'USD', null,
  null, 'active',
  'Kurumba resort representative meets guests in the arrivals hall at Velana International Airport.', 'Kurumba Maldives jetty, Vihamanaafushi island, Kaafu Atoll — one of the shortest resort transfers in the Maldives.',
  'Arranged through Kurumba Maldives'' own resort-information/transfer booking channel.', null,
  'Kurumba Maldives'' own shared speedboat transfer from Velana International Airport, a roughly 5-minute crossing to the country''s first resort island.'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('transfer_route', 'velana-international-airport-to-baros', 'Velana International Airport to Baros', 'Transfer route from Velana International Airport to Baros.', 'published', 'Velana International Airport to Baros Transfers | Maldives Tour Guide', 'Transfer route from Velana International Airport to Baros.', now())
on conflict (node_type, slug) do nothing;

insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)
select n.id, o.id, d.id, null, 25
from nodes n, nodes o, nodes d
where n.node_type = 'transfer_route' and n.slug = 'velana-international-airport-to-baros'
  and o.node_type = 'location' and o.slug = 'velana-international-airport'
  and d.node_type = 'location' and d.slug = 'baros'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  'beaa2dfc-bdf2-f72a-090d-10e73abcc1fd'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'velana-international-airport-to-baros'),
  (select id from nodes where node_type = 'provider' and slug = 'baros-maldives'),
  'speedboat', 'Speedboat', 'shared',
  25, 260, 'USD', null,
  null, 'active',
  'Baros representative meets guests at Velana International Airport; transfer timing is arranged around guests'' international flight times.', 'Baros Maldives jetty, Baros island, Kaafu Atoll.',
  'Coordinated with the resort in advance around guest flight details; complimentary return transfer is offered for certain half-board bookings of 3+ nights per the source.', null,
  'Baros Maldives'' own shared, resort-scheduled speedboat transfer from Velana International Airport, a 25-minute crossing.'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('transfer_route', 'velana-international-airport-to-velassaru', 'Velana International Airport to Velassaru', 'Transfer route from Velana International Airport to Velassaru.', 'published', 'Velana International Airport to Velassaru Transfers | Maldives Tour Guide', 'Transfer route from Velana International Airport to Velassaru.', now())
on conflict (node_type, slug) do nothing;

insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)
select n.id, o.id, d.id, null, 25
from nodes n, nodes o, nodes d
where n.node_type = 'transfer_route' and n.slug = 'velana-international-airport-to-velassaru'
  and o.node_type = 'location' and o.slug = 'velana-international-airport'
  and d.node_type = 'location' and d.slug = 'velassaru'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  '2de88296-2603-8e9c-ac9b-c64624b1dfa6'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'velana-international-airport-to-velassaru'),
  (select id from nodes where node_type = 'provider' and slug = 'universal-resorts'),
  'speedboat', 'Speedboat', 'private',
  25, 187, 'USD', null,
  null, 'active',
  'Velassaru resort representative meets guests at Velana International Airport; guests must send flight details at least 72 hours ahead to guarantee the transfer.', 'Velassaru Maldives jetty, Velassaru island, Kaafu Atoll.',
  'Mandatory resort-operated transfer — third-party transfer arrangement is not permitted per the source; flight details required at least 72 hours before arrival.', null,
  'Velassaru Maldives'' own mandatory speedboat transfer from Velana International Airport, a 25-minute crossing.'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('transfer_route', 'velana-international-airport-to-lankanfushi', 'Velana International Airport to Lankanfushi', 'Transfer route from Velana International Airport to Lankanfushi.', 'published', 'Velana International Airport to Lankanfushi Transfers | Maldives Tour Guide', 'Transfer route from Velana International Airport to Lankanfushi.', now())
on conflict (node_type, slug) do nothing;

insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)
select n.id, o.id, d.id, 20, 30
from nodes n, nodes o, nodes d
where n.node_type = 'transfer_route' and n.slug = 'velana-international-airport-to-lankanfushi'
  and o.node_type = 'location' and o.slug = 'velana-international-airport'
  and d.node_type = 'location' and d.slug = 'lankanfushi'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  'a87292d9-d7fd-5bb6-e8d3-2e71e7fdc1c4'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'velana-international-airport-to-lankanfushi'),
  (select id from nodes where node_type = 'provider' and slug = 'gili-lankanfushi'),
  'speedboat', 'Speedboat', 'shared',
  30, 302.44, 'USD', null,
  null, 'active',
  'Gili Lankanfushi representative meets guests at Velana International Airport.', 'Gili Lankanfushi jetty, Lankanfushi island, Kaafu Atoll (North Malé Atoll).',
  'Arranged through the resort''s own transfer booking channel.', null,
  'Gili Lankanfushi''s own shared return speedboat transfer from Velana International Airport, roughly a 20 km, 30-minute crossing.'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('transfer_route', 'velana-international-airport-to-maafushi', 'Velana International Airport to Maafushi', 'Transfer route from Velana International Airport to Maafushi.', 'published', 'Velana International Airport to Maafushi Transfers | Maldives Tour Guide', 'Transfer route from Velana International Airport to Maafushi.', now())
on conflict (node_type, slug) do nothing;

insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)
select n.id, o.id, d.id, 27, 35
from nodes n, nodes o, nodes d
where n.node_type = 'transfer_route' and n.slug = 'velana-international-airport-to-maafushi'
  and o.node_type = 'location' and o.slug = 'velana-international-airport'
  and d.node_type = 'location' and d.slug = 'maafushi'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  '2e8c4b0d-2637-9ed9-ced8-e7a25dc12ea7'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'velana-international-airport-to-maafushi'),
  (select id from nodes where node_type = 'provider' and slug = 'kaani-hotels'),
  'speedboat', 'Speedboat', 'shared',
  35, 20, 'USD', 8,
  null, 'active',
  'Kaani Hotels representative meets guests at Velana International Airport arrivals.', 'Kaani Beach Hotel jetty, Maafushi island, Kaafu Atoll.',
  'Booked directly through Kaani Beach Hotel/Kaani Hotels as part of a stay.', null,
  'Kaani Hotels'' own shared speedboat transfer from Velana International Airport to its Maafushi property, a 35-minute crossing.'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  '2788a638-55ff-55cb-4646-6d62b29c9b44'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'velana-international-airport-to-maafushi'),
  (select id from nodes where node_type = 'provider' and slug = 'icom-tours'),
  'speedboat', 'Speedboat', 'shared',
  45, 25, 'USD', null,
  null, 'active',
  'iCom Tours representative meets guests at Velana International Airport.', 'Public jetty area, Maafushi island, Kaafu Atoll.',
  'Bookable directly with iCom Tours (icomtours.com) ahead of arrival.', null,
  'A shared, scheduled speedboat transfer from Velana International Airport to Maafushi, run by the independent operator iCom Tours (distinct from the government MTCC public ferry and from resort-specific operators like Kaani Hotels).'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('transfer_route', 'velana-international-airport-to-kunfunadhoo', 'Velana International Airport to Kunfunadhoo', 'Transfer route from Velana International Airport to Kunfunadhoo.', 'published', 'Velana International Airport to Kunfunadhoo Transfers | Maldives Tour Guide', 'Transfer route from Velana International Airport to Kunfunadhoo.', now())
on conflict (node_type, slug) do nothing;

insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)
select n.id, o.id, d.id, null, null
from nodes n, nodes o, nodes d
where n.node_type = 'transfer_route' and n.slug = 'velana-international-airport-to-kunfunadhoo'
  and o.node_type = 'location' and o.slug = 'velana-international-airport'
  and d.node_type = 'location' and d.slug = 'kunfunadhoo'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  '9f87ee9c-d98a-5cd5-c00c-fcbce174b99f'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'velana-international-airport-to-kunfunadhoo'),
  (select id from nodes where node_type = 'provider' and slug = 'soneva-management-bvi-limited'),
  'seaplane', 'Seaplane', 'shared',
  null, 950, 'USD', null,
  null, 'active',
  'Soneva''s own seaplane lounge/terminal area at Velana International Airport.', 'Soneva Fushi''s own seaplane jetty, Kunfunadhoo island, Baa Atoll.',
  'Arranged through Soneva Fushi''s own reservations/transfer booking process ahead of arrival, coordinated with international flight times.', null,
  'Soneva Fushi''s own published shared round-trip seaplane transfer from Velana International Airport to Kunfunadhoo island, Baa Atoll.'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('transfer_route', 'velana-international-airport-to-olhuveli', 'Velana International Airport to Olhuveli', 'Transfer route from Velana International Airport to Olhuveli.', 'published', 'Velana International Airport to Olhuveli Transfers | Maldives Tour Guide', 'Transfer route from Velana International Airport to Olhuveli.', now())
on conflict (node_type, slug) do nothing;

insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)
select n.id, o.id, d.id, null, 60
from nodes n, nodes o, nodes d
where n.node_type = 'transfer_route' and n.slug = 'velana-international-airport-to-olhuveli'
  and o.node_type = 'location' and o.slug = 'velana-international-airport'
  and d.node_type = 'location' and d.slug = 'olhuveli'
on conflict (id) do nothing;

insert into transfer_services (
  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,
  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,
  booking_requirements, cancellation_policy, description
)
select
  '69961daf-50dc-a52c-e927-775f16b9293a'::uuid,
  (select id from nodes where node_type = 'transfer_route' and slug = 'velana-international-airport-to-olhuveli'),
  (select id from nodes where node_type = 'provider' and slug = 'six-senses'),
  'domestic_flight', 'Domestic flight (Malé–Kadhdhoo) + speedboat', 'shared',
  60, 590, 'USD', null,
  null, 'active',
  'Domestic terminal at Velana International Airport for the ~40-minute flight to Kadhdhoo Airport, Laamu Atoll; a Six Senses Laamu representative meets guests at Kadhdhoo for the onward speedboat leg.', 'Six Senses Laamu''s own jetty, Olhuveli island, Laamu Atoll, after a roughly 15–20 minute speedboat ride from Kadhdhoo.',
  'Guests are strongly encouraged to coordinate international arrival/departure timing with this combined transfer; a chartered (private) boat leg can be arranged on request via the resort''s Guest Experience Maker, subject to availability and added cost.', null,
  'Six Senses Laamu''s standard combined transfer: a domestic flight from Malé to Kadhdhoo Airport followed by a shared resort speedboat to Olhuveli island, Laamu Atoll.'
on conflict (id) do nothing;

