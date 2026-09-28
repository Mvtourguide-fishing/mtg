-- Part 7 of 14 - run this in the Supabase SQL Editor AFTER the previous parts.
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

-- Kandolhu
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'kandolhu-maldives-island-resort', 'Kandolhu Maldives Island Resort', 'An island as neatly constructed as Kandolhu is unusual even in the Maldives. The island is beautiful, with vast sandy beaches surrounding the emerald green water, and it is home to one of the Maldives'' most colourful and dynamic house reefs. Kandolhu is an amazing Maldives resort with just 30 villas that flawlessly integrate natural Maldivian elements with modern architecture and creature-comforts, creating an experience that will stay with you forever.', 'published', 'Kandolhu Maldives Island Resort | Maldives Resorts | MTG', 'An island as neatly constructed as Kandolhu is unusual even in the Maldives. The island is beautiful, with vast sandy beaches surrounding the emerald green water, and it is home to one of the Maldives'' most colourful and dynamic house reefs. Kandolhu is an amazing Maldives resort with just 30 villas that flawlessly integrate natural Maldivian elements with modern architecture and creature-comforts, creating an experience that will stay with you forever.', '{"overview_paragraphs":["An island as neatly constructed as Kandolhu is unusual even in the Maldives. The island is beautiful, with vast sandy beaches surrounding the emerald green water, and it is home to one of the Maldives'' most colourful and dynamic house reefs. Kandolhu is an amazing Maldives resort with just 30 villas that flawlessly integrate natural Maldivian elements with modern architecture and creature-comforts, creating an experience that will stay with you forever.","These one-of-a-kind Maldives beach villas on Kandolhu''s western coastlines have a king bed and a big open air garden bathroom with a jetted bathtub, shower, and twin vanity. A second outdoor shower has been installed in the backyard. The front veranda has a comfortable daybed and an eating area, while the neighbouring sundeck has sun loungers and a sun umbrella.","The magnificent Pool Villa, which faces east, has a spacious bedroom with a king-sized bed overlooking the pool and the turquoise lagoon beyond. Enter the big open air bathroom through the expansive wardrobe, which has a freestanding bath, shower, dual vanity, and an outside garden shower. These Maldives luxury homes have wide verandas with an outdoor daybed. Each outside deck features a 9-square-meter pool, sun loungers, a sun shade, and an eating area.","This exquisite seaside villa in the Maldives is located above the water and has A huge bedroom with a king bed, a daybed, and views of the ocean. This luxurious villa''s bathroom overlooks the lagoon and features a jetted bathtub, dual vanity, shower, and dressing space. The sun terrace is secluded and equipped with sun loungers, a sun umbrella, and stairs leading down to the water.","Kandolhu Maldives has 30 villas in 5 different designs, each with its own unique design. All homes have Maldivian architecture with contemporary decor. They are all in outstanding sites, having either immediate beach access or unobstructed views of the Indian Ocean.","Kandolhu Maldives is 70 kilometres from Velana International Airport and can be accessed by a 20-minute seaplane flight followed by a 15-minute speedboat ride."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 700, 'uvRrBgIp_1I', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'kandolhu-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'kandolhu-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'kandolhu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'kandolhu-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 700, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'kandolhu-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'kandolhu-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ocean Villa', 1100, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'kandolhu-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Komandoo-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'komandoo-island-resort-and-spa-maldives', 'Komandoo Island Resort and Spa Maldives', 'Komandoo is tailor-made for romance, combining the splendour of the Maldives with the charm of a tiny resort. A laid-back hideaway guaranteed by award-winning attentiveness and a variety of leisure activities, ideal for your honeymoon, a calm romantic holiday, or a trip with friends. Pure and uncomplicated paradise awaits. The Maldives is linked with honeymoons and unforgettable vacations, and it is a popular destination for adults-only retreats. One of the many reasons people pick the Maldives as a vacation destination is the ''One Island, One Resort'' idea.', 'published', 'Komandoo Island Resort and Spa Maldives | Maldives Resorts | MTG', 'Komandoo is tailor-made for romance, combining the splendour of the Maldives with the charm of a tiny resort. A laid-back hideaway guaranteed by award-winning attentiveness and a variety of leisure activities, ideal for your honeymoon, a calm romantic holiday, or a trip with friends. Pure and uncomplicated paradise awaits. The Maldives is linked with honeymoons and unforgettable vacations, and it is a popular destination for adults-only retreats. One of the many reasons people pick the Maldives as a vacation destination is the ''One Island, One Resort'' idea.', '{"overview_paragraphs":["Komandoo is tailor-made for romance, combining the splendour of the Maldives with the charm of a tiny resort. A laid-back hideaway guaranteed by award-winning attentiveness and a variety of leisure activities, ideal for your honeymoon, a calm romantic holiday, or a trip with friends. Pure and uncomplicated paradise awaits. The Maldives is linked with honeymoons and unforgettable vacations, and it is a popular destination for adults-only retreats. One of the many reasons people pick the Maldives as a vacation destination is the ''One Island, One Resort'' idea.","Komandoo''s Beach Villas, with their tastefully equipped environment reminiscent of traditional Maldives, are the ideal hideaway for those looking for a romantic break. Enjoy your own private terrace with views of Komandoo''s stunning blue lagoon. The Komandoo Beach Villas are huge timber bungalows tucked away along the beach. Each villa includes a wooden balcony from which to enjoy the sound of the ocean and the breathtaking scenery. These traditional Maldivian villas create a peaceful environment for your stay at Komandoo.","The most coveted villas on Komandoo ensure a magnificent and romantic setting for your stay in paradise. A spacious, partially roofed wooden terrace with a stairway running down to the water provides you with your own own slice of paradise. The tranquillity of the lagoon makes these villas an ideal choice for your honeymoon or a romantic holiday with your sweetheart. Relax in your own Jacuzzi or spa bath while staring out over the horizon where turquoise seas meet sapphire-colored skies.","Nothing says \"vacation\" like a lovely villa that provides much-needed peace and relaxation. Offering genuine Maldivian luxury and charm, as well as a picture-perfect site, either on the beach or above the lagoon. The villas at Komandoo will take your breath away with their lovely surroundings.","Komandoo is located in the Lhaviyani Atoll, a scenic 40-minute seaplane ride from Male\"s Velana International Airport.","Whether it''s a romantic lunch for two beneath the stars, a bountiful buffet, or fine dining, Komandoo provides great dining options for all occasions, including the opportunity to dine under the sea at our sister resort, Hurawalhi Maldives. Komandoo''s dining and drinking options are rounded out with a selection of bars where you may sip your favourite libation. Aqua, Komandoo''s a-la-carte restaurant, is just breathtaking. Diners may savour exquisite delicacies while perched on stilts over the lagoon, surrounded by the natural splendour of the Maldives."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 500, 'USCSU8yKo_Y', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'komandoo-island-resort-and-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'komandoo-island-resort-and-spa-maldives'
  and l.node_type = 'location' and l.slug = 'komandoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'komandoo-island-resort-and-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 500, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'komandoo-island-resort-and-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'JACUZZI WATER VILLA', 700, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'komandoo-island-resort-and-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- Kudadoo
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'kudadoo-maldives-private-island-resort', 'Kudadoo Maldives Private Island Resort', 'KUDADOO MALDIVES PRIVATE ISLAND PROVIDES A COMPLETE EXPERIENCE WITH EVERYTHING UNDER THE MOON AVAILABLE TO YOU AT ANY TIME AND FROM ANYWHERE. THIS PRIVATE ISLAND HAS BEEN DESIGNED FOR ESCAPES FROM THE CONFINES OF EVERYDAY LIFE AND IS SURE TO IMPRESS EVEN THE MOST DISCERNING TRAVELLER. MAGNIFICENT MOMENTS TAKE THE FORM OF DELICIOUS CULINARY CREATIONS, ENDLESS LEISURE ACTIVITIES, AND WELLNESS. SEIZE YOUR DAYS ON THIS TINY TROPICAL ISLAND WITH THE HELP OF YOUR PERSONAL BUTLER, WHO CAN ASSIST YOU IN CREATING THE PERFECT HOLIDAY ITINERARY. KUDADOO SETS A NEW STANDARD IN SUSTAINABLE LUXURY HOSPITALITY WITH THE ARCHITECTURAL MASTERMIND, YUJI YAMAZAKI; WE TAKE GREAT PRIDE IN THE FOLLOWING ACCOLADES: LUXURY TRAVEL INTELLIGENCE''S BEST NEW LUXURY HOTEL FOR 2018; ROBB REPORT''S BEST ISLAND RESORT 2019.', 'published', 'Kudadoo Maldives Private Island Resort | Maldives Resorts | MTG', 'KUDADOO MALDIVES PRIVATE ISLAND PROVIDES A COMPLETE EXPERIENCE WITH EVERYTHING UNDER THE MOON AVAILABLE TO YOU AT ANY TIME AND FROM ANYWHERE. THIS PRIVATE ISLAND HAS BEEN DESIGNED FOR ESCAPES FROM THE CONFINES OF EVERYDAY LIFE AND IS SURE TO IMPRESS EVEN THE MOST DISCERNING TRAVELLER. MAGNIFICENT MOMENTS TAKE THE FORM OF DELICIOUS CULINARY CREATIONS, ENDLESS LEISURE ACTIVITIES, AND WELLNESS. SEIZE YOUR DAYS ON THIS TINY TROPICAL ISLAND WITH THE HELP OF YOUR PERSONAL BUTLER, WHO CAN ASSIST YOU IN CREATING THE PERFECT HOLIDAY ITINERARY. KUDADOO SETS A NEW STANDARD IN SUSTAINABLE LUXURY HOSPITALITY WITH THE ARCHITECTURAL MASTERMIND, YUJI YAMAZAKI; WE TAKE GREAT PRIDE IN THE FOLLOWING ACCOLADES: LUXURY TRAVEL INTELLIGENCE''S BEST NEW LUXURY HOTEL FOR 2018; ROBB REPORT''S BEST ISLAND RESORT 2019.', '{"overview_paragraphs":["KUDADOO MALDIVES PRIVATE ISLAND PROVIDES A COMPLETE EXPERIENCE WITH EVERYTHING UNDER THE MOON AVAILABLE TO YOU AT ANY TIME AND FROM ANYWHERE. THIS PRIVATE ISLAND HAS BEEN DESIGNED FOR ESCAPES FROM THE CONFINES OF EVERYDAY LIFE AND IS SURE TO IMPRESS EVEN THE MOST DISCERNING TRAVELLER. MAGNIFICENT MOMENTS TAKE THE FORM OF DELICIOUS CULINARY CREATIONS, ENDLESS LEISURE ACTIVITIES, AND WELLNESS. SEIZE YOUR DAYS ON THIS TINY TROPICAL ISLAND WITH THE HELP OF YOUR PERSONAL BUTLER, WHO CAN ASSIST YOU IN CREATING THE PERFECT HOLIDAY ITINERARY. KUDADOO SETS A NEW STANDARD IN SUSTAINABLE LUXURY HOSPITALITY WITH THE ARCHITECTURAL MASTERMIND, YUJI YAMAZAKI; WE TAKE GREAT PRIDE IN THE FOLLOWING ACCOLADES: LUXURY TRAVEL INTELLIGENCE''S BEST NEW LUXURY HOTEL FOR 2018; ROBB REPORT''S BEST ISLAND RESORT 2019.","YOUR SECLUDED HIDEAWAY IS LOCATED ON TOP OF AN AQUAMARINE LAGOON. THE RESIDENCES ON KUDADOO MALDIVES PRIVATE ISLAND HAVE CAREFULLY CRAFTED INTERIORS AND EXTERIORS. THEY BRING FREEDOM OF TIME, SPACE, AND UNRESTRICTED CONNECTIONS. IN PRECIOUS MOMENTS OF INDULGENCE, AN ENVIRONMENTALLY CONSCIOUS DESIGN, SHEER COMFORT, AND THE UTMOST PRIVACY COME TOGETHER. THIS IS A PLACE WHERE YOU CAN EXPLORE YOURSELF.","Hurawalhi''s Kudadoo Maldives Private Island is an elite resort with just 15 large, overwater Ocean Residences with 44 sq metre terrace pools. Each property floats on an azure lagoon and boasts a carefully crafted interior and outdoor space that exudes connection.","Kudadoo Maldives is a private island with a gorgeous lagoon, a stunning house reef, and extensive lengths of white sandy beach. Kudadoo is approximately 200 metres long and 200 metres broad. A direct seaplane trip from Velana International Airport takes 40 minutes and is a picturesque flight.","LIKE GOOD FOOD, NOTHING BRINGS PEOPLE TOGETHER. KUDADOO IS FULL OF TASTE EXPERIENCES CAREFULLY CURATE BY THE EXECUTIVE CHEF. THE MENUS INCLUDE ALL-TIME FAVORITES IN ADDITION TO FINE DINING TREATS, AND A RANGE OF DIETARY REQUIREMENTS AND PREFERENCES CAN BE ACCOMMODATED UPON REQUEST.","SULHA SPA AT THE RETREAT IS A SANCTUARY SUSPENDED OVER THE OCEAN THAT ALLOWS YOU TO CALM THE PERSISTENT CONSCIOUS LOOP WITH IMMERSIVE EXPERIENCES SO YOU CAN REST, RESET, AND CONNECT. YOU WILL FEEL BETTER THAN YOU HAVE IN YEARS IF YOU SPEND AS MUCH TIME AS YOU WISH ENJOYING WORLD-CLASS SPA AND WELL-BEING EXPERIENCES."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 4300, 'Kmbrx_LYk0Q', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'kudadoo-maldives-private-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'kudadoo-maldives-private-island-resort'
  and l.node_type = 'location' and l.slug = 'kudadoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'kudadoo-maldives-private-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ocean Pool Residence Single Bedroom', 4300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'kudadoo-maldives-private-island-resort'
on conflict (accommodation_id, name) do nothing;

-- LUX-South
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'lux-south-ari-atoll-resorts-maldives-island', 'LUX* South Ari Atoll Resorts Maldives Island', 'The Maldives is one of those destinations that keeps appearing on travellers'' wish lists. And not without cause. If you''ve ever dreamt of living like Robinson Crusoe on a remote tropical island, you''ve come to the correct spot. At LUX* South Ari Atoll, you can ride your bicycle along the jetty, swim with whale sharks, relax in your stilted bungalow, dine at any of the eight restaurants, dance the night away, and participate in marine conservation... Whatever you''re looking for, you''ll find it at LUX* South Ari Atoll.', 'published', 'LUX* South Ari Atoll Resorts Maldives Island | Maldives Resorts | MTG', 'The Maldives is one of those destinations that keeps appearing on travellers'' wish lists. And not without cause. If you''ve ever dreamt of living like Robinson Crusoe on a remote tropical island, you''ve come to the correct spot. At LUX* South Ari Atoll, you can ride your bicycle along the jetty, swim with whale sharks, relax in your stilted bungalow, dine at any of the eight restaurants, dance the night away, and participate in marine conservation... Whatever you''re looking for, you''ll find it at LUX* South Ari Atoll.', '{"overview_paragraphs":["The Maldives is one of those destinations that keeps appearing on travellers'' wish lists. And not without cause. If you''ve ever dreamt of living like Robinson Crusoe on a remote tropical island, you''ve come to the correct spot. At LUX* South Ari Atoll, you can ride your bicycle along the jetty, swim with whale sharks, relax in your stilted bungalow, dine at any of the eight restaurants, dance the night away, and participate in marine conservation... Whatever you''re looking for, you''ll find it at LUX* South Ari Atoll.","You couldn''t get much closer to the shore if you tried. Our thatched-roof beach pavilion is as stylish as they come. There is the option of interconnecting rooms, making this a good choice for families with small children or friends who enjoy going on double dates.","If picture-perfect vacations are your goal, you''ll enjoy our elegant beach home. A seaside house. The most beautiful private pool. Amenities tailored to the needs of the leisure tourist. The most romantic indoor-outdoor bathroom imaginable. Welcome to your Maldives home.","As hoteliers who like travelling, we understand the value of a good night''s sleep. It''s the nicest feeling to having a home away from home. Our Maldives water villa is that house, but on stilts with the Indian Ocean as your pool!","At LUX* South Ari Atoll, 193 private villas are scattered over two miles of powder fine beaches and situated on stilts above a beautiful lagoon. These incredibly big rooms and suites provide a totally unique atmosphere of coastal, beach house flair to the Maldives, whether on land or above water, sunset facing or dawn facing.","The picture-perfect island of Dhidhoofinolhu is home to LUX* South Ari Atoll, a luxury resort where your ideal of a laid-back, desert island paradise is about to come true, whether you desire a calm getaway or active adventure. This home is also in one of Maamigili''s prime locations. South Ari Atoll is 30 minutes by seaplane from Malé International Airport."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 600, '0wkm-EuG-Aw', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'lux-south-ari-atoll-resorts-maldives-island'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'lux-south-ari-atoll-resorts-maldives-island'
  and l.node_type = 'location' and l.slug = 'dhidhoofinolhu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'lux-south-ari-atoll-resorts-maldives-island'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pavillion', 600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'lux-south-ari-atoll-resorts-maldives-island'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1100, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'lux-south-ari-atoll-resorts-maldives-island'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 1000, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'lux-south-ari-atoll-resorts-maldives-island'
on conflict (accommodation_id, name) do nothing;

-- Lily-beach
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'lily-beach-resort-spa-maldives-island-resort', 'Lily Beach Resort & Spa Maldives Island Resort', 'Lily Beach Resort & Spa''s Platinum Plan allows you to enjoy a hassle-free, outstanding value-for-money vacation. This is an all-inclusive package that includes a magnificent assortment of high-quality services such as exquisite dining experiences, romantic excursions, sporting activities, and high-quality items such as premium wines and spirits.', 'published', 'Lily Beach Resort & Spa Maldives Island Resort | Maldives Resorts | MTG', 'Lily Beach Resort & Spa''s Platinum Plan allows you to enjoy a hassle-free, outstanding value-for-money vacation. This is an all-inclusive package that includes a magnificent assortment of high-quality services such as exquisite dining experiences, romantic excursions, sporting activities, and high-quality items such as premium wines and spirits.', '{"overview_paragraphs":["Lily Beach Resort & Spa''s Platinum Plan allows you to enjoy a hassle-free, outstanding value-for-money vacation. This is an all-inclusive package that includes a magnificent assortment of high-quality services such as exquisite dining experiences, romantic excursions, sporting activities, and high-quality items such as premium wines and spirits.","The Beach Villas allow you to fully enjoy the lovely natural playground just outside your door. The Villas are set among lush greenery, only steps from the warm Indian Ocean and a short walk from the resort''s main area.","Many of our visitors prefer the Lagoon Villas because of their private patio with direct access to the lagoon and tropical surroundings.","At Lily Beach Huvahendhoo, the pleasure never stops, and the hotel seeks to enliven days, enrapture evenings, and awaken visitors to a heightened level of well-being. The major goal has been to transform the resort into a high-quality, premium experience. All of its villas and public rooms are made entirely of natural materials. The finished project is a synthesis of current design and Maldivian architecture. It is a great combination of wood, various types of natural stones, and modern design that blends in wonderfully with the island''s natural environment.","Lily Beach Resort is located on the island of Huvahendhoo, South Ari Atoll, and is 600 m long and 110 m wide. It is a 25-minute sea plane flight from Male International Airport. Because of its advantageous location in the magnificent Ari Atoll, it is adjacent to some of the world''s most remarkable dive locations.","Maa, the local term for flower, is a place where your love of delicious cuisine may blossom into a pleasurable eating experience. The genuine value of this wonderful sand-floored restaurant is provided by its magnificent, all-inclusive buffet dishes that will whet anyone''s appetite. Lily Maa, the primary buffet-style restaurant, will enable you bloom into a genuine gourmet, recognising that the quality of your Maldives experience will unavoidably expand through the seduction of your taste senses as well. Every day of the week, a new foreign cuisine to transport you to other corners of the world while being at the one you wouldn''t exchange for anything else. Whatever your favourite dish, Lily Maa is an unrivalled gastronomic treat, recognised across the Maldives for its chefs'' feasts. Don’t"]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1100, 'JEgqJqbA79E', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'lily-beach-resort-spa-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'lily-beach-resort-spa-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'huvahendhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'lily-beach-resort-spa-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 1100, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'lily-beach-resort-spa-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 1200, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'lily-beach-resort-spa-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Maayafushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'nakai-maayafushi-maldives-island-resort', 'NAKAI Maayafushi Maldives Island Resort', 'Maayafushi, located in the northern portion of the Ari Atoll, contains all of the characteristics that distinguish this little region of Maldives: from the untamed nature of the vegetation to the bottom inhabited by the most diverse types of fish. The resort is framed by crystal blue waters and lovely beaches, and its rooms can provide tourists with every type of comfort. The island, with its well-known diving spots, is a popular destination for divers from all over the world, from the most experienced to those who want to dive for the first time in these enchanted depths.', 'published', 'NAKAI Maayafushi Maldives Island Resort | Maldives Resorts | MTG', 'Maayafushi, located in the northern portion of the Ari Atoll, contains all of the characteristics that distinguish this little region of Maldives: from the untamed nature of the vegetation to the bottom inhabited by the most diverse types of fish. The resort is framed by crystal blue waters and lovely beaches, and its rooms can provide tourists with every type of comfort. The island, with its well-known diving spots, is a popular destination for divers from all over the world, from the most experienced to those who want to dive for the first time in these enchanted depths.', '{"overview_paragraphs":["Maayafushi, located in the northern portion of the Ari Atoll, contains all of the characteristics that distinguish this little region of Maldives: from the untamed nature of the vegetation to the bottom inhabited by the most diverse types of fish. The resort is framed by crystal blue waters and lovely beaches, and its rooms can provide tourists with every type of comfort. The island, with its well-known diving spots, is a popular destination for divers from all over the world, from the most experienced to those who want to dive for the first time in these enchanted depths.","The allure of a walk in nature, the sensation of sand and wood beneath your feet before returning to your bed. Maayafushi''s 60 Beach Bungalows mesmerise with a green vista from which to scan the azure horizon of the Indian Ocean.","Maayafushi''s 8 Over Water survey the ocean''s limitless horizon, leaving them dumbfounded. The charm of water, which cradles the minutes before sleep and the seconds after rising, provides unforgettable pleasures. You will be immersed in the sounds of the sea in these rooms, and there will be a large outside deck where you may rest.","Guests may choose between three sorts of accommodation categories: Garden Rooms, Beach Bungalows, and Water Bungalows, all of which are constructed in harmony with the surrounding environment of the island while keeping comfort in mind. The rooms are large and well-equipped.","Maayafushi is located 65 kilometres from Velana International Airport and may be accessible either seaplane or a short ferry boat ride. The Ari''s atoll, well-known across the globe for its white sand and beautiful beaches, has become a scuba diver''s paradise on Earth. Sightings of whale sharks and hammerhead sharks, as well as other species dwelling in the coral reef that runs all the way around the shore, are common.","Let yourself be conquered by the tastes of the island in Maayafushi''s eateries and pubs. Our dining menu has been created to be as diverse as possible in order to fulfil the demands of all customers. In the restaurants, you may sample the delights of Italian and Maldivian cuisine, cooked and served daily by our Chefs. Our bars will be the ideal spot to unwind and have a refreshing drink while taking in the sights and sounds that only the Maldives can provide."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, null, '09xGGXQ0WA0', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'nakai-maayafushi-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'nakai-maayafushi-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'maayafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'nakai-maayafushi-maldives-island-resort'
on conflict (id) do nothing;

-- Makunudu-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'makunudu-island-resort-maldives', 'Makunudu Island Resort Maldives', 'Makunudu Island, located in North Malé Atoll and a 50-minute speedboat trip from Male International Airport, welcomes you into the warm embrace of an authentic Maldivian getaway. Where gleaming beaches give way to the turquoise lagoon''s crystal pure waters, melting into endless ocean views. Where serenity permeates into your spirit and real hospitality greets you like a friend. A rare retreat, gloriously undisturbed, that has a particular place in the hearts of people who explore the world. Remove your shoes and immerse yourself in island time...', 'published', 'Makunudu Island Resort Maldives | Maldives Resorts | MTG', 'Makunudu Island, located in North Malé Atoll and a 50-minute speedboat trip from Male International Airport, welcomes you into the warm embrace of an authentic Maldivian getaway. Where gleaming beaches give way to the turquoise lagoon''s crystal pure waters, melting into endless ocean views. Where serenity permeates into your spirit and real hospitality greets you like a friend. A rare retreat, gloriously undisturbed, that has a particular place in the hearts of people who explore the world. Remove your shoes and immerse yourself in island time...', '{"overview_paragraphs":["Makunudu Island, located in North Malé Atoll and a 50-minute speedboat trip from Male International Airport, welcomes you into the warm embrace of an authentic Maldivian getaway. Where gleaming beaches give way to the turquoise lagoon''s crystal pure waters, melting into endless ocean views. Where serenity permeates into your spirit and real hospitality greets you like a friend. A rare retreat, gloriously undisturbed, that has a particular place in the hearts of people who explore the world. Remove your shoes and immerse yourself in island time...","These vast havens of leisure merge rustic beauty with modern conveniences, thoughtfully designed in traditional Maldivian style utilising native woods, stones, and a palette of earthy colours. Enjoy the pleasure of a garden shower that is accessible to the outdoors yet entirely concealed. Relax on your individual sun loungers in the shade of the palms or under the warm Maldivian sun. Sleep quietly to the soothing sounds of lapping waves.","The Deluxe bungalows, inspired by its Maldivian history, represent the island''s native culture and energy. One of 36 beachfront villas set among thick tropical greenery only steps from the beach is your own little getaway.","We are located in North Malé Atoll, 45 minutes via speedboat from Malé International Airport.","Indulge in spectacular buffets of meats, seafood, and tropical fruits, table-served set dinners, and once a week, a scorching barbeque and a wonderful slice of Maldivian spice in a beautiful Maldivian buffet supper. Quench your thirst at the Sand Bar, day or night, with delicious beverages and sunset cocktails, while conversing with fellow travellers and being cooled by the ocean wind. A carefully made candlelit supper beneath the stars on the beach, in your bungalow, or other secluded locales is an experience to truly savour on those special occasions.","Your rejuvenation journey begins with therapies that include the finest of Maldivian, Asian, and European wellness methods and traditions. A Maldivian massage utilising seashells and pure indigenous coconut oil is available. A customised face will restore your natural glow. Relax and restore balance from head to toe with an Ayurvedic Indian head massage or reflexology."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 300, 'm16ooP56quk', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'makunudu-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'makunudu-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'makunudu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'makunudu-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Bungalow', 300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'makunudu-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Malahini-Kuda-Bandos
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'malahini-kuda-bandos-maldives-island-resort', 'Malahini Kuda Bandos Maldives Island Resort', 'Malahini Kuda Bandos, Celebrate your marriage with a honeymoon on beautiful pristine beaches overlooking turquoise waters while dining on delicious cuisine. We provide customised honeymoon packages with loads of advantages!', 'published', 'Malahini Kuda Bandos Maldives Island Resort | Maldives Resorts | MTG', 'Malahini Kuda Bandos, Celebrate your marriage with a honeymoon on beautiful pristine beaches overlooking turquoise waters while dining on delicious cuisine. We provide customised honeymoon packages with loads of advantages!', '{"overview_paragraphs":["Malahini Kuda Bandos, Celebrate your marriage with a honeymoon on beautiful pristine beaches overlooking turquoise waters while dining on delicious cuisine. We provide customised honeymoon packages with loads of advantages!","Our Deluxe accommodations, which are located along the beach, have a partial view of the ocean. Each room is 27 square metres in size and has the following amenities to provide a comfortable stay:","This year, Malahini Kuda Bandos might be your pleasant spot to relax with their modern and contemporary homes. Beach Villas, Superior Rooms, Deluxe Rooms, and Classic Rooms are the five accommodation types available.","Malahini Kuda Bandos is a ten-minute boat journey from Velana International Airport and provides basic luxury without breaking the wallet.","Sit at the water''s edge and have breakfast, lunch, or dinner in our modern and stunning restaurant that overlooks our lovely lagoon. If you like to eat under the stars, please sit on our open-air deck and listen to the waves breaking around you. If you would like to have a private dinner experience on the beach, please contact our Maaga Crew and they would be pleased to arrange one for you. To gratify our broad group of travellers, the Maaga Buffet is painstakingly created to feature a range of cuisines from all around the world.","Visit Alizé to calm your senses and absorb the peacefulness of our surroundings. Our spa pavilions at Alizé are inspired by age-old Asian and Maldivian traditions and are meant to offer you with a refuge from the world while also considering your well-being. Pamper yourself with a manicure or pedicure while admiring the ocean!"]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 355, 'f_g5hU7gpHI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'malahini-kuda-bandos-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'malahini-kuda-bandos-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'kuda-bandos'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'malahini-kuda-bandos-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Room', 355, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'malahini-kuda-bandos-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Medhufushi-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'medhufushi-island-resort-maldives', 'Medhufushi Island Resort Maldives', 'Medhufushi Island Resort is a peaceful and relaxing haven. The lovely island, decorated with shaded coconut palms and tropical flowers, exudes serenity. A magnificent lagoon in turquoise and sparkling azure blue surrounds the island. Medhufushi Island Resort is the best place to get away from it all and experience inexpensive, laid-back rustic at a Maldives resort.', 'published', 'Medhufushi Island Resort Maldives | Maldives Resorts | MTG', 'Medhufushi Island Resort is a peaceful and relaxing haven. The lovely island, decorated with shaded coconut palms and tropical flowers, exudes serenity. A magnificent lagoon in turquoise and sparkling azure blue surrounds the island. Medhufushi Island Resort is the best place to get away from it all and experience inexpensive, laid-back rustic at a Maldives resort.', '{"overview_paragraphs":["Medhufushi Island Resort is a peaceful and relaxing haven. The lovely island, decorated with shaded coconut palms and tropical flowers, exudes serenity. A magnificent lagoon in turquoise and sparkling azure blue surrounds the island. Medhufushi Island Resort is the best place to get away from it all and experience inexpensive, laid-back rustic at a Maldives resort.","For further solitude, the beach villas are built on pristine white sand and surrounded by lush flora such as hibiscus and sea cabbage. The four-poster king-size bed/twin beds and outdoor rain showers are highlights. 14 of the beach homes are semi-detached and offer more room as well as a partition door connecting the villas.","The sunrise or sunset-facing Water Villas have floor-to-ceiling windows in the bedroom that fold back over the whole fourth wall, allowing you to completely appreciate the ocean views. They also provide direct access to the lagoon from your private sundeck via steps.","Medhufushi is one of only two resorts in the picturesque Meemu Atoll, distant from the bustle and congestion of modern life. It includes 112 villas spread across around 10 hectares of land. Each villa is intended to provide natural luxury as well as the joy of a perfect refuge. All of the conveniences of home are offered in these spacious and appealing villas, which include a private sundeck and a traditional Maldivian swing chair. There is no better place to observe the soothing waves than under the shade of the ''undholi.'' The unique Lagoon Suites are the best in luxury.","This five-star resort is located on Meemu Atoll, 130 kilometres from Velana International Airport, a breathtaking 40-minute seaplane flight away.","This poolside restaurant, named after the Dhivehi word for mermaid, provides breathtaking views of the ocean. The restaurant serves buffet-style breakfasts, lunches, and dinners, with chefs working live cooking stations to customise your dish to your preferences. The food of Malaafaiy Restaurant is inspired by culinary traditions from throughout the world."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 250, '5j7XZjsxiP8', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'medhufushi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'medhufushi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'medhufushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'medhufushi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 250, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'medhufushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 430, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'medhufushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Meeru-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'meeru-island-resort-spa-maldives', 'Meeru Island Resort & Spa Maldives', 'Meeru Island Resort welcomes you to experience an unique beach filled holiday with a splash of simply Maldivian mixing into every facet of your stay, boasting one of the world''s most amazing beaches. Meeru takes pride in servicing the Maldives hotel sector for over 40 years. Explore the authentic Maldivian culture all throughout the island, including our very own state-of-the-art island museum. You will undoubtedly share Magical Moments with your loved ones when visiting here.', 'published', 'Meeru Island Resort & Spa Maldives | Maldives Resorts | MTG', 'Meeru Island Resort welcomes you to experience an unique beach filled holiday with a splash of simply Maldivian mixing into every facet of your stay, boasting one of the world''s most amazing beaches. Meeru takes pride in servicing the Maldives hotel sector for over 40 years. Explore the authentic Maldivian culture all throughout the island, including our very own state-of-the-art island museum. You will undoubtedly share Magical Moments with your loved ones when visiting here.', '{"overview_paragraphs":["Meeru Island Resort welcomes you to experience an unique beach filled holiday with a splash of simply Maldivian mixing into every facet of your stay, boasting one of the world''s most amazing beaches. Meeru takes pride in servicing the Maldives hotel sector for over 40 years. Explore the authentic Maldivian culture all throughout the island, including our very own state-of-the-art island museum. You will undoubtedly share Magical Moments with your loved ones when visiting here.","Meeru''s Beach Villas are big, well-appointed wooden bungalows on the beach with a stunning view of the lagoon. Step right onto the secluded beach, which offers breathtaking views of the island lagoon. These wooden bungalows provide a real Maldives beachfront experience. Relax on the villa terrace or on your beach sun loungers while listening to natural noises and inhaling in the ocean wind.","These classic Maldives villas are set in the lagoon, over-the-water. Only a short walk along your private jetty to this isolated refuge where you may immerse yourself in a Jacuzzi for two \"under the stars\" and simply climb the stairs into the water with the most spectacular views of all.","Meeru offers pleasant accommodation with tropical décor and modern conveniences, whether close to the beach or over-the-water, with 284 guest rooms divided into 5 room types. All Rooms have tropical décor, a king-sized bed, a private porch with furniture, air conditioning, a ceiling fan, a partially open-air bathroom (except Garden Rooms) with a rain shower, and amenities for an unforgettable Meeru stay.","Much of this lovely island remains undisturbed, with its bordering coconut palm trees, rich greenery, and brilliant coral reefs alive with marine life. It takes a 55-minute scenic motorboat trip from Velana International Airport to reach this unspoilt, natural paradise. Whether on a family holiday in the sun or an intimate beach gateway with a loved one, enjoy a relaxed, calm ambiance in a natural setting.","Meeru Island has two Buffet Restaurants, both with the same menu and a range of foreign and regional cuisines to suit everyone''s taste. Breakfast, lunch, and supper are all-you-can-eat buffet style, with vibrant Theme Nights. Friday evenings are Maldivian theme nights, complete with a themed cuisine and staff dressed in traditional clothes. Sunday brunch includes free Sparkling Wine."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 440, '7cJKIs_Ps0Q', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'meeru-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'meeru-island-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'meerufenfushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'meeru-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 440, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'meeru-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Jacuzzi Water Villa', 500, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'meeru-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- Milaidhoo
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'milaidhoo-maldives-island-resort', 'Milaidhoo Maldives Island Resort', 'Come on in, take off your shoes, and let us tell you a story... Once upon a time, there was a little tropical island, an emerald drop of paradise surrounded by a colourful coral reef, caressed by warm turquoise waves, and nestled in the centre of a UNESCO Biosphere Reserve. That island is Milaidhoo. That time has here, and this is our tale. Milaidhoo is not just another five-star resort in the Maldives; we call it re-invented luxury. We don''t conceive of our visitors as vacationers, but rather as storytellers who are creating their ideal vacation. This is the start of your narrative about a little island.', 'published', 'Milaidhoo Maldives Island Resort | Maldives Resorts | MTG', 'Come on in, take off your shoes, and let us tell you a story... Once upon a time, there was a little tropical island, an emerald drop of paradise surrounded by a colourful coral reef, caressed by warm turquoise waves, and nestled in the centre of a UNESCO Biosphere Reserve. That island is Milaidhoo. That time has here, and this is our tale. Milaidhoo is not just another five-star resort in the Maldives; we call it re-invented luxury. We don''t conceive of our visitors as vacationers, but rather as storytellers who are creating their ideal vacation. This is the start of your narrative about a little island.', '{"overview_paragraphs":["Come on in, take off your shoes, and let us tell you a story... Once upon a time, there was a little tropical island, an emerald drop of paradise surrounded by a colourful coral reef, caressed by warm turquoise waves, and nestled in the centre of a UNESCO Biosphere Reserve. That island is Milaidhoo. That time has here, and this is our tale. Milaidhoo is not just another five-star resort in the Maldives; we call it re-invented luxury. We don''t conceive of our visitors as vacationers, but rather as storytellers who are creating their ideal vacation. This is the start of your narrative about a little island.","Milaidhoo, which opened in November 2016, is a boutique luxury resort in the Baa Atoll UNESCO Biosphere Reserve, adjacent to Hanifaru Bay, 126 kilometres north-west of Male''. We''re ideal for environment enthusiasts since our own coral reef, which encircles the island, is a protected area and a popular snorkelling and diving destination. Our magnificent island, which is densely forested, spans just 300m by 180m and is surrounded by a smooth, deep white sand beach. We welcome guests aged nine and up and have a strict no-drone policy on the island, making it ideal for couples seeking quiet and seclusion. Everything at Milaidhoo is handcrafted to order and designed with your comfort in mind. Service is excellent yet always pleasant, in keeping with","These bright and large 290sqm thatched-roof villas open up 180 degrees to a wide sundeck and amazing views, and are set on a white, powder soft, sand beach among palm trees and lush, tropical flora. Each villa has a king-size bed with stunning views of the beach and ocean. Each home has high ceilings that create a sense of spaciousness and light. The custom-made furniture are complemented by a concealed flat-screen television, a specialised wine cooler, a full-sized, quiet refrigerator and mini bar, coffee machine, ceiling fan, and air conditioning.","The Beach Pool Villas at Milaidhoo welcome guests to a private island house designed to take advantage of the natural tranquilly given by the thick greenery that surrounds the property. The contemporary interior design incorporates numerous local details, creating a sense of belonging.","These enormous 245sqm thatched-roof houses on stilts above the ocean are tranquil and full of light, leading out to a massive sundeck surrounded by the clean air of a fresh sea wind. The sun deck is built around a 42sqm private freshwater infinity pool and has a Maldivian-style swing sofa, sun loungers, a huge umbrella, a dining table with seats, and a wide, covered daybed. Steps descend into the lagoon, providing easy access to the neighbouring coral reef.","The interior design of the Water Pool Villa is inspired by Maldivian tradition and culture, with furniture custom-made for Milaidhoo and room colours that mirror the vibrant hues of the natural surroundings. The spacious bathroom in the Villa has a large bathtub with an ocean view. The bathroom has a tropical rain shower."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1900, 'fQsrXcjbvqE', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'milaidhoo-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'milaidhoo-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'milaidhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'milaidhoo-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 2200, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'milaidhoo-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Pool Villa', 1900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'milaidhoo-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;
