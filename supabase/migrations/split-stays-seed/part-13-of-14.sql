-- Part 13 of 14 - run this in the Supabase SQL Editor AFTER the previous parts.
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

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 332, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'summer-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- vommuli
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'the-st-regis-vommuli-island-resort-maldives', 'The St. Regis Vommuli Island Resort Maldives', 'The St. Regis Maldives Vommuli Resort overlooks the alluring waves of the Indian Ocean, nestled between verdant rain forest and white-sand beaches on a private island. Explore the quiet, eco-friendly setting''s tropical beauty and abundant marine life. The Iridium Spa and outdoor swimming pool, as well as the private lagoon, offer unrivaled relaxation. At the beach, there is a wide range of water sports and excursions. The butlers, the diving center''s signature operation, will arrange a wide range of water sports and excursions. In addition, their six restaurants and bars serve delectable cuisine.', 'published', 'The St. Regis Vommuli Island Resort Maldives | Maldives Resorts | MTG', 'The St. Regis Maldives Vommuli Resort overlooks the alluring waves of the Indian Ocean, nestled between verdant rain forest and white-sand beaches on a private island. Explore the quiet, eco-friendly setting''s tropical beauty and abundant marine life. The Iridium Spa and outdoor swimming pool, as well as the private lagoon, offer unrivaled relaxation. At the beach, there is a wide range of water sports and excursions. The butlers, the diving center''s signature operation, will arrange a wide range of water sports and excursions. In addition, their six restaurants and bars serve delectable cuisine.', '{"overview_paragraphs":["The St. Regis Maldives Vommuli Resort overlooks the alluring waves of the Indian Ocean, nestled between verdant rain forest and white-sand beaches on a private island. Explore the quiet, eco-friendly setting''s tropical beauty and abundant marine life. The Iridium Spa and outdoor swimming pool, as well as the private lagoon, offer unrivaled relaxation. At the beach, there is a wide range of water sports and excursions. The butlers, the diving center''s signature operation, will arrange a wide range of water sports and excursions. In addition, their six restaurants and bars serve delectable cuisine.","Each of the 33 on-land and 44 over-water villas at St. Regis Maldives Vommuli Resort offers picturesque ocean or garden views from private terraces and pools, as well as refined furnishings and island-inspired architecture. The legendary Butlers of the St. Regis provide personalized service at all hours of the day and night."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 763, 'SrtYhHoTGfw', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'the-st-regis-vommuli-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'the-st-regis-vommuli-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'vommuli'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'the-st-regis-vommuli-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Garden Pool Villa', 763, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'the-st-regis-vommuli-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 859, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'the-st-regis-vommuli-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Pool Villa', 910, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'the-st-regis-vommuli-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- w-maldives
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'w-maldives-island-resort-maldives', 'W Maldives Island Resort Maldives', 'W Maldives is a wonderland of white sand beaches, turquoise lagoons, and stunning reefs where you can relax, mingle, dance, and enhance your paradise adventure. W Maldives is a peaceful haven with a Diving Center, Fitness Center, and open-air Infinity Pool. Expansive Villas come with a private plunge pool and direct beach, lagoon, or ocean entry. AWAY® Spa, which offers massage, Ayurvedic, and facial treatments, is a haven of indulgence. Water Sports, Yoga, and Aqua Aerobics are among the activities available to visitors.', 'published', 'W Maldives Island Resort Maldives | Maldives Resorts | MTG', 'W Maldives is a wonderland of white sand beaches, turquoise lagoons, and stunning reefs where you can relax, mingle, dance, and enhance your paradise adventure. W Maldives is a peaceful haven with a Diving Center, Fitness Center, and open-air Infinity Pool. Expansive Villas come with a private plunge pool and direct beach, lagoon, or ocean entry. AWAY® Spa, which offers massage, Ayurvedic, and facial treatments, is a haven of indulgence. Water Sports, Yoga, and Aqua Aerobics are among the activities available to visitors.', '{"overview_paragraphs":["W Maldives is a wonderland of white sand beaches, turquoise lagoons, and stunning reefs where you can relax, mingle, dance, and enhance your paradise adventure. W Maldives is a peaceful haven with a Diving Center, Fitness Center, and open-air Infinity Pool. Expansive Villas come with a private plunge pool and direct beach, lagoon, or ocean entry. AWAY® Spa, which offers massage, Ayurvedic, and facial treatments, is a haven of indulgence. Water Sports, Yoga, and Aqua Aerobics are among the activities available to visitors.","On W Maldives, there are 78 different Retreats to choose from. There are 28 land-based Beach Oasis, including three twin Beach Oasis; 25 over-water Ocean Oasis and 21 Ocean Oasis Lagoon View Retreats; 3 Seascape Escapes, our Junior Suites; and one Extreme WOW Villa, the 2-Bedroom Ocean Haven."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 728, 'dVPW7ifhylg', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'w-maldives-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'w-maldives-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'fesdu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'w-maldives-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Villa', 824, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'w-maldives-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Pool Villa', 728, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'w-maldives-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Amra-Palace
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'amra-palace-island-hotel-maldives', 'Amra Palace Island Hotel Maldives', 'Amra Palace is a private gated residence surrounded by lush tropical gardens. It is the ideal setting for unwinding, relaxing, and enjoying the Maldives'' natural beauty. The friendly staff at Amra Hotel can arrange you a variety of activities such as diving, snorkelling, island hopping, and dolphin watching, while the in-house restaurant serves local and foreign cuisine. In-room eating is also available through room service.', 'published', 'Amra Palace Island Hotel Maldives | Maldives Hotels | MTG', 'Amra Palace is a private gated residence surrounded by lush tropical gardens. It is the ideal setting for unwinding, relaxing, and enjoying the Maldives'' natural beauty. The friendly staff at Amra Hotel can arrange you a variety of activities such as diving, snorkelling, island hopping, and dolphin watching, while the in-house restaurant serves local and foreign cuisine. In-room eating is also available through room service.', '{"overview_paragraphs":["Amra Palace is a private gated residence surrounded by lush tropical gardens. It is the ideal setting for unwinding, relaxing, and enjoying the Maldives'' natural beauty. The friendly staff at Amra Hotel can arrange you a variety of activities such as diving, snorkelling, island hopping, and dolphin watching, while the in-house restaurant serves local and foreign cuisine. In-room eating is also available through room service.","The rooms of Amra Palace are divided into two categories: deluxe and outstanding. Superior rooms are located on the first level and are big and pleasant, as well as equipped with all modern comforts. Deluxe rooms are on the ground level and enjoy a beautiful view of the Amra Palace grounds and gardens. Amra Palace can also accommodate families, with twin beds and interconnecting rooms available.","Amra Palace is located in a vibrant and dynamic local community and is accessible through a 35-minute flight from Velana International Airport to Kaddhoo Domestic Airport and a 10-minute car ride. It is ideally located a 5-minute walk from one of the Gan Atoll''s nicest, most opulent, and prettiest beaches."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'hotel', null, null, 'BNO2diluGHE', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'amra-palace-island-hotel-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'amra-palace-island-hotel-maldives'
  and l.node_type = 'location' and l.slug = 'gan'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'amra-palace-island-hotel-maldives'
