-- Task 9 data verification (dev-only, run manually — not a migration).

\echo '=== Row counts ==='
select
  (select count(*) from activities where activity_category = 'surfing')     as surfing_activities,
  (select count(*) from locations where location_type = 'surf_break')       as surf_breaks,
  (select count(*) from nodes where node_type = 'provider')                 as providers_total,
  (select count(*) from categories where category_group = 'activity-type')  as activity_type_categories;

\echo '=== 1. Every surfing activity node has a matching activities row ==='
select n.id, n.slug from nodes n
join activities a on a.id = n.id
where a.activity_category = 'surfing'
  and n.node_type <> 'activity';
-- expect 0 rows (node_type mismatch would be impossible given FK, sanity check only)

\echo '=== 2. No duplicate slugs among activities, providers, or surf-break locations ==='
select slug, count(*) from nodes where node_type = 'activity' group by slug having count(*) > 1;
-- expect 0 rows
select title, count(*) from nodes where node_type = 'provider' group by title having count(*) > 1;
-- expect 0 rows
select n.slug, count(*) from nodes n join locations l on l.id = n.id
where l.location_type = 'surf_break' group by n.slug having count(*) > 1;
-- expect 0 rows (confirms the two "Wave Surfing" entries from different
-- operators did not collapse into, or collide with, existing Task 6 nodes)

\echo '=== 3. Every surfing activity has exactly one primary location, referencing a real location ==='
select n.slug, count(*) filter (where nl.relation = 'primary') as primary_count
from nodes n
join activities a on a.id = n.id and a.activity_category = 'surfing'
join node_locations nl on nl.node_id = n.id
group by n.slug
having count(*) filter (where nl.relation = 'primary') <> 1;
-- expect 0 rows

select n.slug
from nodes n
join activities a on a.id = n.id and a.activity_category = 'surfing'
join node_locations nl on nl.node_id = n.id and nl.relation = 'primary'
where not exists (select 1 from locations l where l.id = nl.location_id);
-- expect 0 rows

\echo '=== 4. Every operated_by_provider_id references a real provider node ==='
select n.slug from activities a join nodes n on n.id = a.id
where a.activity_category = 'surfing' and a.operated_by_provider_id is not null
  and not exists (select 1 from nodes p where p.id = a.operated_by_provider_id and p.node_type = 'provider');
-- expect 0 rows

\echo '=== 5. Every surf-type category tag on a surfing activity is real and correctly grouped ==='
select n.slug as activity_slug, nc.category_id
from nodes n
join activities a on a.id = n.id and a.activity_category = 'surfing'
join node_categories nc on nc.node_id = n.id
where not exists (
  select 1 from categories c where c.id = nc.category_id and c.category_group = 'activity-type'
);
-- expect 0 rows

\echo '=== 6. bookable_products: valid FK, every surfing activity IS bookable ==='
select bp.id from bookable_products bp
where not exists (select 1 from nodes n where n.id = bp.id and n.node_type in ('accommodation','activity','package'));
-- expect 0 rows
select n.slug from nodes n
join activities a on a.id = n.id and a.activity_category = 'surfing'
where not exists (select 1 from bookable_products bp where bp.id = n.id);
-- expect 0 rows

\echo '=== 7. CRITICAL: no surf break ever has a bookable_products row ==='
select n.slug from nodes n
join locations l on l.id = n.id and l.location_type = 'surf_break'
where exists (select 1 from bookable_products bp where bp.id = n.id);
-- expect 0 rows — a surf break must never become a bookable product

\echo '=== 8. Every surf break has location_type = surf_break, a real parent location, and a valid break_type attribute ==='
select n.slug from nodes n
join locations l on l.id = n.id and l.location_type = 'surf_break'
where l.parent_id is null or not exists (select 1 from locations p where p.id = l.parent_id);
-- expect 0 rows (every surf break is parented under a real atoll)

select n.slug, n.attributes->>'break_type' as break_type
from nodes n join locations l on l.id = n.id and l.location_type = 'surf_break'
where n.attributes->>'break_type' is not null
  and n.attributes->>'break_type' not in ('reef_break','point_break','beach_break','channel');
