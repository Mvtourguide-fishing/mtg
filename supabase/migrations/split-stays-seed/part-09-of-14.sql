-- Part 9 of 14 - run this in the Supabase SQL Editor AFTER the previous parts.
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

-- Outrigger-Konotta
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'outrigger-konotta-maldives-island-resort', 'Outrigger Konotta Maldives Island Resort', 'Outrigger Konotta Maldives Resort offers full solitude and intimate luxury among the beautiful seas of Gaafu Dhaalu Atoll. Outrigger hospitality is unrivalled in this haven of superb over-water villas, inventive Maldivian cuisine, the relaxing Navasana Spa, reef adventure, and stunning sea life.', 'published', 'Outrigger Konotta Maldives Island Resort | Maldives Resorts | MTG', 'Outrigger Konotta Maldives Resort offers full solitude and intimate luxury among the beautiful seas of Gaafu Dhaalu Atoll. Outrigger hospitality is unrivalled in this haven of superb over-water villas, inventive Maldivian cuisine, the relaxing Navasana Spa, reef adventure, and stunning sea life.', '{"overview_paragraphs":["Outrigger Konotta Maldives Resort offers full solitude and intimate luxury among the beautiful seas of Gaafu Dhaalu Atoll. Outrigger hospitality is unrivalled in this haven of superb over-water villas, inventive Maldivian cuisine, the relaxing Navasana Spa, reef adventure, and stunning sea life.","Outrigger Konotta Maldives Resort offers ultimate solitude and intimate luxury with 21 Beach Pool Villas, 21 Ocean Pool Villas, 8 Two Bedroom Beach Pool Villas, 2 Lagoon Pool Villas, and the Grand Konotta Villa.","Outrigger Konotta Maldives Resort is located on Konotta, a private island in the Gaafu Dhaalu Atoll, 340 kilometres south of Male'' and easily accessible through a 55-minute flight to Kaadedhdhoo Airport (KDM), followed by a spectacular 30-minute speed boat ride."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, null, 'eZFc1P6ivgw', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'outrigger-konotta-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'outrigger-konotta-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'konotta'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'outrigger-konotta-maldives-island-resort'
on conflict (id) do nothing;

-- Outrigger-Maafushivaru
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'outrigger-maldives-maafushivaru-resort-island', 'Outrigger Maldives Maafushivaru Resort Island', 'Outrigger Maldives Maafushivaru Resort is located on the picturesque South Ari Atoll, just a 25-minute seaplane ride from Male. You''ll be surrounded by kilometres of the Maldives'' signature blue seas. This resort is located on a 350-metre-long island that is partially sheltered by thick foliage and surrounded by beautiful beaches adjacent to a stunning house reef.', 'published', 'Outrigger Maldives Maafushivaru Resort Island | Maldives Resorts | MTG', 'Outrigger Maldives Maafushivaru Resort is located on the picturesque South Ari Atoll, just a 25-minute seaplane ride from Male. You''ll be surrounded by kilometres of the Maldives'' signature blue seas. This resort is located on a 350-metre-long island that is partially sheltered by thick foliage and surrounded by beautiful beaches adjacent to a stunning house reef.', '{"overview_paragraphs":["Outrigger Maldives Maafushivaru Resort is located on the picturesque South Ari Atoll, just a 25-minute seaplane ride from Male. You''ll be surrounded by kilometres of the Maldives'' signature blue seas. This resort is located on a 350-metre-long island that is partially sheltered by thick foliage and surrounded by beautiful beaches adjacent to a stunning house reef.","Our beach villas are self-contained and positioned directly near the beach, surrounded by lush greenery, with sun loungers on a private balcony facing the sea.","The beach pool villas have king-sized bedrooms, a modern distinctive silver glass crystal tiled bathroom, a twin vanity, and separate indoor and outdoor showers in your own garden.","Luxury villas with contemporary conveniences and unique lagoon views. The large bedroom has a king-sized bed and a daybed.","Maafushivaru has 81 villas in various types, all with direct access to the beach or great views of the ocean. The villas are well-appointed but basic in style and architecture, combining in wonderfully with the Maldives'' laid-back atmosphere. All are well equipped with everything you need for a comfortable vacation near to nature.","Maafushivaru, located 93 kilometres from the airport in the beautiful South Ari Atoll, provides five various types of villas, each blending features of Maldivian architecture with elegant and trendy finishing touches, and appeals to couples seeking romantic pursuits. Allow Maafushivaru to assist you in creating memories that will last a lifetime."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 900, 'pN2jDp7fIA0', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'outrigger-maldives-maafushivaru-resort-island'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'outrigger-maldives-maafushivaru-resort-island'
  and l.node_type = 'location' and l.slug = 'maafushivaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'outrigger-maldives-maafushivaru-resort-island'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 950, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'outrigger-maldives-maafushivaru-resort-island'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1100, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'outrigger-maldives-maafushivaru-resort-island'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Villa', 900, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'outrigger-maldives-maafushivaru-resort-island'
on conflict (accommodation_id, name) do nothing;

