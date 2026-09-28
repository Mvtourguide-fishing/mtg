-- Part 12 of 14 - run this in the Supabase SQL Editor AFTER the previous parts.
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

-- Vilamendhoo-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'vilamendhoo-island-resort-spa-maldives', 'Vilamendhoo Island Resort & Spa Maldives', 'Your vacation journey begins at Vilamendhoo Island Resort & Spa, located in the South Ari Atoll and following the Maldives'' famed ''One Island, One Resort'' idea. This island is around 55 acres in size, 900 metres long by 250 metres broad, and is encircled by a stunning house reef a short swim away from the large sandy beach. Vilamendhoo is the ultimate diving and snorkelling adventure.', 'published', 'Vilamendhoo Island Resort & Spa Maldives | Maldives Resorts | MTG', 'Your vacation journey begins at Vilamendhoo Island Resort & Spa, located in the South Ari Atoll and following the Maldives'' famed ''One Island, One Resort'' idea. This island is around 55 acres in size, 900 metres long by 250 metres broad, and is encircled by a stunning house reef a short swim away from the large sandy beach. Vilamendhoo is the ultimate diving and snorkelling adventure.', '{"overview_paragraphs":["Your vacation journey begins at Vilamendhoo Island Resort & Spa, located in the South Ari Atoll and following the Maldives'' famed ''One Island, One Resort'' idea. This island is around 55 acres in size, 900 metres long by 250 metres broad, and is encircled by a stunning house reef a short swim away from the large sandy beach. Vilamendhoo is the ultimate diving and snorkelling adventure.","Garden Rooms are situated in the natural island gardens, each with its own privacy screen. This tropical lodging provides leisure and comfort in between fun-filled island experiences. These accommodations provide convenient access to the island''s services, including the main restaurant and bar.","Extend your love of the sea to your vacation living area by booking the Jacuzzi Water Villa. The over-water villas in the Maldives are designed for adventure seekers, romance, and water enthusiasts, and have a private sundeck with stairs going into the sea. The Jacuzzi Water Villas at Vilamendhoo are only available to visitors over the age of 18.","The island is divided into two sections: one for adults exclusively (including an Overwater Villa) and one for families. Beach Villas with additional beds are offered for small families with young children, as well as exclusive and romantic Water Front Villas for couples seeking privacy. All villas are outfitted with the most up-to-date conveniences and are divided by a screen to offer optimum seclusion.","This snorkelling and diving paradise is only a 25-minute seaplane ride away. The Vilamendhoo Island Resort is surrounded by a gorgeous lagoon, an outstanding house reef, and extensive lengths of immaculate dunes, making it an ideal position to see the sought whale sharks that migrate through the Maldives.","Before embarking on your travels, or after a day of fun on the island, stop for a bite to eat or a refreshing drink at any of the island''s restaurants and pubs. Vilamendhoo provides one-of-a-kind dining experiences in the Maldives, with a delectable selection of regional and international cuisines. The two buffet restaurants, one family-friendly and one for adults-only, contribute to the island''s laid-back atmosphere. The restaurants are open-air with sand flooring, reflecting Maldivian customs and offering a relaxed dining experience. Enjoy à la carte eating experiences, whether on the lake at Asian Wok or on the beach at Hot Rock. Reserve a table for a private al fresco supper on the beach for a totally unique and romantic experience."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 400, 'vBYLNZEdaYI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'vilamendhoo-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'vilamendhoo-island-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'vilamendhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'vilamendhoo-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Garden Villa', 400, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'vilamendhoo-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Jacuzzi Water Villa', 792, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'vilamendhoo-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- Waldorf-Astoria
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'waldorf-astoria-maldives-ithaafushi-island-resort', 'Waldorf Astoria Maldives Ithaafushi Island Resort', 'The Waldorf Astoria Maldives Ithaafushi resort is a 45-minute boat ride from Velana International Airport, nestled among beautiful dunes and crystal blue seas. The resort has 11 acclaimed dining locations, including Michelin-starred chef Dave Pynt''s Zuma Maldives and Terra, the only private hand-crafted bamboo dining pods in the Maldives, a world-class spa retreat, the only water wellness centre of its type in the Maldives, and an exclusive private island. The Waldorf Astoria Maldives Ithaafushi offers 119 beach, reef, and overwater villas with private pools, including a private island, as well as world-class facilities for a wonderful visit. Ithaafushi - The Private Island is the largest Maldivian private island in the Indian Ocean, spanning 32,000 square metres and accommodating up to 24 guests across two elegantly designed villas and one four-bedroom residence, ideal for bonding with loved ones or celebrating life''s significant milestones with close friends.', 'published', 'Waldorf Astoria Maldives Ithaafushi Island Resort | Maldives Resorts | MTG', 'The Waldorf Astoria Maldives Ithaafushi resort is a 45-minute boat ride from Velana International Airport, nestled among beautiful dunes and crystal blue seas. The resort has 11 acclaimed dining locations, including Michelin-starred chef Dave Pynt''s Zuma Maldives and Terra, the only private hand-crafted bamboo dining pods in the Maldives, a world-class spa retreat, the only water wellness centre of its type in the Maldives, and an exclusive private island. The Waldorf Astoria Maldives Ithaafushi offers 119 beach, reef, and overwater villas with private pools, including a private island, as well as world-class facilities for a wonderful visit. Ithaafushi - The Private Island is the largest Maldivian private island in the Indian Ocean, spanning 32,000 square metres and accommodating up to 24 guests across two elegantly designed villas and one four-bedroom residence, ideal for bonding with loved ones or celebrating life''s significant milestones with close friends.', '{"overview_paragraphs":["The Waldorf Astoria Maldives Ithaafushi resort is a 45-minute boat ride from Velana International Airport, nestled among beautiful dunes and crystal blue seas. The resort has 11 acclaimed dining locations, including Michelin-starred chef Dave Pynt''s Zuma Maldives and Terra, the only private hand-crafted bamboo dining pods in the Maldives, a world-class spa retreat, the only water wellness centre of its type in the Maldives, and an exclusive private island. The Waldorf Astoria Maldives Ithaafushi offers 119 beach, reef, and overwater villas with private pools, including a private island, as well as world-class facilities for a wonderful visit. Ithaafushi - The Private Island is the largest Maldivian private island in the Indian Ocean, spanning 32,000 square metres and accommodating up to 24 guests across two elegantly designed villas and one four-bedroom residence, ideal for bonding with loved ones or celebrating life''s significant milestones with close friends.","This contemporary property has enough interior living, eating, and sleeping space. Relax on a daybed or hammock by the pool, surrounded by swaying palm palms.","These overwater homes provide breathtaking ocean views through floor-to-ceiling windows. There is space for both indoor and outdoor life.","There are 119 villas spread out over three private islands. Choose from one, two, or three-bedroom villas, each with its own private pool, swing daybeds, dining gazebos, and in-water couches, and all with unobstructed views of the Indian Ocean.","The magnificent Waldorf Astoria Maldives Ithaafushi is nestled among beautiful dunes and crystal blue lagoons, about 45 minutes by boat from Malé International Airport.","Discover a unique dining experience in one of 11 strategically located restaurants and bars, or just dine on your villa''s own terrace with a tailor-made personalised menu."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, null, 'gXK48Tb4Pic', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'waldorf-astoria-maldives-ithaafushi-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'waldorf-astoria-maldives-ithaafushi-island-resort'
  and l.node_type = 'location' and l.slug = 'ithaafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'waldorf-astoria-maldives-ithaafushi-island-resort'
