-- Task 8 data verification (dev-only, run manually — not a migration).

\echo '=== Row counts ==='
select
  (select count(*) from activities where activity_category = 'diving')      as diving_activities,
  (select count(*) from locations where location_type = 'dive_site')        as dive_sites,
  (select count(*) from nodes where node_type = 'provider')                 as providers_total,
  (select count(*) from categories where category_group = 'activity-type')  as activity_type_categories;

\echo '=== 1. Every diving activity node has a matching activities row ==='
select n.id, n.slug from nodes n
join activities a on a.id = n.id
where a.activity_category = 'diving'
  and n.node_type <> 'activity';
-- expect 0 rows (node_type mismatch would be impossible given FK, sanity check only)

\echo '=== 2. No duplicate slugs among activities, providers, or dive-site locations ==='
select slug, count(*) from nodes where node_type = 'activity' group by slug having count(*) > 1;
-- expect 0 rows
select title, count(*) from nodes where node_type = 'provider' group by title having count(*) > 1;
-- expect 0 rows
select n.slug, count(*) from nodes n join locations l on l.id = n.id
where l.location_type = 'dive_site' group by n.slug having count(*) > 1;
-- expect 0 rows (confirms same-named dive activities like the four
-- "Discover Scuba Diving" and four "PADI Open Water Diver Course" entries
-- did not collapse into, or collide with, existing Task 6 nodes)

\echo '=== 3. Every diving activity has exactly one primary location, referencing a real location ==='
select n.slug, count(*) filter (where nl.relation = 'primary') as primary_count
from nodes n
join activities a on a.id = n.id and a.activity_category = 'diving'
join node_locations nl on nl.node_id = n.id
group by n.slug
having count(*) filter (where nl.relation = 'primary') <> 1;
-- expect 0 rows

select n.slug
from nodes n
join activities a on a.id = n.id and a.activity_category = 'diving'
join node_locations nl on nl.node_id = n.id and nl.relation = 'primary'
where not exists (select 1 from locations l where l.id = nl.location_id);
-- expect 0 rows

\echo '=== 4. Every operated_by_provider_id references a real provider node ==='
select n.slug from activities a join nodes n on n.id = a.id
where a.activity_category = 'diving' and a.operated_by_provider_id is not null
  and not exists (select 1 from nodes p where p.id = a.operated_by_provider_id and p.node_type = 'provider');
-- expect 0 rows

\echo '=== 5. Every diving-type category tag on a diving activity is real and correctly grouped ==='
select n.slug as activity_slug, nc.category_id
from nodes n
join activities a on a.id = n.id and a.activity_category = 'diving'
join node_categories nc on nc.node_id = n.id
where not exists (
  select 1 from categories c where c.id = nc.category_id and c.category_group = 'activity-type'
);
-- expect 0 rows

\echo '=== 6. bookable_products: valid FK, every diving activity IS bookable ==='
select bp.id from bookable_products bp
where not exists (select 1 from nodes n where n.id = bp.id and n.node_type in ('accommodation','activity','package'));
-- expect 0 rows
select n.slug from nodes n
join activities a on a.id = n.id and a.activity_category = 'diving'
where not exists (select 1 from bookable_products bp where bp.id = n.id);
-- expect 0 rows

\echo '=== 7. CRITICAL: no dive site ever has a bookable_products row ==='
select n.slug from nodes n
join locations l on l.id = n.id and l.location_type = 'dive_site'
where exists (select 1 from bookable_products bp where bp.id = n.id);
-- expect 0 rows — a dive site must never become a bookable product

\echo '=== 8. Every dive site has location_type = dive_site, a real parent location, and a valid site_type attribute ==='
select n.slug from nodes n
join locations l on l.id = n.id and l.location_type = 'dive_site'
where l.parent_id is null or not exists (select 1 from locations p where p.id = l.parent_id);
-- expect 0 rows (every dive site is parented under a real atoll)

