-- Site-owner-confirmed follow-up to 20250201000100 (Male City Tour / Whale
-- Submarine): 6 more real Male Atoll excursions recovered from the legacy
-- site's booking-form pages under release/public_html/tours/. The legacy
-- crawler had classified these as generic "booking-form-widget" pages (the
-- same pattern correctly used to exclude the Vaavu Atoll false alarm
-- investigated earlier), which is why they never got a redirect or were
-- surfaced for review — but reading the actual HTML shows each one carries
-- real, distinct content: description, per-tour pricing (adult/child, from
-- the page's own total-price JS), a timed stop-by-stop itinerary, meeting
-- points, and inclusions. None of this is invented — see the reason string
-- on each page's redirect below for its exact source file.
--
-- One of the six (Nurse Shark Snorkeling) only exists as
-- release/public_html/images/tours/nurse-shark-snorkeling-male-atoll-activities.html
-- — misplaced under images/tours/ in the site export, but its content and
-- URL pattern match every sibling page, so its real legacy URL is treated
-- as /tours/nurse-shark-snorkeling-male-atoll-activities.html to match.
--
-- Two pages already flagged migrationStatus: "review" in
-- redirect-review.json (sandbank-and-snorkeling-male-atoll-activities.html,
-- shipwreck-snorkeling-excursion.html) are resolved here too, the same way
-- whale-submarine-tour.html was resolved previously.
--
-- All 6 depart from Hulhumalé (every itinerary's stated "Leave from
-- Hulhumale Jetty" step), with earlier pickups from Male Atoll resorts and
-- islands — so 'hulhumale' is their primary location, not 'male'.

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values (
  'activity', 'full-day-excursion-male-atoll', 'Full Day Excursion Male Atoll',
  'Full Day Excursion Male Atoll is an 8-hour combo excursion covering Stingray Point, Nurse Shark Point, a local island lunch stop, a sandbank visit, and a dolphin trip, with free pickup from Male Atoll resorts and islands. From USD 150 per adult, USD 110 per child. Itinerary: resort pickups 08:00-08:30, leave Hulhumale Jetty 09:00, Stingray Point 09:15, Nurse Shark 10:45, lunch at a local island 12:30, sandbank 14:30, dolphin trip 15:30, return to Hulhumale Jetty 17:00. Includes soft drinks, lunch, resort/island pickup, snorkeling equipment, towels, and GoPro footage. Add-ons (extra charge): babysitter, drone video, underwater photography.',
  'published',
  'Full Day Excursion Male Atoll (USD 150) | Maldives Tour Guide',
  'Full Day Excursion Male Atoll is an 8-hour combo excursion covering Stingray Point, Nurse Shark Point, a local island, a sandbank, and a dolphin trip. From USD 150 per adult.',
  now()
)
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency)
select n.id, 'excursion', p.id, 480, 150, 'USD'
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'full-day-excursion-male-atoll' and p.node_type = 'provider' and p.slug = 'maldives-tour-guide-tours'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'full-day-excursion-male-atoll' and l.node_type = 'location' and l.slug = 'hulhumale'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 150, 'USD' from nodes where node_type = 'activity' and slug = 'full-day-excursion-male-atoll'
on conflict (id) do nothing;

-- Vaavu Atoll Excursion: Shipwreck Snorkeling, Nurse Shark Encounter, Local
-- Island Visit & Dolphin Trip (the page's own subheading) — 9-hour boat trip
-- from Male Atoll to Vaavu Atoll.
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values (
  'activity', 'vaavu-atoll-excursion', 'Vaavu Atoll Excursion',
  'Vaavu Atoll Excursion: Shipwreck Snorkeling, Nurse Shark Encounter, Local Island Visit & Dolphin Trip is a 9-hour boat excursion from Male Atoll into the unspoiled Vaavu Atoll, blending underwater adventure, a local island visit, and wildlife encounters. From USD 150 per adult, USD 110 per child. Itinerary: resort pickups 07:00-07:30, leave Hulhumale Jetty 08:00, shipwreck snorkeling 10:00, lunch at a local island 12:00, nurse shark encounter 13:30, depart Vaavu 15:30, return to Hulhumale Jetty 17:30. Includes soft drinks, professional snorkeling guides, lunch, round-trip transfer for Male Atoll resorts and islands, snorkeling equipment, towels, and GoPro footage. Add-ons (extra charge): babysitter, drone video, underwater photography.',
  'published',
  'Vaavu Atoll Excursion (USD 150) | Maldives Tour Guide',
  'Vaavu Atoll Excursion is a 9-hour boat trip combining shipwreck snorkeling, a nurse shark encounter, a local island visit, and a dolphin trip. From USD 150 per adult.',
  now()
)
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency)
select n.id, 'excursion', p.id, 540, 150, 'USD'
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'vaavu-atoll-excursion' and p.node_type = 'provider' and p.slug = 'maldives-tour-guide-tours'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'vaavu-atoll-excursion' and l.node_type = 'location' and l.slug = 'hulhumale'
on conflict (node_id, location_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'vaavu-atoll-excursion' and l.node_type = 'location' and l.slug = 'vaavu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 150, 'USD' from nodes where node_type = 'activity' and slug = 'vaavu-atoll-excursion'
on conflict (id) do nothing;

-- Stingray Snorkeling (3-5 hours; duration_minutes uses the midpoint since
-- the real travel time varies by resort pickup distance, per the page's own
-- stated range).
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values (
  'activity', 'stingray-snorkeling', 'Stingray Snorkeling',
  'Stingray Snorkeling is a 3-5 hour snorkeling trip to Stingray Point in Male Atoll, with free pickup from Male Atoll resorts and islands. From USD 50 per adult, USD 35 per child. Itinerary: resort pickups 07:00-07:30, leave Hulhumale Jetty 08:00, return to Hulhumale Jetty 10:30. Includes soft drinks, resort/island pickup, snorkeling equipment, and towels. Add-ons (extra charge): babysitter, drone video, underwater photography.',
  'published',
  'Stingray Snorkeling Male Atoll (USD 50) | Maldives Tour Guide',
  'Stingray Snorkeling is a 3-5 hour snorkeling trip to Stingray Point in Male Atoll, with resort pickup included. From USD 50 per adult.',
  now()
)
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency)
select n.id, 'watersports', p.id, 240, 50, 'USD'
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'stingray-snorkeling' and p.node_type = 'provider' and p.slug = 'maldives-tour-guide-tours'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'stingray-snorkeling' and l.node_type = 'location' and l.slug = 'hulhumale'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 50, 'USD' from nodes where node_type = 'activity' and slug = 'stingray-snorkeling'
on conflict (id) do nothing;

-- Nurse Shark Snorkeling (3-5 hours, same midpoint-duration approach).
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values (
  'activity', 'nurse-shark-snorkeling', 'Nurse Shark Snorkeling',
  'Nurse Shark Snorkeling is a 3-5 hour snorkeling trip to encounter nurse sharks in a Male Atoll lagoon or reef, with free pickup from Male Atoll resorts and islands. From USD 80 per adult, USD 60 per child. Itinerary: resort pickups 11:00-11:30, leave Hulhumale Jetty 13:00, return to Hulhumale Jetty 15:00. Includes soft drinks, resort/island pickup, snorkeling equipment, and towels. Add-ons (extra charge): babysitter, drone video, underwater photography.',
  'published',
  'Nurse Shark Snorkeling Male Atoll (USD 80) | Maldives Tour Guide',
  'Nurse Shark Snorkeling is a 3-5 hour snorkeling trip to encounter nurse sharks in a Male Atoll lagoon or reef. From USD 80 per adult.',
  now()
)
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency)
select n.id, 'watersports', p.id, 240, 80, 'USD'
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'nurse-shark-snorkeling' and p.node_type = 'provider' and p.slug = 'maldives-tour-guide-tours'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'nurse-shark-snorkeling' and l.node_type = 'location' and l.slug = 'hulhumale'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 80, 'USD' from nodes where node_type = 'activity' and slug = 'nurse-shark-snorkeling'
on conflict (id) do nothing;