on conflict (id) do nothing;

-- casa-retreat
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'casa-retreat', 'casa-retreat', 'Casa Retreat is an ideal place to stay in Male City and Airport for travelers seeking beauty, comfort, and convenience. This is a convenient property that is near to the airport and easily accessible from both Male'' and Hulhumale''. The hotel has its own spa, which will deliver a 1-hour spa treatment at a reduced rate, as well as other excursions.', 'published', 'casa-retreat | Maldives Guesthouses | MTG', 'Casa Retreat is an ideal place to stay in Male City and Airport for travelers seeking beauty, comfort, and convenience. This is a convenient property that is near to the airport and easily accessible from both Male'' and Hulhumale''. The hotel has its own spa, which will deliver a 1-hour spa treatment at a reduced rate, as well as other excursions.', '{"overview_paragraphs":["Casa Retreat is an ideal place to stay in Male City and Airport for travelers seeking beauty, comfort, and convenience. This is a convenient property that is near to the airport and easily accessible from both Male'' and Hulhumale''. The hotel has its own spa, which will deliver a 1-hour spa treatment at a reduced rate, as well as other excursions.","Hotel have excellent services and amenities, ensuring that you have a pleasant stay. The hotel offers complimentary Wi-Fi in all rooms, as well as daily housekeeping and a restaurant. Some facilities, such as \"things to do and ways to relax,\" are available outside of the accommodation."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'guesthouse', null, 67, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'casa-retreat'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'casa-retreat'
  and l.node_type = 'location' and l.slug = 'hulhumale'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'casa-retreat'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Standard Room', 67, 'USD', null, null, 0
from nodes where node_type = 'accommodation' and slug = 'casa-retreat'
on conflict (accommodation_id, name) do nothing;

