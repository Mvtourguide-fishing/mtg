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

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'hard-rock-hotel-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'akasdhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'hard-rock-hotel-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Silver Beach Studio', 600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'hard-rock-hotel-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Pletinum Water Villa', 820, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'hard-rock-hotel-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Heritance-Aarah
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'heritance-aarah-maldives-island-resort', 'Heritance Aarah Maldives Island Resort', 'Return to Heritance Aarah… Wake up to the sound of the sea in paradise, dive among unique underwater wonders, and dine beneath a beautiful star-studded sky over one of the greatest Maldives luxury resorts.', 'published', 'Heritance Aarah Maldives Island Resort | Maldives Resorts | MTG', 'Return to Heritance Aarah… Wake up to the sound of the sea in paradise, dive among unique underwater wonders, and dine beneath a beautiful star-studded sky over one of the greatest Maldives luxury resorts.', '{"overview_paragraphs":["Return to Heritance Aarah… Wake up to the sound of the sea in paradise, dive among unique underwater wonders, and dine beneath a beautiful star-studded sky over one of the greatest Maldives luxury resorts.","With golden sands at your doorstep and the pull of the sea all around, the options for relaxation and pleasure at our Beach Villa in Maldives seem limitless. Each house is elegantly constructed and has immediate beach access as well as a wide open-air terrace where you can soak in the lovely coastal environment.","Our trademark accommodation, the beautiful Pool Beach Villa, includes a private pool with sun loungers. This Maldives pool property has immediate beach access, ideal for a refreshing plunge in the Indian Ocean''s stunning seas.","Our Ocean Villas, which lie over a beautiful lagoon and overlook a limitless horizon, are the ideal getaway for romantic times. These exquisite Maldives overwater villas provide a separate outdoor space where you may snuggle up on a daybed together or step down to the seas below.","For solitude, Heritance Aarah has 150 villas and suites divided by tropical flora. Every property has immediate access to the pure sandy beach and the stunning blue lagoon beyond. The Resort was planned and developed with a combination of indigenous Maldivian and modern architecture, providing an overall contemporary luxury feel with a Maldivian touch - delivering solitude and comfort for a well-deserved vacation experience.","The resort is located in Raa Atoll, in a picturesque lagoon surrounded by an unending stretch of white sandy beach, and provides visitors with a premium 5-star Maldivian resort experience. A 40-minute seaplane flight from Velana International Airport provides stunning views of the Indian Ocean."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 900, 'kEchVUUdLCg', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'heritance-aarah-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'heritance-aarah-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'aarah'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'heritance-aarah-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 900, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'heritance-aarah-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1000, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'heritance-aarah-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 950, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'heritance-aarah-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Hideaway-Beach
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'hideaway-beach-resort-spa-maldives-island', 'Hideaway Beach Resort & Spa Maldives Island', 'Enjoy the ultimate Maldives beach holiday experience at Hideaway Beach Resort & Spa with our White Platinum All Inclusive Plan. We think that the finest vacations happen naturally, so we''ve included everything you could want in your White Platinum Plan, from excellent meals to fantastic adventures.', 'published', 'Hideaway Beach Resort & Spa Maldives Island | Maldives Resorts | MTG', 'Enjoy the ultimate Maldives beach holiday experience at Hideaway Beach Resort & Spa with our White Platinum All Inclusive Plan. We think that the finest vacations happen naturally, so we''ve included everything you could want in your White Platinum Plan, from excellent meals to fantastic adventures.', '{"overview_paragraphs":["Enjoy the ultimate Maldives beach holiday experience at Hideaway Beach Resort & Spa with our White Platinum All Inclusive Plan. We think that the finest vacations happen naturally, so we''ve included everything you could want in your White Platinum Plan, from excellent meals to fantastic adventures.","The Sunset Beach Villa is a cosy home away from home in a tropical paradise - an excellent setting for a relaxing Maldives beach vacation. This beachside home epitomises understated elegance, located on your very own private beach only moments away from the welcoming blue of the Indian Ocean. In addition to the main bedroom, the villa offers a separate living space. The Sunset Beach Villa includes its own Personal Butler to assist you in tailoring your stay and attending to your requirements.","The Beach Residence with Plunge Pool at Hideaway Beach Resort and Spa in the Maldives is your very own hidden beach home - a luxury villa, the ideal spot to unwind and appreciate paradise''s luxurious surrounds. The villa itself has a living and dining space, a master bedroom, and a spacious bathroom with a jacuzzi bath tub. This villa may be configured to suit families or groups of people. A master bedroom that can be locked affords total seclusion. Its own white sand beach is readily accessible from both the bright and large bedroom and living area. The Beach Residence with Plunge Pool includes its own Personal Butler to assist you in tailoring your stay and attending to your requirements.","The Deluxe Water Villa with Pool at Hideaway Beach Resort and Spa in the Maldives is the pinnacle of Maldivian luxury villa vacations. Allow yourself to be surrounded by the beauty and immensity of the ocean. Built on wooden stilts above the glistening blue lagoon, with floor-to-ceiling windows that maximise the spectacular panoramic Maldivian views. The Deluxe Water Villa with Pool is divided into two portions by an entry space, with the main bedroom on one side and the bathroom on the other. The enormous outside terrace runs the entire length of the property. Couples will appreciate this aquatic hideaway''s subtle modern comfort.","The 103 apartments are located on the beach among coconut trees and lush flora, or on stilts over the lovely lagoon, and provide world-class services as well as incomparable solitude. Each villa at Hideaway Beach Resort Maldives has its own butler to take care of all requirements. Our 10 various villa models, ranging from 130 sqm to 1,420 sqm, are among the largest luxury villas in the Maldives, and all beachfront villas have their own private beach.","Hideaway Beach Resort & Spa is located on the crescent-shaped Dhonakulhi Island in the Maldives'' northwestern Haa Alifu Atoll. Malé is 290 kilometres away."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 700, 'cckWsTSD3l4', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'hideaway-beach-resort-spa-maldives-island'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'hideaway-beach-resort-spa-maldives-island'
  and l.node_type = 'location' and l.slug = 'dhonakulhi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'hideaway-beach-resort-spa-maldives-island'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunset Beach Villa', 700, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'hideaway-beach-resort-spa-maldives-island'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Residence With Pool', 880, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'hideaway-beach-resort-spa-maldives-island'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Water Villa With Pool', 1220, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'hideaway-beach-resort-spa-maldives-island'
on conflict (accommodation_id, name) do nothing;

