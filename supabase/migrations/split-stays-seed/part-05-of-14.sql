-- Part 5 of 14 - run this in the Supabase SQL Editor AFTER the previous parts.
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

-- Fairmont
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'fairmont-maldives-sirru-fen-fushi', 'Fairmont Maldives Sirru Fen Fushi', 'Sirru Fen Fushi is more than simply your own retreat. It is located on the Shaviyani Atoll, which contains one of the country''s largest resort lagoons, Fairmont Maldives. Our "hidden water island," as the locals call it, shines like a gem. Postcard-perfect white sand beaches bordered with swaying palms, lapped by the turquoise waters of the 600-hectare lagoon that leads to the calm blues of the Indian Ocean and an endless horizon.', 'published', 'Fairmont Maldives Sirru Fen Fushi | Maldives Resorts | MTG', 'Sirru Fen Fushi is more than simply your own retreat. It is located on the Shaviyani Atoll, which contains one of the country''s largest resort lagoons, Fairmont Maldives. Our "hidden water island," as the locals call it, shines like a gem. Postcard-perfect white sand beaches bordered with swaying palms, lapped by the turquoise waters of the 600-hectare lagoon that leads to the calm blues of the Indian Ocean and an endless horizon.', '{"overview_paragraphs":["Sirru Fen Fushi is more than simply your own retreat. It is located on the Shaviyani Atoll, which contains one of the country''s largest resort lagoons, Fairmont Maldives. Our \"hidden water island,\" as the locals call it, shines like a gem. Postcard-perfect white sand beaches bordered with swaying palms, lapped by the turquoise waters of the 600-hectare lagoon that leads to the calm blues of the Indian Ocean and an endless horizon.","Our magnificent resort has the Maldives'' largest infinity pool, which leads to the Coralarium, the Maldives'' first and only coral regeneration project in the form of an underwater art installation by Jason deCaires Taylor. Sirru Fen Fushi at Fairmont Maldives is surrounded by magnificent Beach Villas, decadent Over Water Villas, and the unique luxury Tented Jungle Villas.","The Beach Sunset Villas, nestled among thick mangrove greenery on the edge of beautiful white sands, have an en-suite private bathroom with separate shower, twin vanities, a Nespresso coffee machine, wine fridge, a Bose sound system, and a California king-size bed. Outside, there''s a private alfresco bathroom with bathtub and shower, a 14-square-meter plunge pool, and a sala where you can rest and eat. Your personal butler is accessible 24 hours a day to attend to every detail and is only a phone call away. Alternatively, ride your bike along the resort''s sandy roads.","These 495 sqm private luxury pool homes on the island''s east coast are ideal for families, tucked among lush tropical flora. The villas offer private tropical gardens, a plunge pool, big indoor and outdoor bathrooms with separate shower and double sink, a Nespresso coffee maker, wine fridge, Bose Hi-Fi system, a California King-size bed, and a separate living room space. A professional Villa Host is on hand 24 hours a day and takes care in making your stay as pleasant as possible; simply call them and begin exploring our private water island.","These 495 sqm private premium pool homes tucked on the island''s east coast are ideal for families. The pristine Indian Ocean in front of you, lush mangrove behind, the villas feature private tropical gardens, plunge pool, generous indoor and outdoor bathrooms with separate shower and double sink, a Nespresso coffee machine, wine fridge, Bose Hi-Fi system, a California King-size bed, and a separate living room area. A specialised Villa Host is accessible 24 hours a day and takes delight in making your stay as pleasant as possible; simply call them and begin exploring our secret water island.","Relax into the natural elegance of Fairmont Maldives Sirru Fen Fushi''s rustic chic Beach and Water Villas, each with its own private pool, or retreat in true tropical flair to Tented Jungle Villa while indulging in an inspiring Maldivian experience."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 850, 'jGU84_1YfzM', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'fairmont-maldives-sirru-fen-fushi'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'fairmont-maldives-sirru-fen-fushi'
  and l.node_type = 'location' and l.slug = 'sirru-fen-fushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'fairmont-maldives-sirru-fen-fushi'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Villa', 850, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'fairmont-maldives-sirru-fen-fushi'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Beach Sunrise Villa', 1280, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'fairmont-maldives-sirru-fen-fushi'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Sunrise Villa', 1111, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'fairmont-maldives-sirru-fen-fushi'
on conflict (accommodation_id, name) do nothing;

