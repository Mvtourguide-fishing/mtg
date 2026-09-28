-- Part 6 of 14 - run this in the Supabase SQL Editor AFTER the previous parts.
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

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'hard-rock-hotel-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'akasdhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'hard-rock-hotel-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Silver Beach Studio', 600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'hard-rock-hotel-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Pletinum Water Villa', 820, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'hard-rock-hotel-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Heritance-Aarah
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'heritance-aarah-maldives-island-resort', 'Heritance Aarah Maldives Island Resort', 'Return to Heritance Aarah… Wake up to the sound of the sea in paradise, dive among unique underwater wonders, and dine beneath a beautiful star-studded sky over one of the greatest Maldives luxury resorts.', 'published', 'Heritance Aarah Maldives Island Resort | Maldives Resorts | MTG', 'Return to Heritance Aarah… Wake up to the sound of the sea in paradise, dive among unique underwater wonders, and dine beneath a beautiful star-studded sky over one of the greatest Maldives luxury resorts.', '{"overview_paragraphs":["Return to Heritance Aarah… Wake up to the sound of the sea in paradise, dive among unique underwater wonders, and dine beneath a beautiful star-studded sky over one of the greatest Maldives luxury resorts.","With golden sands at your doorstep and the pull of the sea all around, the options for relaxation and pleasure at our Beach Villa in Maldives seem limitless. Each house is elegantly constructed and has immediate beach access as well as a wide open-air terrace where you can soak in the lovely coastal environment.","Our trademark accommodation, the beautiful Pool Beach Villa, includes a private pool with sun loungers. This Maldives pool property has immediate beach access, ideal for a refreshing plunge in the Indian Ocean''s stunning seas.","Our Ocean Villas, which lie over a beautiful lagoon and overlook a limitless horizon, are the ideal getaway for romantic times. These exquisite Maldives overwater villas provide a separate outdoor space where you may snuggle up on a daybed together or step down to the seas below.","For solitude, Heritance Aarah has 150 villas and suites divided by tropical flora. Every property has immediate access to the pure sandy beach and the stunning blue lagoon beyond. The Resort was planned and developed with a combination of indigenous Maldivian and modern architecture, providing an overall contemporary luxury feel with a Maldivian touch - delivering solitude and comfort for a well-deserved vacation experience.","The resort is located in Raa Atoll, in a picturesque lagoon surrounded by an unending stretch of white sandy beach, and provides visitors with a premium 5-star Maldivian resort experience. A 40-minute seaplane flight from Velana International Airport provides stunning views of the Indian Ocean."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 900, 'kEchVUUdLCg', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'heritance-aarah-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'heritance-aarah-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'aarah'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'heritance-aarah-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 900, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'heritance-aarah-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1000, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'heritance-aarah-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 950, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'heritance-aarah-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Hideaway-Beach
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'hideaway-beach-resort-spa-maldives-island', 'Hideaway Beach Resort & Spa Maldives Island', 'Enjoy the ultimate Maldives beach holiday experience at Hideaway Beach Resort & Spa with our White Platinum All Inclusive Plan. We think that the finest vacations happen naturally, so we''ve included everything you could want in your White Platinum Plan, from excellent meals to fantastic adventures.', 'published', 'Hideaway Beach Resort & Spa Maldives Island | Maldives Resorts | MTG', 'Enjoy the ultimate Maldives beach holiday experience at Hideaway Beach Resort & Spa with our White Platinum All Inclusive Plan. We think that the finest vacations happen naturally, so we''ve included everything you could want in your White Platinum Plan, from excellent meals to fantastic adventures.', '{"overview_paragraphs":["Enjoy the ultimate Maldives beach holiday experience at Hideaway Beach Resort & Spa with our White Platinum All Inclusive Plan. We think that the finest vacations happen naturally, so we''ve included everything you could want in your White Platinum Plan, from excellent meals to fantastic adventures.","The Sunset Beach Villa is a cosy home away from home in a tropical paradise - an excellent setting for a relaxing Maldives beach vacation. This beachside home epitomises understated elegance, located on your very own private beach only moments away from the welcoming blue of the Indian Ocean. In addition to the main bedroom, the villa offers a separate living space. The Sunset Beach Villa includes its own Personal Butler to assist you in tailoring your stay and attending to your requirements.","The Beach Residence with Plunge Pool at Hideaway Beach Resort and Spa in the Maldives is your very own hidden beach home - a luxury villa, the ideal spot to unwind and appreciate paradise''s luxurious surrounds. The villa itself has a living and dining space, a master bedroom, and a spacious bathroom with a jacuzzi bath tub. This villa may be configured to suit families or groups of people. A master bedroom that can be locked affords total seclusion. Its own white sand beach is readily accessible from both the bright and large bedroom and living area. The Beach Residence with Plunge Pool includes its own Personal Butler to assist you in tailoring your stay and attending to your requirements.","The Deluxe Water Villa with Pool at Hideaway Beach Resort and Spa in the Maldives is the pinnacle of Maldivian luxury villa vacations. Allow yourself to be surrounded by the beauty and immensity of the ocean. Built on wooden stilts above the glistening blue lagoon, with floor-to-ceiling windows that maximise the spectacular panoramic Maldivian views. The Deluxe Water Villa with Pool is divided into two portions by an entry space, with the main bedroom on one side and the bathroom on the other. The enormous outside terrace runs the entire length of the property. Couples will appreciate this aquatic hideaway''s subtle modern comfort.","The 103 apartments are located on the beach among coconut trees and lush flora, or on stilts over the lovely lagoon, and provide world-class services as well as incomparable solitude. Each villa at Hideaway Beach Resort Maldives has its own butler to take care of all requirements. Our 10 various villa models, ranging from 130 sqm to 1,420 sqm, are among the largest luxury villas in the Maldives, and all beachfront villas have their own private beach.","Hideaway Beach Resort & Spa is located on the crescent-shaped Dhonakulhi Island in the Maldives'' northwestern Haa Alifu Atoll. Malé is 290 kilometres away."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 700, 'cckWsTSD3l4', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'hideaway-beach-resort-spa-maldives-island'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'hideaway-beach-resort-spa-maldives-island'
  and l.node_type = 'location' and l.slug = 'dhonakulhi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'hideaway-beach-resort-spa-maldives-island'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunset Beach Villa', 700, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'hideaway-beach-resort-spa-maldives-island'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Residence With Pool', 880, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'hideaway-beach-resort-spa-maldives-island'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Water Villa With Pool', 1220, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'hideaway-beach-resort-spa-maldives-island'
