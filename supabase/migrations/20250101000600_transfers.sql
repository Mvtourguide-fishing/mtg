-- MTG foundation: transfers.
-- transfer_routes is the canonical, SEO-indexable node (directional
-- origin -> destination; the reverse direction is a separate row, never
-- inferred). transfer_services is NOT a node — it is the commercial/
-- transactional offering shown on its route's page (Task 2 Revision 3 §1,
-- §2, §6).

create table transfer_routes (
  id                          uuid primary key references nodes(id) on delete cascade,
  origin_location_id          uuid not null references locations(id),
  destination_location_id     uuid not null references locations(id),
  distance_km                 numeric(6,2),
  typical_duration_minutes    int,
  unique (origin_location_id, destination_location_id),
  check (origin_location_id <> destination_location_id)
);
create index transfer_routes_origin_idx      on transfer_routes(origin_location_id);
create index transfer_routes_destination_idx on transfer_routes(destination_location_id);

create table transfer_services (
  id                     uuid primary key default gen_random_uuid(),
  route_id               uuid not null references transfer_routes(id) on delete cascade,
  provider_id            uuid references providers(id),
  transfer_type          text not null check (transfer_type in (
                            'speedboat','seaplane','domestic_flight','ferry','private_yacht','land_transfer'
                          )),
  vehicle_type           text,
  shared_or_private      text not null check (shared_or_private in ('shared','private')),
  duration_minutes       int,
  price                  numeric(10,2) not null,
  currency               text not null default 'USD',
  capacity               int,
  luggage_allowance      text,
  status                 text not null default 'active' check (status in ('active','seasonal','suspended','discontinued')),
  pickup_instructions    text,
  dropoff_instructions   text,
  booking_requirements   text,
  cancellation_policy    text,
  description            text,
  created_at             timestamptz not null default now(),
  updated_at             timestamptz not null default now()
);
create index transfer_services_route_idx    on transfer_services(route_id);
create index transfer_services_provider_idx on transfer_services(provider_id);
create index transfer_services_status_idx   on transfer_services(status);

create trigger transfer_services_set_updated_at
  before update on transfer_services
  for each row execute function set_updated_at();

-- Normalized recurring-departure schedule — supports multiple departures
-- per day per service without JSONB (Task 2 Revision 3 §1).
create table transfer_service_schedules (
  id                    uuid primary key default gen_random_uuid(),
  transfer_service_id   uuid not null references transfer_services(id) on delete cascade,
  day_of_week           smallint check (day_of_week between 0 and 6),  -- 0=Sun..6=Sat; null = every day
  departure_time        time,
  arrival_time           time,
  duration_minutes       int,
  effective_from          date,
  effective_to            date,
  status                  text not null default 'active' check (status in ('active','inactive')),
  sort_order              int not null default 0,
  unique nulls not distinct (transfer_service_id, day_of_week, departure_time)
);
create index transfer_service_schedules_service_idx on transfer_service_schedules(transfer_service_id);

create table transfer_service_media (
  transfer_service_id   uuid not null references transfer_services(id) on delete cascade,
  media_id              uuid not null references media_assets(id) on delete cascade,
  role                  text not null check (role in ('hero','gallery')),
  sort_order            int default 0,
  primary key (transfer_service_id, media_id, role)
);