-- Filitheyo-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'filitheyo-island-resort-maldives', 'Filitheyo Island Resort Maldives', 'Welcome to an island paradise of verdant jungle greenery and gleaming white beaches. Filitheyo resort is located on Faafu Atoll, one of the Maldives'' most pristine atolls, which is rich in colourful marine life and brilliant coral 120. It takes 35 minutes by sea plane to reach 7 km from Male Velana International Airport, followed by a 10-minute traditional dhoni ride. Seaplane transfers are the only way for visitors to reach this beautiful island.', 'published', 'Filitheyo Island Resort Maldives | Maldives Resorts | MTG', 'Welcome to an island paradise of verdant jungle greenery and gleaming white beaches. Filitheyo resort is located on Faafu Atoll, one of the Maldives'' most pristine atolls, which is rich in colourful marine life and brilliant coral 120. It takes 35 minutes by sea plane to reach 7 km from Male Velana International Airport, followed by a 10-minute traditional dhoni ride. Seaplane transfers are the only way for visitors to reach this beautiful island.', '{"overview_paragraphs":["Welcome to an island paradise of verdant jungle greenery and gleaming white beaches. Filitheyo resort is located on Faafu Atoll, one of the Maldives'' most pristine atolls, which is rich in colourful marine life and brilliant coral 120. It takes 35 minutes by sea plane to reach 7 km from Male Velana International Airport, followed by a 10-minute traditional dhoni ride. Seaplane transfers are the only way for visitors to reach this beautiful island.","This quaint Maldives resort offers a spa unlike any other. The jungle spa, located in the middle of the island, is a tranquil haven surrounded by lush tropical flora. Spa therapists provide a variety of Balinese and foreign treatments. Filitheyo is also a scuba diver''s heaven. The house reef is teeming with aquatic life, such as fish, reef sharks, and rays, and our Werner Lau dive centre offers a variety of daily excursions. The freeform infinity-edge swimming pool adjacent to the sea, complete with a swim-up bar, is an ideal place to unwind.","These semi-detached villas on the beachfront provide a king size four poster bed or twin beds, a private sundeck with a day bed, and a semi-open-air bathroom with an outdoor shower. Families and groups can request interconnecting rooms.","The spacious water villas are built on stilts above the lagoon and have a king size four poster bed or twin beds, a huge bathroom with a jacuzzi, day bed, and a private sundeck with a traditional ''udoli'' (swing chair) and private stairs going right into the water.","Filitheyo, with a total land area of around 21 hectares, contains 125 homes built to blend in with the island ambience, creating the image of wooden cottages with thatched roofs covered by palm trees. They are all outfitted with the greatest and most up-to-date accommodation amenities and services.","Filitheyo resort, located in Faafu Atoll, is 121 kilometres from Velana International Airport and is accessible by sea plane in 35 minutes, followed by a 15-minute traditional dhoni ride. Seaplane transfers are the sole way for visitors to reach this picturesque island."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 250, 'N-FaHyKf1uI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'filitheyo-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'filitheyo-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'filitheyo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'filitheyo-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Superior Villa', 250, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'filitheyo-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 620, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'filitheyo-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Finolhu
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'finolhu-maldives-island-resort-kanufushi', 'Finolhu Maldives Island Resort Kanufushi', 'Finolhu, a Maldives resort, provides similar experiences. Imagine you''re relaxing on the patio of your private villa at sunset when a manta ray swims past. Or perhaps you''re snorkelling in the morning and are met by a colourful and interested turtle. Finolhu lies on the cusp of a very different world: the sea is the world''s largest natural ecosystem. And here in Baa Atoll, a UNESCO biosphere reserve, the colours of the corals and fish reveal their very distinct enchantment. Finolhu is a fantastic destination, both on the beach and in the ocean. So please tell us about your dreams! We are excited to meet you!', 'published', 'Finolhu Maldives Island Resort Kanufushi | Maldives Resorts | MTG', 'Finolhu, a Maldives resort, provides similar experiences. Imagine you''re relaxing on the patio of your private villa at sunset when a manta ray swims past. Or perhaps you''re snorkelling in the morning and are met by a colourful and interested turtle. Finolhu lies on the cusp of a very different world: the sea is the world''s largest natural ecosystem. And here in Baa Atoll, a UNESCO biosphere reserve, the colours of the corals and fish reveal their very distinct enchantment. Finolhu is a fantastic destination, both on the beach and in the ocean. So please tell us about your dreams! We are excited to meet you!', '{"overview_paragraphs":["Finolhu, a Maldives resort, provides similar experiences. Imagine you''re relaxing on the patio of your private villa at sunset when a manta ray swims past. Or perhaps you''re snorkelling in the morning and are met by a colourful and interested turtle. Finolhu lies on the cusp of a very different world: the sea is the world''s largest natural ecosystem. And here in Baa Atoll, a UNESCO biosphere reserve, the colours of the corals and fish reveal their very distinct enchantment. Finolhu is a fantastic destination, both on the beach and in the ocean. So please tell us about your dreams! We are excited to meet you!","Our Maldivian Beach Villas provide that laid-back island vibe. You can see your lush garden and the beach beyond without getting out of bed, and the blue sea is immediately behind you. The subtle changes in forms and tones of blue and green, as well as the apricot tone of the setting sun, provide lightness and freshness to this lovely 205-square-meter garden cottage. A large bathroom with tub and shower at the back contains an open-air space where you may stare at the stars while having a shower.","In one of our beachfront pool villas, you can experience true Maldivian comfort and relaxation. Imagine waking up in the morning and gazing out at your beautiful private garden, then wandering through it to the beach and the stunning lagoon beyond. Life can be so carefree and lovely when you''re lying entirely comfortable in your own private pool, reading a book under the palm trees, or taking a refreshing shower in the open-air section of the bathroom. The pool villa is 205 square metres (2206 ft2) with indoor and outdoor areas and provides a pleasant blend of privacy and spaciousness, while the beautiful colour composition gives this home lightness and freshness.","The view over the tranquil waters of the lagoon with its countless colours of blue from this stylish Lagoon Villa may be seductive. You may sprawl out and relax on the sun loungers of your hidden wooden deck, which has 145 square metres of private area immediately above the ocean, while a private jetty runs directly into the sea. Take another drink while listening to your favourite music on the cutting-edge Marshall Sound System. Life is really amazing here!","Living by the sea and seeing its countless colours of blue on a daily basis is healthy for the soul. When one looks out over the water, the spirit is transported by the waves, and all sense of time fades. Staying in any of our 125 villas puts you right on the beach, on the lagoon, or on stilts above the water, and 79 of them have their own swimming pool. The acclaimed designers from Muza Lab in London have integrated the brilliant colours of nature inside the villas in an almost irresistible way, creating a kaleidoscope effect. Each villa not only has luxurious furnishings but also a high level of privacy, allowing you to sleep, relax, and shower in peace.","Finolhu Maldives lies in the UNESCO World Biosphere Reserve in Baa Atoll. Traveling by seaplane from Velana International Airport takes only 30 minutes, or take a 20-minute trip to Dharavandhoo Domestic Airport on Baa Atoll, followed by a 20-minute speedboat journey to Finolhu."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 800, 'WRlxlbZ3pYU', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'finolhu-maldives-island-resort-kanufushi'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'finolhu-maldives-island-resort-kanufushi'
  and l.node_type = 'location' and l.slug = 'kanufushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'finolhu-maldives-island-resort-kanufushi'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 950, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'finolhu-maldives-island-resort-kanufushi'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1400, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'finolhu-maldives-island-resort-kanufushi'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 800, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'finolhu-maldives-island-resort-kanufushi'