-- Sandbank and Snorkeling Excursion (2 hours, two fixed daily departures).
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values (
  'activity', 'sandbank-and-snorkeling-excursion', 'Sandbank and Snorkeling Excursion',
  'Sandbank and Snorkeling Excursion is a 2-hour trip to a secluded Male Atoll sandbank and nearby reef, with two daily departures. From USD 75 per adult, USD 55 per child. Trip 1: depart Male 09:00, return 11:00. Trip 2: depart Male 14:00, return 16:00 (resort pickups 1 hour ahead). Includes drinking water, GoPro footage, and towels. Add-ons (extra charge): drone video, private photography, meals.',
  'published',
  'Sandbank and Snorkeling Excursion (USD 75) | Maldives Tour Guide',
  'Sandbank and Snorkeling Excursion is a 2-hour trip to a secluded Male Atoll sandbank and nearby reef, with two daily departures. From USD 75 per adult.',
  now()
)
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency)
select n.id, 'watersports', p.id, 120, 75, 'USD'
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'sandbank-and-snorkeling-excursion' and p.node_type = 'provider' and p.slug = 'maldives-tour-guide-tours'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'sandbank-and-snorkeling-excursion' and l.node_type = 'location' and l.slug = 'hulhumale'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 75, 'USD' from nodes where node_type = 'activity' and slug = 'sandbank-and-snorkeling-excursion'
on conflict (id) do nothing;