-- gaafaru-view-inn-maldives
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'gaafari-view-inn-hotel-maldives', 'Gaafari view inn Hotel Maldives', 'Gaafaru View Inn is a three-star Guest House in the Maldives. The guest house provides guests with 7 air-conditioned rooms with private bathrooms and balconies, 1 main restaurant, as well as a variety of excursions, private dining experiences, and local culture. Our restaurant serves both regional and foreign cuisine.', 'published', 'Gaafari view inn Hotel Maldives | Maldives Guesthouses | MTG', 'Gaafaru View Inn is a three-star Guest House in the Maldives. The guest house provides guests with 7 air-conditioned rooms with private bathrooms and balconies, 1 main restaurant, as well as a variety of excursions, private dining experiences, and local culture. Our restaurant serves both regional and foreign cuisine.', '{"overview_paragraphs":["Gaafaru View Inn is a three-star Guest House in the Maldives. The guest house provides guests with 7 air-conditioned rooms with private bathrooms and balconies, 1 main restaurant, as well as a variety of excursions, private dining experiences, and local culture. Our restaurant serves both regional and foreign cuisine.","The Gaafaru View Inn is situated on one of the Maldives'' major lagoons. Gaafaru View inn Maldives, which is situated on a big lagoon with numerous snorkeling and diving areas, strives to give visitors a taste of the Maldives underwater beauty through a variety of organized trips to neighboring locations. Every day, turtles, manta rays, sharks, and dolphins can be spotted in these areas.","The Gaafaru Bikini Beach is only 2 minutes away from Gaafaru View Inn. Gaafaru View Inn attempts to deliver all you may want from a Maldives vacation at an inexpensive price, including white sand beaches, swaying palm trees, golden sunset views, and colorful corals and fish beneath the lagoon.","Gaafaru is one of Kaafu Atoll''s inhabited islands, as well as the lone island of the Gaafaru natural atoll. As the name suggests, Gaafaru refers to corals and Faru refers to reefs. On a nearby pristine island, see how the local Maldivians live. It''s a little fishing village in the Maldives. You will get a really private holiday experience, as it will not be overcrowded. The population of Gaafaru is estimated to be around 1500 people, with fishing being their primary source of income. As a result, the harbor is home to a variety of fishing boats ranging in size from 25 to 90 feet. The land area is estimated to be 17.2 hectares"]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'guesthouse', 3, 40, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'gaafari-view-inn-hotel-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'gaafari-view-inn-hotel-maldives'
  and l.node_type = 'location' and l.slug = 'gaafaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'gaafari-view-inn-hotel-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Room', 40, 'USD', null, null, 0
from nodes where node_type = 'accommodation' and slug = 'gaafari-view-inn-hotel-maldives'
on conflict (accommodation_id, name) do nothing;

-- island-break-fulidhoo
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'island-break-fulidhoo-maldives', 'Island Break Fulidhoo Maldives', 'OurHotel is located in vaavu atoll Fulidhoo. Located 1 hour away from the Male international airport.The hotel is owned and run by 3 three young enthusiastic brothers. The Hotel islocated at the east end of the island, Which give our guest maximum privacy from the locals.The hotel is featuredwith an onsite restaurant, our restaurant is set up to provide an expectational service and quality food to our clients. Where they got to eat daily fresh Catchor seafood platters and so on, Our hotel consists of 7 Rooms and also providing an expectational day out activities like, Swimming with dolphins, mantas, Snorkeling withturtle, Snorkeling with Nurse Sharks and other snorkeling points, Day out tosandbanks, Visiting Ship Wrack.', 'published', 'Island Break Fulidhoo Maldives | Maldives Guesthouses | MTG', 'OurHotel is located in vaavu atoll Fulidhoo. Located 1 hour away from the Male international airport.The hotel is owned and run by 3 three young enthusiastic brothers. The Hotel islocated at the east end of the island, Which give our guest maximum privacy from the locals.The hotel is featuredwith an onsite restaurant, our restaurant is set up to provide an expectational service and quality food to our clients. Where they got to eat daily fresh Catchor seafood platters and so on, Our hotel consists of 7 Rooms and also providing an expectational day out activities like, Swimming with dolphins, mantas, Snorkeling withturtle, Snorkeling with Nurse Sharks and other snorkeling points, Day out tosandbanks, Visiting Ship Wrack.', '{"overview_paragraphs":["OurHotel is located in vaavu atoll Fulidhoo. Located 1 hour away from the Male international airport.The hotel is owned and run by 3 three young enthusiastic brothers. The Hotel islocated at the east end of the island, Which give our guest maximum privacy from the locals.The hotel is featuredwith an onsite restaurant, our restaurant is set up to provide an expectational service and quality food to our clients. Where they got to eat daily fresh Catchor seafood platters and so on, Our hotel consists of 7 Rooms and also providing an expectational day out activities like, Swimming with dolphins, mantas, Snorkeling withturtle, Snorkeling with Nurse Sharks and other snorkeling points, Day out tosandbanks, Visiting Ship Wrack."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'guesthouse', null, 65, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'island-break-fulidhoo-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'island-break-fulidhoo-maldives'
  and l.node_type = 'location' and l.slug = 'fulidhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'island-break-fulidhoo-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ground Room', 65, 'USD', 'Double', null, 0