on conflict (accommodation_id, name) do nothing;

-- Four-Seasons-Giraavaru
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'four-seasons-resort-maldives-at-landaa-giraavaru', 'Four Seasons Resort Maldives at Landaa Giraavaru', 'Welcome to one of the most beautiful islands in the world: a UNESCO Biosphere Reserve wilderness where iridescent blues, jungle greens, and brilliant whites meet innovation, conservation, and health. Snorkel with manta rays in aquarium-like seas, rehabilitate sea turtles at our Marine Discovery Centre, enjoy world-class wellness at AyurMa, and dine at Blu Beach Club.', 'published', 'Four Seasons Resort Maldives at Landaa Giraavaru | Maldives Resorts | MTG', 'Welcome to one of the most beautiful islands in the world: a UNESCO Biosphere Reserve wilderness where iridescent blues, jungle greens, and brilliant whites meet innovation, conservation, and health. Snorkel with manta rays in aquarium-like seas, rehabilitate sea turtles at our Marine Discovery Centre, enjoy world-class wellness at AyurMa, and dine at Blu Beach Club.', '{"overview_paragraphs":["Welcome to one of the most beautiful islands in the world: a UNESCO Biosphere Reserve wilderness where iridescent blues, jungle greens, and brilliant whites meet innovation, conservation, and health. Snorkel with manta rays in aquarium-like seas, rehabilitate sea turtles at our Marine Discovery Centre, enjoy world-class wellness at AyurMa, and dine at Blu Beach Club.","Swim with the crew that is working relentlessly to safeguard the world''s biggest known population of manta rays. Sign up for our Manta On Call service and you will be whisked away by speedboat whenever manta rays are seen near the Resort for an amazing snorkelling experience.","Walk away from the beach and through a turquoise gate to your walled Beach Villa, which features a private lap pool flanked by a cushioned daybed, an open-air living and dining pavilion, and an island-style bedroom surrounded by tropical foliage.","In these west-facing infinity-pool villas, you can enjoy kaleidoscopic sunsets. Submit to the cool simplicity of indoor-outdoor life, from outdoor showers and a loft-level lounge to midnight dives in your private pool, isolated off a double jetty.","The villas and bungalows are a modest, modern fusion of Maldivian building techniques with Sri Lankan shapes. Four Seasons Landaa Giraavaru provides 13 various room types on both land and sea, each with its own private beach, pool, outdoor showers, beautiful private gardens, huge sundecks, outdoor showers, and nets for over-water sunbathing.","Four Seasons Landaa Giraavaru is a 44-acre utopia on the Baa Atoll UNESCO Biosphere Reserve that combines innovation, wellness, and conservation. Following your arrival at Velana International Airport (MLE), your adventure to Landaa Giraavaru continues with a 35-minute seaplane ride that provides a breathtaking view of the crystalline seas and secluded islands."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 2500, '74y61Fcw970', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'four-seasons-resort-maldives-at-landaa-giraavaru'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'four-seasons-resort-maldives-at-landaa-giraavaru'
  and l.node_type = 'location' and l.slug = 'landaa-giraavaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'four-seasons-resort-maldives-at-landaa-giraavaru'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa With Pool', 2500, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'four-seasons-resort-maldives-at-landaa-giraavaru'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunset Water Villa With Pool', 2500, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'four-seasons-resort-maldives-at-landaa-giraavaru'
