-- Site-owner-confirmed content-gap fix: the legacy site had "Male City
-- Tour" and "Whale Submarine Tour" pages that did not carry over into the
-- new site. Investigated via data/maldives/migration/legacy-url-inventory.json,
-- redirect-map.json and redirect-review.json:
--   - male-city-tour.html was misclassified during the Task 16 redirect
--     migration as a duplicate of the Malé island page and 301-redirected
--     to /maldives/islands/male/ — a real content-preservation gap.
--   - whale-submarine-tour.html was correctly flagged
--     migrationStatus: "review" in redirect-review.json (never silently
--     dropped) but never resolved until now.
-- Content below is taken directly from the real legacy source files
-- (release/public_html/male-city-tour.html,
-- release/public_html/whale-submarine-tour.html) — prices, durations,
-- inclusions, and highlights are the site's own original figures, not
-- invented. Images are the site's own real legacy photos, already
-- uploaded to Storage and already present as media_assets rows via
-- 20250115000100_full_legacy_image_library.sql — no new media_assets
-- rows needed here, only node_media attachments (same pattern as
-- 20250118000100_activity_images.sql).

-- Providers: the Male City tours are the site's own guided tours (no
-- separate legacy operator was named), matching the existing
-- 'maldives-tour-guide-transfers' naming precedent. Whale Submarine is a
-- real, distinct submarine-tourism operator named on the legacy page.
insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'maldives-tour-guide-tours', 'Maldives Tour Guide', 'Maldives Tour Guide operates guided city tours and excursions in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'maldives-tour-guide-tours'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'whale-submarine-maldives', 'Whale Submarine Maldives', 'Whale Submarine Maldives operates the only passenger submarine in South East Asia, diving from Malé.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'whale-submarine-maldives'
on conflict (id) do nothing;

-- Activity-type taxonomy tag for the Male City tour family, so it's
-- filterable alongside the existing fishing/diving/surfing types.
insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'city-tour', 'City Tour', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'city_tour'::ltree from nodes where node_type = 'category' and slug = 'city-tour'
on conflict (id) do nothing;

-- Activity: Male City Walking Tour ($15, ~2 hours) — the legacy page's
-- flagship product (its own <title> read "...to visit the capital island
-- of the Maldives (15$)").
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values (
  'activity', 'male-city-walking-tour', 'Male City Walking Tour',
  'Male City Walking Tour is a 2-hour guided walk through Malé, the Maldives'' capital island, with airport pickup and drop-off. From USD 15 per person. Includes: airport pickup and drop-off, local guide, taxes. Highlights: Stingray Point, local market, fish market, souvenir street, Old Presidential Palace, Grand Friday Mosque, Victory Monument, Old Friday Mosque (heritage), Presidential Office, Parliament, Artificial Beach, and the surfing point.',
  'published',
  'Male City Walking Tour (USD 15) | Maldives Tour Guide',
  'Male City Walking Tour is a 2-hour guided walk through Malé, the Maldives'' capital island, with airport pickup and drop-off. From USD 15 per person.',
  now()
)
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency)
select n.id, 'excursion', p.id, 120, 15, 'USD'
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'male-city-walking-tour' and p.node_type = 'provider' and p.slug = 'maldives-tour-guide-tours'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'male-city-walking-tour' and l.node_type = 'location' and l.slug = 'male'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 15, 'USD' from nodes where node_type = 'activity' and slug = 'male-city-walking-tour'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'activity' and n.slug = 'male-city-walking-tour' and c.node_type = 'category' and c.slug = 'city-tour'
on conflict (node_id, category_id) do nothing;

insert into node_media (node_id, media_id, role, sort_order)
select id, 'd3eebd01-a9ab-8b4e-03f3-094be0902f56', 'hero', 0 from nodes where node_type = 'activity' and slug = 'male-city-walking-tour'
on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order)
select id, '173a81f5-7dc2-5e05-f1cf-fae1c27373ae', 'gallery', 1 from nodes where node_type = 'activity' and slug = 'male-city-walking-tour'
on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order)
select id, 'a9b7c081-9df8-521b-84de-b3b50bd30bdb', 'gallery', 2 from nodes where node_type = 'activity' and slug = 'male-city-walking-tour'
on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order)
select id, 'a1102fa9-16d9-40eb-3d77-c243bd74479e', 'gallery', 3 from nodes where node_type = 'activity' and slug = 'male-city-walking-tour'
on conflict (node_id, media_id, role) do nothing;