-- Hotel-Riu
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'riu-palace-maldives-island-resort', 'RIU Palace Maldives Island Resort', 'If you want to spend a luxurious vacation in a tropical paradise, Hotel Riu Palace Maldivas is the place to stay. This Maldives all-inclusive resort is located on the private island of Kedhigandu and provides 24-hour all-inclusive service, free Wi-Fi throughout the hotel, a variety of restaurants, and several leisure and entertainment opportunities.', 'published', 'RIU Palace Maldives Island Resort | Maldives Resorts | MTG', 'If you want to spend a luxurious vacation in a tropical paradise, Hotel Riu Palace Maldivas is the place to stay. This Maldives all-inclusive resort is located on the private island of Kedhigandu and provides 24-hour all-inclusive service, free Wi-Fi throughout the hotel, a variety of restaurants, and several leisure and entertainment opportunities.', '{"overview_paragraphs":["If you want to spend a luxurious vacation in a tropical paradise, Hotel Riu Palace Maldivas is the place to stay. This Maldives all-inclusive resort is located on the private island of Kedhigandu and provides 24-hour all-inclusive service, free Wi-Fi throughout the hotel, a variety of restaurants, and several leisure and entertainment opportunities.","To make your stay as comfortable as possible, the Hotel Riu Palace Maldives offers Junior Suites in various villas, as well as rare overwater suites, some of which have tiny private pools. Its more than 150 rooms have minibars, beverage dispensers, kettles, air conditioning, and satellite television, among other amenities.","If you wish to stay on the beach, these junior rooms at the Hotel Riu Palace Maldives are an excellent alternative. These 40-square-meter rooms have a king-size bed (200x200 cm) or two tiny double beds (125x200 cm), a sofa or sofa-bed in the living area, satellite TV, air conditioning, a ceiling fan, drink dispensers, a minibar, and a kettle. Furthermore, the beachside terrace will make your vacation experience one-of-a-kind.","These exquisite accommodations on the water will provide you with an amazing vacation. These 47-square-meter suites at the Hotel Riu Palace Maldives have one king-size bed (200x200 cm) or two tiny double beds (125x200 cm), a couch in the living area, satellite TV, air conditioning, a ceiling fan, drink dispensers, a minibar, and a kettle. In addition, there is a bathtub, a Balinese bed, sun loungers, and direct access to the sea on the terrace.","The RIU Palace Maldives will have 176 land-based villas with direct sea access and water villas with a private terrace and stairs going to the sea, some of which will have private pools. The Overwater Villas at RIU Palace are believed to be the most luxury since they will include a private pool and baths on the terrace with direct access to the tiny lagoon.","RIU Palace Maldives is located on the pristine island of Gadifuri, part of Dhaalu Atoll, and is connected to their sister resort, RIU Atoll, via a walkway. Its proximity to Kudahuvadhoo Island, which also has a domestic airport, will make getting to these two resorts a breeze."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 400, 'LlGWVpZYozE', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'riu-palace-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'riu-palace-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'kedhigandu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'riu-palace-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Junior Suite With Beach Access', 400, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'riu-palace-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Overwater Suite', 680, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'riu-palace-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Hurawalhi-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'hurawalhi-island-resort-maldives', 'Hurawalhi Island Resort Maldives', 'Hurawalhi Island Resort, located on an idyllic private island in the Maldives'' pristine Lhaviyani Atoll, is much like your relationship: it is a perfect balance of calm and excitement, comfort and adventure; it stirs up your every atom with an intricate blend of closeness and adrenaline.', 'published', 'Hurawalhi Island Resort Maldives | Maldives Resorts | MTG', 'Hurawalhi Island Resort, located on an idyllic private island in the Maldives'' pristine Lhaviyani Atoll, is much like your relationship: it is a perfect balance of calm and excitement, comfort and adventure; it stirs up your every atom with an intricate blend of closeness and adrenaline.', '{"overview_paragraphs":["Hurawalhi Island Resort, located on an idyllic private island in the Maldives'' pristine Lhaviyani Atoll, is much like your relationship: it is a perfect balance of calm and excitement, comfort and adventure; it stirs up your every atom with an intricate blend of closeness and adrenaline.","Hurawalhi is where you may fill your days with an abundance of extraordinary people, your head with wonder, and your heart with romance. The 90-villa, adults-only luxury resort is as beautiful as the ocean that laps against its beaches and more stunning than any island you''ve ever seen. Nothing prepares you for the stunning combination of barefoot joy and contemporary style found at Hurawalhi than photographs of the Maldives.","Enjoy the best of seaside happiness - Beach Pool Villas have a clean, unassuming appeal and an outstanding location on Hurawalhi''s attractive beach. They are popular with couples whose dream vacation includes seaside luxury.","The Maldives'' grandeur is epitomised by sleek and beautiful homes hung over the gleaming Indian Ocean. Slip into the lagoon from the sundeck and experience Hurawalhi''s spectacular grandeur from the solitude of your villa or your very own infinity pool.","Hurawalhi Island Resort''s villas pamper with opulent luxury, exclusivity, and breathtaking views. With the option of beach-side or over-water luxury, you may enjoy your chosen perspective and setting while having paradise at your fingertips - with the ocean just outside your door.","Hurawalhi Island Resort, nestled away in the north of the pristine Lhaviyani Atoll, combines striking natural beauty and elegant design. During the day, a picturesque 40-minute seaplane ride from Velana'' International Airport will take you to this tropical paradise (MLE). The resort is situated on a private coral island that is approximately 400 m x 165 m in size and is surrounded by the Indian Ocean; the year-round warmth of the water in which Hurawalhi Island Resort is situated is comparable to the shades and variations of blue that stretch out as far as the eye can see."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 900, 'xznjFXZmNPI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'hurawalhi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'hurawalhi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'hurawalhi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'hurawalhi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1150, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'hurawalhi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'hurawalhi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Innahura
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'innahura-maldives-island-resort', 'Innahura Maldives Island Resort', 'Innahura''s formula for a fantastic Maldives vacation is simple: we take the key sun, sea, and sand ingredients, add a traditional twist to modern amenities, and top it off with a large dose of unique experiences. This modest jewel in the south-east Lhaviyani Atoll entices sunseekers, young and old, who are looking for a Maldives resort where letting your hair down and savouring life''s simple pleasures are the norm. You''ll fall in love with Innahura because it''s laid-back, fun, and constantly ready for new adventures, just like you.', 'published', 'Innahura Maldives Island Resort | Maldives Resorts | MTG', 'Innahura''s formula for a fantastic Maldives vacation is simple: we take the key sun, sea, and sand ingredients, add a traditional twist to modern amenities, and top it off with a large dose of unique experiences. This modest jewel in the south-east Lhaviyani Atoll entices sunseekers, young and old, who are looking for a Maldives resort where letting your hair down and savouring life''s simple pleasures are the norm. You''ll fall in love with Innahura because it''s laid-back, fun, and constantly ready for new adventures, just like you.', '{"overview_paragraphs":["Innahura''s formula for a fantastic Maldives vacation is simple: we take the key sun, sea, and sand ingredients, add a traditional twist to modern amenities, and top it off with a large dose of unique experiences. This modest jewel in the south-east Lhaviyani Atoll entices sunseekers, young and old, who are looking for a Maldives resort where letting your hair down and savouring life''s simple pleasures are the norm. You''ll fall in love with Innahura because it''s laid-back, fun, and constantly ready for new adventures, just like you.","Palm trees sway in the air, loungers vie for your attention under them, a length of sand so silky it tickles your feet and takes you from your bungalow to a lagoon as clear as it gets - welcome to Innahura! This is most likely how you imagined your Maldives vacation...","Innahura''s allure rests in his return to simplicity. The bungalows at the resort are designed for folks like you and me: they are simple yet comfortable, unassuming yet unforgettable. They deliver on the promise of a tropical, laid-back refuge from which to lavish on the island''s many attractions. These bright bungalows are big, on the beach, with a minibar, and private sunloungers - these are all your Maldives fantasies are made of, without the expensive price tag.","Innahura Maldives has 78 luxurious accommodations, including 33 Sunset Beach Bungalows and 45 Sunrise Beach Bungalows, as well as 4 neighbouring bungalows for families.","The island of Innahura Maldives is located in the Lhaviyani Atoll to the north of the Maldives. It takes 40 minutes by seaplane, during which you may enjoy a breathtaking view of the Maldives'' garland of islands.","Life is better at the beach, especially when accompanied with delicious food, refreshing beverages, and great company. The resort''s venues bring it all together and contribute to the mix of Innahura''s characteristic casual ambiance; mellow places that keep your tummy full, your thirst satiated, and your days filled with get-togethers and unplanned meet-ups with newly made friends."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 300, '6JHqOSK--sw', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'innahura-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'innahura-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'innahura'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'innahura-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Villa', 300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'innahura-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- InterContinental
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'intercontinental-maldives-maamunagau-island-resort', 'InterContinental Maldives Maamunagau Island Resort', 'In the vast azure panorama of the Indian Ocean, escape and reconnect with nature, yourself, and those who mean most. From the time you board the seaplane to the serene shores of the Raa Atoll, you will be captivated by island life with silky white dunes and palm tree dotted terraces. Prepare to be astounded by the abundance of marine life in our lagoon, which is near to the UNESCO Biosphere Reserve and has a unique manta ray sanctuary.', 'published', 'InterContinental Maldives Maamunagau Island Resort | Maldives Resorts | MTG', 'In the vast azure panorama of the Indian Ocean, escape and reconnect with nature, yourself, and those who mean most. From the time you board the seaplane to the serene shores of the Raa Atoll, you will be captivated by island life with silky white dunes and palm tree dotted terraces. Prepare to be astounded by the abundance of marine life in our lagoon, which is near to the UNESCO Biosphere Reserve and has a unique manta ray sanctuary.', '{"overview_paragraphs":["In the vast azure panorama of the Indian Ocean, escape and reconnect with nature, yourself, and those who mean most. From the time you board the seaplane to the serene shores of the Raa Atoll, you will be captivated by island life with silky white dunes and palm tree dotted terraces. Prepare to be astounded by the abundance of marine life in our lagoon, which is near to the UNESCO Biosphere Reserve and has a unique manta ray sanctuary.","When you hire the entire island for an intimate family celebration or business trip, you will find something for everyone with a variety of eating places, miles of beautiful beach, and a choice of recreational and wellness activities.","The InterContinental Maldives Maamunagau Resort''s spacious 81 Beach, Lagoon, and Overwater Villas and Residences provide stunning views of the Maldives. Choose between relaxing lagoon or dramatic ocean views from your private patio, and enjoy a beautiful dawn or sunset.","The resort is located on a private island in Raa Atoll, 152 kilometres north of Velana International Airport. Guests will be charmed by the unusual marine life, which includes manta rays and dolphins, since it is located adjacent to the Baa Atoll UNESCO Reserve. Among these intriguing spots to visit nearby, Hanifaru Bay is 35 minutes away by speedboat and is well-known for being a nursery ground for grey sharks and sting rays.","Simple yet remarkable, guests will begin on a gastronomic adventure from the top of the Lighthouse with a predinner cocktail and rare 360 degree views of the Indian Ocean, followed by a personalised private dining experience or a communal sharing dinner at the main restaurant area.","AVI Spa is meant to rejuvenate the spirit by waking the senses and is inspired by the ethereality of the ocean and the transforming power of clean island air. Rejuvenate in one of six over-the-water treatment villas, each of which uses the psychology of natural light and sound to put you in a profound state of relaxation."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 800, 'enmAUSapMec', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'intercontinental-maldives-maamunagau-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'intercontinental-maldives-maamunagau-island-resort'
  and l.node_type = 'location' and l.slug = 'maamunagau'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'intercontinental-maldives-maamunagau-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1200, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'intercontinental-maldives-maamunagau-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Overwater Pool Villa', 800, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'intercontinental-maldives-maamunagau-island-resort'
on conflict (accommodation_id, name) do nothing;

-- JA-Manafaru
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'ja-manafaru-maldives-island-resort', 'JA Manafaru Maldives Island Resort', 'Dreams of Romance in a Tropical Island Paradise Experience an enchanting island retreat in the Maldives'' remote sanctuary of JA Manafaru. A tropical Maldives resort in the Indian Ocean blends the tranquillity of the Maldives with six venues, extra In-villa and Destination Dining offers, numerous recreational activities, and unique spa and wellness amenities.', 'published', 'JA Manafaru Maldives Island Resort | Maldives Resorts | MTG', 'Dreams of Romance in a Tropical Island Paradise Experience an enchanting island retreat in the Maldives'' remote sanctuary of JA Manafaru. A tropical Maldives resort in the Indian Ocean blends the tranquillity of the Maldives with six venues, extra In-villa and Destination Dining offers, numerous recreational activities, and unique spa and wellness amenities.', '{"overview_paragraphs":["Dreams of Romance in a Tropical Island Paradise Experience an enchanting island retreat in the Maldives'' remote sanctuary of JA Manafaru. A tropical Maldives resort in the Indian Ocean blends the tranquillity of the Maldives with six venues, extra In-villa and Destination Dining offers, numerous recreational activities, and unique spa and wellness amenities.","Set amid a beautiful oasis around the resort''s main swimming pool, the Mediterranean-inspired Bistro is available for lunch and afternoon meals until early evening. Ideal for couples and families that require all-day dining till late meal.","Pool on the beach Villa surrounded by tropical vegetation, just steps from the gorgeous beach and your private beach cabana. Cozy living rooms with an open-air bathroom that leads to an attractive sundeck, a pool, a daybed and sun loungers in the garden and on the beach. While dining al fresco in your private beach dining cabana, take in the wind.","Wake awake to the sound of the Indian Ocean. As the sun rises over the horizon, watch the water below your villa reflect the morning light from your sun terrace. Connect with nature directly from your villa or view from the glass floor panel in luxury. Relax your body and mind in your own infinity pool or on the terrace with the most breathtaking views.","Do you fantasise of a romantic getaway in your own overwater villa with direct access to the ocean? Maybe you fantasise of walking out of your Beach Villa onto the lovely beach that surrounds the island. Whatever your heart desires, we offer many of alternatives for your island stay, and all of them include your very own private plunge pool and daily breakfast. Discover nature''s splendours at their best. Whether you choose beachfront or waterfront living, each of JA Manafaru''s 84 villas and homes has been designed to fit in with the island''s natural scenery.","Domestic flight: The trip from Male'' International Airport to Hanimadhoo Island takes around 55 minutes. After that, a 45-minute speedboat ride from Hanimadhoo Island to JA Manafaru Private Island follows. Private seaplane flight: The voyage from Male'' International Airport to JA Manafaru Private Island takes around 90 minutes."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 1200, 'RUmR4femVf4', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'ja-manafaru-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'ja-manafaru-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'manafaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'ja-manafaru-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1200, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'ja-manafaru-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Water Villa Pool', 1400, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'ja-manafaru-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- JOALI
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'joali-maldives-island-resort', 'JOALI Maldives Island Resort', 'Our tale began with the ambition of creating a one-of-a-kind creative resort in the beautiful Raa Atoll. Thus was created JOALI Maldives, an utopia of creativity, pleasure, and adventure. Through a magnificent collection of artworks that spread over the island, visitors may feel the joy of life.', 'published', 'JOALI Maldives Island Resort | Maldives Resorts | MTG', 'Our tale began with the ambition of creating a one-of-a-kind creative resort in the beautiful Raa Atoll. Thus was created JOALI Maldives, an utopia of creativity, pleasure, and adventure. Through a magnificent collection of artworks that spread over the island, visitors may feel the joy of life.', '{"overview_paragraphs":["Our tale began with the ambition of creating a one-of-a-kind creative resort in the beautiful Raa Atoll. Thus was created JOALI Maldives, an utopia of creativity, pleasure, and adventure. Through a magnificent collection of artworks that spread over the island, visitors may feel the joy of life.","An art-infused luxury island resort located on Muravandhoo Island in Raa Atoll in the Maldives'' northernmost reaches. Coral reefs teem with life and colour where lovely white dunes meet magnificent blue seas. Raise a glass to long-lasting glamour in this enchanted realm, a constant expression of joie de vivre.","Our luxurious one-bedroom beach home offers views of the Maldives'' beach, garden, and ocean. Featuring hand-selected art objects, a private beach garden, and an infinity pool.","Discover the allure of ocean life from this one-bedroom water cottage. You are in for an unforgettable luxury resort experience.","Discover the best of island living. Awaken to glistening seascapes and delicate white dunes. Experience the awe of an impressionist sunset. Allow the waves to lull you to sleep. The Indian Ocean is your constant companion, bringing you joy at all hours of the day and night. The magnificent private villas and houses at the resort epitomise sustainable luxury. Each of JOALI''s 73 villas was inspired by a different story and was created to take visitors on a sensory journey. An environment of unusual luxury is created through artisanal amenities, selected in-room book shelves, careful décor, and exquisite objet d''art.","JOALI Maldives is located on Muravandhoo island in the Raa Atoll in the Maldives'' northernmost region. Arriving guests will be welcomed inside the special JOALI airport lounge at Male Airport. Before your transfer to the resort, you may unwind there. Transfer takes 40 minutes by seaplane or 35 minutes by domestic flight followed by 15 minutes by speedboat."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 2300, '0VIhza1IyE0', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'joali-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'joali-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'muravandhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'joali-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 2900, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'joali-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa Pool', 2300, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'joali-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- JW-Marriott
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'jw-marriott-maldives-island-resort', 'JW Marriott Maldives Island Resort', 'JW Marriott Maldives Resort & Spa is a picturesque luxury haven on the blue seas of Shaviyani Atoll. Relax in contemporary overwater villas and beach villas with luxurious mattresses, private pools, and decks with breathtaking views of the Indian Ocean. At our different dining places, delight your palette with exceptional Japanese, Italian, and world cuisine, as well as treetop dining and buffet breakfasts. Explore a wide range of sports such as snorkelling, scuba diving, jet skiing, and sailing. Our Little Griffins kids'' group allows children to have their own experiences in the Maldives. Refresh in our dazzling pool or have an intense workout in our modern fitness centre. Make a wonderful day in Shaviyani Atoll with a refreshing beauty or massage treatment.', 'published', 'JW Marriott Maldives Island Resort | Maldives Resorts | MTG', 'JW Marriott Maldives Resort & Spa is a picturesque luxury haven on the blue seas of Shaviyani Atoll. Relax in contemporary overwater villas and beach villas with luxurious mattresses, private pools, and decks with breathtaking views of the Indian Ocean. At our different dining places, delight your palette with exceptional Japanese, Italian, and world cuisine, as well as treetop dining and buffet breakfasts. Explore a wide range of sports such as snorkelling, scuba diving, jet skiing, and sailing. Our Little Griffins kids'' group allows children to have their own experiences in the Maldives. Refresh in our dazzling pool or have an intense workout in our modern fitness centre. Make a wonderful day in Shaviyani Atoll with a refreshing beauty or massage treatment.', '{"overview_paragraphs":["JW Marriott Maldives Resort & Spa is a picturesque luxury haven on the blue seas of Shaviyani Atoll. Relax in contemporary overwater villas and beach villas with luxurious mattresses, private pools, and decks with breathtaking views of the Indian Ocean. At our different dining places, delight your palette with exceptional Japanese, Italian, and world cuisine, as well as treetop dining and buffet breakfasts. Explore a wide range of sports such as snorkelling, scuba diving, jet skiing, and sailing. Our Little Griffins kids'' group allows children to have their own experiences in the Maldives. Refresh in our dazzling pool or have an intense workout in our modern fitness centre. Make a wonderful day in Shaviyani Atoll with a refreshing beauty or massage treatment.","JW Marriott Maldives Resort & Spa offers 60 luxury Beach and Overwater Pool Villas with living sizes ranging from 234 sqm to 285 sqm. Our beautiful and large Beach and Overwater Pool Villas are suitable for both couples and families visiting Maldives, with contemporary and airy décor offering the utmost seclusion and tranquillity. From your private villa terrace with its own huge private wooden deck, pool, and outdoor shower, you may enjoy an unimpeded view of the Indian Ocean or our island''s beautiful tropical gardens. Each villa at the JW Marriott Maldives Resort & Spa is inspired by the natural surroundings and Maldivian culture, with colours and materials that reflect the island locale. Villas'' thatched roofs are suggestive of upside-down Dhoni boats, Maldives'' traditional wooden fishing vessels, and sloping roof tips are reminiscent of white herons dipping their heads into the ocean.","JW Marriott Maldives Resort & Spa provides a tropical island haven with 61 magnificent Beach and Overwater Pool villas in the remote Shaviyani Atoll. The Villas have been created with modern roomy and airy interiors that give an intimate setting that allows for seclusion while still providing thoughtful interacting places if desired.","JW Marriott Maldives Resort & Spa is located on the beautiful island of Van''gaaru in the Shaviyani Atoll, a picturesque 55-minute seaplane ride from Velana International Airport in Male, Maldives.","JW Marriott Maldives Resort & Spa offers a diverse range of gastronomic experiences. Begin your day with a hearty breakfast at Aailaa, then order your favourite pizza from Fiamma for a quiet lunch by the pool, or spice up your day with genuine Thai food from Kaashi. Horizon offers a tranquil view of the Maldivian sunset while serving your favourite cocktails. Visit our Wine Room for a wine-pairing dining experience, or Rum Baan to build your own drink. For pre-dinner beverages, try our famous smoked cocktails at Wabi Sabi before indulging in Japanese delicacies at Hashi or the best prime cut meats and crustaceans at Shio, our namesake restaurant.","We believe that genuine well-being begins with mind-body harmony at Spa by JW. As a result, we design places that can support a variety of health activities, from activeness to more restorative mindfulness periods, while letting in natural light and enabling access to more natural settings. There is no better place in the world to experiment with natural remedies than on a private island paradise. Join us for a Personal Training Session, a Personal Yoga Class, or a Guided Meditation to revitalise your mind, body, and spirit."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 750, 'EHZiO7QOToA', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'jw-marriott-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'jw-marriott-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'vagaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'jw-marriott-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Pool Villa', 800, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'jw-marriott-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Over Water Villa Pool', 750, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'jw-marriott-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Jumeirah-Olhahali
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'jumeirah-maldives-olhahali-island-resort', 'Jumeirah Maldives Olhahali Island Resort', 'The Jumeirah Maldives Olhahali Island is an all-day dining venue with professional chefs serving a diverse menu of foreign delicacies. Take in the soft sea breeze on the open-air terrace atop the seclusion of your beautiful villa while you revel in your rooftop movie experience, whether it''s a treasured family event or a significant romantic getaway. Our beach boutique offers an uplifting luxury experience for discerning travellers seeking serenity away from it all. Discover a diverse range of outstanding and ecologically responsible resort wear, menswear, womenswear, childrenswear, accessories, and jewellery from across the world, as well as Maldivian crafts.', 'published', 'Jumeirah Maldives Olhahali Island Resort | Maldives Resorts | MTG', 'The Jumeirah Maldives Olhahali Island is an all-day dining venue with professional chefs serving a diverse menu of foreign delicacies. Take in the soft sea breeze on the open-air terrace atop the seclusion of your beautiful villa while you revel in your rooftop movie experience, whether it''s a treasured family event or a significant romantic getaway. Our beach boutique offers an uplifting luxury experience for discerning travellers seeking serenity away from it all. Discover a diverse range of outstanding and ecologically responsible resort wear, menswear, womenswear, childrenswear, accessories, and jewellery from across the world, as well as Maldivian crafts.', '{"overview_paragraphs":["The Jumeirah Maldives Olhahali Island is an all-day dining venue with professional chefs serving a diverse menu of foreign delicacies. Take in the soft sea breeze on the open-air terrace atop the seclusion of your beautiful villa while you revel in your rooftop movie experience, whether it''s a treasured family event or a significant romantic getaway. Our beach boutique offers an uplifting luxury experience for discerning travellers seeking serenity away from it all. Discover a diverse range of outstanding and ecologically responsible resort wear, menswear, womenswear, childrenswear, accessories, and jewellery from across the world, as well as Maldivian crafts.","A isolated one-bedroom villa with its own infinity pool that ends only with the atoll''s beautiful dunes and blue ocean. Relax on your rooftop or poolside and enjoy views that are uniquely yours.","Our Water Villa is perched atop the coral, on a pier extending out into the blue waters of the North Lagoon. From your private rooftop terrace, where you may dine or simply rest, you can see even further across the ocean. Sit in a covered sunken salon on the lower deck, or chill off and drift in your own pool.","Each house is capped with a stunning private Sky-Lounge for the first time in the Maldives. Every room, whether on the beach or on stilts over water, has a private pool and an inspiring expanse of sky-lounge roof deck. With all seven accommodation types elevating indoor-outdoor living to new heights of breezy sophistication, this is a Maldives-exclusive elevated island experience.","It takes 45 minutes by luxury speedboat from Velana International Airport to reach this tiny resort, which is a visual feast of nautical forms and tones. Each of the 67 double-story villas offers a private pool with a vibrant South Beach vibe, thanks to the new vision of Singaporean design studio Miaja.","Set sail over the glistening sea on one of Jumeirah Maldives'' special yachts, from awe-inspiring sunset cruises to a joyous adventure in search of the friendly Maldivian dolphins. Guests at Jumeirah Maldives may also book chartered tailored excursions, including as fishing trips or visits to other local islands."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 2100, 'EAExZzTcTGI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'jumeirah-maldives-olhahali-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'jumeirah-maldives-olhahali-island-resort'
  and l.node_type = 'location' and l.slug = 'olhahali'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'jumeirah-maldives-olhahali-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 2300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'jumeirah-maldives-olhahali-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa Pool', 2100, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'jumeirah-maldives-olhahali-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Kandima
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'kandima-maldives-island-resort', 'Kandima Maldives Island Resort', 'KWelcome to one of the world''s most beautiful islands: a UNESCO Biosphere Reserve wilderness where iridescent blues, jungle greens, and bright whites collide with innovation, conservation, and health. Snorkel with manta rays in aquarium-like waters, help sea turtles at our Marine Discovery Centre, relax at AyurMa, and eat at Blu Beach Club. Kandima Maldives is more than simply a vacation; it''s a way of life! Experience this new game-changing location, which features 264 elegantly built apartments and villas, 10 amazing eating establishments, and a plethora of fun-filled activities. This very sophisticated resort welcomes visitors of all ages and income levels, including families, couples, groups of friends, and honeymooners. Kandima Maldives provides something for everyone, whether you''re looking for a romance holiday, aquatic adventures, fitness activities, spa escapes, or just family time. The island, located in the Dhaalu Atoll, is only a thirty-minute flight from Velana International Airport, followed by a twenty-minute boat journey to this very elegant island.', 'published', 'Kandima Maldives Island Resort | Maldives Resorts | MTG', 'KWelcome to one of the world''s most beautiful islands: a UNESCO Biosphere Reserve wilderness where iridescent blues, jungle greens, and bright whites collide with innovation, conservation, and health. Snorkel with manta rays in aquarium-like waters, help sea turtles at our Marine Discovery Centre, relax at AyurMa, and eat at Blu Beach Club. Kandima Maldives is more than simply a vacation; it''s a way of life! Experience this new game-changing location, which features 264 elegantly built apartments and villas, 10 amazing eating establishments, and a plethora of fun-filled activities. This very sophisticated resort welcomes visitors of all ages and income levels, including families, couples, groups of friends, and honeymooners. Kandima Maldives provides something for everyone, whether you''re looking for a romance holiday, aquatic adventures, fitness activities, spa escapes, or just family time. The island, located in the Dhaalu Atoll, is only a thirty-minute flight from Velana International Airport, followed by a twenty-minute boat journey to this very elegant island.', '{"overview_paragraphs":["KWelcome to one of the world''s most beautiful islands: a UNESCO Biosphere Reserve wilderness where iridescent blues, jungle greens, and bright whites collide with innovation, conservation, and health. Snorkel with manta rays in aquarium-like waters, help sea turtles at our Marine Discovery Centre, relax at AyurMa, and eat at Blu Beach Club. Kandima Maldives is more than simply a vacation; it''s a way of life! Experience this new game-changing location, which features 264 elegantly built apartments and villas, 10 amazing eating establishments, and a plethora of fun-filled activities. This very sophisticated resort welcomes visitors of all ages and income levels, including families, couples, groups of friends, and honeymooners. Kandima Maldives provides something for everyone, whether you''re looking for a romance holiday, aquatic adventures, fitness activities, spa escapes, or just family time. The island, located in the Dhaalu Atoll, is only a thirty-minute flight from Velana International Airport, followed by a twenty-minute boat journey to this very elegant island.","Welcome to your own cool and elegant hideaway. Take in the breathtaking view of Kandima''s huge lagoon from above the treetops, or just walk to the shore. Do you require extra space? We have 8 Two-Bedroom Family Sky Suites that are joined by a lounge space and are ideal for groups of friends or families that want to stay near together. That''s what we mean by \"home away from home.\"","Do you need some sea rehabilitation? These villas are perched overwater and have direct access to the lagoon, making them ideal for those looking for the ultimate overwater vacation. The private sundeck with sun loungers and a bathroom give a stunning view of Kandima''s expansive lagoon. Your daily \"vitamin sea\" dosage is assured.","Our 264 apartments and villas are not just elegantly pleasant, but also intelligent! Our apartments and villas are anything from average, with tech-savvy amenities, service at your fingertips, and bright and airy décor. Even if you''re miles from anything, you can stay connected with free Wi-Fi.","Kandima Maldives is located on one of the Maldives'' most secluded atolls. Only 7 of the atoll''s 57 islands are inhabited, making Dhaalu atoll one of the country''s most pristine places.","This trendy beach house on the beach with indoor and outdoor seating provides informal dining by day and sophisticated trademark dining on the beach by night. Enjoy an unlimited variety of Mediterranean cuisine, seafood, tapas, steaks, oven-baked pizzas, and great wines from our cellar. With a wide garden area, this restaurant is ideal for hosting outdoor gala dinner events for bigger parties or gatherings of family and friends."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, null, 'yUpZcB6oe_A', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'kandima-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'kandima-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'kandima'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'kandima-maldives-island-resort'
on conflict (id) do nothing;

-- Kandolhu
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'kandolhu-maldives-island-resort', 'Kandolhu Maldives Island Resort', 'An island as neatly constructed as Kandolhu is unusual even in the Maldives. The island is beautiful, with vast sandy beaches surrounding the emerald green water, and it is home to one of the Maldives'' most colourful and dynamic house reefs. Kandolhu is an amazing Maldives resort with just 30 villas that flawlessly integrate natural Maldivian elements with modern architecture and creature-comforts, creating an experience that will stay with you forever.', 'published', 'Kandolhu Maldives Island Resort | Maldives Resorts | MTG', 'An island as neatly constructed as Kandolhu is unusual even in the Maldives. The island is beautiful, with vast sandy beaches surrounding the emerald green water, and it is home to one of the Maldives'' most colourful and dynamic house reefs. Kandolhu is an amazing Maldives resort with just 30 villas that flawlessly integrate natural Maldivian elements with modern architecture and creature-comforts, creating an experience that will stay with you forever.', '{"overview_paragraphs":["An island as neatly constructed as Kandolhu is unusual even in the Maldives. The island is beautiful, with vast sandy beaches surrounding the emerald green water, and it is home to one of the Maldives'' most colourful and dynamic house reefs. Kandolhu is an amazing Maldives resort with just 30 villas that flawlessly integrate natural Maldivian elements with modern architecture and creature-comforts, creating an experience that will stay with you forever.","These one-of-a-kind Maldives beach villas on Kandolhu''s western coastlines have a king bed and a big open air garden bathroom with a jetted bathtub, shower, and twin vanity. A second outdoor shower has been installed in the backyard. The front veranda has a comfortable daybed and an eating area, while the neighbouring sundeck has sun loungers and a sun umbrella.","The magnificent Pool Villa, which faces east, has a spacious bedroom with a king-sized bed overlooking the pool and the turquoise lagoon beyond. Enter the big open air bathroom through the expansive wardrobe, which has a freestanding bath, shower, dual vanity, and an outside garden shower. These Maldives luxury homes have wide verandas with an outdoor daybed. Each outside deck features a 9-square-meter pool, sun loungers, a sun shade, and an eating area.","This exquisite seaside villa in the Maldives is located above the water and has A huge bedroom with a king bed, a daybed, and views of the ocean. This luxurious villa''s bathroom overlooks the lagoon and features a jetted bathtub, dual vanity, shower, and dressing space. The sun terrace is secluded and equipped with sun loungers, a sun umbrella, and stairs leading down to the water.","Kandolhu Maldives has 30 villas in 5 different designs, each with its own unique design. All homes have Maldivian architecture with contemporary decor. They are all in outstanding sites, having either immediate beach access or unobstructed views of the Indian Ocean.","Kandolhu Maldives is 70 kilometres from Velana International Airport and can be accessed by a 20-minute seaplane flight followed by a 15-minute speedboat ride."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 700, 'uvRrBgIp_1I', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'kandolhu-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'kandolhu-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'kandolhu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'kandolhu-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 700, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'kandolhu-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'kandolhu-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ocean Villa', 1100, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'kandolhu-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Komandoo-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'komandoo-island-resort-and-spa-maldives', 'Komandoo Island Resort and Spa Maldives', 'Komandoo is tailor-made for romance, combining the splendour of the Maldives with the charm of a tiny resort. A laid-back hideaway guaranteed by award-winning attentiveness and a variety of leisure activities, ideal for your honeymoon, a calm romantic holiday, or a trip with friends. Pure and uncomplicated paradise awaits. The Maldives is linked with honeymoons and unforgettable vacations, and it is a popular destination for adults-only retreats. One of the many reasons people pick the Maldives as a vacation destination is the ''One Island, One Resort'' idea.', 'published', 'Komandoo Island Resort and Spa Maldives | Maldives Resorts | MTG', 'Komandoo is tailor-made for romance, combining the splendour of the Maldives with the charm of a tiny resort. A laid-back hideaway guaranteed by award-winning attentiveness and a variety of leisure activities, ideal for your honeymoon, a calm romantic holiday, or a trip with friends. Pure and uncomplicated paradise awaits. The Maldives is linked with honeymoons and unforgettable vacations, and it is a popular destination for adults-only retreats. One of the many reasons people pick the Maldives as a vacation destination is the ''One Island, One Resort'' idea.', '{"overview_paragraphs":["Komandoo is tailor-made for romance, combining the splendour of the Maldives with the charm of a tiny resort. A laid-back hideaway guaranteed by award-winning attentiveness and a variety of leisure activities, ideal for your honeymoon, a calm romantic holiday, or a trip with friends. Pure and uncomplicated paradise awaits. The Maldives is linked with honeymoons and unforgettable vacations, and it is a popular destination for adults-only retreats. One of the many reasons people pick the Maldives as a vacation destination is the ''One Island, One Resort'' idea.","Komandoo''s Beach Villas, with their tastefully equipped environment reminiscent of traditional Maldives, are the ideal hideaway for those looking for a romantic break. Enjoy your own private terrace with views of Komandoo''s stunning blue lagoon. The Komandoo Beach Villas are huge timber bungalows tucked away along the beach. Each villa includes a wooden balcony from which to enjoy the sound of the ocean and the breathtaking scenery. These traditional Maldivian villas create a peaceful environment for your stay at Komandoo.","The most coveted villas on Komandoo ensure a magnificent and romantic setting for your stay in paradise. A spacious, partially roofed wooden terrace with a stairway running down to the water provides you with your own own slice of paradise. The tranquillity of the lagoon makes these villas an ideal choice for your honeymoon or a romantic holiday with your sweetheart. Relax in your own Jacuzzi or spa bath while staring out over the horizon where turquoise seas meet sapphire-colored skies.","Nothing says \"vacation\" like a lovely villa that provides much-needed peace and relaxation. Offering genuine Maldivian luxury and charm, as well as a picture-perfect site, either on the beach or above the lagoon. The villas at Komandoo will take your breath away with their lovely surroundings.","Komandoo is located in the Lhaviyani Atoll, a scenic 40-minute seaplane ride from Male\"s Velana International Airport.","Whether it''s a romantic lunch for two beneath the stars, a bountiful buffet, or fine dining, Komandoo provides great dining options for all occasions, including the opportunity to dine under the sea at our sister resort, Hurawalhi Maldives. Komandoo''s dining and drinking options are rounded out with a selection of bars where you may sip your favourite libation. Aqua, Komandoo''s a-la-carte restaurant, is just breathtaking. Diners may savour exquisite delicacies while perched on stilts over the lagoon, surrounded by the natural splendour of the Maldives."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 500, 'USCSU8yKo_Y', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'komandoo-island-resort-and-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'komandoo-island-resort-and-spa-maldives'
  and l.node_type = 'location' and l.slug = 'komandoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'komandoo-island-resort-and-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 500, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'komandoo-island-resort-and-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'JACUZZI WATER VILLA', 700, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'komandoo-island-resort-and-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- Kudadoo
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'kudadoo-maldives-private-island-resort', 'Kudadoo Maldives Private Island Resort', 'KUDADOO MALDIVES PRIVATE ISLAND PROVIDES A COMPLETE EXPERIENCE WITH EVERYTHING UNDER THE MOON AVAILABLE TO YOU AT ANY TIME AND FROM ANYWHERE. THIS PRIVATE ISLAND HAS BEEN DESIGNED FOR ESCAPES FROM THE CONFINES OF EVERYDAY LIFE AND IS SURE TO IMPRESS EVEN THE MOST DISCERNING TRAVELLER. MAGNIFICENT MOMENTS TAKE THE FORM OF DELICIOUS CULINARY CREATIONS, ENDLESS LEISURE ACTIVITIES, AND WELLNESS. SEIZE YOUR DAYS ON THIS TINY TROPICAL ISLAND WITH THE HELP OF YOUR PERSONAL BUTLER, WHO CAN ASSIST YOU IN CREATING THE PERFECT HOLIDAY ITINERARY. KUDADOO SETS A NEW STANDARD IN SUSTAINABLE LUXURY HOSPITALITY WITH THE ARCHITECTURAL MASTERMIND, YUJI YAMAZAKI; WE TAKE GREAT PRIDE IN THE FOLLOWING ACCOLADES: LUXURY TRAVEL INTELLIGENCE''S BEST NEW LUXURY HOTEL FOR 2018; ROBB REPORT''S BEST ISLAND RESORT 2019.', 'published', 'Kudadoo Maldives Private Island Resort | Maldives Resorts | MTG', 'KUDADOO MALDIVES PRIVATE ISLAND PROVIDES A COMPLETE EXPERIENCE WITH EVERYTHING UNDER THE MOON AVAILABLE TO YOU AT ANY TIME AND FROM ANYWHERE. THIS PRIVATE ISLAND HAS BEEN DESIGNED FOR ESCAPES FROM THE CONFINES OF EVERYDAY LIFE AND IS SURE TO IMPRESS EVEN THE MOST DISCERNING TRAVELLER. MAGNIFICENT MOMENTS TAKE THE FORM OF DELICIOUS CULINARY CREATIONS, ENDLESS LEISURE ACTIVITIES, AND WELLNESS. SEIZE YOUR DAYS ON THIS TINY TROPICAL ISLAND WITH THE HELP OF YOUR PERSONAL BUTLER, WHO CAN ASSIST YOU IN CREATING THE PERFECT HOLIDAY ITINERARY. KUDADOO SETS A NEW STANDARD IN SUSTAINABLE LUXURY HOSPITALITY WITH THE ARCHITECTURAL MASTERMIND, YUJI YAMAZAKI; WE TAKE GREAT PRIDE IN THE FOLLOWING ACCOLADES: LUXURY TRAVEL INTELLIGENCE''S BEST NEW LUXURY HOTEL FOR 2018; ROBB REPORT''S BEST ISLAND RESORT 2019.', '{"overview_paragraphs":["KUDADOO MALDIVES PRIVATE ISLAND PROVIDES A COMPLETE EXPERIENCE WITH EVERYTHING UNDER THE MOON AVAILABLE TO YOU AT ANY TIME AND FROM ANYWHERE. THIS PRIVATE ISLAND HAS BEEN DESIGNED FOR ESCAPES FROM THE CONFINES OF EVERYDAY LIFE AND IS SURE TO IMPRESS EVEN THE MOST DISCERNING TRAVELLER. MAGNIFICENT MOMENTS TAKE THE FORM OF DELICIOUS CULINARY CREATIONS, ENDLESS LEISURE ACTIVITIES, AND WELLNESS. SEIZE YOUR DAYS ON THIS TINY TROPICAL ISLAND WITH THE HELP OF YOUR PERSONAL BUTLER, WHO CAN ASSIST YOU IN CREATING THE PERFECT HOLIDAY ITINERARY. KUDADOO SETS A NEW STANDARD IN SUSTAINABLE LUXURY HOSPITALITY WITH THE ARCHITECTURAL MASTERMIND, YUJI YAMAZAKI; WE TAKE GREAT PRIDE IN THE FOLLOWING ACCOLADES: LUXURY TRAVEL INTELLIGENCE''S BEST NEW LUXURY HOTEL FOR 2018; ROBB REPORT''S BEST ISLAND RESORT 2019.","YOUR SECLUDED HIDEAWAY IS LOCATED ON TOP OF AN AQUAMARINE LAGOON. THE RESIDENCES ON KUDADOO MALDIVES PRIVATE ISLAND HAVE CAREFULLY CRAFTED INTERIORS AND EXTERIORS. THEY BRING FREEDOM OF TIME, SPACE, AND UNRESTRICTED CONNECTIONS. IN PRECIOUS MOMENTS OF INDULGENCE, AN ENVIRONMENTALLY CONSCIOUS DESIGN, SHEER COMFORT, AND THE UTMOST PRIVACY COME TOGETHER. THIS IS A PLACE WHERE YOU CAN EXPLORE YOURSELF.","Hurawalhi''s Kudadoo Maldives Private Island is an elite resort with just 15 large, overwater Ocean Residences with 44 sq metre terrace pools. Each property floats on an azure lagoon and boasts a carefully crafted interior and outdoor space that exudes connection.","Kudadoo Maldives is a private island with a gorgeous lagoon, a stunning house reef, and extensive lengths of white sandy beach. Kudadoo is approximately 200 metres long and 200 metres broad. A direct seaplane trip from Velana International Airport takes 40 minutes and is a picturesque flight.","LIKE GOOD FOOD, NOTHING BRINGS PEOPLE TOGETHER. KUDADOO IS FULL OF TASTE EXPERIENCES CAREFULLY CURATE BY THE EXECUTIVE CHEF. THE MENUS INCLUDE ALL-TIME FAVORITES IN ADDITION TO FINE DINING TREATS, AND A RANGE OF DIETARY REQUIREMENTS AND PREFERENCES CAN BE ACCOMMODATED UPON REQUEST.","SULHA SPA AT THE RETREAT IS A SANCTUARY SUSPENDED OVER THE OCEAN THAT ALLOWS YOU TO CALM THE PERSISTENT CONSCIOUS LOOP WITH IMMERSIVE EXPERIENCES SO YOU CAN REST, RESET, AND CONNECT. YOU WILL FEEL BETTER THAN YOU HAVE IN YEARS IF YOU SPEND AS MUCH TIME AS YOU WISH ENJOYING WORLD-CLASS SPA AND WELL-BEING EXPERIENCES."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 4300, 'Kmbrx_LYk0Q', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'kudadoo-maldives-private-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'kudadoo-maldives-private-island-resort'
  and l.node_type = 'location' and l.slug = 'kudadoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'kudadoo-maldives-private-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ocean Pool Residence Single Bedroom', 4300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'kudadoo-maldives-private-island-resort'
on conflict (accommodation_id, name) do nothing;

-- LUX-South
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'lux-south-ari-atoll-resorts-maldives-island', 'LUX* South Ari Atoll Resorts Maldives Island', 'The Maldives is one of those destinations that keeps appearing on travellers'' wish lists. And not without cause. If you''ve ever dreamt of living like Robinson Crusoe on a remote tropical island, you''ve come to the correct spot. At LUX* South Ari Atoll, you can ride your bicycle along the jetty, swim with whale sharks, relax in your stilted bungalow, dine at any of the eight restaurants, dance the night away, and participate in marine conservation... Whatever you''re looking for, you''ll find it at LUX* South Ari Atoll.', 'published', 'LUX* South Ari Atoll Resorts Maldives Island | Maldives Resorts | MTG', 'The Maldives is one of those destinations that keeps appearing on travellers'' wish lists. And not without cause. If you''ve ever dreamt of living like Robinson Crusoe on a remote tropical island, you''ve come to the correct spot. At LUX* South Ari Atoll, you can ride your bicycle along the jetty, swim with whale sharks, relax in your stilted bungalow, dine at any of the eight restaurants, dance the night away, and participate in marine conservation... Whatever you''re looking for, you''ll find it at LUX* South Ari Atoll.', '{"overview_paragraphs":["The Maldives is one of those destinations that keeps appearing on travellers'' wish lists. And not without cause. If you''ve ever dreamt of living like Robinson Crusoe on a remote tropical island, you''ve come to the correct spot. At LUX* South Ari Atoll, you can ride your bicycle along the jetty, swim with whale sharks, relax in your stilted bungalow, dine at any of the eight restaurants, dance the night away, and participate in marine conservation... Whatever you''re looking for, you''ll find it at LUX* South Ari Atoll.","You couldn''t get much closer to the shore if you tried. Our thatched-roof beach pavilion is as stylish as they come. There is the option of interconnecting rooms, making this a good choice for families with small children or friends who enjoy going on double dates.","If picture-perfect vacations are your goal, you''ll enjoy our elegant beach home. A seaside house. The most beautiful private pool. Amenities tailored to the needs of the leisure tourist. The most romantic indoor-outdoor bathroom imaginable. Welcome to your Maldives home.","As hoteliers who like travelling, we understand the value of a good night''s sleep. It''s the nicest feeling to having a home away from home. Our Maldives water villa is that house, but on stilts with the Indian Ocean as your pool!","At LUX* South Ari Atoll, 193 private villas are scattered over two miles of powder fine beaches and situated on stilts above a beautiful lagoon. These incredibly big rooms and suites provide a totally unique atmosphere of coastal, beach house flair to the Maldives, whether on land or above water, sunset facing or dawn facing.","The picture-perfect island of Dhidhoofinolhu is home to LUX* South Ari Atoll, a luxury resort where your ideal of a laid-back, desert island paradise is about to come true, whether you desire a calm getaway or active adventure. This home is also in one of Maamigili''s prime locations. South Ari Atoll is 30 minutes by seaplane from Malé International Airport."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 600, '0wkm-EuG-Aw', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'lux-south-ari-atoll-resorts-maldives-island'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'lux-south-ari-atoll-resorts-maldives-island'
  and l.node_type = 'location' and l.slug = 'dhidhoofinolhu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'lux-south-ari-atoll-resorts-maldives-island'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pavillion', 600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'lux-south-ari-atoll-resorts-maldives-island'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1100, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'lux-south-ari-atoll-resorts-maldives-island'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 1000, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'lux-south-ari-atoll-resorts-maldives-island'
on conflict (accommodation_id, name) do nothing;

-- Lily-beach
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'lily-beach-resort-spa-maldives-island-resort', 'Lily Beach Resort & Spa Maldives Island Resort', 'Lily Beach Resort & Spa''s Platinum Plan allows you to enjoy a hassle-free, outstanding value-for-money vacation. This is an all-inclusive package that includes a magnificent assortment of high-quality services such as exquisite dining experiences, romantic excursions, sporting activities, and high-quality items such as premium wines and spirits.', 'published', 'Lily Beach Resort & Spa Maldives Island Resort | Maldives Resorts | MTG', 'Lily Beach Resort & Spa''s Platinum Plan allows you to enjoy a hassle-free, outstanding value-for-money vacation. This is an all-inclusive package that includes a magnificent assortment of high-quality services such as exquisite dining experiences, romantic excursions, sporting activities, and high-quality items such as premium wines and spirits.', '{"overview_paragraphs":["Lily Beach Resort & Spa''s Platinum Plan allows you to enjoy a hassle-free, outstanding value-for-money vacation. This is an all-inclusive package that includes a magnificent assortment of high-quality services such as exquisite dining experiences, romantic excursions, sporting activities, and high-quality items such as premium wines and spirits.","The Beach Villas allow you to fully enjoy the lovely natural playground just outside your door. The Villas are set among lush greenery, only steps from the warm Indian Ocean and a short walk from the resort''s main area.","Many of our visitors prefer the Lagoon Villas because of their private patio with direct access to the lagoon and tropical surroundings.","At Lily Beach Huvahendhoo, the pleasure never stops, and the hotel seeks to enliven days, enrapture evenings, and awaken visitors to a heightened level of well-being. The major goal has been to transform the resort into a high-quality, premium experience. All of its villas and public rooms are made entirely of natural materials. The finished project is a synthesis of current design and Maldivian architecture. It is a great combination of wood, various types of natural stones, and modern design that blends in wonderfully with the island''s natural environment.","Lily Beach Resort is located on the island of Huvahendhoo, South Ari Atoll, and is 600 m long and 110 m wide. It is a 25-minute sea plane flight from Male International Airport. Because of its advantageous location in the magnificent Ari Atoll, it is adjacent to some of the world''s most remarkable dive locations.","Maa, the local term for flower, is a place where your love of delicious cuisine may blossom into a pleasurable eating experience. The genuine value of this wonderful sand-floored restaurant is provided by its magnificent, all-inclusive buffet dishes that will whet anyone''s appetite. Lily Maa, the primary buffet-style restaurant, will enable you bloom into a genuine gourmet, recognising that the quality of your Maldives experience will unavoidably expand through the seduction of your taste senses as well. Every day of the week, a new foreign cuisine to transport you to other corners of the world while being at the one you wouldn''t exchange for anything else. Whatever your favourite dish, Lily Maa is an unrivalled gastronomic treat, recognised across the Maldives for its chefs'' feasts. Don’t"]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1100, 'JEgqJqbA79E', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'lily-beach-resort-spa-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'lily-beach-resort-spa-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'huvahendhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'lily-beach-resort-spa-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 1100, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'lily-beach-resort-spa-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 1200, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'lily-beach-resort-spa-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Maayafushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'nakai-maayafushi-maldives-island-resort', 'NAKAI Maayafushi Maldives Island Resort', 'Maayafushi, located in the northern portion of the Ari Atoll, contains all of the characteristics that distinguish this little region of Maldives: from the untamed nature of the vegetation to the bottom inhabited by the most diverse types of fish. The resort is framed by crystal blue waters and lovely beaches, and its rooms can provide tourists with every type of comfort. The island, with its well-known diving spots, is a popular destination for divers from all over the world, from the most experienced to those who want to dive for the first time in these enchanted depths.', 'published', 'NAKAI Maayafushi Maldives Island Resort | Maldives Resorts | MTG', 'Maayafushi, located in the northern portion of the Ari Atoll, contains all of the characteristics that distinguish this little region of Maldives: from the untamed nature of the vegetation to the bottom inhabited by the most diverse types of fish. The resort is framed by crystal blue waters and lovely beaches, and its rooms can provide tourists with every type of comfort. The island, with its well-known diving spots, is a popular destination for divers from all over the world, from the most experienced to those who want to dive for the first time in these enchanted depths.', '{"overview_paragraphs":["Maayafushi, located in the northern portion of the Ari Atoll, contains all of the characteristics that distinguish this little region of Maldives: from the untamed nature of the vegetation to the bottom inhabited by the most diverse types of fish. The resort is framed by crystal blue waters and lovely beaches, and its rooms can provide tourists with every type of comfort. The island, with its well-known diving spots, is a popular destination for divers from all over the world, from the most experienced to those who want to dive for the first time in these enchanted depths.","The allure of a walk in nature, the sensation of sand and wood beneath your feet before returning to your bed. Maayafushi''s 60 Beach Bungalows mesmerise with a green vista from which to scan the azure horizon of the Indian Ocean.","Maayafushi''s 8 Over Water survey the ocean''s limitless horizon, leaving them dumbfounded. The charm of water, which cradles the minutes before sleep and the seconds after rising, provides unforgettable pleasures. You will be immersed in the sounds of the sea in these rooms, and there will be a large outside deck where you may rest.","Guests may choose between three sorts of accommodation categories: Garden Rooms, Beach Bungalows, and Water Bungalows, all of which are constructed in harmony with the surrounding environment of the island while keeping comfort in mind. The rooms are large and well-equipped.","Maayafushi is located 65 kilometres from Velana International Airport and may be accessible either seaplane or a short ferry boat ride. The Ari''s atoll, well-known across the globe for its white sand and beautiful beaches, has become a scuba diver''s paradise on Earth. Sightings of whale sharks and hammerhead sharks, as well as other species dwelling in the coral reef that runs all the way around the shore, are common.","Let yourself be conquered by the tastes of the island in Maayafushi''s eateries and pubs. Our dining menu has been created to be as diverse as possible in order to fulfil the demands of all customers. In the restaurants, you may sample the delights of Italian and Maldivian cuisine, cooked and served daily by our Chefs. Our bars will be the ideal spot to unwind and have a refreshing drink while taking in the sights and sounds that only the Maldives can provide."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, null, '09xGGXQ0WA0', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'nakai-maayafushi-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'nakai-maayafushi-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'maayafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'nakai-maayafushi-maldives-island-resort'
on conflict (id) do nothing;

-- Makunudu-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'makunudu-island-resort-maldives', 'Makunudu Island Resort Maldives', 'Makunudu Island, located in North Malé Atoll and a 50-minute speedboat trip from Male International Airport, welcomes you into the warm embrace of an authentic Maldivian getaway. Where gleaming beaches give way to the turquoise lagoon''s crystal pure waters, melting into endless ocean views. Where serenity permeates into your spirit and real hospitality greets you like a friend. A rare retreat, gloriously undisturbed, that has a particular place in the hearts of people who explore the world. Remove your shoes and immerse yourself in island time...', 'published', 'Makunudu Island Resort Maldives | Maldives Resorts | MTG', 'Makunudu Island, located in North Malé Atoll and a 50-minute speedboat trip from Male International Airport, welcomes you into the warm embrace of an authentic Maldivian getaway. Where gleaming beaches give way to the turquoise lagoon''s crystal pure waters, melting into endless ocean views. Where serenity permeates into your spirit and real hospitality greets you like a friend. A rare retreat, gloriously undisturbed, that has a particular place in the hearts of people who explore the world. Remove your shoes and immerse yourself in island time...', '{"overview_paragraphs":["Makunudu Island, located in North Malé Atoll and a 50-minute speedboat trip from Male International Airport, welcomes you into the warm embrace of an authentic Maldivian getaway. Where gleaming beaches give way to the turquoise lagoon''s crystal pure waters, melting into endless ocean views. Where serenity permeates into your spirit and real hospitality greets you like a friend. A rare retreat, gloriously undisturbed, that has a particular place in the hearts of people who explore the world. Remove your shoes and immerse yourself in island time...","These vast havens of leisure merge rustic beauty with modern conveniences, thoughtfully designed in traditional Maldivian style utilising native woods, stones, and a palette of earthy colours. Enjoy the pleasure of a garden shower that is accessible to the outdoors yet entirely concealed. Relax on your individual sun loungers in the shade of the palms or under the warm Maldivian sun. Sleep quietly to the soothing sounds of lapping waves.","The Deluxe bungalows, inspired by its Maldivian history, represent the island''s native culture and energy. One of 36 beachfront villas set among thick tropical greenery only steps from the beach is your own little getaway.","We are located in North Malé Atoll, 45 minutes via speedboat from Malé International Airport.","Indulge in spectacular buffets of meats, seafood, and tropical fruits, table-served set dinners, and once a week, a scorching barbeque and a wonderful slice of Maldivian spice in a beautiful Maldivian buffet supper. Quench your thirst at the Sand Bar, day or night, with delicious beverages and sunset cocktails, while conversing with fellow travellers and being cooled by the ocean wind. A carefully made candlelit supper beneath the stars on the beach, in your bungalow, or other secluded locales is an experience to truly savour on those special occasions.","Your rejuvenation journey begins with therapies that include the finest of Maldivian, Asian, and European wellness methods and traditions. A Maldivian massage utilising seashells and pure indigenous coconut oil is available. A customised face will restore your natural glow. Relax and restore balance from head to toe with an Ayurvedic Indian head massage or reflexology."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 300, 'm16ooP56quk', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'makunudu-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'makunudu-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'makunudu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'makunudu-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Bungalow', 300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'makunudu-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Malahini-Kuda-Bandos
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'malahini-kuda-bandos-maldives-island-resort', 'Malahini Kuda Bandos Maldives Island Resort', 'Malahini Kuda Bandos, Celebrate your marriage with a honeymoon on beautiful pristine beaches overlooking turquoise waters while dining on delicious cuisine. We provide customised honeymoon packages with loads of advantages!', 'published', 'Malahini Kuda Bandos Maldives Island Resort | Maldives Resorts | MTG', 'Malahini Kuda Bandos, Celebrate your marriage with a honeymoon on beautiful pristine beaches overlooking turquoise waters while dining on delicious cuisine. We provide customised honeymoon packages with loads of advantages!', '{"overview_paragraphs":["Malahini Kuda Bandos, Celebrate your marriage with a honeymoon on beautiful pristine beaches overlooking turquoise waters while dining on delicious cuisine. We provide customised honeymoon packages with loads of advantages!","Our Deluxe accommodations, which are located along the beach, have a partial view of the ocean. Each room is 27 square metres in size and has the following amenities to provide a comfortable stay:","This year, Malahini Kuda Bandos might be your pleasant spot to relax with their modern and contemporary homes. Beach Villas, Superior Rooms, Deluxe Rooms, and Classic Rooms are the five accommodation types available.","Malahini Kuda Bandos is a ten-minute boat journey from Velana International Airport and provides basic luxury without breaking the wallet.","Sit at the water''s edge and have breakfast, lunch, or dinner in our modern and stunning restaurant that overlooks our lovely lagoon. If you like to eat under the stars, please sit on our open-air deck and listen to the waves breaking around you. If you would like to have a private dinner experience on the beach, please contact our Maaga Crew and they would be pleased to arrange one for you. To gratify our broad group of travellers, the Maaga Buffet is painstakingly created to feature a range of cuisines from all around the world.","Visit Alizé to calm your senses and absorb the peacefulness of our surroundings. Our spa pavilions at Alizé are inspired by age-old Asian and Maldivian traditions and are meant to offer you with a refuge from the world while also considering your well-being. Pamper yourself with a manicure or pedicure while admiring the ocean!"]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 355, 'f_g5hU7gpHI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'malahini-kuda-bandos-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'malahini-kuda-bandos-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'kuda-bandos'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'malahini-kuda-bandos-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Room', 355, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'malahini-kuda-bandos-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Medhufushi-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'medhufushi-island-resort-maldives', 'Medhufushi Island Resort Maldives', 'Medhufushi Island Resort is a peaceful and relaxing haven. The lovely island, decorated with shaded coconut palms and tropical flowers, exudes serenity. A magnificent lagoon in turquoise and sparkling azure blue surrounds the island. Medhufushi Island Resort is the best place to get away from it all and experience inexpensive, laid-back rustic at a Maldives resort.', 'published', 'Medhufushi Island Resort Maldives | Maldives Resorts | MTG', 'Medhufushi Island Resort is a peaceful and relaxing haven. The lovely island, decorated with shaded coconut palms and tropical flowers, exudes serenity. A magnificent lagoon in turquoise and sparkling azure blue surrounds the island. Medhufushi Island Resort is the best place to get away from it all and experience inexpensive, laid-back rustic at a Maldives resort.', '{"overview_paragraphs":["Medhufushi Island Resort is a peaceful and relaxing haven. The lovely island, decorated with shaded coconut palms and tropical flowers, exudes serenity. A magnificent lagoon in turquoise and sparkling azure blue surrounds the island. Medhufushi Island Resort is the best place to get away from it all and experience inexpensive, laid-back rustic at a Maldives resort.","For further solitude, the beach villas are built on pristine white sand and surrounded by lush flora such as hibiscus and sea cabbage. The four-poster king-size bed/twin beds and outdoor rain showers are highlights. 14 of the beach homes are semi-detached and offer more room as well as a partition door connecting the villas.","The sunrise or sunset-facing Water Villas have floor-to-ceiling windows in the bedroom that fold back over the whole fourth wall, allowing you to completely appreciate the ocean views. They also provide direct access to the lagoon from your private sundeck via steps.","Medhufushi is one of only two resorts in the picturesque Meemu Atoll, distant from the bustle and congestion of modern life. It includes 112 villas spread across around 10 hectares of land. Each villa is intended to provide natural luxury as well as the joy of a perfect refuge. All of the conveniences of home are offered in these spacious and appealing villas, which include a private sundeck and a traditional Maldivian swing chair. There is no better place to observe the soothing waves than under the shade of the ''undholi.'' The unique Lagoon Suites are the best in luxury.","This five-star resort is located on Meemu Atoll, 130 kilometres from Velana International Airport, a breathtaking 40-minute seaplane flight away.","This poolside restaurant, named after the Dhivehi word for mermaid, provides breathtaking views of the ocean. The restaurant serves buffet-style breakfasts, lunches, and dinners, with chefs working live cooking stations to customise your dish to your preferences. The food of Malaafaiy Restaurant is inspired by culinary traditions from throughout the world."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 250, '5j7XZjsxiP8', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'medhufushi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'medhufushi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'medhufushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'medhufushi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 250, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'medhufushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 430, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'medhufushi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Meeru-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'meeru-island-resort-spa-maldives', 'Meeru Island Resort & Spa Maldives', 'Meeru Island Resort welcomes you to experience an unique beach filled holiday with a splash of simply Maldivian mixing into every facet of your stay, boasting one of the world''s most amazing beaches. Meeru takes pride in servicing the Maldives hotel sector for over 40 years. Explore the authentic Maldivian culture all throughout the island, including our very own state-of-the-art island museum. You will undoubtedly share Magical Moments with your loved ones when visiting here.', 'published', 'Meeru Island Resort & Spa Maldives | Maldives Resorts | MTG', 'Meeru Island Resort welcomes you to experience an unique beach filled holiday with a splash of simply Maldivian mixing into every facet of your stay, boasting one of the world''s most amazing beaches. Meeru takes pride in servicing the Maldives hotel sector for over 40 years. Explore the authentic Maldivian culture all throughout the island, including our very own state-of-the-art island museum. You will undoubtedly share Magical Moments with your loved ones when visiting here.', '{"overview_paragraphs":["Meeru Island Resort welcomes you to experience an unique beach filled holiday with a splash of simply Maldivian mixing into every facet of your stay, boasting one of the world''s most amazing beaches. Meeru takes pride in servicing the Maldives hotel sector for over 40 years. Explore the authentic Maldivian culture all throughout the island, including our very own state-of-the-art island museum. You will undoubtedly share Magical Moments with your loved ones when visiting here.","Meeru''s Beach Villas are big, well-appointed wooden bungalows on the beach with a stunning view of the lagoon. Step right onto the secluded beach, which offers breathtaking views of the island lagoon. These wooden bungalows provide a real Maldives beachfront experience. Relax on the villa terrace or on your beach sun loungers while listening to natural noises and inhaling in the ocean wind.","These classic Maldives villas are set in the lagoon, over-the-water. Only a short walk along your private jetty to this isolated refuge where you may immerse yourself in a Jacuzzi for two \"under the stars\" and simply climb the stairs into the water with the most spectacular views of all.","Meeru offers pleasant accommodation with tropical décor and modern conveniences, whether close to the beach or over-the-water, with 284 guest rooms divided into 5 room types. All Rooms have tropical décor, a king-sized bed, a private porch with furniture, air conditioning, a ceiling fan, a partially open-air bathroom (except Garden Rooms) with a rain shower, and amenities for an unforgettable Meeru stay.","Much of this lovely island remains undisturbed, with its bordering coconut palm trees, rich greenery, and brilliant coral reefs alive with marine life. It takes a 55-minute scenic motorboat trip from Velana International Airport to reach this unspoilt, natural paradise. Whether on a family holiday in the sun or an intimate beach gateway with a loved one, enjoy a relaxed, calm ambiance in a natural setting.","Meeru Island has two Buffet Restaurants, both with the same menu and a range of foreign and regional cuisines to suit everyone''s taste. Breakfast, lunch, and supper are all-you-can-eat buffet style, with vibrant Theme Nights. Friday evenings are Maldivian theme nights, complete with a themed cuisine and staff dressed in traditional clothes. Sunday brunch includes free Sparkling Wine."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 440, '7cJKIs_Ps0Q', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'meeru-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'meeru-island-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'meerufenfushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'meeru-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 440, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'meeru-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Jacuzzi Water Villa', 500, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'meeru-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- Milaidhoo
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'milaidhoo-maldives-island-resort', 'Milaidhoo Maldives Island Resort', 'Come on in, take off your shoes, and let us tell you a story... Once upon a time, there was a little tropical island, an emerald drop of paradise surrounded by a colourful coral reef, caressed by warm turquoise waves, and nestled in the centre of a UNESCO Biosphere Reserve. That island is Milaidhoo. That time has here, and this is our tale. Milaidhoo is not just another five-star resort in the Maldives; we call it re-invented luxury. We don''t conceive of our visitors as vacationers, but rather as storytellers who are creating their ideal vacation. This is the start of your narrative about a little island.', 'published', 'Milaidhoo Maldives Island Resort | Maldives Resorts | MTG', 'Come on in, take off your shoes, and let us tell you a story... Once upon a time, there was a little tropical island, an emerald drop of paradise surrounded by a colourful coral reef, caressed by warm turquoise waves, and nestled in the centre of a UNESCO Biosphere Reserve. That island is Milaidhoo. That time has here, and this is our tale. Milaidhoo is not just another five-star resort in the Maldives; we call it re-invented luxury. We don''t conceive of our visitors as vacationers, but rather as storytellers who are creating their ideal vacation. This is the start of your narrative about a little island.', '{"overview_paragraphs":["Come on in, take off your shoes, and let us tell you a story... Once upon a time, there was a little tropical island, an emerald drop of paradise surrounded by a colourful coral reef, caressed by warm turquoise waves, and nestled in the centre of a UNESCO Biosphere Reserve. That island is Milaidhoo. That time has here, and this is our tale. Milaidhoo is not just another five-star resort in the Maldives; we call it re-invented luxury. We don''t conceive of our visitors as vacationers, but rather as storytellers who are creating their ideal vacation. This is the start of your narrative about a little island.","Milaidhoo, which opened in November 2016, is a boutique luxury resort in the Baa Atoll UNESCO Biosphere Reserve, adjacent to Hanifaru Bay, 126 kilometres north-west of Male''. We''re ideal for environment enthusiasts since our own coral reef, which encircles the island, is a protected area and a popular snorkelling and diving destination. Our magnificent island, which is densely forested, spans just 300m by 180m and is surrounded by a smooth, deep white sand beach. We welcome guests aged nine and up and have a strict no-drone policy on the island, making it ideal for couples seeking quiet and seclusion. Everything at Milaidhoo is handcrafted to order and designed with your comfort in mind. Service is excellent yet always pleasant, in keeping with","These bright and large 290sqm thatched-roof villas open up 180 degrees to a wide sundeck and amazing views, and are set on a white, powder soft, sand beach among palm trees and lush, tropical flora. Each villa has a king-size bed with stunning views of the beach and ocean. Each home has high ceilings that create a sense of spaciousness and light. The custom-made furniture are complemented by a concealed flat-screen television, a specialised wine cooler, a full-sized, quiet refrigerator and mini bar, coffee machine, ceiling fan, and air conditioning.","The Beach Pool Villas at Milaidhoo welcome guests to a private island house designed to take advantage of the natural tranquilly given by the thick greenery that surrounds the property. The contemporary interior design incorporates numerous local details, creating a sense of belonging.","These enormous 245sqm thatched-roof houses on stilts above the ocean are tranquil and full of light, leading out to a massive sundeck surrounded by the clean air of a fresh sea wind. The sun deck is built around a 42sqm private freshwater infinity pool and has a Maldivian-style swing sofa, sun loungers, a huge umbrella, a dining table with seats, and a wide, covered daybed. Steps descend into the lagoon, providing easy access to the neighbouring coral reef.","The interior design of the Water Pool Villa is inspired by Maldivian tradition and culture, with furniture custom-made for Milaidhoo and room colours that mirror the vibrant hues of the natural surroundings. The spacious bathroom in the Villa has a large bathtub with an ocean view. The bathroom has a tropical rain shower."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1900, 'fQsrXcjbvqE', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'milaidhoo-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'milaidhoo-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'milaidhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'milaidhoo-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 2200, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'milaidhoo-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Pool Villa', 1900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'milaidhoo-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Mirihi-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'mirihi-island-resort-maldives', 'Mirihi Island Resort Maldives', 'Mirihi Island Resort is a modest and precious jewel with white sands and swaying palms in the soft air. Surrounded by the infinite azure of the Indian Ocean, eco-friendly Mirihi is one of the Maldives'' tiniest resorts, giving our guests the unique impression of being on their own little island.', 'published', 'Mirihi Island Resort Maldives | Maldives Resorts | MTG', 'Mirihi Island Resort is a modest and precious jewel with white sands and swaying palms in the soft air. Surrounded by the infinite azure of the Indian Ocean, eco-friendly Mirihi is one of the Maldives'' tiniest resorts, giving our guests the unique impression of being on their own little island.', '{"overview_paragraphs":["Mirihi Island Resort is a modest and precious jewel with white sands and swaying palms in the soft air. Surrounded by the infinite azure of the Indian Ocean, eco-friendly Mirihi is one of the Maldives'' tiniest resorts, giving our guests the unique impression of being on their own little island.","We are a world apart, a heaven of calm and tranquillity, with no television in the villas, no motorised water sports, no discos or nightlife to bother you with loud music and noise, and nothing else to come between you and the genuine definition of relaxation and joy. Our customised service and committed team of well-trained professionals ensure that your experience is as unspoiled and soothing as if you were the first to come in a location designed just for you, and as unique as you are.","Six elegantly constructed Beach Villas (53 m2) are ideally placed on the island''s sunset side, with direct access to our talcum powdery beach. These cosy homes, surrounded by thick tropical flora and swaying palms, provide full solitude and unrivalled ocean views. Designer furnishings, polished wooden flooring, king or twin beds, semi-open air baths, Bose audio system with Bluetooth connectivity, free high speed WI-FI, Nespresso machine, personal safe, and fully stocked Villa Bar are all included.","Our 30 Water Villas (53 m2) are built on stilts over the blue lagoon and provide direct access to our lively house reef. These nicely constructed cosy villas are endowed with an unbroken view of the blue ocean from the entire seclusion of the sun deck, with a view of the dawn or sunset. All Villas feature the same high-quality designer furnishings, polished wooden floors, king-size or twin beds, en suite bathrooms with glass doors overlooking the Indian Ocean, Bose music system with Bluetooth connectivity, free high-speed Wi-Fi, Nespresso machine, personal safe, and fully stocked Villa Bar. The Water Villa requires children to be 8 years old for safety reasons.","The 37 attractively constructed Villas have recently been refurbished, delivering luxury and comfort while also providing space and natural light. They are conveniently positioned all across the island and provide perfect seclusion. Each luxurious mansion is given a distinct Dhivehi (Maldivian) name drawn from the land or sea. The villas, which include 6 Beach Villas, 30 Water Villas, 1 Two-Bedroom Water Suite, and 1 Two-Bedroom Beach Suite, are exquisitely positioned around the island and above the active house reef, providing unending views of the vast horizon. Each villa is the ideal hideaway from the rest of the world, whether from your private deck or private beach.","The island is only 350 metres long and 50 metres broad, with palm-fringed beaches and powder soft, sun-kissed sand. This beautiful, private island is reached through a 30-minute seaplane flight and is encircled by 6 kilometres of one of the Maldives'' greatest house reefs. It''s also a great place to watch whale sharks."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 550, '22tRj_0CFDQ', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'mirihi-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'mirihi-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'mirihi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'mirihi-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'mirihi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 550, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'mirihi-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Movenpick
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'movenpick-resort-kuredhivaru-maldives-resort', 'Movenpick Resort Kuredhivaru Maldives Resort', 'The Mövenpick Resort Kuredhivaru Maldives is a beautiful refuge and tropical paradise located in the unspoiled Noonu Atoll. Our 5 star luxury beach resort is located 45 minutes north of Male International Airport. In each of the 72 overwater pool villas, 30 beach pool suites, and three beach spa pool homes, you may relax in your own private plunge pool.', 'published', 'Movenpick Resort Kuredhivaru Maldives Resort | Maldives Resorts | MTG', 'The Mövenpick Resort Kuredhivaru Maldives is a beautiful refuge and tropical paradise located in the unspoiled Noonu Atoll. Our 5 star luxury beach resort is located 45 minutes north of Male International Airport. In each of the 72 overwater pool villas, 30 beach pool suites, and three beach spa pool homes, you may relax in your own private plunge pool.', '{"overview_paragraphs":["The Mövenpick Resort Kuredhivaru Maldives is a beautiful refuge and tropical paradise located in the unspoiled Noonu Atoll. Our 5 star luxury beach resort is located 45 minutes north of Male International Airport. In each of the 72 overwater pool villas, 30 beach pool suites, and three beach spa pool homes, you may relax in your own private plunge pool.","Mövenpick Resort Kuredhivaru Maldives'' restaurants brilliantly mix gourmet delights with breathtaking views of the Maldives. You may treat yourself and your loved one endlessly throughout your relaxed vacation with us in the Maldives, from a seafood fine dining experience to a private romantic candlelit meal on the beach.","Feel the sand between your toes as you walk along the powder-white beaches and explore the plethora of colourful marine life that the Indian Ocean has to offer. Enjoy delicious food at three restaurants and a refreshing drink at our bar while admiring the breathtaking views of the Indian Ocean. Relax at the Healing Earth Sun Spa, redirect your energy with yoga, and let your kids play at the Little Birds Club. Allow us to tailor-make a very distinctive Maldives experience for you during your stay at Mövenpick Resort Kuredhivaru Maldives.","This home is surrounded by beautiful nature and is located right close to a white-sand beach. Relax by your own infinity pool or relax in a swinging chair outdoors. Enjoy the stunning Maldivian reef, as well as free Chocolate Hours, snorkelling equipment, and non-motorized watersports.","Our over water villas with see-through floors provide lagoon views and are located over the turquoise lagoon. Open the glass doors and dive into your infinity-edge pool. Daily Chocolate Hours, unlimited water, snorkelling equipment, and non-motorized water activities are all available.","Mövenpick Resort boasts a modern design with an emphasis on comfortable accommodations and a secluded, yet dynamic resort experience. Every modern convenience is integrated with the desert-island luxury, reflecting Mövenpick''s famous devotion to authentic comforts provided extremely well."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 800, 'hEpEZxGW_Js', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'movenpick-resort-kuredhivaru-maldives-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'movenpick-resort-kuredhivaru-maldives-resort'
  and l.node_type = 'location' and l.slug = 'kuredhivaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'movenpick-resort-kuredhivaru-maldives-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Suite', 1000, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'movenpick-resort-kuredhivaru-maldives-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Pool Lagoon', 800, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'movenpick-resort-kuredhivaru-maldives-resort'
on conflict (accommodation_id, name) do nothing;

-- Nika-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'nika-island-resort-spa-maldives', 'Nika Island Resort & Spa Maldives', 'Nika Island is a piece of Maldivian history, since it was one of the first islands in Ari Atoll to become a world-renowned tourist attraction. Nika Island is our collective imagination''s paradise island. A forum where traditional Maldivian beauty and custom meet Italian culture. Nothing has changed on the island of Nika. A destination where you may relive the Maldives of yesteryear. "A item of beauty is a delight forever," said the English poet Keats, and Nika''s beauty beyond words. This island is frozen in time, impervious to the tremendous tourism forces that are altering the Maldives today. An unrepeatable and completely successful alchemical experiment that has written a significant chapter in history.', 'published', 'Nika Island Resort & Spa Maldives | Maldives Resorts | MTG', 'Nika Island is a piece of Maldivian history, since it was one of the first islands in Ari Atoll to become a world-renowned tourist attraction. Nika Island is our collective imagination''s paradise island. A forum where traditional Maldivian beauty and custom meet Italian culture. Nothing has changed on the island of Nika. A destination where you may relive the Maldives of yesteryear. "A item of beauty is a delight forever," said the English poet Keats, and Nika''s beauty beyond words. This island is frozen in time, impervious to the tremendous tourism forces that are altering the Maldives today. An unrepeatable and completely successful alchemical experiment that has written a significant chapter in history.', '{"overview_paragraphs":["Nika Island is a piece of Maldivian history, since it was one of the first islands in Ari Atoll to become a world-renowned tourist attraction. Nika Island is our collective imagination''s paradise island. A forum where traditional Maldivian beauty and custom meet Italian culture. Nothing has changed on the island of Nika. A destination where you may relive the Maldives of yesteryear. \"A item of beauty is a delight forever,\" said the English poet Keats, and Nika''s beauty beyond words. This island is frozen in time, impervious to the tremendous tourism forces that are altering the Maldives today. An unrepeatable and completely successful alchemical experiment that has written a significant chapter in history.","10 Beach Villas (about 80 square feet) with a double room, living area, and bathroom. They are on the north side of the island, facing a big lagoon, with swimming access to the barrier reef from your own private beach. All Beach Villas face the ocean and are constructed with natural materials in accordance with Maldives architectural heritage norms. They are separated from one another by thick greenery and are encircled by a garden with gazebo and hot tub. One Beach Villa has been modified to accommodate people with disabilities.","8 Water Villas (about 1200sqft) with double room, living room, bathroom, terrace with direct beach access, and solarium. Water Villas are located on the north side of the island in the lagoon, facing one of the best maintained barrier reefs in the Indian Ocean. Water Villas are divided into three levels: the first is on the water, where you can dive right in; the second is a wooden terrace where you can rest on comfy deck chairs; and the third is on the roof, where you can watch the ocean and enjoy the wonderful sea wind. Guests have access to two public beaches with sun loungers, bathrooms, and beach umbrellas, one near the Water Villas boardwalk and one in front of the hotel.","Only 43 villas on an island surrounded by a gorgeous house reef, rich greenery, and helpful personnel will make you feel perfectly at home: 6 Garden rooms, 10 Beach Villas, 10 Deluxe Beach Villas, 3 Family Beach Villas, 3 Family Deluxe Beach Villas, 1 Sultan Suite, and 10 Water Villas.","Nika Island Resort & Spa is situated on its own own island on the western fringe of North Ari Atoll. Male International Airport is 75 kilometres away and may be reached in 25/30 minutes by seaplane. The Nika Maldives experience begins with a warm greeting from the resort host at the arrival port, who will accompany visitors to the Nika lounge till the departure by sea plane for the breathtaking ride to the resort.","Nika Restaurant provides full-board, half-board, and all-inclusive packages, with a buffet meal rotating alongside an à la carte menu. A Maldivian feast and BBQ is offered once a week. The restaurant is a big open-air building that is appealing. The food is mostly Italian and Mediterranean. Our chefs are available to accommodate any requirement, even customers with dietary sensitivities. The wine cellar on the island has approximately 100 different varieties of wine. A unique candlelit meal with a fish-and-shellfish-based cuisine may be organised upon request, either on your villa''s private beach or on the desert island within a few minutes boat ride from Nika."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 400, '7WBGJrqLLz4', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'nika-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'nika-island-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'kudafolhudhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'nika-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 400, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'nika-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 450, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'nika-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- Noku
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'noku-maldives-island-resort', 'Noku Maldives Island Resort', 'Twenty beach villas and 30 over-water villas are nestled among lush tropical flora and surrounded by a tranquil blue lagoon. Each spacious unit is intended to give maximum seclusion and is outfitted with modern conveniences to ensure comfort. Each villa''s subtle elegance, with gentle white colours and dark wood accents, complements the splendour of nature as viewed via huge bay windows and french doors.', 'published', 'Noku Maldives Island Resort | Maldives Resorts | MTG', 'Twenty beach villas and 30 over-water villas are nestled among lush tropical flora and surrounded by a tranquil blue lagoon. Each spacious unit is intended to give maximum seclusion and is outfitted with modern conveniences to ensure comfort. Each villa''s subtle elegance, with gentle white colours and dark wood accents, complements the splendour of nature as viewed via huge bay windows and french doors.', '{"overview_paragraphs":["Twenty beach villas and 30 over-water villas are nestled among lush tropical flora and surrounded by a tranquil blue lagoon. Each spacious unit is intended to give maximum seclusion and is outfitted with modern conveniences to ensure comfort. Each villa''s subtle elegance, with gentle white colours and dark wood accents, complements the splendour of nature as viewed via huge bay windows and french doors.","Each of the contemporary Beach Villas is large and stylishly constructed to capture natural light and amazing views of the Indian Ocean, and is surrounded by lush tropical foliage. Enjoy a visual delight of a Maldivian sunrise or sunset from the direct beach access and spacious sundeck.","Wake up to a stunning dawn through the gentle white tones of this one-bedroom villa, or from the expansive sundeck with a private plunge pool. Enjoy cleaning routines in the outdoor rain shower, indoor shower, or standalone bathtub.","This magnificent one-bedroom house positioned immediately above the turquoise lagoon, facing South East, offers unrivalled views of the Indian Ocean. A spacious sundeck captures the spectacular dawn and gives direct access to the water below. There are indoor and outdoor showers as well as a standalone bathtub for further relaxation.","The resort has been elegantly renovated using sustainable materials, selected hand-made design items, and attention to detail on the island of Kuda-Funafaru in Noonu Atoll, 189 kilometres from Velana International Airport. The island is 750 metres long and 250 metres wide, making it the ideal size for relaxing in tropical tranquillity.","From locally grown vegetables with a Maldivian twist to international cuisine such as Japanese, Singaporean, and Thai, there is something for everyone. Our menu selection at Thari Restaurant, which includes components of Maldivian, Thai, Japanese, and Singaporean cuisines, will give you a flavorful sense of the nations where our Noku hotels are located."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 800, 'LRyhlGZy_q0', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'noku-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'noku-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'kudafunafaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'noku-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 800, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'noku-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1000, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'noku-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 850, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'noku-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Nova
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'nova-maldives-island-resort', 'NOVA Maldives Island Resort', 'Everyone is welcome to our home-away-from-home, whether they are travelling alone, with loved ones, friends, or family. You may do whatever you want here, as much or as little as your spirit wishes. Dive, go to the gym, or relax beneath the palm trees and enjoy something simple and genuine. I''m glad to be here. Happy in the moment- at Nova, one of the top all-inclusive resorts in the Maldives.', 'published', 'NOVA Maldives Island Resort | Maldives Resorts | MTG', 'Everyone is welcome to our home-away-from-home, whether they are travelling alone, with loved ones, friends, or family. You may do whatever you want here, as much or as little as your spirit wishes. Dive, go to the gym, or relax beneath the palm trees and enjoy something simple and genuine. I''m glad to be here. Happy in the moment- at Nova, one of the top all-inclusive resorts in the Maldives.', '{"overview_paragraphs":["Everyone is welcome to our home-away-from-home, whether they are travelling alone, with loved ones, friends, or family. You may do whatever you want here, as much or as little as your spirit wishes. Dive, go to the gym, or relax beneath the palm trees and enjoy something simple and genuine. I''m glad to be here. Happy in the moment- at Nova, one of the top all-inclusive resorts in the Maldives.","These accommodations are just a few feet from the beach and provide direct access to the endless blue lagoons. The 80-square-meter rooms have bespoke furnishings, natural light, and warmth, as well as a king-size bed with soft linen and cushions.","Beach Villa with Private Pool is a sanctuary of comfort overlooking the turquoise waves, with direct access to the coastline. It is set in an immensely soothing environment. Each room has 160 square metres of space and a king-size bed with luxury linen and cushions.","These suites provide an unrivalled view of the Indian Ocean and direct access to the lagoon below. Spend the day relaxing on the sun loungers on the expansive sun terrace, or down the private stairway and swim laps in the lagoon.","It''s a novel spin on the all-inclusive concept, going beyond meals and services and inviting everyone to take use of everything Nova has to offer. There are 76 lovely beach and over-water villas, beach volleyball, diving, local art and culture, and delightfully fresh dining at its three restaurants and two bars. People in Nova make time for the things that make them happy.","Nova is located in South Ari Atoll and may be accessed by a picturesque 25-minute seaplane flight."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 600, 'pNaa-necLJQ', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'nova-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'nova-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'vakarufalhi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'nova-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'nova-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1100, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'nova-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 900, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'nova-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- OBLU-NATURE-Helengeli
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'oblu-nature-helengeli-maldives-island-resort', 'OBLU NATURE Helengeli Maldives Island Resort', 'OBLU NATURE Helengeli is a thrilling 50-minute speedboat journey from Malé International Airport and provides all the enchantment of flora and animals. Helengeli is a favourite among Maldives all-inclusive resorts for ardent explorers, snorkelers, and channel divers due to its island-inspired, bohemia ambiance. The resort has its own house-reef only steps from the coast and is home to a breathtaking display of marine dwellers all year round, with 116 villas with vivid, tropical interiors amidst lush flora.', 'published', 'OBLU NATURE Helengeli Maldives Island Resort | Maldives Resorts | MTG', 'OBLU NATURE Helengeli is a thrilling 50-minute speedboat journey from Malé International Airport and provides all the enchantment of flora and animals. Helengeli is a favourite among Maldives all-inclusive resorts for ardent explorers, snorkelers, and channel divers due to its island-inspired, bohemia ambiance. The resort has its own house-reef only steps from the coast and is home to a breathtaking display of marine dwellers all year round, with 116 villas with vivid, tropical interiors amidst lush flora.', '{"overview_paragraphs":["OBLU NATURE Helengeli is a thrilling 50-minute speedboat journey from Malé International Airport and provides all the enchantment of flora and animals. Helengeli is a favourite among Maldives all-inclusive resorts for ardent explorers, snorkelers, and channel divers due to its island-inspired, bohemia ambiance. The resort has its own house-reef only steps from the coast and is home to a breathtaking display of marine dwellers all year round, with 116 villas with vivid, tropical interiors amidst lush flora.","These semi-detached beach homes are a few steps from Helengeli island''s coastlines and are ideal for fun and relaxation.","These exquisite homes are constructed partially on land and provide excellent sunset views. The terrace leads into the tranquil turquoise lagoon.","The resort has 116 villas in four categories that are all-inclusive with high-quality international cuisine and a variety of activities such as spectacular Channel Diving and a tranquil Garden Spa! OBLU by Atmosphere in Helengeli, a Four-Star Superior resort, strives to offer a ''Best in Class'' Maldivian Beach holiday experience!","OBLU by Atmosphere at Helengeli is located in North Male'' Atoll and is a 50-minute speedboat ride from Velana International Airport.","The Spice offers a stunning Maldives resort dining experience with a lagoon-facing wooden terrace and inside seats on a natural sandy floor. Relax by the pool with a beverage and some bar snacks at Helen''s Bar. Just Grill offers a wonderful dining experience with scrumptious grilled meats and fresh seafood."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 600, 'f9bdiPl0bWY', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'oblu-nature-helengeli-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'oblu-nature-helengeli-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'helengeli'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'oblu-nature-helengeli-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'oblu-nature-helengeli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa Pool', 700, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'oblu-nature-helengeli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- OBLU-SELECT-Lobigili
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'oblu-select-lobigili-maldives-island-resort', 'OBLU SELECT Lobigili Maldives Island Resort', 'Helengeli Island, North Male'' Atoll, is known for its Exotic House Reef, which is home to Silver-tipped Sharks, Lobsters, and Giant Sea Turtles. Embracing the lush environment on Helengeli Island and guaranteeing that the amazing house reef, only metres away from the island, is totally conserved in its original condition - the colourful, stylish, and hip resort, OBLU by Atmosphere at Helengeli, opened its doors on November 1, 2015!', 'published', 'OBLU SELECT Lobigili Maldives Island Resort | Maldives Resorts | MTG', 'Helengeli Island, North Male'' Atoll, is known for its Exotic House Reef, which is home to Silver-tipped Sharks, Lobsters, and Giant Sea Turtles. Embracing the lush environment on Helengeli Island and guaranteeing that the amazing house reef, only metres away from the island, is totally conserved in its original condition - the colourful, stylish, and hip resort, OBLU by Atmosphere at Helengeli, opened its doors on November 1, 2015!', '{"overview_paragraphs":["Helengeli Island, North Male'' Atoll, is known for its Exotic House Reef, which is home to Silver-tipped Sharks, Lobsters, and Giant Sea Turtles. Embracing the lush environment on Helengeli Island and guaranteeing that the amazing house reef, only metres away from the island, is totally conserved in its original condition - the colourful, stylish, and hip resort, OBLU by Atmosphere at Helengeli, opened its doors on November 1, 2015!","This airy, sun-lit one-bedroom beach cottage is the ultimate in relaxation. Lush tropical gardens and palm palms provide complete solitude. Carefree days begin with a pleasant swim in the pool or the sea. Inside, vibrant tropical sensations follow you, with hardwood textures, intriguing modern décor, and earthy red tones adding a sensuous touch. After a day in paradise, the sumptuous outdoor-indoor Maldivian bathroom with an open-air freestanding bathtub is ideal for a leisurely start-lit soak.","Immerse yourself in crystal-clear lagoon views and elegantly furnished areas. This one-bedroom overwater home exudes tropical serenity. The interiors are modern and lively, with relaxing white walls, warm hardwood flooring, gorgeous ocean-framing windows, and a luxurious bathroom with a tempting, deep-soaking bathtub and private overwater hammock.","OBLU CHOICE Lobigili is exclusively for adults, featuring postcard-perfect coastal and overwater homes. These remote vacation houses merge tropical panoramas and nature-inspired architecture for a romantic, castaway vibe, making them ideal for romantic getaways. While Loabigili Island is great for a romantic interlude for two, it is also suitable for adults-only trips such as a bachelorette party, carousing with friends, or a romantic couples stay in the Indian Ocean.","Ylang-Ylang (All-Day Dining) - Global flavours with an Italian twist are sure to satisfy your taste buds. Choose from a variety of live culinary stations, tandoors, and desserts ranging from the Italian specialty tiramisu to Thai Loy Coconut Milk.","Only Blu Specialty Underwater Restaurant - Culinary feast in a mystical underwater atmosphere. Our continually changing menu highlights fresh ingredients and current culinary methods to produce a one-of-a-kind dining experience that will live on forever, paired with the appropriate wine."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 800, 'RwiYnEODZuk', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'oblu-select-lobigili-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'oblu-select-lobigili-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'lobigili'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'oblu-select-lobigili-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'SunNest Beach Pool Villa', 900, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'oblu-select-lobigili-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Nest Water Villa', 800, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'oblu-select-lobigili-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- OBLU-SELECT-Sangeli
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'oblu-select-sangeli-maldives-island-resort', 'OBLU SELECT Sangeli Maldives Island Resort', 'The gloriously lovely OBLU SELECT Sangeli is located on the northwestern point of Malé Atoll, Maldives. Stay in elegant, tropical villas and suites and sample exotic cuisine at exotic restaurants and bars. Enjoy a scenic environment with swaying palm trees, pure white beaches, and a blue lagoon brimming with colourful coral life. Every aspect of a deluxe holiday is included into your stay for a really carefree and unforgettable trip at the Maldives'' greatest beach resort!', 'published', 'OBLU SELECT Sangeli Maldives Island Resort | Maldives Resorts | MTG', 'The gloriously lovely OBLU SELECT Sangeli is located on the northwestern point of Malé Atoll, Maldives. Stay in elegant, tropical villas and suites and sample exotic cuisine at exotic restaurants and bars. Enjoy a scenic environment with swaying palm trees, pure white beaches, and a blue lagoon brimming with colourful coral life. Every aspect of a deluxe holiday is included into your stay for a really carefree and unforgettable trip at the Maldives'' greatest beach resort!', '{"overview_paragraphs":["The gloriously lovely OBLU SELECT Sangeli is located on the northwestern point of Malé Atoll, Maldives. Stay in elegant, tropical villas and suites and sample exotic cuisine at exotic restaurants and bars. Enjoy a scenic environment with swaying palm trees, pure white beaches, and a blue lagoon brimming with colourful coral life. Every aspect of a deluxe holiday is included into your stay for a really carefree and unforgettable trip at the Maldives'' greatest beach resort!","These stand-alone Maldives beach bungalows are vibrant and tropical, overlooking Sangeli island''s gorgeous blue lagoons. Each has a bedroom with high ceilings, a walk-in closet, and a partially open-air Maldivian bathroom. A warm, inviting room is created by combining current design concepts with traditional Maldivian architecture. Step out onto the spacious terrace, which leads to a private garden and beach.","The stand-alone beach villas with pool on Sangeli Island''s lush green northern side are the best among Maldives hotels. Some of the attractions of this property include 5 star in-villa facilities, an open-air porch, a luxury 13m2 plunge pool, and a tropical garden going directly out to the stunning white beach and a brilliantly blue lagoon!","A stretch of ocean-facing water villas curves around the turquoise waters of the enormous Sangeli lagoon. These Maldives overwater villas are light and airy, with separate sundecks and steps going directly into the lagoon. Indulgent facilities, stunning views, and sophisticated design combine to create a deliciously intimate atmosphere, ideal for a romantic holiday!","The villas are the genuine stars of OBLU SELECT at Sangeli. On their Maldives vacation, these havens provide postcard-perfect luxury, with stand-alone villas offering private pools, lagoon-facing beach villas with direct beach access, and open-air baths. Of course, there are the Maldives'' iconic 42 over-water villas with direct lagoon access, 26 of which have a private 8 square metre plunge pool. In-villa minibars are equipped with beer, wine, soft drinks, and a variety of food and are restocked once daily. Whatever sort of accommodation you seek on your next Maldives vacation, OBLU SELECT at Sangeli has the ideal villa for you.","OBLU SELECT at Sangeli is ideally located at the northwestern tip of Male'' Atoll and is only 50 minutes by speed boat from Velana International Airport. The spacious Stand-Alone Beach & Water Villas - with & without Private Pools, an upgraded All-Inclusive plan - THE SERENITY PlanTM, with inclusions of Fine Dining experiences at two specialty restaurants - JUST GRILL & SIMPLY VEG, as well as In-Villa Mini Bar replenishment at no extra charge, set this resort apart from the rest!"]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 700, 'B_VEo7K5gCI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'oblu-select-sangeli-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'oblu-select-sangeli-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'sangeli'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'oblu-select-sangeli-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 700, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'oblu-select-sangeli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'oblu-select-sangeli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 780, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'oblu-select-sangeli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- OBLU-XPERIENCE-Ailafushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'oblu-xperience-ailafushi-maldives-island-resort', 'OBLU XPErience Ailafushi Maldives Island Resort', 'Immerse yourself in carefree tropical island living at OBLU Xperience Ailafushi, with exhilarating activities, whimsical decor, and a vibrant party environment. Ailafushi island, which means "family island" in Dhivehi, is a 15-minute speedboat journey from Malé International Airport. This limited-service 4-Star Island Resort has 268 rooms divided into four categories. With its busy retail and café environment, La Promenade offers a touch of sophistication where you can socialise with like-minded folks. Simply unbeatable!', 'published', 'OBLU XPErience Ailafushi Maldives Island Resort | Maldives Resorts | MTG', 'Immerse yourself in carefree tropical island living at OBLU Xperience Ailafushi, with exhilarating activities, whimsical decor, and a vibrant party environment. Ailafushi island, which means "family island" in Dhivehi, is a 15-minute speedboat journey from Malé International Airport. This limited-service 4-Star Island Resort has 268 rooms divided into four categories. With its busy retail and café environment, La Promenade offers a touch of sophistication where you can socialise with like-minded folks. Simply unbeatable!', '{"overview_paragraphs":["Immerse yourself in carefree tropical island living at OBLU Xperience Ailafushi, with exhilarating activities, whimsical decor, and a vibrant party environment. Ailafushi island, which means \"family island\" in Dhivehi, is a 15-minute speedboat journey from Malé International Airport. This limited-service 4-Star Island Resort has 268 rooms divided into four categories. With its busy retail and café environment, La Promenade offers a touch of sophistication where you can socialise with like-minded folks. Simply unbeatable!","The beautiful Beach Villas are only a few steps away from the white, sandy beach. Dip into the lagoon whenever you like. Alternatively, relax on your private outside veranda and garden. Warm, oak floors, a soft bed, a large sofa, beautiful themes, and vivid fabrics make the interiors just as appealing. A walk-in closet connects to a spa-like bathroom with marble vanity and an outdoor shower overlooking a garden. Everything you need to unwind in luxury is available! Enjoy your favourite beverages in your villa, with a selection of wines and spirits available for buy separately at the Wine Boutique at La Promenade and other resort locations.","The water homes are accessible through a wooden pier that stretches into the beautiful lagoon. Each overwater refuge is designed in the style of a traditional Maldivian boat - a ''dhoni'' - giving the impression of an intimate, romantic getaway. Relax on your private terrace or descend the staircase for a relaxing dip in the warm sea lapped softly against your villa. Enjoy your favourite beverages in your villa, with a selection of wines and spirits available for buy separately at the Wine Boutique at La Promenade and other resort locations.","Experience the magnificent Indian Ocean from a bright beach or overwater villa with spectacular ocean views. A joyful, free-spirited stay is created by refreshingly warm, compassionate service and delightfully furnished spaces.","The OBLU XPErience Ailafushi is conveniently positioned on the northwestern tip of Male'' Atoll, about 20 minutes via speed boat from Velana International Airport. The magnificent Beach & Water Villas on their own.","At Element X, a limited-service all-day eating restaurant, a joyful, chilled-out balance is at the centre of the dining experience. Share wonderful family memories over delectable feasts and self-service beverage kiosks. Immerse in a multi-layered experience at the vibrant X360 bar - with a distinctively engaging, joyful, and exuberant ambiance. Try the Copper Pot Food Truck''s refreshing ''Surf & Turf'' grills beneath a starlit sky, or book a reservation for a refined Modern Gastronomic experience at the iconic under ocean restaurant, Only BLU. The Fushi PlanTM includes the Element X and X360 bar. Dining at Copper Pot Food Truck and Only BLU is fee-based."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 500, '2KS4bmFNL7Y', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'oblu-xperience-ailafushi-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'oblu-xperience-ailafushi-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'ailafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'oblu-xperience-ailafushi-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 500, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'oblu-xperience-ailafushi-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 500, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'oblu-xperience-ailafushi-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- OZEN-LIFE-MAADHOO
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'ozen-life-maadhoo-maldives-island-resort', 'Ozen Life Maadhoo Maldives Island Resort', 'The first OZEN resort, a favourite among Maldives 5 star resorts, OZEN LIFE MAADHOO, is a serene palm-painted paradise of luxury located in the beautiful turquoise colours of South Malé Atoll. The resort provides exciting experiences and a dynamic island lifestyle, with 94 tastefully built villas and one unique Residence. An exquisite Maldives stay combines all the characteristics of an ultra-luxe vacation, from underwater dining at M6m to adrenaline ocean excursions.', 'published', 'Ozen Life Maadhoo Maldives Island Resort | Maldives Resorts | MTG', 'The first OZEN resort, a favourite among Maldives 5 star resorts, OZEN LIFE MAADHOO, is a serene palm-painted paradise of luxury located in the beautiful turquoise colours of South Malé Atoll. The resort provides exciting experiences and a dynamic island lifestyle, with 94 tastefully built villas and one unique Residence. An exquisite Maldives stay combines all the characteristics of an ultra-luxe vacation, from underwater dining at M6m to adrenaline ocean excursions.', '{"overview_paragraphs":["The first OZEN resort, a favourite among Maldives 5 star resorts, OZEN LIFE MAADHOO, is a serene palm-painted paradise of luxury located in the beautiful turquoise colours of South Malé Atoll. The resort provides exciting experiences and a dynamic island lifestyle, with 94 tastefully built villas and one unique Residence. An exquisite Maldives stay combines all the characteristics of an ultra-luxe vacation, from underwater dining at M6m to adrenaline ocean excursions.","Elegant, vibrant, and inviting. The Earth Villas are a cheerful and small beach holiday property. Bask in the assurance of Refined Elegance at these 185m2 stand-alone villas, which have a beautiful tropical garden that opens onto a relaxing, white, fine sandy beach and blue ocean waves. A balmy island atmosphere is created by high-pitched roofs, massive panoramic windows, open spaces, and trendy interiors done up in warm and bright colours. Each villa features a large sun terrace as well as a large outdoor bathroom with a handmade bathtub and a monsoon shower—a wonderfully refreshing vacation!","The Earth Villas with Pool is a Maldives villa that has all of the facilities of the Earth Villas as well as two more features for an even more luxurious vacation! The first is a 20-square-metre infinity pool with ambient underwater lighting. The other is stunning lagoon views, complete with a front-row ticket to the Maldivian sunset!","New, romantic, and inspiring! There are 24 charming 112 m2 Wind Villas located along the lagoon to the north of Maadhoo Island. They are built on stilts over the ocean and offer ultimate island life, which is often described as pleasant, romantic, and inspirational. Their stylish tropical décor and exquisite interiors provide a welcoming living place. The beautiful facilities, complete with free-standing elliptical bathtubs and unobstructed views of the horizon, provide for a profoundly pleasurable experience.","OZEN LIFE MAADHOO has 90 private villas in 6 categories, positioned overwater and beachfront, as well as a luxury superyacht. Each villa has its own private pool as well as direct beach or lagoon access. They provide visitors with the ultimate in luxury in massive vacation homes in the most beautiful places on the island. The opulent architecture, premium facilities, and exclusive services provide guests with an out-of-this-world experience.","Maadhoo Island is located in a remote area of the South Malé atoll. The island is reached by a 40-minute speedboat journey from Velana International Airport."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1120, 'UYUayGwigOI', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'ozen-life-maadhoo-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'ozen-life-maadhoo-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'maadhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'ozen-life-maadhoo-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Earth Villa', 1150, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'ozen-life-maadhoo-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Earth Pool Villa', 1400, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'ozen-life-maadhoo-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Wind Villa', 1120, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'ozen-life-maadhoo-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- One-and-Only
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'one-only-reethi-rah-maldives-island-resort', 'One & Only Reethi Rah Maldives Island Resort', 'This Christmas season, One&Only Reethi Rah transforms into a Sparkling Wonderland, inspired by our pristine white beach surrounding by the sun-kissed Indian Ocean. The resort is bustling with entertainment, parties, and music, from acrobats to a 15-piece showband, fire dancers, and fairy ballerinas.', 'published', 'One & Only Reethi Rah Maldives Island Resort | Maldives Resorts | MTG', 'This Christmas season, One&Only Reethi Rah transforms into a Sparkling Wonderland, inspired by our pristine white beach surrounding by the sun-kissed Indian Ocean. The resort is bustling with entertainment, parties, and music, from acrobats to a 15-piece showband, fire dancers, and fairy ballerinas.', '{"overview_paragraphs":["This Christmas season, One&Only Reethi Rah transforms into a Sparkling Wonderland, inspired by our pristine white beach surrounding by the sun-kissed Indian Ocean. The resort is bustling with entertainment, parties, and music, from acrobats to a 15-piece showband, fire dancers, and fairy ballerinas.","Each one-bedroom villa has a king-size bed and a large terrazzo bath with a walk-in rain and jet shower. Wake up to the sounds of soothing waves ebbing and flowing just metres away from your bright and spacious Maldives beachfront home. Step out into the sand from your outdoor wooden patio, through your private sun loungers and refreshing outdoor shower, and onto your own beachfront. While you settle into island life, your host and villa valet will attend to your every need discreetly.","The enormous bedroom has a king-size bed and floor-to-ceiling windows with beautiful ocean views, as well as a wide, sun-drenched en suite with soaking tub. The airy, roomy layout welcomes long and leisurely days relaxing between your living room and sun-lit patio through the wide villa doors. At our unique Maldives resort, you may relax in the solitude of your own swimming pool and length of sandy beach. Relax among the swaying palms in your hammock - a standard in all of our villas.","Our beautiful Water Villas in the Maldives have an open-plan bedroom with a king-size bed and floor-to-ceiling windows that provide panoramic water-to-sky vistas. A separate living and eating area joins a spacious bathroom, with the beautiful enormous tub affording its own spectacular perspective of the quiet waters beyond. On the split-level hardwood deck that encases the house and a coconut-thatched covered veranda, discover wrap-around netting hammocks hung just over the glittering sea.","The beautiful villas at One & Only Reethi Rah are set either over the lagoon or along the beach. These villas are sleek and stunning, with outstanding solitude and views.","One&Only Reethi Rah is located on one of the biggest islands in North Malé Atoll, surrounded by the wonders of the Indian Ocean. It is located around 700 kilometres (430 miles) southwest of Sri Lanka and is a gem among a line of coral atolls, lagoons, and white sands. Guests may reach the resort in 20 minutes via seaplane transfer or 45 minutes by speedboat transport."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 2050, '4yLvHcjWaMY', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'one-only-reethi-rah-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'one-only-reethi-rah-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'reethi-rah'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'one-only-reethi-rah-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 2050, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'one-only-reethi-rah-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 2600, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'one-only-reethi-rah-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 2450, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'one-only-reethi-rah-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

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

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'soneva-jani-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, '3 Bedroom Island Reserve', 23400, 'USD', 'King', 9, 0
from nodes where node_type = 'accommodation' and slug = 'soneva-jani-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, '1 bedroom Water Retreat', 4200, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'soneva-jani-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- South-Palm
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'south-palm-resort-maldives-island', 'South Palm Resort Maldives Island', 'South Palm Resort Maldives is a haven of unparalleled tranquillity, solitude, and comfort. Addu Atoll is surrounded by beautiful sandy beaches, a clean lagoon, and serene blue ocean vistas. South Palm Resort Maldives is a million miles away from the worries and strains of everyday life, located on a private island in the remote, southern edge of the Maldives. South Palm Resort Maldives offers 6 Villa kinds of stylish accommodation to meet all of your holiday needs. The island features a plethora of activities and outstanding amenities, including the first ever floating spa rooms in the Maldives, if not the globe. This makes it a great getaway for couples and honeymooners, as well as a fun-filled family resort.', 'published', 'South Palm Resort Maldives Island | Maldives Resorts | MTG', 'South Palm Resort Maldives is a haven of unparalleled tranquillity, solitude, and comfort. Addu Atoll is surrounded by beautiful sandy beaches, a clean lagoon, and serene blue ocean vistas. South Palm Resort Maldives is a million miles away from the worries and strains of everyday life, located on a private island in the remote, southern edge of the Maldives. South Palm Resort Maldives offers 6 Villa kinds of stylish accommodation to meet all of your holiday needs. The island features a plethora of activities and outstanding amenities, including the first ever floating spa rooms in the Maldives, if not the globe. This makes it a great getaway for couples and honeymooners, as well as a fun-filled family resort.', '{"overview_paragraphs":["South Palm Resort Maldives is a haven of unparalleled tranquillity, solitude, and comfort. Addu Atoll is surrounded by beautiful sandy beaches, a clean lagoon, and serene blue ocean vistas. South Palm Resort Maldives is a million miles away from the worries and strains of everyday life, located on a private island in the remote, southern edge of the Maldives. South Palm Resort Maldives offers 6 Villa kinds of stylish accommodation to meet all of your holiday needs. The island features a plethora of activities and outstanding amenities, including the first ever floating spa rooms in the Maldives, if not the globe. This makes it a great getaway for couples and honeymooners, as well as a fun-filled family resort.","From your Sunrise Villa, watch the first rays of morning sunshine rise over the Indian Ocean. After the concert, relax on your outside daybed and soak in the sea wind. The large 50sqm Villas, the most inexpensive accommodation category, have modern furnishings, elegant lines, and comfortable bedding.","Allow the peaceful sounds of the Indian Ocean to lull you to sleep in the middle of the day, and then wake up to experience the stunning colours of the sunset. In these huge 70 Sqm over-water villas, relax on the daybed on the wooden terrace and count the stars with a loved one.","The South Palm villas have been tastefully designed as a tranquil place for you to unwind and enjoy beautiful ocean views. A selection of 100 land-based beachfront Villas and 30 over-water Villas awaits to meet all of your vacation demands.","Located on a private island in the Maldives'' southernmost tip. Ismehela Hera is located on the western rim of Addu atoll. Gan International Airport on Addu Atoll is a 10-minute speedboat trip away.","The Banyan Restaurant, South Palm Resort''s primary dining location, offers an abundance of options. With breathtaking views of the Indian Ocean, dine on Asian and international cuisine as well as traditional Maldivian fare."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 220, 'aYQPJc27w60', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'south-palm-resort-maldives-island'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'south-palm-resort-maldives-island'
  and l.node_type = 'location' and l.slug = 'ismehela-hera'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'south-palm-resort-maldives-island'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Villa', 220, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'south-palm-resort-maldives-island'
on conflict (accommodation_id, name) do nothing;

-- Sun-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'sun-island-resort-spa-maldives', 'Sun Island Resort & Spa Maldives', 'Discover a world of adventure at Sun Island Resort & Spa, nestled in South Ari Atoll in the South Ari Marine Protected Area, whether you want adrenaline-fueled thrills or calm (SAMPA). Sun Island Resort & Spa, located on one of the biggest Maldivian islands and home to a healthy biodiversity and marine life, is a premium eco resort where natural beauty meets bright interior design and magnificent indoor-outdoor living areas. This Maldivian oasis, nestled among lush coconut trees, offers you to experience warm hospitality as well as an abundance of opportunities and exceptional seclusion to reconnect with nature.', 'published', 'Sun Island Resort & Spa Maldives | Maldives Resorts | MTG', 'Discover a world of adventure at Sun Island Resort & Spa, nestled in South Ari Atoll in the South Ari Marine Protected Area, whether you want adrenaline-fueled thrills or calm (SAMPA). Sun Island Resort & Spa, located on one of the biggest Maldivian islands and home to a healthy biodiversity and marine life, is a premium eco resort where natural beauty meets bright interior design and magnificent indoor-outdoor living areas. This Maldivian oasis, nestled among lush coconut trees, offers you to experience warm hospitality as well as an abundance of opportunities and exceptional seclusion to reconnect with nature.', '{"overview_paragraphs":["Discover a world of adventure at Sun Island Resort & Spa, nestled in South Ari Atoll in the South Ari Marine Protected Area, whether you want adrenaline-fueled thrills or calm (SAMPA). Sun Island Resort & Spa, located on one of the biggest Maldivian islands and home to a healthy biodiversity and marine life, is a premium eco resort where natural beauty meets bright interior design and magnificent indoor-outdoor living areas. This Maldivian oasis, nestled among lush coconut trees, offers you to experience warm hospitality as well as an abundance of opportunities and exceptional seclusion to reconnect with nature.","Sun Villas are tranquil getaways in the middle of the island, surrounded by luscious coconut trees and lush green flora. Large garden villas offer a calm and private place for families with young children to unwind and revitalise in the midst of Maldivian nature.","Beach Pool Villas include private pools, a wide 121sqm open plan living room with an attractive design, a private veranda, contemporary conveniences, and everything you need for an amazing Maldives vacation. Relax in your private pool while enjoying a tropical island breeze, or explore the gorgeous white beach and turquoise seas just outside your door.","The Water Villas at Sun Island Resort & Spa provide a quiet refuge located over crystal pure water. Enjoy carefree island living while admiring the expansive horizon from your private sundeck. Enjoy direct access to the lagoon from your private stairway and explore adjacent colourful reefs to enjoy the beauty of the natural aquatic environment. These luxury villas provide an unforgettable experience in one of the world''s most spectacular locations.","Sun Island Resort & Spa features 462 well appointed rooms. All of the rooms are intended to provide comfort and a pleasing outlook. From garden villas to water bungalows, all of the accommodations feature modern conveniences and are well-equipped for the modern traveller.","Sun Island Resort & Spa is situated on Nalaguraidhoo Island in South Ari Atoll, south of Malé International Airport. It is the largest resort in the Maldives, and its size comes with an unrivalled array of facilities as well as very great value for money. The resort is accessible via a 17-minute domestic flight from Male International Airport."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 200, 'B9eBA_LNeJc', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'sun-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'sun-island-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'nalaguraidhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'sun-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sun Villa', 200, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'sun-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 700, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'sun-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 600, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'sun-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- Sun-Siyam-IruVeli
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'sun-siyam-iru-veli-maldives-island-resort', 'Sun Siyam Iru Veli Maldives Island Resort', 'Sun Siyam Iru Veli is the perfect tropical hideaway, with sleek and spacious suites. With front-row lagoon views and a freshwater pool in each five-star room, all you have to do is check in, relax, and watch our neighbouring dolphins swim by each day. Shoes are left at the entrance from the time you walk in, so forget about dress rules and come as you are. We live in the barefoot idyll, so relax and bury your toes into the smoothest white sand - it doesn''t get any better than this.', 'published', 'Sun Siyam Iru Veli Maldives Island Resort | Maldives Resorts | MTG', 'Sun Siyam Iru Veli is the perfect tropical hideaway, with sleek and spacious suites. With front-row lagoon views and a freshwater pool in each five-star room, all you have to do is check in, relax, and watch our neighbouring dolphins swim by each day. Shoes are left at the entrance from the time you walk in, so forget about dress rules and come as you are. We live in the barefoot idyll, so relax and bury your toes into the smoothest white sand - it doesn''t get any better than this.', '{"overview_paragraphs":["Sun Siyam Iru Veli is the perfect tropical hideaway, with sleek and spacious suites. With front-row lagoon views and a freshwater pool in each five-star room, all you have to do is check in, relax, and watch our neighbouring dolphins swim by each day. Shoes are left at the entrance from the time you walk in, so forget about dress rules and come as you are. We live in the barefoot idyll, so relax and bury your toes into the smoothest white sand - it doesn''t get any better than this.","These suites are spacious and appealing, with views of the dawn or sunset and lots of space to assemble. Plenty of natural light is provided through floor-to-ceiling glass doors and an outdoor bathroom, as well as space to enjoy outside on the wide sundeck, your own length of beach, or in your private pool.","These suites provide front-row seats for seeing dolphins swim by every day - a spectacular sight you''ll never forget. We''ve brought the beach right to your door, with your very own length of sand constructed into the deck.","Enjoy the good life in our 125 sun-drizzled suites, which are scattered over the lagoon and across sugar-fine dunes and are bathed in warm, natural light. Each is a luxurious hideaway with its own private pool.","Sun Siyam Iru Veli lives on Aluvifushi, an island in South Nilandhe Atoll (also known as Dhaalu Atoll). Sun Siyam Iru Veli is 40 minutes from Velana International Airport via seaplane.","The buffet at Aqua Orange is a visual feast, presenting an incredible assortment of cuisines from across the world. Following breakfast, lunch and supper will entice you with Italian classics, Maldivian specialties, and themed evenings. With tables placed out on the beach, you may enjoy stunning lagoon views as your backdrop."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1300, '1ljyDTmN1Yk', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'sun-siyam-iru-veli-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'sun-siyam-iru-veli-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'aloofushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'sun-siyam-iru-veli-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Family Suite Pool', 1400, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'sun-siyam-iru-veli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Dolphin Ocean Suite', 1300, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'sun-siyam-iru-veli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Sun-Siyam-Olhuveli
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'sun-siyam-olhuveli-maldives-island-resort', 'Sun Siyam Olhuveli Maldives Island Resort', 'The large island of Olhuveli is only a 45-minute speedboat trip away from where you landed. With no need for a seaplane, you can get right into visiting our two islands or just relaxing. This is your time together. Sun Siyam Olhuveli combines traditional Maldivian style with modern design, with accommodations ranging from Maldivian-inspired suites to sleek contemporary villas. We have three pools to appeal to your every need, including an adults-only infinity pool that never fails to please - but be careful, the lagoon may pull you into adventure.', 'published', 'Sun Siyam Olhuveli Maldives Island Resort | Maldives Resorts | MTG', 'The large island of Olhuveli is only a 45-minute speedboat trip away from where you landed. With no need for a seaplane, you can get right into visiting our two islands or just relaxing. This is your time together. Sun Siyam Olhuveli combines traditional Maldivian style with modern design, with accommodations ranging from Maldivian-inspired suites to sleek contemporary villas. We have three pools to appeal to your every need, including an adults-only infinity pool that never fails to please - but be careful, the lagoon may pull you into adventure.', '{"overview_paragraphs":["The large island of Olhuveli is only a 45-minute speedboat trip away from where you landed. With no need for a seaplane, you can get right into visiting our two islands or just relaxing. This is your time together. Sun Siyam Olhuveli combines traditional Maldivian style with modern design, with accommodations ranging from Maldivian-inspired suites to sleek contemporary villas. We have three pools to appeal to your every need, including an adults-only infinity pool that never fails to please - but be careful, the lagoon may pull you into adventure.","King-size bedrooms include clean white lines with vibrant bursts of colour, as well as an alcoved daybed great for curling up with a good book. The outdoor baths are spacious, and there is an eating area, daybed, and sun loungers on the oceanfront terrace.","These traditional Maldivian overwater villas have an outdoor jet tub and steps that go straight into the lagoon. The king-size beds are located behind a comfy sofa, well positioned to soak in the views, and each bathroom has a standalone tub.","Step into your new home at Sun Siyam Olhuveli Maldives for the next several pleasant days. Each of the 164 villas, which include Deluxe Rooms, Beach Villas, Deluxe Water Villas, Jacuzzi Water Villas, and Honeymoon Water Villas, as well as the luxury Presidential Water Suite, has been designed with comfort, relaxation, and elegance in mind. The rooms were created using natural materials and integrating them with modern elegance and open-air styled to take advantage of the Maldivian sunlight and serene vistas. A variety of villas offer the ideal option of lodging for families, couples, honeymooners, and individuals alike.","The scenic Sun Siyam Olhuveli Maldives is located on the tip of South Male'' Atoll, 34 kilometres from Velana International Airport, and is known for its magnificent beaches and numerous sandbanks. A scenic 45-minute speedboat ride takes you to the resort.","Malaafaiy, which is perfectly located for Dream Island guests, provides something for everyone all day long. Ocean vistas and a pleasant sea wind will accompany every meal, whether you''re fueling up before a long day of activity, stopping in for a quick lunch, or visiting us for dinner."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 800, 'H-_NBKBb1fw', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'sun-siyam-olhuveli-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'sun-siyam-olhuveli-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'olhuveli'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'sun-siyam-olhuveli-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Garden Beach Villa', 800, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'sun-siyam-olhuveli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Water Villa', 800, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'sun-siyam-olhuveli-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Sun-Siyam-ViluReef
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'sun-siyam-vilu-reef-maldives-island-resort', 'Sun Siyam Vilu Reef Maldives Island Resort', 'Stay at Sun Siyam Vilu Reef Maldives'' water villas and enjoy 5 star luxury with sand beneath your feet. Sink into new depths of relaxation with the waves as your soundtrack in this perfect honeymoon destination. You''ll quickly understand why we welcome so many familiar faces back year after year. Sun Siyam Vilu Reef''s water villas are surrounded by some of the nicest coral reef in the Maldives, and we''ve been sharing the resort''s island home with unique flora and animals for over 20 years. Coconut palms flutter in the air, and don''t be shocked if you see a heron or a hermit crab on your walk to breakfast.', 'published', 'Sun Siyam Vilu Reef Maldives Island Resort | Maldives Resorts | MTG', 'Stay at Sun Siyam Vilu Reef Maldives'' water villas and enjoy 5 star luxury with sand beneath your feet. Sink into new depths of relaxation with the waves as your soundtrack in this perfect honeymoon destination. You''ll quickly understand why we welcome so many familiar faces back year after year. Sun Siyam Vilu Reef''s water villas are surrounded by some of the nicest coral reef in the Maldives, and we''ve been sharing the resort''s island home with unique flora and animals for over 20 years. Coconut palms flutter in the air, and don''t be shocked if you see a heron or a hermit crab on your walk to breakfast.', '{"overview_paragraphs":["Stay at Sun Siyam Vilu Reef Maldives'' water villas and enjoy 5 star luxury with sand beneath your feet. Sink into new depths of relaxation with the waves as your soundtrack in this perfect honeymoon destination. You''ll quickly understand why we welcome so many familiar faces back year after year. Sun Siyam Vilu Reef''s water villas are surrounded by some of the nicest coral reef in the Maldives, and we''ve been sharing the resort''s island home with unique flora and animals for over 20 years. Coconut palms flutter in the air, and don''t be shocked if you see a heron or a hermit crab on your walk to breakfast.","Our 14 Beach Bungalows are directly on the beach, only steps from the lagoon. Bright white furnishings contrast with tropical colour accents, and each suite has a king-size bed, an alcoved daybed, an outdoor bathroom with a rain shower, and a covered terrace with loungers and a dining space.","There are just six Aqua Villas on the jetty, and with infinity plunge pools, overwater hammocks, and big outside terraces with stairs straight down to the lagoon, it''s simple to understand why. Sliding glass doors let in natural light and seaside breezes, and the bathrooms include freestanding tubs and separate showers.","Sun Siyam Vilu Reef villas provide a taste of island living - a relaxed luxury brimming with friendliness. Sleep to the sound of the waves and jump into the sea from your own private jetty. They truly offer something for everyone, with 103 beautiful Villas, 6 Suites, 62 Land Villas, and 35 Over Water Villas.","Get away from the fast-paced city life and start your trip to luxury. Sun Siyam Vilu Reef is approximately a 35-minute seaplane journey from the international airport. The ride to Vilu Reef is breathtaking, so your escape to paradise begins as soon as you land at the airport.","Seafood lovers should attend to our monthly lobster and champagne feast, served on the beach with live music, from the restaurants and bars at Sun Siyam Vilu Reef Maldives. Cocktail experts will like our herb-infused creations, while wine connoisseurs will enjoy our award-winning cellar, which houses over 1,400 wines."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 800, 'KWl90P4Oe10', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'sun-siyam-vilu-reef-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'sun-siyam-vilu-reef-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'meedhuffushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'sun-siyam-vilu-reef-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 800, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'sun-siyam-vilu-reef-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Aqua Villa', 1000, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'sun-siyam-vilu-reef-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Taj-Coral-Reef
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'taj-coral-reef-resort-spa-maldives', 'Taj Coral Reef Resort & Spa Maldives', 'Taj Coral Reef Resort & Spa, located on heart-shaped Hembadhu Island, is a modern tropical haven hidden atop a 1000-year-old beautiful coral atoll in sunny Maldives. A 45-minute speed boat trip from Velana International Airport, 62 magnificent thatched-roof villas are built above our house reef to provide ecologically friendly, all-inclusive holidays.', 'published', 'Taj Coral Reef Resort & Spa Maldives | Maldives Resorts | MTG', 'Taj Coral Reef Resort & Spa, located on heart-shaped Hembadhu Island, is a modern tropical haven hidden atop a 1000-year-old beautiful coral atoll in sunny Maldives. A 45-minute speed boat trip from Velana International Airport, 62 magnificent thatched-roof villas are built above our house reef to provide ecologically friendly, all-inclusive holidays.', '{"overview_paragraphs":["Taj Coral Reef Resort & Spa, located on heart-shaped Hembadhu Island, is a modern tropical haven hidden atop a 1000-year-old beautiful coral atoll in sunny Maldives. A 45-minute speed boat trip from Velana International Airport, 62 magnificent thatched-roof villas are built above our house reef to provide ecologically friendly, all-inclusive holidays.","Superior Beach Villas are 58 square metres of ultimate luxury, with 12 attractively decorated Superior Beach Villas. Our airy Superior beach villas at Taj Coral Reef, Maldives work their spell on you with amazing views, outdoor bathrooms, and a distinctively constructed open area, and are built in subdued and relaxing pastel colours with a wide comfy sea-facing bed. These magnificent rooms, with distinctive thatched roofs, provide complete solitude for your tropical escape. You may enjoy all of the greatest amenities at these beach villas. Wrap yourself in 100% cotton robes, indulge in delectable snacks from our 24-hour in-villa dining, or simply watch a movie on our 43\" LED TV with home theatre system. Come on in and let us immerse you in ecstasy.","Our Taj Coral Reef, Maldives'' 32 Premium Water Villas will delight all of your senses. This is a great area for supper, with 85 square metres designed to be your personal paradise, a thatched roof, and an exterior terrace facing the sea with sun loungers. Absolute joy! An open-air shower and a large wooden stairway leading directly into the lagoon would complete the indoor-outdoor experience. Inside, you''ll find a wide peaceful sea-facing bed, a wardrobe, and direct access to the outdoor terrace from the bedroom and bathroom. A comfortable day bed, attractive furnishings, and the Treat Yourself minibar, which features organic foods and drinks, are among the other amenities. Begin your tropical transformation now.","The resort provides modern conveniences in a natural setting, with most of the magnificent apartments and villas enjoying ocean views, whether on the beach or across the lagoon. Spacious thatched villas provide sophisticated décor, soft furniture, and stunning bathrooms with open air showers, while private decks provide relaxing places. Some villas include a private plunge pool for extra luxury, while the Nirvana Presidential Suites are ideal for families with two bedrooms split across two storeys.","The resort is located on Hembadhu Island, less than 32 kilometres from Velana International Airport. Amateurs and pros can explore the resort''s own own house reef and shipwreck. Those who choose to stay on land will be captivated by the beauty of the lagoon studded with water homes.","What is a world-class island trip without excellent seafood, beach barbecues, and elegant private dining? Our Coral All-Inclusive Meal Plan is your gastronomic passport to a wide range of international and regional cuisines at these fashionable establishments. The Coral All-Inclusive provides everything you need for a fantastic holiday in one easy package. We''ve curated a bouquet of our best gourmet and aquatic experiences so you may see and do it all without having to pick and choose."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1150, 'dPFQMGyAFck', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'taj-coral-reef-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'taj-coral-reef-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'hembadhu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'taj-coral-reef-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Superior Beach Villa', 1150, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'taj-coral-reef-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Premium Water Villa', 1400, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'taj-coral-reef-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- Taj-Exotica
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'taj-exotica-resort-spa-maldives', 'Taj Exotica Resort & Spa Maldives', 'Escape the frantic speed and confusion of everyday life at Taj Exotica Resort & Spa in the Maldives. Away from the bright lights of Male, our 5 star Maldives hotel is set across the Emboodhu Finolhu island in the heart of one of the Maldives'' biggest lagoons. This tropical isle, also known as the Three Coconut Isle, is located among coral reefs and is recognised for its abundant flora and wildlife. A 15- to 20-minute speedboat journey from the airport takes you to Male''s lovely beach resort, which is encircled by the blue seas of the Indian Ocean. Set gently above the lagoon, this postcard-perfect Maldives retreat offers 64 sea-view suites and villas that are sumptuous and extravagant while remaining affordable.', 'published', 'Taj Exotica Resort & Spa Maldives | Maldives Resorts | MTG', 'Escape the frantic speed and confusion of everyday life at Taj Exotica Resort & Spa in the Maldives. Away from the bright lights of Male, our 5 star Maldives hotel is set across the Emboodhu Finolhu island in the heart of one of the Maldives'' biggest lagoons. This tropical isle, also known as the Three Coconut Isle, is located among coral reefs and is recognised for its abundant flora and wildlife. A 15- to 20-minute speedboat journey from the airport takes you to Male''s lovely beach resort, which is encircled by the blue seas of the Indian Ocean. Set gently above the lagoon, this postcard-perfect Maldives retreat offers 64 sea-view suites and villas that are sumptuous and extravagant while remaining affordable.', '{"overview_paragraphs":["Escape the frantic speed and confusion of everyday life at Taj Exotica Resort & Spa in the Maldives. Away from the bright lights of Male, our 5 star Maldives hotel is set across the Emboodhu Finolhu island in the heart of one of the Maldives'' biggest lagoons. This tropical isle, also known as the Three Coconut Isle, is located among coral reefs and is recognised for its abundant flora and wildlife. A 15- to 20-minute speedboat journey from the airport takes you to Male''s lovely beach resort, which is encircled by the blue seas of the Indian Ocean. Set gently above the lagoon, this postcard-perfect Maldives retreat offers 64 sea-view suites and villas that are sumptuous and extravagant while remaining affordable.","These lovely homes are set on excellent white beach sand and are only steps away from the lagoon. To round out your Maldives experience, indulge in the joys of a tropical outdoor shower in your private walled garden.","Overwater Villas on stilts with private sun decks, loungers, and easy chairs, as well as direct access to the lagoon. Each villa has a double vanity bathroom, rain showers, and bathtubs, as well as breathtaking views of the Indian Ocean.","This postcard-perfect retreat is set gently above the lagoon and provides 64 sea-view villas and suites that are sumptuous and extravagant while maintaining a fine balance with nature. The Taj Exotica Resort & Spa also includes a world-famous, award-winning presidential suite that is probably the most gorgeous spot on the planet.","Taj Exotica Resort & Spa is located away from the bright lights of Male'', on Emboodhu Finolhu island, in the heart of one of the Maldives'' biggest lagoons. The lovely resort is bordered by the blue seas of the Indian Ocean and is only a 15-minute speedboat ride from the airport.","At Taj Exotica Maldives, you can eat your way across the globe. The chefs at our award-winning Maldives restaurants guarantee to take you on a culinary tour de force. This, along with the splendour of the Maldives, creates an otherworldly experience."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 2500, 'AHXkN6Zbg3E', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'taj-exotica-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'taj-exotica-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'emboodhu-finolhu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'taj-exotica-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Beach Pool Villa', 3400, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'taj-exotica-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Villa', 2500, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'taj-exotica-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

-- The-Ritz-Carlton
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'the-ritz-carlton-maldives-fari-island-resort', 'The Ritz Carlton Maldives Fari Island Resort', 'The Ritz-Carlton Maldives, Fari Islands invites you to immerse yourself in island life and relax in an azure lagoon surrounded by white sand beaches. From Velana International Airport, the resort is a 45-minute picturesque voyage by luxury speedboat or a 10-minute seaplane flight away. The resort features 100 elegantly built villas by Kerry Hill Architect, inspired by water and circular movement, where modern architecture meets the Maldives. Each villa features a private pool, sundeck, en-suite bathroom, and a spectacular assortment of individualized amenities both indoors and out.', 'published', 'The Ritz Carlton Maldives Fari Island Resort | Maldives Resorts | MTG', 'The Ritz-Carlton Maldives, Fari Islands invites you to immerse yourself in island life and relax in an azure lagoon surrounded by white sand beaches. From Velana International Airport, the resort is a 45-minute picturesque voyage by luxury speedboat or a 10-minute seaplane flight away. The resort features 100 elegantly built villas by Kerry Hill Architect, inspired by water and circular movement, where modern architecture meets the Maldives. Each villa features a private pool, sundeck, en-suite bathroom, and a spectacular assortment of individualized amenities both indoors and out.', '{"overview_paragraphs":["The Ritz-Carlton Maldives, Fari Islands invites you to immerse yourself in island life and relax in an azure lagoon surrounded by white sand beaches. From Velana International Airport, the resort is a 45-minute picturesque voyage by luxury speedboat or a 10-minute seaplane flight away. The resort features 100 elegantly built villas by Kerry Hill Architect, inspired by water and circular movement, where modern architecture meets the Maldives. Each villa features a private pool, sundeck, en-suite bathroom, and a spectacular assortment of individualized amenities both indoors and out."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 2384, 'Zcocq4od2Tw', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'the-ritz-carlton-maldives-fari-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'the-ritz-carlton-maldives-fari-island-resort'
  and l.node_type = 'location' and l.slug = 'fari-islands'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'the-ritz-carlton-maldives-fari-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Villa', 2887, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'the-ritz-carlton-maldives-fari-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Pool Villa', 2384, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'the-ritz-carlton-maldives-fari-island-resort'
on conflict (accommodation_id, name) do nothing;

-- VARU-Atmosphere
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'varu-by-atmosphere-maldives-island-resort', 'VARU by Atmosphere Maldives Island Resort', 'Atmosphere Hotels & Resorts introduces VARU by Atmosphere, a Maldives all-inclusive resort, nestled in the beautiful Indian Oceans of the Maldives. Enjoy your first moments in paradise on a 40-minute speed boat ride from Male International Airport to the Maldives'' northwestern coast. Experience the local culture and genuine hospitality while receiving 5 star treatment during your stay. ''Varu'' in Dhivehi, the local dialect, means strength, resilience, and plenty, all of which come to life at the resort, with its ideal combination of contemporary architecture and tropical feelings of the island paradise.', 'published', 'VARU by Atmosphere Maldives Island Resort | Maldives Resorts | MTG', 'Atmosphere Hotels & Resorts introduces VARU by Atmosphere, a Maldives all-inclusive resort, nestled in the beautiful Indian Oceans of the Maldives. Enjoy your first moments in paradise on a 40-minute speed boat ride from Male International Airport to the Maldives'' northwestern coast. Experience the local culture and genuine hospitality while receiving 5 star treatment during your stay. ''Varu'' in Dhivehi, the local dialect, means strength, resilience, and plenty, all of which come to life at the resort, with its ideal combination of contemporary architecture and tropical feelings of the island paradise.', '{"overview_paragraphs":["Atmosphere Hotels & Resorts introduces VARU by Atmosphere, a Maldives all-inclusive resort, nestled in the beautiful Indian Oceans of the Maldives. Enjoy your first moments in paradise on a 40-minute speed boat ride from Male International Airport to the Maldives'' northwestern coast. Experience the local culture and genuine hospitality while receiving 5 star treatment during your stay. ''Varu'' in Dhivehi, the local dialect, means strength, resilience, and plenty, all of which come to life at the resort, with its ideal combination of contemporary architecture and tropical feelings of the island paradise.","Beach Villas with Pool are located along the palm-fringed beach, only steps from from the gorgeous white sandy beach. Relax in well-appointed surroundings with natural wood and stone accents, minimalistic design, and ornamental things. The expansive outside terrace is surrounded by lush green flora and a private infinity pool of 10m2.","Escape to an exquisite getaway at our Maldives Overwater pool villa, just steps from from the blue lagoon. This precisely constructed apartment combines the finest of modern living with cutting-edge conveniences. Everything here reflects the island''s fascinating Indian Ocean surroundings, from Maldivian-style interiors to enticing tropical features. The wide veranda has a private 10m2 infinity pool, ideal for a refreshing dip while admiring the lovely lagoon views.","VARU is positioned as a modern and ''Naturally Maldivian'' resort experience, with 108 Villas strewn along the white sandy beaches and spreading over the blue lagoons onto three jetties with over-water accommodation.","VARU is located on the northwestern border of the Malé Atoll Maldives.","Indulge in a gastronomical adventure at VARU by Atmosphere in the Maldives, with the top Maldives restaurants bringing the world to you on a plate through the most delectable culinary experiences. Choose from the best culinary dishes from Europe to Asia, with a Maldivian twist. To create that unique experience for the ages, enjoy magnificent lunch and supper dishes with stunning presentations matched by exquisite vistas."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 1200, 'JCoOrSl6-as', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'varu-by-atmosphere-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'varu-by-atmosphere-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'madivaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'varu-by-atmosphere-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1200, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'varu-by-atmosphere-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Pool Villa', 1400, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'varu-by-atmosphere-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Vakkaru
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'vakkaru-maldives-island-resort', 'Vakkaru Maldives Island Resort', 'Vakkaru Maldives is an isolated coral island inside the UNESCO Biosphere Reserve of Baa Atoll, blessed with timeless ocean vistas, powder-soft, beautiful white sands, deep blue holes, and a house reef with unique marine fauna. A picturesque 30-minute seaplane journey from Male International Airport whisks you away to this pristine hideaway, which has been intelligently built for tourists seeking timeless experiences.', 'published', 'Vakkaru Maldives Island Resort | Maldives Resorts | MTG', 'Vakkaru Maldives is an isolated coral island inside the UNESCO Biosphere Reserve of Baa Atoll, blessed with timeless ocean vistas, powder-soft, beautiful white sands, deep blue holes, and a house reef with unique marine fauna. A picturesque 30-minute seaplane journey from Male International Airport whisks you away to this pristine hideaway, which has been intelligently built for tourists seeking timeless experiences.', '{"overview_paragraphs":["Vakkaru Maldives is an isolated coral island inside the UNESCO Biosphere Reserve of Baa Atoll, blessed with timeless ocean vistas, powder-soft, beautiful white sands, deep blue holes, and a house reef with unique marine fauna. A picturesque 30-minute seaplane journey from Male International Airport whisks you away to this pristine hideaway, which has been intelligently built for tourists seeking timeless experiences.","Beach Villa with Plunge Pool, surrounded by swaying coconut palms and lush greenery, with direct beach access and a private terrace, as well as a recently added open-air Jacuzzi suited for couples seeking romantic relaxation.","Our Over Water Villas are the perfect romantic getaway positioned over the turquoise lagoon, with a private over water patio and hammock for two people wishing to savour the splendour of their aquatic surrounds.","Whether you are travelling as a couple on a romantic getaway or in a bigger group with family and friends, Vakkaru Maldives has a fantastic selection of luxury hotel choices. All 113 beach and over water villas and Residences have an earthy yet sophisticated style, in line with the rustic charms of Maldivian culture, and give an unparalleled feeling of spaciousness and breathtaking ocean vistas.","From Velana International Airport, a picturesque 25-minute seaplane trip takes you to Vakkaru Maldives, an enchanting sanctuary organically built to heal the soul and quiet the spirit.","To begin the day, enjoy healthy flavours in a quiet, light, and airy atmosphere by the beach, with an interactive presentation of world cuisines and inspired meals enhanced with local tastes and tropical tones."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 3000, '-tmrOPCI3-Q', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'vakkaru-maldives-island-resort'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'vakkaru-maldives-island-resort'
  and l.node_type = 'location' and l.slug = 'vakkaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'vakkaru-maldives-island-resort'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 4800, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'vakkaru-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Villa', 3000, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'vakkaru-maldives-island-resort'
on conflict (accommodation_id, name) do nothing;

-- Veligandu-Island
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'veligandu-island-resort-spa-maldives', 'Veligandu Island Resort & Spa Maldives', 'The jewel of the Indian Ocean is Veligandu Island Resort & Spa. A charming tropical paradise filled with swaying palm palms, white sand beaches, crystal clear water, and exuberant coral reefs alive with marine life. This green island retreat provides peace and serenity, which feed one''s well-being.', 'published', 'Veligandu Island Resort & Spa Maldives | Maldives Resorts | MTG', 'The jewel of the Indian Ocean is Veligandu Island Resort & Spa. A charming tropical paradise filled with swaying palm palms, white sand beaches, crystal clear water, and exuberant coral reefs alive with marine life. This green island retreat provides peace and serenity, which feed one''s well-being.', '{"overview_paragraphs":["The jewel of the Indian Ocean is Veligandu Island Resort & Spa. A charming tropical paradise filled with swaying palm palms, white sand beaches, crystal clear water, and exuberant coral reefs alive with marine life. This green island retreat provides peace and serenity, which feed one''s well-being.","Enjoy beachfront views from your Maldives Beach Villa, which is only a few steps from the water. All of our 11 Beach Villas are set among lush tropical flora and beneath swaying coconut palms and offer the needed facilities for a pleasant, comfortable vacation in paradise.","Slip away to your private ocean retreat and enjoy the pleasure of direct access to the blue waters of the ocean through the stairs on your Water Villa''s sun-kissed balcony.","Private porches, lagoon views, flat-screen TVs, and complimentary high-speed Internet are available in the exquisite villas. Upgraded villas have whirlpool spas or Jacuzzis, and some are perched on stilts over the lagoon. Some villas accept children aged 14 and under.","A 20-minute seaplane journey from Velana International Airport takes you to this quiet resort on a 600-meter-long island. Surrounded by stunning lagoons, a great house reef, and long expanses of pristine white sand,","Enjoy the exquisite joys of paradise while tickling your taste senses. Veligandu, home to some of the top restaurants in the Maldives, serves flavorful native food as well as cuisines from across the world. Dhonveli, our primary restaurant, offers a wide range of cuisines. During breakfast, lunch, and supper, the buffet offers a diverse selection of gastronomic pleasures. Madivaru, our famous à la carte restaurant, serves a fine dining menu full of delectable specialties, all while overlooking the lagoon. Relaxed afternoons and evenings are best spent at one of our bars, with a cool drink in hand."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', 5, 600, '8RTjyBXGrJA', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'veligandu-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'veligandu-island-resort-spa-maldives'
  and l.node_type = 'location' and l.slug = 'veligandu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'veligandu-island-resort-spa-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Villa', 600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'veligandu-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 600, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'veligandu-island-resort-spa-maldives'
on conflict (accommodation_id, name) do nothing;

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

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 332, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'summer-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- vommuli
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'the-st-regis-vommuli-island-resort-maldives', 'The St. Regis Vommuli Island Resort Maldives', 'The St. Regis Maldives Vommuli Resort overlooks the alluring waves of the Indian Ocean, nestled between verdant rain forest and white-sand beaches on a private island. Explore the quiet, eco-friendly setting''s tropical beauty and abundant marine life. The Iridium Spa and outdoor swimming pool, as well as the private lagoon, offer unrivaled relaxation. At the beach, there is a wide range of water sports and excursions. The butlers, the diving center''s signature operation, will arrange a wide range of water sports and excursions. In addition, their six restaurants and bars serve delectable cuisine.', 'published', 'The St. Regis Vommuli Island Resort Maldives | Maldives Resorts | MTG', 'The St. Regis Maldives Vommuli Resort overlooks the alluring waves of the Indian Ocean, nestled between verdant rain forest and white-sand beaches on a private island. Explore the quiet, eco-friendly setting''s tropical beauty and abundant marine life. The Iridium Spa and outdoor swimming pool, as well as the private lagoon, offer unrivaled relaxation. At the beach, there is a wide range of water sports and excursions. The butlers, the diving center''s signature operation, will arrange a wide range of water sports and excursions. In addition, their six restaurants and bars serve delectable cuisine.', '{"overview_paragraphs":["The St. Regis Maldives Vommuli Resort overlooks the alluring waves of the Indian Ocean, nestled between verdant rain forest and white-sand beaches on a private island. Explore the quiet, eco-friendly setting''s tropical beauty and abundant marine life. The Iridium Spa and outdoor swimming pool, as well as the private lagoon, offer unrivaled relaxation. At the beach, there is a wide range of water sports and excursions. The butlers, the diving center''s signature operation, will arrange a wide range of water sports and excursions. In addition, their six restaurants and bars serve delectable cuisine.","Each of the 33 on-land and 44 over-water villas at St. Regis Maldives Vommuli Resort offers picturesque ocean or garden views from private terraces and pools, as well as refined furnishings and island-inspired architecture. The legendary Butlers of the St. Regis provide personalized service at all hours of the day and night."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 763, 'SrtYhHoTGfw', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'the-st-regis-vommuli-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'the-st-regis-vommuli-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'vommuli'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'the-st-regis-vommuli-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Garden Pool Villa', 763, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'the-st-regis-vommuli-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 859, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'the-st-regis-vommuli-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Pool Villa', 910, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'the-st-regis-vommuli-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- w-maldives
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'w-maldives-island-resort-maldives', 'W Maldives Island Resort Maldives', 'W Maldives is a wonderland of white sand beaches, turquoise lagoons, and stunning reefs where you can relax, mingle, dance, and enhance your paradise adventure. W Maldives is a peaceful haven with a Diving Center, Fitness Center, and open-air Infinity Pool. Expansive Villas come with a private plunge pool and direct beach, lagoon, or ocean entry. AWAY® Spa, which offers massage, Ayurvedic, and facial treatments, is a haven of indulgence. Water Sports, Yoga, and Aqua Aerobics are among the activities available to visitors.', 'published', 'W Maldives Island Resort Maldives | Maldives Resorts | MTG', 'W Maldives is a wonderland of white sand beaches, turquoise lagoons, and stunning reefs where you can relax, mingle, dance, and enhance your paradise adventure. W Maldives is a peaceful haven with a Diving Center, Fitness Center, and open-air Infinity Pool. Expansive Villas come with a private plunge pool and direct beach, lagoon, or ocean entry. AWAY® Spa, which offers massage, Ayurvedic, and facial treatments, is a haven of indulgence. Water Sports, Yoga, and Aqua Aerobics are among the activities available to visitors.', '{"overview_paragraphs":["W Maldives is a wonderland of white sand beaches, turquoise lagoons, and stunning reefs where you can relax, mingle, dance, and enhance your paradise adventure. W Maldives is a peaceful haven with a Diving Center, Fitness Center, and open-air Infinity Pool. Expansive Villas come with a private plunge pool and direct beach, lagoon, or ocean entry. AWAY® Spa, which offers massage, Ayurvedic, and facial treatments, is a haven of indulgence. Water Sports, Yoga, and Aqua Aerobics are among the activities available to visitors.","On W Maldives, there are 78 different Retreats to choose from. There are 28 land-based Beach Oasis, including three twin Beach Oasis; 25 over-water Ocean Oasis and 21 Ocean Oasis Lagoon View Retreats; 3 Seascape Escapes, our Junior Suites; and one Extreme WOW Villa, the 2-Bedroom Ocean Haven."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'resort', null, 728, 'dVPW7ifhylg', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'w-maldives-island-resort-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'w-maldives-island-resort-maldives'
  and l.node_type = 'location' and l.slug = 'fesdu'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'w-maldives-island-resort-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sunrise Beach Villa', 824, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'w-maldives-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Over Water Pool Villa', 728, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'w-maldives-island-resort-maldives'
on conflict (accommodation_id, name) do nothing;

-- Amra-Palace
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'amra-palace-island-hotel-maldives', 'Amra Palace Island Hotel Maldives', 'Amra Palace is a private gated residence surrounded by lush tropical gardens. It is the ideal setting for unwinding, relaxing, and enjoying the Maldives'' natural beauty. The friendly staff at Amra Hotel can arrange you a variety of activities such as diving, snorkelling, island hopping, and dolphin watching, while the in-house restaurant serves local and foreign cuisine. In-room eating is also available through room service.', 'published', 'Amra Palace Island Hotel Maldives | Maldives Hotels | MTG', 'Amra Palace is a private gated residence surrounded by lush tropical gardens. It is the ideal setting for unwinding, relaxing, and enjoying the Maldives'' natural beauty. The friendly staff at Amra Hotel can arrange you a variety of activities such as diving, snorkelling, island hopping, and dolphin watching, while the in-house restaurant serves local and foreign cuisine. In-room eating is also available through room service.', '{"overview_paragraphs":["Amra Palace is a private gated residence surrounded by lush tropical gardens. It is the ideal setting for unwinding, relaxing, and enjoying the Maldives'' natural beauty. The friendly staff at Amra Hotel can arrange you a variety of activities such as diving, snorkelling, island hopping, and dolphin watching, while the in-house restaurant serves local and foreign cuisine. In-room eating is also available through room service.","The rooms of Amra Palace are divided into two categories: deluxe and outstanding. Superior rooms are located on the first level and are big and pleasant, as well as equipped with all modern comforts. Deluxe rooms are on the ground level and enjoy a beautiful view of the Amra Palace grounds and gardens. Amra Palace can also accommodate families, with twin beds and interconnecting rooms available.","Amra Palace is located in a vibrant and dynamic local community and is accessible through a 35-minute flight from Velana International Airport to Kaddhoo Domestic Airport and a 10-minute car ride. It is ideally located a 5-minute walk from one of the Gan Atoll''s nicest, most opulent, and prettiest beaches."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'hotel', null, null, 'BNO2diluGHE', 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'amra-palace-island-hotel-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'amra-palace-island-hotel-maldives'
  and l.node_type = 'location' and l.slug = 'gan'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'amra-palace-island-hotel-maldives'
on conflict (id) do nothing;

-- casa-retreat
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'casa-retreat', 'casa-retreat', 'Casa Retreat is an ideal place to stay in Male City and Airport for travelers seeking beauty, comfort, and convenience. This is a convenient property that is near to the airport and easily accessible from both Male'' and Hulhumale''. The hotel has its own spa, which will deliver a 1-hour spa treatment at a reduced rate, as well as other excursions.', 'published', 'casa-retreat | Maldives Guesthouses | MTG', 'Casa Retreat is an ideal place to stay in Male City and Airport for travelers seeking beauty, comfort, and convenience. This is a convenient property that is near to the airport and easily accessible from both Male'' and Hulhumale''. The hotel has its own spa, which will deliver a 1-hour spa treatment at a reduced rate, as well as other excursions.', '{"overview_paragraphs":["Casa Retreat is an ideal place to stay in Male City and Airport for travelers seeking beauty, comfort, and convenience. This is a convenient property that is near to the airport and easily accessible from both Male'' and Hulhumale''. The hotel has its own spa, which will deliver a 1-hour spa treatment at a reduced rate, as well as other excursions.","Hotel have excellent services and amenities, ensuring that you have a pleasant stay. The hotel offers complimentary Wi-Fi in all rooms, as well as daily housekeeping and a restaurant. Some facilities, such as \"things to do and ways to relax,\" are available outside of the accommodation."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'guesthouse', null, 67, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'casa-retreat'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'casa-retreat'
  and l.node_type = 'location' and l.slug = 'hulhumale'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'casa-retreat'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Standard Room', 67, 'USD', null, null, 0
from nodes where node_type = 'accommodation' and slug = 'casa-retreat'
on conflict (accommodation_id, name) do nothing;

-- gaafaru-view-inn-maldives
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'gaafari-view-inn-hotel-maldives', 'Gaafari view inn Hotel Maldives', 'Gaafaru View Inn is a three-star Guest House in the Maldives. The guest house provides guests with 7 air-conditioned rooms with private bathrooms and balconies, 1 main restaurant, as well as a variety of excursions, private dining experiences, and local culture. Our restaurant serves both regional and foreign cuisine.', 'published', 'Gaafari view inn Hotel Maldives | Maldives Guesthouses | MTG', 'Gaafaru View Inn is a three-star Guest House in the Maldives. The guest house provides guests with 7 air-conditioned rooms with private bathrooms and balconies, 1 main restaurant, as well as a variety of excursions, private dining experiences, and local culture. Our restaurant serves both regional and foreign cuisine.', '{"overview_paragraphs":["Gaafaru View Inn is a three-star Guest House in the Maldives. The guest house provides guests with 7 air-conditioned rooms with private bathrooms and balconies, 1 main restaurant, as well as a variety of excursions, private dining experiences, and local culture. Our restaurant serves both regional and foreign cuisine.","The Gaafaru View Inn is situated on one of the Maldives'' major lagoons. Gaafaru View inn Maldives, which is situated on a big lagoon with numerous snorkeling and diving areas, strives to give visitors a taste of the Maldives underwater beauty through a variety of organized trips to neighboring locations. Every day, turtles, manta rays, sharks, and dolphins can be spotted in these areas.","The Gaafaru Bikini Beach is only 2 minutes away from Gaafaru View Inn. Gaafaru View Inn attempts to deliver all you may want from a Maldives vacation at an inexpensive price, including white sand beaches, swaying palm trees, golden sunset views, and colorful corals and fish beneath the lagoon.","Gaafaru is one of Kaafu Atoll''s inhabited islands, as well as the lone island of the Gaafaru natural atoll. As the name suggests, Gaafaru refers to corals and Faru refers to reefs. On a nearby pristine island, see how the local Maldivians live. It''s a little fishing village in the Maldives. You will get a really private holiday experience, as it will not be overcrowded. The population of Gaafaru is estimated to be around 1500 people, with fishing being their primary source of income. As a result, the harbor is home to a variety of fishing boats ranging in size from 25 to 90 feet. The land area is estimated to be 17.2 hectares"]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'guesthouse', 3, 40, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'gaafari-view-inn-hotel-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'gaafari-view-inn-hotel-maldives'
  and l.node_type = 'location' and l.slug = 'gaafaru'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'gaafari-view-inn-hotel-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Room', 40, 'USD', null, null, 0
from nodes where node_type = 'accommodation' and slug = 'gaafari-view-inn-hotel-maldives'
on conflict (accommodation_id, name) do nothing;

-- island-break-fulidhoo
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'island-break-fulidhoo-maldives', 'Island Break Fulidhoo Maldives', 'OurHotel is located in vaavu atoll Fulidhoo. Located 1 hour away from the Male international airport.The hotel is owned and run by 3 three young enthusiastic brothers. The Hotel islocated at the east end of the island, Which give our guest maximum privacy from the locals.The hotel is featuredwith an onsite restaurant, our restaurant is set up to provide an expectational service and quality food to our clients. Where they got to eat daily fresh Catchor seafood platters and so on, Our hotel consists of 7 Rooms and also providing an expectational day out activities like, Swimming with dolphins, mantas, Snorkeling withturtle, Snorkeling with Nurse Sharks and other snorkeling points, Day out tosandbanks, Visiting Ship Wrack.', 'published', 'Island Break Fulidhoo Maldives | Maldives Guesthouses | MTG', 'OurHotel is located in vaavu atoll Fulidhoo. Located 1 hour away from the Male international airport.The hotel is owned and run by 3 three young enthusiastic brothers. The Hotel islocated at the east end of the island, Which give our guest maximum privacy from the locals.The hotel is featuredwith an onsite restaurant, our restaurant is set up to provide an expectational service and quality food to our clients. Where they got to eat daily fresh Catchor seafood platters and so on, Our hotel consists of 7 Rooms and also providing an expectational day out activities like, Swimming with dolphins, mantas, Snorkeling withturtle, Snorkeling with Nurse Sharks and other snorkeling points, Day out tosandbanks, Visiting Ship Wrack.', '{"overview_paragraphs":["OurHotel is located in vaavu atoll Fulidhoo. Located 1 hour away from the Male international airport.The hotel is owned and run by 3 three young enthusiastic brothers. The Hotel islocated at the east end of the island, Which give our guest maximum privacy from the locals.The hotel is featuredwith an onsite restaurant, our restaurant is set up to provide an expectational service and quality food to our clients. Where they got to eat daily fresh Catchor seafood platters and so on, Our hotel consists of 7 Rooms and also providing an expectational day out activities like, Swimming with dolphins, mantas, Snorkeling withturtle, Snorkeling with Nurse Sharks and other snorkeling points, Day out tosandbanks, Visiting Ship Wrack."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'guesthouse', null, 65, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'island-break-fulidhoo-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'island-break-fulidhoo-maldives'
  and l.node_type = 'location' and l.slug = 'fulidhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'island-break-fulidhoo-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Ground Room', 65, 'USD', 'Double', null, 0
from nodes where node_type = 'accommodation' and slug = 'island-break-fulidhoo-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Luxury Coconut Suit with Balcony', 75, 'USD', 'Double', null, 1
from nodes where node_type = 'accommodation' and slug = 'island-break-fulidhoo-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Luxury Coconut Suit Triple Room with Balcony', 85, 'USD', 'Triple', null, 2
from nodes where node_type = 'accommodation' and slug = 'island-break-fulidhoo-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Luxury Coconut Suit with Balcony Twin Room', 75, 'USD', 'Double', null, 3
from nodes where node_type = 'accommodation' and slug = 'island-break-fulidhoo-maldives'
on conflict (accommodation_id, name) do nothing;

-- maagiri
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'maagiri-hotel-male-maldives', 'Maagiri Hotel Male Maldives', 'The Maagiri Hotel is conveniently located across the street from the Hulhumale'' Ferry Terminal in the capital Male''. Maagiri offers a 4-star accommodation to compliment its excellent service, set against a scenic backdrop of the surrounding ocean and a few of the Maldives'' many islands.', 'published', 'Maagiri Hotel Male Maldives | Maldives Hotels | MTG', 'The Maagiri Hotel is conveniently located across the street from the Hulhumale'' Ferry Terminal in the capital Male''. Maagiri offers a 4-star accommodation to compliment its excellent service, set against a scenic backdrop of the surrounding ocean and a few of the Maldives'' many islands.', '{"overview_paragraphs":["The Maagiri Hotel is conveniently located across the street from the Hulhumale'' Ferry Terminal in the capital Male''. Maagiri offers a 4-star accommodation to compliment its excellent service, set against a scenic backdrop of the surrounding ocean and a few of the Maldives'' many islands.","Maagiri has four different types of rooms, each with elegant interiors, luxury amenities, and panoramic views of the Maldivian seas."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'hotel', 4, 220, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'maagiri-hotel-male-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'maagiri-hotel-male-maldives'
  and l.node_type = 'location' and l.slug = 'male'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'maagiri-hotel-male-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Premier Room', 220, 'USD', 'Double', null, 0
from nodes where node_type = 'accommodation' and slug = 'maagiri-hotel-male-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Junior Suit', 228, 'USD', null, null, 1
from nodes where node_type = 'accommodation' and slug = 'maagiri-hotel-male-maldives'
on conflict (accommodation_id, name) do nothing;

-- mantha-view-hotel
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'mantha-view-hotel-maldives', 'Mantha view Hotel Maldives', 'The Maldives'' Manta View Guest House is located in Vaavu, Keyodhoo. It includes five rooms, each with a double bed and a toilet. There are four rooms with air conditioning. We provide the following activities: Snorkeling with a professional guide [sandbanks and reefs] Snorkeling for half a day Fishing for the entire day Fishing in the morning Fishing at night Bivacco journey Trip to the Alimatha Resort', 'published', 'Mantha view Hotel Maldives | Maldives Guesthouses | MTG', 'The Maldives'' Manta View Guest House is located in Vaavu, Keyodhoo. It includes five rooms, each with a double bed and a toilet. There are four rooms with air conditioning. We provide the following activities: Snorkeling with a professional guide [sandbanks and reefs] Snorkeling for half a day Fishing for the entire day Fishing in the morning Fishing at night Bivacco journey Trip to the Alimatha Resort', '{"overview_paragraphs":["The Maldives'' Manta View Guest House is located in Vaavu, Keyodhoo. It includes five rooms, each with a double bed and a toilet. There are four rooms with air conditioning. We provide the following activities: Snorkeling with a professional guide [sandbanks and reefs] Snorkeling for half a day Fishing for the entire day Fishing in the morning Fishing at night Bivacco journey Trip to the Alimatha Resort","When visiting the Maldives Islands, Keyodhoo Manta View Guest House, which offers exceptional accommodation and excellent service, will make you feel right at home. Guests will have easy access to everything the vibrant city has to offer from here. The hotel''s ideal location allows guests to easily access the city''s must-see attractions. This Maldives Islands hotel offers an abundance of exceptional services and amenities. On-site amenities include 24-hour room service, daily housekeeping, portable wi-fi rental, luggage storage, and valet parking for hotel guests. During your visit, you will have access to high-quality room amenities.","Towels, air conditioning, wireless internet connection (fees apply), shower, and washing machine are available in some rooms to let guests unwind after a hard day. Top-notch recreational facilities such as snorkeling, private beach, and fishing will keep you amused whether you''re a fitness fanatic or simply searching for a way to unwind after a long day. Keyodhoo Manta View Guest House is a fantastic choice for your stay in the Maldives Islands, whatever your reason for visiting."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'guesthouse', null, 40, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'mantha-view-hotel-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'mantha-view-hotel-maldives'
  and l.node_type = 'location' and l.slug = 'keyodhoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'mantha-view-hotel-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Room', 40, 'USD', null, null, 0
from nodes where node_type = 'accommodation' and slug = 'mantha-view-hotel-maldives'
on conflict (accommodation_id, name) do nothing;

-- reveries-village
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'reveries-village', 'reveries-village', 'Reveries Diving Village proudly opened its doors as Laamu’s first guest house, in the heart of the atoll. The aim was to invite the world to experience the culture and beauty of Dhivehi island society at an affordable price. Our pioneering venture found its home on Gan, the longest island in the country, at the northern end of the Thundi village. From here, Reveries has gone from strength to strength, combining vibrant island culture and stunning natural environment with comfort and luxury for guests who wish to sample all the Maldives has to offer. A typical day with Reveries might take you from the comfort of your room, out past our private beach, snorkeling over the reef and diving down into the pristine lagoon. The next morning, you can let our guides take you on a tour of their island and relax in our rooftop spa before a candlelit dinner in our verdant garden. Reveries is a gateway to the precious underwater kingdom and best surfing experience. It’s your paradise.', 'published', 'reveries-village | Maldives Guesthouses | MTG', 'Reveries Diving Village proudly opened its doors as Laamu’s first guest house, in the heart of the atoll. The aim was to invite the world to experience the culture and beauty of Dhivehi island society at an affordable price. Our pioneering venture found its home on Gan, the longest island in the country, at the northern end of the Thundi village. From here, Reveries has gone from strength to strength, combining vibrant island culture and stunning natural environment with comfort and luxury for guests who wish to sample all the Maldives has to offer. A typical day with Reveries might take you from the comfort of your room, out past our private beach, snorkeling over the reef and diving down into the pristine lagoon. The next morning, you can let our guides take you on a tour of their island and relax in our rooftop spa before a candlelit dinner in our verdant garden. Reveries is a gateway to the precious underwater kingdom and best surfing experience. It’s your paradise.', '{"overview_paragraphs":["Reveries Diving Village proudly opened its doors as Laamu’s first guest house, in the heart of the atoll. The aim was to invite the world to experience the culture and beauty of Dhivehi island society at an affordable price. Our pioneering venture found its home on Gan, the longest island in the country, at the northern end of the Thundi village. From here, Reveries has gone from strength to strength, combining vibrant island culture and stunning natural environment with comfort and luxury for guests who wish to sample all the Maldives has to offer. A typical day with Reveries might take you from the comfort of your room, out past our private beach, snorkeling over the reef and diving down into the pristine lagoon. The next morning, you can let our guides take you on a tour of their island and relax in our rooftop spa before a candlelit dinner in our verdant garden. Reveries is a gateway to the precious underwater kingdom and best surfing experience. It’s your paradise."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'guesthouse', null, 65, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'reveries-village'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'reveries-village'
  and l.node_type = 'location' and l.slug = 'gan'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'reveries-village'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Room', 65, 'USD', 'King', 2, 0
from nodes where node_type = 'accommodation' and slug = 'reveries-village'
on conflict (accommodation_id, name) do nothing;

-- rosemery-maafushi
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'rosemery-maafushi', 'rosemery-maafushi', 'Rosemary Boutique is a boutique on the beautiful island of Maafushi that offers a variety of events and thrilling journeys for visitors. Maafushi island is 24 kilometers from the airport and is easily accessible all over the island.', 'published', 'rosemery-maafushi | Maldives Hotels | MTG', 'Rosemary Boutique is a boutique on the beautiful island of Maafushi that offers a variety of events and thrilling journeys for visitors. Maafushi island is 24 kilometers from the airport and is easily accessible all over the island.', '{"overview_paragraphs":["Rosemary Boutique is a boutique on the beautiful island of Maafushi that offers a variety of events and thrilling journeys for visitors. Maafushi island is 24 kilometers from the airport and is easily accessible all over the island.","There are a variety of rooms available, ranging from simple double rooms to suites with modern amenities. There are a total of 22 rooms available to accommodate all travel classes."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'hotel', null, 44, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'rosemery-maafushi'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'rosemery-maafushi'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'rosemery-maafushi'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Double Balcony Room', 44, 'USD', 'Double', null, 0
from nodes where node_type = 'accommodation' and slug = 'rosemery-maafushi'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Tripple Balcony Room', 52, 'USD', 'Maximum', null, 1
from nodes where node_type = 'accommodation' and slug = 'rosemery-maafushi'
on conflict (accommodation_id, name) do nothing;

-- surfview-male
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('accommodation', 'surfview-hotel-male-maldives', 'Surfview Hotel Male Maldives', 'The hotel has spectacular sea and city views and is located on the seafront with 11 signature rooms that offer comfort and connectivity. Surfview Raalhugandhu is centrally located in Male'' City, just a short walk from banks, parks, and souvenir shops.', 'published', 'Surfview Hotel Male Maldives | Maldives Guesthouses | MTG', 'The hotel has spectacular sea and city views and is located on the seafront with 11 signature rooms that offer comfort and connectivity. Surfview Raalhugandhu is centrally located in Male'' City, just a short walk from banks, parks, and souvenir shops.', '{"overview_paragraphs":["The hotel has spectacular sea and city views and is located on the seafront with 11 signature rooms that offer comfort and connectivity. Surfview Raalhugandhu is centrally located in Male'' City, just a short walk from banks, parks, and souvenir shops.","Surfview Raalhugandhu has 11 signature rooms that will provide guests with the best in service and comfort."]}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into accommodations (
  id, accommodation_type, star_rating, price_from, video_youtube_id, currency
)
select
  n.id, 'guesthouse', null, 64, null, 'USD'
from nodes n where n.node_type = 'accommodation' and n.slug = 'surfview-hotel-male-maldives'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'surfview-hotel-male-maldives'
  and l.node_type = 'location' and l.slug = 'male'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = 'surfview-hotel-male-maldives'
on conflict (id) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Superior Room', 64, 'USD', null, null, 0
from nodes where node_type = 'accommodation' and slug = 'surfview-hotel-male-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Sea View Room', 93, 'USD', null, null, 1
from nodes where node_type = 'accommodation' and slug = 'surfview-hotel-male-maldives'
on conflict (accommodation_id, name) do nothing;

-- Enriching already-seeded Task 5 accommodations with this round's
-- real price/video/room/overview data (same physical resorts — see
-- mergeIntoExistingSlug in merge-accommodation-research.mjs).
-- Baros-Island -> baros-maldives
update accommodations set
  price_from = coalesce(accommodations.price_from, 780),
  video_youtube_id = coalesce(accommodations.video_youtube_id, '9NssgRLiKF8')
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'baros-maldives';

update nodes set attributes = attributes || '{"overview_paragraphs":["Turquoise seas lap against white-sand beaches. Palm trees rustle in the breeze. Welcome to Baros, a lush island canopy natural paradise about 25 minutes by speedboat from the Maldives'' international airport. We''ve been greeting visitors since 1973, and we''ve spent decades polishing our services and developing our surroundings to create what we feel to be a renowned resort. Today, we''re one of the most popular Maldives resorts, and we can''t wait to show you what makes us so unique.","Unrivaled in its attention to detail, Baros creates really transformative experiences by putting the individual first, customising to their specific needs and expectations in a spirit of true generosity. Allow us to contact you in order to design your Maldives vacation.","The lavish furniture and unique artworks in this enormous property create a warm and welcome atmosphere. A private pool is bordered by tropical flowers in the garden courtyard, and a front balcony leads to your own length of Baros beach. Butler service is available 24 hours a day, seven days a week, ensuring that you have whatever you need, when you need it.","Turquoise seas lap against white-sand beaches. Palm trees rustle in the breeze. A beautiful island canopy in a natural wonderland within 25 minutes by speedboat from the Maldives'' international airport. We''ve been greeting visitors since 1973, and we''ve spent decades perfecting our services and nurturing our surroundings.","Take a supper cruise for two on a dhoni. Or, for a special gourmet supper, come to the Piano Deck with your own private chef. Alternatively, enjoy the sunset with cocktails and canapés at The Lighthouse. Every meal is yours to savour at these gourmet restaurants in Baros, and every mouthful is meant to inspire. For more than 40 years, we''ve been working to refine classic meals while experimenting with new techniques and ingredients from across the world. From opulent buffet breakfasts by the pool to exquisite dining at the famed Lighthouse, each meal is another chance to indulge in a favourite or try something new.","Serenity Spa, a haven of relaxation and a sanctuary nestled in the forest, welcomes you into a world of luxurious spa and beauty rituals. You can come here to unwind for a few hours or to create a personalised wellness journey with a series of daily treatments. From daily yoga classes to therapeutic massage, everything here is geared to help you regain your balance and find your peace. Request a yoga session anywhere on the island for something out of the usual, or get a soothing massage in the privacy of your comfy home."]}'::jsonb
where node_type = 'accommodation' and slug = 'baros-maldives' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Villa', 780, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'baros-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 1100, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'baros-maldives'
on conflict (accommodation_id, name) do nothing;

-- Gili-Lankanfushi -> gili-lankanfushi
update accommodations set
  price_from = coalesce(accommodations.price_from, 1600),
  video_youtube_id = coalesce(accommodations.video_youtube_id, 'Xx61PgIeXRA')
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'gili-lankanfushi';

update nodes set attributes = attributes || '{"overview_paragraphs":["With sustainably designed homes hanging above turquoise seas that reach as far as the eye can see, our exclusive island refuge provides peace by design. Spend your days doing anything you want—snorkeling, relaxing at the spa, sailing on a catamaran—and don''t be afraid to ask for help and guidance from our helpful staff. Nourish your body with locally produced products and worldwide cuisines, enjoy the sunset from your rustic-luxe villa, and fall asleep with the moon shining gloriously in the sky.","These 18 one-bedroom retreats are ideal for couples. Each apartment has an open-air living area, a huge bathroom, and a separate rooftop terrace from which to take in the vistas. Spend your days swimming and snorkelling in the coral gardens at the base of your sundeck, which has direct ocean access. At night, relax on catamaran nets while watching the sky.","Our five overwater Gili Lagoon Villas face west and provide breathtaking sunset views. The one-bedroom hideaways with thatched roofs are split across two storeys and include open-air living spaces, big bathrooms, and private rooftop terraces. Relax on the deck or swim out to your own own water hammock. You may pass by eagle rays, reef sharks, and shoals of luminous fish.","The Family Villa, perched at the end of our Western-facing jetty, is an open-air paradise with unrivalled views of the surrounding seascape. The main bedroom has an en-suite bathroom as well as an outdoor tub and shower. Two huge, air-conditioned living areas offer plenty of living (and sleeping) space. When you''re not napping off in the sun, take use of your own gym, steam room, or rooftop Jacuzzi. Alternatively, venture off the quiet Three Palm Island to relax in a magnificent cabana.","45 rustic-chic thatched villas float over the clear lagoon waters of Gili Lankanfushi in the Maldives. Many are linked to wooden jetties that extend from a little island, while others stand alone in the water. Simple, yet magnificent abodes (all created from sustainable materials) can serve as the ideal foundation for any modern-day Robinson Crusoe trip.","Gili Lankanfushi Maldives, perched above the Indian Ocean, offers exquisite accommodation near to the sun and water. Gili Lankanfushi Maldives is located on the private island of Lankanfushi in Male Atoll, a 20-minute speedboat journey from Male International Airport."]}'::jsonb
where node_type = 'accommodation' and slug = 'gili-lankanfushi' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Villa Suite', 1600, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'gili-lankanfushi'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Gili Lagoon Villa', 1800, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'gili-lankanfushi'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Family Villa', 4000, 'USD', 'King', 9, 2
from nodes where node_type = 'accommodation' and slug = 'gili-lankanfushi'
on conflict (accommodation_id, name) do nothing;

-- Kurumba -> kurumba-maldives
update accommodations set
  price_from = coalesce(accommodations.price_from, 300),
  video_youtube_id = coalesce(accommodations.video_youtube_id, '8ODifdytxy4')
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'kurumba-maldives';

update nodes set attributes = attributes || '{"overview_paragraphs":["Kurumba Maldives welcomes you. A Maldives island resort with more to offer than sun, sand, and water! A resort full of surprises, engaging activities, energetic entertainment, and friendly people that will make your Maldives vacation that much more memorable. Kurumba is appropriate for guests of all ages. We are glad to offer couples, honeymooners, friends, families, and small groups with a grin and a splash of Maldivian charm via our choice of entertainment, facilities, activities, and social events.","Accommodation that is both spacious and reasonably priced. Walk onto the beach, the water beneath your feet and Malé in the distance.","A huge pool villa with a large balcony. An open-plan area with views of the Maldives ocean on the east and seclusion and excellent lagoon on the west.","Kurumba Maldives provides classic modern style with character and thoughtful touches in 8 different room types.","Make every opportunity count. We are only a 10-minute speedboat trip from Velana International Airport (open 24 hours), so you may be on the beach with a beverage in hand within seconds of landing.","Veli Spa is a real Maldivian experience, set among beautiful grounds. While embracing contemporary therapies, our Spa is inspired by the tranquillity of the Maldives Islands, the balance of the waters, the vitality of the Maldivian indigenous people, and the healing powers of human touch."]}'::jsonb
where node_type = 'accommodation' and slug = 'kurumba-maldives' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Superior Room', 300, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'kurumba-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Pool Villa', 900, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'kurumba-maldives'
on conflict (accommodation_id, name) do nothing;

-- Six-Senses-Laamu -> six-senses-laamu
update accommodations set
  price_from = coalesce(accommodations.price_from, 1000),
  video_youtube_id = coalesce(accommodations.video_youtube_id, 'nR4SchedAl8')
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'six-senses-laamu';

update nodes set attributes = attributes || '{"overview_paragraphs":["Award-winning marine conservation effort located at Six Senses Laamu in conjunction with three partner NGOs: The Manta Trust, Blue Marine Foundation, and Olive Ridley Project, all of which collaborate to achieve research, guest education, and community outreach objectives. Is this your ideal palm-fringed paradise? It''s the sole resort in the secluded Laamu Atoll in the Maldives'' south, yet it''s only a short inter-island flight and boat ride away. On-land and over-water homes, dolphins playing in the warm sapphire waters, and restaurants offering delectable East-West cuisine combine to create an amazing, natural paradise.","These beach homes, hidden among the thick tropical flora overlooking the lagoon, feature a private pool and give complete seclusion surrounded by the turquoise lagoon waters. The pool is only a few metres from the beach, and sun loungers are strategically placed beside the pool deck for sun and shade. Feel the soothing sea wind streaming through the leaves while you bathe in the open-air branch-encircled shower or outdoor bathtub, or simply rest in the secluded garden area. Climb to your treetop terrace, which has a comfortable seating and dining space, for a unique panoramic view of Maldivian nature, sapphire ocean, and an incredible beautiful sunset.","A short bike ride on the aged timber jetties will take you to these overwater hideaways, which are surrounded by towering wooden walls. With direct access to the sea, you may go swimming or snorkelling around the lagoon, or simply rest on the overwater netted hammock. If you want to soak up some sun or watch the sunset over the lagoon, you may relax on the sun loungers or around the glass-bottom table on the outdoor deck. The water villas have an outdoor rain shower and a glass overwater bathtub with a view of the lagoon. You may obtain a unique panoramic view of the Indian Ocean, sapphire seascape, and an outstanding vivid tropical sunset here.","Six Senses Laamu''s beautifully built, air-conditioned villas have an outdoor bathroom with rain shower where guests may shower beneath the stars. Guests may enjoy the Maldivian sun from the luxury of their villas thanks to private day beds and sun loungers. The rooms include an electric kettle, slippers, and a dental kit.","The Six Senses Laamu is the sole resort in the Laamu Atoll, which is located in the Maldives'' south. Olhuveli Island is a 35-minute inter-island domestic flight from Male International Airport to Kadhdhoo, followed by a short motorboat journey.","Every day begins with a hearty breakfast with buffet and a la carte selections, as well as a daily changing live cooking station and fruit cut to order. Dinners are international themed events with a concentration on South Asia. There are also live cooking nights where chefs produce fresh meals from a range of different cuisines on the spot."]}'::jsonb
where node_type = 'accommodation' and slug = 'six-senses-laamu' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Beach Villa Pool', 1080, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'six-senses-laamu'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Lagoon Water Villa', 1000, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'six-senses-laamu'
on conflict (accommodation_id, name) do nothing;

-- Soneva-Fushi -> soneva-fushi
update accommodations set
  price_from = coalesce(accommodations.price_from, 2000),
  video_youtube_id = coalesce(accommodations.video_youtube_id, 'SPn2V6YP_eg')
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'soneva-fushi';

update nodes set attributes = attributes || '{"overview_paragraphs":["Soneva Fushi is a natural wonder located in the UNESCO Biosphere Reserve of Baa Atoll, one of the Maldives'' biggest islands. Sixty-four private island homes are tucked away in a lush expanse of lush vegetation. All have expansive living areas and views of the dawn or sunset, and most have their own pools in addition to being just steps from the beach. Our eight Water Retreats are among the largest of their kind in the world, boasting a terrace with a private pool and an ocean water slide. All Soneva Fushi villas have our personalised Barefoot Guardian service, which is available 24 hours a day, seven days a week.","Take a relaxing plunge in your private pool, which is protected by trees. If you wish to experience the pristine Maldivian ocean''s underwater delights, you''re only a few steps away. Relax among the whimsically rustic-chic apartments and balconies and succumb to the shipwrecked vibe.","Sunrise over the water has a mystical quality about it. With three two-story bungalows facing the ocean, there are infinite opportunities to enjoy the sunrise at this expansive seaside Retreat. Promenade the elevated walkway. Swim in the cool private pool. Bathe under the stars in the open-air garden bathrooms. Enjoy a leisurely lunch on the elevated dining pavilion, complemented by a cold beverage from the in-villa wine cooler.","The 1 Bedroom Water Retreat with Slide is positioned right over the pristine waters of the Indian Ocean and is accessible from the main island through a curving dock. The vast home has a light-filled, wide living space with a neighbouring pantry and minibar, as well as sleek and modest décor inspired by the sea.","Fifty-seven individual villas, each with its own length of beach, are tucked away among deep greenery and within touching distance of a magnificent coral reef. Our Soneva Fushi villas are located on the island''s sunset or dawn side. Despite the fact that there are little distinctions, both sides boast the Maldives'' characteristic white-sand beaches and crystal clear turquoise seas. Mr./Ms. Friday butlers deliver intuitive service.","Guests may fly directly to Soneva Fushi from Malé International Airport. Please keep in mind that the seaplane only operates throughout the day, with the latest trip departing at 17:00. Guests can also fly domestically to the neighbouring Dharavandhoo Airport, then take a 15-minute speedboat journey to the resorts. The final domestic flight departs at 23:15. Both flights last between 30 and 40 minutes. We recommend arriving by seaplane to get a bird''s eye perspective of the Maldives'' gorgeous islands."]}'::jsonb
where node_type = 'accommodation' and slug = 'soneva-fushi' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Crusoe Villa Pool', 2000, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'soneva-fushi'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Villa 41 Three Bedroom Pool Residence', 21700, 'USD', 'King', 9, 1
from nodes where node_type = 'accommodation' and slug = 'soneva-fushi'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, '1 Bedroom Water Retreat Slide', 5700, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'soneva-fushi'
on conflict (accommodation_id, name) do nothing;

-- Velassaru -> velassaru-maldives
update accommodations set
  price_from = coalesce(accommodations.price_from, 800),
  video_youtube_id = coalesce(accommodations.video_youtube_id, 'UBywDUXX3dA')
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'velassaru-maldives';

update nodes set attributes = attributes || '{"overview_paragraphs":["Crystal-clear oceans, soft white beaches. A picture-perfect lovely lagoon with breathtaking sunset views. Chic private hideaways dot the coastline. Five restaurants and two pubs serve exquisite flavours from all around the world. Explore our abundant coral reefs, sail beyond the horizon, or simply unwind on our idyllic Maldivian beaches.","Luxurious in a subtle way. Your Deluxe Villa is a haven unto itself, with easy access to a lovely white sandy beach:","Each Beach Villa with Pool is located on the beach and has direct access to the ocean. Each one has all you need for a comfortable stay:","Our 24 Water Villas are sophisticated over-water ocean villas with stunning lagoon views. Each one has all you need for a comfortable stay:","Contemporary-styled villas and bungalows offer stylish seclusion tucked away in gorgeous gardens, located along the seaside, or perched above water. Every villa in Velassaru Maldives has everything you need for a relaxing stay.","Velassaru Maldives is a 25-minute speedboat journey from Malé International Airport in South Malé Atoll. Our guest services crew will be at the airport to greet visitors and transport them to waiting speedboats."]}'::jsonb
where node_type = 'accommodation' and slug = 'velassaru-maldives' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Villa', 800, 'USD', 'King', 3, 0
from nodes where node_type = 'accommodation' and slug = 'velassaru-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Beach Pool Villa', 1050, 'USD', 'King', 3, 1
from nodes where node_type = 'accommodation' and slug = 'velassaru-maldives'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Water Villa', 1400, 'USD', 'King', 3, 2
from nodes where node_type = 'accommodation' and slug = 'velassaru-maldives'
on conflict (accommodation_id, name) do nothing;

-- arena-maafushi -> arena-beach-hotel
update accommodations set
  price_from = coalesce(accommodations.price_from, 59),
  video_youtube_id = coalesce(accommodations.video_youtube_id, null)
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'arena-beach-hotel';

update nodes set attributes = attributes || '{"overview_paragraphs":["The Arena Beach Hotel in Maafushi, Maldives, is located on the coast of the South Male Atoll. The island has a breathtaking view of the Indian Ocean and the turquoise lagoon. Let go of your worries and revel in the thrills that await you at every stop. Arena Beach Hotel offers the most accessible way to explore the real Maldives.","Seven Double Deluxe Rooms with balconies have views of the city with coconut trees swaying softly in the breeze, while nine Double Deluxe Rooms with balconies have views of the island''s stunning turquoise lagoon reaching out across the Indian Ocean. In addition, Arena Beach Hotel offers two Super Deluxe Sea View Rooms, which deliver just what the name implies."]}'::jsonb
where node_type = 'accommodation' and slug = 'arena-beach-hotel' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Standard Room', 59, 'USD', 'Double', null, 0
from nodes where node_type = 'accommodation' and slug = 'arena-beach-hotel'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Double Sea View Balcony Room', 89, 'USD', 'Double', null, 1
from nodes where node_type = 'accommodation' and slug = 'arena-beach-hotel'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Balcony Sea View Tripple Room', 112, 'USD', 'Double', null, 2
from nodes where node_type = 'accommodation' and slug = 'arena-beach-hotel'
on conflict (accommodation_id, name) do nothing;

-- kaanibeach-maafushi -> kaani-beach-hotel
update accommodations set
  price_from = coalesce(accommodations.price_from, 71),
  video_youtube_id = coalesce(accommodations.video_youtube_id, null)
from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = 'kaani-beach-hotel';

update nodes set attributes = attributes || '{"overview_paragraphs":["On Maafushi Island, a sunny beach getaway surrounded by coconut palm trees, the 3-star Kaani Beach Hotel is located. On-site activities include scuba diving, island picnics, dolphin viewing, and snorkeling. Kaani Beach Hotel is the ideal choice for anyone looking for a romantic getaway or something a little more laid-back.","Sea View rooms with private balconies are available at Kaani Beach Hotel, a sunny beach getaway surrounded by coconut palm trees. All of the rooms have air conditioning, a hot water shower, satellite television, wireless Internet, a mini bar, a hair dryer, and a safe. There is also a restaurant offering buffet breakfast and dinner, as well as a rooftop open-air terrace with loungers."]}'::jsonb
where node_type = 'accommodation' and slug = 'kaani-beach-hotel' and not (attributes ? 'overview_paragraphs');

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Deluxe Sea View Balcony Room', 71, 'USD', 'Double', null, 0
from nodes where node_type = 'accommodation' and slug = 'kaani-beach-hotel'
on conflict (accommodation_id, name) do nothing;

insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)
select id, 'Tripple Sea View Balcony Room', 84, 'USD', 'Tripple', null, 1
from nodes where node_type = 'accommodation' and slug = 'kaani-beach-hotel'
on conflict (accommodation_id, name) do nothing;

