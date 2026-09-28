-- Part 10 of 14 - run this in the Supabase SQL Editor AFTER the previous parts.
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
select id, 'Deluxe Beach Villa', 250, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'reethi-faru-resort-maldives-island'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 300, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'reethi-faru-resort-maldives-island'
on conflict (accommodation_id, name) do nothing;

-- Residence-Dhigurah
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'the-residence-maldives-at-dhigurah-island-resort', 'The Residence Maldives at Dhigurah Island Resort', 'Discover your own own luxury retreat at The Residence Maldives at Dhigurah, nestled in the Gaafu Alifu Atoll in the southern Maldives. A palm-fringed paradise surrounded by turquoise lagoons, relaxing ocean blues, and a beautiful natural wilderness of over 2500 well-preserved coconut palm trees where you may immerse yourself in blissful relaxation.', 'published', 'The Residence Maldives at Dhigurah Island Resort | Maldives Resorts | MTG', 'Discover your own own luxury retreat at The Residence Maldives at Dhigurah, nestled in the Gaafu Alifu Atoll in the southern Maldives. A palm-fringed paradise surrounded by turquoise lagoons, relaxing ocean blues, and a beautiful natural wilderness of over 2500 well-preserved coconut palm trees where you may immerse yourself in blissful relaxation.', '{"overview_paragraphs":["Discover your own own luxury retreat at The Residence Maldives at Dhigurah, nestled in the Gaafu Alifu Atoll in the southern Maldives. A palm-fringed paradise surrounded by turquoise lagoons, relaxing ocean blues, and a beautiful natural wilderness of over 2500 well-preserved coconut palm trees where you may immerse yourself in blissful relaxation.","Feel the stresses of contemporary life fade away as this 173-villa resort takes you to a haven of unsurpassed serenity and relaxation, surrounded by nature''s pristine splendour. Lounging on pristine sun-kissed beaches, snorkelling amid colourful coral reefs in clear lagoons, and diving with marine critters in the ocean depths are all pure delights here.","Relax in the comfort of the island''s large villas, which have been thoughtfully constructed to blend in with their surroundings. At Li Bai, you may savour a fascinating world of exotic flavours ranging from Indian Ocean specialities to Mediterranean tapas and contemporary Cantonese cuisine. The resort''s unique Spa by Clarins health retreat, set in lush tropical gardens, promises a journey to blissful wellbeing for the ultimate in pampering.","Children are also well cared for, with a variety of Kids Club activities designed to keep young brains occupied and interested. On a marine exploration or garden ramble, uncover nature''s complicated eco-systems while gathering freshly produced vegetables from the resort''s own Earth Basket. Picnics on our private Castaway Island or at Dhigurah''s sister resort on neighbouring Falhumaafushi island, which you may reach through a one-kilometer bridge. The Residence Maldives at Dhigurah is the ideal hideaway you''ve been looking for, from romantic getaways to unforgettable family vacations.","With a lagoon-facing bedroom that opens out onto a big verandah and indoor and outdoor baths, these tastefully fitted villas have an intimate environment cocooned within the natural surroundings. Relax on the sun loungers beside your own pool, sipping a beverage and taking in the sense of total relaxation and the caress of the ocean air.","The Lagoon Pool Villas, which are located above the lagoon, provide a haven of peace and comfort. Immerse yourself in a magnificent bathroom experience that includes a huge bathtub as well as indoor and outdoor showers. Enjoy the picturesque surroundings from your private verandah and pool, as well as a private garden just outside your door."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1100, '1rqPO5YR71c', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'the-residence-maldives-at-dhigurah-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'the-residence-maldives-at-dhigurah-island-resort'
  and l.node_type = 'location' and l.slug = 'dhigurah'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'the-residence-maldives-at-dhigurah-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Pool Villa', 1100, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'the-residence-maldives-at-dhigurah-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 1340, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'the-residence-maldives-at-dhigurah-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Residence-Falhumaafushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'the-residence-maldives-at-falhumaafushi-island-resort', 'The Residence Maldives at Falhumaafushi Island Resort', 'The Residence Maldives is located on Falhumaafushi, a beautiful island in the Gaafu Alifu Atoll, one of the world''s biggest atolls. Indulge in our hidden retreat''s private island feeling, where nature''s unrivalled beauty forms a mesmerising background for your blissful relaxation.', 'published', 'The Residence Maldives at Falhumaafushi Island Resort | Maldives Resorts | MTG', 'The Residence Maldives is located on Falhumaafushi, a beautiful island in the Gaafu Alifu Atoll, one of the world''s biggest atolls. Indulge in our hidden retreat''s private island feeling, where nature''s unrivalled beauty forms a mesmerising background for your blissful relaxation.', '{"overview_paragraphs":["The Residence Maldives is located on Falhumaafushi, a beautiful island in the Gaafu Alifu Atoll, one of the world''s biggest atolls. Indulge in our hidden retreat''s private island feeling, where nature''s unrivalled beauty forms a mesmerising background for your blissful relaxation.","The Residence Maldives creates the time and space for you to rediscover the meaning of leisure, carefully taken care of by our attentive yet discreet hospitality. The resort was designed to be in sync with the natural environment, perfectly blending traditional Maldivian architecture with contemporary elegance and modern conveniences. Relax in the tranquilly of the resort''s beachfront and over-water villas, which provide a sanctuary only feet from the sand, or enjoy the delight of slipping directly from your deck into the cold, clear waters to reach your own private lagoon.","Embrace the destination with our one-of-a-kind culinary experiences and a plethora of activities ranging from sunbathing on sun-kissed beaches to snorkelling, island hopping, or seeing the incredible marine life at several local diving spots. Whether you''re looking for the ideal couple''s hideaway or a spectacular family vacation, let The Residence Maldives captivate you.","Experience the airy tranquilly of our Beach Villas, which are situated among peaceful flora along the glittering shoreline. Enjoy immediate beach access, a palm-fringed playground for your children, and a huge living area that opens out to a private terrace with magnificent ocean views.","Relax on the beach or by your private pool, just steps away from the luxurious internal amenities of this huge beachfront property with amazing ocean views. A great place to stay for families travelling together. Twin beds are available in the second bedroom.","Beautiful views of the water. Gentle waves lapping at your front door. In the shimmering seas beneath your feet, schools of fish fly across vibrant coral reefs. Such are the joys of our Water Villas, which each include a big living area that opens to a private verandah where you may bask in the Maldivian sun and marvel at the live aquarium right in front of your eyes."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 950, 'SE3hjQNVa-c', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'the-residence-maldives-at-falhumaafushi-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'the-residence-maldives-at-falhumaafushi-island-resort'
  and l.node_type = 'location' and l.slug = 'falhumaafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'the-residence-maldives-at-falhumaafushi-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 950, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'the-residence-maldives-at-falhumaafushi-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1100, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'the-residence-maldives-at-falhumaafushi-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 1250, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'the-residence-maldives-at-falhumaafushi-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Rihiveli
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'rihiveli-maldives', 'Rihiveli Maldives', 'Enjoy being outside, whether on the beach or on your private balcony. Do you want to get a tan, listen to fantastic music, dive among the magnificent aquatic life, or drink your favourite cocktail? Rihiveli Maldives Resort offers the finest of what the Maldives has to offer in a barefoot island environment. Allow yourself to truly appreciate the Maldives'' unparalleled and one-of-a-kind beauty.', 'published', 'Rihiveli Maldives | Maldives Resorts | MTG', 'Enjoy being outside, whether on the beach or on your private balcony. Do you want to get a tan, listen to fantastic music, dive among the magnificent aquatic life, or drink your favourite cocktail? Rihiveli Maldives Resort offers the finest of what the Maldives has to offer in a barefoot island environment. Allow yourself to truly appreciate the Maldives'' unparalleled and one-of-a-kind beauty.', '{"overview_paragraphs":["Enjoy being outside, whether on the beach or on your private balcony. Do you want to get a tan, listen to fantastic music, dive among the magnificent aquatic life, or drink your favourite cocktail? Rihiveli Maldives Resort offers the finest of what the Maldives has to offer in a barefoot island environment. Allow yourself to truly appreciate the Maldives'' unparalleled and one-of-a-kind beauty.","Charming bungalows with a sea view (sunrise or sunset side), wonderfully covered by palm palms, keeping the rooms cool.","The island is located in the Kaafu South Male atoll, 43 kilometres from the airport, and can be accessed by speed boat in 50 minutes.","Serene, light, and airy beach settings to start or end the day; to enjoy healthy flavours in an interactive presentation of many cuisines and innovative meals enhanced with local flavours and tropical tones. Relax, sip, savour, and enjoy yourself every day.","After a day of relaxing on Voavah''s magnificent coasts, treat yourself to a customised treatment at the Ocean of Consciousness - the island''s unique Spa. Our signature treatment, which includes breath preparation, a salt-and-crystal scrub, a bath soak, an awakening massage, and a fully immersive sound bath, harnesses the unlimited power of sound to connect you to the layers of awakened wisdom both inside and outside of you.","At Voavah, there are no neighbours, no paparazzi, and no limits on what you may do. Continue the music all night and commemorate a major milestone with a well-known performer. Make your own mini-Woodstock or Coachella on the beach, organise an incredible island-wide proposal trail, or turn the island into a wedding fantasy."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, null, 'CqbUr7mdR6w', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'rihiveli-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'rihiveli-maldives'
  and l.node_type = 'location' and l.slug = 'mahaanaelhihuraa'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'rihiveli-maldives'