-- Dolphin Excursion ("Lucky Dolphin Trip" on the legacy page). The page's
-- own "Duration: 11hrs" label contradicts its own itinerary (pickups
-- 15:00-15:30, back at Hulhumale 18:05) by nearly 8 hours — an evident
-- copy/paste leftover from a longer template, not a real figure. The
-- concrete timed itinerary is trusted instead, matching how the Whale
-- Submarine Tour's own internally-contradictory schedule text was resolved
-- against its structured session table.
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values (
  'activity', 'dolphin-excursion', 'Dolphin Excursion',
  'Dolphin Excursion (Lucky Dolphin Trip) is an evening boat trip to see wild dolphins in Male Atoll, with free pickup from Male Atoll resorts and islands. From USD 85 per adult, USD 60 per child. Itinerary: resort pickups 15:00-15:30, leave Hulhumale Jetty 16:00, return to Hulhumale Jetty 18:00. Includes soft drinks, resort/island pickup, snorkeling equipment, and towels. Add-ons (extra charge): babysitter, drone video, underwater photography.',
  'published',
  'Dolphin Excursion Male Atoll (USD 85) | Maldives Tour Guide',
  'Dolphin Excursion (Lucky Dolphin Trip) is an evening boat trip to see wild dolphins in Male Atoll, with resort pickup included. From USD 85 per adult.',
  now()
)
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency)
select n.id, 'excursion', p.id, 180, 85, 'USD'
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'dolphin-excursion' and p.node_type = 'provider' and p.slug = 'maldives-tour-guide-tours'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'dolphin-excursion' and l.node_type = 'location' and l.slug = 'hulhumale'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 85, 'USD' from nodes where node_type = 'activity' and slug = 'dolphin-excursion'
on conflict (id) do nothing;

-- Island Hopping Excursion Male Atoll (3-5 hours, evening departure).
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values (
  'activity', 'island-hopping-excursion-male-atoll', 'Island Hopping Excursion Male Atoll',
  'Island Hopping Excursion Male Atoll explores the diverse beauty and culture of multiple islands in one trip — from luxury resort islands to uninhabited sandbanks and traditional local villages — with free pickup from Male Atoll resorts and islands. From USD 80 per adult, USD 60 per child. Itinerary: resort pickups 13:00-13:30, leave Hulhumale Jetty 14:00, return to Hulhumale Jetty 18:00. Includes soft drinks, resort/island pickup, snorkeling equipment, towels, and GoPro footage. Add-ons (extra charge): babysitter, drone video, underwater photography.',
  'published',
  'Island Hopping Excursion Male Atoll (USD 80) | Maldives Tour Guide',
  'Island Hopping Excursion Male Atoll explores multiple islands in one trip, from resort islands to local villages, with resort pickup included. From USD 80 per adult.',
  now()
)
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id, duration_minutes, price_from, currency)
select n.id, 'island_hopping', p.id, 240, 80, 'USD'
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'island-hopping-excursion-male-atoll' and p.node_type = 'provider' and p.slug = 'maldives-tour-guide-tours'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'island-hopping-excursion-male-atoll' and l.node_type = 'location' and l.slug = 'hulhumale'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode, base_price, currency)
select id, 'inquiry', 80, 'USD' from nodes where node_type = 'activity' and slug = 'island-hopping-excursion-male-atoll'
on conflict (id) do nothing;
-- (node_media for this activity is attached in 20250203000100, once the
-- island-hopping/ photos' media_assets rows exist from 20250202000200.)

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/tours/island-hopping-male-atoll-activities.html', 'path', '/maldives/activities/island-hopping-excursion-male-atoll/', 301, '[redirect, confidence=high] Real content recreated from the legacy booking-form page (Task 22 content-gap fix).')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

-- Redirects: fix/add the 6 legacy tour pages, resolving the 2 that were
-- already flagged migrationStatus: "review" in redirect-review.json.
insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/tours/fullday-excursion-male-atoll-activities.html', 'path', '/maldives/activities/full-day-excursion-male-atoll/', 301, '[redirect, confidence=high] Real content recreated from the legacy booking-form page (Task 22 content-gap fix).')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/tours/vaavu-excursion-male-atoll-activities.html', 'path', '/maldives/activities/vaavu-atoll-excursion/', 301, '[redirect, confidence=high] Real content recreated from the legacy booking-form page (Task 22 content-gap fix).')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/tours/stingray-snorkeling-male-atoll-activities.html', 'path', '/maldives/activities/stingray-snorkeling/', 301, '[redirect, confidence=high] Real content recreated from the legacy booking-form page (Task 22 content-gap fix).')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/tours/nurse-shark-snorkeling-male-atoll-activities.html', 'path', '/maldives/activities/nurse-shark-snorkeling/', 301, '[redirect, confidence=high] Real content recreated from the page misplaced at images/tours/nurse-shark-snorkeling-male-atoll-activities.html in the site export; URL pattern matches every sibling tours/ page (Task 22 content-gap fix).')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/tours/dolphin-excursion-male-atoll-activities.html', 'path', '/maldives/activities/dolphin-excursion/', 301, '[redirect, confidence=high] Real content recreated from the legacy booking-form page (Task 22 content-gap fix).')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/tours/sandbank-and-snorkeling-male-atoll-activities.html', 'path', '/maldives/activities/sandbank-and-snorkeling-excursion/', 301, '[redirect, confidence=high] Previously flagged migrationStatus=review in redirect-review.json; real content recreated (Task 22 content-gap fix).')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/tours/shipwreck-snorkeling-excursion.html', 'path', '/maldives/activities/vaavu-atoll-excursion/', 301, '[redirect, confidence=medium] Previously flagged migrationStatus=review in redirect-review.json; shipwreck snorkeling is one of this excursion''s named stops, the closest genuine match (Task 22 content-gap fix).')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();
