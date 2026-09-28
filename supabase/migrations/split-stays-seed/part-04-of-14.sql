-- Part 4 of 14 - run this in the Supabase SQL Editor AFTER the previous parts.
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

-- Cocogiri-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'cocogiri-island-resort-maldives', 'Cocogiri Island Resort Maldives', 'Our swimming pool is right adjacent to White Sand''s Bar and Cafe and the beach, giving our visitors with spectacular views of the Indian Ocean. Enjoy a delicious drink from our Bar while lying by the pool in the Maldivian sun. Our Swimming Pool also features a children''s section for the enjoyment of the entire family.', 'published', 'Cocogiri Island Resort Maldives | Maldives Resorts | MTG', 'Our swimming pool is right adjacent to White Sand''s Bar and Cafe and the beach, giving our visitors with spectacular views of the Indian Ocean. Enjoy a delicious drink from our Bar while lying by the pool in the Maldivian sun. Our Swimming Pool also features a children''s section for the enjoyment of the entire family.', '{"overview_paragraphs":["Our swimming pool is right adjacent to White Sand''s Bar and Cafe and the beach, giving our visitors with spectacular views of the Indian Ocean. Enjoy a delicious drink from our Bar while lying by the pool in the Maldivian sun. Our Swimming Pool also features a children''s section for the enjoyment of the entire family.","Through our daily excursions, you can explore the surrounding islands and immerse yourself in the cultural beauty of the Maldives. Cocogiri is your private gateway to tropical paradise, located only 18 minutes by seaplane or 60 minutes by speed boat from Male International Airport.","Azure Lagoona Restaurant offers a pleasant dining experience with views of the Indian Ocean. The buffet offers a diverse selection of cuisine, as well as live cooking stations and themed evenings. Take your dining experience to the next level by ordering from our A La Carte menu. Breakfast, lunch, and dinner are all gastronomic experiences at Azure Lagoona Restaurant, where delectable specialties are prepared using only the finest ingredients.","Ameera Spa is created in discrete pods to provide our visitors with a sense of calm and joy. Our Spa Therapists are trained to provide a variety of services such as massage, facials, body wraps, scrubs, and numerous aesthetic treatments. Begin your day with a revitalising facial treatment or relax after a day of activities with our hot stone massage.","The secluded Vaavu Atoll has some of the Maldives'' most stunning coral reefs and sandbanks. The Vaavu Atoll is well-known for its diverse marine life, including dolphins, turtles, manta rays, eagle rays, living coral, and whale sharks. It is also home to Fotteyo Kandu, the Maldives'' largest unbroken barrier reef stretching over 50 kilometers, making it one of the best places in the world for diving."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 540, 'CqbUr7mdR6w', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'cocogiri-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'cocogiri-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'vashugiri'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'cocogiri-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Villa', 540, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'cocogiri-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Cocoon
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'cocoon-island-resort-maldives', 'Cocoon Island Resort Maldives', 'Cocoon Maldives combines the best of Italian design with the spectacular natural beauty of the Maldives, all against the backdrop of the turquoise Indian Ocean.', 'published', 'Cocoon Island Resort Maldives | Maldives Resorts | MTG', 'Cocoon Maldives combines the best of Italian design with the spectacular natural beauty of the Maldives, all against the backdrop of the turquoise Indian Ocean.', '{"overview_paragraphs":["Cocoon Maldives combines the best of Italian design with the spectacular natural beauty of the Maldives, all against the backdrop of the turquoise Indian Ocean.","The villas are completely equipped to allow you to rest, unwind, and enjoy a timeless vacation with us. The beachfront terrace views the gorgeous crystal-clear ocean, while your private garden, with with sun loungers, day bed, swimming pool, and outdoor shower, is the ideal place to spend sunny days. The natural beauty of the Maldives combined with the best of Italian design is a harmonious marriage of style and nature. Cocoon includes 150 guest villas, 3 restaurants, and 2 bars exclusively created by LAGO, the award-winning Italian designer, with mattresses that float in the air and rustic wildwood tables.","Cocoon Maldives is situated on the beautiful island of Ookolhufinolhu in the Lhaviyani Atoll. The resort is a picturesque 30-minute seaplane ride from Malé''s Velana International Airport.","You will be spoiled for choice with three restaurants and two bars. The main restaurant, OCTOPUS, entices you with world cuisines in themed buffets and interactive live stations. MANTA Restaurant in the lagoon offers à la carte eating for those looking for a romantic evening by candlelight to the rising lovers'' moon. JAPANESE GARDEN serves traditional Japanese cuisine while overlooking the Indian Ocean. KURUM-BAR is a laid-back spot for sunset cocktails, and the LOABI LOABI pool Bar is a convivial gathering spot that hosts nighttime parties.","Cocoon''s skilled spa therapists provide a wide range of therapeutic treatments from around the world to ensure a sublime spa experience that heals the mind, body, and spirit.","Cocoon Maldives has activities for everyone, from sports to entertainment and diving aficionados. Excursions activities such as island tours and dolphin cruises can be scheduled through our Travel & Tour Assistance staff. Daily entertainment includes a live band, a disco, a Maldivian cultural show, and other activities. Sporting activities such as Big Game fishing trips, Snorkeling Explorer, and others are available. You will be overwhelmed with options."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 390, 'VBv-4dBPSy4', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'cocoon-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'cocoon-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'ookolhufinolhu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'cocoon-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Villa', 390, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'cocoon-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoo Villa', 450, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'cocoon-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Conrad-Rangali
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'conrad-maldives-rangali-island-resort-maldives', 'Conrad Maldives Rangali Island Resort Maldives', 'Conrad Maldives Rangali Island is on an environmental mission. Our partnership with the environmental nonprofit Parley For The Oceans strives to influence change and promote sustainable travel. Each villa will be given a Parley Kit, which will encourage visitors to use less of the materials that have a negative influence on the environment and the ocean. Join us in honouring our oceans and caring for our threatened ecosystem.', 'published', 'Conrad Maldives Rangali Island Resort Maldives | Maldives Resorts | MTG', 'Conrad Maldives Rangali Island is on an environmental mission. Our partnership with the environmental nonprofit Parley For The Oceans strives to influence change and promote sustainable travel. Each villa will be given a Parley Kit, which will encourage visitors to use less of the materials that have a negative influence on the environment and the ocean. Join us in honouring our oceans and caring for our threatened ecosystem.', '{"overview_paragraphs":["Conrad Maldives Rangali Island is on an environmental mission. Our partnership with the environmental nonprofit Parley For The Oceans strives to influence change and promote sustainable travel. Each villa will be given a Parley Kit, which will encourage visitors to use less of the materials that have a negative influence on the environment and the ocean. Join us in honouring our oceans and caring for our threatened ecosystem.","Conrad Maldives Rangali Island will give you a new perspective on life. THE MURAKA is a one-of-a-kind property nestled in a private portion of the dazzling lagoon, providing completely integrated living, dining, entertaining, and sleeping above and below the Indian Ocean with unimpeded views at every step.","This property on Rangali-Finolhu Island is nestled among swaying palm trees and tropical foliage and has direct access to the powder soft white sand beach and turquoise sea of the Indian Ocean. Relax in the enormous bedroom with floor-to-ceiling glass windows; for further privacy, this villa has the option of creating a curtained-off section morphing into an alcove for a day bed.","Soak in the sound of the waves on the intimate outdoor patio, or take advantage of a one-of-a-kind open-air bathroom with rain shower and a magnificent thatch-roofed outdoor bathing pavilion. Beach villas are positioned on either side of the island, with some facing the morning sunrise and others facing the evening sunset.","Wake up to the relaxing sound of the ocean and the sun shining through your private sundeck, which offers unobstructed views of infinite blue. This villa is located on Rangali Island, our isolated adults-only island, and is ideal for a romantic island escape for two.","Spend the day snorkelling directly from your sundeck steps, swimming with exotic reef species in crystal clear water, or simply relaxing and sunbathing in the infinity plunge pool. This stilted thatch-roofed water villa has a big room with a lounge area, a glass desk set atop a glass-paneled floor with views into the ocean below, and a bathroom with an ocean-view tub, rain shower, and double vanity."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 1200, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'conrad-maldives-rangali-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'conrad-maldives-rangali-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'rangali'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'conrad-maldives-rangali-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 1200, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'conrad-maldives-rangali-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Water Villa', 1700, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'conrad-maldives-rangali-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Cora-Cora
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'cora-cora-maldives-island-resort-maldives', 'Cora Cora Maldives Island Resort Maldives', 'I''ve spent a lot of time in the Maldives staring down at huge islands, silently hoping that the resort I''m about to land at isn''t the one with the kilometer-long, villa-lined boardwalk snaking out to sea. Don''t get me wrong: staying at larger resorts has advantages, but Cora Cora Maldives, which opened last year, is a shining example of the advantages of smaller ones.', 'published', 'Cora Cora Maldives Island Resort Maldives | Maldives Resorts | MTG', 'I''ve spent a lot of time in the Maldives staring down at huge islands, silently hoping that the resort I''m about to land at isn''t the one with the kilometer-long, villa-lined boardwalk snaking out to sea. Don''t get me wrong: staying at larger resorts has advantages, but Cora Cora Maldives, which opened last year, is a shining example of the advantages of smaller ones.', '{"overview_paragraphs":["I''ve spent a lot of time in the Maldives staring down at huge islands, silently hoping that the resort I''m about to land at isn''t the one with the kilometer-long, villa-lined boardwalk snaking out to sea. Don''t get me wrong: staying at larger resorts has advantages, but Cora Cora Maldives, which opened last year, is a shining example of the advantages of smaller ones."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 600, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'cora-cora-maldives-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'cora-cora-maldives-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'maamigili'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'cora-cora-maldives-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'cora-cora-maldives-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'cora-cora-maldives-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 620, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'cora-cora-maldives-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Dhigali
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'dhigali-maldives-island-resort', 'Dhigali Maldives Island Resort', 'Dhigali Island, a slender coral cay in the Raa Atoll, is pure Maldivian bliss. This is a luxurious getaway with a twist, surrounded by coral and kissed by the sun. The island''s pristine blue border is dotted with castaway houses and overwater bungalows. The colourful life abounds in the house-reef. The depths of the Lakshadweep Sea beyond the lagoon provide magnificent sights. To set foot on the sands of Dhigali in the Maldives is to embark on an adventure. The excitement of discovery awaits on land, at sea, or undersea. Dhigali gives a warm Maldivian welcome to all guests. Design innovation, breathtaking scenery, and inspired, intuitive service combine to create a truly sublime island experience.', 'published', 'Dhigali Maldives Island Resort | Maldives Resorts | MTG', 'Dhigali Island, a slender coral cay in the Raa Atoll, is pure Maldivian bliss. This is a luxurious getaway with a twist, surrounded by coral and kissed by the sun. The island''s pristine blue border is dotted with castaway houses and overwater bungalows. The colourful life abounds in the house-reef. The depths of the Lakshadweep Sea beyond the lagoon provide magnificent sights. To set foot on the sands of Dhigali in the Maldives is to embark on an adventure. The excitement of discovery awaits on land, at sea, or undersea. Dhigali gives a warm Maldivian welcome to all guests. Design innovation, breathtaking scenery, and inspired, intuitive service combine to create a truly sublime island experience.', '{"overview_paragraphs":["Dhigali Island, a slender coral cay in the Raa Atoll, is pure Maldivian bliss. This is a luxurious getaway with a twist, surrounded by coral and kissed by the sun. The island''s pristine blue border is dotted with castaway houses and overwater bungalows. The colourful life abounds in the house-reef. The depths of the Lakshadweep Sea beyond the lagoon provide magnificent sights. To set foot on the sands of Dhigali in the Maldives is to embark on an adventure. The excitement of discovery awaits on land, at sea, or undersea. Dhigali gives a warm Maldivian welcome to all guests. Design innovation, breathtaking scenery, and inspired, intuitive service combine to create a truly sublime island experience.","The 20 beach cottages at Dhigali are concealed among natural vegetation. Each features an open-air bathroom as well as a luxurious semi-open rainfall shower. A large, covered patio with private sun loungers.","Beach Villas with private pools at Dhigali Maldives resort are excellent for couples celebrating romance. The villas offer breathtaking views of the sparkling blue-green waters, as well as a bathroom with an exhilarating rainfall shower that is open to the balmy island air and an expansive covered outdoor veranda that leads to the porcelain sands of the beach, where private sun loungers sit under native fronds.","Dhigali''s 24 Overwater villas in the Maldives are elegantly situated over crystal clear water, just a short paddle from the colourful house reef. Each villa has a large wooden sundeck that steps down to the sea, where exciting excursions await.","Dhigali Maldives'' crystal blue periphery is dotted with castaway homes and Over Water Bungalows. Some rooms include a lounge space for your comfort. There is a coffee machine in the room. Every room has its own bathroom, which has a bath or shower, a bidet, and a selection of amenities.","Beyond the lagoon, Dhigali Maldives is encircled by a massive house reef in Raa Atoll. Dhigali Maldives is a 45-minute seaplane flight from Velana International Airport. Domestic flights from Ifuru/Dharavandhoo Airport take only 70 minutes, including the transfer by speedboat."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 889, 'mK3be2nNVlI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'dhigali-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'dhigali-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'dhigali'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'dhigali-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Bungalow', 889, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'dhigali-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1400, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'dhigali-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 1180, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'dhigali-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Dhiggiri
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'nakai-dhiggiri-island-resort-maldives', 'NAKAI Dhiggiri Island Resort Maldives', 'Dhiggiri is a three-hectare island in the peaceful and intriguing Vaavu atoll, 20 minutes by seaplane and 90 minutes by speed boat north of Male. It is a "niche" atoll that only the most ardent Maldives fans are familiar with due to its magnificent points of immersion and distinct naturalistic tone. Its low population density and resulting small number of human settlements result in breathtaking natural vistas that can capture the eyes and hearts of people who cross it.', 'published', 'NAKAI Dhiggiri Island Resort Maldives | Maldives Resorts | MTG', 'Dhiggiri is a three-hectare island in the peaceful and intriguing Vaavu atoll, 20 minutes by seaplane and 90 minutes by speed boat north of Male. It is a "niche" atoll that only the most ardent Maldives fans are familiar with due to its magnificent points of immersion and distinct naturalistic tone. Its low population density and resulting small number of human settlements result in breathtaking natural vistas that can capture the eyes and hearts of people who cross it.', '{"overview_paragraphs":["Dhiggiri is a three-hectare island in the peaceful and intriguing Vaavu atoll, 20 minutes by seaplane and 90 minutes by speed boat north of Male. It is a \"niche\" atoll that only the most ardent Maldives fans are familiar with due to its magnificent points of immersion and distinct naturalistic tone. Its low population density and resulting small number of human settlements result in breathtaking natural vistas that can capture the eyes and hearts of people who cross it.","A modern structure surrounded by traditional Maldivian coral. In addition to the distinctive comfort and unsurpassed charm of the beachfront, the 27 beach bungalows of Dhiggiri will provide you with the tranquillity that only the most intimate and friendly environs can provide.","You will wake up to the sound of the sea and a stunning horizon at the 34 Over Water of Dhiggiri. The Over Water woods combine exquisite minimalism with sensory stimulation, ushering you into a new day of relaxation and tranquillity.","Dhiggiri offers three various types of rooms to its guests, ranging from the Over Water Rooms that view the ocean to the Beach Bungalows that are just a few steps from the beach, passing through a Garden Villa that is surrounded by flora. Choose the one that best suits you and let yourself to be whisked away by Dhiggiri''s enchantment.","It is close to a variety of diving sites in the Maldives, some of which are protected areas on the list of the greatest dive sites in the world, making it suitable for both expert and beginner divers. Dhiggiri is about 20 minutes by seaplane and 90 minutes by speed boat from Velana International Airport.","Let yourself be enslaved by the flavours of the island in Dhiggiri''s restaurants and pubs. Our dining menu has been created to be as diverse as possible in order to fulfil the demands of all customers. In the restaurants, you can sample the delights of Italian and Maldivian cuisine, prepared and served daily by our Chefs. Our bars will be the ideal place to unwind and have a refreshing drink while taking in the sights and sounds that only the Maldives can provide."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 310, 'Ng4M3P60Mio', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'nakai-dhiggiri-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'nakai-dhiggiri-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'dhiggiri'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'nakai-dhiggiri-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Bungalow', 310, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'nakai-dhiggiri-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Villa', 375, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'nakai-dhiggiri-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Dhigufaru-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'dhigufaru-island-resort-maldives', 'Dhigufaru Island Resort Maldives', 'Dhigufaru Island, meaning "a long reef," is the essence of an exotic hideaway, nestled in the protected Biosphere reserve of Baa Atoll. We offer the right blend of both if you choose to kick back, relax, and take in the majestic, stunning beauty of the island and surrounding coral, or if you prefer a more action-packed, exotic trip. Dhigufaru Island Resort welcomes you.', 'published', 'Dhigufaru Island Resort Maldives | Maldives Resorts | MTG', 'Dhigufaru Island, meaning "a long reef," is the essence of an exotic hideaway, nestled in the protected Biosphere reserve of Baa Atoll. We offer the right blend of both if you choose to kick back, relax, and take in the majestic, stunning beauty of the island and surrounding coral, or if you prefer a more action-packed, exotic trip. Dhigufaru Island Resort welcomes you.', '{"overview_paragraphs":["Dhigufaru Island, meaning \"a long reef,\" is the essence of an exotic hideaway, nestled in the protected Biosphere reserve of Baa Atoll. We offer the right blend of both if you choose to kick back, relax, and take in the majestic, stunning beauty of the island and surrounding coral, or if you prefer a more action-packed, exotic trip. Dhigufaru Island Resort welcomes you.","We invite you to a whole unique experience, one that lets you to discover the Maldives'' natural beauty from both above and below the water. We offer you an opportunity unlike any other, one that allows you to be as busy or as peaceful as you desire.","With breathtaking views and direct beach access from each of the 10 Veli Pool Beach Villas, 12 Veli Beach Villas, 8 Boaku Beach Villas, and 2 Family Beach Villas, you may choose between the serenity and tranquillity of the eastern facing Boaku beach and the stunning majesty of the Veli beach. Each Villa contains a semi-outdoor shower area, an inside bathroom, and a vanity area for him and her. The room is outfitted with all of the modern conveniences you''ll need. Each accommodation connects to your own veranda, which is surrounded by a private garden and offers views of the beach and lagoon.","The 10 Veli Pool Villas, located just within the beach tree line, offer the ultimate tropical luxury with views of the sun, sea, and sand. Everything you need for your comfort is provided within the room, including elegantly constructed comfy furnishings, satellite television, air conditioning, and ambient lighting. Step through to the decked veranda imbedded with a plunge pool facing the beach, fitted with comfortable sun loungers for all-day sunbathing.","Our amazing 20 Fidhanfulhu Water Villas are the pinnacle of comfort and enjoyment. These exquisite Water villas are big, bright, and luxuriously outfitted. Every Villa has its own stairway that leads down to the crystal clear lagoon below, ideal for swimming or snorkelling. Spend your days reclining just a few feet above the beautiful waves of the Indian Ocean on your private chaise, soaking up the sun while being pampered by our attentive staff.","The accommodations are positioned along the island''s perimeter, allowing you to appreciate the unique natural characteristics that make Dhigufaru Island Resort so fascinating."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 480, 'ni9GAZMyeBY', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'dhigufaru-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'dhigufaru-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'dhigufaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'dhigufaru-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Boaku Beach Villa', 480, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'dhigufaru-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Veli Pool Villa', 600, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'dhigufaru-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Fidhanfulhu Water Villa', 700, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'dhigufaru-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Diamonds-Thudufushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'diamond-thudufushi-maldives-resort-and-spa', 'Diamond Thudufushi Maldives Resort and Spa', 'Welcome to the magnificent Diamonds Thudufushi Beach and Water Villas. Elegant beach bungalows and luxury overwater villas can be found on the island. A wellness centre provides ayurvedic treatments, and a diving centre caters to our guests'' underwater experience. The Diamonds Thudufushi resort is only a 20-minute scenic seaplane flight from Malé International Airport. Thudufushi is the ideal resort to begin exploring the Maldives in a centre of excellence, where every detail has been carefully selected to make your journey unforgettable.', 'published', 'Diamond Thudufushi Maldives Resort and Spa | Maldives Resorts | MTG', 'Welcome to the magnificent Diamonds Thudufushi Beach and Water Villas. Elegant beach bungalows and luxury overwater villas can be found on the island. A wellness centre provides ayurvedic treatments, and a diving centre caters to our guests'' underwater experience. The Diamonds Thudufushi resort is only a 20-minute scenic seaplane flight from Malé International Airport. Thudufushi is the ideal resort to begin exploring the Maldives in a centre of excellence, where every detail has been carefully selected to make your journey unforgettable.', '{"overview_paragraphs":["Welcome to the magnificent Diamonds Thudufushi Beach and Water Villas. Elegant beach bungalows and luxury overwater villas can be found on the island. A wellness centre provides ayurvedic treatments, and a diving centre caters to our guests'' underwater experience. The Diamonds Thudufushi resort is only a 20-minute scenic seaplane flight from Malé International Airport. Thudufushi is the ideal resort to begin exploring the Maldives in a centre of excellence, where every detail has been carefully selected to make your journey unforgettable.","Your dives and excursions will be guided by experts, ranging from biologists who will reveal the secrets of the reef to qualified personnel who will ensure that your entire stay is unique and unforgettable. Because of our all-inclusive formula, you will be able to fully enjoy every second at Diamonds Thudufushi.","The 12 Beach Bungalows face the unspoiled waters and have direct access to the beach. They have verandas with private terraces with armchairs, tables, and sun loungers. Each of the rooms has an outdoor shower.","14 Water Villas have a large private terrace with direct ocean access. All of the rooms have a spacious living area with elegant furniture, a four poster bed, a comfortable sofa and corner bar, contemporary Italian lighting, and beautiful parquet floors.","Thudufushi is the ideal resort for exploring the Maldives and having an unforgettable vacation. During their stay, guests can relax in Beach Villas or enjoy an exquisite experience in Water Villas.","Malé International Airport is only a scenic 25-minute flight away."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 300, 'Caues3sglgg', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'diamond-thudufushi-maldives-resort-and-spa'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'diamond-thudufushi-maldives-resort-and-spa'
  and l.node_type = 'location' and l.slug = 'thudufushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'diamond-thudufushi-maldives-resort-and-spa'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Bungalow', 300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'diamond-thudufushi-maldives-resort-and-spa'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 500, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'diamond-thudufushi-maldives-resort-and-spa'
on conflict (accommodation_id, name) do nothing;

-- Dusit-Thani
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'dusit-thani-island-resort-maldives', 'Dusit Thani Island Resort Maldives', 'Thai heritage combined with the warm and welcoming Maldivian island culture Dusit Thani Maldives is located on Mudhdhoo Island in Baa Atoll, Maldives'' first UNESCO World Biosphere Reserve, and is only 35 minutes by seaplane from the capital city, Malé, or a 25-minute domestic flight and 10 minutes by speedboat from Dharavandhoo Airport.', 'published', 'Dusit Thani Island Resort Maldives | Maldives Resorts | MTG', 'Thai heritage combined with the warm and welcoming Maldivian island culture Dusit Thani Maldives is located on Mudhdhoo Island in Baa Atoll, Maldives'' first UNESCO World Biosphere Reserve, and is only 35 minutes by seaplane from the capital city, Malé, or a 25-minute domestic flight and 10 minutes by speedboat from Dharavandhoo Airport.', '{"overview_paragraphs":["Thai heritage combined with the warm and welcoming Maldivian island culture Dusit Thani Maldives is located on Mudhdhoo Island in Baa Atoll, Maldives'' first UNESCO World Biosphere Reserve, and is only 35 minutes by seaplane from the capital city, Malé, or a 25-minute domestic flight and 10 minutes by speedboat from Dharavandhoo Airport.","Guests seeking island adventure, fine dining, and relaxation will find a luxurious Maldives hotel on the beach as well as over-water villas and residences. The house reef is teeming with marine life, Devarana Spa provides elevated treatment rooms among the coconut trees, and full-service amenities cater to every whim.","Your luxurious Beach Villa awaits, spread across 122 square metres and surrounded by tropical flora, with modern amenities and full-service facilities on hand. Relax on your private terrace before taking a step down to the secluded sands below.","Your stylish Beach Villa offers poolside luxury in paradise, with a generous 122 sq. m of living space enhanced by elegant Thai decor. Take a dip on your private deck or relax on the terrace. Take advantage of the open-air garden bathroom and the direct beach access.","Your luxurious Water Villa, suspended over the turquoise lagoon''s crystal waters, measures 150 square metres and is decorated with Thai flourishes and equipped with all the amenities you require. Relax on your private terrace by the pool or plunge into the ocean.","Choose from a variety of beach and over-water villas and residences to create your ideal private paradise. Dusit Thani Maldives is a 5-star resort in the Maldives with elegant Thai interiors, modern conveniences, and butler service. Luxurious beach retreats await at Dusit Thani Maldives."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1000, 'PmHX8kEUcLI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'dusit-thani-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'dusit-thani-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'mudhdhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'dusit-thani-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 1000, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'dusit-thani-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1150, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'dusit-thani-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Pool Water Villa', 1300, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'dusit-thani-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Emerald-Maldives
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'emerald-maldives-resort-spa-fasmendhoo', 'Emerald Maldives Resort & Spa Fasmendhoo', 'Welcome to the Emerald Maldives Resort & Spa, a new 5-star Deluxe All-Inclusive Resort and proud member of The Leading Hotels of the World. The Resort combines tropical nature with modern design, creating atmospheres of natural and informal elegance, offering the ideal backdrop for guests to construct fresh and memorable experiences.', 'published', 'Emerald Maldives Resort & Spa Fasmendhoo | Maldives Resorts | MTG', 'Welcome to the Emerald Maldives Resort & Spa, a new 5-star Deluxe All-Inclusive Resort and proud member of The Leading Hotels of the World. The Resort combines tropical nature with modern design, creating atmospheres of natural and informal elegance, offering the ideal backdrop for guests to construct fresh and memorable experiences.', '{"overview_paragraphs":["Welcome to the Emerald Maldives Resort & Spa, a new 5-star Deluxe All-Inclusive Resort and proud member of The Leading Hotels of the World. The Resort combines tropical nature with modern design, creating atmospheres of natural and informal elegance, offering the ideal backdrop for guests to construct fresh and memorable experiences.","The spacious Beach Villas have a private garden outside the bathroom, a bedroom, and covered and open patios to relax on after a long day in Paradise.","The Beach Villas with Pool have a private pool in the private garden right outside the bathroom, as well as a bedroom and covered and open patios, allowing guests to be rewarded by a refreshing and quiet moment whenever they choose.","The Water Villas, which are directly on the pier and overlook the turquoise saltwater, provide a bedroom with a bathroom and a walk-in closet, as well as a terrace with a view of the sea.","The Emerald Maldives Resort & Spa has 120 luxury villas with modern and tropical elements, separated into 60 beach villas and 60 overwater villas. Not to add that more than half of the Villas will have their own private pool and Jacuzzi.","Fasmendhoo is an island in Raa Atoll, in the Maldives'' North West area. A breathtaking seaplane trip from Male will take 40 minutes, or you may take a 30-minute domestic flight to Ifuru Domestic Airport, where guests will enjoy a 15-minute speedboat ride to Emerald Maldives Resort. Guests will be able to conveniently connect with their intercontinental flights in the evening thanks to the domestic flight option."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 770, 'C5NRgq0L8_8', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'emerald-maldives-resort-spa-fasmendhoo'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'emerald-maldives-resort-spa-fasmendhoo'
  and l.node_type = 'location' and l.slug = 'fasmendhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'emerald-maldives-resort-spa-fasmendhoo'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 770, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'emerald-maldives-resort-spa-fasmendhoo'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'emerald-maldives-resort-spa-fasmendhoo'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 800, 'USD', 'Double', null, 2
from nodes where node_type = 'accommodation' and slug = 'emerald-maldives-resort-spa-fasmendhoo'
on conflict (accommodation_id, name) do nothing;

-- Eriyadu-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'eriyadu-island-resort-maldives', 'Eriyadu Island Resort Maldives', 'Feel a faraway wind, hear quiet laughing, and glide into a delicate groove that continually and beautifully fills this perfect piece of nature. Lie down on the sun-drenched white sand beach. Eriyadu Island exists, unlike a prophesied legend or a fantasy-scape, with its earthy-woody architecture and salty sea; it''s all real and it''s all here. When you arrive, you''ll be whisked away to the little island known for some of the world''s best diving.', 'published', 'Eriyadu Island Resort Maldives | Maldives Resorts | MTG', 'Feel a faraway wind, hear quiet laughing, and glide into a delicate groove that continually and beautifully fills this perfect piece of nature. Lie down on the sun-drenched white sand beach. Eriyadu Island exists, unlike a prophesied legend or a fantasy-scape, with its earthy-woody architecture and salty sea; it''s all real and it''s all here. When you arrive, you''ll be whisked away to the little island known for some of the world''s best diving.', '{"overview_paragraphs":["Feel a faraway wind, hear quiet laughing, and glide into a delicate groove that continually and beautifully fills this perfect piece of nature. Lie down on the sun-drenched white sand beach. Eriyadu Island exists, unlike a prophesied legend or a fantasy-scape, with its earthy-woody architecture and salty sea; it''s all real and it''s all here. When you arrive, you''ll be whisked away to the little island known for some of the world''s best diving.","SMARTLINE Eriyadu is a modest resort created with comfort in mind in the traditional Maldivian manner. These villas are tucked along the shoreline, beneath the sheltered fronds of palm trees.","SMARTLINE Eriyadu is located 45 minutes from Velana International Airport in North Male'' Atoll and is easily accessible by speed boat."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 130, 'dYXK4n48TUI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'eriyadu-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'eriyadu-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'eriyadu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'eriyadu-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sea View Sky Room', 130, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'eriyadu-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Faarufushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'emerald-faarufushi-island-resort-maldives', 'Emerald Faarufushi Island Resort Maldives', 'Welcome to the Emerald Faarufushi Resort & Spa, a new 5-star Deluxe All-Inclusive Resort and a proud member of The Leading Hotels of the World, where tropical landscapes and swaying palm trees welcome you to a refined fusion of nature and indulgence, creating an enchanting atmosphere of barefoot elegance. The resort is located in the Raa Atoll, in the northern part of the Maldives archipelago, on a beautiful private 7-hectare island with 1.2 kilometres of white sandy beach, and it is surrounded by a stunning 100-hectare lagoon with one of the Maldivian ecosystem''s finest coral reefs.', 'published', 'Emerald Faarufushi Island Resort Maldives | Maldives Resorts | MTG', 'Welcome to the Emerald Faarufushi Resort & Spa, a new 5-star Deluxe All-Inclusive Resort and a proud member of The Leading Hotels of the World, where tropical landscapes and swaying palm trees welcome you to a refined fusion of nature and indulgence, creating an enchanting atmosphere of barefoot elegance. The resort is located in the Raa Atoll, in the northern part of the Maldives archipelago, on a beautiful private 7-hectare island with 1.2 kilometres of white sandy beach, and it is surrounded by a stunning 100-hectare lagoon with one of the Maldivian ecosystem''s finest coral reefs.', '{"overview_paragraphs":["Welcome to the Emerald Faarufushi Resort & Spa, a new 5-star Deluxe All-Inclusive Resort and a proud member of The Leading Hotels of the World, where tropical landscapes and swaying palm trees welcome you to a refined fusion of nature and indulgence, creating an enchanting atmosphere of barefoot elegance. The resort is located in the Raa Atoll, in the northern part of the Maldives archipelago, on a beautiful private 7-hectare island with 1.2 kilometres of white sandy beach, and it is surrounded by a stunning 100-hectare lagoon with one of the Maldivian ecosystem''s finest coral reefs.","Emerald Faarufushi was created with the discriminating visitor in mind, and it distinguishes out for its simple yet modern architecture, real cultural experiences, and precisely perfected services that defy pretence. The island has 80 magnificent homes divided into six types, including 38 beach villas and 42 overwater villas.","The Beach Villas include an own furnished terrace and an open-air bathroom. Clean lines, subdued wood tones, and delicate pastel accents characterise this elegantly modest building. Access to a covered timber deck bordered by greenery with views of the sea.","The Beach Villas with Pool give direct access to the white-sand beach of Emerald Faarufushi. Views that reach all the way to the horizon. Every morning, the view is front and centre thanks to the vaulted ceilings, simple décor, and floor-to-ceiling windows. The finishing touch is a private plunge pool between the front entrance and the sea. They also have a private infinity pool, a large closet, an air-conditioned bathroom, and a private covered terrace with lounge chairs.","The Water Villas with Pool are located along the jetty of Emerald Faarufushi. Because they are all about the vista, they are completed in warm wood tones and large glass. Whether you''re relaxing in the tub, swimming in the pool, or spreading out on the terrace. Take it all in. They have a private infinity pool, a large closet, an air-conditioned bathroom, and a private covered terrace with lounge chairs.","All homes were developed with the purpose of blending in with the surrounding nature and have a simple, elegant style that integrates natural materials of stone and wood. The villas are luxuriously understated: sleek, contemporary, and delectably soothing. All 80 villas are meticulously curated havens with a stunning Indian Ocean view, perched either on the white sandy beach or immediately on the ocean. Flat satellite TVs, king size mattresses, walk-in and \"under the stars\" bathrooms, baths, ample closets, room-controlled air conditioning, and high-speed Wi-Fi are among the thoughtful pleasures. Seventy of the villas have their own private pool overlooking the ocean."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 775, '_WWq9VYHs5I', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'emerald-faarufushi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'emerald-faarufushi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'faarufushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'emerald-faarufushi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ocean Retreat With Pool', 775, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'emerald-faarufushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;