-- Ozen-Reserve-Bolifushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'ozen-reserve-bolifushi-maldives-island-resort', 'Ozen Reserve Bolifushi Maldives Island Resort', 'OZEN RESERVE BOLIFUSHI brings to life your fantasies of Maldives 5-star resorts. The exclusive island resort embodies elegance, flair, and timeless sophistication, surrounded by a stunning natural reef and blue seas. Every experience is precisely created to pamper you with an extraordinary break, from stunning overwater villas with slides to exotic gourmet dining and ice skating by the beach.', 'published', 'Ozen Reserve Bolifushi Maldives Island Resort | Maldives Resorts | MTG', 'OZEN RESERVE BOLIFUSHI brings to life your fantasies of Maldives 5-star resorts. The exclusive island resort embodies elegance, flair, and timeless sophistication, surrounded by a stunning natural reef and blue seas. Every experience is precisely created to pamper you with an extraordinary break, from stunning overwater villas with slides to exotic gourmet dining and ice skating by the beach.', '{"overview_paragraphs":["OZEN RESERVE BOLIFUSHI brings to life your fantasies of Maldives 5-star resorts. The exclusive island resort embodies elegance, flair, and timeless sophistication, surrounded by a stunning natural reef and blue seas. Every experience is precisely created to pamper you with an extraordinary break, from stunning overwater villas with slides to exotic gourmet dining and ice skating by the beach.","Enjoy the stunning sunset views from this peaceful, expansive, and elegantly elegant retreat. These beautiful tropical havens are ideal for all types of travellers, including small families, couples, and groups of friends. They provide the ideal Maldivian retreat! Earth Pool Villa Sunset is a tropical oasis built for all sorts of visitors, from small families and groups of friends to couples searching for an unique Maldivian holiday.","The mystical Indian Ocean is just a few feet away from the Ocean Pool Suite. Its vast outside terrace, surrounded by the lagoon, is a real haven for calm sunbathing or relaxing stargazing beneath shimmering sky. It has a private infinity pool, sunken seats, an overwater hammock, and a few stairs going down to the cerulean lagoon bubbling below. This is the ultimate way to feel the Maldives'' real essence! If the outside is paradise, the inside is just as gorgeous. This beautiful house is finished with a teak floor, colourful tropical furnishings, and sophisticated décor.","The 5-star villas at Ozen Reserve Bolifushi have an open-concept plan that allows guests to enjoy the spectacular sea views and pleasant breezes. There are 43 beach villas and suites, 46 water villas and ocean suites, and 1 Royal Residence in the resort. Every villa has its own pool and direct access to the beach or lagoon. Not to add that there is free WiFi in the rooms.","This tranquil island resort retreat is only a 20-minute boat trip from Velana International Airport. This is a luxurious hideaway that is easily accessible, located on the south side of Male Atoll. You''ll discover large lengths of white sandy beaches and clear seas at Ozen Reserve Bolifushi, providing a magnificent vision for you to gaze upon while you let the leisurely joys of life take over.","A world of captivating culinary surprises greets each guest at OZEN RESERVE BOLIFUSHI. Enjoy customised dining experiences in Maldivian beauty, with breathtaking views of the Indian Ocean from each. For an exquisite culinary experience, choose from three specialty restaurants, an all-day dining restaurant, and two pubs. Our enthusiastic chefs create meals and delectable dishes using the freshest produce from our Chef''s Garden, which they individually handpick. So sit back, relax, and enjoy this delightful adventure at our resort!"]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1900, 'il6USSNhBDY', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'ozen-reserve-bolifushi-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'ozen-reserve-bolifushi-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'bolifushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'ozen-reserve-bolifushi-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Earth Pool Villa Sunset', 1900, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'ozen-reserve-bolifushi-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ocean Pool Suite', 2000, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'ozen-reserve-bolifushi-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Palm-Beach
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'palm-beach-island-resort-spa-maldives', 'Palm Beach Island Resort & Spa Maldives', 'The 4-star Palm Beach Island Resort & Spa Maldives Lhaviyani Atoll is located near Madhiriguraidhoo Island and offers medical services, 24-hour cleaning, and wake-up calls. Fushifaru Thila is 3.1 km away, while Palm Beach Resort & Spa is 0.5 km distant. The rooms include a private safe, Wi-Fi, and a work desk, as well as an electric kettle, glasses, and coffee/tea making facilities for cooking. Some flats have views of the garden. A spa bathtub, a hair dryer, and towels are also available to guests.', 'published', 'Palm Beach Island Resort & Spa Maldives | Maldives Resorts | MTG', 'The 4-star Palm Beach Island Resort & Spa Maldives Lhaviyani Atoll is located near Madhiriguraidhoo Island and offers medical services, 24-hour cleaning, and wake-up calls. Fushifaru Thila is 3.1 km away, while Palm Beach Resort & Spa is 0.5 km distant. The rooms include a private safe, Wi-Fi, and a work desk, as well as an electric kettle, glasses, and coffee/tea making facilities for cooking. Some flats have views of the garden. A spa bathtub, a hair dryer, and towels are also available to guests.', '{"overview_paragraphs":["The 4-star Palm Beach Island Resort & Spa Maldives Lhaviyani Atoll is located near Madhiriguraidhoo Island and offers medical services, 24-hour cleaning, and wake-up calls. Fushifaru Thila is 3.1 km away, while Palm Beach Resort & Spa is 0.5 km distant. The rooms include a private safe, Wi-Fi, and a work desk, as well as an electric kettle, glasses, and coffee/tea making facilities for cooking. Some flats have views of the garden. A spa bathtub, a hair dryer, and towels are also available to guests.","Choose from a selection of magnificent Villas and Suites that provide a hidden hideaway among lush tropical foliage while gazing over the beautiful colours of a setting sun or the serene splendour of morning coming.","On your picturesque 40-minute seaplane ride to Lhaviyani Atoll and onto infinite expanses of immaculate white beach set by groves of coconut palms rustling softly to the beat of tropical winds, gaze at jewel tones of turquoise, jade, and bright tones across the Maldives archipelago."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, null, 'zS3TfPEFOcc', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'palm-beach-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'palm-beach-island-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'madhiriguraidhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'palm-beach-island-resort-spa-maldives'
on conflict (id) do nothing;

