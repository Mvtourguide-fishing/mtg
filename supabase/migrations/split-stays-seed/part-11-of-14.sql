-- Part 11 of 14 - run this in the Supabase SQL Editor AFTER the previous parts.
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

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'soneva-jani-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, '3 Bedroom Island Reserve', 23400, 'USD', 'King', 9, 0
from nodes where node_type = 'accommodation' and slug = 'soneva-jani-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, '1 bedroom Water Retreat', 4200, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'soneva-jani-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- South-Palm
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'south-palm-resort-maldives-island', 'South Palm Resort Maldives Island', 'South Palm Resort Maldives is a haven of unparalleled tranquillity, solitude, and comfort. Addu Atoll is surrounded by beautiful sandy beaches, a clean lagoon, and serene blue ocean vistas. South Palm Resort Maldives is a million miles away from the worries and strains of everyday life, located on a private island in the remote, southern edge of the Maldives. South Palm Resort Maldives offers 6 Villa kinds of stylish accommodation to meet all of your holiday needs. The island features a plethora of activities and outstanding amenities, including the first ever floating spa rooms in the Maldives, if not the globe. This makes it a great getaway for couples and honeymooners, as well as a fun-filled family resort.', 'published', 'South Palm Resort Maldives Island | Maldives Resorts | MTG', 'South Palm Resort Maldives is a haven of unparalleled tranquillity, solitude, and comfort. Addu Atoll is surrounded by beautiful sandy beaches, a clean lagoon, and serene blue ocean vistas. South Palm Resort Maldives is a million miles away from the worries and strains of everyday life, located on a private island in the remote, southern edge of the Maldives. South Palm Resort Maldives offers 6 Villa kinds of stylish accommodation to meet all of your holiday needs. The island features a plethora of activities and outstanding amenities, including the first ever floating spa rooms in the Maldives, if not the globe. This makes it a great getaway for couples and honeymooners, as well as a fun-filled family resort.', '{"overview_paragraphs":["South Palm Resort Maldives is a haven of unparalleled tranquillity, solitude, and comfort. Addu Atoll is surrounded by beautiful sandy beaches, a clean lagoon, and serene blue ocean vistas. South Palm Resort Maldives is a million miles away from the worries and strains of everyday life, located on a private island in the remote, southern edge of the Maldives. South Palm Resort Maldives offers 6 Villa kinds of stylish accommodation to meet all of your holiday needs. The island features a plethora of activities and outstanding amenities, including the first ever floating spa rooms in the Maldives, if not the globe. This makes it a great getaway for couples and honeymooners, as well as a fun-filled family resort.","From your Sunrise Villa, watch the first rays of morning sunshine rise over the Indian Ocean. After the concert, relax on your outside daybed and soak in the sea wind. The large 50sqm Villas, the most inexpensive accommodation category, have modern furnishings, elegant lines, and comfortable bedding.","Allow the peaceful sounds of the Indian Ocean to lull you to sleep in the middle of the day, and then wake up to experience the stunning colours of the sunset. In these huge 70 Sqm over-water villas, relax on the daybed on the wooden terrace and count the stars with a loved one.","The South Palm villas have been tastefully designed as a tranquil place for you to unwind and enjoy beautiful ocean views. A selection of 100 land-based beachfront Villas and 30 over-water Villas awaits to meet all of your vacation demands.","Located on a private island in the Maldives'' southernmost tip. Ismehela Hera is located on the western rim of Addu atoll. Gan International Airport on Addu Atoll is a 10-minute speedboat trip away.","The Banyan Restaurant, South Palm Resort''s primary dining location, offers an abundance of options. With breathtaking views of the Indian Ocean, dine on Asian and international cuisine as well as traditional Maldivian fare."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 220, 'aYQPJc27w60', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'south-palm-resort-maldives-island'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'south-palm-resort-maldives-island'
  and l.node_type = 'location' and l.slug = 'ismehela-hera'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'south-palm-resort-maldives-island'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Villa', 220, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'south-palm-resort-maldives-island'
on conflict (accommodation_id, name) do nothing;