on conflict (accommodation_id, name) do nothing;

-- Hotel-Riu
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'riu-palace-maldives-island-resort', 'RIU Palace Maldives Island Resort', 'If you want to spend a luxurious vacation in a tropical paradise, Hotel Riu Palace Maldivas is the place to stay. This Maldives all-inclusive resort is located on the private island of Kedhigandu and provides 24-hour all-inclusive service, free Wi-Fi throughout the hotel, a variety of restaurants, and several leisure and entertainment opportunities.', 'published', 'RIU Palace Maldives Island Resort | Maldives Resorts | MTG', 'If you want to spend a luxurious vacation in a tropical paradise, Hotel Riu Palace Maldivas is the place to stay. This Maldives all-inclusive resort is located on the private island of Kedhigandu and provides 24-hour all-inclusive service, free Wi-Fi throughout the hotel, a variety of restaurants, and several leisure and entertainment opportunities.', '{"overview_paragraphs":["If you want to spend a luxurious vacation in a tropical paradise, Hotel Riu Palace Maldivas is the place to stay. This Maldives all-inclusive resort is located on the private island of Kedhigandu and provides 24-hour all-inclusive service, free Wi-Fi throughout the hotel, a variety of restaurants, and several leisure and entertainment opportunities.","To make your stay as comfortable as possible, the Hotel Riu Palace Maldives offers Junior Suites in various villas, as well as rare overwater suites, some of which have tiny private pools. Its more than 150 rooms have minibars, beverage dispensers, kettles, air conditioning, and satellite television, among other amenities.","If you wish to stay on the beach, these junior rooms at the Hotel Riu Palace Maldives are an excellent alternative. These 40-square-meter rooms have a king-size bed (200x200 cm) or two tiny double beds (125x200 cm), a sofa or sofa-bed in the living area, satellite TV, air conditioning, a ceiling fan, drink dispensers, a minibar, and a kettle. Furthermore, the beachside terrace will make your vacation experience one-of-a-kind.","These exquisite accommodations on the water will provide you with an amazing vacation. These 47-square-meter suites at the Hotel Riu Palace Maldives have one king-size bed (200x200 cm) or two tiny double beds (125x200 cm), a couch in the living area, satellite TV, air conditioning, a ceiling fan, drink dispensers, a minibar, and a kettle. In addition, there is a bathtub, a Balinese bed, sun loungers, and direct access to the sea on the terrace.","The RIU Palace Maldives will have 176 land-based villas with direct sea access and water villas with a private terrace and stairs going to the sea, some of which will have private pools. The Overwater Villas at RIU Palace are believed to be the most luxury since they will include a private pool and baths on the terrace with direct access to the tiny lagoon.","RIU Palace Maldives is located on the pristine island of Gadifuri, part of Dhaalu Atoll, and is connected to their sister resort, RIU Atoll, via a walkway. Its proximity to Kudahuvadhoo Island, which also has a domestic airport, will make getting to these two resorts a breeze."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 400, 'LlGWVpZYozE', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'riu-palace-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'riu-palace-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'kedhigandu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'riu-palace-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Junior Suite With Beach Access', 400, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'riu-palace-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Overwater Suite', 680, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'riu-palace-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Hurawalhi-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'hurawalhi-island-resort-maldives', 'Hurawalhi Island Resort Maldives', 'Hurawalhi Island Resort, located on an idyllic private island in the Maldives'' pristine Lhaviyani Atoll, is much like your relationship: it is a perfect balance of calm and excitement, comfort and adventure; it stirs up your every atom with an intricate blend of closeness and adrenaline.', 'published', 'Hurawalhi Island Resort Maldives | Maldives Resorts | MTG', 'Hurawalhi Island Resort, located on an idyllic private island in the Maldives'' pristine Lhaviyani Atoll, is much like your relationship: it is a perfect balance of calm and excitement, comfort and adventure; it stirs up your every atom with an intricate blend of closeness and adrenaline.', '{"overview_paragraphs":["Hurawalhi Island Resort, located on an idyllic private island in the Maldives'' pristine Lhaviyani Atoll, is much like your relationship: it is a perfect balance of calm and excitement, comfort and adventure; it stirs up your every atom with an intricate blend of closeness and adrenaline.","Hurawalhi is where you may fill your days with an abundance of extraordinary people, your head with wonder, and your heart with romance. The 90-villa, adults-only luxury resort is as beautiful as the ocean that laps against its beaches and more stunning than any island you''ve ever seen. Nothing prepares you for the stunning combination of barefoot joy and contemporary style found at Hurawalhi than photographs of the Maldives.","Enjoy the best of seaside happiness - Beach Pool Villas have a clean, unassuming appeal and an outstanding location on Hurawalhi''s attractive beach. They are popular with couples whose dream vacation includes seaside luxury.","The Maldives'' grandeur is epitomised by sleek and beautiful homes hung over the gleaming Indian Ocean. Slip into the lagoon from the sundeck and experience Hurawalhi''s spectacular grandeur from the solitude of your villa or your very own infinity pool.","Hurawalhi Island Resort''s villas pamper with opulent luxury, exclusivity, and breathtaking views. With the option of beach-side or over-water luxury, you may enjoy your chosen perspective and setting while having paradise at your fingertips - with the ocean just outside your door.","Hurawalhi Island Resort, nestled away in the north of the pristine Lhaviyani Atoll, combines striking natural beauty and elegant design. During the day, a picturesque 40-minute seaplane ride from Velana'' International Airport will take you to this tropical paradise (MLE). The resort is situated on a private coral island that is approximately 400 m x 165 m in size and is surrounded by the Indian Ocean; the year-round warmth of the water in which Hurawalhi Island Resort is situated is comparable to the shades and variations of blue that stretch out as far as the eye can see."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 900, 'xznjFXZmNPI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'hurawalhi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'hurawalhi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'hurawalhi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'hurawalhi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1150, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'hurawalhi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'hurawalhi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Innahura
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'innahura-maldives-island-resort', 'Innahura Maldives Island Resort', 'Innahura''s formula for a fantastic Maldives vacation is simple: we take the key sun, sea, and sand ingredients, add a traditional twist to modern amenities, and top it off with a large dose of unique experiences. This modest jewel in the south-east Lhaviyani Atoll entices sunseekers, young and old, who are looking for a Maldives resort where letting your hair down and savouring life''s simple pleasures are the norm. You''ll fall in love with Innahura because it''s laid-back, fun, and constantly ready for new adventures, just like you.', 'published', 'Innahura Maldives Island Resort | Maldives Resorts | MTG', 'Innahura''s formula for a fantastic Maldives vacation is simple: we take the key sun, sea, and sand ingredients, add a traditional twist to modern amenities, and top it off with a large dose of unique experiences. This modest jewel in the south-east Lhaviyani Atoll entices sunseekers, young and old, who are looking for a Maldives resort where letting your hair down and savouring life''s simple pleasures are the norm. You''ll fall in love with Innahura because it''s laid-back, fun, and constantly ready for new adventures, just like you.', '{"overview_paragraphs":["Innahura''s formula for a fantastic Maldives vacation is simple: we take the key sun, sea, and sand ingredients, add a traditional twist to modern amenities, and top it off with a large dose of unique experiences. This modest jewel in the south-east Lhaviyani Atoll entices sunseekers, young and old, who are looking for a Maldives resort where letting your hair down and savouring life''s simple pleasures are the norm. You''ll fall in love with Innahura because it''s laid-back, fun, and constantly ready for new adventures, just like you.","Palm trees sway in the air, loungers vie for your attention under them, a length of sand so silky it tickles your feet and takes you from your bungalow to a lagoon as clear as it gets - welcome to Innahura! This is most likely how you imagined your Maldives vacation...","Innahura''s allure rests in his return to simplicity. The bungalows at the resort are designed for folks like you and me: they are simple yet comfortable, unassuming yet unforgettable. They deliver on the promise of a tropical, laid-back refuge from which to lavish on the island''s many attractions. These bright bungalows are big, on the beach, with a minibar, and private sunloungers - these are all your Maldives fantasies are made of, without the expensive price tag.","Innahura Maldives has 78 luxurious accommodations, including 33 Sunset Beach Bungalows and 45 Sunrise Beach Bungalows, as well as 4 neighbouring bungalows for families.","The island of Innahura Maldives is located in the Lhaviyani Atoll to the north of the Maldives. It takes 40 minutes by seaplane, during which you may enjoy a breathtaking view of the Maldives'' garland of islands.","Life is better at the beach, especially when accompanied with delicious food, refreshing beverages, and great company. The resort''s venues bring it all together and contribute to the mix of Innahura''s characteristic casual ambiance; mellow places that keep your tummy full, your thirst satiated, and your days filled with get-togethers and unplanned meet-ups with newly made friends."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 300, '6JHqOSK--sw', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'innahura-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'innahura-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'innahura'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'innahura-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Villa', 300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'innahura-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- InterContinental
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'intercontinental-maldives-maamunagau-island-resort', 'InterContinental Maldives Maamunagau Island Resort', 'In the vast azure panorama of the Indian Ocean, escape and reconnect with nature, yourself, and those who mean most. From the time you board the seaplane to the serene shores of the Raa Atoll, you will be captivated by island life with silky white dunes and palm tree dotted terraces. Prepare to be astounded by the abundance of marine life in our lagoon, which is near to the UNESCO Biosphere Reserve and has a unique manta ray sanctuary.', 'published', 'InterContinental Maldives Maamunagau Island Resort | Maldives Resorts | MTG', 'In the vast azure panorama of the Indian Ocean, escape and reconnect with nature, yourself, and those who mean most. From the time you board the seaplane to the serene shores of the Raa Atoll, you will be captivated by island life with silky white dunes and palm tree dotted terraces. Prepare to be astounded by the abundance of marine life in our lagoon, which is near to the UNESCO Biosphere Reserve and has a unique manta ray sanctuary.', '{"overview_paragraphs":["In the vast azure panorama of the Indian Ocean, escape and reconnect with nature, yourself, and those who mean most. From the time you board the seaplane to the serene shores of the Raa Atoll, you will be captivated by island life with silky white dunes and palm tree dotted terraces. Prepare to be astounded by the abundance of marine life in our lagoon, which is near to the UNESCO Biosphere Reserve and has a unique manta ray sanctuary.","When you hire the entire island for an intimate family celebration or business trip, you will find something for everyone with a variety of eating places, miles of beautiful beach, and a choice of recreational and wellness activities.","The InterContinental Maldives Maamunagau Resort''s spacious 81 Beach, Lagoon, and Overwater Villas and Residences provide stunning views of the Maldives. Choose between relaxing lagoon or dramatic ocean views from your private patio, and enjoy a beautiful dawn or sunset.","The resort is located on a private island in Raa Atoll, 152 kilometres north of Velana International Airport. Guests will be charmed by the unusual marine life, which includes manta rays and dolphins, since it is located adjacent to the Baa Atoll UNESCO Reserve. Among these intriguing spots to visit nearby, Hanifaru Bay is 35 minutes away by speedboat and is well-known for being a nursery ground for grey sharks and sting rays.","Simple yet remarkable, guests will begin on a gastronomic adventure from the top of the Lighthouse with a predinner cocktail and rare 360 degree views of the Indian Ocean, followed by a personalised private dining experience or a communal sharing dinner at the main restaurant area.","AVI Spa is meant to rejuvenate the spirit by waking the senses and is inspired by the ethereality of the ocean and the transforming power of clean island air. Rejuvenate in one of six over-the-water treatment villas, each of which uses the psychology of natural light and sound to put you in a profound state of relaxation."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 800, 'enmAUSapMec', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'intercontinental-maldives-maamunagau-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'intercontinental-maldives-maamunagau-island-resort'
  and l.node_type = 'location' and l.slug = 'maamunagau'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'intercontinental-maldives-maamunagau-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1200, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'intercontinental-maldives-maamunagau-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Overwater Pool Villa', 800, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'intercontinental-maldives-maamunagau-island-resort'
on conflict (accommodation_id, name) do nothing;

-- JA-Manafaru
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'ja-manafaru-maldives-island-resort', 'JA Manafaru Maldives Island Resort', 'Dreams of Romance in a Tropical Island Paradise Experience an enchanting island retreat in the Maldives'' remote sanctuary of JA Manafaru. A tropical Maldives resort in the Indian Ocean blends the tranquillity of the Maldives with six venues, extra In-villa and Destination Dining offers, numerous recreational activities, and unique spa and wellness amenities.', 'published', 'JA Manafaru Maldives Island Resort | Maldives Resorts | MTG', 'Dreams of Romance in a Tropical Island Paradise Experience an enchanting island retreat in the Maldives'' remote sanctuary of JA Manafaru. A tropical Maldives resort in the Indian Ocean blends the tranquillity of the Maldives with six venues, extra In-villa and Destination Dining offers, numerous recreational activities, and unique spa and wellness amenities.', '{"overview_paragraphs":["Dreams of Romance in a Tropical Island Paradise Experience an enchanting island retreat in the Maldives'' remote sanctuary of JA Manafaru. A tropical Maldives resort in the Indian Ocean blends the tranquillity of the Maldives with six venues, extra In-villa and Destination Dining offers, numerous recreational activities, and unique spa and wellness amenities.","Set amid a beautiful oasis around the resort''s main swimming pool, the Mediterranean-inspired Bistro is available for lunch and afternoon meals until early evening. Ideal for couples and families that require all-day dining till late meal.","Pool on the beach Villa surrounded by tropical vegetation, just steps from the gorgeous beach and your private beach cabana. Cozy living rooms with an open-air bathroom that leads to an attractive sundeck, a pool, a daybed and sun loungers in the garden and on the beach. While dining al fresco in your private beach dining cabana, take in the wind.","Wake awake to the sound of the Indian Ocean. As the sun rises over the horizon, watch the water below your villa reflect the morning light from your sun terrace. Connect with nature directly from your villa or view from the glass floor panel in luxury. Relax your body and mind in your own infinity pool or on the terrace with the most breathtaking views.","Do you fantasise of a romantic getaway in your own overwater villa with direct access to the ocean? Maybe you fantasise of walking out of your Beach Villa onto the lovely beach that surrounds the island. Whatever your heart desires, we offer many of alternatives for your island stay, and all of them include your very own private plunge pool and daily breakfast. Discover nature''s splendours at their best. Whether you choose beachfront or waterfront living, each of JA Manafaru''s 84 villas and homes has been designed to fit in with the island''s natural scenery.","Domestic flight: The trip from Male'' International Airport to Hanimadhoo Island takes around 55 minutes. After that, a 45-minute speedboat ride from Hanimadhoo Island to JA Manafaru Private Island follows. Private seaplane flight: The voyage from Male'' International Airport to JA Manafaru Private Island takes around 90 minutes."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 1200, 'RUmR4femVf4', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'ja-manafaru-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'ja-manafaru-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'manafaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'ja-manafaru-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1200, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'ja-manafaru-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Water Villa Pool', 1400, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'ja-manafaru-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- JOALI
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'joali-maldives-island-resort', 'JOALI Maldives Island Resort', 'Our tale began with the ambition of creating a one-of-a-kind creative resort in the beautiful Raa Atoll. Thus was created JOALI Maldives, an utopia of creativity, pleasure, and adventure. Through a magnificent collection of artworks that spread over the island, visitors may feel the joy of life.', 'published', 'JOALI Maldives Island Resort | Maldives Resorts | MTG', 'Our tale began with the ambition of creating a one-of-a-kind creative resort in the beautiful Raa Atoll. Thus was created JOALI Maldives, an utopia of creativity, pleasure, and adventure. Through a magnificent collection of artworks that spread over the island, visitors may feel the joy of life.', '{"overview_paragraphs":["Our tale began with the ambition of creating a one-of-a-kind creative resort in the beautiful Raa Atoll. Thus was created JOALI Maldives, an utopia of creativity, pleasure, and adventure. Through a magnificent collection of artworks that spread over the island, visitors may feel the joy of life.","An art-infused luxury island resort located on Muravandhoo Island in Raa Atoll in the Maldives'' northernmost reaches. Coral reefs teem with life and colour where lovely white dunes meet magnificent blue seas. Raise a glass to long-lasting glamour in this enchanted realm, a constant expression of joie de vivre.","Our luxurious one-bedroom beach home offers views of the Maldives'' beach, garden, and ocean. Featuring hand-selected art objects, a private beach garden, and an infinity pool.","Discover the allure of ocean life from this one-bedroom water cottage. You are in for an unforgettable luxury resort experience.","Discover the best of island living. Awaken to glistening seascapes and delicate white dunes. Experience the awe of an impressionist sunset. Allow the waves to lull you to sleep. The Indian Ocean is your constant companion, bringing you joy at all hours of the day and night. The magnificent private villas and houses at the resort epitomise sustainable luxury. Each of JOALI''s 73 villas was inspired by a different story and was created to take visitors on a sensory journey. An environment of unusual luxury is created through artisanal amenities, selected in-room book shelves, careful décor, and exquisite objet d''art.","JOALI Maldives is located on Muravandhoo island in the Raa Atoll in the Maldives'' northernmost region. Arriving guests will be welcomed inside the special JOALI airport lounge at Male Airport. Before your transfer to the resort, you may unwind there. Transfer takes 40 minutes by seaplane or 35 minutes by domestic flight followed by 15 minutes by speedboat."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 2300, '0VIhza1IyE0', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'joali-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'joali-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'muravandhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'joali-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 2900, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'joali-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa Pool', 2300, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'joali-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- JW-Marriott
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'jw-marriott-maldives-island-resort', 'JW Marriott Maldives Island Resort', 'JW Marriott Maldives Resort & Spa is a picturesque luxury haven on the blue seas of Shaviyani Atoll. Relax in contemporary overwater villas and beach villas with luxurious mattresses, private pools, and decks with breathtaking views of the Indian Ocean. At our different dining places, delight your palette with exceptional Japanese, Italian, and world cuisine, as well as treetop dining and buffet breakfasts. Explore a wide range of sports such as snorkelling, scuba diving, jet skiing, and sailing. Our Little Griffins kids'' group allows children to have their own experiences in the Maldives. Refresh in our dazzling pool or have an intense workout in our modern fitness centre. Make a wonderful day in Shaviyani Atoll with a refreshing beauty or massage treatment.', 'published', 'JW Marriott Maldives Island Resort | Maldives Resorts | MTG', 'JW Marriott Maldives Resort & Spa is a picturesque luxury haven on the blue seas of Shaviyani Atoll. Relax in contemporary overwater villas and beach villas with luxurious mattresses, private pools, and decks with breathtaking views of the Indian Ocean. At our different dining places, delight your palette with exceptional Japanese, Italian, and world cuisine, as well as treetop dining and buffet breakfasts. Explore a wide range of sports such as snorkelling, scuba diving, jet skiing, and sailing. Our Little Griffins kids'' group allows children to have their own experiences in the Maldives. Refresh in our dazzling pool or have an intense workout in our modern fitness centre. Make a wonderful day in Shaviyani Atoll with a refreshing beauty or massage treatment.', '{"overview_paragraphs":["JW Marriott Maldives Resort & Spa is a picturesque luxury haven on the blue seas of Shaviyani Atoll. Relax in contemporary overwater villas and beach villas with luxurious mattresses, private pools, and decks with breathtaking views of the Indian Ocean. At our different dining places, delight your palette with exceptional Japanese, Italian, and world cuisine, as well as treetop dining and buffet breakfasts. Explore a wide range of sports such as snorkelling, scuba diving, jet skiing, and sailing. Our Little Griffins kids'' group allows children to have their own experiences in the Maldives. Refresh in our dazzling pool or have an intense workout in our modern fitness centre. Make a wonderful day in Shaviyani Atoll with a refreshing beauty or massage treatment.","JW Marriott Maldives Resort & Spa offers 60 luxury Beach and Overwater Pool Villas with living sizes ranging from 234 sqm to 285 sqm. Our beautiful and large Beach and Overwater Pool Villas are suitable for both couples and families visiting Maldives, with contemporary and airy décor offering the utmost seclusion and tranquillity. From your private villa terrace with its own huge private wooden deck, pool, and outdoor shower, you may enjoy an unimpeded view of the Indian Ocean or our island''s beautiful tropical gardens. Each villa at the JW Marriott Maldives Resort & Spa is inspired by the natural surroundings and Maldivian culture, with colours and materials that reflect the island locale. Villas'' thatched roofs are suggestive of upside-down Dhoni boats, Maldives'' traditional wooden fishing vessels, and sloping roof tips are reminiscent of white herons dipping their heads into the ocean.","JW Marriott Maldives Resort & Spa provides a tropical island haven with 61 magnificent Beach and Overwater Pool villas in the remote Shaviyani Atoll. The Villas have been created with modern roomy and airy interiors that give an intimate setting that allows for seclusion while still providing thoughtful interacting places if desired.","JW Marriott Maldives Resort & Spa is located on the beautiful island of Van''gaaru in the Shaviyani Atoll, a picturesque 55-minute seaplane ride from Velana International Airport in Male, Maldives.","JW Marriott Maldives Resort & Spa offers a diverse range of gastronomic experiences. Begin your day with a hearty breakfast at Aailaa, then order your favourite pizza from Fiamma for a quiet lunch by the pool, or spice up your day with genuine Thai food from Kaashi. Horizon offers a tranquil view of the Maldivian sunset while serving your favourite cocktails. Visit our Wine Room for a wine-pairing dining experience, or Rum Baan to build your own drink. For pre-dinner beverages, try our famous smoked cocktails at Wabi Sabi before indulging in Japanese delicacies at Hashi or the best prime cut meats and crustaceans at Shio, our namesake restaurant.","We believe that genuine well-being begins with mind-body harmony at Spa by JW. As a result, we design places that can support a variety of health activities, from activeness to more restorative mindfulness periods, while letting in natural light and enabling access to more natural settings. There is no better place in the world to experiment with natural remedies than on a private island paradise. Join us for a Personal Training Session, a Personal Yoga Class, or a Guided Meditation to revitalise your mind, body, and spirit."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 750, 'EHZiO7QOToA', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'jw-marriott-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'jw-marriott-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'vagaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'jw-marriott-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Pool Villa', 800, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'jw-marriott-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Over Water Villa Pool', 750, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'jw-marriott-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Jumeirah-Olhahali
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'jumeirah-maldives-olhahali-island-resort', 'Jumeirah Maldives Olhahali Island Resort', 'The Jumeirah Maldives Olhahali Island is an all-day dining venue with professional chefs serving a diverse menu of foreign delicacies. Take in the soft sea breeze on the open-air terrace atop the seclusion of your beautiful villa while you revel in your rooftop movie experience, whether it''s a treasured family event or a significant romantic getaway. Our beach boutique offers an uplifting luxury experience for discerning travellers seeking serenity away from it all. Discover a diverse range of outstanding and ecologically responsible resort wear, menswear, womenswear, childrenswear, accessories, and jewellery from across the world, as well as Maldivian crafts.', 'published', 'Jumeirah Maldives Olhahali Island Resort | Maldives Resorts | MTG', 'The Jumeirah Maldives Olhahali Island is an all-day dining venue with professional chefs serving a diverse menu of foreign delicacies. Take in the soft sea breeze on the open-air terrace atop the seclusion of your beautiful villa while you revel in your rooftop movie experience, whether it''s a treasured family event or a significant romantic getaway. Our beach boutique offers an uplifting luxury experience for discerning travellers seeking serenity away from it all. Discover a diverse range of outstanding and ecologically responsible resort wear, menswear, womenswear, childrenswear, accessories, and jewellery from across the world, as well as Maldivian crafts.', '{"overview_paragraphs":["The Jumeirah Maldives Olhahali Island is an all-day dining venue with professional chefs serving a diverse menu of foreign delicacies. Take in the soft sea breeze on the open-air terrace atop the seclusion of your beautiful villa while you revel in your rooftop movie experience, whether it''s a treasured family event or a significant romantic getaway. Our beach boutique offers an uplifting luxury experience for discerning travellers seeking serenity away from it all. Discover a diverse range of outstanding and ecologically responsible resort wear, menswear, womenswear, childrenswear, accessories, and jewellery from across the world, as well as Maldivian crafts.","A isolated one-bedroom villa with its own infinity pool that ends only with the atoll''s beautiful dunes and blue ocean. Relax on your rooftop or poolside and enjoy views that are uniquely yours.","Our Water Villa is perched atop the coral, on a pier extending out into the blue waters of the North Lagoon. From your private rooftop terrace, where you may dine or simply rest, you can see even further across the ocean. Sit in a covered sunken salon on the lower deck, or chill off and drift in your own pool.","Each house is capped with a stunning private Sky-Lounge for the first time in the Maldives. Every room, whether on the beach or on stilts over water, has a private pool and an inspiring expanse of sky-lounge roof deck. With all seven accommodation types elevating indoor-outdoor living to new heights of breezy sophistication, this is a Maldives-exclusive elevated island experience.","It takes 45 minutes by luxury speedboat from Velana International Airport to reach this tiny resort, which is a visual feast of nautical forms and tones. Each of the 67 double-story villas offers a private pool with a vibrant South Beach vibe, thanks to the new vision of Singaporean design studio Miaja.","Set sail over the glistening sea on one of Jumeirah Maldives'' special yachts, from awe-inspiring sunset cruises to a joyous adventure in search of the friendly Maldivian dolphins. Guests at Jumeirah Maldives may also book chartered tailored excursions, including as fishing trips or visits to other local islands."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 2100, 'EAExZzTcTGI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'jumeirah-maldives-olhahali-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'jumeirah-maldives-olhahali-island-resort'
  and l.node_type = 'location' and l.slug = 'olhahali'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'jumeirah-maldives-olhahali-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 2300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'jumeirah-maldives-olhahali-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa Pool', 2100, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'jumeirah-maldives-olhahali-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Kandima
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'kandima-maldives-island-resort', 'Kandima Maldives Island Resort', 'KWelcome to one of the world''s most beautiful islands: a UNESCO Biosphere Reserve wilderness where iridescent blues, jungle greens, and bright whites collide with innovation, conservation, and health. Snorkel with manta rays in aquarium-like waters, help sea turtles at our Marine Discovery Centre, relax at AyurMa, and eat at Blu Beach Club. Kandima Maldives is more than simply a vacation; it''s a way of life! Experience this new game-changing location, which features 264 elegantly built apartments and villas, 10 amazing eating establishments, and a plethora of fun-filled activities. This very sophisticated resort welcomes visitors of all ages and income levels, including families, couples, groups of friends, and honeymooners. Kandima Maldives provides something for everyone, whether you''re looking for a romance holiday, aquatic adventures, fitness activities, spa escapes, or just family time. The island, located in the Dhaalu Atoll, is only a thirty-minute flight from Velana International Airport, followed by a twenty-minute boat journey to this very elegant island.', 'published', 'Kandima Maldives Island Resort | Maldives Resorts | MTG', 'KWelcome to one of the world''s most beautiful islands: a UNESCO Biosphere Reserve wilderness where iridescent blues, jungle greens, and bright whites collide with innovation, conservation, and health. Snorkel with manta rays in aquarium-like waters, help sea turtles at our Marine Discovery Centre, relax at AyurMa, and eat at Blu Beach Club. Kandima Maldives is more than simply a vacation; it''s a way of life! Experience this new game-changing location, which features 264 elegantly built apartments and villas, 10 amazing eating establishments, and a plethora of fun-filled activities. This very sophisticated resort welcomes visitors of all ages and income levels, including families, couples, groups of friends, and honeymooners. Kandima Maldives provides something for everyone, whether you''re looking for a romance holiday, aquatic adventures, fitness activities, spa escapes, or just family time. The island, located in the Dhaalu Atoll, is only a thirty-minute flight from Velana International Airport, followed by a twenty-minute boat journey to this very elegant island.', '{"overview_paragraphs":["KWelcome to one of the world''s most beautiful islands: a UNESCO Biosphere Reserve wilderness where iridescent blues, jungle greens, and bright whites collide with innovation, conservation, and health. Snorkel with manta rays in aquarium-like waters, help sea turtles at our Marine Discovery Centre, relax at AyurMa, and eat at Blu Beach Club. Kandima Maldives is more than simply a vacation; it''s a way of life! Experience this new game-changing location, which features 264 elegantly built apartments and villas, 10 amazing eating establishments, and a plethora of fun-filled activities. This very sophisticated resort welcomes visitors of all ages and income levels, including families, couples, groups of friends, and honeymooners. Kandima Maldives provides something for everyone, whether you''re looking for a romance holiday, aquatic adventures, fitness activities, spa escapes, or just family time. The island, located in the Dhaalu Atoll, is only a thirty-minute flight from Velana International Airport, followed by a twenty-minute boat journey to this very elegant island.","Welcome to your own cool and elegant hideaway. Take in the breathtaking view of Kandima''s huge lagoon from above the treetops, or just walk to the shore. Do you require extra space? We have 8 Two-Bedroom Family Sky Suites that are joined by a lounge space and are ideal for groups of friends or families that want to stay near together. That''s what we mean by \"home away from home.\"","Do you need some sea rehabilitation? These villas are perched overwater and have direct access to the lagoon, making them ideal for those looking for the ultimate overwater vacation. The private sundeck with sun loungers and a bathroom give a stunning view of Kandima''s expansive lagoon. Your daily \"vitamin sea\" dosage is assured.","Our 264 apartments and villas are not just elegantly pleasant, but also intelligent! Our apartments and villas are anything from average, with tech-savvy amenities, service at your fingertips, and bright and airy décor. Even if you''re miles from anything, you can stay connected with free Wi-Fi.","Kandima Maldives is located on one of the Maldives'' most secluded atolls. Only 7 of the atoll''s 57 islands are inhabited, making Dhaalu atoll one of the country''s most pristine places.","This trendy beach house on the beach with indoor and outdoor seating provides informal dining by day and sophisticated trademark dining on the beach by night. Enjoy an unlimited variety of Mediterranean cuisine, seafood, tapas, steaks, oven-baked pizzas, and great wines from our cellar. With a wide garden area, this restaurant is ideal for hosting outdoor gala dinner events for bigger parties or gatherings of family and friends."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, null, 'yUpZcB6oe_A', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'kandima-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'kandima-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'kandima'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'kandima-maldives-island-resort'
on conflict (id) do nothing;