-- Park-Hyatt
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'park-hyatt-maldives-hadahaa-island-resort', 'Park Hyatt Maldives Hadahaa Island Resort', 'Explore the natural beauty of the remote Huvadhoo Atoll, whether as a ''castaway'' learning essential survival skills before feasting on a BBQ of fresh fish from the lagoon, picnicking on a remote uninhabited island, or snorkelling and diving among sea turtles, black tip reef sharks, barracudas, spotted eagle rays, and colourful tropical fish species. Engaging children''s activities immersed in nature''s playground, as well as a deeper dive into the ocean and marine life preservation at the Blue Journeys Dive and Activity Center, provide insights into long-term projects to protect the endangered ecosystem and traditional Maldivian way of life. Exquisite culinary excursions await at sophisticated but relaxed restaurant, bar, and lounge options, as well as amazing personalised private dining.', 'published', 'Park Hyatt Maldives Hadahaa Island Resort | Maldives Resorts | MTG', 'Explore the natural beauty of the remote Huvadhoo Atoll, whether as a ''castaway'' learning essential survival skills before feasting on a BBQ of fresh fish from the lagoon, picnicking on a remote uninhabited island, or snorkelling and diving among sea turtles, black tip reef sharks, barracudas, spotted eagle rays, and colourful tropical fish species. Engaging children''s activities immersed in nature''s playground, as well as a deeper dive into the ocean and marine life preservation at the Blue Journeys Dive and Activity Center, provide insights into long-term projects to protect the endangered ecosystem and traditional Maldivian way of life. Exquisite culinary excursions await at sophisticated but relaxed restaurant, bar, and lounge options, as well as amazing personalised private dining.', '{"overview_paragraphs":["Explore the natural beauty of the remote Huvadhoo Atoll, whether as a ''castaway'' learning essential survival skills before feasting on a BBQ of fresh fish from the lagoon, picnicking on a remote uninhabited island, or snorkelling and diving among sea turtles, black tip reef sharks, barracudas, spotted eagle rays, and colourful tropical fish species. Engaging children''s activities immersed in nature''s playground, as well as a deeper dive into the ocean and marine life preservation at the Blue Journeys Dive and Activity Center, provide insights into long-term projects to protect the endangered ecosystem and traditional Maldivian way of life. Exquisite culinary excursions await at sophisticated but relaxed restaurant, bar, and lounge options, as well as amazing personalised private dining.","Our 165-square-meter villas have a king bed with chaise lounge, a private deck with table and chairs, loungers, an indoor and outdoor shower area with terrazzo bathtub and rain shower, and direct beach access.","Our 180-square-meter villas have a king bed, a chaise lounge overlooking a private plunge pool and balcony, an indoor and outdoor shower room with terrazzo bathtub and rain shower area, and direct beach access.","Relax in our 115 sq m water villas, which include 180° views of the ocean, a king bed, an indoor bathtub, a sun porch with a daybed, and direct access to the house reef.","This resort has 51 villas, each having a private deck with table and chairs, an outdoor garden bathroom with bathtub and rain shower, and private beach access with two sun loungers. The Deluxe Beach Pool Villas and Two Bedroom Beach Pool Villas have a private 55 sq m (592 sq ft) luxury plunge pool, as well as an outside bale/cabana with table and chairs. Overwater Sunset Pool Villas include their own freshwater plunge pool and outdoor cabana. From the private terrace outside, all water villas have stunning panoramic ocean views and individual access to the coral-filled seas below. Every villa has a personal home entertainment system, a digital media centre, an in-villa iPad with an interactive resort compendium, a flat-screen television, a DVD player, and a CD player.","Guests take a pleasant domestic flight with Maldivian to Kooddoo Domestic Airport on the North Huvadhoo (Gaafu Alifu) atoll, which takes between 60 and 105 minutes depending on the route, followed by an entertaining 30-minute speedboat ride to the resort."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1300, 'MHEVNKQTr28', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'park-hyatt-maldives-hadahaa-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'park-hyatt-maldives-hadahaa-island-resort'
  and l.node_type = 'location' and l.slug = 'hadahaa'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'park-hyatt-maldives-hadahaa-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 1300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'park-hyatt-maldives-hadahaa-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1600, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'park-hyatt-maldives-hadahaa-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 1950, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'park-hyatt-maldives-hadahaa-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Patina-Maldives
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'the-patina-maldives-fari-island-resort', 'The Patina Maldives Fari Island Resort', 'Far from all you know, there is a freedom inspired by everything you are - an island of pure beauty and surprising depth. Deep serenity or a shared experience. Follow your instincts to find what you require. Find the best luxury resort in the Maldives for your next vacation. At our Maldives resort, sophisticated rooms coexist with stimulating adventures. Create an unforgettable visit with Patina Maldives, Fari Islands'' special packages and seasonal discounts.', 'published', 'The Patina Maldives Fari Island Resort | Maldives Resorts | MTG', 'Far from all you know, there is a freedom inspired by everything you are - an island of pure beauty and surprising depth. Deep serenity or a shared experience. Follow your instincts to find what you require. Find the best luxury resort in the Maldives for your next vacation. At our Maldives resort, sophisticated rooms coexist with stimulating adventures. Create an unforgettable visit with Patina Maldives, Fari Islands'' special packages and seasonal discounts.', '{"overview_paragraphs":["Far from all you know, there is a freedom inspired by everything you are - an island of pure beauty and surprising depth. Deep serenity or a shared experience. Follow your instincts to find what you require. Find the best luxury resort in the Maldives for your next vacation. At our Maldives resort, sophisticated rooms coexist with stimulating adventures. Create an unforgettable visit with Patina Maldives, Fari Islands'' special packages and seasonal discounts.","Some of these one-bedroom villas offer views of the white sand beach, and they are all surrounded by a gorgeous garden of mature, natural tropical plants. This natural abundance provides the property and its grounds with seclusion and peace, making it perfect for seasoned travellers looking for a Maldives beach villa with a private pool. This is also felt within the villa, as floor-to-ceiling glass windows and doors open on three sides to provide a seamless transition between inside and outdoors.","Floor-to-ceiling panoramic glass swings back to reveal magnificent one-bedroom villas overlooking the turquoise ocean and at one with our local marine life. Nothing but the gentle ripples of the lagoon disrupt the horizon views from the private terrace. Inside our Maldives private water villa, the bedroom, bathroom, and lounge are crafted from natural materials that are in perfect harmony with our breathtaking setting.","In a secluded sanctuary, verdant landscaping envelops each of Patina Maldives'' 90 contemporary one- to three-bedroom Beach and Water Pool Villas, as well as 20 Fari Studios, yet opens invitingly into the surrounding island life; a simultaneous sensation of seclusion and belonging.","The property is located on the North Malé Atoll, 45 minutes via speedboat from Malé International Airport.","Each of our 12 ideas, a selected ensemble of the greatest food, gives a new viewpoint on what a Maldives restaurant should be, where the best ingredients and methods take centre stage. To build a worldwide connection via cuisine, our chefs retain time-honored skills with a dash of creativity."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 2600, 'g5ECncmC0OI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'the-patina-maldives-fari-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'the-patina-maldives-fari-island-resort'
  and l.node_type = 'location' and l.slug = 'fari-islands'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'the-patina-maldives-fari-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 2600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'the-patina-maldives-fari-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 3000, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'the-patina-maldives-fari-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Pullman
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'pullman-maldives-maamutaa-island-resort', 'Pullman Maldives Maamutaa Island Resort', 'Pullman Maldives Maamutaa is a Maldives premium all-inclusive resort where visitors may take advantage of special privileges, inspire their thoughts, and test their horizons. You''ll discover everything you need to improve your game right here. Our creative playground is headquartered on Maamutaa Island in Gaafu Alifu Atoll, in the southern Maldives. Set within 18 hectares of lush forest and around a natural lake, our aim is to provide our visitors with a holiday of a lifetime.', 'published', 'Pullman Maldives Maamutaa Island Resort | Maldives Resorts | MTG', 'Pullman Maldives Maamutaa is a Maldives premium all-inclusive resort where visitors may take advantage of special privileges, inspire their thoughts, and test their horizons. You''ll discover everything you need to improve your game right here. Our creative playground is headquartered on Maamutaa Island in Gaafu Alifu Atoll, in the southern Maldives. Set within 18 hectares of lush forest and around a natural lake, our aim is to provide our visitors with a holiday of a lifetime.', '{"overview_paragraphs":["Pullman Maldives Maamutaa is a Maldives premium all-inclusive resort where visitors may take advantage of special privileges, inspire their thoughts, and test their horizons. You''ll discover everything you need to improve your game right here. Our creative playground is headquartered on Maamutaa Island in Gaafu Alifu Atoll, in the southern Maldives. Set within 18 hectares of lush forest and around a natural lake, our aim is to provide our visitors with a holiday of a lifetime.","The Pullman Beach Villa is a tranquil haven in perfect harmony with its surroundings. A king-size bed dominates the 200sqm of modern living area. A huge private balcony captures sea breezes to the accompaniment of rustling palms and gently lapping waves. From the beautiful garden to the azure Indian Ocean, a quiet pathway leads. The spacious indoor-outdoor bath space has two refreshing showers and a luxurious island tub.","A chic hideaway surrounded by rich natural greenery, with the beach''s coral-white beaches just feet away. A shaded balcony overlooks the private pool and captures the sea wind. The Pullman Beach Pool Villa is a sophisticated traveler''s island getaway. Together or alone. The understated interior design combines Maldivian heritage with modern flair. A generous 240sqm of area provides plenty of room to do nothing. Alternatively, you could do everything. The bath space is centred on a deep island tub, with indoor and outdoor showers and his and hers wash basins.","Steps descend immediately from a large timber terrace to the lovely, tranquil sea. Pullman''s Ocean Villa is ideal for couples who want to savour every minute. Both day and night. An mesmerising view of the rich aquatic life below is provided via a lighted glass aperture in the floor. A large quantity of space (160sqm) means you''ll have plenty of room to stretch out. The open air living environment will revitalise and reconnect you with nature. Or soak it all up in the netting hammock floating above water.","Discover Pullman''s The Aqua Villa experience, an immersive encounter with aquatic life from the luxury of your bed that will nourish and bring to life your childhood fantasies. Enjoy the tranquillity of the Indian Ocean while finding the right combination of play and refreshment. Because Pullman believes in blending work and leisure, there is so much more to do at Pullman Maldives than just kick back, sleep, and take a picture. This luxurious two-level Aqua Villa features a submerged master bedroom as well as an overwater bedroom, as well as lots of space for you to relax and live your once-in-a-lifetime narrative. The Aqua Villa Experience brings your childhood fantasies to reality. It''s not a game.","The resort has 122 villas, including magnificent and unusual underwater villas. Honeymooners may enjoy their Private Beach and Water Pool Villas, while families can enjoy spacious 2 -3 Bedroom Villas."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1000, 'aCmdCbfQu10', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'pullman-maldives-maamutaa-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'pullman-maldives-maamutaa-island-resort'
  and l.node_type = 'location' and l.slug = 'maamutaa'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'pullman-maldives-maamutaa-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 1000, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'pullman-maldives-maamutaa-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1150, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'pullman-maldives-maamutaa-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ocean Villa', 1000, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'pullman-maldives-maamutaa-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Aqua Villa', 3700, 'USD', 'King', 3, 3
