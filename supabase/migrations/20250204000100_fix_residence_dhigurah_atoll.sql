-- Bug fix, surfaced by the site owner correcting the previous migration's
-- assumption: "The Residence Maldives at Dhigurah Island Resort" was
-- linked (20250123000200_seed_stays_properties.sql) to the pre-existing
-- 'dhigurah' location node — the real, inhabited Dhigurah island in Alif
-- Dhaalu Atoll (seeded earlier, 20250102000100, and used for genuine
-- Alif Dhaalu content such as whale shark excursions). That was a name-only
-- match, not an atoll-checked one: this resort's own legacy page
-- (release/public_html/resorts/Residence-Dhigurah/The-Residence-Dhigurah-Maldives.html)
-- states outright, in its meta description and twice in its body copy,
-- that it is "nestled in the Gaafu Alifu Atoll" — matching
-- data/maldives/accommodations-v2/resolved-properties.json's own
-- atollCode: "GA" for this property, which the original migration's
-- node_locations insert simply didn't check against. Two real, different
-- Maldivian islands share the name "Dhigurah" (Alif Dhaalu's is the
-- well-known one with guesthouses/whale shark tours; this one is the
-- Residence's private resort island in Gaafu Alifu) — same situation as
-- the existing maamendhoo-gaafu-alifu/nilandhoo-gaafu-alifu disambiguated
-- slugs, so the same '-gaafu-alifu' suffix convention is used here.

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('location', 'dhigurah-gaafu-alifu', 'Dhigurah', 'Dhigurah is a resort island in Gaafu Alifu Atoll, Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'dhigurah_ga'::ltree), false
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'dhigurah-gaafu-alifu'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

delete from node_locations
where node_id = (select id from nodes where node_type = 'accommodation' and slug = 'the-residence-maldives-at-dhigurah-island-resort')
  and location_id = (select id from nodes where node_type = 'location' and slug = 'dhigurah');

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'accommodation' and n.slug = 'the-residence-maldives-at-dhigurah-island-resort'
  and l.node_type = 'location' and l.slug = 'dhigurah-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

-- Now add it to the Gaafu Alifu Island Hopping Tour (20250203000100), as
-- the site owner originally intended.
insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'gaafu-alifu-island-hopping-tour' and l.node_type = 'location' and l.slug = 'dhigurah-gaafu-alifu'
on conflict (node_id, location_id) do nothing;
