-- Functional verification script (not a migration — dev-only, run manually
-- against a test database). Exercises the security/integrity rules from
-- Task 2 Revision 3 against the applied schema.

\set ON_ERROR_STOP off
\echo '=== 1. RLS enabled on every table? (expect: empty result set) ==='
select relname
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public' and c.relkind = 'r' and not c.relrowsecurity;

\echo '=== 2. Seed data present ==='
select category_group, count(*) from categories group by category_group order by 1;
select key, value from platform_settings;
select count(*) from location_type_hierarchy_rules;

\echo '=== 3. Build a minimal valid location chain: country -> atoll -> island(s) ==='
with n as (insert into nodes (node_type, slug, title, status) values ('location', 'test-maldives', 'Test Maldives', 'published') returning id)
insert into locations (id, location_type, path) select id, 'country', 'test_maldives'::ltree from n
returning id as country_id \gset

with n as (insert into nodes (node_type, slug, title, status) values ('location', 'test-atoll', 'Test Atoll', 'published') returning id)
insert into locations (id, location_type, parent_id, path)
select id, 'atoll', :'country_id', (select path from locations where id = :'country_id') || 'test_atoll'::ltree from n
returning id as atoll_id \gset

with n as (insert into nodes (node_type, slug, title, status) values ('location', 'test-island-a', 'Test Island A', 'published') returning id)
insert into locations (id, location_type, parent_id, path)
select id, 'island', :'atoll_id', (select path from locations where id = :'atoll_id') || 'test_island_a'::ltree from n
returning id as island_a_id \gset

with n as (insert into nodes (node_type, slug, title, status) values ('location', 'test-island-b', 'Test Island B', 'published') returning id)
insert into locations (id, location_type, parent_id, path)
select id, 'island', :'atoll_id', (select path from locations where id = :'atoll_id') || 'test_island_b'::ltree from n
returning id as island_b_id \gset
select id, location_type, path from locations where id in (:'country_id', :'atoll_id', :'island_a_id', :'island_b_id') order by nlevel(path);

\echo '=== 4. Location hierarchy trigger correctly rejects invalid combinations ==='
insert into nodes (node_type, slug, title, status) values ('location', 'test-bad-root', 'Bad Root', 'draft');
with n as (select id from nodes where slug = 'test-bad-root')
insert into locations (id, location_type, parent_id, path) select id, 'island', null, 'bad_root'::ltree from n;
-- expected: ERROR — location_type island is not permitted as a root location

with n as (insert into nodes (node_type, slug, title, status) values ('location', 'test-island-c', 'Island under Island', 'draft') returning id)
insert into locations (id, location_type, parent_id, path) select id, 'island', :'island_a_id', 'x'::ltree from n;
-- expected: ERROR — location_type island is not a permitted child of parent type island

\echo '=== 5. Create a test bookable accommodation on Island A (staff/postgres bypasses RLS) ==='
with n as (
  insert into nodes (node_type, slug, title, status, published_at)
  values ('accommodation', 'test-hotel', 'Test Hotel', 'published', now())
  returning id
)
insert into accommodations (id, accommodation_type)
select id, 'hotel' from n
returning id as test_hotel_id \gset
insert into node_locations (node_id, location_id, relation) values (:'test_hotel_id', :'island_a_id', 'primary');
insert into bookable_products (id) values (:'test_hotel_id');
\echo 'bookable accommodation created and located: OK'

\echo '=== 6. Bookable-product type safety: reject a non-bookable node type ==='
insert into bookable_products (id) values (:'island_a_id');
-- expected: ERROR — node_type location may not be marked bookable

\echo '=== 7. node_locations: at most one primary per node ==='
insert into node_locations (node_id, location_id, relation) values (:'test_hotel_id', :'island_b_id', 'primary');
-- expected: ERROR — duplicate key on partial unique index (already has a primary)
insert into node_locations (node_id, location_id, relation) values (:'test_hotel_id', :'island_b_id', 'secondary');
\echo 'second secondary location on same node: OK'

\echo '=== 8. Booking reference generation, uniqueness, via the guest RPC ==='
set role anon;
select (create_booking_inquiry(
  'node', :'test_hotel_id', null,
  'Jane Guest', 'jane@example.com', null, null,
  null, null, current_date + 10, null, null, null, 'one_way',
  2, 0, 0, null, 'Sea view please', 250.00, 'USD'
)).*;
select (create_booking_inquiry(
  'node', :'test_hotel_id', null,
  'John Guest', 'john@example.com', null, null,
  null, null, current_date + 12, null, null, null, 'one_way',
  1, 0, 0, null, null, 120.00, 'USD'
)).*;
reset role;
select booking_reference, customer_name, status, notification_status, user_id, product_type
from bookings order by created_at;

