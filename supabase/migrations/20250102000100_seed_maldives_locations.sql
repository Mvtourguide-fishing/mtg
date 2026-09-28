-- MTG: Maldives geographic hierarchy seed (Task 4).
-- GENERATED FILE — do not hand-edit. Source of truth:
--   data/maldives/locations/atolls.json
--   data/maldives/locations/islands.json
--   data/maldives/locations/SOURCES.md
-- Regenerate with: node scripts/generate-location-seed.mjs
--
-- Idempotent: every insert is keyed by (node_type, slug) with
-- ON CONFLICT DO NOTHING, so re-applying this migration after the
-- source data hasn't changed is a no-op. Hierarchy validation and
-- ltree path computation are handled entirely by the triggers from
-- 20250101001300_functions_triggers.sql — this file does not bypass them.

-- Country
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maldives', 'Maldives', 'The Maldives is an island nation in the Indian Ocean, organized into 20 administrative atolls plus the capital, Malé City.', 'published', 'Maldives Travel Guide | MTG', 'The Maldives is an island nation in the Indian Ocean, organized into 20 administrative atolls plus the capital, Malé City.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select id, 'country', null, 'maldives'::ltree from nodes where node_type = 'location' and slug = 'maldives'
on conflict (id) do nothing;

-- Atolls
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'haa-alif', 'Haa Alif Atoll', 'Haa Alif Atoll is one of the Maldives'' administrative atolls (code HA), comprising 14 inhabited islands. Its administrative capital is Dhidhdhoo.', 'published', 'Haa Alif Atoll | Maldives Atolls | MTG', 'Haa Alif Atoll is one of the Maldives'' administrative atolls (code HA), comprising 14 inhabited islands. Its administrative capital is Dhidhdhoo.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'haa_alif'::ltree), 'HA'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'haa-alif'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'haa-dhaalu', 'Haa Dhaalu Atoll', 'Haa Dhaalu Atoll is one of the Maldives'' administrative atolls (code HDh), comprising 14 inhabited islands. Its administrative capital is Kulhudhuffushi.', 'published', 'Haa Dhaalu Atoll | Maldives Atolls | MTG', 'Haa Dhaalu Atoll is one of the Maldives'' administrative atolls (code HDh), comprising 14 inhabited islands. Its administrative capital is Kulhudhuffushi.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'haa_dhaalu'::ltree), 'HDh'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'haa-dhaalu'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'shaviyani', 'Shaviyani Atoll', 'Shaviyani Atoll is one of the Maldives'' administrative atolls (code Sh), comprising 14 inhabited islands. Its administrative capital is Funadhoo.', 'published', 'Shaviyani Atoll | Maldives Atolls | MTG', 'Shaviyani Atoll is one of the Maldives'' administrative atolls (code Sh), comprising 14 inhabited islands. Its administrative capital is Funadhoo.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'shaviyani'::ltree), 'Sh'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'shaviyani'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'noonu', 'Noonu Atoll', 'Noonu Atoll is one of the Maldives'' administrative atolls (code N), comprising 13 inhabited islands. Its administrative capital is Manadhoo.', 'published', 'Noonu Atoll | Maldives Atolls | MTG', 'Noonu Atoll is one of the Maldives'' administrative atolls (code N), comprising 13 inhabited islands. Its administrative capital is Manadhoo.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'noonu'::ltree), 'N'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'noonu'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'raa', 'Raa Atoll', 'Raa Atoll is one of the Maldives'' administrative atolls (code R), comprising 16 inhabited islands. Its administrative capital is Ungoofaaru.', 'published', 'Raa Atoll | Maldives Atolls | MTG', 'Raa Atoll is one of the Maldives'' administrative atolls (code R), comprising 16 inhabited islands. Its administrative capital is Ungoofaaru.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'raa'::ltree), 'R'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'raa'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'baa', 'Baa Atoll', 'Baa Atoll is one of the Maldives'' administrative atolls (code B), comprising 13 inhabited islands. Its administrative capital is Eydhafushi.', 'published', 'Baa Atoll | Maldives Atolls | MTG', 'Baa Atoll is one of the Maldives'' administrative atolls (code B), comprising 13 inhabited islands. Its administrative capital is Eydhafushi.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'baa'::ltree), 'B'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'baa'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'lhaviyani', 'Lhaviyani Atoll', 'Lhaviyani Atoll is one of the Maldives'' administrative atolls (code Lh), comprising 4 inhabited islands. Its administrative capital is Naifaru.', 'published', 'Lhaviyani Atoll | Maldives Atolls | MTG', 'Lhaviyani Atoll is one of the Maldives'' administrative atolls (code Lh), comprising 4 inhabited islands. Its administrative capital is Naifaru.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'lhaviyani'::ltree), 'Lh'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'lhaviyani'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kaafu', 'Kaafu Atoll', 'Kaafu Atoll is one of the Maldives'' administrative atolls (code K), comprising 9 inhabited islands. Its administrative capital is Thulusdhoo.', 'published', 'Kaafu Atoll | Maldives Atolls | MTG', 'Kaafu Atoll is one of the Maldives'' administrative atolls (code K), comprising 9 inhabited islands. Its administrative capital is Thulusdhoo.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'kaafu'::ltree), 'K'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'kaafu'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'alif-alif', 'Alif Alif Atoll', 'Alif Alif Atoll is one of the Maldives'' administrative atolls (code AA), comprising 8 inhabited islands. Its administrative capital is Rasdhoo.', 'published', 'Alif Alif Atoll | Maldives Atolls | MTG', 'Alif Alif Atoll is one of the Maldives'' administrative atolls (code AA), comprising 8 inhabited islands. Its administrative capital is Rasdhoo.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'alif_alif'::ltree), 'AA'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'alif-alif'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'alif-dhaalu', 'Alif Dhaalu Atoll', 'Alif Dhaalu Atoll is one of the Maldives'' administrative atolls (code ADh), comprising 10 inhabited islands. Its administrative capital is Mahibadhoo.', 'published', 'Alif Dhaalu Atoll | Maldives Atolls | MTG', 'Alif Dhaalu Atoll is one of the Maldives'' administrative atolls (code ADh), comprising 10 inhabited islands. Its administrative capital is Mahibadhoo.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'alif_dhaalu'::ltree), 'ADh'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'alif-dhaalu'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'vaavu', 'Vaavu Atoll', 'Vaavu Atoll is one of the Maldives'' administrative atolls (code V), comprising 5 inhabited islands. Its administrative capital is Felidhoo.', 'published', 'Vaavu Atoll | Maldives Atolls | MTG', 'Vaavu Atoll is one of the Maldives'' administrative atolls (code V), comprising 5 inhabited islands. Its administrative capital is Felidhoo.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'vaavu'::ltree), 'V'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'vaavu'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'meemu', 'Meemu Atoll', 'Meemu Atoll is one of the Maldives'' administrative atolls (code M), comprising 8 inhabited islands. Its administrative capital is Muli.', 'published', 'Meemu Atoll | Maldives Atolls | MTG', 'Meemu Atoll is one of the Maldives'' administrative atolls (code M), comprising 8 inhabited islands. Its administrative capital is Muli.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'meemu'::ltree), 'M'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'meemu'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'faafu', 'Faafu Atoll', 'Faafu Atoll is one of the Maldives'' administrative atolls (code F), comprising 5 inhabited islands. Its administrative capital is Nilandhoo.', 'published', 'Faafu Atoll | Maldives Atolls | MTG', 'Faafu Atoll is one of the Maldives'' administrative atolls (code F), comprising 5 inhabited islands. Its administrative capital is Nilandhoo.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'faafu'::ltree), 'F'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'faafu'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dhaalu', 'Dhaalu Atoll', 'Dhaalu Atoll is one of the Maldives'' administrative atolls (code Dh), comprising 6 inhabited islands. Its administrative capital is Kudahuvadhoo.', 'published', 'Dhaalu Atoll | Maldives Atolls | MTG', 'Dhaalu Atoll is one of the Maldives'' administrative atolls (code Dh), comprising 6 inhabited islands. Its administrative capital is Kudahuvadhoo.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'dhaalu'::ltree), 'Dh'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'dhaalu'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'thaa', 'Thaa Atoll', 'Thaa Atoll is one of the Maldives'' administrative atolls (code Th), comprising 13 inhabited islands. Its administrative capital is Veymandoo.', 'published', 'Thaa Atoll | Maldives Atolls | MTG', 'Thaa Atoll is one of the Maldives'' administrative atolls (code Th), comprising 13 inhabited islands. Its administrative capital is Veymandoo.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'thaa'::ltree), 'Th'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'thaa'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'laamu', 'Laamu Atoll', 'Laamu Atoll is one of the Maldives'' administrative atolls (code L), comprising 12 inhabited islands. Its administrative capital is Fonadhoo.', 'published', 'Laamu Atoll | Maldives Atolls | MTG', 'Laamu Atoll is one of the Maldives'' administrative atolls (code L), comprising 12 inhabited islands. Its administrative capital is Fonadhoo.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'laamu'::ltree), 'L'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'laamu'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'gaafu-alifu', 'Gaafu Alifu Atoll', 'Gaafu Alifu Atoll is one of the Maldives'' administrative atolls (code GA), comprising 10 inhabited islands. Its administrative capital is Vilingili.', 'published', 'Gaafu Alifu Atoll | Maldives Atolls | MTG', 'Gaafu Alifu Atoll is one of the Maldives'' administrative atolls (code GA), comprising 10 inhabited islands. Its administrative capital is Vilingili.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'gaafu_alifu'::ltree), 'GA'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'gaafu-alifu'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'gaafu-dhaalu', 'Gaafu Dhaalu Atoll', 'Gaafu Dhaalu Atoll is one of the Maldives'' administrative atolls (code GDh), comprising 9 inhabited islands. Its administrative capital is Thinadhoo.', 'published', 'Gaafu Dhaalu Atoll | Maldives Atolls | MTG', 'Gaafu Dhaalu Atoll is one of the Maldives'' administrative atolls (code GDh), comprising 9 inhabited islands. Its administrative capital is Thinadhoo.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'gaafu_dhaalu'::ltree), 'GDh'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'gaafu-dhaalu'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'gnaviyani', 'Gnaviyani Atoll', 'Gnaviyani Atoll is one of the Maldives'' administrative atolls (code Gn), comprising 1 inhabited island. Its administrative capital is Fuvahmulah.', 'published', 'Gnaviyani Atoll | Maldives Atolls | MTG', 'Gnaviyani Atoll is one of the Maldives'' administrative atolls (code Gn), comprising 1 inhabited island. Its administrative capital is Fuvahmulah.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'gnaviyani'::ltree), 'Gn'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'gnaviyani'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'seenu', 'Seenu Atoll', 'Seenu Atoll is one of the Maldives'' administrative atolls (code S), comprising 6 inhabited islands. Its administrative capital is Hithadhoo.', 'published', 'Seenu Atoll | Maldives Atolls | MTG', 'Seenu Atoll is one of the Maldives'' administrative atolls (code S), comprising 6 inhabited islands. Its administrative capital is Hithadhoo.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'seenu'::ltree), 'S'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'seenu'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'male-city', 'Malé City', 'Malé City is one of the Maldives'' administrative atolls (code MLE), comprising 3 inhabited islands. Its administrative capital is Malé.', 'published', 'Malé City | Maldives Atolls | MTG', 'Malé City is one of the Maldives'' administrative atolls (code MLE), comprising 3 inhabited islands. Its administrative capital is Malé.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, administrative_code)
select n.id, 'atoll', c.id, (c_loc.path || 'male_city'::ltree), 'MLE'
from nodes n, nodes c join locations c_loc on c_loc.id = c.id
where n.node_type = 'location' and n.slug = 'male-city'
  and c.node_type = 'location' and c.slug = 'maldives'
