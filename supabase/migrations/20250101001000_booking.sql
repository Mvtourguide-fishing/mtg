-- MTG foundation: booking / inquiry system.
-- One reusable table for every bookable thing (accommodation, activity,
-- package, or transfer service) — no per-entity-type booking tables.
-- Guest checkout is first-class: user_id is nullable, customer contact
-- fields are captured directly (Task 2 Revision 3 §3).

create table bookable_products (
  id              uuid primary key references nodes(id) on delete cascade,
  booking_mode    text not null default 'inquiry' check (booking_mode in ('inquiry','instant')),
  base_price      numeric(10,2),
  currency        text default 'USD',
  max_guests      int
);
-- Type-safety trigger (only accommodation/activity/package nodes may be
-- bookable) is added in the functions/triggers migration, once nodes and
-- this table both exist.

create table booking_reference_counters (
  year         int primary key,
  last_value   int not null default 0
);

create table bookings (
  id                         uuid primary key default gen_random_uuid(),
  booking_reference          text not null unique,
  product_type               text not null check (product_type in ('node','transfer_service')),
  product_node_id            uuid references bookable_products(id),
  transfer_service_id        uuid references transfer_services(id),
  user_id                    uuid references auth.users(id),         -- nullable: guest bookings
  customer_name              text not null,
  customer_email             text not null,
  customer_phone             text,
  customer_whatsapp          text,
  origin_location_id         uuid references locations(id),
  destination_location_id    uuid references locations(id),
  travel_date                date,
  travel_time                time,
  return_date                date,
  return_time                time,
  trip_type                  text check (trip_type in ('one_way','round_trip','multi_day','n_a')),
  adults                     int not null default 1,
  children                   int not null default 0,
  infants                    int not null default 0,
  flight_number               text,
  special_requests             text,
  estimated_price              numeric(10,2),
  quoted_price                  numeric(10,2),
  currency                      text not null default 'USD',
  internal_notes                text,
  status                        text not null default 'new' check (status in (
                                   'new','contacted','pending','confirmed','cancelled','completed'
                                 )),
  notification_status           text not null default 'pending' check (notification_status in ('pending','sent','failed')),
  created_at                    timestamptz not null default now(),
  updated_at                    timestamptz not null default now(),
  check (
    (product_type = 'node' and product_node_id is not null and transfer_service_id is null)
    or
    (product_type = 'transfer_service' and transfer_service_id is not null and product_node_id is null)
  )
);
create index bookings_reference_idx        on bookings(booking_reference);
create index bookings_status_idx           on bookings(status);
create index bookings_user_idx             on bookings(user_id);
create index bookings_product_node_idx     on bookings(product_node_id);
create index bookings_transfer_service_idx on bookings(transfer_service_id);
create index bookings_travel_date_idx      on bookings(travel_date);
create index bookings_customer_email_idx   on bookings(customer_email);

create trigger bookings_set_updated_at
  before update on bookings
  for each row execute function set_updated_at();
-- booking_reference generation trigger is added in the functions/triggers
-- migration (must be unconditionally authoritative — Task 2 Revision 3 §4).

create table booking_notifications (
  id                    uuid primary key default gen_random_uuid(),
  booking_id            uuid not null references bookings(id) on delete cascade,
  notification_type     text not null check (notification_type in ('admin_alert','customer_confirmation')),
  recipient_email       text not null,
  status                text not null default 'pending' check (status in ('pending','sent','failed')),
  provider_message_id   text,
  error_message         text,
  attempted_at          timestamptz not null default now(),
  sent_at               timestamptz
);
create index booking_notifications_booking_idx on booking_notifications(booking_id);

create table platform_settings (
  key            text primary key,
  value          text not null,
  description    text,
  updated_at     timestamptz not null default now()
);

create trigger platform_settings_set_updated_at
  before update on platform_settings
  for each row execute function set_updated_at();