from nodes where node_type = 'accommodation' and slug = 'pullman-maldives-maamutaa-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Radisson-Blu
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'radisson-blu-maldives-island-resort', 'Radisson Blu Maldives Island Resort', 'The Radisson Blu Resort Maldives, a hidden jewel in the Indian Ocean, allows you to escape from the world and rest in elegance. Our knowledgeable team will arrange for your transportation to the hotel''s island. Enjoy world-class snorkelling and diving, as well as some of the greatest spots on the planet to observe whale sharks, throughout your vacation. You may explore nearby islands such as Dhigurah and Maamigili, or you can dive right here at our Dive and Water Sports Center. Relax with a glass of champagne in your villa''s own pool and share your fondest Fenfushi coral reef memories.', 'published', 'Radisson Blu Maldives Island Resort | Maldives Resorts | MTG', 'The Radisson Blu Resort Maldives, a hidden jewel in the Indian Ocean, allows you to escape from the world and rest in elegance. Our knowledgeable team will arrange for your transportation to the hotel''s island. Enjoy world-class snorkelling and diving, as well as some of the greatest spots on the planet to observe whale sharks, throughout your vacation. You may explore nearby islands such as Dhigurah and Maamigili, or you can dive right here at our Dive and Water Sports Center. Relax with a glass of champagne in your villa''s own pool and share your fondest Fenfushi coral reef memories.', '{"overview_paragraphs":["The Radisson Blu Resort Maldives, a hidden jewel in the Indian Ocean, allows you to escape from the world and rest in elegance. Our knowledgeable team will arrange for your transportation to the hotel''s island. Enjoy world-class snorkelling and diving, as well as some of the greatest spots on the planet to observe whale sharks, throughout your vacation. You may explore nearby islands such as Dhigurah and Maamigili, or you can dive right here at our Dive and Water Sports Center. Relax with a glass of champagne in your villa''s own pool and share your fondest Fenfushi coral reef memories.","In this property, enjoy your coffee while relaxing on the sun porch. This contemporary option offers amazing views of the Indian Ocean, unimpeded access to the beach, and a private pool. When you''re ready to go, refresh up in the bathroom, which has a bathtub, a rain shower, and a dual vanity counter. An IPTV, a sofa, a daybed, a vanity kit, IDD phones, and outside lounge chairs are among common features.","With spectacular views, a private outdoor terrace, an overwater hammock, and easy access to the pristine ocean waters, our overwater home helps you experience island life. Sunbathe on a beach chair or take a break from the sun by watching your favourite show on IPTV. A walk-in closet, a daybed, a sofa, a vanity kit, twin vanity counters, and IDD phones are other standard features.","Whether you''re visiting the Maldives for world-class snorkelling and diving activities or to celebrate your honeymoon with your spouse, our villa-style accommodations provide the finest of island life with private pools, breathtaking ocean views, and 24-hour room service. To have direct access to the gorgeous beach, book a beachfront villa. Outdoor decks, sun loungers, and dual vanity counters are standard features in all villas. Begin your day with a complimentary breakfast and a hot beverage from the espresso machine. Please keep in mind that additional guests who exceed a villa''s standard occupancy may be charged. Children under the age of 12 are admitted free of charge. Furthermore, we do not recommend that minors under the age of 12 stay in our overwater lodgings.","The resort is adjacent to Velana International Airport and provides two modes of transportation (domestic aircraft and seaplane) between the airport and the resort. Located in Alifu Dhaalu Atoll, an atoll known for its diverse marine life, multiple diving locations, and year-round whale shark and manta sightings.","Our restaurants at the Radisson Blu Resort Maldives inspire guests to experience something different, from Japanese cuisine to Mediterranean dishes flavoured with Asian flare. Visit Raha for an international buffet breakfast, lunch, and supper, or make an appointment at Alifaan for grilled specialties from around the world. Dine at Kabuki, our Japanese restaurant, for a journey of discovery prepared by our expert Japanese chefs, which includes a variety of drinks from Japan and the rest of the world."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 950, 'od5aJv768h4', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'radisson-blu-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'radisson-blu-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'huruelhi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'radisson-blu-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1180, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'radisson-blu-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Pool Villa', 950, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'radisson-blu-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Raffles
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'raffles-maldives-meradhoo-island-resort', 'Raffles Maldives Meradhoo Island Resort', 'Raffles Maldives Meradhoo is an exceptional refuge. It is as far removed from the rhythm of regular life as one can get in its isolated location on the southern extremity of the Maldives archipelago. Guests establish their own beat here. They rest, reconnect, and realign in harmony with nature. It''s easy to forget about the outer world when you''re surrounded by clear Indian Ocean seas teeming with unspoiled house reefs and their wonderful residents. For its exceptional service and magnificent beauty, Raffles Maldives Meradhoo has been named one of the greatest new hotels in the Indian Ocean by discriminating travel enthusiasts and guests. The crew works hard to ensure that guests have a good time and remember it fondly.', 'published', 'Raffles Maldives Meradhoo Island Resort | Maldives Resorts | MTG', 'Raffles Maldives Meradhoo is an exceptional refuge. It is as far removed from the rhythm of regular life as one can get in its isolated location on the southern extremity of the Maldives archipelago. Guests establish their own beat here. They rest, reconnect, and realign in harmony with nature. It''s easy to forget about the outer world when you''re surrounded by clear Indian Ocean seas teeming with unspoiled house reefs and their wonderful residents. For its exceptional service and magnificent beauty, Raffles Maldives Meradhoo has been named one of the greatest new hotels in the Indian Ocean by discriminating travel enthusiasts and guests. The crew works hard to ensure that guests have a good time and remember it fondly.', '{"overview_paragraphs":["Raffles Maldives Meradhoo is an exceptional refuge. It is as far removed from the rhythm of regular life as one can get in its isolated location on the southern extremity of the Maldives archipelago. Guests establish their own beat here. They rest, reconnect, and realign in harmony with nature. It''s easy to forget about the outer world when you''re surrounded by clear Indian Ocean seas teeming with unspoiled house reefs and their wonderful residents. For its exceptional service and magnificent beauty, Raffles Maldives Meradhoo has been named one of the greatest new hotels in the Indian Ocean by discriminating travel enthusiasts and guests. The crew works hard to ensure that guests have a good time and remember it fondly.","This property, just yards from the beach, is stunning from the moment you step inside. The interior colour scheme is inspired by the maritime environment and is soothing to the senses. With spacious outdoor areas featuring a private garden and pool, a wide verandah opening directly onto the beach, and a choice of daybeds both inside and outdoors, this wonderful spot is designed for leisure. Take a step outside and let the ocean wind wash away your problems.","A stay at our Overwater Villa is set against the backdrop of nature. The sun glinting on the lagoon''s calm, clear water, a kaleidoscope of colours beneath the surface as fish dart across the ocean bottom beneath you, and the brightest stars in the night sky. It is the ideal venue for appreciating the natural world''s beauties. Comfort is entirely up to you within your villa. Enclose the living rooms for air-conditioned comfort or open up the entire area to the soothing wind and sounds of the sea. Relax in your private pool or deep indoor bathtub, or indulge in the ultimate luxury by stepping down from your balcony into the clear waters of the lagoon and interacting with the marine life.","The resort''s beach villas are located on a natural island, only steps away from pristine sands and the vast Indian Ocean. The rooms are decorated in gentle sky blue and duck egg tones that mirror the natural beauty of their surrounds, and include furnishings such as the famed Raffles'' writer''s desk. A private pool and outdoor shower on the terrace are ideal for cool starry nights. On the natural island is also located the spectacular Raffles Royal Residence. The magnificent Overwater Residence and Sunset Overwater Residence are located alongside the villas.","A remarkable oasis located at the southern extremity of the Maldives, among the beautiful seas of the Indian Ocean: Meradhoo Raffles Maldives.","From pastries and fresh fruits for breakfast to vivid salads and a la carte meals for lunch and themed dinner evenings, visitors may unwind in this casual, open atmosphere as the soothing ocean breeze cools them."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1900, 'q5l7E02JyYY', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'raffles-maldives-meradhoo-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'raffles-maldives-meradhoo-island-resort'
  and l.node_type = 'location' and l.slug = 'meradhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'raffles-maldives-meradhoo-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1900, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'raffles-maldives-meradhoo-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Villa Pool', 2250, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'raffles-maldives-meradhoo-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Rahaa-Resort
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'rahaa-resort-maldives-island', 'Rahaa Resort Maldives Island', 'Rahaa is a four-star resort in the pristine Laamu Atoll. A naturally stunning setting with native flora, long lengths of beach, and a salt-water lake. Rahaa is accessible through a 30- to 40-minute domestic flight followed by a 20- to 30-minute speed boat trip. Rahaa is an ideal vacation destination for all types of visitors, including honeymooners, singles, adventurers, and families.', 'published', 'Rahaa Resort Maldives Island | Maldives Resorts | MTG', 'Rahaa is a four-star resort in the pristine Laamu Atoll. A naturally stunning setting with native flora, long lengths of beach, and a salt-water lake. Rahaa is accessible through a 30- to 40-minute domestic flight followed by a 20- to 30-minute speed boat trip. Rahaa is an ideal vacation destination for all types of visitors, including honeymooners, singles, adventurers, and families.', '{"overview_paragraphs":["Rahaa is a four-star resort in the pristine Laamu Atoll. A naturally stunning setting with native flora, long lengths of beach, and a salt-water lake. Rahaa is accessible through a 30- to 40-minute domestic flight followed by a 20- to 30-minute speed boat trip. Rahaa is an ideal vacation destination for all types of visitors, including honeymooners, singles, adventurers, and families.","The Ocean View Villas, tucked away amid dense vegetation and backed by gently swaying palms, provide absolute solitude and breathtaking views of the Indian Ocean. Relax on the outdoor daybed or read a book while enjoying the fresh coastal wind.","Rahaa Resort offers Lake View Villas and Ocean View Villas for visitors to enjoy diverse views throughout their stay.","Laamu Atoll is a gorgeous and unspoiled atoll. The domestic trip from Male International Airport to Kadhdhoo Airport takes around 25 minutes, followed by a fast speed boat ride to the resort.","This opulent beachfront restaurant provides worldwide cuisine for breakfast, lunch, and supper buffet style, as well as a selection of A La Carte entrees. Theme evenings will take you on a seven-day journey across the world. As live cooking stations sprout up on the beach and the ocean air filled with pleasant noises and scents to stimulate your appetite, travel from the Maldives to the Mediterranean and back to the streets of Asia.","The Maldives, surrounded by the serenity of the sea, is known as one of the best places to restore your mind and body to their natural balance of energy. Rahaa Spa, which overlooks the turquoise lagoon, is your location for releasing tension and unwinding into the serenity you know you deserve. Our massage and body care treatments, which combine the therapeutic characteristics of natural Maldivian materials, will meet your pampering requirements in the hands of our expert specialists."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 200, 'pFyLzV795hc', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'rahaa-resort-maldives-island'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'rahaa-resort-maldives-island'
  and l.node_type = 'location' and l.slug = 'kudafares'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'rahaa-resort-maldives-island'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ocean View Villa', 200, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'rahaa-resort-maldives-island'