\echo '=== 9. Anon cannot read or directly write bookings (table-level RLS) ==='
set role anon;
select count(*) as anon_visible_bookings from bookings;   -- expect 0 (RLS filters all rows, no error)
insert into bookings (booking_reference, product_type, product_node_id, customer_name, customer_email)
values ('FAKE-REF', 'node', :'test_hotel_id', 'Hacker', 'hacker@example.com');
-- expected: ERROR (blocked before completion — either RLS on bookings or, since the
-- BEFORE INSERT trigger runs first, RLS on booking_reference_counters; both are
-- correct evidence a direct anon insert cannot succeed)
reset role;

\echo '=== 10. create_booking_inquiry() exposes no staff-only parameters ==='
select p.parameter_name
from information_schema.routines r
join information_schema.parameters p on p.specific_name = r.specific_name
where r.routine_name = 'create_booking_inquiry'
  and p.parameter_name in ('p_status','p_booking_reference','p_internal_notes','p_notification_status');
-- expected: 0 rows

\echo '=== 11. Transfer route directionality + uniqueness + origin<>destination ==='
with n as (insert into nodes (node_type, slug, title, status) values ('transfer_route', 'a-to-b', 'A to B', 'published') returning id)
insert into transfer_routes (id, origin_location_id, destination_location_id)
select id, :'island_a_id', :'island_b_id' from n returning id as route_ab_id \gset

with n as (insert into nodes (node_type, slug, title, status) values ('transfer_route', 'b-to-a', 'B to A', 'published') returning id)
insert into transfer_routes (id, origin_location_id, destination_location_id)
select id, :'island_b_id', :'island_a_id' from n returning id as route_ba_id \gset
\echo 'A->B and B->A both created independently: OK'

with n as (insert into nodes (node_type, slug, title, status) values ('transfer_route', 'a-to-b-dupe', 'A to B dupe', 'published') returning id)
insert into transfer_routes (id, origin_location_id, destination_location_id)
select id, :'island_a_id', :'island_b_id' from n;
-- expected: ERROR — duplicate key value violates unique constraint (same direction twice)

with n as (insert into nodes (node_type, slug, title, status) values ('transfer_route', 'a-to-a', 'A to A', 'published') returning id)
insert into transfer_routes (id, origin_location_id, destination_location_id)
select id, :'island_a_id', :'island_a_id' from n;
-- expected: ERROR — check constraint violation (origin = destination)

\echo '=== 12. package itinerary: exactly-one-branch check ==='
with pkg as (insert into nodes (node_type, slug, title, status) values ('package', 'test-package', 'Test Package', 'published') returning id)
insert into packages (id, duration_nights) select id, 7 from pkg returning id as test_package_id \gset

insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title)
values (:'test_package_id', 1, 1, 4, 4, 'Stage 1 — Hotel A')
returning id as stage1_id \gset

insert into package_itinerary_items (stage_id, component_type, component_node_id, transfer_service_id, component_role)
values (:'stage1_id', 'node', :'test_hotel_id', :'route_ab_id', 'accommodation');
-- expected: ERROR — check constraint (both branches populated — route_ab_id isn't even
-- a transfer_service id, but the check fails before that would matter)

insert into package_itinerary_items (stage_id, component_type, component_node_id, transfer_service_id, component_role)
values (:'stage1_id', 'node', null, null, 'accommodation');
-- expected: ERROR — check constraint (neither branch populated)

insert into package_itinerary_items (stage_id, component_type, component_node_id, transfer_service_id, component_role)
values (:'stage1_id', 'node', :'test_hotel_id', null, 'accommodation');
\echo 'valid single-branch itinerary item: OK'

\echo '=== 13. profiles.role: no self-escalation ==='
insert into auth.users (id, email) values ('11111111-1111-1111-1111-111111111111', 'user@example.com');
-- profiles row auto-created by handle_new_auth_user() trigger
set role authenticated;
set request.jwt.claim.sub = '11111111-1111-1111-1111-111111111111';
update profiles set role = 'admin' where id = '11111111-1111-1111-1111-111111111111';
-- expected: ERROR — only an admin may change profiles.role (trigger fires; RLS already let the row through)
select role from profiles where id = '11111111-1111-1111-1111-111111111111';  -- expect still 'user'
update profiles set display_name = 'Jane U.' where id = '11111111-1111-1111-1111-111111111111';
\echo 'non-role self-update still works: OK'
reset role;
reset request.jwt.claim.sub;

\echo '=== 14. redirect chain prevention (both directions) ==='
insert into url_redirects (source_path, target_type, target_path) values ('/old-a', 'path', '/old-b');
insert into url_redirects (source_path, target_type, target_path) values ('/old-b', 'path', '/final');
-- expected: ERROR — /old-b is already the target of another active redirect
insert into url_redirects (source_path, target_type, target_path) values ('/old-c', 'path', '/old-a');
-- expected: ERROR — /old-a is itself an active redirect source

\echo '=== DONE ==='
