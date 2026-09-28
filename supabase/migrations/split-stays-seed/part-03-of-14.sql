-- Part 3 of 14 - run this in the Supabase SQL Editor AFTER the previous parts.
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

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 250, 'p21Ix-mticw', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'angaga-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'angaga-island-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'angaga'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'angaga-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Bungalow', 250, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'angaga-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Bungalow', 350, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'angaga-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- Angsana-Velavaru
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'angsana-velavaru-island-resort-maldives', 'Angsana Velavaru Island Resort Maldives', 'Angsana Velavaru (known as "Turtle Island" in the local Dhivehi language) is perched on an expansive private lagoon in the virtually untouched South Nilandhe Atoll in the Maldives, and is just a 40-minute seaplane journey from Velana International Airport. It is surrounded by sparkling turquoise waters and ocean views as far as the eye can see.', 'published', 'Angsana Velavaru Island Resort Maldives | Maldives Resorts | MTG', 'Angsana Velavaru (known as "Turtle Island" in the local Dhivehi language) is perched on an expansive private lagoon in the virtually untouched South Nilandhe Atoll in the Maldives, and is just a 40-minute seaplane journey from Velana International Airport. It is surrounded by sparkling turquoise waters and ocean views as far as the eye can see.', '{"overview_paragraphs":["Angsana Velavaru (known as \"Turtle Island\" in the local Dhivehi language) is perched on an expansive private lagoon in the virtually untouched South Nilandhe Atoll in the Maldives, and is just a 40-minute seaplane journey from Velana International Airport. It is surrounded by sparkling turquoise waters and ocean views as far as the eye can see.","Angsana Velavaru is a wonderful island destination playground, with 5 All-Inclusive Packages intended to cater to different types of vacationers. Angsana''s All-Inclusive Concept presents a new kind of intrepid travel in the Maldives allowing you to enjoy the very best of #AngsanaMoments during your stay, from gourmet foodies to family travellers, spa enthusiasts, novice and expert divers. Take advantage of the opportunity and enter the uplifting world of Angsana Velavaru, the ideal destination playground for a wonderful year-round tropical holiday.","The 79 island villas and 34 In Ocean Villas are nestled in Velavaru Lagoon, offering amazing views and direct access to the Indian Ocean.","Angsana Velavaru is partly on the crystal blue waters of the Maldivian ocean and half on the white sandy beaches of the South Nilandhe Atoll to capture the finest of both worlds. Velana International Airport is 45 minutes distant via seaplane."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 700, 'G9Q7xzdH5AU', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'angsana-velavaru-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'angsana-velavaru-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'velavaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'angsana-velavaru-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 700, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'angsana-velavaru-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Pool Villa', 739, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'angsana-velavaru-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ocean Villa', 1230, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'angsana-velavaru-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Atmosphere-Kanifushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'atmosphere-kanifushi-island-resort-maldives', 'Atmosphere Kanifushi Island Resort Maldives', 'Escape to a private island retreat surrounded by blue Indian Ocean waves. The island''s two kilometres of beach and water homes have expansive living areas with exquisite décor. Our award-winning culinary experiences, along with exceptional service, are sure to impress even the most discriminating traveller, making it a standout among Maldives luxury resorts.', 'published', 'Atmosphere Kanifushi Island Resort Maldives | Maldives Resorts | MTG', 'Escape to a private island retreat surrounded by blue Indian Ocean waves. The island''s two kilometres of beach and water homes have expansive living areas with exquisite décor. Our award-winning culinary experiences, along with exceptional service, are sure to impress even the most discriminating traveller, making it a standout among Maldives luxury resorts.', '{"overview_paragraphs":["Escape to a private island retreat surrounded by blue Indian Ocean waves. The island''s two kilometres of beach and water homes have expansive living areas with exquisite décor. Our award-winning culinary experiences, along with exceptional service, are sure to impress even the most discriminating traveller, making it a standout among Maldives luxury resorts.","Our magnificent all-inclusive vacation package promises a relaxed, five-star resort experience. Offering premium wines and spirits, as well as buffet, fine dining, and theme night dining options, as well as a variety of experiences ranging from excursions and sunset fishing to snorkelling and non-motorized water sports.","A thrilling 35-minute seaplane trip from Malé''s International Airport takes you to the beautiful Kanifushi Island. The island is about 2 kilometres long and 90 metres broad, and it is covered with lush tropical flora and natural coral reefs. Kanifushi''s atmosphere will enchant you with its white sandy beaches, swaying palm trees, and lush tropical gardens. As the sun shines over the blue lake, time stands still. Under crystal pure waters, magical regions await exploration. Choose how you want to spend your days.","Atmosphere For guest solitude, Kanifushi Maldives provides 132 independent villas and suites separated by a few metres of tropical flora. All villas offer immediate access to the immaculate white beach and the stunning blue lagoon beyond, and are bordered by some of the region''s tallest coconut palms and lush tropical flora.","Kanifushi Island, located in the sparsely populated Lhaviyani Atoll, is roughly 2 km long and 90 metres broad, with beautiful green palm trees and blooming tropical flora surrounded by a big natural coral reef."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 800, 'Tm37BJAKfiw', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'atmosphere-kanifushi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'atmosphere-kanifushi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'kanifushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'atmosphere-kanifushi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunset Beach Villa', 800, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'atmosphere-kanifushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunset Pool Villa', 1000, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'atmosphere-kanifushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 875, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'atmosphere-kanifushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Ayada
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'ayada-maldives-island-resort', 'Ayada Maldives Island Resort', 'Ayada Maldives, located on a lovely private island with pristine beaches and rich tropical flora, offers a really magnificent escape in true Maldivian style. Ayada Maldives is a wonderful choice because of its many restaurants, huge villas with private infinity pools, and our numerous award-winning AySpa. Our visitors may choose from a wide range of water sports, excursions, and other activities.', 'published', 'Ayada Maldives Island Resort | Maldives Resorts | MTG', 'Ayada Maldives, located on a lovely private island with pristine beaches and rich tropical flora, offers a really magnificent escape in true Maldivian style. Ayada Maldives is a wonderful choice because of its many restaurants, huge villas with private infinity pools, and our numerous award-winning AySpa. Our visitors may choose from a wide range of water sports, excursions, and other activities.', '{"overview_paragraphs":["Ayada Maldives, located on a lovely private island with pristine beaches and rich tropical flora, offers a really magnificent escape in true Maldivian style. Ayada Maldives is a wonderful choice because of its many restaurants, huge villas with private infinity pools, and our numerous award-winning AySpa. Our visitors may choose from a wide range of water sports, excursions, and other activities.","At Ayada Maldives, we have 8 outlets, each offering a different cuisine and unique dining experience, such as Teppanyaki, Mediterranean fine dining, and Asian delicacies. We use fresh organic ingredients from our garden and nearby farmers in each restaurant, which makes our meal genuine and wonderfully delicious. Ile de Joie, our over-water wine cellar, provides a one-of-a-kind wine and cheese experience. Our cooks are prepared to accommodate any dietary restrictions.","Ayada Maldives provides nine different types of luxury accommodation, all of which incorporate contemporary and traditional Maldivian design aspects. The stilted water villas have been carefully situated on the beautifully formed jetty to catch amazing views of the boundless horizon, whilst the beach villas provide an enclave of perfect seclusion and quiet only 30 steps from the Indian Ocean.","The magnificent and spacious 10 Garden Villas, 33 Beach Villas, 4 Beach Suites, 14 Sunset Beach Villas, 11 Sunset Lagoon Suites, 33 Ocean Villas, 14 Sunset Ocean Suites, 2 Sunset Family Suites, and Ayada Royal Suite are all tastefully designed and furnished to provide maximum privacy and utmost comfort.","Ayada Maldives is situated in the beautiful Gaafu Dhaalu Atoll in the country''s south. When passengers arrive at Velena (MLE), they are met by one of our airport personnel and brought to the domestic lounge, followed by the leaving domestic aircraft gate. The resort is merely a 55-minute domestic flight and a 50-minute speed boat ride from Male."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 670, 'CZGxcfCXJz0', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'ayada-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'ayada-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'maguhdhuvaa'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'ayada-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Garden Villa', 670, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'ayada-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Pool Villa', 850, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'ayada-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ocean Villa', 1300, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'ayada-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Baglioni-Resort
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'baglioni-island-resort-maldives', 'Baglioni Island Resort Maldives', 'Lose yourself in the expanse of the Indian Ocean, only to resurface peacefully under a palm tree. This is just one of the extraordinary experiences available at the Baglioni Resort Maldives. This amazing resort is bathed in tropical natural splendour and is dreamily dazzling on the island of Maagau in Dhaalu atoll.', 'published', 'Baglioni Island Resort Maldives | Maldives Resorts | MTG', 'Lose yourself in the expanse of the Indian Ocean, only to resurface peacefully under a palm tree. This is just one of the extraordinary experiences available at the Baglioni Resort Maldives. This amazing resort is bathed in tropical natural splendour and is dreamily dazzling on the island of Maagau in Dhaalu atoll.', '{"overview_paragraphs":["Lose yourself in the expanse of the Indian Ocean, only to resurface peacefully under a palm tree. This is just one of the extraordinary experiences available at the Baglioni Resort Maldives. This amazing resort is bathed in tropical natural splendour and is dreamily dazzling on the island of Maagau in Dhaalu atoll.","Baglioni Resort Maldives received outstanding recognitions at the World Luxury Hotel Awards (Continent Winner, Luxury Beach Resort Spa - Country Winner, Fine Dining Cuisine - Regional Winner) and the Luxury Lifestyle Awards in 2022. (Best Luxury Beach Hotel).","Luxury villas surrounded by lush tropical vegetation, blue seas, and velvety-soft white beaches. Accommodation designed with typical Italian attention to detail, employing materials and design approaches for maximum sustainability while maximising the natural surroundings and its all-encompassing beauty.","Baglioni Resort Maldives is drenched with tropical natural beauty and is dreamily resplendent on the island of Maagau in Dhaalu atoll, a 40-minute seaplane ride from Malé, the Maldives'' capital. Baglioni Resort Maldives was designed to minimise environmental impact, with sustainable materials and measures for maximum sustainability and efficiency. It is the ideal destination for an unforgettable stay between sport and relaxation, all complemented by a prestigious gastronomic offer for the most discerning international clientele.","From breakfast to after dinner, the Resort''s unique Italian cuisine will thrill the most discerning international clients. A pool bar and grill, three excellent restaurants serving gourmet cuisine, and a Kids'' Menu designed specifically for younger guests are available. Sophisticated aperitivi, wine tastings, and bespoke private dinners round out the menu.","Relax and revitalise the body and spirit with Maldivian tradition''s rich rituals. At the Baglioni SPA, your Italian paradise in the middle of nature, you may share beauty and health experiences with your loved ones. In addition, our visiting professional practitioner will assist you through your inner self awareness and holistic well-being: meditation, Kundalini yoga, stress reduction and chakra balancing, alternative medical treatments such as Acupuncture and Naturopathy."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 1180, '5d1Pp6Ky0-8', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'baglioni-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'baglioni-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'maagau'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'baglioni-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 1180, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'baglioni-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 1320, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'baglioni-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Bandos-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'bandos-island-resort-maldives', 'Bandos Island Resort Maldives', 'The island of Bandos is located in the centre of the Indian Ocean. A picture-perfect sanctuary tucked away from the worries of everyday life. The stunning blue ocean, colourful plant life, and white sandy beaches immediately generate a sense of calm. From the time you arrive, you will experience the pleasant, attentive service that has earned Bandos the nickname "Island of Hospitality." We deliver the finest without having to travel any further, as we are only 10 minutes from the international airport.', 'published', 'Bandos Island Resort Maldives | Maldives Resorts | MTG', 'The island of Bandos is located in the centre of the Indian Ocean. A picture-perfect sanctuary tucked away from the worries of everyday life. The stunning blue ocean, colourful plant life, and white sandy beaches immediately generate a sense of calm. From the time you arrive, you will experience the pleasant, attentive service that has earned Bandos the nickname "Island of Hospitality." We deliver the finest without having to travel any further, as we are only 10 minutes from the international airport.', '{"overview_paragraphs":["The island of Bandos is located in the centre of the Indian Ocean. A picture-perfect sanctuary tucked away from the worries of everyday life. The stunning blue ocean, colourful plant life, and white sandy beaches immediately generate a sense of calm. From the time you arrive, you will experience the pleasant, attentive service that has earned Bandos the nickname \"Island of Hospitality.\" We deliver the finest without having to travel any further, as we are only 10 minutes from the international airport.","Bandos Maldives is well-known for being a family-friendly resort. You may unwind and enjoy yourself as your children have the time of their lives. Our medical facility, which is equipped with a hyperbaric and decompression chamber, has two doctors on call 24 hours a day, seven days a week for general and dive-related needs. We have numerous repeat customers that have been with us for over 20 years. We are also pleased to be one of the best rated hotels in the Maldives across all booking and review sites.","Bandos'' lodging options, which range from ultra-exclusive and magnificent Water Villas to regular rooms, clearly reflect the different interests and expectations of our guests.","Bandos Island, located 10 minutes from Velana International Airport, offers the finest without the burden of travelling further.","Bandos Maldives now offers an All Inclusive Package. Breakfast, lunch, and supper at the Gallery restaurant are included, as well as alcoholic and non-alcoholic beverages at the Sand Bar, Huvan, and Gallery restaurant. The bundle also includes a choice of sports and entertainment options. Enjoy a wonderful bargain vacation today on the white-sand beaches of Bandos, Maldives.","Everything at Orchid Spa is pleasurable: the energy of the pool, the calm of the tropical setting, the natural noises, the hot steam and sauna baths that enter the muscles and release stress. The quaint tiny hair salon offers Crème Baths, deep soothing head massages, hair conditioning treatments, and manicure services. Relax your body and mind with a wonderful massage at Orchid Spa while on vacation in Bandos. Spa''s private villas and cabanas provide intimacy and solitude."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 350, 'NXykEIVZthY', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'bandos-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'bandos-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'bandos'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'bandos-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 350, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'bandos-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 800, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'bandos-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 910, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'bandos-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Banyan-Tree
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'banyan-tree-vabbinfaru-island-resort-maldives', 'Banyan Tree Vabbinfaru Island Resort Maldives', 'Step into a barefoot luxury tropical paradise where the sea meets the sky. Be enchanted by the all-natural beauty of Banyan Tree Vabbinfaru, set in the heart of North Male'' Atoll, just a 20-minute speedboat trip from Velana International Airport.', 'published', 'Banyan Tree Vabbinfaru Island Resort Maldives | Maldives Resorts | MTG', 'Step into a barefoot luxury tropical paradise where the sea meets the sky. Be enchanted by the all-natural beauty of Banyan Tree Vabbinfaru, set in the heart of North Male'' Atoll, just a 20-minute speedboat trip from Velana International Airport.', '{"overview_paragraphs":["Step into a barefoot luxury tropical paradise where the sea meets the sky. Be enchanted by the all-natural beauty of Banyan Tree Vabbinfaru, set in the heart of North Male'' Atoll, just a 20-minute speedboat trip from Velana International Airport.","Relax at the all-pool villas on this gorgeous island, which are set among swaying palm trees. Explore the colourful underwater world of the Maldives and the Indian Ocean on a luxury Catamaran. Set off on a delectable gastronomic adventure that will make your heart sing. Time-honored Asian-inspired therapies at the award-winning Banyan Tree Spa round off a completely refreshing vacation.","48 beautiful villas are set on a coral atoll in the Indian Ocean, surrounded by a white powdery beach. Banyan Tree Vabbinfaru villas all include one bedroom, an open patio, a manicured garden, and a private sundeck.","Banyan Tree Vabbinfaru is located in North Male'' Atoll, a 35-minute speedboat ride from Velana International Airport.","At the informal seaside Ilaafathi, where indigenous food is presented alongside worldwide favourites, indulge in unhurried gastronomic delights with barefoot eating. Naiboli Bar features breathtaking sunsets, delightful drinks, and Bodu Beru nights of energising dance performances.","Destination Dining is a one-of-a-kind experience that even the most seasoned traveller should enjoy. A private table accentuated with romantic accents, an expansive view of the Indian Ocean before you, and a star-filled sky overhead combine to provide a private dinner experience in Maldives to remember."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 980, 'j1sbqolKVj4', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'banyan-tree-vabbinfaru-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'banyan-tree-vabbinfaru-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'vabbinfaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'banyan-tree-vabbinfaru-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 980, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'banyan-tree-vabbinfaru-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- COMO-Cocoa
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'como-cocoa-island-resort-maldives', 'COMO Cocoa Island Resort Maldives', 'COMO''s white-sand private island retreat in the Maldives is a small, intimate resort with 33 overwater villas overlooking a turquoise lagoon. At its core? The essence of relaxation – and an outstanding COMO Shambhala health resort.', 'published', 'COMO Cocoa Island Resort Maldives | Maldives Resorts | MTG', 'COMO''s white-sand private island retreat in the Maldives is a small, intimate resort with 33 overwater villas overlooking a turquoise lagoon. At its core? The essence of relaxation – and an outstanding COMO Shambhala health resort.', '{"overview_paragraphs":["COMO''s white-sand private island retreat in the Maldives is a small, intimate resort with 33 overwater villas overlooking a turquoise lagoon. At its core? The essence of relaxation – and an outstanding COMO Shambhala health resort.","Our one- to three-bedroom villas inhabit the gently curved shapes of indigenous ''dhoni'' boats, so you can stroll along wooden paths to your apartment."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, null, '_XB8pI2cRwU', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'como-cocoa-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'como-cocoa-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'makunufushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'como-cocoa-island-resort-maldives'
on conflict (id) do nothing;