on conflict (accommodation_id, name) do nothing;

-- Reethi-Beach
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'reethi-beach-resort-maldives', 'Reethi Beach Resort Maldives', 'In this hectic world, visitors may still enjoy tranquillity mixed with a real Maldivian jungle vibe on a tiny island in Baa Atoll, a simple 35-minute seaplane flight from Male''. Our spacious freestanding and semi-detached villas are attentively designed while providing a one-of-a-kind service in a distinctive setting.', 'published', 'Reethi Beach Resort Maldives | Maldives Resorts | MTG', 'In this hectic world, visitors may still enjoy tranquillity mixed with a real Maldivian jungle vibe on a tiny island in Baa Atoll, a simple 35-minute seaplane flight from Male''. Our spacious freestanding and semi-detached villas are attentively designed while providing a one-of-a-kind service in a distinctive setting.', '{"overview_paragraphs":["In this hectic world, visitors may still enjoy tranquillity mixed with a real Maldivian jungle vibe on a tiny island in Baa Atoll, a simple 35-minute seaplane flight from Male''. Our spacious freestanding and semi-detached villas are attentively designed while providing a one-of-a-kind service in a distinctive setting.","Sunset Deluxe Villas are single standing apartments located on the westside of the island by the excellent sandy beach with a spectacular view of the crystal blue lagoon. Wooden deck chairs on the patio and a traditional Maldivian swing right outside the villa encourage you to unwind. Each villa has a king-size bed, a wider living space, and an open-air Maldivian bathroom with a bathtub and rain shower.","This is a must-see for every ocean lover, built on stilts over the lagoon''s gorgeous waters. There are 30 semi-detached Water Villas of 61 sqm available, each with a bathroom with bathtub and shower, bathrobes, a big sitting area with direct access to the lagoon, and a sun umbrella with sun loungers.","Each exquisite villa on the island offers luxury in a unique environment and is intended to promote personal relaxation. The villas were created from natural materials in traditional Maldivian architecture and are ideally positioned among tropical greenery, on the gorgeous sandy beach, or on stilts above the pure waters of the turquoise lagoon.","Take a breathtaking 35-minute seaplane journey with a spectacular aerial view of the Maldivian thousand isles, or take a 20-minute domestic flight to Dharavandhoo airport and then a 15-minute speed boat ride to the island. The 600 m x 200 m resort is set among lush flora, covered by majestic palm trees, encircled by a white sandy beach, and edged by a lovely house reef 30 m to 100 m from the island.","Dine in a variety of locations, including beachside and overwater. We provide to the most demanding consumer with 5 restaurants, including a buffet restaurant, dine dining, and specialised restaurants. Our main restaurant, which overlooks the garden and the sea, provides buffet-style breakfast, lunch, and supper. Dinner is especially exceptional, with an unique ''theme'' every night of the week and a biweekly menu change. Special dietary needs are met on a case-by-case basis; vegetarian and ''healthy eating'' choices are always available."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, null, 'su-IqEO2mS4', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'reethi-beach-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'reethi-beach-resort-maldives'
  and l.node_type = 'location' and l.slug = 'fonimagoodhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'reethi-beach-resort-maldives'