-- Sun-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'sun-island-resort-spa-maldives', 'Sun Island Resort & Spa Maldives', 'Discover a world of adventure at Sun Island Resort & Spa, nestled in South Ari Atoll in the South Ari Marine Protected Area, whether you want adrenaline-fueled thrills or calm (SAMPA). Sun Island Resort & Spa, located on one of the biggest Maldivian islands and home to a healthy biodiversity and marine life, is a premium eco resort where natural beauty meets bright interior design and magnificent indoor-outdoor living areas. This Maldivian oasis, nestled among lush coconut trees, offers you to experience warm hospitality as well as an abundance of opportunities and exceptional seclusion to reconnect with nature.', 'published', 'Sun Island Resort & Spa Maldives | Maldives Resorts | MTG', 'Discover a world of adventure at Sun Island Resort & Spa, nestled in South Ari Atoll in the South Ari Marine Protected Area, whether you want adrenaline-fueled thrills or calm (SAMPA). Sun Island Resort & Spa, located on one of the biggest Maldivian islands and home to a healthy biodiversity and marine life, is a premium eco resort where natural beauty meets bright interior design and magnificent indoor-outdoor living areas. This Maldivian oasis, nestled among lush coconut trees, offers you to experience warm hospitality as well as an abundance of opportunities and exceptional seclusion to reconnect with nature.', '{"overview_paragraphs":["Discover a world of adventure at Sun Island Resort & Spa, nestled in South Ari Atoll in the South Ari Marine Protected Area, whether you want adrenaline-fueled thrills or calm (SAMPA). Sun Island Resort & Spa, located on one of the biggest Maldivian islands and home to a healthy biodiversity and marine life, is a premium eco resort where natural beauty meets bright interior design and magnificent indoor-outdoor living areas. This Maldivian oasis, nestled among lush coconut trees, offers you to experience warm hospitality as well as an abundance of opportunities and exceptional seclusion to reconnect with nature.","Sun Villas are tranquil getaways in the middle of the island, surrounded by luscious coconut trees and lush green flora. Large garden villas offer a calm and private place for families with young children to unwind and revitalise in the midst of Maldivian nature.","Beach Pool Villas include private pools, a wide 121sqm open plan living room with an attractive design, a private veranda, contemporary conveniences, and everything you need for an amazing Maldives vacation. Relax in your private pool while enjoying a tropical island breeze, or explore the gorgeous white beach and turquoise seas just outside your door.","The Water Villas at Sun Island Resort & Spa provide a quiet refuge located over crystal pure water. Enjoy carefree island living while admiring the expansive horizon from your private sundeck. Enjoy direct access to the lagoon from your private stairway and explore adjacent colourful reefs to enjoy the beauty of the natural aquatic environment. These luxury villas provide an unforgettable experience in one of the world''s most spectacular locations.","Sun Island Resort & Spa features 462 well appointed rooms. All of the rooms are intended to provide comfort and a pleasing outlook. From garden villas to water bungalows, all of the accommodations feature modern conveniences and are well-equipped for the modern traveller.","Sun Island Resort & Spa is situated on Nalaguraidhoo Island in South Ari Atoll, south of Malé International Airport. It is the largest resort in the Maldives, and its size comes with an unrivalled array of facilities as well as very great value for money. The resort is accessible via a 17-minute domestic flight from Male International Airport."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 200, 'B9eBA_LNeJc', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'sun-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'sun-island-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'nalaguraidhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'sun-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sun Villa', 200, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'sun-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 700, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'sun-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 600, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'sun-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- Sun-Siyam-IruVeli
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'sun-siyam-iru-veli-maldives-island-resort', 'Sun Siyam Iru Veli Maldives Island Resort', 'Sun Siyam Iru Veli is the perfect tropical hideaway, with sleek and spacious suites. With front-row lagoon views and a freshwater pool in each five-star room, all you have to do is check in, relax, and watch our neighbouring dolphins swim by each day. Shoes are left at the entrance from the time you walk in, so forget about dress rules and come as you are. We live in the barefoot idyll, so relax and bury your toes into the smoothest white sand - it doesn''t get any better than this.', 'published', 'Sun Siyam Iru Veli Maldives Island Resort | Maldives Resorts | MTG', 'Sun Siyam Iru Veli is the perfect tropical hideaway, with sleek and spacious suites. With front-row lagoon views and a freshwater pool in each five-star room, all you have to do is check in, relax, and watch our neighbouring dolphins swim by each day. Shoes are left at the entrance from the time you walk in, so forget about dress rules and come as you are. We live in the barefoot idyll, so relax and bury your toes into the smoothest white sand - it doesn''t get any better than this.', '{"overview_paragraphs":["Sun Siyam Iru Veli is the perfect tropical hideaway, with sleek and spacious suites. With front-row lagoon views and a freshwater pool in each five-star room, all you have to do is check in, relax, and watch our neighbouring dolphins swim by each day. Shoes are left at the entrance from the time you walk in, so forget about dress rules and come as you are. We live in the barefoot idyll, so relax and bury your toes into the smoothest white sand - it doesn''t get any better than this.","These suites are spacious and appealing, with views of the dawn or sunset and lots of space to assemble. Plenty of natural light is provided through floor-to-ceiling glass doors and an outdoor bathroom, as well as space to enjoy outside on the wide sundeck, your own length of beach, or in your private pool.","These suites provide front-row seats for seeing dolphins swim by every day - a spectacular sight you''ll never forget. We''ve brought the beach right to your door, with your very own length of sand constructed into the deck.","Enjoy the good life in our 125 sun-drizzled suites, which are scattered over the lagoon and across sugar-fine dunes and are bathed in warm, natural light. Each is a luxurious hideaway with its own private pool.","Sun Siyam Iru Veli lives on Aluvifushi, an island in South Nilandhe Atoll (also known as Dhaalu Atoll). Sun Siyam Iru Veli is 40 minutes from Velana International Airport via seaplane.","The buffet at Aqua Orange is a visual feast, presenting an incredible assortment of cuisines from across the world. Following breakfast, lunch and supper will entice you with Italian classics, Maldivian specialties, and themed evenings. With tables placed out on the beach, you may enjoy stunning lagoon views as your backdrop."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1300, '1ljyDTmN1Yk', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'sun-siyam-iru-veli-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'sun-siyam-iru-veli-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'aloofushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'sun-siyam-iru-veli-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Family Suite Pool', 1400, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'sun-siyam-iru-veli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Dolphin Ocean Suite', 1300, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'sun-siyam-iru-veli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Sun-Siyam-Olhuveli
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'sun-siyam-olhuveli-maldives-island-resort', 'Sun Siyam Olhuveli Maldives Island Resort', 'The large island of Olhuveli is only a 45-minute speedboat trip away from where you landed. With no need for a seaplane, you can get right into visiting our two islands or just relaxing. This is your time together. Sun Siyam Olhuveli combines traditional Maldivian style with modern design, with accommodations ranging from Maldivian-inspired suites to sleek contemporary villas. We have three pools to appeal to your every need, including an adults-only infinity pool that never fails to please - but be careful, the lagoon may pull you into adventure.', 'published', 'Sun Siyam Olhuveli Maldives Island Resort | Maldives Resorts | MTG', 'The large island of Olhuveli is only a 45-minute speedboat trip away from where you landed. With no need for a seaplane, you can get right into visiting our two islands or just relaxing. This is your time together. Sun Siyam Olhuveli combines traditional Maldivian style with modern design, with accommodations ranging from Maldivian-inspired suites to sleek contemporary villas. We have three pools to appeal to your every need, including an adults-only infinity pool that never fails to please - but be careful, the lagoon may pull you into adventure.', '{"overview_paragraphs":["The large island of Olhuveli is only a 45-minute speedboat trip away from where you landed. With no need for a seaplane, you can get right into visiting our two islands or just relaxing. This is your time together. Sun Siyam Olhuveli combines traditional Maldivian style with modern design, with accommodations ranging from Maldivian-inspired suites to sleek contemporary villas. We have three pools to appeal to your every need, including an adults-only infinity pool that never fails to please - but be careful, the lagoon may pull you into adventure.","King-size bedrooms include clean white lines with vibrant bursts of colour, as well as an alcoved daybed great for curling up with a good book. The outdoor baths are spacious, and there is an eating area, daybed, and sun loungers on the oceanfront terrace.","These traditional Maldivian overwater villas have an outdoor jet tub and steps that go straight into the lagoon. The king-size beds are located behind a comfy sofa, well positioned to soak in the views, and each bathroom has a standalone tub.","Step into your new home at Sun Siyam Olhuveli Maldives for the next several pleasant days. Each of the 164 villas, which include Deluxe Rooms, Beach Villas, Deluxe Water Villas, Jacuzzi Water Villas, and Honeymoon Water Villas, as well as the luxury Presidential Water Suite, has been designed with comfort, relaxation, and elegance in mind. The rooms were created using natural materials and integrating them with modern elegance and open-air styled to take advantage of the Maldivian sunlight and serene vistas. A variety of villas offer the ideal option of lodging for families, couples, honeymooners, and individuals alike.","The scenic Sun Siyam Olhuveli Maldives is located on the tip of South Male'' Atoll, 34 kilometres from Velana International Airport, and is known for its magnificent beaches and numerous sandbanks. A scenic 45-minute speedboat ride takes you to the resort.","Malaafaiy, which is perfectly located for Dream Island guests, provides something for everyone all day long. Ocean vistas and a pleasant sea wind will accompany every meal, whether you''re fueling up before a long day of activity, stopping in for a quick lunch, or visiting us for dinner."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 800, 'H-_NBKBb1fw', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'sun-siyam-olhuveli-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'sun-siyam-olhuveli-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'olhuveli'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'sun-siyam-olhuveli-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Garden Beach Villa', 800, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'sun-siyam-olhuveli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Water Villa', 800, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'sun-siyam-olhuveli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Sun-Siyam-ViluReef
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'sun-siyam-vilu-reef-maldives-island-resort', 'Sun Siyam Vilu Reef Maldives Island Resort', 'Stay at Sun Siyam Vilu Reef Maldives'' water villas and enjoy 5 star luxury with sand beneath your feet. Sink into new depths of relaxation with the waves as your soundtrack in this perfect honeymoon destination. You''ll quickly understand why we welcome so many familiar faces back year after year. Sun Siyam Vilu Reef''s water villas are surrounded by some of the nicest coral reef in the Maldives, and we''ve been sharing the resort''s island home with unique flora and animals for over 20 years. Coconut palms flutter in the air, and don''t be shocked if you see a heron or a hermit crab on your walk to breakfast.', 'published', 'Sun Siyam Vilu Reef Maldives Island Resort | Maldives Resorts | MTG', 'Stay at Sun Siyam Vilu Reef Maldives'' water villas and enjoy 5 star luxury with sand beneath your feet. Sink into new depths of relaxation with the waves as your soundtrack in this perfect honeymoon destination. You''ll quickly understand why we welcome so many familiar faces back year after year. Sun Siyam Vilu Reef''s water villas are surrounded by some of the nicest coral reef in the Maldives, and we''ve been sharing the resort''s island home with unique flora and animals for over 20 years. Coconut palms flutter in the air, and don''t be shocked if you see a heron or a hermit crab on your walk to breakfast.', '{"overview_paragraphs":["Stay at Sun Siyam Vilu Reef Maldives'' water villas and enjoy 5 star luxury with sand beneath your feet. Sink into new depths of relaxation with the waves as your soundtrack in this perfect honeymoon destination. You''ll quickly understand why we welcome so many familiar faces back year after year. Sun Siyam Vilu Reef''s water villas are surrounded by some of the nicest coral reef in the Maldives, and we''ve been sharing the resort''s island home with unique flora and animals for over 20 years. Coconut palms flutter in the air, and don''t be shocked if you see a heron or a hermit crab on your walk to breakfast.","Our 14 Beach Bungalows are directly on the beach, only steps from the lagoon. Bright white furnishings contrast with tropical colour accents, and each suite has a king-size bed, an alcoved daybed, an outdoor bathroom with a rain shower, and a covered terrace with loungers and a dining space.","There are just six Aqua Villas on the jetty, and with infinity plunge pools, overwater hammocks, and big outside terraces with stairs straight down to the lagoon, it''s simple to understand why. Sliding glass doors let in natural light and seaside breezes, and the bathrooms include freestanding tubs and separate showers.","Sun Siyam Vilu Reef villas provide a taste of island living - a relaxed luxury brimming with friendliness. Sleep to the sound of the waves and jump into the sea from your own private jetty. They truly offer something for everyone, with 103 beautiful Villas, 6 Suites, 62 Land Villas, and 35 Over Water Villas.","Get away from the fast-paced city life and start your trip to luxury. Sun Siyam Vilu Reef is approximately a 35-minute seaplane journey from the international airport. The ride to Vilu Reef is breathtaking, so your escape to paradise begins as soon as you land at the airport.","Seafood lovers should attend to our monthly lobster and champagne feast, served on the beach with live music, from the restaurants and bars at Sun Siyam Vilu Reef Maldives. Cocktail experts will like our herb-infused creations, while wine connoisseurs will enjoy our award-winning cellar, which houses over 1,400 wines."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 800, 'KWl90P4Oe10', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'sun-siyam-vilu-reef-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'sun-siyam-vilu-reef-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'meedhuffushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'sun-siyam-vilu-reef-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 800, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'sun-siyam-vilu-reef-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Aqua Villa', 1000, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'sun-siyam-vilu-reef-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Taj-Coral-Reef
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'taj-coral-reef-resort-spa-maldives', 'Taj Coral Reef Resort & Spa Maldives', 'Taj Coral Reef Resort & Spa, located on heart-shaped Hembadhu Island, is a modern tropical haven hidden atop a 1000-year-old beautiful coral atoll in sunny Maldives. A 45-minute speed boat trip from Velana International Airport, 62 magnificent thatched-roof villas are built above our house reef to provide ecologically friendly, all-inclusive holidays.', 'published', 'Taj Coral Reef Resort & Spa Maldives | Maldives Resorts | MTG', 'Taj Coral Reef Resort & Spa, located on heart-shaped Hembadhu Island, is a modern tropical haven hidden atop a 1000-year-old beautiful coral atoll in sunny Maldives. A 45-minute speed boat trip from Velana International Airport, 62 magnificent thatched-roof villas are built above our house reef to provide ecologically friendly, all-inclusive holidays.', '{"overview_paragraphs":["Taj Coral Reef Resort & Spa, located on heart-shaped Hembadhu Island, is a modern tropical haven hidden atop a 1000-year-old beautiful coral atoll in sunny Maldives. A 45-minute speed boat trip from Velana International Airport, 62 magnificent thatched-roof villas are built above our house reef to provide ecologically friendly, all-inclusive holidays.","Superior Beach Villas are 58 square metres of ultimate luxury, with 12 attractively decorated Superior Beach Villas. Our airy Superior beach villas at Taj Coral Reef, Maldives work their spell on you with amazing views, outdoor bathrooms, and a distinctively constructed open area, and are built in subdued and relaxing pastel colours with a wide comfy sea-facing bed. These magnificent rooms, with distinctive thatched roofs, provide complete solitude for your tropical escape. You may enjoy all of the greatest amenities at these beach villas. Wrap yourself in 100% cotton robes, indulge in delectable snacks from our 24-hour in-villa dining, or simply watch a movie on our 43\" LED TV with home theatre system. Come on in and let us immerse you in ecstasy.","Our Taj Coral Reef, Maldives'' 32 Premium Water Villas will delight all of your senses. This is a great area for supper, with 85 square metres designed to be your personal paradise, a thatched roof, and an exterior terrace facing the sea with sun loungers. Absolute joy! An open-air shower and a large wooden stairway leading directly into the lagoon would complete the indoor-outdoor experience. Inside, you''ll find a wide peaceful sea-facing bed, a wardrobe, and direct access to the outdoor terrace from the bedroom and bathroom. A comfortable day bed, attractive furnishings, and the Treat Yourself minibar, which features organic foods and drinks, are among the other amenities. Begin your tropical transformation now.","The resort provides modern conveniences in a natural setting, with most of the magnificent apartments and villas enjoying ocean views, whether on the beach or across the lagoon. Spacious thatched villas provide sophisticated décor, soft furniture, and stunning bathrooms with open air showers, while private decks provide relaxing places. Some villas include a private plunge pool for extra luxury, while the Nirvana Presidential Suites are ideal for families with two bedrooms split across two storeys.","The resort is located on Hembadhu Island, less than 32 kilometres from Velana International Airport. Amateurs and pros can explore the resort''s own own house reef and shipwreck. Those who choose to stay on land will be captivated by the beauty of the lagoon studded with water homes.","What is a world-class island trip without excellent seafood, beach barbecues, and elegant private dining? Our Coral All-Inclusive Meal Plan is your gastronomic passport to a wide range of international and regional cuisines at these fashionable establishments. The Coral All-Inclusive provides everything you need for a fantastic holiday in one easy package. We''ve curated a bouquet of our best gourmet and aquatic experiences so you may see and do it all without having to pick and choose."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1150, 'dPFQMGyAFck', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'taj-coral-reef-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'taj-coral-reef-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'hembadhu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'taj-coral-reef-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Superior Beach Villa', 1150, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'taj-coral-reef-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Premium Water Villa', 1400, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'taj-coral-reef-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- Taj-Exotica
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'taj-exotica-resort-spa-maldives', 'Taj Exotica Resort & Spa Maldives', 'Escape the frantic speed and confusion of everyday life at Taj Exotica Resort & Spa in the Maldives. Away from the bright lights of Male, our 5 star Maldives hotel is set across the Emboodhu Finolhu island in the heart of one of the Maldives'' biggest lagoons. This tropical isle, also known as the Three Coconut Isle, is located among coral reefs and is recognised for its abundant flora and wildlife. A 15- to 20-minute speedboat journey from the airport takes you to Male''s lovely beach resort, which is encircled by the blue seas of the Indian Ocean. Set gently above the lagoon, this postcard-perfect Maldives retreat offers 64 sea-view suites and villas that are sumptuous and extravagant while remaining affordable.', 'published', 'Taj Exotica Resort & Spa Maldives | Maldives Resorts | MTG', 'Escape the frantic speed and confusion of everyday life at Taj Exotica Resort & Spa in the Maldives. Away from the bright lights of Male, our 5 star Maldives hotel is set across the Emboodhu Finolhu island in the heart of one of the Maldives'' biggest lagoons. This tropical isle, also known as the Three Coconut Isle, is located among coral reefs and is recognised for its abundant flora and wildlife. A 15- to 20-minute speedboat journey from the airport takes you to Male''s lovely beach resort, which is encircled by the blue seas of the Indian Ocean. Set gently above the lagoon, this postcard-perfect Maldives retreat offers 64 sea-view suites and villas that are sumptuous and extravagant while remaining affordable.', '{"overview_paragraphs":["Escape the frantic speed and confusion of everyday life at Taj Exotica Resort & Spa in the Maldives. Away from the bright lights of Male, our 5 star Maldives hotel is set across the Emboodhu Finolhu island in the heart of one of the Maldives'' biggest lagoons. This tropical isle, also known as the Three Coconut Isle, is located among coral reefs and is recognised for its abundant flora and wildlife. A 15- to 20-minute speedboat journey from the airport takes you to Male''s lovely beach resort, which is encircled by the blue seas of the Indian Ocean. Set gently above the lagoon, this postcard-perfect Maldives retreat offers 64 sea-view suites and villas that are sumptuous and extravagant while remaining affordable.","These lovely homes are set on excellent white beach sand and are only steps away from the lagoon. To round out your Maldives experience, indulge in the joys of a tropical outdoor shower in your private walled garden.","Overwater Villas on stilts with private sun decks, loungers, and easy chairs, as well as direct access to the lagoon. Each villa has a double vanity bathroom, rain showers, and bathtubs, as well as breathtaking views of the Indian Ocean.","This postcard-perfect retreat is set gently above the lagoon and provides 64 sea-view villas and suites that are sumptuous and extravagant while maintaining a fine balance with nature. The Taj Exotica Resort & Spa also includes a world-famous, award-winning presidential suite that is probably the most gorgeous spot on the planet.","Taj Exotica Resort & Spa is located away from the bright lights of Male'', on Emboodhu Finolhu island, in the heart of one of the Maldives'' biggest lagoons. The lovely resort is bordered by the blue seas of the Indian Ocean and is only a 15-minute speedboat ride from the airport.","At Taj Exotica Maldives, you can eat your way across the globe. The chefs at our award-winning Maldives restaurants guarantee to take you on a culinary tour de force. This, along with the splendour of the Maldives, creates an otherworldly experience."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 2500, 'AHXkN6Zbg3E', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'taj-exotica-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'taj-exotica-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'emboodhu-finolhu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'taj-exotica-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Beach Pool Villa', 3400, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'taj-exotica-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 2500, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'taj-exotica-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- The-Ritz-Carlton
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'the-ritz-carlton-maldives-fari-island-resort', 'The Ritz Carlton Maldives Fari Island Resort', 'The Ritz-Carlton Maldives, Fari Islands invites you to immerse yourself in island life and relax in an azure lagoon surrounded by white sand beaches. From Velana International Airport, the resort is a 45-minute picturesque voyage by luxury speedboat or a 10-minute seaplane flight away. The resort features 100 elegantly built villas by Kerry Hill Architect, inspired by water and circular movement, where modern architecture meets the Maldives. Each villa features a private pool, sundeck, en-suite bathroom, and a spectacular assortment of individualized amenities both indoors and out.', 'published', 'The Ritz Carlton Maldives Fari Island Resort | Maldives Resorts | MTG', 'The Ritz-Carlton Maldives, Fari Islands invites you to immerse yourself in island life and relax in an azure lagoon surrounded by white sand beaches. From Velana International Airport, the resort is a 45-minute picturesque voyage by luxury speedboat or a 10-minute seaplane flight away. The resort features 100 elegantly built villas by Kerry Hill Architect, inspired by water and circular movement, where modern architecture meets the Maldives. Each villa features a private pool, sundeck, en-suite bathroom, and a spectacular assortment of individualized amenities both indoors and out.', '{"overview_paragraphs":["The Ritz-Carlton Maldives, Fari Islands invites you to immerse yourself in island life and relax in an azure lagoon surrounded by white sand beaches. From Velana International Airport, the resort is a 45-minute picturesque voyage by luxury speedboat or a 10-minute seaplane flight away. The resort features 100 elegantly built villas by Kerry Hill Architect, inspired by water and circular movement, where modern architecture meets the Maldives. Each villa features a private pool, sundeck, en-suite bathroom, and a spectacular assortment of individualized amenities both indoors and out."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 2384, 'Zcocq4od2Tw', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'the-ritz-carlton-maldives-fari-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'the-ritz-carlton-maldives-fari-island-resort'
  and l.node_type = 'location' and l.slug = 'fari-islands'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'the-ritz-carlton-maldives-fari-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Villa', 2887, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'the-ritz-carlton-maldives-fari-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Pool Villa', 2384, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'the-ritz-carlton-maldives-fari-island-resort'
