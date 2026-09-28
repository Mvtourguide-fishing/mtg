-- Part 8 of 14 - run this in the Supabase SQL Editor AFTER the previous parts.
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

-- Mirihi-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'mirihi-island-resort-maldives', 'Mirihi Island Resort Maldives', 'Mirihi Island Resort is a modest and precious jewel with white sands and swaying palms in the soft air. Surrounded by the infinite azure of the Indian Ocean, eco-friendly Mirihi is one of the Maldives'' tiniest resorts, giving our guests the unique impression of being on their own little island.', 'published', 'Mirihi Island Resort Maldives | Maldives Resorts | MTG', 'Mirihi Island Resort is a modest and precious jewel with white sands and swaying palms in the soft air. Surrounded by the infinite azure of the Indian Ocean, eco-friendly Mirihi is one of the Maldives'' tiniest resorts, giving our guests the unique impression of being on their own little island.', '{"overview_paragraphs":["Mirihi Island Resort is a modest and precious jewel with white sands and swaying palms in the soft air. Surrounded by the infinite azure of the Indian Ocean, eco-friendly Mirihi is one of the Maldives'' tiniest resorts, giving our guests the unique impression of being on their own little island.","We are a world apart, a heaven of calm and tranquillity, with no television in the villas, no motorised water sports, no discos or nightlife to bother you with loud music and noise, and nothing else to come between you and the genuine definition of relaxation and joy. Our customised service and committed team of well-trained professionals ensure that your experience is as unspoiled and soothing as if you were the first to come in a location designed just for you, and as unique as you are.","Six elegantly constructed Beach Villas (53 m2) are ideally placed on the island''s sunset side, with direct access to our talcum powdery beach. These cosy homes, surrounded by thick tropical flora and swaying palms, provide full solitude and unrivalled ocean views. Designer furnishings, polished wooden flooring, king or twin beds, semi-open air baths, Bose audio system with Bluetooth connectivity, free high speed WI-FI, Nespresso machine, personal safe, and fully stocked Villa Bar are all included.","Our 30 Water Villas (53 m2) are built on stilts over the blue lagoon and provide direct access to our lively house reef. These nicely constructed cosy villas are endowed with an unbroken view of the blue ocean from the entire seclusion of the sun deck, with a view of the dawn or sunset. All Villas feature the same high-quality designer furnishings, polished wooden floors, king-size or twin beds, en suite bathrooms with glass doors overlooking the Indian Ocean, Bose music system with Bluetooth connectivity, free high-speed Wi-Fi, Nespresso machine, personal safe, and fully stocked Villa Bar. The Water Villa requires children to be 8 years old for safety reasons.","The 37 attractively constructed Villas have recently been refurbished, delivering luxury and comfort while also providing space and natural light. They are conveniently positioned all across the island and provide perfect seclusion. Each luxurious mansion is given a distinct Dhivehi (Maldivian) name drawn from the land or sea. The villas, which include 6 Beach Villas, 30 Water Villas, 1 Two-Bedroom Water Suite, and 1 Two-Bedroom Beach Suite, are exquisitely positioned around the island and above the active house reef, providing unending views of the vast horizon. Each villa is the ideal hideaway from the rest of the world, whether from your private deck or private beach.","The island is only 350 metres long and 50 metres broad, with palm-fringed beaches and powder soft, sun-kissed sand. This beautiful, private island is reached through a 30-minute seaplane flight and is encircled by 6 kilometres of one of the Maldives'' greatest house reefs. It''s also a great place to watch whale sharks."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 550, '22tRj_0CFDQ', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'mirihi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'mirihi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'mirihi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'mirihi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'mirihi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 550, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'mirihi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Movenpick
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'movenpick-resort-kuredhivaru-maldives-resort', 'Movenpick Resort Kuredhivaru Maldives Resort', 'The Mövenpick Resort Kuredhivaru Maldives is a beautiful refuge and tropical paradise located in the unspoiled Noonu Atoll. Our 5 star luxury beach resort is located 45 minutes north of Male International Airport. In each of the 72 overwater pool villas, 30 beach pool suites, and three beach spa pool homes, you may relax in your own private plunge pool.', 'published', 'Movenpick Resort Kuredhivaru Maldives Resort | Maldives Resorts | MTG', 'The Mövenpick Resort Kuredhivaru Maldives is a beautiful refuge and tropical paradise located in the unspoiled Noonu Atoll. Our 5 star luxury beach resort is located 45 minutes north of Male International Airport. In each of the 72 overwater pool villas, 30 beach pool suites, and three beach spa pool homes, you may relax in your own private plunge pool.', '{"overview_paragraphs":["The Mövenpick Resort Kuredhivaru Maldives is a beautiful refuge and tropical paradise located in the unspoiled Noonu Atoll. Our 5 star luxury beach resort is located 45 minutes north of Male International Airport. In each of the 72 overwater pool villas, 30 beach pool suites, and three beach spa pool homes, you may relax in your own private plunge pool.","Mövenpick Resort Kuredhivaru Maldives'' restaurants brilliantly mix gourmet delights with breathtaking views of the Maldives. You may treat yourself and your loved one endlessly throughout your relaxed vacation with us in the Maldives, from a seafood fine dining experience to a private romantic candlelit meal on the beach.","Feel the sand between your toes as you walk along the powder-white beaches and explore the plethora of colourful marine life that the Indian Ocean has to offer. Enjoy delicious food at three restaurants and a refreshing drink at our bar while admiring the breathtaking views of the Indian Ocean. Relax at the Healing Earth Sun Spa, redirect your energy with yoga, and let your kids play at the Little Birds Club. Allow us to tailor-make a very distinctive Maldives experience for you during your stay at Mövenpick Resort Kuredhivaru Maldives.","This home is surrounded by beautiful nature and is located right close to a white-sand beach. Relax by your own infinity pool or relax in a swinging chair outdoors. Enjoy the stunning Maldivian reef, as well as free Chocolate Hours, snorkelling equipment, and non-motorized watersports.","Our over water villas with see-through floors provide lagoon views and are located over the turquoise lagoon. Open the glass doors and dive into your infinity-edge pool. Daily Chocolate Hours, unlimited water, snorkelling equipment, and non-motorized water activities are all available.","Mövenpick Resort boasts a modern design with an emphasis on comfortable accommodations and a secluded, yet dynamic resort experience. Every modern convenience is integrated with the desert-island luxury, reflecting Mövenpick''s famous devotion to authentic comforts provided extremely well."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 800, 'hEpEZxGW_Js', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'movenpick-resort-kuredhivaru-maldives-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'movenpick-resort-kuredhivaru-maldives-resort'
  and l.node_type = 'location' and l.slug = 'kuredhivaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'movenpick-resort-kuredhivaru-maldives-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Suite', 1000, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'movenpick-resort-kuredhivaru-maldives-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Pool Lagoon', 800, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'movenpick-resort-kuredhivaru-maldives-resort'
