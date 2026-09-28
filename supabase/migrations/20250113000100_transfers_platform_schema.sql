-- Task 20: schema extensions for the Maldives Transfers SEO platform
-- rebuild. Extends the existing architecture (nodes/categories/
-- bookable_products/reviews/transfer_services) rather than duplicating
-- it — see this file's individual sections for what's reused vs. new.

-- ── §1: multi-category transfer routes ──────────────────────────────
-- A route already tags any number of node_categories (Task 7 foundation).
-- Reusing that directly for "airport / resort / hotel / island" tags
-- (Task 20 §22 "multi-category routes") means a route can be airport AND
-- resort AND island simultaneously with zero new tables — exactly the
-- same mechanism packages already use for traveler-type/style/theme.
alter table categories drop constraint categories_category_group_check;
alter table categories add constraint categories_category_group_check
  check (category_group in (
    'accommodation-type', 'activity-type', 'amenity',
    'traveler-type', 'package-style', 'duration-band', 'inclusion', 'theme',
    'article-category', 'transfer-category'
  ));

-- ── §2: new node types — speedboat (private charter fleet), vehicle
-- (car transfer fleet). Both reuse the full nodes backbone (slug, title,
-- summary, status, meta_title/description, node_media, node_categories)
-- exactly like accommodation/activity/package, rather than a parallel
-- content system.
alter table nodes drop constraint nodes_node_type_check;
alter table nodes add constraint nodes_node_type_check
  check (node_type in (
    'location', 'category', 'provider', 'accommodation',
    'activity', 'transfer_route', 'package', 'article',
    'speedboat', 'vehicle'
  ));

create table speedboats (
  id                 uuid primary key references nodes(id) on delete cascade,
  capacity           int not null,
  length_feet        numeric(5,1),
  engine_count       smallint check (engine_count in (1,2)),
  horsepower         int,
  top_speed_knots    numeric(4,1),
  facilities         text[] not null default '{}',
  charter_options    text[] not null default '{}',
  active             boolean not null default true
);
create index speedboats_active_idx on speedboats(active);

-- Fleet detail is intentionally minimal until real data exists (Task 20
-- §17: "pricing will be entered later" — same rule applied to capacity/
-- facilities for any vehicle not yet described by the operator). No
-- price column at all: there is no public per-vehicle or per-boat price
-- anywhere in this platform, by design (Task 20 §14/§17 — never invent
-- one), so unlike transfer_services there is nothing to leave null here.
create table vehicles (
  id                 uuid primary key references nodes(id) on delete cascade,
  vehicle_type       text not null check (vehicle_type in ('car','minibus','bus')),
  capacity           int not null,
  luggage_capacity   text,
  facilities         text[] not null default '{}',
  active             boolean not null default true
);
create index vehicles_type_idx on vehicles(vehicle_type);

-- ── §3: bookable_products type safety now also covers speedboat/vehicle
-- inquiries (booking_mode='inquiry', base_price=null — no public price),
-- reusing the exact same create_booking_inquiry(p_product_type='node', ...)
-- path packages already use. No second inquiry system. transfer_route is
-- also added: the existing shared-transfer booking flow attaches to a
-- specific transfer_service, but a route's "Private Transfer" option
-- (Task 20 §29) needs somewhere to attach when the route has no distinct
-- private service on record — the route node itself, never a fabricated
-- private service.
create or replace function enforce_bookable_product_node_type() returns trigger as $$
declare
  v_node_type text;
begin
  select node_type into v_node_type from nodes where id = new.id;
  if v_node_type is null then
    raise exception 'bookable_products.id % does not reference an existing node', new.id;
  end if;
  if v_node_type not in ('accommodation', 'activity', 'package', 'speedboat', 'vehicle', 'transfer_route') then
    raise exception 'node_type % may not be marked bookable (allowed: accommodation, activity, package, speedboat, vehicle, transfer_route)', v_node_type;
  end if;
  return new;
end;
$$ language plpgsql set search_path = public, pg_temp;

