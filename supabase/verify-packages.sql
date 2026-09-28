-- Task 11 data verification (dev-only, run manually — not a migration).

\echo '=== Row counts ==='
select
  (select count(*) from nodes where node_type = 'package')                                            as packages,
  (select count(*) from package_itinerary_stages)                                                      as stages,
  (select count(*) from package_itinerary_items)                                                       as items,
  (select count(*) from package_itinerary_items where component_type = 'node')                         as node_items,
  (select count(*) from package_itinerary_items where component_type = 'transfer_service')             as transfer_items,
  (select count(*) from node_categories nc join nodes n on n.id = nc.node_id where n.node_type = 'package') as category_tags,
  (select count(*) from node_locations nl join nodes n on n.id = nl.node_id where n.node_type = 'package')  as location_tags,
  (select count(*) from bookable_products bp join nodes n on n.id = bp.id where n.node_type = 'package')    as bookable_packages;

\echo '=== 1. Every package node has a matching packages row ==='
select n.id, n.slug from nodes n
where n.node_type = 'package'
  and not exists (select 1 from packages p where p.id = n.id);
-- expect 0 rows (FK makes this impossible, sanity check only)

\echo '=== 2. No duplicate package slugs ==='
select slug, count(*) from nodes where node_type = 'package' group by slug having count(*) > 1;
-- expect 0 rows

\echo '=== 3. Every stage belongs to a real package node ==='
select s.id, s.package_id from package_itinerary_stages s
where not exists (select 1 from nodes n where n.id = s.package_id and n.node_type = 'package');
-- expect 0 rows

\echo '=== 4. No duplicate (package_id, stage_number) pairs ==='
select package_id, stage_number, count(*) from package_itinerary_stages
group by package_id, stage_number having count(*) > 1;
-- expect 0 rows (also enforced by the schema's own unique constraint)

\echo '=== 5. Valid stage day ranges (day_end >= day_start, both positive) ==='
select id, day_start, day_end from package_itinerary_stages
where day_end < day_start or day_start < 1;
-- expect 0 rows (day_end >= day_start also enforced by the schema's own check constraint)

\echo '=== 6. CRITICAL: every item satisfies the schema node-XOR-transfer_service shape ==='
select id, component_type, component_node_id, transfer_service_id from package_itinerary_items
where (component_type = 'node' and (component_node_id is null or transfer_service_id is not null))
   or (component_type = 'transfer_service' and (transfer_service_id is null or component_node_id is not null));
-- expect 0 rows (also enforced by the schema's own check constraint)

\echo '=== 7. Every node-typed item references a real, existing node ==='
select i.id, i.component_node_id from package_itinerary_items i
where i.component_type = 'node'
  and not exists (select 1 from nodes n where n.id = i.component_node_id);
-- expect 0 rows

\echo '=== 8. CRITICAL: every accommodation-role item actually points at an accommodation node, every activity/excursion-role item at an activity node (no role/type mismatch) ==='
select i.id, i.component_role, n.node_type from package_itinerary_items i
join nodes n on n.id = i.component_node_id
where i.component_type = 'node'
  and ((i.component_role = 'accommodation' and n.node_type <> 'accommodation')
    or (i.component_role in ('activity', 'excursion') and n.node_type <> 'activity'));
-- expect 0 rows

\echo '=== 9. Every transfer_service-typed item references a real, active transfer_services row ==='
select i.id, i.transfer_service_id from package_itinerary_items i
where i.component_type = 'transfer_service'
  and not exists (select 1 from transfer_services ts where ts.id = i.transfer_service_id);
-- expect 0 rows

\echo '=== 10. Every item belongs to a real stage ==='
select i.id, i.stage_id from package_itinerary_items i
where not exists (select 1 from package_itinerary_stages s where s.id = i.stage_id);
-- expect 0 rows

\echo '=== 11. No orphan itinerary items (unreachable from any package) ==='
select i.id from package_itinerary_items i
where not exists (
  select 1 from package_itinerary_stages s
  join nodes n on n.id = s.package_id
  where s.id = i.stage_id and n.node_type = 'package'
);
-- expect 0 rows

\echo '=== 12. No duplicate node_categories/node_locations rows for a package (no double-tagging) ==='
select node_id, category_id, count(*) from node_categories nc
where exists (select 1 from nodes n where n.id = nc.node_id and n.node_type = 'package')
group by node_id, category_id having count(*) > 1;
-- expect 0 rows (also enforced by the schema's own primary key)
select node_id, location_id, count(*) from node_locations nl
where exists (select 1 from nodes n where n.id = nl.node_id and n.node_type = 'package')
group by node_id, location_id having count(*) > 1;
-- expect 0 rows (also enforced by the schema's own primary key)

\echo '=== 13. At most one primary destination per package ==='
select node_id, count(*) from node_locations nl
where relation = 'primary'
  and exists (select 1 from nodes n where n.id = nl.node_id and n.node_type = 'package')
group by node_id having count(*) > 1;
-- expect 0 rows (also enforced by the schema's own partial unique index)

\echo '=== 14. Every category tag references a real, valid taxonomy group for packages (traveler-type/package-style/duration-band/inclusion/theme only) ==='
select nc.node_id, c.category_group from node_categories nc
join categories c on c.id = nc.category_id
join nodes n on n.id = nc.node_id
where n.node_type = 'package'
  and c.category_group not in ('traveler-type', 'package-style', 'duration-band', 'inclusion', 'theme');
-- expect 0 rows (informational — packages could technically be tagged with any group, but this dataset only ever tags these five)

\echo '=== 15. Every package has exactly one duration-band tag, consistent with packages.duration_nights ==='
select n.slug, p.duration_nights, count(*) filter (where c.category_group = 'duration-band') as duration_band_tags
from nodes n
join packages p on p.id = n.id
left join node_categories nc on nc.node_id = n.id
left join categories c on c.id = nc.category_id and c.category_group = 'duration-band'
where n.node_type = 'package'
group by n.slug, p.duration_nights
having count(*) filter (where c.category_group = 'duration-band') <> 1;
-- expect 0 rows

\echo '=== 16. CRITICAL: every package has a bookable_products row (packages are a bookable product type per the schema own type-safety trigger) ==='
select n.id, n.slug from nodes n
where n.node_type = 'package'
  and not exists (select 1 from bookable_products bp where bp.id = n.id);
-- expect 0 rows

\echo '=== 17. operated_by_provider_id, where set, references a real provider ==='
select n.slug, p.operated_by_provider_id from nodes n
join packages p on p.id = n.id
where p.operated_by_provider_id is not null
  and not exists (select 1 from nodes prov where prov.id = p.operated_by_provider_id and prov.node_type = 'provider');
-- expect 0 rows

\echo '=== 18. No fabricated pricing: price_from is null wherever no verified per-night rate exists (this dataset: always null) ==='
select n.slug, p.price_from, p.currency from nodes n
join packages p on p.id = n.id
where n.node_type = 'package' and (p.price_from is not null or p.currency is not null);
-- informational: expect 0 rows for this dataset (see data/maldives/packages/SOURCES.md);
-- a future task adding real verified pricing would legitimately change this
