-- Task 15: generic node-to-node relationship table.
--
-- Articles need to link to (and be linked from) accommodations, activities,
-- fishing/diving/surfing content, transfer routes, packages, and other
-- articles. Every one of those is already a `nodes` row (Task 2 foundation),
-- so this reuses the same node model instead of adding a separate
-- foreign-key system per relationship type (island/atoll already have one
-- via `node_locations`, which this does not duplicate).
--
-- `relation_type` distinguishes an editorial "this article is about/related
-- to X" link from a lighter-weight "this article mentions X" reference, so
-- rendering can choose to treat them differently (e.g. only 'related' in a
-- "Related" section, both when building in-body contextual links).
create table node_relationships (
  node_id          uuid not null references nodes(id) on delete cascade,
  related_node_id  uuid not null references nodes(id) on delete cascade,
  relation_type    text not null default 'related' check (relation_type in ('related', 'mentions')),
  confidence       numeric(4,3),
  sort_order       int not null default 0,
  created_at       timestamptz not null default now(),
  primary key (node_id, related_node_id, relation_type),
  check (node_id <> related_node_id)
);
create index node_relationships_related_idx on node_relationships(related_node_id);

alter table node_relationships enable row level security;
create policy node_relationships_public_read on node_relationships for select
  using (
    exists (select 1 from nodes n where n.id = node_relationships.node_id and n.status = 'published')
    and exists (select 1 from nodes n2 where n2.id = node_relationships.related_node_id and n2.status = 'published')
  );
create policy node_relationships_staff_all on node_relationships for all
  using (is_staff()) with check (is_staff());