on conflict (accommodation_id, name) do nothing;

-- Four-Seasons-Huraa
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'four-seasons-resort-maldives-at-kuda-huraa', 'FOUR SEASONS RESORT MALDIVES AT KUDA HURAA', 'Kuda Huraa rises gently from a sheet of turquoise, making it difficult to determine where the water stops and the sky starts. We embrace our gorgeous surroundings to bring you closer to the sea and its mysteries, which are as enthralling beneath the waves as they are above them. Discover a lagoon, flower gardens, a secluded spa island, and large new Beach Pavilion hideaways in a beautiful village setting, granted a Forbes Five-Star rating in 2020.', 'published', 'FOUR SEASONS RESORT MALDIVES AT KUDA HURAA | Maldives Resorts | MTG', 'Kuda Huraa rises gently from a sheet of turquoise, making it difficult to determine where the water stops and the sky starts. We embrace our gorgeous surroundings to bring you closer to the sea and its mysteries, which are as enthralling beneath the waves as they are above them. Discover a lagoon, flower gardens, a secluded spa island, and large new Beach Pavilion hideaways in a beautiful village setting, granted a Forbes Five-Star rating in 2020.', '{"overview_paragraphs":["Kuda Huraa rises gently from a sheet of turquoise, making it difficult to determine where the water stops and the sky starts. We embrace our gorgeous surroundings to bring you closer to the sea and its mysteries, which are as enthralling beneath the waves as they are above them. Discover a lagoon, flower gardens, a secluded spa island, and large new Beach Pavilion hideaways in a beautiful village setting, granted a Forbes Five-Star rating in 2020.","Take to the skies with a team of professional guides in search of the greatest surf and the largest waves in the Maldives. It''s your chance, only via our Resort, to fly into the heart of Maldivian surf wildness.","From internal solitude to the white-sand beach, from sunbathing on your private deck to cooling off in your plunge pool, you can do it all with ease. Our Sunrise Beach Bungalows with Pool are set among a paradise of tropical vegetation and mature palms and offer the finest of indoor-outdoor living.","Dive right from your bedroom into the infinity pool. Relax on overwater hammocks. At the water''s edge living and eating pavilion, soak up the sunset blues. Descend the steps into the warm clear lagoon, which is teeming with reef fish and corals.","The Four Seasons Kuda Huraa offers 13 distinct accommodation types, each with breathtaking views of the ocean.","Four Seasons Kuda Huraa is located on the North Malé Atoll, in the peaceful turquoise seas of the Indian Ocean, a 25-minute speedboat trip from Velana International Airport."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1500, '-8e3_fdwxmk', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'four-seasons-resort-maldives-at-kuda-huraa'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'four-seasons-resort-maldives-at-kuda-huraa'
  and l.node_type = 'location' and l.slug = 'kuda-huraa'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'four-seasons-resort-maldives-at-kuda-huraa'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Bangalow With Pool', 1500, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'four-seasons-resort-maldives-at-kuda-huraa'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunset Water Villa With Pool', 2200, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'four-seasons-resort-maldives-at-kuda-huraa'
on conflict (accommodation_id, name) do nothing;

