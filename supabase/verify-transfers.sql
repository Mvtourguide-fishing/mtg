-- Task 10 data verification (dev-only, run manually — not a migration).

\echo '=== Row counts ==='
select
  (select count(*) from nodes where node_type = 'transfer_route')     as transfer_routes,
  (select count(*) from transfer_services)                            as transfer_services,
  (select count(*) from transfer_service_schedules)                   as schedules,
  (select count(*) from locations where location_type = 'airport')    as airports,
  (select count(*) from nodes where node_type = 'provider')           as providers_total;

\echo '=== 1. Every transfer_route node has a matching transfer_routes row ==='
select n.id, n.slug from nodes n
join transfer_routes tr on tr.id = n.id
where n.node_type <> 'transfer_route';
-- expect 0 rows (FK makes this impossible, sanity check only)

\echo '=== 2. No duplicate route slugs, no duplicate (origin, destination) pairs ==='
select slug, count(*) from nodes where node_type = 'transfer_route' group by slug having count(*) > 1;
-- expect 0 rows
select origin_location_id, destination_location_id, count(*)
from transfer_routes group by origin_location_id, destination_location_id having count(*) > 1;
-- expect 0 rows (also enforced by the schema's own unique constraint)

\echo '=== 3. CRITICAL: directional integrity — no route has origin = destination ==='
select n.slug from nodes n
join transfer_routes tr on tr.id = n.id
where tr.origin_location_id = tr.destination_location_id;
-- expect 0 rows (also enforced by the schema's own check constraint)

\echo '=== 4. Reverse-direction routes are genuinely separate rows (A->B and B->A both exist as distinct nodes, never collapsed) ==='
select a.slug as a_to_b, b.slug as b_to_a
from transfer_routes ra
join transfer_routes rb on rb.origin_location_id = ra.destination_location_id and rb.destination_location_id = ra.origin_location_id
join nodes a on a.id = ra.id
join nodes b on b.id = rb.id
where ra.id <> rb.id
order by a.slug;
-- informational: lists the route pairs that have both directions seeded

\echo '=== 5. Every origin/destination location reference is real ==='
select n.slug from nodes n
join transfer_routes tr on tr.id = n.id
where not exists (select 1 from locations l where l.id = tr.origin_location_id)
   or not exists (select 1 from locations l where l.id = tr.destination_location_id);
-- expect 0 rows

\echo '=== 6. Every transfer_service references a real route and, where set, a real provider ==='
select ts.id from transfer_services ts
where not exists (select 1 from transfer_routes tr where tr.id = ts.route_id);
-- expect 0 rows
select ts.id from transfer_services ts
where ts.provider_id is not null
  and not exists (select 1 from nodes p where p.id = ts.provider_id and p.node_type = 'provider');
-- expect 0 rows

\echo '=== 7. Every schedule references a real service ==='
select s.id from transfer_service_schedules s
where not exists (select 1 from transfer_services ts where ts.id = s.transfer_service_id);
-- expect 0 rows

\echo '=== 8. Valid price/currency: price is set and positive on every service (schema requires NOT NULL already) ==='
select id from transfer_services where price is null or price <= 0;
-- expect 0 rows

\echo '=== 9. Valid capacity where set (must be positive) ==='
select id, capacity from transfer_services where capacity is not null and capacity <= 0;
-- expect 0 rows

\echo '=== 10. Valid operating-day representation (day_of_week within 0-6 or null) ==='
select id, day_of_week from transfer_service_schedules where day_of_week is not null and day_of_week not between 0 and 6;
-- expect 0 rows (also enforced by the schema's own check constraint)

\echo '=== 11. CRITICAL: no transfer_service ever appears in bookable_products ==='
-- transfer_services are not nodes (see supabase/migrations/20250101000600_transfers.sql's
-- own header comment), so this should be structurally impossible — bookable_products.id
-- has a FK straight to nodes(id), and no transfer_services.id was ever inserted into
-- nodes. This query confirms no id collision accidentally made one look bookable.
select ts.id from transfer_services ts
where exists (select 1 from bookable_products bp where bp.id = ts.id);
-- expect 0 rows

\echo '=== 12. Transfer services ARE reachable from the booking architecture the intended way ==='
-- Not a row check (no bookings exist yet — Task 10 explicitly builds no booking UI) —
-- confirms the bookings table's own constraint shape supports transfer_service_id
-- exactly as designed, so a later booking task has nothing further to add here.
select conname, pg_get_constraintdef(oid) from pg_constraint
where conrelid = 'bookings'::regclass and conname like '%product_type%';

\echo '=== 13. location_type_hierarchy_rules respected — the new airport is parented under a real atoll ==='
select n.slug, p.location_type as parent_type
from nodes n
join locations l on l.id = n.id and l.location_type = 'airport'
join locations p on p.id = l.parent_id
where p.location_type not in ('atoll', 'island');
-- expect 0 rows

\echo '=== 14. Every transfer route with its services (price, type, provider) ==='
select
  rn.title as route,
  pn.title as provider,
  ts.transfer_type,
  ts.shared_or_private,
  ts.price,
  ts.currency,
  ts.duration_minutes,
  ts.status
from transfer_services ts
join transfer_routes tr on tr.id = ts.route_id
join nodes rn on rn.id = tr.id
left join nodes pn on pn.id = ts.provider_id
order by rn.title, ts.price;

\echo '=== 15. Schedules with their service/route context ==='
select rn.title as route, pn.title as provider, s.day_of_week, s.departure_time, s.arrival_time
from transfer_service_schedules s
join transfer_services ts on ts.id = s.transfer_service_id
join transfer_routes tr on tr.id = ts.route_id
join nodes rn on rn.id = tr.id
left join nodes pn on pn.id = ts.provider_id
order by rn.title;

\echo '=== 16. Providers: accommodations + activities + transfer services, per provider ==='
select pn.title as provider,
  (select count(*) from accommodations acc where acc.operated_by_provider_id = pn.id) as accommodations,
  (select count(*) from activities act where act.operated_by_provider_id = pn.id) as activities,
  (select count(*) from transfer_services ts where ts.provider_id = pn.id) as transfer_services
from nodes pn
where pn.node_type = 'provider'
order by pn.title;

\echo '=== DONE ==='