on conflict (id) do nothing;

-- Reethi-Faru
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'reethi-faru-resort-maldives-island', 'Reethi Faru Resort Maldives Island', 'Reethi Faru is a luxurious retreat on the quiet, beautiful, and private island of Filaidhoo. Discover this one-of-a-kind tropical island paradise, where the sparkling crystal clear water meets the limitless white coral beach and lush flora transforms it into a genuinely wonderful lagoon hideaway. We are confident that you will be immersed in peace the moment you walk into its crystal clear light blue seas reaching across the smooth dunes. A wonderfully enchanting but one-of-a-kind location where you may select from a variety of things to enjoy throughout your stay.', 'published', 'Reethi Faru Resort Maldives Island | Maldives Resorts | MTG', 'Reethi Faru is a luxurious retreat on the quiet, beautiful, and private island of Filaidhoo. Discover this one-of-a-kind tropical island paradise, where the sparkling crystal clear water meets the limitless white coral beach and lush flora transforms it into a genuinely wonderful lagoon hideaway. We are confident that you will be immersed in peace the moment you walk into its crystal clear light blue seas reaching across the smooth dunes. A wonderfully enchanting but one-of-a-kind location where you may select from a variety of things to enjoy throughout your stay.', '{"overview_paragraphs":["Reethi Faru is a luxurious retreat on the quiet, beautiful, and private island of Filaidhoo. Discover this one-of-a-kind tropical island paradise, where the sparkling crystal clear water meets the limitless white coral beach and lush flora transforms it into a genuinely wonderful lagoon hideaway. We are confident that you will be immersed in peace the moment you walk into its crystal clear light blue seas reaching across the smooth dunes. A wonderfully enchanting but one-of-a-kind location where you may select from a variety of things to enjoy throughout your stay.","The totally private location will inspire you to enjoy the ''Me'' time you''ve always desired. Each villa has its own sunset cabana, sun loungers, and reading chairs. A book, some gentle music, and the natural surroundings in the midst of lots of sunlight will provide you with enough reasons to smile without giving you another cause to grin.","This is your place, with your very own sky. If staring at the sky or taking up the scenery while holding hands in a secluded environment sounds romantic, this is it. These Villas have magnificent natural lighting, hardwood ceilings, and inviting décor that is frequently caressed by a fresh wind.","To give the perfect vacation at Reethi Faru Resort, special care has been made to the design and placement of each of the 150 villas. You will discover a fully serviced villa that matches all of your requirements and interests, from family-friendly accommodations to perfectly located romantic hideaways.","Reethi Faru Resort is a newly new 5-star resort in Raa Atoll, north-west of Male'', on the little island of Filaidhoo, with a lovely house reef only 80 metres from shore. Reethi Faru Resort is a breathtaking 45-minute seaplane journey or a 20-minute domestic flight to Dharavandhoo followed by a 40-minute speed boat ride directly to the Resort from the international airport.","With breakfast being the most essential meal of the day, there is something for everyone at the restaurant. Our breakfast buffet includes a live area with waffles, pancakes, omelettes, and local delicacies, as well as continental spreads with a variety of flavours to tempt your taste buds. The menu expands to include a variety of lunch and supper options."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 250, 'gvkORhQg47s', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'reethi-faru-resort-maldives-island'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'reethi-faru-resort-maldives-island'
  and l.node_type = 'location' and l.slug = 'filaidhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'reethi-faru-resort-maldives-island'
on conflict (id) do nothing;