-- ── §4: transfer_services.is_bookable — the ferry schedule (Task 20 §25)
-- is explicitly information-only with NO booking functionality, while
-- reusing the same transfer_routes/transfer_services/schedules shape as
-- every other scheduled service. This one boolean is the entire
-- distinction; the repository comment in src/lib/transfers/repository.ts
-- already anticipated this exact column ("if a future task adds a
-- transfer-specific bookability flag, is obvious").
alter table transfer_services add column is_bookable boolean not null default true;

-- ── §5: transfer_services facilities — real, per-service attributes only
-- (Task 20 §35: "only display facilities supported by real data"). Empty
-- by default; never backfilled with guesses for the 77 existing services
-- that have no sourced facility list.
alter table transfer_services add column facilities text[] not null default '{}';

-- ── §6: guest-safe reviews (Task 20 §34). The existing `reviews` table
-- required an authenticated user_id, but this project has no sign-in flow
-- anywhere (checked — no auth UI exists), so as originally written no real
-- visitor could ever submit one. This mirrors the guest-checkout pattern
-- already proven for bookings (nullable user_id + captured contact
-- fields), not a new review system.
alter table reviews alter column user_id drop not null;
alter table reviews add column guest_name text;
alter table reviews add column guest_email text;
alter table reviews add constraint reviews_identity_check check (
  user_id is not null or (guest_name is not null and guest_email is not null)
);
-- A guest may leave several reviews for different nodes; the original
-- (node_id, user_id) unique constraint only meant anything for real
-- accounts, so it's replaced with one that also treats (node_id,
-- guest_email) as a duplicate guard (Postgres already treats each NULL
-- user_id as distinct on its own, so this makes the guest case explicit
-- rather than relying on that default).
alter table reviews drop constraint reviews_node_id_user_id_key;
alter table reviews add constraint reviews_node_user_unique unique nulls not distinct (node_id, user_id, guest_email);

create or replace function submit_review(
  p_node_id       uuid,
  p_rating        smallint,
  p_title         text,
  p_body          text,
  p_guest_name    text,
  p_guest_email   text
) returns table (id uuid)
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_id uuid;
  v_user_id uuid := auth.uid();
begin
  if p_rating is null or p_rating not between 1 and 5 then
    raise exception 'rating must be between 1 and 5';
  end if;
  if v_user_id is null then
    if p_guest_name is null or length(trim(p_guest_name)) = 0 then
      raise exception 'guest_name is required for a guest review';
    end if;
    if p_guest_email is null or p_guest_email !~ '^[^@\s]+@[^@\s]+\.[^@\s]+$' then
      raise exception 'a valid guest_email is required for a guest review';
    end if;
  end if;

  insert into reviews (node_id, user_id, rating, title, body, guest_name, guest_email, status)
  values (p_node_id, v_user_id, p_rating, p_title, p_body,
          case when v_user_id is null then p_guest_name end,
          case when v_user_id is null then p_guest_email end,
          'pending')
  returning reviews.id into v_id;

  return query select v_id;
end;
$$;

revoke all on function submit_review(uuid, smallint, text, text, text, text) from public;
grant execute on function submit_review(uuid, smallint, text, text, text, text) to anon, authenticated;

-- ── §7: RLS for the two new node-backed tables — identical shape to
-- every other type extension table (accommodations/activities/packages).
alter table speedboats enable row level security;
create policy speedboats_public_read on speedboats for select
  using (exists (select 1 from nodes n where n.id = speedboats.id and n.status = 'published'));
create policy speedboats_staff_all on speedboats for all
  using (is_staff()) with check (is_staff());

alter table vehicles enable row level security;
create policy vehicles_public_read on vehicles for select
  using (exists (select 1 from nodes n where n.id = vehicles.id and n.status = 'published'));
create policy vehicles_staff_all on vehicles for all
  using (is_staff()) with check (is_staff());

-- ── §8: ferry schedule — information-only public transport data (Task 20
-- §25: "NO BOOKING FUNCTIONALITY"). Deliberately NOT modeled as
-- transfer_routes/transfer_services: a real province ferry "route" is a
-- multi-stop loop (e.g. 11 islands on Route 101), not the strict single
-- origin/destination pair transfer_routes enforces, and nothing here is
-- ever booked, priced, or queried per-stop — so a lean, read-only table
-- with the stop sequence as an ordered JSONB array is the honest fit,
-- not a workaround of the "not JSONB" rule in
-- docs/SYSTEM_ARCHITECTURE_AND_DATABASE_DESIGN.md (that rule was about
-- *bookable* multi-departure services needing real rows/uniqueness
-- constraints, which does not apply to unbookable reference data).
-- origin/destination location_id are resolved against the real, already-
-- seeded locations table where a name match exists and left null
-- otherwise — never a fabricated location.
create table ferry_routes (
  id                       uuid primary key default gen_random_uuid(),
  route_number             text not null,
  variant_label            text,
  title                    text not null,
  province                 text not null,
  operating_days           text not null,
  origin_location_id       uuid references locations(id),
  destination_location_id  uuid references locations(id),
  stops                    jsonb not null default '[]'::jsonb,
  notes                    text,
  hero_media_id            uuid references media_assets(id),
  source_legacy_url        text,
  sort_order               int not null default 0,
  active                   boolean not null default true
);
create index ferry_routes_active_idx on ferry_routes(active);

alter table ferry_routes enable row level security;
create policy ferry_routes_public_read on ferry_routes for select using (active);
create policy ferry_routes_staff_all on ferry_routes for all
  using (is_staff()) with check (is_staff());
