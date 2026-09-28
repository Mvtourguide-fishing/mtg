-- MTG foundation: the reusability layer — any node can attach to any
-- number of locations and categories without duplicating data.

create table node_locations (
  node_id       uuid not null references nodes(id) on delete cascade,
  location_id   uuid not null references locations(id) on delete cascade,
  relation      text not null default 'primary' check (relation in ('primary','secondary')),
  primary key (node_id, location_id)
);
create index node_locations_location_idx on node_locations(location_id);

-- At most one primary location per node; unlimited secondary locations
-- (Task 2 Revision 3 §8).
create unique index node_locations_one_primary_per_node
  on node_locations (node_id) where relation = 'primary';

create table node_categories (
  node_id       uuid not null references nodes(id) on delete cascade,
  category_id   uuid not null references categories(id) on delete cascade,
  primary key (node_id, category_id)
);
create index node_categories_category_idx on node_categories(category_id);