on conflict (id) do nothing;

-- Inhabited islands
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'baarah', 'Baarah', 'Baarah is an inhabited island in Haa Alif Atoll, Maldives.', 'published', 'Baarah, Haa Alif Atoll | Maldives Islands | MTG', 'Baarah is an inhabited island in Haa Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'baarah'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'baarah'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dhidhdhoo', 'Dhidhdhoo', 'Dhidhdhoo is an inhabited island in Haa Alif Atoll, Maldives.', 'published', 'Dhidhdhoo, Haa Alif Atoll | Maldives Islands | MTG', 'Dhidhdhoo is an inhabited island in Haa Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhidhdhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhidhdhoo'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'filladhoo', 'Filladhoo', 'Filladhoo is an inhabited island in Haa Alif Atoll, Maldives.', 'published', 'Filladhoo, Haa Alif Atoll | Maldives Islands | MTG', 'Filladhoo is an inhabited island in Haa Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'filladhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'filladhoo'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'hoarafushi', 'Hoarafushi', 'Hoarafushi is an inhabited island in Haa Alif Atoll, Maldives.', 'published', 'Hoarafushi, Haa Alif Atoll | Maldives Islands | MTG', 'Hoarafushi is an inhabited island in Haa Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hoarafushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hoarafushi'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'ihavandhoo', 'Ihavandhoo', 'Ihavandhoo is an inhabited island in Haa Alif Atoll, Maldives.', 'published', 'Ihavandhoo, Haa Alif Atoll | Maldives Islands | MTG', 'Ihavandhoo is an inhabited island in Haa Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'ihavandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'ihavandhoo'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kelaa', 'Kelaa', 'Kelaa is an inhabited island in Haa Alif Atoll, Maldives.', 'published', 'Kelaa, Haa Alif Atoll | Maldives Islands | MTG', 'Kelaa is an inhabited island in Haa Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kelaa'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kelaa'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maarandhoo', 'Maarandhoo', 'Maarandhoo is an inhabited island in Haa Alif Atoll, Maldives.', 'published', 'Maarandhoo, Haa Alif Atoll | Maldives Islands | MTG', 'Maarandhoo is an inhabited island in Haa Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maarandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maarandhoo'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'mulhadhoo', 'Mulhadhoo', 'Mulhadhoo is an inhabited island in Haa Alif Atoll, Maldives.', 'published', 'Mulhadhoo, Haa Alif Atoll | Maldives Islands | MTG', 'Mulhadhoo is an inhabited island in Haa Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'mulhadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'mulhadhoo'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'muraidhoo', 'Muraidhoo', 'Muraidhoo is an inhabited island in Haa Alif Atoll, Maldives.', 'published', 'Muraidhoo, Haa Alif Atoll | Maldives Islands | MTG', 'Muraidhoo is an inhabited island in Haa Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'muraidhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'muraidhoo'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'thakandhoo', 'Thakandhoo', 'Thakandhoo is an inhabited island in Haa Alif Atoll, Maldives.', 'published', 'Thakandhoo, Haa Alif Atoll | Maldives Islands | MTG', 'Thakandhoo is an inhabited island in Haa Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'thakandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'thakandhoo'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'thuraakunu', 'Thuraakunu', 'Thuraakunu is an inhabited island in Haa Alif Atoll, Maldives.', 'published', 'Thuraakunu, Haa Alif Atoll | Maldives Islands | MTG', 'Thuraakunu is an inhabited island in Haa Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'thuraakunu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'thuraakunu'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'uligamu', 'Uligamu', 'Uligamu is an inhabited island in Haa Alif Atoll, Maldives.', 'published', 'Uligamu, Haa Alif Atoll | Maldives Islands | MTG', 'Uligamu is an inhabited island in Haa Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'uligamu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'uligamu'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'utheemu', 'Utheemu', 'Utheemu is an inhabited island in Haa Alif Atoll, Maldives.', 'published', 'Utheemu, Haa Alif Atoll | Maldives Islands | MTG', 'Utheemu is an inhabited island in Haa Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'utheemu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'utheemu'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'vashafaru', 'Vashafaru', 'Vashafaru is an inhabited island in Haa Alif Atoll, Maldives.', 'published', 'Vashafaru, Haa Alif Atoll | Maldives Islands | MTG', 'Vashafaru is an inhabited island in Haa Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vashafaru'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vashafaru'
  and p.node_type = 'location' and p.slug = 'haa-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'finey', 'Finey', 'Finey is an inhabited island in Haa Dhaalu Atoll, Maldives.', 'published', 'Finey, Haa Dhaalu Atoll | Maldives Islands | MTG', 'Finey is an inhabited island in Haa Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'finey'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'finey'
  and p.node_type = 'location' and p.slug = 'haa-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'hanimaadhoo', 'Hanimaadhoo', 'Hanimaadhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', 'published', 'Hanimaadhoo, Haa Dhaalu Atoll | Maldives Islands | MTG', 'Hanimaadhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hanimaadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hanimaadhoo'
  and p.node_type = 'location' and p.slug = 'haa-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'hirimaradhoo', 'Hirimaradhoo', 'Hirimaradhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', 'published', 'Hirimaradhoo, Haa Dhaalu Atoll | Maldives Islands | MTG', 'Hirimaradhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hirimaradhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hirimaradhoo'
  and p.node_type = 'location' and p.slug = 'haa-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kulhudhuffushi', 'Kulhudhuffushi', 'Kulhudhuffushi is an inhabited island in Haa Dhaalu Atoll, Maldives.', 'published', 'Kulhudhuffushi, Haa Dhaalu Atoll | Maldives Islands | MTG', 'Kulhudhuffushi is an inhabited island in Haa Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kulhudhuffushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kulhudhuffushi'
  and p.node_type = 'location' and p.slug = 'haa-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kumundhoo', 'Kumundhoo', 'Kumundhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', 'published', 'Kumundhoo, Haa Dhaalu Atoll | Maldives Islands | MTG', 'Kumundhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kumundhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kumundhoo'
  and p.node_type = 'location' and p.slug = 'haa-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kunburudhoo', 'Kunburudhoo', 'Kunburudhoo is an island in Haa Dhaalu Atoll, Maldives, no longer inhabited after its community relocated.', 'published', 'Kunburudhoo, Haa Dhaalu Atoll | Maldives Islands | MTG', 'Kunburudhoo is an island in Haa Dhaalu Atoll, Maldives, no longer inhabited after its community relocated.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kunburudhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kunburudhoo'
  and p.node_type = 'location' and p.slug = 'haa-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kurinbi', 'Kurinbi', 'Kurinbi is an inhabited island in Haa Dhaalu Atoll, Maldives.', 'published', 'Kurinbi, Haa Dhaalu Atoll | Maldives Islands | MTG', 'Kurinbi is an inhabited island in Haa Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kurinbi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kurinbi'
  and p.node_type = 'location' and p.slug = 'haa-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'makunudhoo', 'Makunudhoo', 'Makunudhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', 'published', 'Makunudhoo, Haa Dhaalu Atoll | Maldives Islands | MTG', 'Makunudhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'makunudhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'makunudhoo'
  and p.node_type = 'location' and p.slug = 'haa-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'naivaadhoo', 'Naivaadhoo', 'Naivaadhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', 'published', 'Naivaadhoo, Haa Dhaalu Atoll | Maldives Islands | MTG', 'Naivaadhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'naivaadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'naivaadhoo'
  and p.node_type = 'location' and p.slug = 'haa-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'nellaidhoo', 'Nellaidhoo', 'Nellaidhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', 'published', 'Nellaidhoo, Haa Dhaalu Atoll | Maldives Islands | MTG', 'Nellaidhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'nellaidhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'nellaidhoo'
  and p.node_type = 'location' and p.slug = 'haa-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'neykurendhoo', 'Neykurendhoo', 'Neykurendhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', 'published', 'Neykurendhoo, Haa Dhaalu Atoll | Maldives Islands | MTG', 'Neykurendhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'neykurendhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'neykurendhoo'
  and p.node_type = 'location' and p.slug = 'haa-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'nolhivaram', 'Nolhivaram', 'Nolhivaram is an inhabited island in Haa Dhaalu Atoll, Maldives.', 'published', 'Nolhivaram, Haa Dhaalu Atoll | Maldives Islands | MTG', 'Nolhivaram is an inhabited island in Haa Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'nolhivaram'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'nolhivaram'
  and p.node_type = 'location' and p.slug = 'haa-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'nolhivaranfaru', 'Nolhivaranfaru', 'Nolhivaranfaru is an inhabited island in Haa Dhaalu Atoll, Maldives.', 'published', 'Nolhivaranfaru, Haa Dhaalu Atoll | Maldives Islands | MTG', 'Nolhivaranfaru is an inhabited island in Haa Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'nolhivaranfaru'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'nolhivaranfaru'
  and p.node_type = 'location' and p.slug = 'haa-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'vaikaradhoo', 'Vaikaradhoo', 'Vaikaradhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', 'published', 'Vaikaradhoo, Haa Dhaalu Atoll | Maldives Islands | MTG', 'Vaikaradhoo is an inhabited island in Haa Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vaikaradhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vaikaradhoo'
  and p.node_type = 'location' and p.slug = 'haa-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'bileffahi', 'Bileffahi', 'Bileffahi is an inhabited island in Shaviyani Atoll, Maldives.', 'published', 'Bileffahi, Shaviyani Atoll | Maldives Islands | MTG', 'Bileffahi is an inhabited island in Shaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'bileffahi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'bileffahi'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'feevah', 'Feevah', 'Feevah is an inhabited island in Shaviyani Atoll, Maldives.', 'published', 'Feevah, Shaviyani Atoll | Maldives Islands | MTG', 'Feevah is an inhabited island in Shaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'feevah'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'feevah'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'feydhoo', 'Feydhoo', 'Feydhoo is an inhabited island in Shaviyani Atoll, Maldives.', 'published', 'Feydhoo, Shaviyani Atoll | Maldives Islands | MTG', 'Feydhoo is an inhabited island in Shaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'feydhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'feydhoo'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'foakaidhoo', 'Foakaidhoo', 'Foakaidhoo is an inhabited island in Shaviyani Atoll, Maldives.', 'published', 'Foakaidhoo, Shaviyani Atoll | Maldives Islands | MTG', 'Foakaidhoo is an inhabited island in Shaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'foakaidhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'foakaidhoo'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'funadhoo', 'Funadhoo', 'Funadhoo is an inhabited island in Shaviyani Atoll, Maldives.', 'published', 'Funadhoo, Shaviyani Atoll | Maldives Islands | MTG', 'Funadhoo is an inhabited island in Shaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'funadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'funadhoo'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'goidhoo', 'Goidhoo', 'Goidhoo is an inhabited island in Shaviyani Atoll, Maldives.', 'published', 'Goidhoo, Shaviyani Atoll | Maldives Islands | MTG', 'Goidhoo is an inhabited island in Shaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'goidhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'goidhoo'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kanditheemu', 'Kanditheemu', 'Kanditheemu is an inhabited island in Shaviyani Atoll, Maldives.', 'published', 'Kanditheemu, Shaviyani Atoll | Maldives Islands | MTG', 'Kanditheemu is an inhabited island in Shaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kanditheemu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kanditheemu'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'komandoo', 'Komandoo', 'Komandoo is an inhabited island in Shaviyani Atoll, Maldives.', 'published', 'Komandoo, Shaviyani Atoll | Maldives Islands | MTG', 'Komandoo is an inhabited island in Shaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'komandoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'komandoo'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'lhaimagu', 'Lhaimagu', 'Lhaimagu is an inhabited island in Shaviyani Atoll, Maldives.', 'published', 'Lhaimagu, Shaviyani Atoll | Maldives Islands | MTG', 'Lhaimagu is an inhabited island in Shaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'lhaimagu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'lhaimagu'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maaungoodhoo', 'Maaungoodhoo', 'Maaungoodhoo is an inhabited island in Shaviyani Atoll, Maldives.', 'published', 'Maaungoodhoo, Shaviyani Atoll | Maldives Islands | MTG', 'Maaungoodhoo is an inhabited island in Shaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maaungoodhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maaungoodhoo'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maroshi', 'Maroshi', 'Maroshi is an inhabited island in Shaviyani Atoll, Maldives.', 'published', 'Maroshi, Shaviyani Atoll | Maldives Islands | MTG', 'Maroshi is an inhabited island in Shaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maroshi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maroshi'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'milandhoo', 'Milandhoo', 'Milandhoo is an inhabited island in Shaviyani Atoll, Maldives.', 'published', 'Milandhoo, Shaviyani Atoll | Maldives Islands | MTG', 'Milandhoo is an inhabited island in Shaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'milandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'milandhoo'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'narudhoo', 'Narudhoo', 'Narudhoo is an inhabited island in Shaviyani Atoll, Maldives.', 'published', 'Narudhoo, Shaviyani Atoll | Maldives Islands | MTG', 'Narudhoo is an inhabited island in Shaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'narudhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'narudhoo'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'noomaraa', 'Noomaraa', 'Noomaraa is an inhabited island in Shaviyani Atoll, Maldives.', 'published', 'Noomaraa, Shaviyani Atoll | Maldives Islands | MTG', 'Noomaraa is an inhabited island in Shaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'noomaraa'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'noomaraa'
  and p.node_type = 'location' and p.slug = 'shaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'foddhoo', 'Foddhoo', 'Foddhoo is an inhabited island in Noonu Atoll, Maldives.', 'published', 'Foddhoo, Noonu Atoll | Maldives Islands | MTG', 'Foddhoo is an inhabited island in Noonu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'foddhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'foddhoo'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'henbandhoo', 'Henbandhoo', 'Henbandhoo is an inhabited island in Noonu Atoll, Maldives.', 'published', 'Henbandhoo, Noonu Atoll | Maldives Islands | MTG', 'Henbandhoo is an inhabited island in Noonu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'henbandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'henbandhoo'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'holhudhoo', 'Holhudhoo', 'Holhudhoo is an inhabited island in Noonu Atoll, Maldives.', 'published', 'Holhudhoo, Noonu Atoll | Maldives Islands | MTG', 'Holhudhoo is an inhabited island in Noonu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'holhudhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'holhudhoo'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kendhikolhudhoo', 'Kendhikolhudhoo', 'Kendhikolhudhoo is an inhabited island in Noonu Atoll, Maldives.', 'published', 'Kendhikolhudhoo, Noonu Atoll | Maldives Islands | MTG', 'Kendhikolhudhoo is an inhabited island in Noonu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kendhikolhudhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kendhikolhudhoo'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kudafaree', 'Kudafaree', 'Kudafaree is an inhabited island in Noonu Atoll, Maldives.', 'published', 'Kudafaree, Noonu Atoll | Maldives Islands | MTG', 'Kudafaree is an inhabited island in Noonu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kudafaree'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kudafaree'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'landhoo', 'Landhoo', 'Landhoo is an inhabited island in Noonu Atoll, Maldives.', 'published', 'Landhoo, Noonu Atoll | Maldives Islands | MTG', 'Landhoo is an inhabited island in Noonu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'landhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'landhoo'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'lhohi', 'Lhohi', 'Lhohi is an inhabited island in Noonu Atoll, Maldives.', 'published', 'Lhohi, Noonu Atoll | Maldives Islands | MTG', 'Lhohi is an inhabited island in Noonu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'lhohi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'lhohi'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maafaru', 'Maafaru', 'Maafaru is an inhabited island in Noonu Atoll, Maldives.', 'published', 'Maafaru, Noonu Atoll | Maldives Islands | MTG', 'Maafaru is an inhabited island in Noonu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maafaru'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maafaru'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maalhendhoo', 'Maalhendhoo', 'Maalhendhoo is an inhabited island in Noonu Atoll, Maldives.', 'published', 'Maalhendhoo, Noonu Atoll | Maldives Islands | MTG', 'Maalhendhoo is an inhabited island in Noonu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maalhendhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maalhendhoo'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'magoodhoo', 'Magoodhoo', 'Magoodhoo is an inhabited island in Noonu Atoll, Maldives.', 'published', 'Magoodhoo, Noonu Atoll | Maldives Islands | MTG', 'Magoodhoo is an inhabited island in Noonu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'magoodhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'magoodhoo'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'manadhoo', 'Manadhoo', 'Manadhoo is an inhabited island in Noonu Atoll, Maldives.', 'published', 'Manadhoo, Noonu Atoll | Maldives Islands | MTG', 'Manadhoo is an inhabited island in Noonu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'manadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'manadhoo'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'miladhoo', 'Miladhoo', 'Miladhoo is an inhabited island in Noonu Atoll, Maldives.', 'published', 'Miladhoo, Noonu Atoll | Maldives Islands | MTG', 'Miladhoo is an inhabited island in Noonu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'miladhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'miladhoo'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'velidhoo', 'Velidhoo', 'Velidhoo is an inhabited island in Noonu Atoll, Maldives.', 'published', 'Velidhoo, Noonu Atoll | Maldives Islands | MTG', 'Velidhoo is an inhabited island in Noonu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'velidhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'velidhoo'
  and p.node_type = 'location' and p.slug = 'noonu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'alifushi', 'Alifushi', 'Alifushi is an inhabited island in Raa Atoll, Maldives.', 'published', 'Alifushi, Raa Atoll | Maldives Islands | MTG', 'Alifushi is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'alifushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'alifushi'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'angolhitheemu', 'Angolhitheemu', 'Angolhitheemu is an inhabited island in Raa Atoll, Maldives.', 'published', 'Angolhitheemu, Raa Atoll | Maldives Islands | MTG', 'Angolhitheemu is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'angolhitheemu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'angolhitheemu'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dhuvaafaru', 'Dhuvaafaru', 'Dhuvaafaru is an inhabited island in Raa Atoll, Maldives.', 'published', 'Dhuvaafaru, Raa Atoll | Maldives Islands | MTG', 'Dhuvaafaru is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhuvaafaru'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhuvaafaru'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'fainu', 'Fainu', 'Fainu is an inhabited island in Raa Atoll, Maldives.', 'published', 'Fainu, Raa Atoll | Maldives Islands | MTG', 'Fainu is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fainu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fainu'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'hulhudhuffaaru', 'Hulhudhuffaaru', 'Hulhudhuffaaru is an inhabited island in Raa Atoll, Maldives.', 'published', 'Hulhudhuffaaru, Raa Atoll | Maldives Islands | MTG', 'Hulhudhuffaaru is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hulhudhuffaaru'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hulhudhuffaaru'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'inguraidhoo', 'Inguraidhoo', 'Inguraidhoo is an inhabited island in Raa Atoll, Maldives.', 'published', 'Inguraidhoo, Raa Atoll | Maldives Islands | MTG', 'Inguraidhoo is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'inguraidhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'inguraidhoo'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'innamaadhoo', 'Innamaadhoo', 'Innamaadhoo is an inhabited island in Raa Atoll, Maldives.', 'published', 'Innamaadhoo, Raa Atoll | Maldives Islands | MTG', 'Innamaadhoo is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'innamaadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'innamaadhoo'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kinolhas', 'Kinolhas', 'Kinolhas is an inhabited island in Raa Atoll, Maldives.', 'published', 'Kinolhas, Raa Atoll | Maldives Islands | MTG', 'Kinolhas is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kinolhas'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kinolhas'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maakurathu', 'Maakurathu', 'Maakurathu is an inhabited island in Raa Atoll, Maldives.', 'published', 'Maakurathu, Raa Atoll | Maldives Islands | MTG', 'Maakurathu is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maakurathu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maakurathu'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maduvvaree', 'Maduvvaree', 'Maduvvaree is an inhabited island in Raa Atoll, Maldives.', 'published', 'Maduvvaree, Raa Atoll | Maldives Islands | MTG', 'Maduvvaree is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maduvvaree'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maduvvaree'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maamigili', 'Maamigili', 'Maamigili is an inhabited island in Raa Atoll, Maldives.', 'published', 'Maamigili, Raa Atoll | Maldives Islands | MTG', 'Maamigili is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maamigili'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maamigili'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'meedhoo', 'Meedhoo', 'Meedhoo is an inhabited island in Raa Atoll, Maldives.', 'published', 'Meedhoo, Raa Atoll | Maldives Islands | MTG', 'Meedhoo is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'meedhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'meedhoo'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'rasgetheemu', 'Rasgetheemu', 'Rasgetheemu is an inhabited island in Raa Atoll, Maldives.', 'published', 'Rasgetheemu, Raa Atoll | Maldives Islands | MTG', 'Rasgetheemu is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'rasgetheemu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'rasgetheemu'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'rasmaadhoo', 'Rasmaadhoo', 'Rasmaadhoo is an inhabited island in Raa Atoll, Maldives.', 'published', 'Rasmaadhoo, Raa Atoll | Maldives Islands | MTG', 'Rasmaadhoo is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'rasmaadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'rasmaadhoo'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'ungoofaaru', 'Ungoofaaru', 'Ungoofaaru is an inhabited island in Raa Atoll, Maldives.', 'published', 'Ungoofaaru, Raa Atoll | Maldives Islands | MTG', 'Ungoofaaru is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'ungoofaaru'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'ungoofaaru'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'vaadhoo', 'Vaadhoo', 'Vaadhoo is an inhabited island in Raa Atoll, Maldives.', 'published', 'Vaadhoo, Raa Atoll | Maldives Islands | MTG', 'Vaadhoo is an inhabited island in Raa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vaadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vaadhoo'
  and p.node_type = 'location' and p.slug = 'raa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dharavandhoo', 'Dharavandhoo', 'Dharavandhoo is an inhabited island in Baa Atoll, Maldives.', 'published', 'Dharavandhoo, Baa Atoll | Maldives Islands | MTG', 'Dharavandhoo is an inhabited island in Baa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dharavandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dharavandhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dhonfanu', 'Dhonfanu', 'Dhonfanu is an inhabited island in Baa Atoll, Maldives.', 'published', 'Dhonfanu, Baa Atoll | Maldives Islands | MTG', 'Dhonfanu is an inhabited island in Baa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhonfanu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhonfanu'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'eydhafushi', 'Eydhafushi', 'Eydhafushi is an inhabited island in Baa Atoll, Maldives.', 'published', 'Eydhafushi, Baa Atoll | Maldives Islands | MTG', 'Eydhafushi is an inhabited island in Baa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'eydhafushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'eydhafushi'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'fehendhoo', 'Fehendhoo', 'Fehendhoo is an inhabited island in Baa Atoll, Maldives.', 'published', 'Fehendhoo, Baa Atoll | Maldives Islands | MTG', 'Fehendhoo is an inhabited island in Baa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fehendhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fehendhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'fulhadhoo', 'Fulhadhoo', 'Fulhadhoo is an inhabited island in Baa Atoll, Maldives.', 'published', 'Fulhadhoo, Baa Atoll | Maldives Islands | MTG', 'Fulhadhoo is an inhabited island in Baa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fulhadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fulhadhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'goidhoo-baa', 'Goidhoo', 'Goidhoo is an inhabited island in Baa Atoll, Maldives.', 'published', 'Goidhoo, Baa Atoll | Maldives Islands | MTG', 'Goidhoo is an inhabited island in Baa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'goidhoo_baa'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'goidhoo-baa'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'hithaadhoo', 'Hithaadhoo', 'Hithaadhoo is an inhabited island in Baa Atoll, Maldives.', 'published', 'Hithaadhoo, Baa Atoll | Maldives Islands | MTG', 'Hithaadhoo is an inhabited island in Baa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hithaadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hithaadhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kamadhoo', 'Kamadhoo', 'Kamadhoo is an inhabited island in Baa Atoll, Maldives.', 'published', 'Kamadhoo, Baa Atoll | Maldives Islands | MTG', 'Kamadhoo is an inhabited island in Baa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kamadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kamadhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kendhoo', 'Kendhoo', 'Kendhoo is an inhabited island in Baa Atoll, Maldives.', 'published', 'Kendhoo, Baa Atoll | Maldives Islands | MTG', 'Kendhoo is an inhabited island in Baa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kendhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kendhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kihaadhoo', 'Kihaadhoo', 'Kihaadhoo is an inhabited island in Baa Atoll, Maldives.', 'published', 'Kihaadhoo, Baa Atoll | Maldives Islands | MTG', 'Kihaadhoo is an inhabited island in Baa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kihaadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kihaadhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kudarikilu', 'Kudarikilu', 'Kudarikilu is an inhabited island in Baa Atoll, Maldives.', 'published', 'Kudarikilu, Baa Atoll | Maldives Islands | MTG', 'Kudarikilu is an inhabited island in Baa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kudarikilu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kudarikilu'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maalhos', 'Maalhos', 'Maalhos is an inhabited island in Baa Atoll, Maldives.', 'published', 'Maalhos, Baa Atoll | Maldives Islands | MTG', 'Maalhos is an inhabited island in Baa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maalhos'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maalhos'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'thulhaadhoo', 'Thulhaadhoo', 'Thulhaadhoo is an inhabited island in Baa Atoll, Maldives.', 'published', 'Thulhaadhoo, Baa Atoll | Maldives Islands | MTG', 'Thulhaadhoo is an inhabited island in Baa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'thulhaadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'thulhaadhoo'
  and p.node_type = 'location' and p.slug = 'baa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'hinnavaru', 'Hinnavaru', 'Hinnavaru is an inhabited island in Lhaviyani Atoll, Maldives.', 'published', 'Hinnavaru, Lhaviyani Atoll | Maldives Islands | MTG', 'Hinnavaru is an inhabited island in Lhaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hinnavaru'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hinnavaru'
  and p.node_type = 'location' and p.slug = 'lhaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kurendhoo', 'Kurendhoo', 'Kurendhoo is an inhabited island in Lhaviyani Atoll, Maldives.', 'published', 'Kurendhoo, Lhaviyani Atoll | Maldives Islands | MTG', 'Kurendhoo is an inhabited island in Lhaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kurendhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kurendhoo'
  and p.node_type = 'location' and p.slug = 'lhaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'naifaru', 'Naifaru', 'Naifaru is an inhabited island in Lhaviyani Atoll, Maldives.', 'published', 'Naifaru, Lhaviyani Atoll | Maldives Islands | MTG', 'Naifaru is an inhabited island in Lhaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'naifaru'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'naifaru'
  and p.node_type = 'location' and p.slug = 'lhaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'olhuvelifushi', 'Olhuvelifushi', 'Olhuvelifushi is an inhabited island in Lhaviyani Atoll, Maldives.', 'published', 'Olhuvelifushi, Lhaviyani Atoll | Maldives Islands | MTG', 'Olhuvelifushi is an inhabited island in Lhaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'olhuvelifushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'olhuvelifushi'
  and p.node_type = 'location' and p.slug = 'lhaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dhiffushi', 'Dhiffushi', 'Dhiffushi is an inhabited island in Kaafu Atoll, Maldives.', 'published', 'Dhiffushi, Kaafu Atoll | Maldives Islands | MTG', 'Dhiffushi is an inhabited island in Kaafu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhiffushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhiffushi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'gaafaru', 'Gaafaru', 'Gaafaru is an inhabited island in Kaafu Atoll, Maldives.', 'published', 'Gaafaru, Kaafu Atoll | Maldives Islands | MTG', 'Gaafaru is an inhabited island in Kaafu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'gaafaru'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'gaafaru'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'gulhi', 'Gulhi', 'Gulhi is an inhabited island in Kaafu Atoll, Maldives.', 'published', 'Gulhi, Kaafu Atoll | Maldives Islands | MTG', 'Gulhi is an inhabited island in Kaafu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'gulhi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'gulhi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'guraidhoo', 'Guraidhoo', 'Guraidhoo is an inhabited island in Kaafu Atoll, Maldives.', 'published', 'Guraidhoo, Kaafu Atoll | Maldives Islands | MTG', 'Guraidhoo is an inhabited island in Kaafu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'guraidhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'guraidhoo'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'himmafushi', 'Himmafushi', 'Himmafushi is an inhabited island in Kaafu Atoll, Maldives.', 'published', 'Himmafushi, Kaafu Atoll | Maldives Islands | MTG', 'Himmafushi is an inhabited island in Kaafu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'himmafushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'himmafushi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'huraa', 'Huraa', 'Huraa is an inhabited island in Kaafu Atoll, Maldives.', 'published', 'Huraa, Kaafu Atoll | Maldives Islands | MTG', 'Huraa is an inhabited island in Kaafu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'huraa'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'huraa'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kaashidhoo', 'Kaashidhoo', 'Kaashidhoo is an inhabited island in Kaafu Atoll, Maldives.', 'published', 'Kaashidhoo, Kaafu Atoll | Maldives Islands | MTG', 'Kaashidhoo is an inhabited island in Kaafu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kaashidhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kaashidhoo'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maafushi', 'Maafushi', 'Maafushi is an inhabited island in Kaafu Atoll, Maldives.', 'published', 'Maafushi, Kaafu Atoll | Maldives Islands | MTG', 'Maafushi is an inhabited island in Kaafu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maafushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maafushi'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'thulusdhoo', 'Thulusdhoo', 'Thulusdhoo is an inhabited island in Kaafu Atoll, Maldives.', 'published', 'Thulusdhoo, Kaafu Atoll | Maldives Islands | MTG', 'Thulusdhoo is an inhabited island in Kaafu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'thulusdhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'thulusdhoo'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'bodufolhudhoo', 'Bodufolhudhoo', 'Bodufolhudhoo is an inhabited island in Alif Alif Atoll, Maldives.', 'published', 'Bodufolhudhoo, Alif Alif Atoll | Maldives Islands | MTG', 'Bodufolhudhoo is an inhabited island in Alif Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'bodufolhudhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'bodufolhudhoo'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'feridhoo', 'Feridhoo', 'Feridhoo is an inhabited island in Alif Alif Atoll, Maldives.', 'published', 'Feridhoo, Alif Alif Atoll | Maldives Islands | MTG', 'Feridhoo is an inhabited island in Alif Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'feridhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'feridhoo'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'himandhoo', 'Himandhoo', 'Himandhoo is an inhabited island in Alif Alif Atoll, Maldives.', 'published', 'Himandhoo, Alif Alif Atoll | Maldives Islands | MTG', 'Himandhoo is an inhabited island in Alif Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'himandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'himandhoo'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maalhos-alif-alif', 'Maalhos', 'Maalhos is an inhabited island in Alif Alif Atoll, Maldives.', 'published', 'Maalhos, Alif Alif Atoll | Maldives Islands | MTG', 'Maalhos is an inhabited island in Alif Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maalhos_alif_alif'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maalhos-alif-alif'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'mathiveri', 'Mathiveri', 'Mathiveri is an inhabited island in Alif Alif Atoll, Maldives.', 'published', 'Mathiveri, Alif Alif Atoll | Maldives Islands | MTG', 'Mathiveri is an inhabited island in Alif Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'mathiveri'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'mathiveri'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'rasdhoo', 'Rasdhoo', 'Rasdhoo is an inhabited island in Alif Alif Atoll, Maldives.', 'published', 'Rasdhoo, Alif Alif Atoll | Maldives Islands | MTG', 'Rasdhoo is an inhabited island in Alif Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'rasdhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'rasdhoo'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'thoddoo', 'Thoddoo', 'Thoddoo is an inhabited island in Alif Alif Atoll, Maldives.', 'published', 'Thoddoo, Alif Alif Atoll | Maldives Islands | MTG', 'Thoddoo is an inhabited island in Alif Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'thoddoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'thoddoo'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'ukulhas', 'Ukulhas', 'Ukulhas is an inhabited island in Alif Alif Atoll, Maldives.', 'published', 'Ukulhas, Alif Alif Atoll | Maldives Islands | MTG', 'Ukulhas is an inhabited island in Alif Alif Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'ukulhas'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'ukulhas'
  and p.node_type = 'location' and p.slug = 'alif-alif'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dhangethi', 'Dhangethi', 'Dhangethi is an inhabited island in Alif Dhaalu Atoll, Maldives.', 'published', 'Dhangethi, Alif Dhaalu Atoll | Maldives Islands | MTG', 'Dhangethi is an inhabited island in Alif Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhangethi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhangethi'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dhidhdhoo-alif-dhaalu', 'Dhidhdhoo', 'Dhidhdhoo is an inhabited island in Alif Dhaalu Atoll, Maldives.', 'published', 'Dhidhdhoo, Alif Dhaalu Atoll | Maldives Islands | MTG', 'Dhidhdhoo is an inhabited island in Alif Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhidhdhoo_alif_dhaalu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhidhdhoo-alif-dhaalu'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dhigurah', 'Dhigurah', 'Dhigurah is an inhabited island in Alif Dhaalu Atoll, Maldives.', 'published', 'Dhigurah, Alif Dhaalu Atoll | Maldives Islands | MTG', 'Dhigurah is an inhabited island in Alif Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhigurah'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhigurah'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'fenfushi', 'Fenfushi', 'Fenfushi is an inhabited island in Alif Dhaalu Atoll, Maldives.', 'published', 'Fenfushi, Alif Dhaalu Atoll | Maldives Islands | MTG', 'Fenfushi is an inhabited island in Alif Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fenfushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fenfushi'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'hangnaameedhoo', 'Hangnaameedhoo', 'Hangnaameedhoo is an inhabited island in Alif Dhaalu Atoll, Maldives.', 'published', 'Hangnaameedhoo, Alif Dhaalu Atoll | Maldives Islands | MTG', 'Hangnaameedhoo is an inhabited island in Alif Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hangnaameedhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hangnaameedhoo'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kunburudhoo-alif-dhaalu', 'Kunburudhoo', 'Kunburudhoo is an inhabited island in Alif Dhaalu Atoll, Maldives.', 'published', 'Kunburudhoo, Alif Dhaalu Atoll | Maldives Islands | MTG', 'Kunburudhoo is an inhabited island in Alif Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kunburudhoo_alif_dhaalu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kunburudhoo-alif-dhaalu'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maamingili', 'Maamingili', 'Maamingili is an inhabited island in Alif Dhaalu Atoll, Maldives.', 'published', 'Maamingili, Alif Dhaalu Atoll | Maldives Islands | MTG', 'Maamingili is an inhabited island in Alif Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maamingili'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maamingili'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'mahibadhoo', 'Mahibadhoo', 'Mahibadhoo is an inhabited island in Alif Dhaalu Atoll, Maldives.', 'published', 'Mahibadhoo, Alif Dhaalu Atoll | Maldives Islands | MTG', 'Mahibadhoo is an inhabited island in Alif Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'mahibadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'mahibadhoo'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'mandhoo', 'Mandhoo', 'Mandhoo is an inhabited island in Alif Dhaalu Atoll, Maldives.', 'published', 'Mandhoo, Alif Dhaalu Atoll | Maldives Islands | MTG', 'Mandhoo is an inhabited island in Alif Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'mandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'mandhoo'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'omadhoo', 'Omadhoo', 'Omadhoo is an inhabited island in Alif Dhaalu Atoll, Maldives.', 'published', 'Omadhoo, Alif Dhaalu Atoll | Maldives Islands | MTG', 'Omadhoo is an inhabited island in Alif Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'omadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'omadhoo'
  and p.node_type = 'location' and p.slug = 'alif-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'felidhoo', 'Felidhoo', 'Felidhoo is an inhabited island in Vaavu Atoll, Maldives.', 'published', 'Felidhoo, Vaavu Atoll | Maldives Islands | MTG', 'Felidhoo is an inhabited island in Vaavu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'felidhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'felidhoo'
  and p.node_type = 'location' and p.slug = 'vaavu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'fulidhoo', 'Fulidhoo', 'Fulidhoo is an inhabited island in Vaavu Atoll, Maldives.', 'published', 'Fulidhoo, Vaavu Atoll | Maldives Islands | MTG', 'Fulidhoo is an inhabited island in Vaavu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fulidhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fulidhoo'
  and p.node_type = 'location' and p.slug = 'vaavu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'keyodhoo', 'Keyodhoo', 'Keyodhoo is an inhabited island in Vaavu Atoll, Maldives.', 'published', 'Keyodhoo, Vaavu Atoll | Maldives Islands | MTG', 'Keyodhoo is an inhabited island in Vaavu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'keyodhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'keyodhoo'
  and p.node_type = 'location' and p.slug = 'vaavu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'rakeedhoo', 'Rakeedhoo', 'Rakeedhoo is an inhabited island in Vaavu Atoll, Maldives.', 'published', 'Rakeedhoo, Vaavu Atoll | Maldives Islands | MTG', 'Rakeedhoo is an inhabited island in Vaavu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'rakeedhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'rakeedhoo'
  and p.node_type = 'location' and p.slug = 'vaavu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'thinadhoo', 'Thinadhoo', 'Thinadhoo is an inhabited island in Vaavu Atoll, Maldives.', 'published', 'Thinadhoo, Vaavu Atoll | Maldives Islands | MTG', 'Thinadhoo is an inhabited island in Vaavu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'thinadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'thinadhoo'
  and p.node_type = 'location' and p.slug = 'vaavu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'muli', 'Muli', 'Muli is an inhabited island in Meemu Atoll, Maldives.', 'published', 'Muli, Meemu Atoll | Maldives Islands | MTG', 'Muli is an inhabited island in Meemu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'muli'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'muli'
  and p.node_type = 'location' and p.slug = 'meemu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'boli-mulah', 'Boli Mulah', 'Boli Mulah is an inhabited island in Meemu Atoll, Maldives.', 'published', 'Boli Mulah, Meemu Atoll | Maldives Islands | MTG', 'Boli Mulah is an inhabited island in Meemu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'boli_mulah'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'boli-mulah'
  and p.node_type = 'location' and p.slug = 'meemu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dhiggaru', 'Dhiggaru', 'Dhiggaru is an inhabited island in Meemu Atoll, Maldives.', 'published', 'Dhiggaru, Meemu Atoll | Maldives Islands | MTG', 'Dhiggaru is an inhabited island in Meemu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhiggaru'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhiggaru'
  and p.node_type = 'location' and p.slug = 'meemu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kolhufushi', 'Kolhufushi', 'Kolhufushi is an inhabited island in Meemu Atoll, Maldives.', 'published', 'Kolhufushi, Meemu Atoll | Maldives Islands | MTG', 'Kolhufushi is an inhabited island in Meemu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kolhufushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kolhufushi'
  and p.node_type = 'location' and p.slug = 'meemu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maduvvaree-meemu', 'Maduvvaree', 'Maduvvaree is an inhabited island in Meemu Atoll, Maldives.', 'published', 'Maduvvaree, Meemu Atoll | Maldives Islands | MTG', 'Maduvvaree is an inhabited island in Meemu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maduvvaree_meemu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maduvvaree-meemu'
  and p.node_type = 'location' and p.slug = 'meemu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'naalaafushi', 'Naalaafushi', 'Naalaafushi is an inhabited island in Meemu Atoll, Maldives.', 'published', 'Naalaafushi, Meemu Atoll | Maldives Islands | MTG', 'Naalaafushi is an inhabited island in Meemu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'naalaafushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'naalaafushi'
  and p.node_type = 'location' and p.slug = 'meemu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'raimmandhoo', 'Raimmandhoo', 'Raimmandhoo is an inhabited island in Meemu Atoll, Maldives.', 'published', 'Raimmandhoo, Meemu Atoll | Maldives Islands | MTG', 'Raimmandhoo is an inhabited island in Meemu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'raimmandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'raimmandhoo'
  and p.node_type = 'location' and p.slug = 'meemu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'veyvah', 'Veyvah', 'Veyvah is an inhabited island in Meemu Atoll, Maldives.', 'published', 'Veyvah, Meemu Atoll | Maldives Islands | MTG', 'Veyvah is an inhabited island in Meemu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'veyvah'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'veyvah'
  and p.node_type = 'location' and p.slug = 'meemu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'bileddhoo', 'Bileddhoo', 'Bileddhoo is an inhabited island in Faafu Atoll, Maldives.', 'published', 'Bileddhoo, Faafu Atoll | Maldives Islands | MTG', 'Bileddhoo is an inhabited island in Faafu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'bileddhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'bileddhoo'
  and p.node_type = 'location' and p.slug = 'faafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dharanboodhoo', 'Dharanboodhoo', 'Dharanboodhoo is an inhabited island in Faafu Atoll, Maldives.', 'published', 'Dharanboodhoo, Faafu Atoll | Maldives Islands | MTG', 'Dharanboodhoo is an inhabited island in Faafu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dharanboodhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dharanboodhoo'
  and p.node_type = 'location' and p.slug = 'faafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'feeali', 'Feeali', 'Feeali is an inhabited island in Faafu Atoll, Maldives.', 'published', 'Feeali, Faafu Atoll | Maldives Islands | MTG', 'Feeali is an inhabited island in Faafu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'feeali'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'feeali'
  and p.node_type = 'location' and p.slug = 'faafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'magoodhoo-faafu', 'Magoodhoo', 'Magoodhoo is an inhabited island in Faafu Atoll, Maldives.', 'published', 'Magoodhoo, Faafu Atoll | Maldives Islands | MTG', 'Magoodhoo is an inhabited island in Faafu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'magoodhoo_faafu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'magoodhoo-faafu'
  and p.node_type = 'location' and p.slug = 'faafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'nilandhoo', 'Nilandhoo', 'Nilandhoo is an inhabited island in Faafu Atoll, Maldives.', 'published', 'Nilandhoo, Faafu Atoll | Maldives Islands | MTG', 'Nilandhoo is an inhabited island in Faafu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'nilandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'nilandhoo'
  and p.node_type = 'location' and p.slug = 'faafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'bandidhoo', 'Bandidhoo', 'Bandidhoo is an inhabited island in Dhaalu Atoll, Maldives.', 'published', 'Bandidhoo, Dhaalu Atoll | Maldives Islands | MTG', 'Bandidhoo is an inhabited island in Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'bandidhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'bandidhoo'
  and p.node_type = 'location' and p.slug = 'dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'hulhudheli', 'Hulhudheli', 'Hulhudheli is an inhabited island in Dhaalu Atoll, Maldives.', 'published', 'Hulhudheli, Dhaalu Atoll | Maldives Islands | MTG', 'Hulhudheli is an inhabited island in Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hulhudheli'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hulhudheli'
  and p.node_type = 'location' and p.slug = 'dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kudahuvadhoo', 'Kudahuvadhoo', 'Kudahuvadhoo is an inhabited island in Dhaalu Atoll, Maldives.', 'published', 'Kudahuvadhoo, Dhaalu Atoll | Maldives Islands | MTG', 'Kudahuvadhoo is an inhabited island in Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kudahuvadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kudahuvadhoo'
  and p.node_type = 'location' and p.slug = 'dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maaenboodhoo', 'Maaenboodhoo', 'Maaenboodhoo is an inhabited island in Dhaalu Atoll, Maldives.', 'published', 'Maaenboodhoo, Dhaalu Atoll | Maldives Islands | MTG', 'Maaenboodhoo is an inhabited island in Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maaenboodhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maaenboodhoo'
  and p.node_type = 'location' and p.slug = 'dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'meedhoo-dhaalu', 'Meedhoo', 'Meedhoo is an inhabited island in Dhaalu Atoll, Maldives.', 'published', 'Meedhoo, Dhaalu Atoll | Maldives Islands | MTG', 'Meedhoo is an inhabited island in Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'meedhoo_dhaalu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'meedhoo-dhaalu'
  and p.node_type = 'location' and p.slug = 'dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'rinbudhoo', 'Rinbudhoo', 'Rinbudhoo is an inhabited island in Dhaalu Atoll, Maldives.', 'published', 'Rinbudhoo, Dhaalu Atoll | Maldives Islands | MTG', 'Rinbudhoo is an inhabited island in Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'rinbudhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'rinbudhoo'
  and p.node_type = 'location' and p.slug = 'dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'burunee', 'Burunee', 'Burunee is an inhabited island in Thaa Atoll, Maldives.', 'published', 'Burunee, Thaa Atoll | Maldives Islands | MTG', 'Burunee is an inhabited island in Thaa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'burunee'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'burunee'
  and p.node_type = 'location' and p.slug = 'thaa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dhiyamigili', 'Dhiyamigili', 'Dhiyamigili is an inhabited island in Thaa Atoll, Maldives.', 'published', 'Dhiyamigili, Thaa Atoll | Maldives Islands | MTG', 'Dhiyamigili is an inhabited island in Thaa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhiyamigili'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhiyamigili'
  and p.node_type = 'location' and p.slug = 'thaa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'gaadhiffushi', 'Gaadhiffushi', 'Gaadhiffushi is an inhabited island in Thaa Atoll, Maldives.', 'published', 'Gaadhiffushi, Thaa Atoll | Maldives Islands | MTG', 'Gaadhiffushi is an inhabited island in Thaa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'gaadhiffushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'gaadhiffushi'
  and p.node_type = 'location' and p.slug = 'thaa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'guraidhoo-thaa', 'Guraidhoo', 'Guraidhoo is an inhabited island in Thaa Atoll, Maldives.', 'published', 'Guraidhoo, Thaa Atoll | Maldives Islands | MTG', 'Guraidhoo is an inhabited island in Thaa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'guraidhoo_thaa'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'guraidhoo-thaa'
  and p.node_type = 'location' and p.slug = 'thaa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'hirilandhoo', 'Hirilandhoo', 'Hirilandhoo is an inhabited island in Thaa Atoll, Maldives.', 'published', 'Hirilandhoo, Thaa Atoll | Maldives Islands | MTG', 'Hirilandhoo is an inhabited island in Thaa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hirilandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hirilandhoo'
  and p.node_type = 'location' and p.slug = 'thaa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kandoodhoo', 'Kandoodhoo', 'Kandoodhoo is an inhabited island in Thaa Atoll, Maldives.', 'published', 'Kandoodhoo, Thaa Atoll | Maldives Islands | MTG', 'Kandoodhoo is an inhabited island in Thaa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kandoodhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kandoodhoo'
  and p.node_type = 'location' and p.slug = 'thaa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kinbidhoo', 'Kinbidhoo', 'Kinbidhoo is an inhabited island in Thaa Atoll, Maldives.', 'published', 'Kinbidhoo, Thaa Atoll | Maldives Islands | MTG', 'Kinbidhoo is an inhabited island in Thaa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kinbidhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kinbidhoo'
  and p.node_type = 'location' and p.slug = 'thaa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'madifushi', 'Madifushi', 'Madifushi is an inhabited island in Thaa Atoll, Maldives.', 'published', 'Madifushi, Thaa Atoll | Maldives Islands | MTG', 'Madifushi is an inhabited island in Thaa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'madifushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'madifushi'
  and p.node_type = 'location' and p.slug = 'thaa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'omadhoo-thaa', 'Omadhoo', 'Omadhoo is an inhabited island in Thaa Atoll, Maldives.', 'published', 'Omadhoo, Thaa Atoll | Maldives Islands | MTG', 'Omadhoo is an inhabited island in Thaa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'omadhoo_thaa'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'omadhoo-thaa'
  and p.node_type = 'location' and p.slug = 'thaa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'thimarafushi', 'Thimarafushi', 'Thimarafushi is an inhabited island in Thaa Atoll, Maldives.', 'published', 'Thimarafushi, Thaa Atoll | Maldives Islands | MTG', 'Thimarafushi is an inhabited island in Thaa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'thimarafushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'thimarafushi'
  and p.node_type = 'location' and p.slug = 'thaa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'vandhoo', 'Vandhoo', 'Vandhoo is an inhabited island in Thaa Atoll, Maldives.', 'published', 'Vandhoo, Thaa Atoll | Maldives Islands | MTG', 'Vandhoo is an inhabited island in Thaa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vandhoo'
  and p.node_type = 'location' and p.slug = 'thaa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'veymandoo', 'Veymandoo', 'Veymandoo is an inhabited island in Thaa Atoll, Maldives.', 'published', 'Veymandoo, Thaa Atoll | Maldives Islands | MTG', 'Veymandoo is an inhabited island in Thaa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'veymandoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'veymandoo'
  and p.node_type = 'location' and p.slug = 'thaa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'vilufushi', 'Vilufushi', 'Vilufushi is an inhabited island in Thaa Atoll, Maldives.', 'published', 'Vilufushi, Thaa Atoll | Maldives Islands | MTG', 'Vilufushi is an inhabited island in Thaa Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vilufushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vilufushi'
  and p.node_type = 'location' and p.slug = 'thaa'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dhanbidhoo', 'Dhanbidhoo', 'Dhanbidhoo is an inhabited island in Laamu Atoll, Maldives.', 'published', 'Dhanbidhoo, Laamu Atoll | Maldives Islands | MTG', 'Dhanbidhoo is an inhabited island in Laamu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhanbidhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhanbidhoo'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'fonadhoo', 'Fonadhoo', 'Fonadhoo is an inhabited island in Laamu Atoll, Maldives.', 'published', 'Fonadhoo, Laamu Atoll | Maldives Islands | MTG', 'Fonadhoo is an inhabited island in Laamu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fonadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fonadhoo'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'gaadhoo', 'Gaadhoo', 'Gaadhoo is an island in Laamu Atoll, Maldives, no longer inhabited after its community relocated.', 'published', 'Gaadhoo, Laamu Atoll | Maldives Islands | MTG', 'Gaadhoo is an island in Laamu Atoll, Maldives, no longer inhabited after its community relocated.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'gaadhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'gaadhoo'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'gan', 'Gan', 'Gan is an inhabited island in Laamu Atoll, Maldives.', 'published', 'Gan, Laamu Atoll | Maldives Islands | MTG', 'Gan is an inhabited island in Laamu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'gan'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'gan'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'hithadhoo', 'Hithadhoo', 'Hithadhoo is an inhabited island in Laamu Atoll, Maldives.', 'published', 'Hithadhoo, Laamu Atoll | Maldives Islands | MTG', 'Hithadhoo is an inhabited island in Laamu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hithadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hithadhoo'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'isdhoo', 'Isdhoo', 'Isdhoo is an inhabited island in Laamu Atoll, Maldives.', 'published', 'Isdhoo, Laamu Atoll | Maldives Islands | MTG', 'Isdhoo is an inhabited island in Laamu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'isdhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'isdhoo'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kalhaidhoo', 'Kalhaidhoo', 'Kalhaidhoo is an island in Laamu Atoll, Maldives, no longer inhabited after its community relocated.', 'published', 'Kalhaidhoo, Laamu Atoll | Maldives Islands | MTG', 'Kalhaidhoo is an island in Laamu Atoll, Maldives, no longer inhabited after its community relocated.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kalhaidhoo'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kalhaidhoo'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kunahandhoo', 'Kunahandhoo', 'Kunahandhoo is an inhabited island in Laamu Atoll, Maldives.', 'published', 'Kunahandhoo, Laamu Atoll | Maldives Islands | MTG', 'Kunahandhoo is an inhabited island in Laamu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kunahandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kunahandhoo'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maabaidhoo', 'Maabaidhoo', 'Maabaidhoo is an inhabited island in Laamu Atoll, Maldives.', 'published', 'Maabaidhoo, Laamu Atoll | Maldives Islands | MTG', 'Maabaidhoo is an inhabited island in Laamu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maabaidhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maabaidhoo'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maamendhoo', 'Maamendhoo', 'Maamendhoo is an inhabited island in Laamu Atoll, Maldives.', 'published', 'Maamendhoo, Laamu Atoll | Maldives Islands | MTG', 'Maamendhoo is an inhabited island in Laamu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maamendhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maamendhoo'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maavah', 'Maavah', 'Maavah is an inhabited island in Laamu Atoll, Maldives.', 'published', 'Maavah, Laamu Atoll | Maldives Islands | MTG', 'Maavah is an inhabited island in Laamu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maavah'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maavah'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'mundoo', 'Mundoo', 'Mundoo is an inhabited island in Laamu Atoll, Maldives.', 'published', 'Mundoo, Laamu Atoll | Maldives Islands | MTG', 'Mundoo is an inhabited island in Laamu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'mundoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'mundoo'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dhaandhoo', 'Dhaandhoo', 'Dhaandhoo is an inhabited island in Gaafu Alifu Atoll, Maldives.', 'published', 'Dhaandhoo, Gaafu Alifu Atoll | Maldives Islands | MTG', 'Dhaandhoo is an inhabited island in Gaafu Alifu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhaandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhaandhoo'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dhevvadhoo', 'Dhevvadhoo', 'Dhevvadhoo is an inhabited island in Gaafu Alifu Atoll, Maldives.', 'published', 'Dhevvadhoo, Gaafu Alifu Atoll | Maldives Islands | MTG', 'Dhevvadhoo is an inhabited island in Gaafu Alifu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhevvadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhevvadhoo'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'dhiyadhoo', 'Dhiyadhoo', 'Dhiyadhoo is an inhabited island in Gaafu Alifu Atoll, Maldives.', 'published', 'Dhiyadhoo, Gaafu Alifu Atoll | Maldives Islands | MTG', 'Dhiyadhoo is an inhabited island in Gaafu Alifu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhiyadhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhiyadhoo'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'gemanafushi', 'Gemanafushi', 'Gemanafushi is an inhabited island in Gaafu Alifu Atoll, Maldives.', 'published', 'Gemanafushi, Gaafu Alifu Atoll | Maldives Islands | MTG', 'Gemanafushi is an inhabited island in Gaafu Alifu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'gemanafushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'gemanafushi'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kanduhulhudhoo', 'Kanduhulhudhoo', 'Kanduhulhudhoo is an inhabited island in Gaafu Alifu Atoll, Maldives.', 'published', 'Kanduhulhudhoo, Gaafu Alifu Atoll | Maldives Islands | MTG', 'Kanduhulhudhoo is an inhabited island in Gaafu Alifu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kanduhulhudhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kanduhulhudhoo'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kolamaafushi', 'Kolamaafushi', 'Kolamaafushi is an inhabited island in Gaafu Alifu Atoll, Maldives.', 'published', 'Kolamaafushi, Gaafu Alifu Atoll | Maldives Islands | MTG', 'Kolamaafushi is an inhabited island in Gaafu Alifu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kolamaafushi'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kolamaafushi'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kondey', 'Kondey', 'Kondey is an inhabited island in Gaafu Alifu Atoll, Maldives.', 'published', 'Kondey, Gaafu Alifu Atoll | Maldives Islands | MTG', 'Kondey is an inhabited island in Gaafu Alifu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kondey'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kondey'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maamendhoo-gaafu-alifu', 'Maamendhoo', 'Maamendhoo is an inhabited island in Gaafu Alifu Atoll, Maldives.', 'published', 'Maamendhoo, Gaafu Alifu Atoll | Maldives Islands | MTG', 'Maamendhoo is an inhabited island in Gaafu Alifu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maamendhoo_gaafu_alifu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maamendhoo-gaafu-alifu'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'nilandhoo-gaafu-alifu', 'Nilandhoo', 'Nilandhoo is an inhabited island in Gaafu Alifu Atoll, Maldives.', 'published', 'Nilandhoo, Gaafu Alifu Atoll | Maldives Islands | MTG', 'Nilandhoo is an inhabited island in Gaafu Alifu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'nilandhoo_gaafu_alifu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'nilandhoo-gaafu-alifu'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'vilingili', 'Vilingili', 'Vilingili is an inhabited island in Gaafu Alifu Atoll, Maldives.', 'published', 'Vilingili, Gaafu Alifu Atoll | Maldives Islands | MTG', 'Vilingili is an inhabited island in Gaafu Alifu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vilingili'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vilingili'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'fares-maathodaa', 'Fares-Maathodaa', 'Fares-Maathodaa is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', 'published', 'Fares-Maathodaa, Gaafu Dhaalu Atoll | Maldives Islands | MTG', 'Fares-Maathodaa is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fares_maathodaa'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fares-maathodaa'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'fiyoari', 'Fiyoari', 'Fiyoari is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', 'published', 'Fiyoari, Gaafu Dhaalu Atoll | Maldives Islands | MTG', 'Fiyoari is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fiyoari'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fiyoari'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'gaddhoo', 'Gaddhoo', 'Gaddhoo is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', 'published', 'Gaddhoo, Gaafu Dhaalu Atoll | Maldives Islands | MTG', 'Gaddhoo is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'gaddhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'gaddhoo'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'hoandeddhoo', 'Hoandeddhoo', 'Hoandeddhoo is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', 'published', 'Hoandeddhoo, Gaafu Dhaalu Atoll | Maldives Islands | MTG', 'Hoandeddhoo is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hoandeddhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hoandeddhoo'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'madaveli', 'Madaveli', 'Madaveli is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', 'published', 'Madaveli, Gaafu Dhaalu Atoll | Maldives Islands | MTG', 'Madaveli is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'madaveli'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'madaveli'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'nadellaa', 'Nadellaa', 'Nadellaa is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', 'published', 'Nadellaa, Gaafu Dhaalu Atoll | Maldives Islands | MTG', 'Nadellaa is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'nadellaa'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'nadellaa'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'rathafandhoo', 'Rathafandhoo', 'Rathafandhoo is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', 'published', 'Rathafandhoo, Gaafu Dhaalu Atoll | Maldives Islands | MTG', 'Rathafandhoo is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'rathafandhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'rathafandhoo'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'thinadhoo-gaafu-dhaalu', 'Thinadhoo', 'Thinadhoo is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', 'published', 'Thinadhoo, Gaafu Dhaalu Atoll | Maldives Islands | MTG', 'Thinadhoo is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'thinadhoo_gaafu_dhaalu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'thinadhoo-gaafu-dhaalu'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'vaadhoo-gaafu-dhaalu', 'Vaadhoo', 'Vaadhoo is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', 'published', 'Vaadhoo, Gaafu Dhaalu Atoll | Maldives Islands | MTG', 'Vaadhoo is an inhabited island in Gaafu Dhaalu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'vaadhoo_gaafu_dhaalu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'vaadhoo-gaafu-dhaalu'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'fuvahmulah', 'Fuvahmulah', 'Fuvahmulah is an inhabited island in Gnaviyani Atoll, Maldives.', 'published', 'Fuvahmulah, Gnaviyani Atoll | Maldives Islands | MTG', 'Fuvahmulah is an inhabited island in Gnaviyani Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'fuvahmulah'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'fuvahmulah'
  and p.node_type = 'location' and p.slug = 'gnaviyani'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'hithadhoo-seenu', 'Hithadhoo', 'Hithadhoo is an inhabited island in Seenu Atoll, Maldives.', 'published', 'Hithadhoo, Seenu Atoll | Maldives Islands | MTG', 'Hithadhoo is an inhabited island in Seenu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hithadhoo_seenu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hithadhoo-seenu'
  and p.node_type = 'location' and p.slug = 'seenu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maradhoo', 'Maradhoo', 'Maradhoo is an inhabited island in Seenu Atoll, Maldives.', 'published', 'Maradhoo, Seenu Atoll | Maldives Islands | MTG', 'Maradhoo is an inhabited island in Seenu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maradhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maradhoo'
  and p.node_type = 'location' and p.slug = 'seenu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'maradhoo-feydhoo', 'Maradhoo-Feydhoo', 'Maradhoo-Feydhoo is an inhabited island in Seenu Atoll, Maldives.', 'published', 'Maradhoo-Feydhoo, Seenu Atoll | Maldives Islands | MTG', 'Maradhoo-Feydhoo is an inhabited island in Seenu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'maradhoo_feydhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'maradhoo-feydhoo'
  and p.node_type = 'location' and p.slug = 'seenu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'feydhoo-seenu', 'Feydhoo', 'Feydhoo is an inhabited island in Seenu Atoll, Maldives.', 'published', 'Feydhoo, Seenu Atoll | Maldives Islands | MTG', 'Feydhoo is an inhabited island in Seenu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'feydhoo_seenu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'feydhoo-seenu'
  and p.node_type = 'location' and p.slug = 'seenu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'hulhudhoo', 'Hulhudhoo', 'Hulhudhoo is an inhabited island in Seenu Atoll, Maldives.', 'published', 'Hulhudhoo, Seenu Atoll | Maldives Islands | MTG', 'Hulhudhoo is an inhabited island in Seenu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hulhudhoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hulhudhoo'
  and p.node_type = 'location' and p.slug = 'seenu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'meedhoo-seenu', 'Meedhoo', 'Meedhoo is an inhabited island in Seenu Atoll, Maldives.', 'published', 'Meedhoo, Seenu Atoll | Maldives Islands | MTG', 'Meedhoo is an inhabited island in Seenu Atoll, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'meedhoo_seenu'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'meedhoo-seenu'
  and p.node_type = 'location' and p.slug = 'seenu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'male', 'Malé', 'Malé is an inhabited island in Malé City, Maldives.', 'published', 'Malé, Malé City | Maldives Islands | MTG', 'Malé is an inhabited island in Malé City, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'male'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'male'
  and p.node_type = 'location' and p.slug = 'male-city'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'hulhumale', 'Hulhumalé', 'Hulhumalé is an inhabited island in Malé City, Maldives.', 'published', 'Hulhumalé, Malé City | Maldives Islands | MTG', 'Hulhumalé is an inhabited island in Malé City, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'hulhumale'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'hulhumale'
  and p.node_type = 'location' and p.slug = 'male-city'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'villingili', 'Villingili', 'Villingili is an inhabited island in Malé City, Maldives.', 'published', 'Villingili, Malé City | Maldives Islands | MTG', 'Villingili is an inhabited island in Malé City, Maldives.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'villingili'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'villingili'
  and p.node_type = 'location' and p.slug = 'male-city'
on conflict (id) do nothing;

