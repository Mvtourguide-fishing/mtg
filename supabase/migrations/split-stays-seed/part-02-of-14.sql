-- Part 2 of 14 - run this in the Supabase SQL Editor AFTER the previous parts.
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

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'furanafushi', 'Furanafushi', 'Furanafushi is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'furanafushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'furanafushi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kanuhura', 'Kanuhura', 'Kanuhura is a resort island in Lhaviyani Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kanuhura'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kanuhura'
  and p.node_type = 'location' and p.slug = 'lhaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'iru-fushi', 'Iru Fushi', 'Iru Fushi is a resort island in Noonu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'iru_fushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'iru-fushi'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'medhufaru', 'Medhufaru', 'Medhufaru is a resort island in Noonu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'medhufaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'medhufaru'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'ismehela-hera', 'Ismehela Hera', 'Ismehela Hera is a resort island in Seenu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'ismehela_hera'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'ismehela-hera'
  and p.node_type = 'location' and p.slug = 'seenu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'nalaguraidhoo', 'Nalaguraidhoo', 'Nalaguraidhoo is a resort island in Alif Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'nalaguraidhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'nalaguraidhoo'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'aloofushi', 'Aloofushi', 'Aloofushi is a resort island in Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'aloofushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'aloofushi'
  and p.node_type = 'location' and p.slug = 'dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'olhuveli', 'Olhuveli', 'Olhuveli is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'olhuveli'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'olhuveli'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'meedhuffushi', 'Meedhuffushi', 'Meedhuffushi is a resort island in Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'meedhuffushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'meedhuffushi'
  and p.node_type = 'location' and p.slug = 'dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'hembadhu', 'Hembadhu', 'Hembadhu is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hembadhu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hembadhu'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'emboodhu-finolhu', 'Emboodhu Finolhu', 'Emboodhu Finolhu is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'emboodhu_finolhu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'emboodhu-finolhu'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'madivaru', 'Madivaru', 'Madivaru is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'madivaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'madivaru'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'vakkaru', 'Vakkaru', 'Vakkaru is a resort island in Baa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vakkaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vakkaru'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'veligandu', 'Veligandu', 'Veligandu is a resort island in Alif Alif Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'veligandu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'veligandu'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'vilamendhoo', 'Vilamendhoo', 'Vilamendhoo is a resort island in Alif Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vilamendhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vilamendhoo'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'ithaafushi', 'Ithaafushi', 'Ithaafushi is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'ithaafushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'ithaafushi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'miriandhoo', 'Miriandhoo', 'Miriandhoo is a resort island in Baa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'miriandhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'miriandhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'uthurumafaru', 'Uthurumafaru', 'Uthurumafaru is a resort island in Raa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'uthurumafaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'uthurumafaru'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'rannalhi', 'Rannalhi', 'Rannalhi is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'rannalhi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'rannalhi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'dhigufinolhu', 'Dhigufinolhu', 'Dhigufinolhu is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhigufinolhu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhigufinolhu'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'giraavaru', 'Giraavaru', 'Giraavaru is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'giraavaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'giraavaru'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'embudu', 'Embudu', 'Embudu is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'embudu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'embudu'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'fihalhohi', 'Fihalhohi', 'Fihalhohi is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fihalhohi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fihalhohi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'nakatchafushi', 'Nakatchafushi', 'Nakatchafushi is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'nakatchafushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'nakatchafushi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kuda-villingili', 'Kuda Villingili', 'Kuda Villingili is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kuda_villingili'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kuda-villingili'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'thiladhoo', 'Thiladhoo', 'Thiladhoo is a resort island in Baa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'thiladhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'thiladhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'lankanfinolhu', 'Lankanfinolhu', 'Lankanfinolhu is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'lankanfinolhu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'lankanfinolhu'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'ziyaaraifushi', 'Ziyaaraifushi', 'Ziyaaraifushi is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'ziyaaraifushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'ziyaaraifushi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'vommuli', 'Vommuli', 'Vommuli is a resort island in Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vommuli'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vommuli'
  and p.node_type = 'location' and p.slug = 'dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'fesdu', 'Fesdu', 'Fesdu is a resort island in Alif Alif Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fesdu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fesdu'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

