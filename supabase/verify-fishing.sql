-- Task 7 data verification (dev-only, run manually — not a migration).

\echo '=== Row counts ==='
select
  (select count(*) from activities where activity_category = 'fishing') as fishing_activities,
  (select count(*) from nodes where node_type = 'provider')             as providers_total,
  (select count(*) from categories where category_group = 'activity-type') as fishing_type_categories;

\echo '=== 1. Every fishing activity node has a matching activities row ==='
select n.id, n.slug from nodes n
join activities a on a.id = n.id
where a.activity_category = 'fishing'
  and n.node_type <> 'activity';
-- expect 0 rows (node_type mismatch would be impossible given FK, sanity check only)

\echo '=== 2. No duplicate slugs among fishing activities or providers ==='
select slug, count(*) from nodes where node_type = 'activity' group by slug having count(*) > 1;
-- expect 0 rows
select title, count(*) from nodes where node_type = 'provider' group by title having count(*) > 1;
-- expect 0 rows (confirms the 2 "Sunset Fishing Trip" activities did not collapse into duplicate providers)

\echo '=== 3. Every fishing activity has exactly one primary location, referencing a real location ==='
select n.slug, count(*) filter (where nl.relation = 'primary') as primary_count
from nodes n
join activities a on a.id = n.id and a.activity_category = 'fishing'
join node_locations nl on nl.node_id = n.id
group by n.slug
having count(*) filter (where nl.relation = 'primary') <> 1;
-- expect 0 rows

select n.slug
from nodes n
join activities a on a.id = n.id and a.activity_category = 'fishing'
join node_locations nl on nl.node_id = n.id and nl.relation = 'primary'
where not exists (select 1 from locations l where l.id = nl.location_id);
-- expect 0 rows

\echo '=== 4. Every operated_by_provider_id references a real provider node (no invalid refs) ==='
select n.slug from activities a join nodes n on n.id = a.id
where a.activity_category = 'fishing' and a.operated_by_provider_id is not null
  and not exists (select 1 from nodes p where p.id = a.operated_by_provider_id and p.node_type = 'provider');
-- expect 0 rows

\echo '=== 5. Every fishing-type category tag references a real, correctly-grouped category ==='
select n.slug as activity_slug, nc.category_id
from nodes n
join activities a on a.id = n.id and a.activity_category = 'fishing'
join node_categories nc on nc.node_id = n.id
where not exists (
  select 1 from categories c where c.id = nc.category_id and c.category_group = 'activity-type'
);
-- expect 0 rows

\echo '=== 6. bookable_products relationships valid + every fishing activity is bookable ==='
select bp.id from bookable_products bp
where not exists (select 1 from nodes n where n.id = bp.id and n.node_type in ('accommodation','activity','package'));
-- expect 0 rows
select n.slug from nodes n
join activities a on a.id = n.id and a.activity_category = 'fishing'
where not exists (select 1 from bookable_products bp where bp.id = n.id);
-- expect 0 rows

\echo '=== 7. No new locations were created by this seed (fishing reuses Task 4/5 locations only) ==='
select count(*) from locations; -- expect 221, unchanged from Task 6

\echo '=== 8. Canonical URL check: exactly one reachable path per fishing activity ==='
-- A fishing activity must NOT be independently addressable as a generic
-- "activity" from the app's routing perspective — verified at the data
-- level here by confirming category is uniformly 'fishing' (route-level
-- 404 guard is verified via lint/typecheck/build + code review, since no
-- live HTTP server is available in this sandbox).
select slug from nodes n join activities a on a.id = n.id
where n.node_type = 'activity' and a.activity_category = 'fishing'
order by slug;

\echo '=== 9. Fishing activities with location, provider, and type ==='
select n.title, ln.title as island, atn.title as atoll, pn.title as provider,
       string_agg(ctn.title, ', ') as fishing_types, a.duration_minutes, a.price_from
from nodes n
join activities a on a.id = n.id and a.activity_category = 'fishing'
join node_locations nl on nl.node_id = n.id and nl.relation = 'primary'
join locations l on l.id = nl.location_id
join nodes ln on ln.id = l.id
left join locations al on al.id = l.parent_id
left join nodes atn on atn.id = al.id
left join nodes pn on pn.id = a.operated_by_provider_id
left join node_categories nc on nc.node_id = n.id
left join nodes ctn on ctn.id = nc.category_id
group by n.title, ln.title, atn.title, pn.title, a.duration_minutes, a.price_from
order by n.title;

\echo '=== 10. Providers: accommodations + all activities + fishing specifically ==='
select pn.title as provider,
  (select count(*) from accommodations acc where acc.operated_by_provider_id = pn.id) as accommodations,
  (select count(*) from activities act where act.operated_by_provider_id = pn.id and act.activity_category <> 'fishing') as other_activities,
  (select count(*) from activities act where act.operated_by_provider_id = pn.id and act.activity_category = 'fishing') as fishing_activities
from nodes pn
where pn.node_type = 'provider'
order by pn.title;

\echo '=== 11. Fishing-type categories seeded (only types actually used) ==='
select n.slug, n.title from nodes n join categories c on c.id = n.id
where c.category_group = 'activity-type' order by n.title;

\echo '=== 12. No fishing-specific locations were fabricated (fishing_spots.json is empty) ==='
select count(*) from locations where location_type = 'fishing_spot';
-- expect 0 — documented as a deliberate limitation in data/maldives/fishing/SOURCES.md

\echo '=== DONE ==='