-- Activity: Male City Bike Tour ($34, ~2 hours)
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values (
  'activity', 'male-city-bike-tour', 'Male City Bike Tour',
  'Male City Bike Tour is a 2-hour guided motorbike tour of Malé, the Maldives'' capital island, riding pillion behind your guide, with airport pickup and drop-off. From USD 34 per person. Includes: airport pickup and drop-off, local guide, motorbike, helmet, taxes. Highlights: Stingray Point, local market, fish market, souvenir street, Old Presidential Palace, Grand Friday Mosque, Victory Monument, Old Friday Mosque (heritage), Presidential Office, Parliament, Artificial Beach, surfing point, Tsunami Monument, King Salmaan Mosque, and the Sinamalé Bridge.',
  'published',
  'Male City Bike Tour (USD 34) | Maldives Tour Guide',
  'Male City Bike Tour is a 2-hour guided motorbike tour of Malé, the Maldives'' capital island, with airport pickup and drop-off. From USD 34 per person.',
  now()
)
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency)
select n.id, 'excursion', p.id, 120, 34, 'USD'
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'male-city-bike-tour' and p.node_type = 'provider' and p.slug = 'maldives-tour-guide-tours'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'male-city-bike-tour' and l.node_type = 'location' and l.slug = 'male'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 34, 'USD' from nodes where node_type = 'activity' and slug = 'male-city-bike-tour'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'activity' and n.slug = 'male-city-bike-tour' and c.node_type = 'category' and c.slug = 'city-tour'
on conflict (node_id, category_id) do nothing;

insert into node_media (node_id, media_id, role, sort_order)
select id, 'b696f490-7694-be52-f326-73d65192e41d', 'hero', 0 from nodes where node_type = 'activity' and slug = 'male-city-bike-tour'
on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order)
select id, '9e3ac774-9501-7d16-51fd-db921498138d', 'gallery', 1 from nodes where node_type = 'activity' and slug = 'male-city-bike-tour'
on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order)
select id, '975fe792-7def-203b-8ebe-2de6950a832b', 'gallery', 2 from nodes where node_type = 'activity' and slug = 'male-city-bike-tour'
on conflict (node_id, media_id, role) do nothing;

-- Activity: Male City Car Tour ($150 per vehicle, ~2 hours)
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values (
  'activity', 'male-city-car-tour', 'Male City Car Tour',
  'Male City Car Tour is a 2-hour guided sightseeing tour of Malé, the Maldives'' capital island, by air-conditioned car, with airport pickup and drop-off. From USD 150 per vehicle (4-seater), not per person. Includes: airport pickup and drop-off, local guide, 4-seater car, coconut drink, taxes. Highlights: Stingray Point, local market, fish market, souvenir street, Old Presidential Palace, Grand Friday Mosque, Victory Monument, Old Friday Mosque (heritage), Presidential Office, Parliament, Artificial Beach, surfing point, Tsunami Monument, King Salmaan Mosque, and the Sinamalé Bridge.',
  'published',
  'Male City Car Tour (USD 150 per vehicle) | Maldives Tour Guide',
  'Male City Car Tour is a 2-hour guided sightseeing tour of Malé by air-conditioned car, with airport pickup and drop-off. From USD 150 per vehicle.',
  now()
)
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency, max_participants)
select n.id, 'excursion', p.id, 120, 150, 'USD', 4
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'male-city-car-tour' and p.node_type = 'provider' and p.slug = 'maldives-tour-guide-tours'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'male-city-car-tour' and l.node_type = 'location' and l.slug = 'male'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency, max_guests)
select id, 'inquiry', 150, 'USD', 4 from nodes where node_type = 'activity' and slug = 'male-city-car-tour'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'activity' and n.slug = 'male-city-car-tour' and c.node_type = 'category' and c.slug = 'city-tour'
on conflict (node_id, category_id) do nothing;

insert into node_media (node_id, media_id, role, sort_order)
select id, 'c55af43e-c0c4-38d1-65d7-e07f51b374c4', 'hero', 0 from nodes where node_type = 'activity' and slug = 'male-city-car-tour'
on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order)
select id, '455637df-2be1-5bc9-e66b-123624cdbbe8', 'gallery', 1 from nodes where node_type = 'activity' and slug = 'male-city-car-tour'
on conflict (node_id, media_id, role) do nothing;