from nodes where node_type = 'accommodation' and slug = 'island-break-fulidhoo-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Luxury Coconut Suit with Balcony', 75, 'USD', 'Double', null, 1
from nodes where node_type = 'accommodation' and slug = 'island-break-fulidhoo-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Luxury Coconut Suit Triple Room with Balcony', 85, 'USD', 'Triple', null, 2
from nodes where node_type = 'accommodation' and slug = 'island-break-fulidhoo-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Luxury Coconut Suit with Balcony Twin Room', 75, 'USD', 'Double', null, 3
from nodes where node_type = 'accommodation' and slug = 'island-break-fulidhoo-maldives'
on conflict (accommodation_id, name) do nothing;

-- maagiri
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'maagiri-hotel-male-maldives', 'Maagiri Hotel Male Maldives', 'The Maagiri Hotel is conveniently located across the street from the Hulhumale'' Ferry Terminal in the capital Male''. Maagiri offers a 4-star accommodation to compliment its excellent service, set against a scenic backdrop of the surrounding ocean and a few of the Maldives'' many islands.', 'published', 'Maagiri Hotel Male Maldives | Maldives Hotels | MTG', 'The Maagiri Hotel is conveniently located across the street from the Hulhumale'' Ferry Terminal in the capital Male''. Maagiri offers a 4-star accommodation to compliment its excellent service, set against a scenic backdrop of the surrounding ocean and a few of the Maldives'' many islands.', '{"overview_paragraphs":["The Maagiri Hotel is conveniently located across the street from the Hulhumale'' Ferry Terminal in the capital Male''. Maagiri offers a 4-star accommodation to compliment its excellent service, set against a scenic backdrop of the surrounding ocean and a few of the Maldives'' many islands.","Maagiri has four different types of rooms, each with elegant interiors, luxury amenities, and panoramic views of the Maldivian seas."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'hotel', 4, 220, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'maagiri-hotel-male-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'maagiri-hotel-male-maldives'
  and l.node_type = 'location' and l.slug = 'male'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'maagiri-hotel-male-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Premier Room', 220, 'USD', 'Double', null, 0
from nodes where node_type = 'accommodation' and slug = 'maagiri-hotel-male-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Junior Suit', 228, 'USD', null, null, 1
from nodes where node_type = 'accommodation' and slug = 'maagiri-hotel-male-maldives'
on conflict (accommodation_id, name) do nothing;

-- mantha-view-hotel
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'mantha-view-hotel-maldives', 'Mantha view Hotel Maldives', 'The Maldives'' Manta View Guest House is located in Vaavu, Keyodhoo. It includes five rooms, each with a double bed and a toilet. There are four rooms with air conditioning. We provide the following activities: Snorkeling with a professional guide [sandbanks and reefs] Snorkeling for half a day Fishing for the entire day Fishing in the morning Fishing at night Bivacco journey Trip to the Alimatha Resort', 'published', 'Mantha view Hotel Maldives | Maldives Guesthouses | MTG', 'The Maldives'' Manta View Guest House is located in Vaavu, Keyodhoo. It includes five rooms, each with a double bed and a toilet. There are four rooms with air conditioning. We provide the following activities: Snorkeling with a professional guide [sandbanks and reefs] Snorkeling for half a day Fishing for the entire day Fishing in the morning Fishing at night Bivacco journey Trip to the Alimatha Resort', '{"overview_paragraphs":["The Maldives'' Manta View Guest House is located in Vaavu, Keyodhoo. It includes five rooms, each with a double bed and a toilet. There are four rooms with air conditioning. We provide the following activities: Snorkeling with a professional guide [sandbanks and reefs] Snorkeling for half a day Fishing for the entire day Fishing in the morning Fishing at night Bivacco journey Trip to the Alimatha Resort","When visiting the Maldives Islands, Keyodhoo Manta View Guest House, which offers exceptional accommodation and excellent service, will make you feel right at home. Guests will have easy access to everything the vibrant city has to offer from here. The hotel''s ideal location allows guests to easily access the city''s must-see attractions. This Maldives Islands hotel offers an abundance of exceptional services and amenities. On-site amenities include 24-hour room service, daily housekeeping, portable wi-fi rental, luggage storage, and valet parking for hotel guests. During your visit, you will have access to high-quality room amenities.","Towels, air conditioning, wireless internet connection (fees apply), shower, and washing machine are available in some rooms to let guests unwind after a hard day. Top-notch recreational facilities such as snorkeling, private beach, and fishing will keep you amused whether you''re a fitness fanatic or simply searching for a way to unwind after a long day. Keyodhoo Manta View Guest House is a fantastic choice for your stay in the Maldives Islands, whatever your reason for visiting."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'guesthouse', null, 40, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'mantha-view-hotel-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'mantha-view-hotel-maldives'
  and l.node_type = 'location' and l.slug = 'keyodhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'mantha-view-hotel-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Room', 40, 'USD', null, null, 0
from nodes where node_type = 'accommodation' and slug = 'mantha-view-hotel-maldives'
on conflict (accommodation_id, name) do nothing;