-- expect 0 rows

\echo '=== 9. Surf breaks are never activities (no row in the activities table for a surf-break node) ==='
select n.slug from nodes n
join locations l on l.id = n.id and l.location_type = 'surf_break'
where exists (select 1 from activities a where a.id = n.id);
-- expect 0 rows

\echo '=== 10. Secondary node_locations (surf-break nearby-island links, activity break visits) point at real locations ==='
select nl.node_id, nl.location_id from node_locations nl
where nl.relation = 'secondary'
  and not exists (select 1 from locations l where l.id = nl.location_id);
-- expect 0 rows

\echo '=== 11. location_type_hierarchy_rules were respected (no bypass) — every surf break parent is atoll or island ==='
select n.slug, p.location_type as parent_type
from nodes n
join locations l on l.id = n.id and l.location_type = 'surf_break'
join locations p on p.id = l.parent_id
where p.location_type not in ('atoll', 'island');
-- expect 0 rows

\echo '=== 12. Total location count (Task 4/5 seeded 221; diving added 12 dive sites; surfing adds 13 surf breaks) ==='
select count(*) from locations;

\echo '=== 13. Surf-type categories seeded (only types actually used) ==='
select n.slug, n.title from nodes n join categories c on c.id = n.id
where c.category_group = 'activity-type' and (n.slug like '%surf%' or n.slug = 'board-rental')
order by n.title;

\echo '=== 14. Surfing activities with location, provider, and type ==='
select n.title, ln.title as island, atn.title as atoll, pn.title as provider,
       string_agg(distinct ctn.title, ', ') as surf_types, a.duration_minutes, a.max_participants, a.difficulty, a.price_from
from nodes n
join activities a on a.id = n.id and a.activity_category = 'surfing'
join node_locations nl on nl.node_id = n.id and nl.relation = 'primary'
join locations l on l.id = nl.location_id
join nodes ln on ln.id = l.id
left join locations al on al.id = l.parent_id
left join nodes atn on atn.id = al.id
left join nodes pn on pn.id = a.operated_by_provider_id
left join node_categories nc on nc.node_id = n.id
left join nodes ctn on ctn.id = nc.category_id
group by n.title, ln.title, atn.title, pn.title, a.duration_minutes, a.max_participants, a.difficulty, a.price_from
order by n.title;

\echo '=== 15. Surf breaks with atoll, nearby island, type, and difficulty ==='
select n.title as surf_break, atn.title as atoll, iln.title as nearby_island,
       n.attributes->>'break_type' as break_type,
       n.attributes->>'difficulty' as difficulty
from nodes n
join locations l on l.id = n.id and l.location_type = 'surf_break'
left join locations al on al.id = l.parent_id
left join nodes atn on atn.id = al.id
left join node_locations nl on nl.node_id = n.id and nl.relation = 'secondary'
left join locations il on il.id = nl.location_id and il.location_type = 'island'
left join nodes iln on iln.id = il.id
order by n.title;

\echo '=== 16. Activity-to-surf-break "visits" links (secondary node_locations from an activity to a named break) ==='
select an.title as activity, bn.title as surf_break
from node_locations nl
join nodes an on an.id = nl.node_id and an.node_type = 'activity'
join locations bl on bl.id = nl.location_id and bl.location_type = 'surf_break'
join nodes bn on bn.id = bl.id
where nl.relation = 'secondary'
order by an.title, bn.title;

\echo '=== 17. Providers: accommodations + all activities + surfing specifically ==='
select pn.title as provider,
  (select count(*) from accommodations acc where acc.operated_by_provider_id = pn.id) as accommodations,
  (select count(*) from activities act where act.operated_by_provider_id = pn.id and act.activity_category <> 'surfing') as other_activities,
  (select count(*) from activities act where act.operated_by_provider_id = pn.id and act.activity_category = 'surfing') as surfing_activities
from nodes pn
where pn.node_type = 'provider'
order by pn.title;

\echo '=== DONE ==='