-- Activity: Male City Half Day Walking Tour ($38, 5-6 hours)
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values (
  'activity', 'male-city-half-day-walking-tour', 'Male City Half Day Walking Tour',
  'Male City Half Day Walking Tour is a 5-6 hour guided walking tour covering 3 islands (Malé, Hulhumalé, and Vilimalé), with airport pickup and drop-off. From USD 38 per person. Includes: airport pickup and drop-off, local guide, Vilimalé transfer, Hulhumalé transfer, tea with local snacks. Highlights: Stingray Point, local market, fish market, souvenir street, Old Presidential Palace, Grand Friday Mosque, Victory Monument, Old Friday Mosque (heritage), Presidential Office, Parliament, Artificial Beach, surfing point, Tsunami Monument, King Salmaan Mosque, Sinamalé Bridge, Vilimalé visit, Hulhumalé visit, and a seaplane port view. National Museum entry available for an additional USD 7.',
  'published',
  'Male City Half Day Walking Tour (USD 38) | Maldives Tour Guide',
  'Male City Half Day Walking Tour is a 5-6 hour guided walk covering Malé, Hulhumalé, and Vilimalé, with airport pickup and drop-off. From USD 38 per person.',
  now()
)
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency)
select n.id, 'excursion', p.id, 330, 38, 'USD'
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'male-city-half-day-walking-tour' and p.node_type = 'provider' and p.slug = 'maldives-tour-guide-tours'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'male-city-half-day-walking-tour' and l.node_type = 'location' and l.slug = 'male'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 38, 'USD' from nodes where node_type = 'activity' and slug = 'male-city-half-day-walking-tour'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'activity' and n.slug = 'male-city-half-day-walking-tour' and c.node_type = 'category' and c.slug = 'city-tour'
on conflict (node_id, category_id) do nothing;

insert into node_media (node_id, media_id, role, sort_order)
select id, 'bcd24d10-89c3-c7e7-2e29-6b25b211c40e', 'hero', 0 from nodes where node_type = 'activity' and slug = 'male-city-half-day-walking-tour'
on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order)
select id, '9e3ac774-9501-7d16-51fd-db921498138d', 'gallery', 1 from nodes where node_type = 'activity' and slug = 'male-city-half-day-walking-tour'
on conflict (node_id, media_id, role) do nothing;

-- Activity: Male City Half Day Bike Tour ($70, 5-6 hours)
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values (
  'activity', 'male-city-half-day-bike-tour', 'Male City Half Day Bike Tour',
  'Male City Half Day Bike Tour is a 5-6 hour guided motorbike tour of Malé and Hulhumalé (riding pillion behind your guide), plus a Vilimalé visit by ferry, with airport pickup and drop-off. From USD 70 per person. Includes: airport pickup and drop-off, local guide, motorbike, helmet, tea with local snacks, Vilimalé transfer. Highlights: Stingray Point, local market, fish market, souvenir street, Old Presidential Palace, Grand Friday Mosque, Victory Monument, Old Friday Mosque (heritage), Presidential Office, Parliament, Artificial Beach, surfing point, Tsunami Monument, King Salmaan Mosque, Sinamalé Bridge, Vilimalé visit, and Hulhumalé visit. National Museum entry available for an additional USD 7.',
  'published',
  'Male City Half Day Bike Tour (USD 70) | Maldives Tour Guide',
  'Male City Half Day Bike Tour is a 5-6 hour guided motorbike tour of Malé, Hulhumalé, and Vilimalé, with airport pickup and drop-off. From USD 70 per person.',
  now()
)
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency)
select n.id, 'excursion', p.id, 330, 70, 'USD'
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'male-city-half-day-bike-tour' and p.node_type = 'provider' and p.slug = 'maldives-tour-guide-tours'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'male-city-half-day-bike-tour' and l.node_type = 'location' and l.slug = 'male'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 70, 'USD' from nodes where node_type = 'activity' and slug = 'male-city-half-day-bike-tour'
on conflict (id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id from nodes n, nodes c where n.node_type = 'activity' and n.slug = 'male-city-half-day-bike-tour' and c.node_type = 'category' and c.slug = 'city-tour'
on conflict (node_id, category_id) do nothing;

insert into node_media (node_id, media_id, role, sort_order)
select id, '8217364e-8d94-61de-35bb-03891448f72f', 'hero', 0 from nodes where node_type = 'activity' and slug = 'male-city-half-day-bike-tour'
on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order)
select id, '975fe792-7def-203b-8ebe-2de6950a832b', 'gallery', 1 from nodes where node_type = 'activity' and slug = 'male-city-half-day-bike-tour'
on conflict (node_id, media_id, role) do nothing;