on conflict (id) do nothing;

-- Westin-Miriandhoo
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'the-westin-maldives-miriandhoo-resort', 'The Westin Maldives Miriandhoo Resort', 'The Westin Maldives Miriandhoo Resort promises an unforgettable experience. Our lovely family-friendly resort offers an unparalleled environment for your Maldives visit, beautifully positioned on the ocean in the UNESCO Biosphere Reserve in Baa Atoll, surrounded by the Indian Ocean. Your luxury journey begins the moment you arrive at our resort, whether by seaplane or boat. Return to your isolated apartment or villa for uninterrupted ocean views, a private deck, and, in select accommodations, a private pool. We encourage you to taste exquisite eating in our restaurants, relax poolside or on the beach, indulge at our wellness spa, play tennis, or explore the resort grounds when you are ready to leave your paradise. Our skilled crew is waiting to make your stay on Baa Atoll great in every way, whether you are celebrating a special family event or spending time with a loved one. Make unforgettable experiences at The Westin Maldives Miriandhoo Resort.', 'published', 'The Westin Maldives Miriandhoo Resort | Maldives Resorts | MTG', 'The Westin Maldives Miriandhoo Resort promises an unforgettable experience. Our lovely family-friendly resort offers an unparalleled environment for your Maldives visit, beautifully positioned on the ocean in the UNESCO Biosphere Reserve in Baa Atoll, surrounded by the Indian Ocean. Your luxury journey begins the moment you arrive at our resort, whether by seaplane or boat. Return to your isolated apartment or villa for uninterrupted ocean views, a private deck, and, in select accommodations, a private pool. We encourage you to taste exquisite eating in our restaurants, relax poolside or on the beach, indulge at our wellness spa, play tennis, or explore the resort grounds when you are ready to leave your paradise. Our skilled crew is waiting to make your stay on Baa Atoll great in every way, whether you are celebrating a special family event or spending time with a loved one. Make unforgettable experiences at The Westin Maldives Miriandhoo Resort.', '{"overview_paragraphs":["The Westin Maldives Miriandhoo Resort promises an unforgettable experience. Our lovely family-friendly resort offers an unparalleled environment for your Maldives visit, beautifully positioned on the ocean in the UNESCO Biosphere Reserve in Baa Atoll, surrounded by the Indian Ocean. Your luxury journey begins the moment you arrive at our resort, whether by seaplane or boat. Return to your isolated apartment or villa for uninterrupted ocean views, a private deck, and, in select accommodations, a private pool. We encourage you to taste exquisite eating in our restaurants, relax poolside or on the beach, indulge at our wellness spa, play tennis, or explore the resort grounds when you are ready to leave your paradise. Our skilled crew is waiting to make your stay on Baa Atoll great in every way, whether you are celebrating a special family event or spending time with a loved one. Make unforgettable experiences at The Westin Maldives Miriandhoo Resort.","Our beach villas, located along the palm-fringed shoreline with direct beach access, gaze out over the huge waves of the Indian Ocean, embodying subtle style and constructed with exquisite open-plan living in mind. The Westin Maldives Miriandhoo Resort Heavenly Bath® is more than just a bathroom; it offers a rejuvenating bathing experience for body and soul, with a separate bathtub and rain-forest shower. The Island Villas are up to 140 square metres in size and have a private pool and sun terrace.","There are 41 stunning on-island and 29 over-sea homes in six categories, ranging from a one-bedroom pool villa to a two-bedroom, three-bathroom garden property with a kitchenette. Most feature pools, and all offer ocean vistas, huge ''Heavenly'' mattresses, outdoor rain showers, original artwork, and high-quality facilities. The overwater villas are among the most spacious in Baa Atoll.","The Westin Maldives Miriandhoo Resort is located 112 kilometres north of Velana International Airport on an 11-acre island in Baa Atoll, Maldives'' first and only UNESCO Biosphere Reserve. The island is roughly 30 minutes by sea plane and 20 minutes by domestic aircraft to Dharavandhoo Airport in Baa Atoll, followed by a 10-minute speed boat trip to the resort.","During your stay at the Westin Maldives Miriandhoo Resort, you may choose from four distinct dining selections. The three restaurants and elevated bar provide unforgettable gastronomic experiences in stunning settings. Cuisines range from The Pearl''s exquisite Japanese menu with a seafood focus to Island Kitchen''s healthful, cosmopolitan meals and all-day eating. Hawker, a colourful bar and restaurant, serves real Asian street cuisine in a bustling market-place setting, while Sunset Bar provides a relaxing conclusion to the day with tapas and seaside views.","The picturesque resort also has the Heavenly Spa by WestinTM, Westin''s own branded spa concept. The Spa also incorporates the most recent aesthetic technologies and has a big treatment suite for two with a Jacuzzi and panoramic ocean views. The Spa area''s design conveys a private and calm ambience. The treatments available at The Heavenly Spa by WestinTM represent the resort''s dedication to wellbeing, allowing visitors to relax and revitalise via a personalised sensory experience. An appointment is necessary."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1080, 'Z67wPR8r8P8', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'the-westin-maldives-miriandhoo-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'the-westin-maldives-miriandhoo-resort'
  and l.node_type = 'location' and l.slug = 'miriandhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'the-westin-maldives-miriandhoo-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1080, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'the-westin-maldives-miriandhoo-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Villa', 1200, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'the-westin-maldives-miriandhoo-resort'