-- reveries-village
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'reveries-village', 'reveries-village', 'Reveries Diving Village proudly opened its doors as Laamu’s first guest house, in the heart of the atoll. The aim was to invite the world to experience the culture and beauty of Dhivehi island society at an affordable price. Our pioneering venture found its home on Gan, the longest island in the country, at the northern end of the Thundi village. From here, Reveries has gone from strength to strength, combining vibrant island culture and stunning natural environment with comfort and luxury for guests who wish to sample all the Maldives has to offer. A typical day with Reveries might take you from the comfort of your room, out past our private beach, snorkeling over the reef and diving down into the pristine lagoon. The next morning, you can let our guides take you on a tour of their island and relax in our rooftop spa before a candlelit dinner in our verdant garden. Reveries is a gateway to the precious underwater kingdom and best surfing experience. It’s your paradise.', 'published', 'reveries-village | Maldives Guesthouses | MTG', 'Reveries Diving Village proudly opened its doors as Laamu’s first guest house, in the heart of the atoll. The aim was to invite the world to experience the culture and beauty of Dhivehi island society at an affordable price. Our pioneering venture found its home on Gan, the longest island in the country, at the northern end of the Thundi village. From here, Reveries has gone from strength to strength, combining vibrant island culture and stunning natural environment with comfort and luxury for guests who wish to sample all the Maldives has to offer. A typical day with Reveries might take you from the comfort of your room, out past our private beach, snorkeling over the reef and diving down into the pristine lagoon. The next morning, you can let our guides take you on a tour of their island and relax in our rooftop spa before a candlelit dinner in our verdant garden. Reveries is a gateway to the precious underwater kingdom and best surfing experience. It’s your paradise.', '{"overview_paragraphs":["Reveries Diving Village proudly opened its doors as Laamu’s first guest house, in the heart of the atoll. The aim was to invite the world to experience the culture and beauty of Dhivehi island society at an affordable price. Our pioneering venture found its home on Gan, the longest island in the country, at the northern end of the Thundi village. From here, Reveries has gone from strength to strength, combining vibrant island culture and stunning natural environment with comfort and luxury for guests who wish to sample all the Maldives has to offer. A typical day with Reveries might take you from the comfort of your room, out past our private beach, snorkeling over the reef and diving down into the pristine lagoon. The next morning, you can let our guides take you on a tour of their island and relax in our rooftop spa before a candlelit dinner in our verdant garden. Reveries is a gateway to the precious underwater kingdom and best surfing experience. It’s your paradise."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'guesthouse', null, 65, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'reveries-village'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'reveries-village'
  and l.node_type = 'location' and l.slug = 'gan'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'reveries-village'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Room', 65, 'USD', 'King', 2, 0
from nodes where node_type = 'accommodation' and slug = 'reveries-village'
on conflict (accommodation_id, name) do nothing;

-- rosemery-maafushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'rosemery-maafushi', 'rosemery-maafushi', 'Rosemary Boutique is a boutique on the beautiful island of Maafushi that offers a variety of events and thrilling journeys for visitors. Maafushi island is 24 kilometers from the airport and is easily accessible all over the island.', 'published', 'rosemery-maafushi | Maldives Hotels | MTG', 'Rosemary Boutique is a boutique on the beautiful island of Maafushi that offers a variety of events and thrilling journeys for visitors. Maafushi island is 24 kilometers from the airport and is easily accessible all over the island.', '{"overview_paragraphs":["Rosemary Boutique is a boutique on the beautiful island of Maafushi that offers a variety of events and thrilling journeys for visitors. Maafushi island is 24 kilometers from the airport and is easily accessible all over the island.","There are a variety of rooms available, ranging from simple double rooms to suites with modern amenities. There are a total of 22 rooms available to accommodate all travel classes."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'hotel', null, 44, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'rosemery-maafushi'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'rosemery-maafushi'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'rosemery-maafushi'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Double Balcony Room', 44, 'USD', 'Double', null, 0
from nodes where node_type = 'accommodation' and slug = 'rosemery-maafushi'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Tripple Balcony Room', 52, 'USD', 'Maximum', null, 1
from nodes where node_type = 'accommodation' and slug = 'rosemery-maafushi'
on conflict (accommodation_id, name) do nothing;

-- surfview-male
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'surfview-hotel-male-maldives', 'Surfview Hotel Male Maldives', 'The hotel has spectacular sea and city views and is located on the seafront with 11 signature rooms that offer comfort and connectivity. Surfview Raalhugandhu is centrally located in Male'' City, just a short walk from banks, parks, and souvenir shops.', 'published', 'Surfview Hotel Male Maldives | Maldives Guesthouses | MTG', 'The hotel has spectacular sea and city views and is located on the seafront with 11 signature rooms that offer comfort and connectivity. Surfview Raalhugandhu is centrally located in Male'' City, just a short walk from banks, parks, and souvenir shops.', '{"overview_paragraphs":["The hotel has spectacular sea and city views and is located on the seafront with 11 signature rooms that offer comfort and connectivity. Surfview Raalhugandhu is centrally located in Male'' City, just a short walk from banks, parks, and souvenir shops.","Surfview Raalhugandhu has 11 signature rooms that will provide guests with the best in service and comfort."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'guesthouse', null, 64, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'surfview-hotel-male-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'surfview-hotel-male-maldives'
  and l.node_type = 'location' and l.slug = 'male'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'surfview-hotel-male-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Superior Room', 64, 'USD', null, null, 0