-- Activity: Whale Submarine Tour (Adult USD 80, Child USD 45 — schema has
-- one price_from field, so price_from is the adult rate and the child
-- rate is stated in the summary/meta, same approach as elsewhere in this
-- codebase when a real second price exists with no dedicated column).
-- 45-minute dive to 45m depth aboard the only passenger submarine in
-- South East Asia; capacity 48 passengers per dive (both real figures
-- from the legacy page, not invented).
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values (
  'activity', 'whale-submarine-tour', 'Whale Submarine Tour',
  'Whale Submarine Tour is the only passenger submarine tour in South East Asia — a 45-minute dive to 45 meters, viewing a sunken reef and reef fish, suitable for non-swimmers, children, and elders. Capacity is 48 passengers per dive. Adult USD 80, Child USD 45. Meeting point: Malé Jetty No. 1. Runs most days except Monday and Wednesday; sessions at 11:00 and 14:30. An optional add-on evening buffet dinner aboard the submarine (DeepSea Restaurant, 120 feet below the surface) is also available.',
  'published',
  'Whale Submarine Tour Maldives (from USD 80) | Maldives Tour Guide',
  'Whale Submarine Tour is the only passenger submarine tour in South East Asia — a 45-minute dive to 45 meters from Malé. Adult USD 80, Child USD 45.',
  now()
)
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency, max_participants)
select n.id, 'excursion', p.id, 45, 80, 'USD', 48
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'whale-submarine-tour' and p.node_type = 'provider' and p.slug = 'whale-submarine-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'whale-submarine-tour' and l.node_type = 'location' and l.slug = 'male'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency, max_guests)
select id, 'inquiry', 80, 'USD', 48 from nodes where node_type = 'activity' and slug = 'whale-submarine-tour'
on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order)
select id, '23a71350-868c-e57f-3aad-128eb4aa29e8', 'hero', 0 from nodes where node_type = 'activity' and slug = 'whale-submarine-tour'
on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order)
select id, '5f5b3882-77d0-cead-41be-8401ab670827', 'gallery', 1 from nodes where node_type = 'activity' and slug = 'whale-submarine-tour'
on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order)
select id, '8564b10d-0761-d4be-6cd1-332ccf2ac5c9', 'gallery', 2 from nodes where node_type = 'activity' and slug = 'whale-submarine-tour'
on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order)
select id, '7f50cbfb-0bd0-5afe-e681-cf00ca936d0d', 'gallery', 3 from nodes where node_type = 'activity' and slug = 'whale-submarine-tour'
on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order)
select id, '4430603a-247f-8ef3-8d55-2f4099b33dc0', 'gallery', 4 from nodes where node_type = 'activity' and slug = 'whale-submarine-tour'
on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order)
select id, '64c8dc1c-d27b-a4a1-81b5-35fb16809cfa', 'gallery', 5 from nodes where node_type = 'activity' and slug = 'whale-submarine-tour'
on conflict (node_id, media_id, role) do nothing;

-- Fix the male-city-tour.html redirect (previously pointed at the Malé
-- island page — see header note) to point at the real recreated content,
-- and add the whale-submarine-tour.html redirect that redirect-review.json
-- had correctly left unresolved pending this decision.
insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/male-city-tour.html', 'path', '/maldives/activities/male-city-walking-tour/', 301, '[redirect, confidence=high] Real content recreated from the legacy page (Task 22 content-gap fix), not a duplicate of the Malé island page.')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/whale-submarine-tour.html', 'path', '/maldives/activities/whale-submarine-tour/', 301, '[redirect, confidence=high] Previously flagged migrationStatus=review in redirect-review.json; real content recreated from the legacy page (Task 22 content-gap fix).')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();