on conflict (accommodation_id, name) do nothing;

-- Nika-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'nika-island-resort-spa-maldives', 'Nika Island Resort & Spa Maldives', 'Nika Island is a piece of Maldivian history, since it was one of the first islands in Ari Atoll to become a world-renowned tourist attraction. Nika Island is our collective imagination''s paradise island. A forum where traditional Maldivian beauty and custom meet Italian culture. Nothing has changed on the island of Nika. A destination where you may relive the Maldives of yesteryear. "A item of beauty is a delight forever," said the English poet Keats, and Nika''s beauty beyond words. This island is frozen in time, impervious to the tremendous tourism forces that are altering the Maldives today. An unrepeatable and completely successful alchemical experiment that has written a significant chapter in history.', 'published', 'Nika Island Resort & Spa Maldives | Maldives Resorts | MTG', 'Nika Island is a piece of Maldivian history, since it was one of the first islands in Ari Atoll to become a world-renowned tourist attraction. Nika Island is our collective imagination''s paradise island. A forum where traditional Maldivian beauty and custom meet Italian culture. Nothing has changed on the island of Nika. A destination where you may relive the Maldives of yesteryear. "A item of beauty is a delight forever," said the English poet Keats, and Nika''s beauty beyond words. This island is frozen in time, impervious to the tremendous tourism forces that are altering the Maldives today. An unrepeatable and completely successful alchemical experiment that has written a significant chapter in history.', '{"overview_paragraphs":["Nika Island is a piece of Maldivian history, since it was one of the first islands in Ari Atoll to become a world-renowned tourist attraction. Nika Island is our collective imagination''s paradise island. A forum where traditional Maldivian beauty and custom meet Italian culture. Nothing has changed on the island of Nika. A destination where you may relive the Maldives of yesteryear. \"A item of beauty is a delight forever,\" said the English poet Keats, and Nika''s beauty beyond words. This island is frozen in time, impervious to the tremendous tourism forces that are altering the Maldives today. An unrepeatable and completely successful alchemical experiment that has written a significant chapter in history.","10 Beach Villas (about 80 square feet) with a double room, living area, and bathroom. They are on the north side of the island, facing a big lagoon, with swimming access to the barrier reef from your own private beach. All Beach Villas face the ocean and are constructed with natural materials in accordance with Maldives architectural heritage norms. They are separated from one another by thick greenery and are encircled by a garden with gazebo and hot tub. One Beach Villa has been modified to accommodate people with disabilities.","8 Water Villas (about 1200sqft) with double room, living room, bathroom, terrace with direct beach access, and solarium. Water Villas are located on the north side of the island in the lagoon, facing one of the best maintained barrier reefs in the Indian Ocean. Water Villas are divided into three levels: the first is on the water, where you can dive right in; the second is a wooden terrace where you can rest on comfy deck chairs; and the third is on the roof, where you can watch the ocean and enjoy the wonderful sea wind. Guests have access to two public beaches with sun loungers, bathrooms, and beach umbrellas, one near the Water Villas boardwalk and one in front of the hotel.","Only 43 villas on an island surrounded by a gorgeous house reef, rich greenery, and helpful personnel will make you feel perfectly at home: 6 Garden rooms, 10 Beach Villas, 10 Deluxe Beach Villas, 3 Family Beach Villas, 3 Family Deluxe Beach Villas, 1 Sultan Suite, and 10 Water Villas.","Nika Island Resort & Spa is situated on its own own island on the western fringe of North Ari Atoll. Male International Airport is 75 kilometres away and may be reached in 25/30 minutes by seaplane. The Nika Maldives experience begins with a warm greeting from the resort host at the arrival port, who will accompany visitors to the Nika lounge till the departure by sea plane for the breathtaking ride to the resort.","Nika Restaurant provides full-board, half-board, and all-inclusive packages, with a buffet meal rotating alongside an à la carte menu. A Maldivian feast and BBQ is offered once a week. The restaurant is a big open-air building that is appealing. The food is mostly Italian and Mediterranean. Our chefs are available to accommodate any requirement, even customers with dietary sensitivities. The wine cellar on the island has approximately 100 different varieties of wine. A unique candlelit meal with a fish-and-shellfish-based cuisine may be organised upon request, either on your villa''s private beach or on the desert island within a few minutes boat ride from Nika."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 400, '7WBGJrqLLz4', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'nika-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'nika-island-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'kudafolhudhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'nika-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 400, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'nika-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 450, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'nika-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- Noku
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'noku-maldives-island-resort', 'Noku Maldives Island Resort', 'Twenty beach villas and 30 over-water villas are nestled among lush tropical flora and surrounded by a tranquil blue lagoon. Each spacious unit is intended to give maximum seclusion and is outfitted with modern conveniences to ensure comfort. Each villa''s subtle elegance, with gentle white colours and dark wood accents, complements the splendour of nature as viewed via huge bay windows and french doors.', 'published', 'Noku Maldives Island Resort | Maldives Resorts | MTG', 'Twenty beach villas and 30 over-water villas are nestled among lush tropical flora and surrounded by a tranquil blue lagoon. Each spacious unit is intended to give maximum seclusion and is outfitted with modern conveniences to ensure comfort. Each villa''s subtle elegance, with gentle white colours and dark wood accents, complements the splendour of nature as viewed via huge bay windows and french doors.', '{"overview_paragraphs":["Twenty beach villas and 30 over-water villas are nestled among lush tropical flora and surrounded by a tranquil blue lagoon. Each spacious unit is intended to give maximum seclusion and is outfitted with modern conveniences to ensure comfort. Each villa''s subtle elegance, with gentle white colours and dark wood accents, complements the splendour of nature as viewed via huge bay windows and french doors.","Each of the contemporary Beach Villas is large and stylishly constructed to capture natural light and amazing views of the Indian Ocean, and is surrounded by lush tropical foliage. Enjoy a visual delight of a Maldivian sunrise or sunset from the direct beach access and spacious sundeck.","Wake up to a stunning dawn through the gentle white tones of this one-bedroom villa, or from the expansive sundeck with a private plunge pool. Enjoy cleaning routines in the outdoor rain shower, indoor shower, or standalone bathtub.","This magnificent one-bedroom house positioned immediately above the turquoise lagoon, facing South East, offers unrivalled views of the Indian Ocean. A spacious sundeck captures the spectacular dawn and gives direct access to the water below. There are indoor and outdoor showers as well as a standalone bathtub for further relaxation.","The resort has been elegantly renovated using sustainable materials, selected hand-made design items, and attention to detail on the island of Kuda-Funafaru in Noonu Atoll, 189 kilometres from Velana International Airport. The island is 750 metres long and 250 metres wide, making it the ideal size for relaxing in tropical tranquillity.","From locally grown vegetables with a Maldivian twist to international cuisine such as Japanese, Singaporean, and Thai, there is something for everyone. Our menu selection at Thari Restaurant, which includes components of Maldivian, Thai, Japanese, and Singaporean cuisines, will give you a flavorful sense of the nations where our Noku hotels are located."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 800, 'LRyhlGZy_q0', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'noku-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'noku-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'kudafunafaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'noku-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 800, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'noku-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1000, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'noku-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 850, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'noku-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Nova
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'nova-maldives-island-resort', 'NOVA Maldives Island Resort', 'Everyone is welcome to our home-away-from-home, whether they are travelling alone, with loved ones, friends, or family. You may do whatever you want here, as much or as little as your spirit wishes. Dive, go to the gym, or relax beneath the palm trees and enjoy something simple and genuine. I''m glad to be here. Happy in the moment- at Nova, one of the top all-inclusive resorts in the Maldives.', 'published', 'NOVA Maldives Island Resort | Maldives Resorts | MTG', 'Everyone is welcome to our home-away-from-home, whether they are travelling alone, with loved ones, friends, or family. You may do whatever you want here, as much or as little as your spirit wishes. Dive, go to the gym, or relax beneath the palm trees and enjoy something simple and genuine. I''m glad to be here. Happy in the moment- at Nova, one of the top all-inclusive resorts in the Maldives.', '{"overview_paragraphs":["Everyone is welcome to our home-away-from-home, whether they are travelling alone, with loved ones, friends, or family. You may do whatever you want here, as much or as little as your spirit wishes. Dive, go to the gym, or relax beneath the palm trees and enjoy something simple and genuine. I''m glad to be here. Happy in the moment- at Nova, one of the top all-inclusive resorts in the Maldives.","These accommodations are just a few feet from the beach and provide direct access to the endless blue lagoons. The 80-square-meter rooms have bespoke furnishings, natural light, and warmth, as well as a king-size bed with soft linen and cushions.","Beach Villa with Private Pool is a sanctuary of comfort overlooking the turquoise waves, with direct access to the coastline. It is set in an immensely soothing environment. Each room has 160 square metres of space and a king-size bed with luxury linen and cushions.","These suites provide an unrivalled view of the Indian Ocean and direct access to the lagoon below. Spend the day relaxing on the sun loungers on the expansive sun terrace, or down the private stairway and swim laps in the lagoon.","It''s a novel spin on the all-inclusive concept, going beyond meals and services and inviting everyone to take use of everything Nova has to offer. There are 76 lovely beach and over-water villas, beach volleyball, diving, local art and culture, and delightfully fresh dining at its three restaurants and two bars. People in Nova make time for the things that make them happy.","Nova is located in South Ari Atoll and may be accessed by a picturesque 25-minute seaplane flight."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 600, 'pNaa-necLJQ', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'nova-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'nova-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'vakarufalhi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'nova-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'nova-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1100, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'nova-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 900, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'nova-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- OBLU-NATURE-Helengeli
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'oblu-nature-helengeli-maldives-island-resort', 'OBLU NATURE Helengeli Maldives Island Resort', 'OBLU NATURE Helengeli is a thrilling 50-minute speedboat journey from Malé International Airport and provides all the enchantment of flora and animals. Helengeli is a favourite among Maldives all-inclusive resorts for ardent explorers, snorkelers, and channel divers due to its island-inspired, bohemia ambiance. The resort has its own house-reef only steps from the coast and is home to a breathtaking display of marine dwellers all year round, with 116 villas with vivid, tropical interiors amidst lush flora.', 'published', 'OBLU NATURE Helengeli Maldives Island Resort | Maldives Resorts | MTG', 'OBLU NATURE Helengeli is a thrilling 50-minute speedboat journey from Malé International Airport and provides all the enchantment of flora and animals. Helengeli is a favourite among Maldives all-inclusive resorts for ardent explorers, snorkelers, and channel divers due to its island-inspired, bohemia ambiance. The resort has its own house-reef only steps from the coast and is home to a breathtaking display of marine dwellers all year round, with 116 villas with vivid, tropical interiors amidst lush flora.', '{"overview_paragraphs":["OBLU NATURE Helengeli is a thrilling 50-minute speedboat journey from Malé International Airport and provides all the enchantment of flora and animals. Helengeli is a favourite among Maldives all-inclusive resorts for ardent explorers, snorkelers, and channel divers due to its island-inspired, bohemia ambiance. The resort has its own house-reef only steps from the coast and is home to a breathtaking display of marine dwellers all year round, with 116 villas with vivid, tropical interiors amidst lush flora.","These semi-detached beach homes are a few steps from Helengeli island''s coastlines and are ideal for fun and relaxation.","These exquisite homes are constructed partially on land and provide excellent sunset views. The terrace leads into the tranquil turquoise lagoon.","The resort has 116 villas in four categories that are all-inclusive with high-quality international cuisine and a variety of activities such as spectacular Channel Diving and a tranquil Garden Spa! OBLU by Atmosphere in Helengeli, a Four-Star Superior resort, strives to offer a ''Best in Class'' Maldivian Beach holiday experience!","OBLU by Atmosphere at Helengeli is located in North Male'' Atoll and is a 50-minute speedboat ride from Velana International Airport.","The Spice offers a stunning Maldives resort dining experience with a lagoon-facing wooden terrace and inside seats on a natural sandy floor. Relax by the pool with a beverage and some bar snacks at Helen''s Bar. Just Grill offers a wonderful dining experience with scrumptious grilled meats and fresh seafood."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 600, 'f9bdiPl0bWY', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'oblu-nature-helengeli-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'oblu-nature-helengeli-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'helengeli'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'oblu-nature-helengeli-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'oblu-nature-helengeli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa Pool', 700, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'oblu-nature-helengeli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- OBLU-SELECT-Lobigili
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'oblu-select-lobigili-maldives-island-resort', 'OBLU SELECT Lobigili Maldives Island Resort', 'Helengeli Island, North Male'' Atoll, is known for its Exotic House Reef, which is home to Silver-tipped Sharks, Lobsters, and Giant Sea Turtles. Embracing the lush environment on Helengeli Island and guaranteeing that the amazing house reef, only metres away from the island, is totally conserved in its original condition - the colourful, stylish, and hip resort, OBLU by Atmosphere at Helengeli, opened its doors on November 1, 2015!', 'published', 'OBLU SELECT Lobigili Maldives Island Resort | Maldives Resorts | MTG', 'Helengeli Island, North Male'' Atoll, is known for its Exotic House Reef, which is home to Silver-tipped Sharks, Lobsters, and Giant Sea Turtles. Embracing the lush environment on Helengeli Island and guaranteeing that the amazing house reef, only metres away from the island, is totally conserved in its original condition - the colourful, stylish, and hip resort, OBLU by Atmosphere at Helengeli, opened its doors on November 1, 2015!', '{"overview_paragraphs":["Helengeli Island, North Male'' Atoll, is known for its Exotic House Reef, which is home to Silver-tipped Sharks, Lobsters, and Giant Sea Turtles. Embracing the lush environment on Helengeli Island and guaranteeing that the amazing house reef, only metres away from the island, is totally conserved in its original condition - the colourful, stylish, and hip resort, OBLU by Atmosphere at Helengeli, opened its doors on November 1, 2015!","This airy, sun-lit one-bedroom beach cottage is the ultimate in relaxation. Lush tropical gardens and palm palms provide complete solitude. Carefree days begin with a pleasant swim in the pool or the sea. Inside, vibrant tropical sensations follow you, with hardwood textures, intriguing modern décor, and earthy red tones adding a sensuous touch. After a day in paradise, the sumptuous outdoor-indoor Maldivian bathroom with an open-air freestanding bathtub is ideal for a leisurely start-lit soak.","Immerse yourself in crystal-clear lagoon views and elegantly furnished areas. This one-bedroom overwater home exudes tropical serenity. The interiors are modern and lively, with relaxing white walls, warm hardwood flooring, gorgeous ocean-framing windows, and a luxurious bathroom with a tempting, deep-soaking bathtub and private overwater hammock.","OBLU CHOICE Lobigili is exclusively for adults, featuring postcard-perfect coastal and overwater homes. These remote vacation houses merge tropical panoramas and nature-inspired architecture for a romantic, castaway vibe, making them ideal for romantic getaways. While Loabigili Island is great for a romantic interlude for two, it is also suitable for adults-only trips such as a bachelorette party, carousing with friends, or a romantic couples stay in the Indian Ocean.","Ylang-Ylang (All-Day Dining) - Global flavours with an Italian twist are sure to satisfy your taste buds. Choose from a variety of live culinary stations, tandoors, and desserts ranging from the Italian specialty tiramisu to Thai Loy Coconut Milk.","Only Blu Specialty Underwater Restaurant - Culinary feast in a mystical underwater atmosphere. Our continually changing menu highlights fresh ingredients and current culinary methods to produce a one-of-a-kind dining experience that will live on forever, paired with the appropriate wine."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 800, 'RwiYnEODZuk', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'oblu-select-lobigili-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'oblu-select-lobigili-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'lobigili'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'oblu-select-lobigili-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'SunNest Beach Pool Villa', 900, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'oblu-select-lobigili-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Nest Water Villa', 800, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'oblu-select-lobigili-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- OBLU-SELECT-Sangeli
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'oblu-select-sangeli-maldives-island-resort', 'OBLU SELECT Sangeli Maldives Island Resort', 'The gloriously lovely OBLU SELECT Sangeli is located on the northwestern point of Malé Atoll, Maldives. Stay in elegant, tropical villas and suites and sample exotic cuisine at exotic restaurants and bars. Enjoy a scenic environment with swaying palm trees, pure white beaches, and a blue lagoon brimming with colourful coral life. Every aspect of a deluxe holiday is included into your stay for a really carefree and unforgettable trip at the Maldives'' greatest beach resort!', 'published', 'OBLU SELECT Sangeli Maldives Island Resort | Maldives Resorts | MTG', 'The gloriously lovely OBLU SELECT Sangeli is located on the northwestern point of Malé Atoll, Maldives. Stay in elegant, tropical villas and suites and sample exotic cuisine at exotic restaurants and bars. Enjoy a scenic environment with swaying palm trees, pure white beaches, and a blue lagoon brimming with colourful coral life. Every aspect of a deluxe holiday is included into your stay for a really carefree and unforgettable trip at the Maldives'' greatest beach resort!', '{"overview_paragraphs":["The gloriously lovely OBLU SELECT Sangeli is located on the northwestern point of Malé Atoll, Maldives. Stay in elegant, tropical villas and suites and sample exotic cuisine at exotic restaurants and bars. Enjoy a scenic environment with swaying palm trees, pure white beaches, and a blue lagoon brimming with colourful coral life. Every aspect of a deluxe holiday is included into your stay for a really carefree and unforgettable trip at the Maldives'' greatest beach resort!","These stand-alone Maldives beach bungalows are vibrant and tropical, overlooking Sangeli island''s gorgeous blue lagoons. Each has a bedroom with high ceilings, a walk-in closet, and a partially open-air Maldivian bathroom. A warm, inviting room is created by combining current design concepts with traditional Maldivian architecture. Step out onto the spacious terrace, which leads to a private garden and beach.","The stand-alone beach villas with pool on Sangeli Island''s lush green northern side are the best among Maldives hotels. Some of the attractions of this property include 5 star in-villa facilities, an open-air porch, a luxury 13m2 plunge pool, and a tropical garden going directly out to the stunning white beach and a brilliantly blue lagoon!","A stretch of ocean-facing water villas curves around the turquoise waters of the enormous Sangeli lagoon. These Maldives overwater villas are light and airy, with separate sundecks and steps going directly into the lagoon. Indulgent facilities, stunning views, and sophisticated design combine to create a deliciously intimate atmosphere, ideal for a romantic holiday!","The villas are the genuine stars of OBLU SELECT at Sangeli. On their Maldives vacation, these havens provide postcard-perfect luxury, with stand-alone villas offering private pools, lagoon-facing beach villas with direct beach access, and open-air baths. Of course, there are the Maldives'' iconic 42 over-water villas with direct lagoon access, 26 of which have a private 8 square metre plunge pool. In-villa minibars are equipped with beer, wine, soft drinks, and a variety of food and are restocked once daily. Whatever sort of accommodation you seek on your next Maldives vacation, OBLU SELECT at Sangeli has the ideal villa for you.","OBLU SELECT at Sangeli is ideally located at the northwestern tip of Male'' Atoll and is only 50 minutes by speed boat from Velana International Airport. The spacious Stand-Alone Beach & Water Villas - with & without Private Pools, an upgraded All-Inclusive plan - THE SERENITY PlanTM, with inclusions of Fine Dining experiences at two specialty restaurants - JUST GRILL & SIMPLY VEG, as well as In-Villa Mini Bar replenishment at no extra charge, set this resort apart from the rest!"]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 700, 'B_VEo7K5gCI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'oblu-select-sangeli-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'oblu-select-sangeli-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'sangeli'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'oblu-select-sangeli-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 700, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'oblu-select-sangeli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'oblu-select-sangeli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 780, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'oblu-select-sangeli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- OBLU-XPERIENCE-Ailafushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'oblu-xperience-ailafushi-maldives-island-resort', 'OBLU XPErience Ailafushi Maldives Island Resort', 'Immerse yourself in carefree tropical island living at OBLU Xperience Ailafushi, with exhilarating activities, whimsical decor, and a vibrant party environment. Ailafushi island, which means "family island" in Dhivehi, is a 15-minute speedboat journey from Malé International Airport. This limited-service 4-Star Island Resort has 268 rooms divided into four categories. With its busy retail and café environment, La Promenade offers a touch of sophistication where you can socialise with like-minded folks. Simply unbeatable!', 'published', 'OBLU XPErience Ailafushi Maldives Island Resort | Maldives Resorts | MTG', 'Immerse yourself in carefree tropical island living at OBLU Xperience Ailafushi, with exhilarating activities, whimsical decor, and a vibrant party environment. Ailafushi island, which means "family island" in Dhivehi, is a 15-minute speedboat journey from Malé International Airport. This limited-service 4-Star Island Resort has 268 rooms divided into four categories. With its busy retail and café environment, La Promenade offers a touch of sophistication where you can socialise with like-minded folks. Simply unbeatable!', '{"overview_paragraphs":["Immerse yourself in carefree tropical island living at OBLU Xperience Ailafushi, with exhilarating activities, whimsical decor, and a vibrant party environment. Ailafushi island, which means \"family island\" in Dhivehi, is a 15-minute speedboat journey from Malé International Airport. This limited-service 4-Star Island Resort has 268 rooms divided into four categories. With its busy retail and café environment, La Promenade offers a touch of sophistication where you can socialise with like-minded folks. Simply unbeatable!","The beautiful Beach Villas are only a few steps away from the white, sandy beach. Dip into the lagoon whenever you like. Alternatively, relax on your private outside veranda and garden. Warm, oak floors, a soft bed, a large sofa, beautiful themes, and vivid fabrics make the interiors just as appealing. A walk-in closet connects to a spa-like bathroom with marble vanity and an outdoor shower overlooking a garden. Everything you need to unwind in luxury is available! Enjoy your favourite beverages in your villa, with a selection of wines and spirits available for buy separately at the Wine Boutique at La Promenade and other resort locations.","The water homes are accessible through a wooden pier that stretches into the beautiful lagoon. Each overwater refuge is designed in the style of a traditional Maldivian boat - a ''dhoni'' - giving the impression of an intimate, romantic getaway. Relax on your private terrace or descend the staircase for a relaxing dip in the warm sea lapped softly against your villa. Enjoy your favourite beverages in your villa, with a selection of wines and spirits available for buy separately at the Wine Boutique at La Promenade and other resort locations.","Experience the magnificent Indian Ocean from a bright beach or overwater villa with spectacular ocean views. A joyful, free-spirited stay is created by refreshingly warm, compassionate service and delightfully furnished spaces.","The OBLU XPErience Ailafushi is conveniently positioned on the northwestern tip of Male'' Atoll, about 20 minutes via speed boat from Velana International Airport. The magnificent Beach & Water Villas on their own.","At Element X, a limited-service all-day eating restaurant, a joyful, chilled-out balance is at the centre of the dining experience. Share wonderful family memories over delectable feasts and self-service beverage kiosks. Immerse in a multi-layered experience at the vibrant X360 bar - with a distinctively engaging, joyful, and exuberant ambiance. Try the Copper Pot Food Truck''s refreshing ''Surf & Turf'' grills beneath a starlit sky, or book a reservation for a refined Modern Gastronomic experience at the iconic under ocean restaurant, Only BLU. The Fushi PlanTM includes the Element X and X360 bar. Dining at Copper Pot Food Truck and Only BLU is fee-based."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 500, '2KS4bmFNL7Y', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'oblu-xperience-ailafushi-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'oblu-xperience-ailafushi-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'ailafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'oblu-xperience-ailafushi-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 500, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'oblu-xperience-ailafushi-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 500, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'oblu-xperience-ailafushi-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- OZEN-LIFE-MAADHOO
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'ozen-life-maadhoo-maldives-island-resort', 'Ozen Life Maadhoo Maldives Island Resort', 'The first OZEN resort, a favourite among Maldives 5 star resorts, OZEN LIFE MAADHOO, is a serene palm-painted paradise of luxury located in the beautiful turquoise colours of South Malé Atoll. The resort provides exciting experiences and a dynamic island lifestyle, with 94 tastefully built villas and one unique Residence. An exquisite Maldives stay combines all the characteristics of an ultra-luxe vacation, from underwater dining at M6m to adrenaline ocean excursions.', 'published', 'Ozen Life Maadhoo Maldives Island Resort | Maldives Resorts | MTG', 'The first OZEN resort, a favourite among Maldives 5 star resorts, OZEN LIFE MAADHOO, is a serene palm-painted paradise of luxury located in the beautiful turquoise colours of South Malé Atoll. The resort provides exciting experiences and a dynamic island lifestyle, with 94 tastefully built villas and one unique Residence. An exquisite Maldives stay combines all the characteristics of an ultra-luxe vacation, from underwater dining at M6m to adrenaline ocean excursions.', '{"overview_paragraphs":["The first OZEN resort, a favourite among Maldives 5 star resorts, OZEN LIFE MAADHOO, is a serene palm-painted paradise of luxury located in the beautiful turquoise colours of South Malé Atoll. The resort provides exciting experiences and a dynamic island lifestyle, with 94 tastefully built villas and one unique Residence. An exquisite Maldives stay combines all the characteristics of an ultra-luxe vacation, from underwater dining at M6m to adrenaline ocean excursions.","Elegant, vibrant, and inviting. The Earth Villas are a cheerful and small beach holiday property. Bask in the assurance of Refined Elegance at these 185m2 stand-alone villas, which have a beautiful tropical garden that opens onto a relaxing, white, fine sandy beach and blue ocean waves. A balmy island atmosphere is created by high-pitched roofs, massive panoramic windows, open spaces, and trendy interiors done up in warm and bright colours. Each villa features a large sun terrace as well as a large outdoor bathroom with a handmade bathtub and a monsoon shower—a wonderfully refreshing vacation!","The Earth Villas with Pool is a Maldives villa that has all of the facilities of the Earth Villas as well as two more features for an even more luxurious vacation! The first is a 20-square-metre infinity pool with ambient underwater lighting. The other is stunning lagoon views, complete with a front-row ticket to the Maldivian sunset!","New, romantic, and inspiring! There are 24 charming 112 m2 Wind Villas located along the lagoon to the north of Maadhoo Island. They are built on stilts over the ocean and offer ultimate island life, which is often described as pleasant, romantic, and inspirational. Their stylish tropical décor and exquisite interiors provide a welcoming living place. The beautiful facilities, complete with free-standing elliptical bathtubs and unobstructed views of the horizon, provide for a profoundly pleasurable experience.","OZEN LIFE MAADHOO has 90 private villas in 6 categories, positioned overwater and beachfront, as well as a luxury superyacht. Each villa has its own private pool as well as direct beach or lagoon access. They provide visitors with the ultimate in luxury in massive vacation homes in the most beautiful places on the island. The opulent architecture, premium facilities, and exclusive services provide guests with an out-of-this-world experience.","Maadhoo Island is located in a remote area of the South Malé atoll. The island is reached by a 40-minute speedboat journey from Velana International Airport."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1120, 'UYUayGwigOI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'ozen-life-maadhoo-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'ozen-life-maadhoo-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'maadhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'ozen-life-maadhoo-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Earth Villa', 1150, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'ozen-life-maadhoo-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Earth Pool Villa', 1400, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'ozen-life-maadhoo-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Wind Villa', 1120, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'ozen-life-maadhoo-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- One-and-Only
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'one-only-reethi-rah-maldives-island-resort', 'One & Only Reethi Rah Maldives Island Resort', 'This Christmas season, One&Only Reethi Rah transforms into a Sparkling Wonderland, inspired by our pristine white beach surrounding by the sun-kissed Indian Ocean. The resort is bustling with entertainment, parties, and music, from acrobats to a 15-piece showband, fire dancers, and fairy ballerinas.', 'published', 'One & Only Reethi Rah Maldives Island Resort | Maldives Resorts | MTG', 'This Christmas season, One&Only Reethi Rah transforms into a Sparkling Wonderland, inspired by our pristine white beach surrounding by the sun-kissed Indian Ocean. The resort is bustling with entertainment, parties, and music, from acrobats to a 15-piece showband, fire dancers, and fairy ballerinas.', '{"overview_paragraphs":["This Christmas season, One&Only Reethi Rah transforms into a Sparkling Wonderland, inspired by our pristine white beach surrounding by the sun-kissed Indian Ocean. The resort is bustling with entertainment, parties, and music, from acrobats to a 15-piece showband, fire dancers, and fairy ballerinas.","Each one-bedroom villa has a king-size bed and a large terrazzo bath with a walk-in rain and jet shower. Wake up to the sounds of soothing waves ebbing and flowing just metres away from your bright and spacious Maldives beachfront home. Step out into the sand from your outdoor wooden patio, through your private sun loungers and refreshing outdoor shower, and onto your own beachfront. While you settle into island life, your host and villa valet will attend to your every need discreetly.","The enormous bedroom has a king-size bed and floor-to-ceiling windows with beautiful ocean views, as well as a wide, sun-drenched en suite with soaking tub. The airy, roomy layout welcomes long and leisurely days relaxing between your living room and sun-lit patio through the wide villa doors. At our unique Maldives resort, you may relax in the solitude of your own swimming pool and length of sandy beach. Relax among the swaying palms in your hammock - a standard in all of our villas.","Our beautiful Water Villas in the Maldives have an open-plan bedroom with a king-size bed and floor-to-ceiling windows that provide panoramic water-to-sky vistas. A separate living and eating area joins a spacious bathroom, with the beautiful enormous tub affording its own spectacular perspective of the quiet waters beyond. On the split-level hardwood deck that encases the house and a coconut-thatched covered veranda, discover wrap-around netting hammocks hung just over the glittering sea.","The beautiful villas at One & Only Reethi Rah are set either over the lagoon or along the beach. These villas are sleek and stunning, with outstanding solitude and views.","One&Only Reethi Rah is located on one of the biggest islands in North Malé Atoll, surrounded by the wonders of the Indian Ocean. It is located around 700 kilometres (430 miles) southwest of Sri Lanka and is a gem among a line of coral atolls, lagoons, and white sands. Guests may reach the resort in 20 minutes via seaplane transfer or 45 minutes by speedboat transport."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 2050, '4yLvHcjWaMY', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'one-only-reethi-rah-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'one-only-reethi-rah-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'reethi-rah'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'one-only-reethi-rah-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 2050, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'one-only-reethi-rah-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 2600, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'one-only-reethi-rah-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 2450, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'one-only-reethi-rah-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;