select n.slug, n.attributes->>'site_type' as site_type
from nodes n join locations l on l.id = n.id and l.location_type = 'dive_site'
where n.attributes->>'site_type' is not null
  and n.attributes->>'site_type' not in ('reef','thila','channel','wreck','pinnacle','wall','cave');
-- expect 0 rows

\echo '=== 9. Dive sites are never activities (no row in the activities table for a dive-site node) ==='
select n.slug from nodes n
join locations l on l.id = n.id and l.location_type = 'dive_site'
where exists (select 1 from activities a where a.id = n.id);
-- expect 0 rows

\echo '=== 10. Secondary node_locations (dive-site nearby-island links, activity site visits) point at real locations ==='
select nl.node_id, nl.location_id from node_locations nl
where nl.relation = 'secondary'
  and not exists (select 1 from locations l where l.id = nl.location_id);
-- expect 0 rows

\echo '=== 11. location_type_hierarchy_rules were respected (no bypass) — every dive site parent is atoll or island ==='
select n.slug, p.location_type as parent_type
from nodes n
join locations l on l.id = n.id and l.location_type = 'dive_site'
join locations p on p.id = l.parent_id
where p.location_type not in ('atoll', 'island');
-- expect 0 rows

\echo '=== 12. Total location count (Task 4/5 seeded 221; diving adds 12 dive sites, no other new locations) ==='
select count(*) from locations;

\echo '=== 13. Diving-type categories seeded (only types actually used) ==='
select n.slug, n.title from nodes n join categories c on c.id = n.id
where c.category_group = 'activity-type' and n.slug like '%diving%' or n.slug = 'dive-courses'
order by n.title;

\echo '=== 14. Diving activities with location, provider, and type ==='
select n.title, ln.title as island, atn.title as atoll, pn.title as provider,
       string_agg(distinct ctn.title, ', ') as diving_types, a.duration_minutes, a.min_age, a.difficulty, a.price_from
from nodes n
join activities a on a.id = n.id and a.activity_category = 'diving'
join node_locations nl on nl.node_id = n.id and nl.relation = 'primary'
join locations l on l.id = nl.location_id
join nodes ln on ln.id = l.id
left join locations al on al.id = l.parent_id
left join nodes atn on atn.id = al.id
left join nodes pn on pn.id = a.operated_by_provider_id
left join node_categories nc on nc.node_id = n.id
left join nodes ctn on ctn.id = nc.category_id
group by n.title, ln.title, atn.title, pn.title, a.duration_minutes, a.min_age, a.difficulty, a.price_from
order by n.title;

\echo '=== 15. Dive sites with atoll, nearby island, type, and depth ==='
select n.title as site, atn.title as atoll, iln.title as nearby_island,
       n.attributes->>'site_type' as site_type,
       n.attributes->>'depth_min_meters' as depth_min, n.attributes->>'depth_max_meters' as depth_max,
       n.attributes->>'experience_level' as experience_level
from nodes n
join locations l on l.id = n.id and l.location_type = 'dive_site'
left join locations al on al.id = l.parent_id
left join nodes atn on atn.id = al.id
left join node_locations nl on nl.node_id = n.id and nl.relation = 'secondary'
left join locations il on il.id = nl.location_id and il.location_type = 'island'
left join nodes iln on iln.id = il.id
order by n.title;

\echo '=== 16. Providers: accommodations + all activities + diving specifically ==='
select pn.title as provider,
  (select count(*) from accommodations acc where acc.operated_by_provider_id = pn.id) as accommodations,
  (select count(*) from activities act where act.operated_by_provider_id = pn.id and act.activity_category <> 'diving') as other_activities,
  (select count(*) from activities act where act.operated_by_provider_id = pn.id and act.activity_category = 'diving') as diving_activities
from nodes pn
where pn.node_type = 'provider'
order by pn.title;

\echo '=== DONE ==='