on conflict (accommodation_id, name) do nothing;

-- VARU-Atmosphere
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'varu-by-atmosphere-maldives-island-resort', 'VARU by Atmosphere Maldives Island Resort', 'Atmosphere Hotels & Resorts introduces VARU by Atmosphere, a Maldives all-inclusive resort, nestled in the beautiful Indian Oceans of the Maldives. Enjoy your first moments in paradise on a 40-minute speed boat ride from Male International Airport to the Maldives'' northwestern coast. Experience the local culture and genuine hospitality while receiving 5 star treatment during your stay. ''Varu'' in Dhivehi, the local dialect, means strength, resilience, and plenty, all of which come to life at the resort, with its ideal combination of contemporary architecture and tropical feelings of the island paradise.', 'published', 'VARU by Atmosphere Maldives Island Resort | Maldives Resorts | MTG', 'Atmosphere Hotels & Resorts introduces VARU by Atmosphere, a Maldives all-inclusive resort, nestled in the beautiful Indian Oceans of the Maldives. Enjoy your first moments in paradise on a 40-minute speed boat ride from Male International Airport to the Maldives'' northwestern coast. Experience the local culture and genuine hospitality while receiving 5 star treatment during your stay. ''Varu'' in Dhivehi, the local dialect, means strength, resilience, and plenty, all of which come to life at the resort, with its ideal combination of contemporary architecture and tropical feelings of the island paradise.', '{"overview_paragraphs":["Atmosphere Hotels & Resorts introduces VARU by Atmosphere, a Maldives all-inclusive resort, nestled in the beautiful Indian Oceans of the Maldives. Enjoy your first moments in paradise on a 40-minute speed boat ride from Male International Airport to the Maldives'' northwestern coast. Experience the local culture and genuine hospitality while receiving 5 star treatment during your stay. ''Varu'' in Dhivehi, the local dialect, means strength, resilience, and plenty, all of which come to life at the resort, with its ideal combination of contemporary architecture and tropical feelings of the island paradise.","Beach Villas with Pool are located along the palm-fringed beach, only steps from from the gorgeous white sandy beach. Relax in well-appointed surroundings with natural wood and stone accents, minimalistic design, and ornamental things. The expansive outside terrace is surrounded by lush green flora and a private infinity pool of 10m2.","Escape to an exquisite getaway at our Maldives Overwater pool villa, just steps from from the blue lagoon. This precisely constructed apartment combines the finest of modern living with cutting-edge conveniences. Everything here reflects the island''s fascinating Indian Ocean surroundings, from Maldivian-style interiors to enticing tropical features. The wide veranda has a private 10m2 infinity pool, ideal for a refreshing dip while admiring the lovely lagoon views.","VARU is positioned as a modern and ''Naturally Maldivian'' resort experience, with 108 Villas strewn along the white sandy beaches and spreading over the blue lagoons onto three jetties with over-water accommodation.","VARU is located on the northwestern border of the Malé Atoll Maldives.","Indulge in a gastronomical adventure at VARU by Atmosphere in the Maldives, with the top Maldives restaurants bringing the world to you on a plate through the most delectable culinary experiences. Choose from the best culinary dishes from Europe to Asia, with a Maldivian twist. To create that unique experience for the ages, enjoy magnificent lunch and supper dishes with stunning presentations matched by exquisite vistas."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1200, 'JCoOrSl6-as', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'varu-by-atmosphere-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'varu-by-atmosphere-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'madivaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'varu-by-atmosphere-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1200, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'varu-by-atmosphere-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Pool Villa', 1400, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'varu-by-atmosphere-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Vakkaru
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'vakkaru-maldives-island-resort', 'Vakkaru Maldives Island Resort', 'Vakkaru Maldives is an isolated coral island inside the UNESCO Biosphere Reserve of Baa Atoll, blessed with timeless ocean vistas, powder-soft, beautiful white sands, deep blue holes, and a house reef with unique marine fauna. A picturesque 30-minute seaplane journey from Male International Airport whisks you away to this pristine hideaway, which has been intelligently built for tourists seeking timeless experiences.', 'published', 'Vakkaru Maldives Island Resort | Maldives Resorts | MTG', 'Vakkaru Maldives is an isolated coral island inside the UNESCO Biosphere Reserve of Baa Atoll, blessed with timeless ocean vistas, powder-soft, beautiful white sands, deep blue holes, and a house reef with unique marine fauna. A picturesque 30-minute seaplane journey from Male International Airport whisks you away to this pristine hideaway, which has been intelligently built for tourists seeking timeless experiences.', '{"overview_paragraphs":["Vakkaru Maldives is an isolated coral island inside the UNESCO Biosphere Reserve of Baa Atoll, blessed with timeless ocean vistas, powder-soft, beautiful white sands, deep blue holes, and a house reef with unique marine fauna. A picturesque 30-minute seaplane journey from Male International Airport whisks you away to this pristine hideaway, which has been intelligently built for tourists seeking timeless experiences.","Beach Villa with Plunge Pool, surrounded by swaying coconut palms and lush greenery, with direct beach access and a private terrace, as well as a recently added open-air Jacuzzi suited for couples seeking romantic relaxation.","Our Over Water Villas are the perfect romantic getaway positioned over the turquoise lagoon, with a private over water patio and hammock for two people wishing to savour the splendour of their aquatic surrounds.","Whether you are travelling as a couple on a romantic getaway or in a bigger group with family and friends, Vakkaru Maldives has a fantastic selection of luxury hotel choices. All 113 beach and over water villas and Residences have an earthy yet sophisticated style, in line with the rustic charms of Maldivian culture, and give an unparalleled feeling of spaciousness and breathtaking ocean vistas.","From Velana International Airport, a picturesque 25-minute seaplane trip takes you to Vakkaru Maldives, an enchanting sanctuary organically built to heal the soul and quiet the spirit.","To begin the day, enjoy healthy flavours in a quiet, light, and airy atmosphere by the beach, with an interactive presentation of world cuisines and inspired meals enhanced with local tastes and tropical tones."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 3000, '-tmrOPCI3-Q', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'vakkaru-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'vakkaru-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'vakkaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'vakkaru-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 4800, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'vakkaru-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Villa', 3000, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'vakkaru-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Veligandu-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'veligandu-island-resort-spa-maldives', 'Veligandu Island Resort & Spa Maldives', 'The jewel of the Indian Ocean is Veligandu Island Resort & Spa. A charming tropical paradise filled with swaying palm palms, white sand beaches, crystal clear water, and exuberant coral reefs alive with marine life. This green island retreat provides peace and serenity, which feed one''s well-being.', 'published', 'Veligandu Island Resort & Spa Maldives | Maldives Resorts | MTG', 'The jewel of the Indian Ocean is Veligandu Island Resort & Spa. A charming tropical paradise filled with swaying palm palms, white sand beaches, crystal clear water, and exuberant coral reefs alive with marine life. This green island retreat provides peace and serenity, which feed one''s well-being.', '{"overview_paragraphs":["The jewel of the Indian Ocean is Veligandu Island Resort & Spa. A charming tropical paradise filled with swaying palm palms, white sand beaches, crystal clear water, and exuberant coral reefs alive with marine life. This green island retreat provides peace and serenity, which feed one''s well-being.","Enjoy beachfront views from your Maldives Beach Villa, which is only a few steps from the water. All of our 11 Beach Villas are set among lush tropical flora and beneath swaying coconut palms and offer the needed facilities for a pleasant, comfortable vacation in paradise.","Slip away to your private ocean retreat and enjoy the pleasure of direct access to the blue waters of the ocean through the stairs on your Water Villa''s sun-kissed balcony.","Private porches, lagoon views, flat-screen TVs, and complimentary high-speed Internet are available in the exquisite villas. Upgraded villas have whirlpool spas or Jacuzzis, and some are perched on stilts over the lagoon. Some villas accept children aged 14 and under.","A 20-minute seaplane journey from Velana International Airport takes you to this quiet resort on a 600-meter-long island. Surrounded by stunning lagoons, a great house reef, and long expanses of pristine white sand,","Enjoy the exquisite joys of paradise while tickling your taste senses. Veligandu, home to some of the top restaurants in the Maldives, serves flavorful native food as well as cuisines from across the world. Dhonveli, our primary restaurant, offers a wide range of cuisines. During breakfast, lunch, and supper, the buffet offers a diverse selection of gastronomic pleasures. Madivaru, our famous à la carte restaurant, serves a fine dining menu full of delectable specialties, all while overlooking the lagoon. Relaxed afternoons and evenings are best spent at one of our bars, with a cool drink in hand."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 600, '8RTjyBXGrJA', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'veligandu-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'veligandu-island-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'veligandu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'veligandu-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'veligandu-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 600, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'veligandu-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;
