-- MTG foundation: packages, itinerary (day-range "stage" model), articles.
-- Package taxonomy (honeymoon/family/luxury/etc.) is expressed entirely
-- through node_categories relationships (see relationships + seed
-- migrations) — deliberately no boolean flag columns here.

create table packages (
  id                        uuid primary key references nodes(id) on delete cascade,
  duration_nights           int,
  price_from                numeric(10,2),
  currency                  text default 'USD',
  operated_by_provider_id   uuid references providers(id)
);
create index packages_provider_idx on packages(operated_by_provider_id);
create index packages_duration_idx on packages(duration_nights);

-- A stage is a day RANGE (e.g. days 1-4 at Hotel A), not one row per day —
-- this avoids repeating the same accommodation node on every night of a
-- multi-night stay (Task 2 Revision 3 §7).
create table package_itinerary_stages (
  id             uuid primary key default gen_random_uuid(),
  package_id     uuid not null references nodes(id) on delete cascade,
  stage_number   int not null,
  day_start      int not null,
  day_end        int not null,
  night_count    int not null default 0,
  title          text,
  description    text,
  sort_order     int not null default 0,
  unique (package_id, stage_number),
  check (day_end >= day_start)
);
create index package_itinerary_stages_package_idx on package_itinerary_stages(package_id);

create table package_itinerary_items (
  id                    uuid primary key default gen_random_uuid(),
  stage_id              uuid not null references package_itinerary_stages(id) on delete cascade,
  component_type        text not null check (component_type in ('node','transfer_service')),
  component_node_id     uuid references nodes(id),
  transfer_service_id   uuid references transfer_services(id),
  component_role        text not null check (component_role in (
                           'accommodation','activity','transfer','meal','free_time','excursion','other'
                         )),
  quantity              int not null default 1,
  notes                 text,
  sort_order            int not null default 0,
  check (
    (component_type = 'node' and component_node_id is not null and transfer_service_id is null)
    or
    (component_type = 'transfer_service' and transfer_service_id is not null and component_node_id is null)
  )
);
create index package_itinerary_items_stage_idx on package_itinerary_items(stage_id);

create table articles (
  id                   uuid primary key references nodes(id) on delete cascade,
  body                 text not null,
  reading_time_minutes int,
  author_id            uuid references auth.users(id)
);