on conflict (id) do nothing;

-- Robinson-Club
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'robinson-club-noonu-maldives-island-resort', 'Robinson Club Noonu Maldives Island Resort', 'Robinson Club Noonu, You''ll experience the Maldives in a whole new manner with ROBINSON, whether you''re barefoot on the sand at our famous Sundowner bar on the peninsula, tastefully attired in our Teppanyaki restaurant elevated on stilts, or on a dive over the stunning Noonu Atoll. Our all-inclusive "crafted by ROBINSON" package and our island''s easy accessibility from Malé (only 45 minutes) make it ideal for families. We hope to see you there!', 'published', 'Robinson Club Noonu Maldives Island Resort | Maldives Resorts | MTG', 'Robinson Club Noonu, You''ll experience the Maldives in a whole new manner with ROBINSON, whether you''re barefoot on the sand at our famous Sundowner bar on the peninsula, tastefully attired in our Teppanyaki restaurant elevated on stilts, or on a dive over the stunning Noonu Atoll. Our all-inclusive "crafted by ROBINSON" package and our island''s easy accessibility from Malé (only 45 minutes) make it ideal for families. We hope to see you there!', '{"overview_paragraphs":["Robinson Club Noonu, You''ll experience the Maldives in a whole new manner with ROBINSON, whether you''re barefoot on the sand at our famous Sundowner bar on the peninsula, tastefully attired in our Teppanyaki restaurant elevated on stilts, or on a dive over the stunning Noonu Atoll. Our all-inclusive \"crafted by ROBINSON\" package and our island''s easy accessibility from Malé (only 45 minutes) make it ideal for families. We hope to see you there!","The Robinson Club Noonu has 150 rooms, three restaurants, and two bars to keep you entertained during your stay.","The club situated on the island of Orivaru Noonu Atoll, some 200 kilometres north of Male International Airport. Transfer time: 45 minutes by seaplane from/to Male, or 35 minutes by domestic aircraft to Ifuru, followed by 45 minutes by speedboat.","Vegetarian dishes, vegan dinners, whole foods, food combining alternatives, gourmet plated meals, nutrition-conscious cuisine, lactose-free dishes, regional and seasonal produce. Meals tailored to individual dietary needs (e.g., allergies) in collaboration with the resort and based on area alternatives.","Dive locations with pristine coral reefs, club-owned reefs, and rare marine life. PADI organises the ROBINSON diving centre, and the instructors are trained in compliance with the applicable association requirements.","Snorkeling or diving: the Maldives are suitable for all types of underwater activities. Both services are offered for an extra fee at ROBINSON NOONU."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 300, 'UXjDrUMTT-Y', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'robinson-club-noonu-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'robinson-club-noonu-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'orivaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'robinson-club-noonu-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Room Seaview Balcony', 300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'robinson-club-noonu-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Bungalow', 530, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'robinson-club-noonu-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Overwater Pool Bungalow', 500, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'robinson-club-noonu-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Robinson-Maldives
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'robinson-club-maldives-island-resort', 'Robinson Club Maldives Island Resort', 'For some, this is Funamadua; for us, it is paradise: exotic underwater wonderland, white dream beach, sunsets that leave you speechless...it is no surprise that so many couples marry here. Even if you do not have a romantic wedding ceremony, you may have a memorable holiday in the Maldives, whether as a couple, with friends, or alone, whether lounging by the pool or snorkelling and diving together. Meet people from all over the world for a meet and greet with WellFit and beach volleyball, or wind off the day with a sundowner.', 'published', 'Robinson Club Maldives Island Resort | Maldives Resorts | MTG', 'For some, this is Funamadua; for us, it is paradise: exotic underwater wonderland, white dream beach, sunsets that leave you speechless...it is no surprise that so many couples marry here. Even if you do not have a romantic wedding ceremony, you may have a memorable holiday in the Maldives, whether as a couple, with friends, or alone, whether lounging by the pool or snorkelling and diving together. Meet people from all over the world for a meet and greet with WellFit and beach volleyball, or wind off the day with a sundowner.', '{"overview_paragraphs":["For some, this is Funamadua; for us, it is paradise: exotic underwater wonderland, white dream beach, sunsets that leave you speechless...it is no surprise that so many couples marry here. Even if you do not have a romantic wedding ceremony, you may have a memorable holiday in the Maldives, whether as a couple, with friends, or alone, whether lounging by the pool or snorkelling and diving together. Meet people from all over the world for a meet and greet with WellFit and beach volleyball, or wind off the day with a sundowner.","The Robinson Club features Garden Bungalows, Beach Bungalow Sea, and Beach Bungalow Sea, with more to come. Robinson Club has 121 rooms, 2 restaurants, and 3 bars to keep you entertained during your stay.","The Robinson Club is located on the island of Funamadua in the Gaaf Alif Atoll, approximately 60 kilometres north of the equator, and is surrounded by a beautiful, mostly undisturbed coral reef (the house reef is 20 to 200 metres away).","Breakfast, lunch, and supper buffets, late-night breakfast, Coffee specialities for breakfast, all beverages at the bar throughout the day (excluding selected wines, sparkling wines, spirits, and other specialties), soft drinks (branded drinks), beer, table wine, filter coffee, and tea available in the buffet area.","Allow yourself time and rest, and allow yourself to be treated according to all of the principles of the art. I treat myself to a health break, whether it''s a massage or a beauty treatment, in the sanarium or with a sauna infusion.","ROBINSON MALDIVES'' culinary highlights satisfy all senses - sample the most delectable meals every day. The best quality and utmost freshness are prioritised. Finish the night with cool beverages and exotic drinks while viewing the sunset."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 400, 'ctxxnGAKqlk', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'robinson-club-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'robinson-club-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'funamadua'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'robinson-club-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Bungalow', 400, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'robinson-club-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 500, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'robinson-club-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Royal-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'royal-island-premium-all-inclusive-maldives-island-resort', 'Royal Island Premium All Inclusive Maldives Island Resort', 'Your incredible All-Inclusive vacation begins here at Royal Island, which includes three daily meals at the main buffet style restaurant, beverages during and after meal times, and a variety of activities. Immerse yourself in a colourful voyage in the pristine and protected UNESCO Biosphere Reserve of Baa Atoll, whether you''re looking for calm or action. Unrivaled services and amenities, such as the exquisite Araamu Spa and a world-class range of restaurants and bars, are available. Discover infinite interactions with the natural environment while relaxing and recharging in one of the world''s most wonderful settings.', 'published', 'Royal Island Premium All Inclusive Maldives Island Resort | Maldives Resorts | MTG', 'Your incredible All-Inclusive vacation begins here at Royal Island, which includes three daily meals at the main buffet style restaurant, beverages during and after meal times, and a variety of activities. Immerse yourself in a colourful voyage in the pristine and protected UNESCO Biosphere Reserve of Baa Atoll, whether you''re looking for calm or action. Unrivaled services and amenities, such as the exquisite Araamu Spa and a world-class range of restaurants and bars, are available. Discover infinite interactions with the natural environment while relaxing and recharging in one of the world''s most wonderful settings.', '{"overview_paragraphs":["Your incredible All-Inclusive vacation begins here at Royal Island, which includes three daily meals at the main buffet style restaurant, beverages during and after meal times, and a variety of activities. Immerse yourself in a colourful voyage in the pristine and protected UNESCO Biosphere Reserve of Baa Atoll, whether you''re looking for calm or action. Unrivaled services and amenities, such as the exquisite Araamu Spa and a world-class range of restaurants and bars, are available. Discover infinite interactions with the natural environment while relaxing and recharging in one of the world''s most wonderful settings.","Royal Island villas are secluded luxury getaways in the middle of nature, giving breathtaking sunrise and sunset views while only steps away from the pure white beach and blue lagoon. Each house is thoughtfully built with rich and colourful aesthetics, stunning marble features, and elaborately carved wooden furnishings, with a focus on laid-back luxury. At Royal Island Resort & Spa, you may embrace independence and tropical tranquillity.","Royal Island Resort, located in the Baa Atoll, is only a 20-minute domestic flight from Velana International Airport. This resort is nearly 800 m long and 220 m wide, and offers the ideal holiday destination, set amongst lush tropical vegetation and perfect untouched beaches, and surrounded by the beautiful lagoon shimmering under the tropical sun.","Enjoy traditional Maldivian delicacies as well as exquisite cuisine from all around the world. Dine alfresco beneath a beautiful star-studded sky or in the traditional elegance of our Asian-style restaurant with breathtaking views of the Indian Ocean. Make memories that will last a lifetime by dancing the night away with friends and family at one of our chic pubs.","Araamu Spa will transport you to a tropical paradise. Discover a world of relaxation and tranquillity in the midst of beautiful coconut palms and tropical greenery. Indulge in a variety of Asian-inspired therapies meant to refresh and rejuvenate mind and body. Aromatherapy, reflexology, body wraps, and luxury pedicures and manicures are among the signature services.","Discover a plethora of resort activities and bucket-list adventures in a naturalist''s paradise. In the magnificent UNESCO Biosphere Reserve of Baa Atoll, where lush nature meets the dazzling waves of the Indian Ocean, really unique activities await. Soar high above the turquoise waves on a thrilling parasailing trip, dine on a sumptuous meal on a secluded sandbank, or unwind at Araamu Spa."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 300, 'YBSyiXv-LBQ', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'royal-island-premium-all-inclusive-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'royal-island-premium-all-inclusive-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'horubadhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'royal-island-premium-all-inclusive-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'royal-island-premium-all-inclusive-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Two Bedroom Family Beach Villa', 900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'royal-island-premium-all-inclusive-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- SAii-Lagoon
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'saii-lagoon-maldives-island-resort', 'Saii Lagoon Maldives Island Resort', 'The large and elegant Sky Rooms on the upper level of SAii have an indoor chill-out space, comfy bespoke furniture, and private balconies that surround the peaceful Indian Ocean and the stunning views of the Maldives island hotel. The bathroom has a double basin, a rainshower, and natural bathing items that visitors can personalise at the M.I.Y. Aroma Lab.', 'published', 'Saii Lagoon Maldives Island Resort | Maldives Resorts | MTG', 'The large and elegant Sky Rooms on the upper level of SAii have an indoor chill-out space, comfy bespoke furniture, and private balconies that surround the peaceful Indian Ocean and the stunning views of the Maldives island hotel. The bathroom has a double basin, a rainshower, and natural bathing items that visitors can personalise at the M.I.Y. Aroma Lab.', '{"overview_paragraphs":["The large and elegant Sky Rooms on the upper level of SAii have an indoor chill-out space, comfy bespoke furniture, and private balconies that surround the peaceful Indian Ocean and the stunning views of the Maldives island hotel. The bathroom has a double basin, a rainshower, and natural bathing items that visitors can personalise at the M.I.Y. Aroma Lab.","Our Maldives Overwater Villas are spacious villas positioned over the water for easy dips into the ocean, with welcoming, modern rustic décor, tailor-made furnishings, and big furnished terraces with a lounging net and a bathtub, all drenched in stunning seascapes. Signature beds invite rest and replenishment, while en-suite bathrooms with double basins and waterfall showers promote relaxing lavation.","The décor will be calming, with natural tones and textures. Complimentary Wi-Fi, HDTVs, complimentary tea and coffee, huge bathrooms with waterfall showers, and furnished decks or balconies with ocean views will be among the in-room amenities. Beach villas will have more room, whereas overwater villas will be surrounded by blue water. The two-bedroom overwater villas with breathtaking ocean views include private pools and are ideal for families or groups of friends.","A unique and fascinating new resort experience awaits in the Maldives, approximately 15 minutes by speed boat from Velana International Airport. SAii Lagoon Maldives is a cerulean hideaway designed for couples, families, and friends looking for a fun holiday getaway.","It is our joy to please you with a cool blend of thrills, sensations, and inspirations when you stay the SAii way. Whether you are looking for comfort cuisine, inventive tastes, inspired mixology, or a cause to party, SAii delights blend an exciting mix of culinary and lifestyle trends to deliver unique experiences that attach to your soul and make your trip complete at our Maldives restaurants. Not to mention a range of eating options, including one of Asia''s 50 Best Restaurants, which is only a 5-minute walk away at The Marina @ CROSSROADS Maldives and will take you on an unforgettable gastronomic trip.","The Maldives'' first free-standing double-story spa and wellness facility, offering quick and easy foot and neck massages as well as more extensive treatments. Lèn Be Well introduces a novel wellness concept that includes remarkable new degrees of relaxation, spa treatments, holistic activities, and gastronomic pleasures. Allow the aura of serenity and joy to wash over you as you indulge in some ultimate pampering and a full journey of wellbeing."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 500, '1HZWfy0F1-Y', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'saii-lagoon-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'saii-lagoon-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'embudu-finolhu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'saii-lagoon-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sky Room', 500, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'saii-lagoon-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Overwater Villa', 950, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'saii-lagoon-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Safari-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'safari-island-resort-and-spa-maldives', 'Safari Island Resort and Spa Maldives', 'Safari Island is located in the Republic of Maldives'' North Ari Atoll. The island is roughly 30,000 square metres in size. The island is around 60 kilometres from Velana International Airport (Male'' International Airport) and takes about 25 minutes to arrive by seaplane. The island is bordered by white powdery, sandy beaches, a crystal clear water lagoon, and a house reef that is ideal for snorkelling and diving.', 'published', 'Safari Island Resort and Spa Maldives | Maldives Resorts | MTG', 'Safari Island is located in the Republic of Maldives'' North Ari Atoll. The island is roughly 30,000 square metres in size. The island is around 60 kilometres from Velana International Airport (Male'' International Airport) and takes about 25 minutes to arrive by seaplane. The island is bordered by white powdery, sandy beaches, a crystal clear water lagoon, and a house reef that is ideal for snorkelling and diving.', '{"overview_paragraphs":["Safari Island is located in the Republic of Maldives'' North Ari Atoll. The island is roughly 30,000 square metres in size. The island is around 60 kilometres from Velana International Airport (Male'' International Airport) and takes about 25 minutes to arrive by seaplane. The island is bordered by white powdery, sandy beaches, a crystal clear water lagoon, and a house reef that is ideal for snorkelling and diving.","Beach room with a deluxe en suite bathroom that has panoramic glass mirrors and twin wash basins. The room has a full glass door that leads to a private wooden porch with seats.","Overwater villas with a beautiful glass-bottomed coffee table. Back private sun deck going to blue lagoon.","On one end of the island, a line of 15 Semi-Water Bungalows runs. A jetty at the other end leads to 39 Water Bungalows. The 30 Beach Bungalows are located on an island surrounded by beautiful green flora, including palm palms. All 84 rooms have a sea view.","It is around 60 kilometres from Velana International Airport and takes about 25 minutes to get by seaplane.","Tropical haven Safari Island is a must-see destination in the Maldives. A visit to our great restaurant, an icon in the Maldives, would not be complete without a tour. The main restaurant, shaded by a spectacular white canopy and floating over the lagoon, serves breakfast, lunch, and supper in an all-you-can-eat buffet format with a range of international and regional cuisines to accommodate everyone''s taste."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 230, 'runiGf6kyVA', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'safari-island-resort-and-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'safari-island-resort-and-spa-maldives'
  and l.node_type = 'location' and l.slug = 'mushimasgali'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'safari-island-resort-and-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 230, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'safari-island-resort-and-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Bungalow', 300, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'safari-island-resort-and-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- Sheraton
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'sheraton-maldives-full-moon-resort-spa-island', 'Sheraton Maldives Full Moon Resort & Spa Island', 'We encourage you to enjoy all that the Sheraton Maldives Full Moon Resort & Spa has to offer from a beautiful 360° panoramic view. Plan your next holiday with your loved ones by exploring our stunning white sand beaches, lush tropical vegetation, over-water homes, and so much more. We travel not to escape life, but to prevent life from escaping us. Bring your loved ones and create wonderful moments. Explore the Maldives with your family, set among beautiful tropical gardens and outfitted with modern conveniences such as an outdoor garden shower and a big terrace with a garden, beach, or plunge pool view. Those who wish to stay near the water may be interested in our water villas and bungalows. There is a private plunge pool option available.', 'published', 'Sheraton Maldives Full Moon Resort & Spa Island | Maldives Resorts | MTG', 'We encourage you to enjoy all that the Sheraton Maldives Full Moon Resort & Spa has to offer from a beautiful 360° panoramic view. Plan your next holiday with your loved ones by exploring our stunning white sand beaches, lush tropical vegetation, over-water homes, and so much more. We travel not to escape life, but to prevent life from escaping us. Bring your loved ones and create wonderful moments. Explore the Maldives with your family, set among beautiful tropical gardens and outfitted with modern conveniences such as an outdoor garden shower and a big terrace with a garden, beach, or plunge pool view. Those who wish to stay near the water may be interested in our water villas and bungalows. There is a private plunge pool option available.', '{"overview_paragraphs":["We encourage you to enjoy all that the Sheraton Maldives Full Moon Resort & Spa has to offer from a beautiful 360° panoramic view. Plan your next holiday with your loved ones by exploring our stunning white sand beaches, lush tropical vegetation, over-water homes, and so much more. We travel not to escape life, but to prevent life from escaping us. Bring your loved ones and create wonderful moments. Explore the Maldives with your family, set among beautiful tropical gardens and outfitted with modern conveniences such as an outdoor garden shower and a big terrace with a garden, beach, or plunge pool view. Those who wish to stay near the water may be interested in our water villas and bungalows. There is a private plunge pool option available.","The Sheraton Maldives Full Moon Resort is a 5-star beach resort with 176 guest rooms ranging from beach huts to over water villas, all decorated in a tropical manner. With the greatest facilities, slipping into the rhythm of exquisite island living this side of heaven has never been easier. Enjoy the fantastic pool and nicely equipped suites.","Sheraton Maldives Full Moon Resort is conveniently positioned on Furanafushi Island in North Male'' Atoll, about 15-20 minutes from Velana International Airport and 1 km from the next populated island.","We eat first, then we do everything else. The lovely sound of the ocean sets the tone for a romantic evening at Sea Salt, which provides courteous illuminated beach dining. Anchorage offers conventional pizzas, amazing salads, and Mediterranean favourites that are ideal for sharing while watching the sunset. The resort''s buffet dining area, Feast, offers a diverse selection with interactive cooking stations. We recommend Baan Thai, our traditional Thai restaurant, or Masala Hut, our Indian restaurant, for bold tastes. Kakuni Hut is our Caribbean-inspired restaurant that serves fresh tacos, sweets, and handcrafted drinks. ChopstiX is ideal for a late meal, with handmade dumplings and filling noodle bowls. Take a gastronomic adventure with our destination dining for a unique experience.","Escape to paradise at our Maldives resort hotel on North Malé Atoll''s newly remodelled Shine Spa for SheratonTM. On a secluded island with sea views, verdant gardens, and a yoga pavilion, rejuvenate with specialty treatments in your own spa pavilion.","Everything is available at Sheraton Maldives Full Moon Resort & Spa, with its azure blue oceans, exotic islands, and gorgeous sunsets, from sandbank picnics to sunset excursions for two."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 500, 'ogVBxqQp3y4', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'sheraton-maldives-full-moon-resort-spa-island'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'sheraton-maldives-full-moon-resort-spa-island'
  and l.node_type = 'location' and l.slug = 'furanafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'sheraton-maldives-full-moon-resort-spa-island'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Front Deluxe', 500, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'sheraton-maldives-full-moon-resort-spa-island'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Bungalow', 900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'sheraton-maldives-full-moon-resort-spa-island'
on conflict (accommodation_id, name) do nothing;

-- Six-Senses-Kanuhura
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'six-senses-kanuhura-maldives-private-island', 'Six Senses Kanuhura Maldives Private Island', 'This is an exciting time in Kanuhura''s lengthy history since we will be incorporating new wellness, sustainability, and conservation efforts into our everyday operations, as well as locally inspired experiences and activities. Kokaa Spa will become a Six Senses Spa, adopting the brand''s high-touch, high-tech approach to health, while our restaurants will follow the Eat With Six Senses concept of natural, local, and sustainable products, and less is more. This will mark the start of a new chapter in the resort''s history, which we are very eager to reveal later this year.', 'published', 'Six Senses Kanuhura Maldives Private Island | Maldives Resorts | MTG', 'This is an exciting time in Kanuhura''s lengthy history since we will be incorporating new wellness, sustainability, and conservation efforts into our everyday operations, as well as locally inspired experiences and activities. Kokaa Spa will become a Six Senses Spa, adopting the brand''s high-touch, high-tech approach to health, while our restaurants will follow the Eat With Six Senses concept of natural, local, and sustainable products, and less is more. This will mark the start of a new chapter in the resort''s history, which we are very eager to reveal later this year.', '{"overview_paragraphs":["This is an exciting time in Kanuhura''s lengthy history since we will be incorporating new wellness, sustainability, and conservation efforts into our everyday operations, as well as locally inspired experiences and activities. Kokaa Spa will become a Six Senses Spa, adopting the brand''s high-touch, high-tech approach to health, while our restaurants will follow the Eat With Six Senses concept of natural, local, and sustainable products, and less is more. This will mark the start of a new chapter in the resort''s history, which we are very eager to reveal later this year.","20 January 2022 - Our second Maldives resort, which will open in December 2022, has three white-sanded private islands, two of which are uninhabited, giving the ultimate choice of where to hang your hammock.","The Lhaviyani Atoll has about 40 diving spots where you may explore marine life. Through our relationship with Ocean Wings, additional watersport activities and high-performance equipment will be offered in the coming months. There will be a variety of events to excite people about the significance of ocean conservation, from touring the coasts of Jehunuhura Island to getting hands-on with coral and seagrass protection."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 540, 'CqbUr7mdR6w', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'six-senses-kanuhura-maldives-private-island'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'six-senses-kanuhura-maldives-private-island'
  and l.node_type = 'location' and l.slug = 'kanuhura'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'six-senses-kanuhura-maldives-private-island'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Villa', 540, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'six-senses-kanuhura-maldives-private-island'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunset Pool Villa', 739, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'six-senses-kanuhura-maldives-private-island'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Villa', 775, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'six-senses-kanuhura-maldives-private-island'
on conflict (accommodation_id, name) do nothing;

-- Siyam-World
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'siyam-world-maldives-island-resort', 'Siyam World Maldives Island Resort', 'Siyam World is a stunning new picture of the Maldives'' rich natural beauties, a carefree playground with an intriguing, diversified, and never-before-seen assortment of ''never-seen-before'' experiences guaranteed to leave you speechless. Premium An all-inclusive island vacation that bridges cultures and boundaries. Designed for fun-loving, open-minded couples, romance seekers, families, or bigger groups of friends who like to wander, socialise, and participate in an island community. Siyam World is one of the Maldives'' biggest islands, including a resort and spectacular villas - The Beach House Collection.', 'published', 'Siyam World Maldives Island Resort | Maldives Resorts | MTG', 'Siyam World is a stunning new picture of the Maldives'' rich natural beauties, a carefree playground with an intriguing, diversified, and never-before-seen assortment of ''never-seen-before'' experiences guaranteed to leave you speechless. Premium An all-inclusive island vacation that bridges cultures and boundaries. Designed for fun-loving, open-minded couples, romance seekers, families, or bigger groups of friends who like to wander, socialise, and participate in an island community. Siyam World is one of the Maldives'' biggest islands, including a resort and spectacular villas - The Beach House Collection.', '{"overview_paragraphs":["Siyam World is a stunning new picture of the Maldives'' rich natural beauties, a carefree playground with an intriguing, diversified, and never-before-seen assortment of ''never-seen-before'' experiences guaranteed to leave you speechless. Premium An all-inclusive island vacation that bridges cultures and boundaries. Designed for fun-loving, open-minded couples, romance seekers, families, or bigger groups of friends who like to wander, socialise, and participate in an island community. Siyam World is one of the Maldives'' biggest islands, including a resort and spectacular villas - The Beach House Collection.","Are there any sunset chasers around? Sunset Pool Beach Villas are located on the beachfront and have easy access to the beach where you may sway into the sunset on a fun fox swing. Take use of a private pool, a mini bar, Wi-Fi, a bathroom with a bathtub, and indoor and outdoor showers. Isn''t it amazing?","These unique Water Villas provide your own private pool as well as a fun slide. Ideal for people who enjoy having a little fun on their vacations in order to create great memories. Enjoy your private sundeck with sun loungers, a bathroom with an indoor shower, a mini bar, Wi-Fi, and breathtaking views. We believe that sliding into the lagoon is more enjoyable.","Our villas are located right on the beach. All of the villas are on the beach or on stilts over the lagoon, and half have their own pool. They not only provide excellent amenities, but also a high level of seclusion - while you sleep, rest, and wash outside. Dreams come true at our villas, which have been identified as being among the top Maldives island resorts!","Located in the famous Noonu Atoll, the resort is only a 45-minute direct seaplane journey or a 40-minute domestic flight from Maafaru International Airport, followed by a 10-minute speedboat ride.","Tempo, located east of the island and set on a gorgeous beach terrace, serves a variety of world cuisines. This casual dining restaurant serves a worldwide marketplace of scents and sensations in a buffet format with live cooking stations."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 700, 'FPEuNEfCHv8', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'siyam-world-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'siyam-world-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'iru-fushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'siyam-world-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunset Beach Pool Villa', 750, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'siyam-world-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Pool Villa Slide', 700, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'siyam-world-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Soneva-Jani
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'soneva-jani-maldives-island-resort', 'Soneva Jani Maldives Island Resort', 'Soneva Jani is tucked away in the calm waters of the Noonu Atoll, where sun-drenched blue sky and turquoise seas reach out in every direction. There are only 51 over-water and three island properties, the largest and most luxury villas in the Maldives, each constructed for utmost seclusion, space, and stunning ocean views. Relax in one of the renowned Water or Island Villas for the ultimate in luxury.', 'published', 'Soneva Jani Maldives Island Resort | Maldives Resorts | MTG', 'Soneva Jani is tucked away in the calm waters of the Noonu Atoll, where sun-drenched blue sky and turquoise seas reach out in every direction. There are only 51 over-water and three island properties, the largest and most luxury villas in the Maldives, each constructed for utmost seclusion, space, and stunning ocean views. Relax in one of the renowned Water or Island Villas for the ultimate in luxury.', '{"overview_paragraphs":["Soneva Jani is tucked away in the calm waters of the Noonu Atoll, where sun-drenched blue sky and turquoise seas reach out in every direction. There are only 51 over-water and three island properties, the largest and most luxury villas in the Maldives, each constructed for utmost seclusion, space, and stunning ocean views. Relax in one of the renowned Water or Island Villas for the ultimate in luxury.","Villa 34''s one-of-a-kind design is inspired by nature''s graceful, undulating curves. This three-bedroom seaside mansion is 1,956 square metres in size, with no straight lines in sight. It contains a freshwater swimming pool as well as a children''s pool with a water slide. By the pool, there is also a children''s treehouse.","The One Bedroom Water Retreat is spread across two stories and includes a private pool surrounded by plenty of space for sunbathing and admiring the ocean views. With the retractable roof of the villa, you can see the stars from the luxury of your master bedroom.","Our magnificent overwater and island villas are all built to provide maximum room, seclusion, and breathtaking views. Our 51 Water Villas, which range in size from one to four bedrooms, all include private pools, waterslides into the lagoon, and a retractable roof over the master bedroom. Our three Island Reserves are just feet from the beach and include private pools as well as ample interior and outdoor living space.","Soneva Jani is a five-island resort in Noonu Atoll''s Medhufaru lagoon, the largest of which is Medhufaru, which is 150 acres in size. The resort is accessible by a spectacular 40-minute seaplane trip from Malé International Airport. Furthermore, the resort is accessible through a 60-minute speedboat journey from Soneva Fushi, or with a relaxing full-day cruise aboard Soneva in Aqua from Soneva Fushi.","Discover all of our eating options and experiences at Soneva Jani and the pristine islands that surround us. Our Hosts would gladly personalise each experience for a special event, celebration, or simply because."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 4200, 'f3smYTocVT0', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'soneva-jani-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'soneva-jani-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'medhufaru'
on conflict (node_id, location_id) do nothing;