-- Four-Seasons-Voavah
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'four-seasons-maldives-private-island-at-voavah-resort-maldives', 'Four Seasons Maldives Private Island at Voavah Resort Maldives', 'What would you do if you had a whole island to yourself? The answer is "anything" at the five-acre UNESCO refuge of Four Seasons Maldives Private Island in Voavah. Remove your barriers, broaden your horizons, retreat, explore, connect, or rejoice. Voavah offers you - and up to 21 guests - to dream with your eyes open, with your own 19-metre (62-foot) boat, dive centre, spa, Beach House, seven bedrooms, and resident pod of dolphins. Only one island. One reservation. This is one incredible hideout.', 'published', 'Four Seasons Maldives Private Island at Voavah Resort Maldives | Maldives Resorts | MTG', 'What would you do if you had a whole island to yourself? The answer is "anything" at the five-acre UNESCO refuge of Four Seasons Maldives Private Island in Voavah. Remove your barriers, broaden your horizons, retreat, explore, connect, or rejoice. Voavah offers you - and up to 21 guests - to dream with your eyes open, with your own 19-metre (62-foot) boat, dive centre, spa, Beach House, seven bedrooms, and resident pod of dolphins. Only one island. One reservation. This is one incredible hideout.', '{"overview_paragraphs":["What would you do if you had a whole island to yourself? The answer is \"anything\" at the five-acre UNESCO refuge of Four Seasons Maldives Private Island in Voavah. Remove your barriers, broaden your horizons, retreat, explore, connect, or rejoice. Voavah offers you - and up to 21 guests - to dream with your eyes open, with your own 19-metre (62-foot) boat, dive centre, spa, Beach House, seven bedrooms, and resident pod of dolphins. Only one island. One reservation. This is one incredible hideout.","Days at Voavah centre on the double-story Beach House and its nearby powder-white sands, pristine lagoon, and active coral, all of which are exceptional even by Maldives standards. Relax in the open-air lounge''s shade. Dive the clear seas. A moonlight dinner or pool party is a classy way to celebrate. Exercise in the gym. Relax at the Library. Allow the children to assist the cooks as you view the great blueness of your Biosphere territory.","Voavah''s isolated mid-ocean position, along with the option to travel by private jet to Velana or Maafaru International Airports and then continue by private seaplane, allows for anonymous access for anybody seeking to fly in and out without being detected. On-site privacy is maintained by 24-hour security and patrols, CCTV, and night-vision cameras.","What is it today? A floating breakfast in your pool, a tantalising tandoor lunch, and a BBQ on a sandbank? Or how about a morning picnic on the beach, hand-caught sashimi aboard your yacht, and a torchlit Bedouin beach banquet? Cocktails in the kitchen and a star-studded pool party? Wok masterpieces, wood-fired pizzas, or fine-dining bites? Alternatively, don''t think at all and let us surprise you.","After a day of resting on Voavah''s beautiful coastlines, indulge yourself to a tailored treatment in the serene settings of the Ocean of Consciousness - the island''s exclusive Spa. Through breath preparation, a salt-and-crystal scrub, a bath soak, an awakening massage, and a deeply immersive sound bath, our hallmark treatment utilises the limitless power of sound to link you to the layers of awakened wisdom both inside and around you.","There are no neighbours, no paparazzi, and no restrictions on what you may do at Voavah. Keep the music going all night and celebrate an important anniversary with a big-name artist. Make your own mini-Woodstock or Coachella on the beach, plan an unforgettable island-wide proposal trail, or transform the island into a wedding fantasia."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 540, 'CqbUr7mdR6w', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'four-seasons-maldives-private-island-at-voavah-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'four-seasons-maldives-private-island-at-voavah-resort-maldives'
  and l.node_type = 'location' and l.slug = 'voavah'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'four-seasons-maldives-private-island-at-voavah-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Villa', 540, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'four-seasons-maldives-private-island-at-voavah-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunset Pool Villa', 739, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'four-seasons-maldives-private-island-at-voavah-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Villa', 775, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'four-seasons-maldives-private-island-at-voavah-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Fun-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'fun-island-resort-spa-maldives', 'Fun Island Resort & Spa Maldives', 'This well-known resort may be described as exotic, desolate, and unspoilt. Fun Island is a fantastic combination of ''Fun in the Sun.'' The island''s biggest draw, however, is Fun Island''s massive lagoon, which provides ideal conditions for a variety of water sports, while the powder white beaches provide endless opportunities to enjoy the sun and sea in picturesque settings.', 'published', 'Fun Island Resort & Spa Maldives | Maldives Resorts | MTG', 'This well-known resort may be described as exotic, desolate, and unspoilt. Fun Island is a fantastic combination of ''Fun in the Sun.'' The island''s biggest draw, however, is Fun Island''s massive lagoon, which provides ideal conditions for a variety of water sports, while the powder white beaches provide endless opportunities to enjoy the sun and sea in picturesque settings.', '{"overview_paragraphs":["This well-known resort may be described as exotic, desolate, and unspoilt. Fun Island is a fantastic combination of ''Fun in the Sun.'' The island''s biggest draw, however, is Fun Island''s massive lagoon, which provides ideal conditions for a variety of water sports, while the powder white beaches provide endless opportunities to enjoy the sun and sea in picturesque settings.","Our Maldivian Beach Villas provide that laid-back island vibe. You can see your lush garden and the beach beyond without getting out of bed, and the blue sea is immediately behind you. The subtle changes in forms and tones of blue and green, as well as the apricot tone of the setting sun, provide lightness and freshness to this lovely 205-square-meter garden cottage. A large bathroom with tub and shower at the back contains an open-air space where you may stare at the stars while having a shower.","Fun Island Resort has 75 rooms and offers cheap accommodations with big decor and excellent views of the ocean or atolls. They also have plenty of seats and private toilets with hot showers and amenities.","Fun Island Resort is located on the south coast of Male'' Atoll, 37 kilometres from Velana International Airport. It takes around 45 minutes by speed boat to get to the resort and be met by the wonderful resort crew. It''s also worth noting that the island is just 700 m long and 168 m broad, so the amenities are easily accessible."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 300, '9Q9Kcl2V2CI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'fun-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'fun-island-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'bodufinolhu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'fun-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'fun-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- Furaveri
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'furaveri-maldives-island-resort', 'Furaveri Maldives Island Resort', 'We tuned in to the basic beauty of the surroundings, staying loyal to key ideals such as making the best of what we had. Furaveri Maldives is a five-star premium resort where the open ocean meets the lagoon and the warm sunset yellow of wonderful evenings by the beach lulls you to sleep in a tree-fortified hideaway. An island abounding in life, as seen by the white herons that can be found across the island, the vivid screwpine trees, the numerous turtles in our reef, and the gentle mantas that visit us on occasion.', 'published', 'Furaveri Maldives Island Resort | Maldives Resorts | MTG', 'We tuned in to the basic beauty of the surroundings, staying loyal to key ideals such as making the best of what we had. Furaveri Maldives is a five-star premium resort where the open ocean meets the lagoon and the warm sunset yellow of wonderful evenings by the beach lulls you to sleep in a tree-fortified hideaway. An island abounding in life, as seen by the white herons that can be found across the island, the vivid screwpine trees, the numerous turtles in our reef, and the gentle mantas that visit us on occasion.', '{"overview_paragraphs":["We tuned in to the basic beauty of the surroundings, staying loyal to key ideals such as making the best of what we had. Furaveri Maldives is a five-star premium resort where the open ocean meets the lagoon and the warm sunset yellow of wonderful evenings by the beach lulls you to sleep in a tree-fortified hideaway. An island abounding in life, as seen by the white herons that can be found across the island, the vivid screwpine trees, the numerous turtles in our reef, and the gentle mantas that visit us on occasion.","Our Beach Villas, perched along Furaveri''s secluded beachfront, appear to move more leisurely, the perfect fantasy of carefree island living. As you relax in the maximum luxury of your strange, hidden sanctuary, take in clear views of the hypnotic blues beyond. Barefoot luxury in its purest form.","Enjoy maximum seaside enjoyment at our magnificent Beach Pool Villas, which combine all of the wonders that the Maldives is famous for. These villas, located in front of Furaveri''s pure unspoilt beach, are the ideal choice for anyone looking to relax and soak in the island enchantment. What you have here is pure and simple bliss.","The view from our sleek and modern Water Villas is never the same twice, surrounded by ever-changing blue colours. Relax in an artistically crafted area, and when the ocean beckons, stroll down a few steps and slide into the lagoon directly from your sundeck. A delightful getaway in a wonderfully gorgeous environment.","We offer a variety of cosy options for your stay at Furaveri Maldives, from entry level Garden Villas to luxurious Ocean Pool Villas and Residences, all of which have been specifically designed to meet guests'' individual preferences and are set among lush vegetation and over water, on a sandy white beach, or settled above a sparkling turquoise lagoon.","Furaveri Maldives is a tropical 23-hectare coral island that is around 750m long and 400m broad. It is located in the unique Raa Atoll, some 151km north of the capital city, Malé. Furaveri is only a lovely 45-minute seaplane journey from the international airport. Domestic flights from adjacent Dharavandhoo and Ifuru airports take 20 minutes, followed by a 45-minute speed boat trip to Furaveri Maldives."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 450, 'qucF2L2aKvY', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'furaveri-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'furaveri-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'furaveri'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'furaveri-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 450, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'furaveri-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 600, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'furaveri-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 500, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'furaveri-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Fushifaru
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'fushifaru-maldives-island-resort', 'Fushifaru Maldives Island Resort', 'Fushifaru Maldives is your private paradise island. The resort is blissfully marooned in the midst of the Indian Ocean, surrounded by powder white sand beaches and brilliant turquoise waters, and provides exquisite amenities and complete seclusion.', 'published', 'Fushifaru Maldives Island Resort | Maldives Resorts | MTG', 'Fushifaru Maldives is your private paradise island. The resort is blissfully marooned in the midst of the Indian Ocean, surrounded by powder white sand beaches and brilliant turquoise waters, and provides exquisite amenities and complete seclusion.', '{"overview_paragraphs":["Fushifaru Maldives is your private paradise island. The resort is blissfully marooned in the midst of the Indian Ocean, surrounded by powder white sand beaches and brilliant turquoise waters, and provides exquisite amenities and complete seclusion.","These villas are positioned on the island''s eastern side, facing the sunrise, and have a view of the \"Maakandu,\" the huge Indian Ocean.","Facing the blue lagoon, the Pool Beach Villas look out towards ''Maakandu'' - the wild open Indian Ocean. Sip cocktails from your private deck or enjoy.","The thatch-roof water villas are perched on top of timber stilts and include a romantic outdoor Jacuzzi with views of the pristine lagoon. Take a swim in.","Fushifaru Maldives has 49 Beach and Water Villas that will highlight your experience of nature while enveloping you in its comfortable interiors. These sanctuaries are built on land and on water, with views of the \"Maakandu,\" the wild open sea, the \"Etherevari,\" the peaceful lagoon, and the \"Kandu-olhi,\" the active channel.","Fushifaru Maldives is an amazing tiny island located on the far north east boundary of Lhaviyani Atoll, wedged between a national Marine Protected Area and three of the Maldives'' most renowned diving spots. Velana International Airport is approximately a 35-minute spectacular seaplane trip away."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 550, 'Lr0Y0xhbVsY', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'fushifaru-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'fushifaru-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'fushifaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'fushifaru-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Villa', 550, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'fushifaru-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'fushifaru-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Jacuzzi Water Villa', 900, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'fushifaru-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Gangehi-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'gangehi-island-resort-maldives', 'Gangehi Island Resort Maldives', 'Discover a beautiful and serene island with rich flora and white sandy beaches, a spectacular and one-of-a-kind location on the planet. The island is a jewel of white sand and coconut trees surrounded by a crystal clear water, protected by its coral reef. Enjoy our gorgeous Overwater Villas, dine at our two restaurants, or unwind in the Ginger Spa. Gangehi Island Resort is the ideal destination for a fantasy Maldives vacation.', 'published', 'Gangehi Island Resort Maldives | Maldives Resorts | MTG', 'Discover a beautiful and serene island with rich flora and white sandy beaches, a spectacular and one-of-a-kind location on the planet. The island is a jewel of white sand and coconut trees surrounded by a crystal clear water, protected by its coral reef. Enjoy our gorgeous Overwater Villas, dine at our two restaurants, or unwind in the Ginger Spa. Gangehi Island Resort is the ideal destination for a fantasy Maldives vacation.', '{"overview_paragraphs":["Discover a beautiful and serene island with rich flora and white sandy beaches, a spectacular and one-of-a-kind location on the planet. The island is a jewel of white sand and coconut trees surrounded by a crystal clear water, protected by its coral reef. Enjoy our gorgeous Overwater Villas, dine at our two restaurants, or unwind in the Ginger Spa. Gangehi Island Resort is the ideal destination for a fantasy Maldives vacation.","Our cosy and useful Club Rooms are designed with teak wood and provide a tranquil view of the garden. Every room has its own private balcony where you may unwind.","Our Overwater Villas in the Maldives give you the impression of waking up every day on the sea. All of the apartments are warmly decorated with teak wood and provide a fantastic view of the sunset and the magnificent lagoon. They consist of one spacious room and a stone bathroom."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 220, 'm3ixdDDUZU4', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'gangehi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'gangehi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'gangehi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'gangehi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Club Room', 220, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'gangehi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Villa', 500, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'gangehi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Grand-Park-Kodhipparu
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'grand-park-kodhipparu-maldives-island-resort', 'Grand Park Kodhipparu Maldives Island Resort', 'Welcome to Grand Park Kodhipparu, Maldives, the first luxury resort of Park Hotel Group and your unique address in the stunning Maldives. We invite you to explore your paradise on an island with a variety of gorgeous villas, pristine beaches, and stunning scenery, nestled in North Male Atoll, a simple 20-minute speedboat trip from Velana International Airport, Malé, Maldives. The resort, designed by Hirsch Bedner Associates, has elegant architecture and a modern façade with Maldives'' traditional influence of wood and rattan, innovative rustic charm, and an appealing serene ambiance.', 'published', 'Grand Park Kodhipparu Maldives Island Resort | Maldives Resorts | MTG', 'Welcome to Grand Park Kodhipparu, Maldives, the first luxury resort of Park Hotel Group and your unique address in the stunning Maldives. We invite you to explore your paradise on an island with a variety of gorgeous villas, pristine beaches, and stunning scenery, nestled in North Male Atoll, a simple 20-minute speedboat trip from Velana International Airport, Malé, Maldives. The resort, designed by Hirsch Bedner Associates, has elegant architecture and a modern façade with Maldives'' traditional influence of wood and rattan, innovative rustic charm, and an appealing serene ambiance.', '{"overview_paragraphs":["Welcome to Grand Park Kodhipparu, Maldives, the first luxury resort of Park Hotel Group and your unique address in the stunning Maldives. We invite you to explore your paradise on an island with a variety of gorgeous villas, pristine beaches, and stunning scenery, nestled in North Male Atoll, a simple 20-minute speedboat trip from Velana International Airport, Malé, Maldives. The resort, designed by Hirsch Bedner Associates, has elegant architecture and a modern façade with Maldives'' traditional influence of wood and rattan, innovative rustic charm, and an appealing serene ambiance.","With its assortment of beach and water villas, award-winning dining venues, recreational areas, and an award-winning overwater spa, the exquisite one-island-one-resort location invites you into an oasis of peace. Grand Park Kodhipparu, Maldives, is ideal for any traveller, whether a couple or honeymooners, since it is surrounded by thrilling underwater adventures of renowned snorkelling and diving locations surrounding the island. Families may also enjoy their stay on the island because the island has family-friendly facilities that provide a variety of children''s activities.","The beach home in Maldives is surrounded by lush foliage and has a private plunge pool overlooking the horizon. Listen to the waves crashing on the coast or take a walk on the beach to feel the white powdery sand beneath your feet; the beach is only a few steps away from your terrace.","Wake up to a gorgeous bright day in one of the greatest water villas in Maldives by Grand Park Kodhipparu, Maldives, which offers unrivalled views of the serene blue ocean and sky. The property also has a large bathroom, indoor and outdoor showers, and direct access to the seaside through an attractive stairway.","Our exquisite one-island-one-resort location features 120 Maldives villas with stunning vistas and opulent in-room amenities. All of our beach, ocean, and lagoon villas have stunning tropical views and private pools, and are designed with a contemporary façade with Maldives'' traditional influence. Relax with the calming sounds of the waves while sitting on your balcony or resting in the plunge pool, feet from the beach - ready for you to discover the colourful marine life.","If you like the sand and sea, the beach pool villas are surrounded by lush flora and are only steps from from the beach while staying near to the resort''s amenities. Our Grand Residences provide a perfect holiday home-away-from-home with two bedrooms, a living room, an infinity pool with spectacular ocean views, and an outside private dining space."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 780, 'fcqLbMY_V18', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'grand-park-kodhipparu-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'grand-park-kodhipparu-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'kodhipparu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'grand-park-kodhipparu-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 880, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'grand-park-kodhipparu-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ocean Water Villa', 780, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'grand-park-kodhipparu-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Hard-Rock-Hotel
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'hard-rock-hotel-maldives-island-resort', 'Hard Rock Hotel Maldives Island Resort', 'Invite the entire team, plus a few extras, to our five-star beach resort in the Indian Ocean, Hard Rock Hotel Maldives. Music is our forte, and we''ve blended it into our underwater melodies at Pool Bar, Hard Rock Cafe Maldives memorabilia, and Crosley turntable luxury. Load your belongings onto the speedboat, set sail for Emboodhoo Lagoon, and meet us at the Arrival Pavilion 20 minutes later for our Sundown Ritual. We''ll see you later.', 'published', 'Hard Rock Hotel Maldives Island Resort | Maldives Resorts | MTG', 'Invite the entire team, plus a few extras, to our five-star beach resort in the Indian Ocean, Hard Rock Hotel Maldives. Music is our forte, and we''ve blended it into our underwater melodies at Pool Bar, Hard Rock Cafe Maldives memorabilia, and Crosley turntable luxury. Load your belongings onto the speedboat, set sail for Emboodhoo Lagoon, and meet us at the Arrival Pavilion 20 minutes later for our Sundown Ritual. We''ll see you later.', '{"overview_paragraphs":["Invite the entire team, plus a few extras, to our five-star beach resort in the Indian Ocean, Hard Rock Hotel Maldives. Music is our forte, and we''ve blended it into our underwater melodies at Pool Bar, Hard Rock Cafe Maldives memorabilia, and Crosley turntable luxury. Load your belongings onto the speedboat, set sail for Emboodhoo Lagoon, and meet us at the Arrival Pavilion 20 minutes later for our Sundown Ritual. We''ll see you later.","The Silver Beach Studio at Hard Rock Hotel Maldives features a private terrace with direct beach access, 1 king bed or 2 double beds, sun loungers, ocean views, indoor and outdoor bathrooms, and distinctive amenities ideal for your island holiday.","Our Platinum Overwater Villa with 1 king bed or 2 twin beds has a million reasons to adore it. Relax on sun loungers on your private patio and take in the vista. Enjoy immediate access to the azure blue lagoon and outdoor life on the lounge net above the water.","Stay at Hard Rock and you''ll discover more than simply a place to unwind and relax. They have entirely altered the ordinary visitor experience into something spectacular, with breathtaking vistas and renowned facilities to elevate holidays to new heights. Their 178 guest rooms, Suites, Villas, and Overwater Villas are inspired by local culture and include tropical architecture combined with modern style. They offer a hotel or suite to accommodate anyone''s requirements and wishes, whether they are travelling with family, that particular someone, or friends.","Hard Rock Hotel Maldives is located in North Male'' Atoll within Emboodhoo Lagoon, the Maldives'' first integrated resort destination, and is only a breathtaking 15-minute boat ride from Velana International Airport.","Our resort dining is a cut above the rest, always amplified and never toned down. Visit our swim-up Pool Bar for specialty beers, cocktails, and other mood-setting beverages. Stop by Hard Rock Cafe ® Maldives for burgers as tall as our vinyl collection. Kick up your heels or tap your toes to the pulse of Balearic music at The Beach Club, the renowned club located at the opposite end of our 500-metre footbridge. Emboodhoo Lagoon is home to award-winning eateries."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 600, 'aglVRgHZars', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'hard-rock-hotel-maldives-island-resort'
on conflict (id) do nothing;
