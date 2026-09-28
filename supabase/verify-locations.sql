-- Task 4 data verification (dev-only, run manually — not a migration).
-- Confirms the imported Maldives geographic hierarchy is internally
-- consistent, per docs/SYSTEM_ARCHITECTURE_AND_DATABASE_DESIGN.md and the
-- Task 4 requirements.

\echo '=== Row counts ==='
select
  (select count(*) from locations where location_type = 'country') as countries,
  (select count(*) from locations where location_type = 'atoll')   as atolls,
  (select count(*) from locations where location_type = 'island')  as islands,
  (select count(*) from locations) as all_locations;

\echo '=== 1. Maldives exists exactly once ==='
select count(*) from nodes where node_type = 'location' and slug = 'maldives';
-- expect 1

\echo '=== 2. No duplicate (node_type, slug) — enforced by DB constraint, sanity check ==='
select node_type, slug, count(*) from nodes where node_type = 'location' group by node_type, slug having count(*) > 1;
-- expect 0 rows

\echo '=== 3. Every atoll parent is exactly the country row ==='
select l.id, n.title
from locations l join nodes n on n.id = l.id
where l.location_type = 'atoll'
  and l.parent_id <> (select id from nodes where slug = 'maldives');
-- expect 0 rows

\echo '=== 4. Every island has a parent that is actually an atoll ==='
select l.id, n.title
from locations l join nodes n on n.id = l.id
where l.location_type = 'island'
  and l.parent_id not in (select id from locations where location_type = 'atoll');
-- expect 0 rows

\echo '=== 5. No orphan locations (non-country row with a null parent) ==='
select id, location_type from locations where parent_id is null and location_type <> 'country';
-- expect 0 rows

\echo '=== 6. No location references a non-existent parent (should be impossible — FK) ==='
select l.id from locations l
where l.parent_id is not null
  and not exists (select 1 from locations p where p.id = l.parent_id);
-- expect 0 rows

\echo '=== 7. ltree path depth matches parent_id chain depth ==='
with recursive depth as (
  select id, parent_id, 1 as expected_levels from locations where parent_id is null
  union all
  select l.id, l.parent_id, d.expected_levels + 1
  from locations l join depth d on l.parent_id = d.id
)
select l.id, l.location_type, nlevel(l.path) as actual_levels, d.expected_levels
from locations l join depth d on d.id = l.id
where nlevel(l.path) <> d.expected_levels;
-- expect 0 rows

\echo '=== 8. Every island path starts with its atoll parent path (ltree consistency) ==='
select isl.id, n.title
from locations isl
join nodes n on n.id = isl.id
join locations atoll on atoll.id = isl.parent_id
where isl.location_type = 'island' and not (isl.path <@ atoll.path) ;
-- expect 0 rows

\echo '=== 9. Island counts per atoll (spot check against SOURCES.md) ==='
select n.title, n.slug, l.administrative_code, count(child.id) as island_count
from locations l
join nodes n on n.id = l.id
left join locations child on child.parent_id = l.id and child.location_type = 'island'
where l.location_type = 'atoll'
group by n.title, n.slug, l.administrative_code
order by n.title;

\echo '=== 10. Sample slugs (accent/apostrophe handling, e.g. Male / Malé) ==='
select n.slug, n.title from nodes n join locations l on l.id = n.id
where n.title like '%é%' or n.title like '%Malé%'
order by n.title
limit 15;

\echo '=== 11. Example canonical slugs referenced in the task brief ==='
select slug, title from nodes where node_type = 'location' and slug in
  ('maldives', 'kaafu', 'lhaviyani', 'hinnavaru', 'maafushi', 'thulusdhoo');

\echo '=== DONE ==='
