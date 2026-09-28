-- Part 14 of 14 - run this in the Supabase SQL Editor AFTER the previous parts.
-- Safe to re-run: every statement in the source file is idempotent (on
-- conflict do nothing / coalesce jsonb merge).

-- MTG: Stays ecosystem seed — 148 real resort/hotel/guesthouse
-- properties, migrated from the legacy site (Phase 1-2 of the Stays
-- ecosystem task).
-- GENERATED FILE — do not hand-edit. Source of truth:
--   data/maldives/accommodations-v2/resolved-properties.json
--   (built by scripts/extract-legacy-accommodations.mjs +
--    scripts/merge-accommodation-research.mjs from WebSearch-verified
--    atoll/island research — see resolution-review.json for the 2
--    properties deliberately excluded: an ambiguous 'Crystal Beach'
--    among 3 same-named guesthouses, and 'Vakarufalhi', rebranded to
--    NOVA Maldives in 2019 and kept under its current name only.)
-- Regenerate with: node scripts/generate-stays-seed.mjs
--
-- Adds to, never replaces, the original 14-property seed from Task 5
-- (20250103000100_seed_accommodations.sql) — idempotent, ON CONFLICT DO
-- NOTHING keyed by slug, same convention as every other generator here.
--
-- No providers are assigned: unlike Task 5's activities/fishing data,
-- the legacy resort/hotel pages never name a distinct booking operator
-- for the property itself (only in-page booking WIDGETS, already
-- confirmed non-content by the Phase 1 audit) — leaving
-- operated_by_provider_id null here is the honest reflection of that,
-- not an oversight.

-- New private/resort islands not covered by the Task 4 inhabited-islands
-- seed or the Task 5 six-resort-island set (deduped — e.g. Fari Islands
-- is shared by two resorts and gets exactly one row here).

update nodes set attributes = attributes || '{"overview_paragraphs":["Crystal-clear oceans, soft white beaches. A picture-perfect lovely lagoon with breathtaking sunset views. Chic private hideaways dot the coastline. Five restaurants and two pubs serve exquisite flavours from all around the world. Explore our abundant coral reefs, sail beyond the horizon, or simply unwind on our idyllic Maldivian beaches.","Luxurious in a subtle way. Your Deluxe Villa is a haven unto itself, with easy access to a lovely white sandy beach:","Each Beach Villa with Pool is located on the beach and has direct access to the ocean. Each one has all you need for a comfortable stay:","Our 24 Water Villas are sophisticated over-water ocean villas with stunning lagoon views. Each one has all you need for a comfortable stay:","Contemporary-styled villas and bungalows offer stylish seclusion tucked away in gorgeous gardens, located along the seaside, or perched above water. Every villa in Velassaru Maldives has everything you need for a relaxing stay.","Velassaru Maldives is a 25-minute speedboat journey from Malé International Airport in South Malé Atoll. Our guest services crew will be at the airport to greet visitors and transport them to waiting speedboats."]}'::jsonb
where node_type = 'accommodation' and slug = 'velassaru-maldives' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Villa', 800, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'velassaru-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1050, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'velassaru-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 1400, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'velassaru-maldives'
on conflict (accommodation_id, name) do nothing;

-- arena-maafushi -> arena-beach-hotel
update accommodations set
  price_from = coalesce(accommodations.price_from, 59),
  video_youtube_id = coalesce(accommodations.video_youtube_id, null)
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'arena-beach-hotel';

update nodes set attributes = attributes || '{"overview_paragraphs":["The Arena Beach Hotel in Maafushi, Maldives, is located on the coast of the South Male Atoll. The island has a breathtaking view of the Indian Ocean and the turquoise lagoon. Let go of your worries and revel in the thrills that await you at every stop. Arena Beach Hotel offers the most accessible way to explore the real Maldives.","Seven Double Deluxe Rooms with balconies have views of the city with coconut trees swaying softly in the breeze, while nine Double Deluxe Rooms with balconies have views of the island''s stunning turquoise lagoon reaching out across the Indian Ocean. In addition, Arena Beach Hotel offers two Super Deluxe Sea View Rooms, which deliver just what the name implies."]}'::jsonb
where node_type = 'accommodation' and slug = 'arena-beach-hotel' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Standard Room', 59, 'USD', 'Double', null, 0
from nodes where node_type = 'accommodation' and slug = 'arena-beach-hotel'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Double Sea View Balcony Room', 89, 'USD', 'Double', null, 1
from nodes where node_type = 'accommodation' and slug = 'arena-beach-hotel'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Balcony Sea View Tripple Room', 112, 'USD', 'Double', null, 2
from nodes where node_type = 'accommodation' and slug = 'arena-beach-hotel'
on conflict (accommodation_id, name) do nothing;

-- kaanibeach-maafushi -> kaani-beach-hotel
update accommodations set
  price_from = coalesce(accommodations.price_from, 71),
  video_youtube_id = coalesce(accommodations.video_youtube_id, null)
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'kaani-beach-hotel';

update nodes set attributes = attributes || '{"overview_paragraphs":["On Maafushi Island, a sunny beach getaway surrounded by coconut palm trees, the 3-star Kaani Beach Hotel is located. On-site activities include scuba diving, island picnics, dolphin viewing, and snorkeling. Kaani Beach Hotel is the ideal choice for anyone looking for a romantic getaway or something a little more laid-back.","Sea View rooms with private balconies are available at Kaani Beach Hotel, a sunny beach getaway surrounded by coconut palm trees. All of the rooms have air conditioning, a hot water shower, satellite television, wireless Internet, a mini bar, a hair dryer, and a safe. There is also a restaurant offering buffet breakfast and dinner, as well as a rooftop open-air terrace with loungers."]}'::jsonb
where node_type = 'accommodation' and slug = 'kaani-beach-hotel' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Sea View Balcony Room', 71, 'USD', 'Double', null, 0
from nodes where node_type = 'accommodation' and slug = 'kaani-beach-hotel'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Tripple Sea View Balcony Room', 84, 'USD', 'Tripple', null, 1
from nodes where node_type = 'accommodation' and slug = 'kaani-beach-hotel'
on conflict (accommodation_id, name) do nothing;