from nodes where node_type = 'accommodation' and slug = 'surfview-hotel-male-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sea View Room', 93, 'USD', null, null, 1
from nodes where node_type = 'accommodation' and slug = 'surfview-hotel-male-maldives'
on conflict (accommodation_id, name) do nothing;

-- Enriching already-seeded Task 5 accommodations with this round's
-- real price/video/room/overview data (same physical resorts — see
-- mergeIntoExistingSlug in merge-accommodation-research.mjs).
-- Baros-Island -> baros-maldives
update accommodations set
  price_from = coalesce(accommodations.price_from, 780),
  video_youtube_id = coalesce(accommodations.video_youtube_id, '9NssgRLiKF8')
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'baros-maldives';

update nodes set attributes = attributes || '{"overview_paragraphs":["Turquoise seas lap against white-sand beaches. Palm trees rustle in the breeze. Welcome to Baros, a lush island canopy natural paradise about 25 minutes by speedboat from the Maldives'' international airport. We''ve been greeting visitors since 1973, and we''ve spent decades polishing our services and developing our surroundings to create what we feel to be a renowned resort. Today, we''re one of the most popular Maldives resorts, and we can''t wait to show you what makes us so unique.","Unrivaled in its attention to detail, Baros creates really transformative experiences by putting the individual first, customising to their specific needs and expectations in a spirit of true generosity. Allow us to contact you in order to design your Maldives vacation.","The lavish furniture and unique artworks in this enormous property create a warm and welcome atmosphere. A private pool is bordered by tropical flowers in the garden courtyard, and a front balcony leads to your own length of Baros beach. Butler service is available 24 hours a day, seven days a week, ensuring that you have whatever you need, when you need it.","Turquoise seas lap against white-sand beaches. Palm trees rustle in the breeze. A beautiful island canopy in a natural wonderland within 25 minutes by speedboat from the Maldives'' international airport. We''ve been greeting visitors since 1973, and we''ve spent decades perfecting our services and nurturing our surroundings.","Take a supper cruise for two on a dhoni. Or, for a special gourmet supper, come to the Piano Deck with your own private chef. Alternatively, enjoy the sunset with cocktails and canapés at The Lighthouse. Every meal is yours to savour at these gourmet restaurants in Baros, and every mouthful is meant to inspire. For more than 40 years, we''ve been working to refine classic meals while experimenting with new techniques and ingredients from across the world. From opulent buffet breakfasts by the pool to exquisite dining at the famed Lighthouse, each meal is another chance to indulge in a favourite or try something new.","Serenity Spa, a haven of relaxation and a sanctuary nestled in the forest, welcomes you into a world of luxurious spa and beauty rituals. You can come here to unwind for a few hours or to create a personalised wellness journey with a series of daily treatments. From daily yoga classes to therapeutic massage, everything here is geared to help you regain your balance and find your peace. Request a yoga session anywhere on the island for something out of the usual, or get a soothing massage in the privacy of your comfy home."]}'::jsonb
where node_type = 'accommodation' and slug = 'baros-maldives' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Villa', 780, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'baros-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 1100, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'baros-maldives'
on conflict (accommodation_id, name) do nothing;

-- Gili-Lankanfushi -> gili-lankanfushi
update accommodations set
  price_from = coalesce(accommodations.price_from, 1600),
  video_youtube_id = coalesce(accommodations.video_youtube_id, 'Xx61PgIeXRA')
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'gili-lankanfushi';

