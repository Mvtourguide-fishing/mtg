-- Task 5 data verification (dev-only, run manually — not a migration).

\echo '=== Row counts ==='
select
  (select count(*) from nodes where node_type = 'provider')      as providers,
  (select count(*) from nodes where node_type = 'accommodation') as accommodations,
  (select count(*) from locations where is_inhabited = false)    as new_resort_islands;

\echo '=== 1. Every accommodation node has a matching accommodations row, and vice versa ==='
select n.id, n.slug from nodes n
where n.node_type = 'accommodation'
  and not exists (select 1 from accommodations a where a.id = n.id);
-- expect 0 rows
select a.id from accommodations a
where not exists (select 1 from nodes n where n.id = a.id and n.node_type = 'accommodation');
-- expect 0 rows

\echo '=== 2. accommodation_type is always one of the valid enum values (constraint already enforces; sanity check) ==='
select distinct accommodation_type from accommodations order by 1;

\echo '=== 3. Every accommodation has exactly one primary location ==='
select n.slug, count(*) filter (where nl.relation = 'primary') as primary_count
from nodes n
join node_locations nl on nl.node_id = n.id
where n.node_type = 'accommodation'
group by n.slug
having count(*) filter (where nl.relation = 'primary') <> 1;
-- expect 0 rows

\echo '=== 4. Every accommodation''s primary location is a real, valid location row ==='
select n.slug
from nodes n
join node_locations nl on nl.node_id = n.id and nl.relation = 'primary'
where n.node_type = 'accommodation'
  and not exists (select 1 from locations l where l.id = nl.location_id);
-- expect 0 rows

\echo '=== 5. No duplicate accommodation slugs (constraint sanity check) ==='
select slug, count(*) from nodes where node_type = 'accommodation' group by slug having count(*) > 1;
-- expect 0 rows

\echo '=== 6. No duplicate provider slugs / no accidental duplicate providers by name ==='
select slug, count(*) from nodes where node_type = 'provider' group by slug having count(*) > 1;
-- expect 0 rows
select title, count(*) from nodes where node_type = 'provider' group by title having count(*) > 1;
-- expect 0 rows (same company should never appear as two provider nodes)

\echo '=== 7. Every operated_by_provider_id references a real provider node ==='
select n.slug, a.operated_by_provider_id
from accommodations a join nodes n on n.id = a.id
where a.operated_by_provider_id is not null
  and not exists (
    select 1 from nodes p where p.id = a.operated_by_provider_id and p.node_type = 'provider'
  );
-- expect 0 rows

\echo '=== 8. bookable_products relationships are valid (only accommodation/activity/package nodes) ==='
select bp.id from bookable_products bp
where not exists (
  select 1 from nodes n where n.id = bp.id and n.node_type in ('accommodation','activity','package')
);
-- expect 0 rows (also enforced by the Task 3 trigger at insert time)

\echo '=== 9. Every accommodation is bookable (Task 5 connects them all to bookable_products) ==='
select n.slug from nodes n
where n.node_type = 'accommodation'
  and not exists (select 1 from bookable_products bp where bp.id = n.id);
-- expect 0 rows

\echo '=== 10. New resort-island locations are correctly parented to a real atoll ==='
select n.slug as island_slug, pn.slug as atoll_slug, pl.location_type
from locations l
join nodes n on n.id = l.id
join locations pl on pl.id = l.parent_id
join nodes pn on pn.id = pl.id
where l.is_inhabited = false;

\echo '=== 11. Accommodations per type, with island/atoll ==='
select n.title, a.accommodation_type, ln.title as island, atn.title as atoll, a.star_rating, a.operated_by_provider_id is not null as has_provider
from nodes n
join accommodations a on a.id = n.id
join node_locations nl on nl.node_id = n.id and nl.relation = 'primary'
join locations l on l.id = nl.location_id
join nodes ln on ln.id = l.id
left join locations al on al.id = l.parent_id
left join nodes atn on atn.id = al.id
order by a.accommodation_type, n.title;

\echo '=== 12. Providers and what they operate ==='
select pn.title as provider, string_agg(n.title, ', ' order by n.title) as accommodations
from nodes pn
left join accommodations a on a.operated_by_provider_id = pn.id
left join nodes n on n.id = a.id
where pn.node_type = 'provider'
group by pn.title
order by pn.title;

\echo '=== DONE ==='