-- COMO-Maalifushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'como-maalifushi-island-resort-maldives', 'COMO Maalifushi Island Resort Maldives', 'The Maldives'' largest private island resort, COMO, includes multi-room villas both above water and in tropical gardens. In the Indian Ocean, we''re surrounded by uninhabited islands, world-class surf breaks, and teeming marine life – a world away.', 'published', 'COMO Maalifushi Island Resort Maldives | Maldives Resorts | MTG', 'The Maldives'' largest private island resort, COMO, includes multi-room villas both above water and in tropical gardens. In the Indian Ocean, we''re surrounded by uninhabited islands, world-class surf breaks, and teeming marine life – a world away.', '{"overview_paragraphs":["The Maldives'' largest private island resort, COMO, includes multi-room villas both above water and in tropical gardens. In the Indian Ocean, we''re surrounded by uninhabited islands, world-class surf breaks, and teeming marine life – a world away.","COMO Maalifushi offers a variety of elegantly furnished hotel rooms with indigenous style and decor. Guests can pick from seven distinct accommodation categories. Each room provides complete solitude and is well equipped with the newest equipment and amenities, allowing you to relax and enjoy the natural tropical surroundings.","COMO Maalifushi is located in Thaa Atoll, in the southern Maldives, and may be reached by a 50-minute sea plane flight from Velana International Airport.","Our Japanese restaurant, Tai, serves local seafood as sushi and sashimi in the evenings. With beach barbecues, nutritious salads, and COMO Cuisine classics, Madi''s all-day eating emphasises flavour and freshness. In-room access to our healthy COMO Shambhala meals is also available.","COMO Shambhala Retreat offers wellbeing in the Maldives, where the sea breeze sweeps through our open-air yoga pavilion and our overwater treatment rooms overlook blue horizons. This is the island where our award-winning holistic health method is based.","Exploring excellent surf breaks and uninhabited private islands under the Maldives'' endless sunshine is one of the experiences available at COMO Maalifushi. Play by COMO''s carefully curated programmes benefit younger guests."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 1260, 'JXF1GshPotc', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'como-maalifushi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'como-maalifushi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'maalifushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'como-maalifushi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Suite', 1260, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'como-maalifushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Suite', 1560, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'como-maalifushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Cinnamon-Dhonveli
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'cinnamon-dhonveli-island-resort-maldives', 'Cinnamon Dhonveli Island Resort Maldives', 'Cinnamon Dhonveli Maldives, a stunning tropical island resort with exclusive access to the legendary Pasta Point surf break, is an island of both action and sumptuous rest. There is something for everyone in this exotic paradise, whether you bring the family, a group of friends, or even your significant other. When you stay with us, you may enjoy stunning over-water suites, couples'' spa treatments, sunset cruises, and intimate, beautiful dinners on the white sand beach.', 'published', 'Cinnamon Dhonveli Island Resort Maldives | Maldives Resorts | MTG', 'Cinnamon Dhonveli Maldives, a stunning tropical island resort with exclusive access to the legendary Pasta Point surf break, is an island of both action and sumptuous rest. There is something for everyone in this exotic paradise, whether you bring the family, a group of friends, or even your significant other. When you stay with us, you may enjoy stunning over-water suites, couples'' spa treatments, sunset cruises, and intimate, beautiful dinners on the white sand beach.', '{"overview_paragraphs":["Cinnamon Dhonveli Maldives, a stunning tropical island resort with exclusive access to the legendary Pasta Point surf break, is an island of both action and sumptuous rest. There is something for everyone in this exotic paradise, whether you bring the family, a group of friends, or even your significant other. When you stay with us, you may enjoy stunning over-water suites, couples'' spa treatments, sunset cruises, and intimate, beautiful dinners on the white sand beach.","Release your inner adrenaline junkie by riding a jet ski across the ocean, water skiing or windsurfing over the waves, or taking a catamaran ride. Sign up for a diving lesson at our dive centre or simply drop in for some leisurely snorkelling if you''d rather go beneath the surface than above it.","Of course, they have a beautiful view from every part of the island! This means that beautiful sunrises, sunsets, and the deep blue Indian Ocean are just outside your window no matter where you stay. Each accommodation at Cinnamon Dhonveli is meant to transport you to heaven while also making you feel completely at home.","The excitement of your exciting destination begins with an amazing 25-minute speedboat voyage to an island 13 kilometres from Malé. Cinnamon Dhonveli Maldives promises a lovely tropical trip packed with cultural excursions and marine life in the heart of the North Malé Atoll!","Pasta Point, a world-famous surf break in the Maldives, is a dream location for surfers from all over the world. This surf location, named after an Italian cafe that used to be in the same area, is known as the \"wave-machine\" of the North Malé Atoll because to its regular wave output, which averages 4-6 feet in height."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 280, '9Cblu6zFvVA', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'cinnamon-dhonveli-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'cinnamon-dhonveli-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'kanuhuraa'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'cinnamon-dhonveli-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Bungalow', 280, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'cinnamon-dhonveli-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Bungalow', 360, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'cinnamon-dhonveli-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Cinnamon-Hakuraa
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'cinnamon-hakuraa-huraa-island-resort-maldives', 'Cinnamon Hakuraa Huraa Island Resort Maldives', 'The Maldives are a haven for couples in love, and the beauty of Cinnamon Hakuraa Huraa Maldives takes romance to a whole new level. You''re staring at one of the Maldives'' largest shallow lagoons - and a great location for a photo shoot! Following a warm welcome at the welcome pavilion, you will be brought to your luxurious room near the sandy beach or an overwater cottage. If you are on your honeymoon, a fruit basket and a bottle of wine will be waiting for you.', 'published', 'Cinnamon Hakuraa Huraa Island Resort Maldives | Maldives Resorts | MTG', 'The Maldives are a haven for couples in love, and the beauty of Cinnamon Hakuraa Huraa Maldives takes romance to a whole new level. You''re staring at one of the Maldives'' largest shallow lagoons - and a great location for a photo shoot! Following a warm welcome at the welcome pavilion, you will be brought to your luxurious room near the sandy beach or an overwater cottage. If you are on your honeymoon, a fruit basket and a bottle of wine will be waiting for you.', '{"overview_paragraphs":["The Maldives are a haven for couples in love, and the beauty of Cinnamon Hakuraa Huraa Maldives takes romance to a whole new level. You''re staring at one of the Maldives'' largest shallow lagoons - and a great location for a photo shoot! Following a warm welcome at the welcome pavilion, you will be brought to your luxurious room near the sandy beach or an overwater cottage. If you are on your honeymoon, a fruit basket and a bottle of wine will be waiting for you.","You''ll be walking on water at this resort. Allow us to indulge you and your significant other with a delectable supper away from the hustle and bustle, on a romantic beach in barefoot luxury. Despite our numerous activities and excursions, we recognise that when you''re in love, sometimes it''s simply enough to be. Relax on a white sandy beach alongside a crystal blue lagoon in complete peace. Honeymooners are invited to the Platinum Island, an adults-only retreat at Cinnamon Hakuraa Huraa Maldives that features a private pool, Manzaru Restaurant, Vevu Bar and Lounge, and the magnificent Platinum Beach Bungalows. This is the place to go if you want complete seclusion.","Cinnamon Hakuraa Huraa offers Beach Bungalows, Water Bungalows, and Platinum Beach Bungalows for a higher level of luxury. Every bungalow has gone above and beyond the degree of design and décor of a luxury yet comfortable existence.","The huge, turquoise halo surrounding the land will be the first thing you notice as your seaplane glides across the seas through the faraway Meemu Atoll. You''re staring at one of the Maldives'' largest shallow lagoons - and an ideal location for a photo shoot.","When you''re not having a romantic private dining experience for two on your own balcony, you may enjoy the aromas, colours, and breathtaking modern architecture of our restaurants and lounges.","Mandara Spa, a specialist in relaxation and luxurious therapies, is bringing some Balinese opulence to our humble island."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 430, 'xOcMV9PMeSU', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'cinnamon-hakuraa-huraa-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'cinnamon-hakuraa-huraa-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'hakuraa-huraa'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'cinnamon-hakuraa-huraa-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Bungalow', 430, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'cinnamon-hakuraa-huraa-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Bungalow', 490, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'cinnamon-hakuraa-huraa-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Cinnamon-Velifushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'cinnamon-velifushi-island-resort-maldives', 'Cinnamon Velifushi Island Resort Maldives', 'This tranquil aquatic sanctuary is teeming with marine life, including the majestic nurse shark. These sluggish creatures, which are harmless to humans, can grow up to 10 feet long and make a stunning spectacle as they glide gently along the reef. At this pristine atoll, kids will appreciate getting up close and personal with nature. Wildlife is more likely to visit when there is less disturbance from boats and planes. Even our Over-water villas and suites feature a sinuous pathway that, from above, resembles a stingray!', 'published', 'Cinnamon Velifushi Island Resort Maldives | Maldives Resorts | MTG', 'This tranquil aquatic sanctuary is teeming with marine life, including the majestic nurse shark. These sluggish creatures, which are harmless to humans, can grow up to 10 feet long and make a stunning spectacle as they glide gently along the reef. At this pristine atoll, kids will appreciate getting up close and personal with nature. Wildlife is more likely to visit when there is less disturbance from boats and planes. Even our Over-water villas and suites feature a sinuous pathway that, from above, resembles a stingray!', '{"overview_paragraphs":["This tranquil aquatic sanctuary is teeming with marine life, including the majestic nurse shark. These sluggish creatures, which are harmless to humans, can grow up to 10 feet long and make a stunning spectacle as they glide gently along the reef. At this pristine atoll, kids will appreciate getting up close and personal with nature. Wildlife is more likely to visit when there is less disturbance from boats and planes. Even our Over-water villas and suites feature a sinuous pathway that, from above, resembles a stingray!","Consider booking an appointment at the resort spa for an exquisite massage or any other unique spa treatment for a more relaxing activity. With our diverse eating alternatives, meals are never boring. Local and foreign cuisine is available, so you can try something new or savour the taste of an old favourite. If you want something more romantic, we will gladly create a more personalised dinner experience in a remote area, such as one of our white sand beaches.","When it''s time to call it a day, relax in one of our 90 incredibly spacious rooms. The spacious, open, Italian-styled décor effectively compliment the magnificent vistas from each elegant accommodation at Cinnamon Velifushi Maldives. Nothing but you and the wide sea in our water villas! Every accent throughout the hotel echoes the movements and natural tones of the ocean''s depths, so feel free to go with the flow...","This resort will have 66 over-water accommodations, including a Water Suite with a Pool, and 24 land-based rooms, including Beach Bungalows. The resort will also have an Over Water Spa, an Over Water Al-a-cater Restaurant, and other attractions.","The most precious things in life are said to come in small packages, and this glittering 5-star private island retreat is no exception, measuring 5 hectares. Cinnamon Velifushi Maldives is a short seaplane (or speedboat, if you prefer) ride away from Malé, and will provide you with all the breathing space from reality that you require.","We are always willing to add extra unique touches to your stay in order to enhance the romanticism of your holiday. Consider private dinners, island vacations, and personalised experiences for two. Here in Cinnamon Velifushi Maldives, the choices are endless."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 400, 'kbMWsPEN_tI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'cinnamon-velifushi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'cinnamon-velifushi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'velifushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'cinnamon-velifushi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Bungalow', 400, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'cinnamon-velifushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Bungalow', 490, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'cinnamon-velifushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Coco-Bodu-Hithi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'coco-bodu-hithi-island-resort-maldives', 'Coco Bodu Hithi Island Resort Maldives', 'The Coco Bodu Hithi Resort in the Maldives captures the essence of the island in every detail. Our Maldives resort is your stylish haven. Reconnect with yourself, your loved ones, and the natural world''s wonders. Remind yourself what it''s like to take a break and travel. Breathe in the fresh sea air. The Hawksbill turtles have arrived. Witness the local Nurse sharks'' tranquil majesty. Investigate the unusual colours of the reef''s inhabitants. Swim beside Manta rays. Take a peaceful sunset cruise across the river. Sink your toes into the white sand and become acquainted with island life and its dreamlike rhythm. All of this is available to you at the Coco Bodu Hithi Maldives Resort.', 'published', 'Coco Bodu Hithi Island Resort Maldives | Maldives Resorts | MTG', 'The Coco Bodu Hithi Resort in the Maldives captures the essence of the island in every detail. Our Maldives resort is your stylish haven. Reconnect with yourself, your loved ones, and the natural world''s wonders. Remind yourself what it''s like to take a break and travel. Breathe in the fresh sea air. The Hawksbill turtles have arrived. Witness the local Nurse sharks'' tranquil majesty. Investigate the unusual colours of the reef''s inhabitants. Swim beside Manta rays. Take a peaceful sunset cruise across the river. Sink your toes into the white sand and become acquainted with island life and its dreamlike rhythm. All of this is available to you at the Coco Bodu Hithi Maldives Resort.', '{"overview_paragraphs":["The Coco Bodu Hithi Resort in the Maldives captures the essence of the island in every detail. Our Maldives resort is your stylish haven. Reconnect with yourself, your loved ones, and the natural world''s wonders. Remind yourself what it''s like to take a break and travel. Breathe in the fresh sea air. The Hawksbill turtles have arrived. Witness the local Nurse sharks'' tranquil majesty. Investigate the unusual colours of the reef''s inhabitants. Swim beside Manta rays. Take a peaceful sunset cruise across the river. Sink your toes into the white sand and become acquainted with island life and its dreamlike rhythm. All of this is available to you at the Coco Bodu Hithi Maldives Resort.","The Maldives'' private Coco Bodu Hithi villas combine the principles of ample space, private pools and outdoor decks, elegant decor, and true comfort. Our Island Villas offer one experience of Bodu Hithi, nestled in thick tropical flora only steps from the water, each with its own space on the beach. Our Water Villas and Escape Water Villas stand gently above the lagoon off the east coast of the island. Waking up to this vision of an endless ocean is eternally uplifting. Coco Residences, which face northwest, stand as an enclave on water, forming an unique wing of the resort.","Coco Bodu Hithi is an island paradise in North Male Atoll, 40 minutes by speedboat from Velana International Airport.","Every night, there''s something new for you to experience, from Maldives fine dining to beach picnics. Our varied breakfast buffets and themed evenings are served at Air. Aqua is our fine-dining establishment that specialises in fish. Tsuki serves authentic Japanese cuisine. Stars combines flavours from the East and the Mediterranean. The Wine Loft is an oenophile''s paradise, while Latitude is a cocktail lover''s fantasy. If you simply cannot leave the sanctuary of your villa, you can order from an In-villa menu featuring a variety of food and drinks from our Maldives Restaurants, including dishes suitable for children.","Coco Spa in the Maldives exudes tranquillity. Eight chambers, each named after a different section of the coconut palm, provide the ideal retreat for disconnecting from the outer world and reconnecting with your body and mind. A variety of extremely restorative treatments inspired by ancient Indonesian, Thai, and Indian traditions and augmented with tea-inspired products. You can relax in the Raa room with our professional Thai masseurs or in the Kurumba room with our distinctive ritual, Journey to the Maldives. Each room at our Maldives Spa provides a tranquil setting in which to unwind after treatments and prolong the sensation of being pampered.","We recognise two things: the richness of our island home is found in its natural beauty, tropical climate, and slow pace, and the shared vision of those who visit us is to be refreshed, enriched, and inspired by their time with us. In response to the qualities of Bodu Hithi and the desires of our guests, we have designed excursions, adventures, and activities that allow you to discover the Maldives and combine it all into unforgettable, cherished realities."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 690, 'xGAFeyMV4XI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'coco-bodu-hithi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'coco-bodu-hithi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'bodu-hithi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'coco-bodu-hithi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Island Villa', 690, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'coco-bodu-hithi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'coco-bodu-hithi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;