update nodes set attributes = attributes || '{"overview_paragraphs":["With sustainably designed homes hanging above turquoise seas that reach as far as the eye can see, our exclusive island refuge provides peace by design. Spend your days doing anything you want—snorkeling, relaxing at the spa, sailing on a catamaran—and don''t be afraid to ask for help and guidance from our helpful staff. Nourish your body with locally produced products and worldwide cuisines, enjoy the sunset from your rustic-luxe villa, and fall asleep with the moon shining gloriously in the sky.","These 18 one-bedroom retreats are ideal for couples. Each apartment has an open-air living area, a huge bathroom, and a separate rooftop terrace from which to take in the vistas. Spend your days swimming and snorkelling in the coral gardens at the base of your sundeck, which has direct ocean access. At night, relax on catamaran nets while watching the sky.","Our five overwater Gili Lagoon Villas face west and provide breathtaking sunset views. The one-bedroom hideaways with thatched roofs are split across two storeys and include open-air living spaces, big bathrooms, and private rooftop terraces. Relax on the deck or swim out to your own own water hammock. You may pass by eagle rays, reef sharks, and shoals of luminous fish.","The Family Villa, perched at the end of our Western-facing jetty, is an open-air paradise with unrivalled views of the surrounding seascape. The main bedroom has an en-suite bathroom as well as an outdoor tub and shower. Two huge, air-conditioned living areas offer plenty of living (and sleeping) space. When you''re not napping off in the sun, take use of your own gym, steam room, or rooftop Jacuzzi. Alternatively, venture off the quiet Three Palm Island to relax in a magnificent cabana.","45 rustic-chic thatched villas float over the clear lagoon waters of Gili Lankanfushi in the Maldives. Many are linked to wooden jetties that extend from a little island, while others stand alone in the water. Simple, yet magnificent abodes (all created from sustainable materials) can serve as the ideal foundation for any modern-day Robinson Crusoe trip.","Gili Lankanfushi Maldives, perched above the Indian Ocean, offers exquisite accommodation near to the sun and water. Gili Lankanfushi Maldives is located on the private island of Lankanfushi in Male Atoll, a 20-minute speedboat journey from Male International Airport."]}'::jsonb
where node_type = 'accommodation' and slug = 'gili-lankanfushi' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Villa Suite', 1600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'gili-lankanfushi'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Gili Lagoon Villa', 1800, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'gili-lankanfushi'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Family Villa', 4000, 'USD', 'King', 9, 2
from nodes where node_type = 'accommodation' and slug = 'gili-lankanfushi'
on conflict (accommodation_id, name) do nothing;

-- Kurumba -> kurumba-maldives
update accommodations set
  price_from = coalesce(accommodations.price_from, 300),
  video_youtube_id = coalesce(accommodations.video_youtube_id, '8ODifdytxy4')
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'kurumba-maldives';

update nodes set attributes = attributes || '{"overview_paragraphs":["Kurumba Maldives welcomes you. A Maldives island resort with more to offer than sun, sand, and water! A resort full of surprises, engaging activities, energetic entertainment, and friendly people that will make your Maldives vacation that much more memorable. Kurumba is appropriate for guests of all ages. We are glad to offer couples, honeymooners, friends, families, and small groups with a grin and a splash of Maldivian charm via our choice of entertainment, facilities, activities, and social events.","Accommodation that is both spacious and reasonably priced. Walk onto the beach, the water beneath your feet and Malé in the distance.","A huge pool villa with a large balcony. An open-plan area with views of the Maldives ocean on the east and seclusion and excellent lagoon on the west.","Kurumba Maldives provides classic modern style with character and thoughtful touches in 8 different room types.","Make every opportunity count. We are only a 10-minute speedboat trip from Velana International Airport (open 24 hours), so you may be on the beach with a beverage in hand within seconds of landing.","Veli Spa is a real Maldivian experience, set among beautiful grounds. While embracing contemporary therapies, our Spa is inspired by the tranquillity of the Maldives Islands, the balance of the waters, the vitality of the Maldivian indigenous people, and the healing powers of human touch."]}'::jsonb
where node_type = 'accommodation' and slug = 'kurumba-maldives' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Superior Room', 300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'kurumba-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Pool Villa', 900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'kurumba-maldives'
on conflict (accommodation_id, name) do nothing;

-- Six-Senses-Laamu -> six-senses-laamu
update accommodations set
  price_from = coalesce(accommodations.price_from, 1000),
  video_youtube_id = coalesce(accommodations.video_youtube_id, 'nR4SchedAl8')
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'six-senses-laamu';