-- Accommodations
-- Aaaveee-Natures-Paradise
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'aaaveee-natures-paradise-island-resort-maldives', 'Aaaveee Nature''s Paradise Island Resort Maldives', 'Come to the Maldives'' most environmentally friendly resort ever built. Nature''s at the core of this gorgeous island in Dhaalu Atoll. The island is a tiny 8 hectare treasure located on the northern portion of Dhaalu Atoll with a short 40 minute seaplane flight and step onto this amazing island in the Maldives.', 'published', 'Aaaveee Nature''s Paradise Island Resort Maldives | Maldives Resorts | MTG', 'Come to the Maldives'' most environmentally friendly resort ever built. Nature''s at the core of this gorgeous island in Dhaalu Atoll. The island is a tiny 8 hectare treasure located on the northern portion of Dhaalu Atoll with a short 40 minute seaplane flight and step onto this amazing island in the Maldives.', '{"overview_paragraphs":["Come to the Maldives'' most environmentally friendly resort ever built. Nature''s at the core of this gorgeous island in Dhaalu Atoll. The island is a tiny 8 hectare treasure located on the northern portion of Dhaalu Atoll with a short 40 minute seaplane flight and step onto this amazing island in the Maldives.","A discovery in nature Maldivian Retreat presenting the true original Maldivian way of life in private retreats back in 1972, when Maldives tourism first began. Come to the Maldives'' most environmentally friendly resort ever built. Nature''s Paradise has it all, whether it''s a house reef, foliage, a lagoon, or anything... It''s your resort, your island, your life, and your universe. The only true Maldivian hideaway, regarded as the best \"Nature Discovery Island Resort\" in the world.","Aaaveee Nature''s Paradise is located in the northwestern section of Dhaalu atoll, about 35 minutes by seaplane from Velana International Airport. It is also 25 kilometers north of the projected Kudahuvadhoo domestic airport and 25 kilometers south of Maamigili International Airport. It is a quick 20-minute speedboat ferry or ride from Kudahuvadhoo airport.","Aaaveee Nature''s Paradise has 33 eco-friendly rooms and three types of lodging that are unique to Aaaveee Nature''s Paradise.","If traveling within 6 months of the wedding date, they will receive a fruit basket with a bottle of wine and a bed decoration. At the time of check-in, the Resort may request a copy of the wedding certificate.","If you stay at aaaVeee Nature''s Paradise on the anniversary date, you will receive a cake with a bottle of wine and a bed decoration. At the time of check-in, the Resort may request a copy of the wedding certificate."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 437, 'Yp51yOrPzpA', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'aaaveee-natures-paradise-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'aaaveee-natures-paradise-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'dhoores'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'aaaveee-natures-paradise-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deck Villa', 437, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'aaaveee-natures-paradise-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 543, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'aaaveee-natures-paradise-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Adaaran-Hudhuranfushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'adaaran-select-hudhuran-fushi-island-resort-maldives', 'Adaaran Select Hudhuran Fushi Island Resort Maldives', 'Adaaran Select Hudhuranfushi offers an unforgettable tropical vacation. The Island of White Gold, blessed with abundant vegetation and clean seas, is located in quiet isolation in the North Male Atoll. Set on 83 acres of beautiful tropical beach property on Kani Beach on Lhohifushi Island, the resort''s architecture allows it to fit in as one of the top resorts in Maldives. Discover a secret paradise where the sun rises to paint the skies in deep orange colours and the gentle waves of the Indian Ocean caress the coastline with elegance.', 'published', 'Adaaran Select Hudhuran Fushi Island Resort Maldives | Maldives Resorts | MTG', 'Adaaran Select Hudhuranfushi offers an unforgettable tropical vacation. The Island of White Gold, blessed with abundant vegetation and clean seas, is located in quiet isolation in the North Male Atoll. Set on 83 acres of beautiful tropical beach property on Kani Beach on Lhohifushi Island, the resort''s architecture allows it to fit in as one of the top resorts in Maldives. Discover a secret paradise where the sun rises to paint the skies in deep orange colours and the gentle waves of the Indian Ocean caress the coastline with elegance.', '{"overview_paragraphs":["Adaaran Select Hudhuranfushi offers an unforgettable tropical vacation. The Island of White Gold, blessed with abundant vegetation and clean seas, is located in quiet isolation in the North Male Atoll. Set on 83 acres of beautiful tropical beach property on Kani Beach on Lhohifushi Island, the resort''s architecture allows it to fit in as one of the top resorts in Maldives. Discover a secret paradise where the sun rises to paint the skies in deep orange colours and the gentle waves of the Indian Ocean caress the coastline with elegance.","Note: This hotel has different rates for diferrent season and this may not be the updated rates as we do not use Hotel PMS software.","The 165 air-conditioned villas are outfitted with modern facilities, exquisite furniture, and tropical-themed décor. Enjoy a slice of paradise at the 37 Ocean Villas, which radiate a world of elegance and luxury while also providing a plethora of exclusive amenities. The air-conditioned villas provide contemporary facilities as well as a private sun deck with 24-hour access to the surrounding ocean."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 320, 'DDBNdhpfmHk', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'adaaran-select-hudhuran-fushi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'adaaran-select-hudhuran-fushi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'lhohifushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'adaaran-select-hudhuran-fushi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 320, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'adaaran-select-hudhuran-fushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ocean Villa', 600, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'adaaran-select-hudhuran-fushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Adaaran-Select
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'adaaran-select-meedhupparu-island-resort-maldives', 'Adaaran Select Meedhupparu Island Resort Maldives', 'Adaaran Select Meedhupparu, one of the greatest resorts in Maldives, offers heavenly accommodation for the discriminating tourist to the Maldives with the promise of an exceptional experience in the tropics. Bask in the healing sun and take in the tempting sights and sounds of a really wonderful tropical island. Adaaran Select Meedhupparu provides calm settings that are oozing with elegance. Set your sights on a vacation filled with stunning adventures that will leave you with memories to last a lifetime.', 'published', 'Adaaran Select Meedhupparu Island Resort Maldives | Maldives Resorts | MTG', 'Adaaran Select Meedhupparu, one of the greatest resorts in Maldives, offers heavenly accommodation for the discriminating tourist to the Maldives with the promise of an exceptional experience in the tropics. Bask in the healing sun and take in the tempting sights and sounds of a really wonderful tropical island. Adaaran Select Meedhupparu provides calm settings that are oozing with elegance. Set your sights on a vacation filled with stunning adventures that will leave you with memories to last a lifetime.', '{"overview_paragraphs":["Adaaran Select Meedhupparu, one of the greatest resorts in Maldives, offers heavenly accommodation for the discriminating tourist to the Maldives with the promise of an exceptional experience in the tropics. Bask in the healing sun and take in the tempting sights and sounds of a really wonderful tropical island. Adaaran Select Meedhupparu provides calm settings that are oozing with elegance. Set your sights on a vacation filled with stunning adventures that will leave you with memories to last a lifetime.","Adaaran Select Meedhupparu - Premium All Inclusive- Premium All Inclusive is located in the Maldives'' Ra Atoll and offers large bungalows with views of the beach and ocean. The resort also has an outdoor swimming pool, specialty spa services, and 5 dining options.","Each beach cottage has a private bathroom and a balcony with sun loungers. A minibar is available for a cost, as well as a tea and coffee machine.","At the water sports centre, guests may learn to dive. There are recreation amenities accessible, such as a workout centre, beach volleyball, and snorkelling.","The resort''s main restaurant has a breakfast, lunch, and supper buffet with Asian and Western cuisines, with beverages available at four bars.","Adaaran Select Meedhupparu - Premium All Inclusive is a 45-minute picturesque sea plane flight from Malé International Airport."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 356, '1JV3MeBgVFs', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'adaaran-select-meedhupparu-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'adaaran-select-meedhupparu-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'meedhupparu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'adaaran-select-meedhupparu-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Villa', 356, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'adaaran-select-meedhupparu-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa With Jaccuzi', 775, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'adaaran-select-meedhupparu-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Adaaran-Vadoo
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'adaaran-prestige-vadoo-island-resort-maldives', 'Adaaran Prestige Vadoo Island Resort Maldives', 'Adaaran Prestige Vadoo is a premium Maldives Island resort that was named the World''s Leading Water Villa Retreat at the World Travel Awards in 2010. Only the mesmerising lushness of the surroundings can equal the list of luxuries that await you at our Maldives Island resort.', 'published', 'Adaaran Prestige Vadoo Island Resort Maldives | Maldives Resorts | MTG', 'Adaaran Prestige Vadoo is a premium Maldives Island resort that was named the World''s Leading Water Villa Retreat at the World Travel Awards in 2010. Only the mesmerising lushness of the surroundings can equal the list of luxuries that await you at our Maldives Island resort.', '{"overview_paragraphs":["Adaaran Prestige Vadoo is a premium Maldives Island resort that was named the World''s Leading Water Villa Retreat at the World Travel Awards in 2010. Only the mesmerising lushness of the surroundings can equal the list of luxuries that await you at our Maldives Island resort.","Note: This hotel has different rates for diferrent season and this may not be the updated rates as we do not use Hotel PMS software.","Adaaran Prestige Vadoo is a luxury resort in the Maldives with 50 water villas, six of which are inspired by classic Japanese design and embody the distinctive Nihon values of elegant simplicity blended with controlled grandeur. Each house is perched on blue waves, providing unrivalled access to the huge Indian Ocean.","Sun, sand, and surf are some of the most prized features of a Maldives vacation, and the lovely island of Vadoo does not disappoint with immaculate beaches and shimmering waters beneath the radiance of exquisite tropical sky. Adaaran Prestige Vadoo is easily accessible by speedboat from the international airport, with the quick water voyage taking only 15 minutes in a picturesque southerly direction."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 620, '-diTGI7I0PI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'adaaran-prestige-vadoo-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'adaaran-prestige-vadoo-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'vadoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'adaaran-prestige-vadoo-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Jacuzzi Water Villa', 620, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'adaaran-prestige-vadoo-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Alila-Kothaifaru
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'alila-kothaifaru-maldives-island-resort', 'Alila Kothaifaru Maldives Island Resort', 'Relax in calm privacy with breathtaking views at this all-pool-villa retreat. Our 11.2 acre private island getaway is located in Raa Atoll, on the northern tip of the Maldives, and is accessible by a breathtaking 45-minute seaplane flight from Malé. Lush foliage, azure waterways, and an abundance of marine life set the stage for a relaxed visit punctuated by adventure.', 'published', 'Alila Kothaifaru Maldives Island Resort | Maldives Resorts | MTG', 'Relax in calm privacy with breathtaking views at this all-pool-villa retreat. Our 11.2 acre private island getaway is located in Raa Atoll, on the northern tip of the Maldives, and is accessible by a breathtaking 45-minute seaplane flight from Malé. Lush foliage, azure waterways, and an abundance of marine life set the stage for a relaxed visit punctuated by adventure.', '{"overview_paragraphs":["Relax in calm privacy with breathtaking views at this all-pool-villa retreat. Our 11.2 acre private island getaway is located in Raa Atoll, on the northern tip of the Maldives, and is accessible by a breathtaking 45-minute seaplane flight from Malé. Lush foliage, azure waterways, and an abundance of marine life set the stage for a relaxed visit punctuated by adventure.","The resort''s tiered pavilions and villas are seamlessly incorporated into the landscape and mix solitude with openness to the outdoors in a unique expression of minimalist beauty. Each of the resort''s 44 beachfront villas and 36 overwater villas has a private pool and has contemporary furnishings in a palette of relaxing colours with natural textures. These vast hideaways have been thoughtfully placed to give complete seclusion and comfort in an understated, classy manner.","Each of the resort''s 44 beachfront villas and 36 overwater villas has a private pool for your enjoyment and is designed for calm relaxation in harmony with nature. These roomy hideaways are thoughtfully positioned to give seclusion and comfort in modest, classy design, with contemporary décor in a palette of calming colours and natural textures.","Our 11.2 acre private island getaway is located on the northernmost tip of the Maldives, in the Raa Atoll, and is accessible by a picturesque 45-minute seaplane flight from Malé."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 950, 'iSxvRiuoJ80', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'alila-kothaifaru-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'alila-kothaifaru-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'kothaifaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'alila-kothaifaru-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 950, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'alila-kothaifaru-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Water Villa', 1050, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'alila-kothaifaru-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Alimathaa
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'nakai-alimathaa-island-resort-maldives', 'Nakai Alimathaa Island Resort Maldives', 'Alimathà originally meant "woman''s face." The island, as seen from above, now has the shape of a heart with a beach of fine white sand that goes deep into the Maldives sea. It is bordered by a stunning and colourful coral reef that is home to hundreds of different fish species. Alimathà is the ideal combination of relaxation on a white sand beach and physical activity, with dozens of sporting activities available on the island.', 'published', 'Nakai Alimathaa Island Resort Maldives | Maldives Resorts | MTG', 'Alimathà originally meant "woman''s face." The island, as seen from above, now has the shape of a heart with a beach of fine white sand that goes deep into the Maldives sea. It is bordered by a stunning and colourful coral reef that is home to hundreds of different fish species. Alimathà is the ideal combination of relaxation on a white sand beach and physical activity, with dozens of sporting activities available on the island.', '{"overview_paragraphs":["Alimathà originally meant \"woman''s face.\" The island, as seen from above, now has the shape of a heart with a beach of fine white sand that goes deep into the Maldives sea. It is bordered by a stunning and colourful coral reef that is home to hundreds of different fish species. Alimathà is the ideal combination of relaxation on a white sand beach and physical activity, with dozens of sporting activities available on the island.","Through our daily excursions, you can explore the surrounding islands and immerse yourself in the cultural beauty of the Maldives. Cocogiri is your private gateway to tropical paradise, located only 18 minutes by seaplane or 60 minutes by speed boat from Male International Airport.","The 96 Beach Bungalows are arranged around the full ring of the island and front right onto Alimathà''s beautiful coral beach. From your deck, you can gaze out at the horizon through the trunks and leaves of the palms, and you''ll only need a few steps to reach the beach, where you may dive into the sea or simply relax in the sun.","The 34 Over Water of Alimathà, which faces true north, opens up in a fan that rotates at sunrise and sunset. They are located in the quietest part of the island and are surrounded by an environment of calm and tranquillity. The Over Water is an excellent choice for taking in the beauty of the horizon while relaxing on a comfortable sun lounger on your private balcony.","Alimathà offers three distinct types of rooms to its guests, ranging from the Over Water viewing the ocean to the Beach Bungalows just steps from the beach, to the Garden Villa surrounded by flora. Choose the one that best suits you and let yourself to be whisked away by Alimathà''s enchantment.","Alimathà Maldives is located in Vaavu atoll, 65 kilometres from Velana International Airport, and may be reached by a 20-minute seaplane ride or an hour and a half by speed boat. Surrounding the island are fantastic dive sites so gorgeous that they have been included to the government-sanctioned list of protected dive sites, including exquisite beaches and crystal clear waters, which serve as the daily backdrop for this small slice of paradise."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 320, 'jOZq8S7pJzA', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'nakai-alimathaa-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'nakai-alimathaa-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'alimatha'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'nakai-alimathaa-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Bungalow', 320, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'nakai-alimathaa-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Bungalow', 350, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'nakai-alimathaa-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Amari-Havodda
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'amari-havodda-maldives-island-resort', 'Amari Havodda Maldives Island Resort', 'situated on a quiet private island 400 kilometres south of Male, in the Gaafu Dhaalu Atoll, an Indian Ocean paradise Amari Havodda Maldives is a secluded refuge with tropical flora, crystal-clear blue seas, and white sandy beaches. This pristine refuge is all yours, allowing you to completely unplug and rejuvenate on your own terms.', 'published', 'Amari Havodda Maldives Island Resort | Maldives Resorts | MTG', 'situated on a quiet private island 400 kilometres south of Male, in the Gaafu Dhaalu Atoll, an Indian Ocean paradise Amari Havodda Maldives is a secluded refuge with tropical flora, crystal-clear blue seas, and white sandy beaches. This pristine refuge is all yours, allowing you to completely unplug and rejuvenate on your own terms.', '{"overview_paragraphs":["situated on a quiet private island 400 kilometres south of Male, in the Gaafu Dhaalu Atoll, an Indian Ocean paradise Amari Havodda Maldives is a secluded refuge with tropical flora, crystal-clear blue seas, and white sandy beaches. This pristine refuge is all yours, allowing you to completely unplug and rejuvenate on your own terms.","Our interiors have been meticulously created to provide a welcoming home-away-from-home experience. We''ve tweaked the décor to highlight modern workmanship at every turn - a modern reimagining of the traditional Maldivian house. Our resort also provides a diverse range of recreational and athletic activities, as well as unique dining experiences under the stars.","Welcome to your personal haven, your own bit of bliss. Our magnificent villas at Amari Havodda Maldives are warm, stylish, and homey. Your beach or overwater retreat boasts natural timber floors, towering palm-thatched roofs, beautiful furniture, an outdoor open-air shower, and modern technology inspired by traditional Maldivian architecture and created within a concept of natural simplicity.","Our resort is located in the Indian Ocean on a private island 400 kilometres south of Male in the Gaafu Dhaalu Atoll. Amari Havodda is accessible through a 55-60 minute domestic air transfer."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 480, 'Gg2E1SAp9HY', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'amari-havodda-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'amari-havodda-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'havodda'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'amari-havodda-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Beach Villa', 480, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'amari-havodda-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Pool Villa', 700, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'amari-havodda-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Villa', 700, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'amari-havodda-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Amaya-Resort
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'amaya-kuda-rah-island-resort-maldives', 'Amaya Kuda Rah Island Resort Maldives', 'Enter an island paradise where the ocean begs you to live and love at one of the Maldives'' greatest luxury resorts. Dive into an underwater wonderland at the neighbouring Kuda Rah Thila, celebrate romance on a sunset boat, and find inner joy at our spa; come experience Amaya Kuda Rah''s real emotional welcome.', 'published', 'Amaya Kuda Rah Island Resort Maldives | Maldives Resorts | MTG', 'Enter an island paradise where the ocean begs you to live and love at one of the Maldives'' greatest luxury resorts. Dive into an underwater wonderland at the neighbouring Kuda Rah Thila, celebrate romance on a sunset boat, and find inner joy at our spa; come experience Amaya Kuda Rah''s real emotional welcome.', '{"overview_paragraphs":["Enter an island paradise where the ocean begs you to live and love at one of the Maldives'' greatest luxury resorts. Dive into an underwater wonderland at the neighbouring Kuda Rah Thila, celebrate romance on a sunset boat, and find inner joy at our spa; come experience Amaya Kuda Rah''s real emotional welcome.","You may visit our resort all year round. You may encounter overcast skies and rain showers from May to October, since this is considered our low season, but you may take advantage of some excellent deals during this time. From December through April, the island enjoys bright sky.","As you relax in dreamlike peace at Amaya Kuda Rah, let the beauty of the Maldives soak through every inch of their rooms. Their expansive villas and suites have been deliberately constructed to provide you with unparalleled enjoyment during your stay. Sunbathe on hardwood terraces, relax in your private plunge pool, or retire to your room for some well-deserved slumber.","The facility, located 94 kilometres south of Velana International Airport, features large villas with private pools, as well as a full-service spa and wellness centre. Amaya Kuda Rah may be reached by seaplane in 25 minutes. A 15-minute speedboat journey from this pier will take you to your beautiful little sanctuary of joy. Furthermore, Amaya Kuda Rah is just minutes away from the well-known diving location of Kuda Rah Thila, which is home to an abundance of marine life."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 240, '24h6vGDC5gs', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'amaya-kuda-rah-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'amaya-kuda-rah-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'kuda-rah'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'amaya-kuda-rah-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 240, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'amaya-kuda-rah-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Pool Water Villa', 390, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'amaya-kuda-rah-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Amilla-Fushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'amilla-fushi-island-resort-maldives', 'Amilla Fushi Island Resort Maldives', 'Explore one of the Maldives'' largest and most expansive five-star resorts. With just 67 villas with spacious outside spaces and individual plunge pools, you can experience the luxury of space. Over 70% of our island is unspoiled forest with stunning white sand beaches. The only footfall you hear are your own. Our Maldives private island resort is fortunate to be positioned in the UNESCO World Biosphere Reserve of Baa Atoll. Hanifaru Bay, which hosts the world''s greatest aggregations of manta rays, beckons divers and snorkelers. Sustainability and wellbeing are key to our Considerate Collection of Small Luxury Hotels.', 'published', 'Amilla Fushi Island Resort Maldives | Maldives Resorts | MTG', 'Explore one of the Maldives'' largest and most expansive five-star resorts. With just 67 villas with spacious outside spaces and individual plunge pools, you can experience the luxury of space. Over 70% of our island is unspoiled forest with stunning white sand beaches. The only footfall you hear are your own. Our Maldives private island resort is fortunate to be positioned in the UNESCO World Biosphere Reserve of Baa Atoll. Hanifaru Bay, which hosts the world''s greatest aggregations of manta rays, beckons divers and snorkelers. Sustainability and wellbeing are key to our Considerate Collection of Small Luxury Hotels.', '{"overview_paragraphs":["Explore one of the Maldives'' largest and most expansive five-star resorts. With just 67 villas with spacious outside spaces and individual plunge pools, you can experience the luxury of space. Over 70% of our island is unspoiled forest with stunning white sand beaches. The only footfall you hear are your own. Our Maldives private island resort is fortunate to be positioned in the UNESCO World Biosphere Reserve of Baa Atoll. Hanifaru Bay, which hosts the world''s greatest aggregations of manta rays, beckons divers and snorkelers. Sustainability and wellbeing are key to our Considerate Collection of Small Luxury Hotels.","The private villas at Amilla Maldives Resort and Residence are located on sandy, sun-drenched coastlines that extend out over the lagoon. Each is a quiet enclave where elegance meets calm, a monument to the sky and water.","Amilla Maldives, a small island less than one kilometre long, rises on the outskirts of the Baa Atoll, home to some of the Maldives'' finest seas and a biosphere reserve designated as a UNESCO World Heritage site since 2011. Arrive at your Baa Atoll Maldives resort in 30 minutes by seaplane from Malé or 10 minutes by speedboat from Dharavandhoo Airport."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1380, '9vdcB98lF6E', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'amilla-fushi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'amilla-fushi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'amilla-fushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'amilla-fushi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1590, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'amilla-fushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunset Water Villa', 1380, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'amilla-fushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Angaga-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'angaga-island-resort-spa-maldives', 'Angaga Island Resort & Spa Maldives', 'The Angaga Island resort and spa is located in the heart of Ari Atoll''s south. South Ari Atoll is well renowned for its abundant marine life and excellent diving opportunities. The island is bordered by white powdery sandy beaches, a crystal clear water lagoon, and a house reef teeming with colourful fish species, making it a snorkelling and diving paradise. The island is roughly 42372 square metres in size. The island is around 85 kilometres from Male airport and takes about 25 minutes to arrive by seaplane.', 'published', 'Angaga Island Resort & Spa Maldives | Maldives Resorts | MTG', 'The Angaga Island resort and spa is located in the heart of Ari Atoll''s south. South Ari Atoll is well renowned for its abundant marine life and excellent diving opportunities. The island is bordered by white powdery sandy beaches, a crystal clear water lagoon, and a house reef teeming with colourful fish species, making it a snorkelling and diving paradise. The island is roughly 42372 square metres in size. The island is around 85 kilometres from Male airport and takes about 25 minutes to arrive by seaplane.', '{"overview_paragraphs":["The Angaga Island resort and spa is located in the heart of Ari Atoll''s south. South Ari Atoll is well renowned for its abundant marine life and excellent diving opportunities. The island is bordered by white powdery sandy beaches, a crystal clear water lagoon, and a house reef teeming with colourful fish species, making it a snorkelling and diving paradise. The island is roughly 42372 square metres in size. The island is around 85 kilometres from Male airport and takes about 25 minutes to arrive by seaplane.","Your house surrounded by tropical trees, turquoise and crystal clear blue seas to stare up on where the sun always smiles. The main jetty provides access to the resort''s excellent house reef for snorkelling. Keep an eye out for schools of snappers, soldierfish, batfish, and other species. Stingrays, sharks, and turtles frequent the reef, and you are extremely likely to see them when snorkelling or diving near it.","Because Angaga Island Resort & Spa is located in the heart of South Ari Atoll in the Maldives, it is a popular diving destination, and many visitors come year after year. Angaga has 50 freestanding beach bungalows, 20 water villas built on stilts over the lagoon, and another 20 premium water villas that were just erected.","Angaga Island Resort is located in the heart of South Ari Atoll, on a tiny island of 320 x 160 metres that can be accessed by seaplane in 25 minutes from Velana International Airport. Because of its handy location, it is simple to combine the tranquillity of the island with a few days of sightseeing in the surrounding town."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;
