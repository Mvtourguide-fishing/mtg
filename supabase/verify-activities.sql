-- Task 6 data verification (dev-only, run manually — not a migration).

\echo '=== Row counts ==='
select
  (select count(*) from nodes where node_type = 'activity')  as activities,
  (select count(*) from nodes where node_type = 'provider')  as providers_total;

\echo '=== 1. Every activity node has a matching activities row, and vice versa ==='
select n.id, n.slug from nodes n
where n.node_type = 'activity'
  and not exists (select 1 from activities a where a.id = n.id);
-- expect 0 rows
select a.id from activities a
where not exists (select 1 from nodes n where n.id = a.id and n.node_type = 'activity');
-- expect 0 rows

\echo '=== 2. activity_category values in use ==='
select distinct activity_category from activities order by 1;

\echo '=== 3. Every activity has exactly one primary location ==='
select n.slug, count(*) filter (where nl.relation = 'primary') as primary_count
from nodes n
join node_locations nl on nl.node_id = n.id
where n.node_type = 'activity'
group by n.slug
having count(*) filter (where nl.relation = 'primary') <> 1;
-- expect 0 rows

\echo '=== 4. Every activity primary location is a real, valid location row ==='
select n.slug
from nodes n
join node_locations nl on nl.node_id = n.id and nl.relation = 'primary'
where n.node_type = 'activity'
  and not exists (select 1 from locations l where l.id = nl.location_id);
-- expect 0 rows

\echo '=== 5. No duplicate activity slugs / no duplicate providers ==='
select slug, count(*) from nodes where node_type = 'activity' group by slug having count(*) > 1;
-- expect 0 rows
select title, count(*) from nodes where node_type = 'provider' group by title having count(*) > 1;
-- expect 0 rows

\echo '=== 6. Providers total did not double-count the 4 reused from Task 5 (expect 4 + 5 new = 9) ==='
select count(*) from nodes where node_type = 'provider';

\echo '=== 7. Every operated_by_provider_id references a real provider node ==='
select n.slug from activities a join nodes n on n.id = a.id
where a.operated_by_provider_id is not null
  and not exists (select 1 from nodes p where p.id = a.operated_by_provider_id and p.node_type = 'provider');
-- expect 0 rows

\echo '=== 8. bookable_products relationships valid + every activity is bookable ==='
select bp.id from bookable_products bp
where not exists (select 1 from nodes n where n.id = bp.id and n.node_type in ('accommodation','activity','package'));
-- expect 0 rows
select n.slug from nodes n
where n.node_type = 'activity' and not exists (select 1 from bookable_products bp where bp.id = n.id);
-- expect 0 rows

\echo '=== 9. No new locations were created by this seed (Task 6 must reuse Task 4/5 locations only) ==='
select count(*) from locations; -- compare against the 215 (1+21+193) from Task 4 + 6 resort islands from Task 5 = 221 expected

\echo '=== 10. Activities per category, with island/atoll/provider ==='
select n.title, a.activity_category, ln.title as island, atn.title as atoll,
       pn.title as provider, a.duration_minutes, a.price_from, a.difficulty
from nodes n
join activities a on a.id = n.id
join node_locations nl on nl.node_id = n.id and nl.relation = 'primary'
join locations l on l.id = nl.location_id
join nodes ln on ln.id = l.id
left join locations al on al.id = l.parent_id
left join nodes atn on atn.id = al.id
left join nodes pn on pn.id = a.operated_by_provider_id
order by a.activity_category, n.title;

\echo '=== 11. Providers and what they now operate (accommodations + activities) ==='
select pn.title as provider,
  (select count(*) from accommodations acc where acc.operated_by_provider_id = pn.id) as accommodations,
  (select count(*) from activities act where act.operated_by_provider_id = pn.id) as activities
from nodes pn
where pn.node_type = 'provider'
order by pn.title;

\echo '=== DONE ==='