update nodes set attributes = attributes || '{"overview_paragraphs":["Award-winning marine conservation effort located at Six Senses Laamu in conjunction with three partner NGOs: The Manta Trust, Blue Marine Foundation, and Olive Ridley Project, all of which collaborate to achieve research, guest education, and community outreach objectives. Is this your ideal palm-fringed paradise? It''s the sole resort in the secluded Laamu Atoll in the Maldives'' south, yet it''s only a short inter-island flight and boat ride away. On-land and over-water homes, dolphins playing in the warm sapphire waters, and restaurants offering delectable East-West cuisine combine to create an amazing, natural paradise.","These beach homes, hidden among the thick tropical flora overlooking the lagoon, feature a private pool and give complete seclusion surrounded by the turquoise lagoon waters. The pool is only a few metres from the beach, and sun loungers are strategically placed beside the pool deck for sun and shade. Feel the soothing sea wind streaming through the leaves while you bathe in the open-air branch-encircled shower or outdoor bathtub, or simply rest in the secluded garden area. Climb to your treetop terrace, which has a comfortable seating and dining space, for a unique panoramic view of Maldivian nature, sapphire ocean, and an incredible beautiful sunset.","A short bike ride on the aged timber jetties will take you to these overwater hideaways, which are surrounded by towering wooden walls. With direct access to the sea, you may go swimming or snorkelling around the lagoon, or simply rest on the overwater netted hammock. If you want to soak up some sun or watch the sunset over the lagoon, you may relax on the sun loungers or around the glass-bottom table on the outdoor deck. The water villas have an outdoor rain shower and a glass overwater bathtub with a view of the lagoon. You may obtain a unique panoramic view of the Indian Ocean, sapphire seascape, and an outstanding vivid tropical sunset here.","Six Senses Laamu''s beautifully built, air-conditioned villas have an outdoor bathroom with rain shower where guests may shower beneath the stars. Guests may enjoy the Maldivian sun from the luxury of their villas thanks to private day beds and sun loungers. The rooms include an electric kettle, slippers, and a dental kit.","The Six Senses Laamu is the sole resort in the Laamu Atoll, which is located in the Maldives'' south. Olhuveli Island is a 35-minute inter-island domestic flight from Male International Airport to Kadhdhoo, followed by a short motorboat journey.","Every day begins with a hearty breakfast with buffet and a la carte selections, as well as a daily changing live cooking station and fruit cut to order. Dinners are international themed events with a concentration on South Asia. There are also live cooking nights where chefs produce fresh meals from a range of different cuisines on the spot."]}'::jsonb
where node_type = 'accommodation' and slug = 'six-senses-laamu' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Beach Villa Pool', 1080, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'six-senses-laamu'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Water Villa', 1000, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'six-senses-laamu'
on conflict (accommodation_id, name) do nothing;

-- Soneva-Fushi -> soneva-fushi
update accommodations set
  price_from = coalesce(accommodations.price_from, 2000),
  video_youtube_id = coalesce(accommodations.video_youtube_id, 'SPn2V6YP_eg')
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'soneva-fushi';

update nodes set attributes = attributes || '{"overview_paragraphs":["Soneva Fushi is a natural wonder located in the UNESCO Biosphere Reserve of Baa Atoll, one of the Maldives'' biggest islands. Sixty-four private island homes are tucked away in a lush expanse of lush vegetation. All have expansive living areas and views of the dawn or sunset, and most have their own pools in addition to being just steps from the beach. Our eight Water Retreats are among the largest of their kind in the world, boasting a terrace with a private pool and an ocean water slide. All Soneva Fushi villas have our personalised Barefoot Guardian service, which is available 24 hours a day, seven days a week.","Take a relaxing plunge in your private pool, which is protected by trees. If you wish to experience the pristine Maldivian ocean''s underwater delights, you''re only a few steps away. Relax among the whimsically rustic-chic apartments and balconies and succumb to the shipwrecked vibe.","Sunrise over the water has a mystical quality about it. With three two-story bungalows facing the ocean, there are infinite opportunities to enjoy the sunrise at this expansive seaside Retreat. Promenade the elevated walkway. Swim in the cool private pool. Bathe under the stars in the open-air garden bathrooms. Enjoy a leisurely lunch on the elevated dining pavilion, complemented by a cold beverage from the in-villa wine cooler.","The 1 Bedroom Water Retreat with Slide is positioned right over the pristine waters of the Indian Ocean and is accessible from the main island through a curving dock. The vast home has a light-filled, wide living space with a neighbouring pantry and minibar, as well as sleek and modest décor inspired by the sea.","Fifty-seven individual villas, each with its own length of beach, are tucked away among deep greenery and within touching distance of a magnificent coral reef. Our Soneva Fushi villas are located on the island''s sunset or dawn side. Despite the fact that there are little distinctions, both sides boast the Maldives'' characteristic white-sand beaches and crystal clear turquoise seas. Mr./Ms. Friday butlers deliver intuitive service.","Guests may fly directly to Soneva Fushi from Malé International Airport. Please keep in mind that the seaplane only operates throughout the day, with the latest trip departing at 17:00. Guests can also fly domestically to the neighbouring Dharavandhoo Airport, then take a 15-minute speedboat journey to the resorts. The final domestic flight departs at 23:15. Both flights last between 30 and 40 minutes. We recommend arriving by seaplane to get a bird''s eye perspective of the Maldives'' gorgeous islands."]}'::jsonb
where node_type = 'accommodation' and slug = 'soneva-fushi' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Crusoe Villa Pool', 2000, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'soneva-fushi'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Villa 41 Three Bedroom Pool Residence', 21700, 'USD', 'King', 9, 1
from nodes where node_type = 'accommodation' and slug = 'soneva-fushi'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, '1 Bedroom Water Retreat Slide', 5700, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'soneva-fushi'
on conflict (accommodation_id, name) do nothing;

-- Velassaru -> velassaru-maldives
update accommodations set
  price_from = coalesce(accommodations.price_from, 800),
  video_youtube_id = coalesce(accommodations.video_youtube_id, 'UBywDUXX3dA')
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'velassaru-maldives';
