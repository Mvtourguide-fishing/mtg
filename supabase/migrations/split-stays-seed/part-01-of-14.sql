-- Part 1 of 14 - run this in the Supabase SQL Editor AFTER the previous parts.
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
values ('location', 'dhoores', 'Dhoores', 'Dhoores is a resort island in Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhoores'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhoores'
  and p.node_type = 'location' and p.slug = 'dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'lhohifushi', 'Lhohifushi', 'Lhohifushi is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'lhohifushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'lhohifushi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'meedhupparu', 'Meedhupparu', 'Meedhupparu is a resort island in Raa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'meedhupparu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'meedhupparu'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'vadoo', 'Vadoo', 'Vadoo is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vadoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vadoo'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kothaifaru', 'Kothaifaru', 'Kothaifaru is a resort island in Raa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kothaifaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kothaifaru'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'alimatha', 'Alimatha', 'Alimatha is a resort island in Vaavu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'alimatha'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'alimatha'
  and p.node_type = 'location' and p.slug = 'vaavu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'havodda', 'Havodda', 'Havodda is a resort island in Gaafu Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'havodda'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'havodda'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kuda-rah', 'Kuda Rah', 'Kuda Rah is a resort island in Alif Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kuda_rah'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kuda-rah'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'amilla-fushi', 'Amilla Fushi', 'Amilla Fushi is a resort island in Baa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'amilla_fushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'amilla-fushi'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'angaga', 'Angaga', 'Angaga is a resort island in Alif Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'angaga'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'angaga'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'velavaru', 'Velavaru', 'Velavaru is a resort island in Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'velavaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'velavaru'
  and p.node_type = 'location' and p.slug = 'dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kanifushi', 'Kanifushi', 'Kanifushi is a resort island in Lhaviyani Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kanifushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kanifushi'
  and p.node_type = 'location' and p.slug = 'lhaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'maguhdhuvaa', 'Maguhdhuvaa', 'Maguhdhuvaa is a resort island in Gaafu Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maguhdhuvaa'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maguhdhuvaa'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'maagau', 'Maagau', 'Maagau is a resort island in Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maagau'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maagau'
  and p.node_type = 'location' and p.slug = 'dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'bandos', 'Bandos', 'Bandos is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'bandos'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'bandos'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'vabbinfaru', 'Vabbinfaru', 'Vabbinfaru is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vabbinfaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vabbinfaru'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'makunufushi', 'Makunufushi', 'Makunufushi is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'makunufushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'makunufushi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'maalifushi', 'Maalifushi', 'Maalifushi is a resort island in Thaa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maalifushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maalifushi'
  and p.node_type = 'location' and p.slug = 'thaa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kanuhuraa', 'Kanuhuraa', 'Kanuhuraa is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kanuhuraa'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kanuhuraa'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'hakuraa-huraa', 'Hakuraa Huraa', 'Hakuraa Huraa is a resort island in Meemu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hakuraa_huraa'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hakuraa-huraa'
  and p.node_type = 'location' and p.slug = 'meemu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'velifushi', 'Velifushi', 'Velifushi is a resort island in Vaavu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'velifushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'velifushi'
  and p.node_type = 'location' and p.slug = 'vaavu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'bodu-hithi', 'Bodu Hithi', 'Bodu Hithi is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'bodu_hithi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'bodu-hithi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'vashugiri', 'Vashugiri', 'Vashugiri is a resort island in Vaavu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vashugiri'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vashugiri'
  and p.node_type = 'location' and p.slug = 'vaavu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'ookolhufinolhu', 'Ookolhufinolhu', 'Ookolhufinolhu is a resort island in Lhaviyani Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'ookolhufinolhu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'ookolhufinolhu'
  and p.node_type = 'location' and p.slug = 'lhaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'rangali', 'Rangali', 'Rangali is a resort island in Alif Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'rangali'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'rangali'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'maamigili', 'Maamigili', 'Maamigili is a resort island in Raa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maamigili'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maamigili'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'dhigali', 'Dhigali', 'Dhigali is a resort island in Raa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhigali'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhigali'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'dhiggiri', 'Dhiggiri', 'Dhiggiri is a resort island in Vaavu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhiggiri'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhiggiri'
  and p.node_type = 'location' and p.slug = 'vaavu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'dhigufaru', 'Dhigufaru', 'Dhigufaru is a resort island in Baa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhigufaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhigufaru'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'thudufushi', 'Thudufushi', 'Thudufushi is a resort island in Alif Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'thudufushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'thudufushi'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'mudhdhoo', 'Mudhdhoo', 'Mudhdhoo is a resort island in Baa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'mudhdhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'mudhdhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'fasmendhoo', 'Fasmendhoo', 'Fasmendhoo is a resort island in Raa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fasmendhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fasmendhoo'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'eriyadu', 'Eriyadu', 'Eriyadu is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'eriyadu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'eriyadu'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'faarufushi', 'Faarufushi', 'Faarufushi is a resort island in Raa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'faarufushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'faarufushi'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'sirru-fen-fushi', 'Sirru Fen Fushi', 'Sirru Fen Fushi is a resort island in Shaviyani Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'sirru_fen_fushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'sirru-fen-fushi'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'filitheyo', 'Filitheyo', 'Filitheyo is a resort island in Faafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'filitheyo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'filitheyo'
  and p.node_type = 'location' and p.slug = 'faafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kanufushi', 'Kanufushi', 'Kanufushi is a resort island in Baa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kanufushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kanufushi'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'landaa-giraavaru', 'Landaa Giraavaru', 'Landaa Giraavaru is a resort island in Baa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'landaa_giraavaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'landaa-giraavaru'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kuda-huraa', 'Kuda Huraa', 'Kuda Huraa is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kuda_huraa'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kuda-huraa'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'voavah', 'Voavah', 'Voavah is a resort island in Baa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'voavah'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'voavah'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'bodufinolhu', 'Bodufinolhu', 'Bodufinolhu is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'bodufinolhu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'bodufinolhu'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'furaveri', 'Furaveri', 'Furaveri is a resort island in Raa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'furaveri'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'furaveri'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'fushifaru', 'Fushifaru', 'Fushifaru is a resort island in Lhaviyani Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fushifaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fushifaru'
  and p.node_type = 'location' and p.slug = 'lhaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'gangehi', 'Gangehi', 'Gangehi is a resort island in Alif Alif Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'gangehi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'gangehi'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kodhipparu', 'Kodhipparu', 'Kodhipparu is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kodhipparu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kodhipparu'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'akasdhoo', 'Akasdhoo', 'Akasdhoo is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'akasdhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'akasdhoo'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'aarah', 'Aarah', 'Aarah is a resort island in Raa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'aarah'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'aarah'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'dhonakulhi', 'Dhonakulhi', 'Dhonakulhi is a resort island in Haa Alif Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhonakulhi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhonakulhi'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kedhigandu', 'Kedhigandu', 'Kedhigandu is a resort island in Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kedhigandu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kedhigandu'
  and p.node_type = 'location' and p.slug = 'dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'hurawalhi', 'Hurawalhi', 'Hurawalhi is a resort island in Lhaviyani Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hurawalhi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hurawalhi'
  and p.node_type = 'location' and p.slug = 'lhaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'innahura', 'Innahura', 'Innahura is a resort island in Lhaviyani Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'innahura'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'innahura'
  and p.node_type = 'location' and p.slug = 'lhaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'maamunagau', 'Maamunagau', 'Maamunagau is a resort island in Raa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maamunagau'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maamunagau'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'manafaru', 'Manafaru', 'Manafaru is a resort island in Haa Alif Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'manafaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'manafaru'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'muravandhoo', 'Muravandhoo', 'Muravandhoo is a resort island in Raa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'muravandhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'muravandhoo'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'vagaru', 'Vagaru', 'Vagaru is a resort island in Shaviyani Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vagaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vagaru'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'olhahali', 'Olhahali', 'Olhahali is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'olhahali'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'olhahali'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kandima', 'Kandima', 'Kandima is a resort island in Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kandima'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kandima'
  and p.node_type = 'location' and p.slug = 'dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kandolhu', 'Kandolhu', 'Kandolhu is a resort island in Alif Alif Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kandolhu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kandolhu'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'komandoo', 'Komandoo', 'Komandoo is a resort island in Lhaviyani Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'komandoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'komandoo'
  and p.node_type = 'location' and p.slug = 'lhaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kudadoo', 'Kudadoo', 'Kudadoo is a resort island in Lhaviyani Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kudadoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kudadoo'
  and p.node_type = 'location' and p.slug = 'lhaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'dhidhoofinolhu', 'Dhidhoofinolhu', 'Dhidhoofinolhu is a resort island in Alif Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhidhoofinolhu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhidhoofinolhu'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'huvahendhoo', 'Huvahendhoo', 'Huvahendhoo is a resort island in Alif Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'huvahendhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'huvahendhoo'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'maayafushi', 'Maayafushi', 'Maayafushi is a resort island in Alif Alif Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maayafushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maayafushi'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'makunudu', 'Makunudu', 'Makunudu is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'makunudu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'makunudu'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kuda-bandos', 'Kuda Bandos', 'Kuda Bandos is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kuda_bandos'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kuda-bandos'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'medhufushi', 'Medhufushi', 'Medhufushi is a resort island in Meemu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'medhufushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'medhufushi'
  and p.node_type = 'location' and p.slug = 'meemu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'meerufenfushi', 'Meerufenfushi', 'Meerufenfushi is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'meerufenfushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'meerufenfushi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'milaidhoo', 'Milaidhoo', 'Milaidhoo is a resort island in Baa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'milaidhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'milaidhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'mirihi', 'Mirihi', 'Mirihi is a resort island in Alif Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'mirihi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'mirihi'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kuredhivaru', 'Kuredhivaru', 'Kuredhivaru is a resort island in Noonu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kuredhivaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kuredhivaru'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kudafolhudhoo', 'Kudafolhudhoo', 'Kudafolhudhoo is a resort island in Alif Alif Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kudafolhudhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kudafolhudhoo'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kudafunafaru', 'Kudafunafaru', 'Kudafunafaru is a resort island in Noonu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kudafunafaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kudafunafaru'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'vakarufalhi', 'Vakarufalhi', 'Vakarufalhi is a resort island in Alif Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vakarufalhi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vakarufalhi'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'helengeli', 'Helengeli', 'Helengeli is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'helengeli'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'helengeli'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'lobigili', 'Lobigili', 'Lobigili is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'lobigili'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'lobigili'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'sangeli', 'Sangeli', 'Sangeli is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'sangeli'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'sangeli'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'ailafushi', 'Ailafushi', 'Ailafushi is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'ailafushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'ailafushi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'maadhoo', 'Maadhoo', 'Maadhoo is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maadhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maadhoo'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'reethi-rah', 'Reethi Rah', 'Reethi Rah is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'reethi_rah'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'reethi-rah'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'konotta', 'Konotta', 'Konotta is a resort island in Gaafu Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'konotta'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'konotta'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'maafushivaru', 'Maafushivaru', 'Maafushivaru is a resort island in Alif Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maafushivaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maafushivaru'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'bolifushi', 'Bolifushi', 'Bolifushi is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'bolifushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'bolifushi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'madhiriguraidhoo', 'Madhiriguraidhoo', 'Madhiriguraidhoo is a resort island in Lhaviyani Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'madhiriguraidhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'madhiriguraidhoo'
  and p.node_type = 'location' and p.slug = 'lhaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'hadahaa', 'Hadahaa', 'Hadahaa is a resort island in Gaafu Alifu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hadahaa'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hadahaa'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'fari-islands', 'Fari Islands', 'Fari Islands is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fari_islands'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fari-islands'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'maamutaa', 'Maamutaa', 'Maamutaa is a resort island in Gaafu Alifu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maamutaa'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maamutaa'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'huruelhi', 'Huruelhi', 'Huruelhi is a resort island in Alif Dhaalu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'huruelhi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'huruelhi'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'meradhoo', 'Meradhoo', 'Meradhoo is a resort island in Gaafu Alifu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'meradhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'meradhoo'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'kudafares', 'Kudafares', 'Kudafares is a resort island in Laamu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kudafares'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kudafares'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'fonimagoodhoo', 'Fonimagoodhoo', 'Fonimagoodhoo is a resort island in Baa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fonimagoodhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fonimagoodhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'filaidhoo', 'Filaidhoo', 'Filaidhoo is a resort island in Raa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'filaidhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'filaidhoo'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'dhigurah', 'Dhigurah', 'Dhigurah is a resort island in Gaafu Alifu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhigurah'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhigurah'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'falhumaafushi', 'Falhumaafushi', 'Falhumaafushi is a resort island in Gaafu Alifu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'falhumaafushi'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'falhumaafushi'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'mahaanaelhihuraa', 'Mahaanaelhihuraa', 'Mahaanaelhihuraa is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'mahaanaelhihuraa'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'mahaanaelhihuraa'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'orivaru', 'Orivaru', 'Orivaru is a resort island in Noonu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'orivaru'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'orivaru'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'funamadua', 'Funamadua', 'Funamadua is a resort island in Gaafu Alifu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'funamadua'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'funamadua'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'horubadhoo', 'Horubadhoo', 'Horubadhoo is a resort island in Baa Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'horubadhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'horubadhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'embudu-finolhu', 'Embudu Finolhu', 'Embudu Finolhu is a resort island in Kaafu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'embudu_finolhu'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'embudu-finolhu'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'mushimasgali', 'Mushimasgali', 'Mushimasgali is a resort island in Alif Alif Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'mushimasgali'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'mushimasgali'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;
