-- MTG foundation: geography and taxonomy backbone.

create table locations (
  id                    uuid primary key references nodes(id) on delete cascade,
  location_type         text not null check (location_type in (
                           'country', 'atoll', 'island', 'locality', 'airport', 'seaport', 'harbour', 'poi',
                           'dive_site', 'surf_break', 'fishing_spot'
                         )),
  parent_id             uuid references locations(id),
  path                  ltree not null,
  lat                   numeric(9,6),
  lng                   numeric(9,6),
  timezone              text default 'Indian/Maldives',
  is_inhabited          boolean,
  administrative_code   text
);
create index locations_path_gist  on locations using gist (path);
create index locations_parent_idx on locations(parent_id);
create index locations_type_idx   on locations(location_type);

create table categories (
  id                uuid primary key references nodes(id) on delete cascade,
  category_group    text not null check (category_group in (
                       'accommodation-type', 'activity-type', 'amenity',
                       'traveler-type', 'package-style', 'duration-band', 'inclusion', 'theme'
                     )),
  parent_id         uuid references categories(id),
  path              ltree not null
);
create index categories_path_gist on categories using gist (path);
create index categories_group_idx on categories(category_group);

create table attribute_definitions (
  id                     uuid primary key default gen_random_uuid(),
  applies_to_node_type   text not null,
  applies_to_subtype     text,
  key                    text not null,
  label                  text not null,
  data_type              text not null check (data_type in ('text','number','boolean','enum','date')),
  unit                   text,
  is_filterable          boolean default true,
  enum_options           text[],
  sort_order             int default 0,
  unique (applies_to_node_type, applies_to_subtype, key)
);

-- Data-driven parent/child rules for the location hierarchy (Task 2 Revision 3 §9).
-- Enforced by the enforce_location_hierarchy() trigger created in the
-- functions/triggers migration; seed rows are loaded in the seed migration.
create table location_type_hierarchy_rules (
  parent_type   text,        -- null = permitted as a root (no parent)
  child_type    text not null,
  -- Not a PRIMARY KEY: a composite primary key forces every one of its
  -- columns NOT NULL, which would rule out the null-parent_type "root"
  -- rows this table depends on. A unique constraint with
  -- `nulls not distinct` gives the same duplicate-prevention guarantee
  -- while still allowing (and de-duplicating) parent_type = null rows.
  unique nulls not distinct (parent_type, child_type)
);