on conflict (accommodation_id, name) do nothing;

-- You-and-Me
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'you-me-by-cocoon-maldives-island-resort', 'You & Me by Cocoon Maldives Island Resort', 'You & Me is a quiet, rustic, and romantic island located in a stunning, unspoiled area of the Maldives. You & Me is the place to unwind, snuggle up, and enjoy some quality ''us time'' away from the worries of everyday life. You & Me is a brand new 5-star resort in Raa atoll, northern Maldives, about 20 minutes by speedboat from Ifuru domestic airport or a breathtaking 45-minute seaplane flight from Male'' international airport. The adults-only island is aimed towards couples, honeymooners, and friends looking for a peaceful, relaxing escape away from other hotels.', 'published', 'You & Me by Cocoon Maldives Island Resort | Maldives Resorts | MTG', 'You & Me is a quiet, rustic, and romantic island located in a stunning, unspoiled area of the Maldives. You & Me is the place to unwind, snuggle up, and enjoy some quality ''us time'' away from the worries of everyday life. You & Me is a brand new 5-star resort in Raa atoll, northern Maldives, about 20 minutes by speedboat from Ifuru domestic airport or a breathtaking 45-minute seaplane flight from Male'' international airport. The adults-only island is aimed towards couples, honeymooners, and friends looking for a peaceful, relaxing escape away from other hotels.', '{"overview_paragraphs":["You & Me is a quiet, rustic, and romantic island located in a stunning, unspoiled area of the Maldives. You & Me is the place to unwind, snuggle up, and enjoy some quality ''us time'' away from the worries of everyday life. You & Me is a brand new 5-star resort in Raa atoll, northern Maldives, about 20 minutes by speedboat from Ifuru domestic airport or a breathtaking 45-minute seaplane flight from Male'' international airport. The adults-only island is aimed towards couples, honeymooners, and friends looking for a peaceful, relaxing escape away from other hotels.","These big rooms on the beach have a magnificent and rustic vibe, with a lovely bathroom complete with a couple''s bathtub and rain shower, a king size bed overlooking the beach, a sofa, balcony, and private pool with private beach and sea views.","These rustic water villas have unrivalled sunset views and have polished hardwood flooring, a king-sized bed facing the ocean, a comfy sofa, a rain shower, and a seaside porch with lagoon views.","You & Me by Cocoon features 109 rooms, including 99 overlooking the ocean and 10 on the beach. You & Me by Cocoon is the place to unwind, snuggle up, and enjoy some quality ''us time'' away from the worries of everyday life.","You & Me by Cocoon is in Raa atoll, northern Maldives, about 20 minutes by speedboat from Ifuru domestic airport or a breathtaking 45-minute seaplane flight from Velana international airport.","You & Me''s standout feature is a totally submerged, underwater restaurant that provides customers with a glimpse of the Maldives'' stunning marine environment as they enjoy a great meal."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 950, 'ncv136ZRUx0', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'you-me-by-cocoon-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'you-me-by-cocoon-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'uthurumafaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'you-me-by-cocoon-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Suite', 950, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'you-me-by-cocoon-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Dolphin Villa', 950, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'you-me-by-cocoon-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- adaaran-club-rannalhi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'adaaran-club-rannalhi-island-resort-maldives', 'Adaaran Club Rannalhi Island Resort Maldives', 'Adaaran Club Rannalhi is one of the greatest hotels in Maldives, located at the point of the South Male atoll in the Maldives, an unique collection of islands. During your stay at our pleasant Maldives hotel, bask in the golden sun and romp on the soft sands while experiencing warm Maldivian hospitality and seeing the rich tropical marvels of a dynamic island nation.', 'published', 'Adaaran Club Rannalhi Island Resort Maldives | Maldives Resorts | MTG', 'Adaaran Club Rannalhi is one of the greatest hotels in Maldives, located at the point of the South Male atoll in the Maldives, an unique collection of islands. During your stay at our pleasant Maldives hotel, bask in the golden sun and romp on the soft sands while experiencing warm Maldivian hospitality and seeing the rich tropical marvels of a dynamic island nation.', '{"overview_paragraphs":["Adaaran Club Rannalhi is one of the greatest hotels in Maldives, located at the point of the South Male atoll in the Maldives, an unique collection of islands. During your stay at our pleasant Maldives hotel, bask in the golden sun and romp on the soft sands while experiencing warm Maldivian hospitality and seeing the rich tropical marvels of a dynamic island nation.","Adaaran Club Rannalhi is a charming Maldives Island resort located on the beautiful dunes of this tropical paradise. Adaaran Club Rannalhi is just 34 kilometers from Male International Airport and may be accessed through a 45-minute speedboat journey over breathtaking blue seas.","The 96 standard rooms at Adaaran Club Rannalhi provide excellent Maldives accommodation with all modern comforts while complimenting the natural surroundings and contributing to the mood. The Adaaran Club Rannalhi''s 34 large and private Water Bungalows offer breathtaking ocean views and access to the changing scenery as the day fades to night."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 302, 'JnsS3oIjDiM', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'adaaran-club-rannalhi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'adaaran-club-rannalhi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'rannalhi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'adaaran-club-rannalhi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Standard Room', 302, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'adaaran-club-rannalhi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Bungalow', 525, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'adaaran-club-rannalhi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- anantara-dhigu
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'anantara-dhigu-island-resort-maldives', 'Anantara Dhigu Island Resort Maldives', 'Anantara Dhigu Maldives is a tropical haven in the Indian Ocean. Indulge in barefoot sophistication in a tropical haven that caters to the entire family. This is a great place to build an unforgettable vacation, with a range of luxurious accommodations offering breathtaking views and private pools. For easy fun, try a variety of cuisines, relax with soothing spa treatments, and explore the nearby lagoon.', 'published', 'Anantara Dhigu Island Resort Maldives | Maldives Resorts | MTG', 'Anantara Dhigu Maldives is a tropical haven in the Indian Ocean. Indulge in barefoot sophistication in a tropical haven that caters to the entire family. This is a great place to build an unforgettable vacation, with a range of luxurious accommodations offering breathtaking views and private pools. For easy fun, try a variety of cuisines, relax with soothing spa treatments, and explore the nearby lagoon.', '{"overview_paragraphs":["Anantara Dhigu Maldives is a tropical haven in the Indian Ocean. Indulge in barefoot sophistication in a tropical haven that caters to the entire family. This is a great place to build an unforgettable vacation, with a range of luxurious accommodations offering breathtaking views and private pools. For easy fun, try a variety of cuisines, relax with soothing spa treatments, and explore the nearby lagoon.","The 110 villas and suites at Anantara Maldives offer a variety of room sizes, with some perched above the water and others nestled on unspoiled sands. Choose from sunrise or sunset views, or a villa with your own private pool."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 540, 'CqbUr7mdR6w', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'anantara-dhigu-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'anantara-dhigu-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'dhigufinolhu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'anantara-dhigu-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Villa', 540, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'anantara-dhigu-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunset Pool Villa', 739, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'anantara-dhigu-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Two bedroom Family Villa', 1426, 'USD', 'Double', null, 2
from nodes where node_type = 'accommodation' and slug = 'anantara-dhigu-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Villa', 775, 'USD', 'King', 3, 3
from nodes where node_type = 'accommodation' and slug = 'anantara-dhigu-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- centara-rasfushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'centara-rasfushi-island-resort-maldives', 'Centara Rasfushi Island Resort Maldives', 'Centara Ras Fushi Resort & Spa is an adult-only resort that provides a relaxing and inspiring vacation experience, as well as ample opportunities to indulge, play, and rejuvenate at the excellent well-being area and numerous restaurants and bars. These 140 luxury villas of Centara Ras Fushi Resort & Spa are built as adults-only accommodation and fit harmoniously with the island''s green interior and white powdery beaches. Using flowing and natural architectural forms and a minimalist decor, these villas are designed to immerse you in total serenity and enjoy breathtaking ocean vistas. Only two adults are allowed in each villa.', 'published', 'Centara Rasfushi Island Resort Maldives | Maldives Resorts | MTG', 'Centara Ras Fushi Resort & Spa is an adult-only resort that provides a relaxing and inspiring vacation experience, as well as ample opportunities to indulge, play, and rejuvenate at the excellent well-being area and numerous restaurants and bars. These 140 luxury villas of Centara Ras Fushi Resort & Spa are built as adults-only accommodation and fit harmoniously with the island''s green interior and white powdery beaches. Using flowing and natural architectural forms and a minimalist decor, these villas are designed to immerse you in total serenity and enjoy breathtaking ocean vistas. Only two adults are allowed in each villa.', '{"overview_paragraphs":["Centara Ras Fushi Resort & Spa is an adult-only resort that provides a relaxing and inspiring vacation experience, as well as ample opportunities to indulge, play, and rejuvenate at the excellent well-being area and numerous restaurants and bars. These 140 luxury villas of Centara Ras Fushi Resort & Spa are built as adults-only accommodation and fit harmoniously with the island''s green interior and white powdery beaches. Using flowing and natural architectural forms and a minimalist decor, these villas are designed to immerse you in total serenity and enjoy breathtaking ocean vistas. Only two adults are allowed in each villa."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 208, 'F1a21IInpQ4', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'centara-rasfushi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'centara-rasfushi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'giraavaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'centara-rasfushi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Oceanfront Beach Villa', 208, 'USD', 'King', 2, 0
from nodes where node_type = 'accommodation' and slug = 'centara-rasfushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Oceanfront Beach Villa', 292, 'USD', 'Double', null, 1
from nodes where node_type = 'accommodation' and slug = 'centara-rasfushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Water Villa', 364, 'USD', 'Double', null, 2
from nodes where node_type = 'accommodation' and slug = 'centara-rasfushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- embudu-village
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'embudu-village-island-maldives', 'Embudu Village Island Maldives', 'Embudu Village has remained pure and natural since its inception as one of the Maldives'' first resorts. When you step foot on Embudu Village, you will be fully relaxed, surrounded by the calmness of the turquoise waters and the sound of the waves on the endless beaches.', 'published', 'Embudu Village Island Maldives | Maldives Resorts | MTG', 'Embudu Village has remained pure and natural since its inception as one of the Maldives'' first resorts. When you step foot on Embudu Village, you will be fully relaxed, surrounded by the calmness of the turquoise waters and the sound of the waves on the endless beaches.', '{"overview_paragraphs":["Embudu Village has remained pure and natural since its inception as one of the Maldives'' first resorts. When you step foot on Embudu Village, you will be fully relaxed, surrounded by the calmness of the turquoise waters and the sound of the waves on the endless beaches.","Embudu Village is a small island off the coast of Male'' Atoll, about a 30-minute speedboat ride from Velana International Airport. As a result, it is readily accessible and a common destination for most visitors. Embudu Village''s villas are all close to the beach and surrounded by palm fronds and tropical plants, giving each room a sense of seclusion and privacy."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 179, 'pGzhOylYfog', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'embudu-village-island-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'embudu-village-island-maldives'
  and l.node_type = 'location' and l.slug = 'embudu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'embudu-village-island-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Room', 179, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'embudu-village-island-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Room', 259, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'embudu-village-island-maldives'
on conflict (accommodation_id, name) do nothing;

-- fihalhohi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'fihaalhohi-island-resort-maldives', 'Fihaalhohi Island Resort Maldives', 'Come to a spot where a breathtaking view of the Indian Ocean and the island''s natural tropical elegance are a daily backdrop. The Maldives'' Fihalhohi Island Resort is an utter paradise island escape. A truly idyllic location where the mind and body are rejuvenated and time stands still. The island''s ideal warm weather makes it ideal for water sports and excursions. A beautiful house reef surrounds the beach, teeming with rich aquatic life that can be enjoyed when diving. Huvandhumaa spa therapists have a variety of Balinese and foreign therapies in a lush tropical environment.', 'published', 'Fihaalhohi Island Resort Maldives | Maldives Resorts | MTG', 'Come to a spot where a breathtaking view of the Indian Ocean and the island''s natural tropical elegance are a daily backdrop. The Maldives'' Fihalhohi Island Resort is an utter paradise island escape. A truly idyllic location where the mind and body are rejuvenated and time stands still. The island''s ideal warm weather makes it ideal for water sports and excursions. A beautiful house reef surrounds the beach, teeming with rich aquatic life that can be enjoyed when diving. Huvandhumaa spa therapists have a variety of Balinese and foreign therapies in a lush tropical environment.', '{"overview_paragraphs":["Come to a spot where a breathtaking view of the Indian Ocean and the island''s natural tropical elegance are a daily backdrop. The Maldives'' Fihalhohi Island Resort is an utter paradise island escape. A truly idyllic location where the mind and body are rejuvenated and time stands still. The island''s ideal warm weather makes it ideal for water sports and excursions. A beautiful house reef surrounds the beach, teeming with rich aquatic life that can be enjoyed when diving. Huvandhumaa spa therapists have a variety of Balinese and foreign therapies in a lush tropical environment.","There are 138 beachfront rooms and 12 well-appointed water villas available for your stay on the island. A total of 150 rooms are available. Both rooms have a hair dryer, Bath & Beach Towels, room safe, Mini Bar, Individually Controlled Air-conditioning and Fan, telephones, and a hair dryer."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 141, 'pgTJIQbrvuw', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'fihaalhohi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'fihaalhohi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'fihalhohi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'fihaalhohi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 141, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'fihaalhohi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Room', 308, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'fihaalhohi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- huvafenfushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'huvafen-fushi-island-resort-maldives', 'Huvafen Fushi Island Resort Maldives', 'Huvafen Fushi Maldives is a naturalist''s paradise set inside its own lagoon, where the breathtaking scenery, both above and below the waterline, is an attraction in and of itself. Their ocean bungalow''s glass floor captures a perfect vision of the turquoise waters and features extravagant and spacious villas. They have accommodation on the water as well as a designer yacht with modern and opulent amenities. Cruise about, savor the finest food prepared by international cooks, and relax with spa treatments. Huvafen Fushi Maldives is a stunning, luxurious, and expensive Maldivian property that is one of the best options in the Maldives.', 'published', 'Huvafen Fushi Island Resort Maldives | Maldives Resorts | MTG', 'Huvafen Fushi Maldives is a naturalist''s paradise set inside its own lagoon, where the breathtaking scenery, both above and below the waterline, is an attraction in and of itself. Their ocean bungalow''s glass floor captures a perfect vision of the turquoise waters and features extravagant and spacious villas. They have accommodation on the water as well as a designer yacht with modern and opulent amenities. Cruise about, savor the finest food prepared by international cooks, and relax with spa treatments. Huvafen Fushi Maldives is a stunning, luxurious, and expensive Maldivian property that is one of the best options in the Maldives.', '{"overview_paragraphs":["Huvafen Fushi Maldives is a naturalist''s paradise set inside its own lagoon, where the breathtaking scenery, both above and below the waterline, is an attraction in and of itself. Their ocean bungalow''s glass floor captures a perfect vision of the turquoise waters and features extravagant and spacious villas. They have accommodation on the water as well as a designer yacht with modern and opulent amenities. Cruise about, savor the finest food prepared by international cooks, and relax with spa treatments. Huvafen Fushi Maldives is a stunning, luxurious, and expensive Maldivian property that is one of the best options in the Maldives.","Huvafen Fushi Maldives offers over-water and beach bungalows with private beaches, as well as free Wi-Fi and six dining options. A sundeck, big flat-screen satellite TV, and a Bang and Olufsen Bluetooth speaker are included with each spacious bungalow. A rain shower and a separate bathtub are included in the attached bathrooms."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 1054, 'jpzWIVnQNic', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'huvafen-fushi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'huvafen-fushi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'nakatchafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'huvafen-fushi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Bungalow', 1054, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'huvafen-fushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Bungalow Pool', 1314, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'huvafen-fushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- kuda-Villingili
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'kuda-villingili-resort-maldives', 'Kuda Villingili Resort Maldives', 'Kuda Villingili Resort Maldives is a private island that redefines time and space. Whether guests are travelling as a couple, family, group of friends, or alone, Kuda Villingili is a slice of paradise where everyone is welcome. The resort''s emphasis on time and space, which balances togetherness and inclusion with solitude and independence, allows guests to enjoy a personalised experience, making each voyage unique.', 'published', 'Kuda Villingili Resort Maldives | Maldives Resorts | MTG', 'Kuda Villingili Resort Maldives is a private island that redefines time and space. Whether guests are travelling as a couple, family, group of friends, or alone, Kuda Villingili is a slice of paradise where everyone is welcome. The resort''s emphasis on time and space, which balances togetherness and inclusion with solitude and independence, allows guests to enjoy a personalised experience, making each voyage unique.', '{"overview_paragraphs":["Kuda Villingili Resort Maldives is a private island that redefines time and space. Whether guests are travelling as a couple, family, group of friends, or alone, Kuda Villingili is a slice of paradise where everyone is welcome. The resort''s emphasis on time and space, which balances togetherness and inclusion with solitude and independence, allows guests to enjoy a personalised experience, making each voyage unique.","This tropical refuge on the pearl white beach is encircled by thick trees. The Deluxe Haven villa''s rustic wood furnishings are accented with stone features that shimmer in the sunlight. Relax on the beachside terrace or relax in a warm bath with uninterrupted ocean views.","The beach is right outside the door of this beachfront property with a private pool. Relax in an essential oil bath before laying out on the king-sized bed made of the finest Egyptian cotton and gazing out over the Maldivian sea.","Wake awake to the sound of the ocean waves in one of KudaVillingili''s oceanfront villas. The villas facing the turquoise sea include king-sized bedrooms, big bathrooms, covered dining patios with views of the horizon, and vast living areas with windows that enable the ocean breeze to flow in and out.","The resort offers a range of lodging options, making it ideal for lone travellers, couples, families, and groups of friends. The fascinating beauty of the Maldives inspired all 59 beach villas and 36 water villas.","The Kuda Villingili is located in North Malé Atoll and is only a 30-minute speedboat trip from Velana International Airport (MLE), ensuring a convenient, pleasant, and quick travel."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 1700, '8902D6Z2FQo', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'kuda-villingili-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'kuda-villingili-resort-maldives'
  and l.node_type = 'location' and l.slug = 'kuda-villingili'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'kuda-villingili-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Haven With Patio', 1700, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'kuda-villingili-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa Pool', 2900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'kuda-villingili-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 1850, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'kuda-villingili-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- nautilus
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'the-nautilus-island-resort-maldives', 'The Nautilus Island Resort Maldives', 'Each house and residence at The Nautilus is a distinct and sophisticated escape, inspired by the lasting shape of the nautilus shell. Each space is replete with curved lines and spiraled components. Our philosophy, like this symbol of the deep, is universal and eternal.', 'published', 'The Nautilus Island Resort Maldives | Maldives Resorts | MTG', 'Each house and residence at The Nautilus is a distinct and sophisticated escape, inspired by the lasting shape of the nautilus shell. Each space is replete with curved lines and spiraled components. Our philosophy, like this symbol of the deep, is universal and eternal.', '{"overview_paragraphs":["Each house and residence at The Nautilus is a distinct and sophisticated escape, inspired by the lasting shape of the nautilus shell. Each space is replete with curved lines and spiraled components. Our philosophy, like this symbol of the deep, is universal and eternal.","The Nautilus has 26 ultra-private beach and overwater homes, each with a luxurious master suite, separate dining space, expansive sundeck, and private pool. These bohemian, suite-style sanctuaries each come with private butler service and are steps away from azure seas."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 2069, 'K4RmfjxrmyY', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'the-nautilus-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'the-nautilus-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'thiladhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'the-nautilus-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach House', 2262, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'the-nautilus-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ocean House', 2069, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'the-nautilus-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- paradise
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'paradise-island-resort-maldives', 'Paradise Island Resort Maldives', 'This is paradise, or more precisely, Paradise Island Resort & Spa, an uncompromising haven of luxury and convenience. A network of paved pathways runs through the lush grounds, linking oceanfront accommodations, gourmet dining spots, sports facilities, and an inspiring spa, all of which contribute to making your Maldives island resort vacation everything you want it to be.', 'published', 'Paradise Island Resort Maldives | Maldives Resorts | MTG', 'This is paradise, or more precisely, Paradise Island Resort & Spa, an uncompromising haven of luxury and convenience. A network of paved pathways runs through the lush grounds, linking oceanfront accommodations, gourmet dining spots, sports facilities, and an inspiring spa, all of which contribute to making your Maldives island resort vacation everything you want it to be.', '{"overview_paragraphs":["This is paradise, or more precisely, Paradise Island Resort & Spa, an uncompromising haven of luxury and convenience. A network of paved pathways runs through the lush grounds, linking oceanfront accommodations, gourmet dining spots, sports facilities, and an inspiring spa, all of which contribute to making your Maldives island resort vacation everything you want it to be.","Paradise Island Resort offers 282 beautifully appointed guest rooms and suites in a casual luxury and luxurious environment. The resort has an outdoor pool, four bars, and a salon with many amenities."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 204, '6DZ5G4PYy3Y', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'paradise-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'paradise-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'lankanfinolhu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'paradise-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Bungalow', 204, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'paradise-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 271, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'paradise-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 496, 'USD', 'King', 2, 2
from nodes where node_type = 'accommodation' and slug = 'paradise-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- summer-island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'summer-island-resort-maldives', 'Summer Island Resort Maldives', 'Summer Island Maldives mixes a barefoot beach lifestyle with all the amenities of a beach. The resort, which is owned and operated locally, has been meticulously designed to have a truly Maldivian experience.', 'published', 'Summer Island Resort Maldives | Maldives Resorts | MTG', 'Summer Island Maldives mixes a barefoot beach lifestyle with all the amenities of a beach. The resort, which is owned and operated locally, has been meticulously designed to have a truly Maldivian experience.', '{"overview_paragraphs":["Summer Island Maldives mixes a barefoot beach lifestyle with all the amenities of a beach. The resort, which is owned and operated locally, has been meticulously designed to have a truly Maldivian experience.","Summer Island''s rooms are light and airy, with zesty interiors and plenty of space to spread out and lounge. Each space and villa has open balconies or verandas that look out onto a spectacular summer sunrise or sunset."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 153, 'kZCfEKeP9dM', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'summer-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'summer-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'ziyaaraifushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'summer-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Garden Villa', 153, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'summer-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 216, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'summer-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;
