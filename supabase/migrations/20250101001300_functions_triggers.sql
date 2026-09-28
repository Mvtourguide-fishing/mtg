-- MTG foundation: functions and triggers implementing the security/
-- integrity rules from Task 2 Revision 3 (§3, §4, §5, §9, §10).

-- ─────────────────────────────────────────────────────────────────
-- §3 bookable_products type safety — only accommodation/activity/package
-- nodes may ever be marked bookable. Enforced at the database level so it
-- cannot be bypassed by application code.
-- ─────────────────────────────────────────────────────────────────
create or replace function enforce_bookable_product_node_type() returns trigger as $$
declare
  v_node_type text;
begin
  select node_type into v_node_type from nodes where id = new.id;
  if v_node_type is null then
    raise exception 'bookable_products.id % does not reference an existing node', new.id;
  end if;
  if v_node_type not in ('accommodation', 'activity', 'package') then
    raise exception 'node_type % may not be marked bookable (allowed: accommodation, activity, package)', v_node_type;
  end if;
  return new;
end;
$$ language plpgsql set search_path = public, pg_temp;

create trigger bookable_products_node_type_check
  before insert or update on bookable_products
  for each row execute function enforce_bookable_product_node_type();

-- ─────────────────────────────────────────────────────────────────
-- §4 booking reference generation — MTG-{year}-{6 digits}, unconditionally
-- authoritative (overwrites any client-supplied value), race-safe under
-- concurrent inserts via a row-locked per-year counter upsert.
-- ─────────────────────────────────────────────────────────────────
create or replace function generate_booking_reference() returns trigger as $$
declare
  next_val int;
  yr int := extract(year from now());
begin
  insert into booking_reference_counters (year, last_value)
  values (yr, 1)
  on conflict (year) do update set last_value = booking_reference_counters.last_value + 1
  returning last_value into next_val;

  new.booking_reference := 'MTG-' || yr || '-' || lpad(next_val::text, 6, '0');
  return new;
end;
$$ language plpgsql set search_path = public, pg_temp;

create trigger set_booking_reference
  before insert on bookings
  for each row execute function generate_booking_reference();

-- ─────────────────────────────────────────────────────────────────
-- §4 guest-safe booking RPCs. create_booking_inquiry() is the ONLY way any
-- anon/authenticated caller can create a booking (see RLS migration — no
-- INSERT policy exists on `bookings` for those roles). It never accepts
-- booking_reference, status, internal_notes, notification_status, or
-- timestamps as parameters — they are simply not in the signature.
-- ─────────────────────────────────────────────────────────────────
create or replace function create_booking_inquiry(
  p_product_type              text,
  p_product_node_id           uuid,
  p_transfer_service_id       uuid,
  p_customer_name              text,
  p_customer_email             text,
  p_customer_phone             text,
  p_customer_whatsapp          text,
  p_origin_location_id         uuid,
  p_destination_location_id    uuid,
  p_travel_date                 date,
  p_travel_time                  time,
  p_return_date                   date,
  p_return_time                   time,
  p_trip_type                     text,
  p_adults                        int default 1,
  p_children                      int default 0,
  p_infants                       int default 0,
  p_flight_number                  text default null,
  p_special_requests                text default null,
  p_estimated_price                 numeric default null,
  p_currency                        text default 'USD'
) returns table (id uuid, booking_reference text)
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_id uuid;
  v_reference text;
begin
  if p_product_type not in ('node', 'transfer_service') then
    raise exception 'invalid product_type: %', p_product_type;
  end if;
  if p_product_type = 'node' and p_product_node_id is null then
    raise exception 'product_node_id is required when product_type = node';
  end if;
  if p_product_type = 'transfer_service' and p_transfer_service_id is null then
    raise exception 'transfer_service_id is required when product_type = transfer_service';
  end if;
  if p_customer_name is null or length(trim(p_customer_name)) = 0 then
    raise exception 'customer_name is required';
  end if;
  if p_customer_email is null or p_customer_email !~ '^[^@\s]+@[^@\s]+\.[^@\s]+$' then
    raise exception 'a valid customer_email is required';
  end if;

  insert into bookings (
    product_type, product_node_id, transfer_service_id, user_id,
    customer_name, customer_email, customer_phone, customer_whatsapp,
    origin_location_id, destination_location_id, travel_date, travel_time,
    return_date, return_time, trip_type, adults, children, infants,
    flight_number, special_requests, estimated_price, currency
  ) values (
    p_product_type,
    case when p_product_type = 'node' then p_product_node_id end,
    case when p_product_type = 'transfer_service' then p_transfer_service_id end,
    auth.uid(),                          -- null for anonymous/guest callers, never client-supplied
    p_customer_name, p_customer_email, p_customer_phone, p_customer_whatsapp,
    p_origin_location_id, p_destination_location_id, p_travel_date, p_travel_time,
    p_return_date, p_return_time, p_trip_type, p_adults, p_children, p_infants,
    p_flight_number, p_special_requests, p_estimated_price, p_currency
  )
  returning bookings.id, bookings.booking_reference into v_id, v_reference;

  return query select v_id, v_reference;
end;
$$;

revoke all on function create_booking_inquiry(
  text, uuid, uuid, text, text, text, text, uuid, uuid, date, time, date, time,
  text, int, int, int, text, text, numeric, text
) from public;
grant execute on function create_booking_inquiry(
  text, uuid, uuid, text, text, text, text, uuid, uuid, date, time, date, time,
  text, int, int, int, text, text, numeric, text
) to anon, authenticated;

create or replace function get_my_bookings() returns setof bookings
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  return query select * from bookings where user_id = auth.uid();
end;
$$;

revoke all on function get_my_bookings from public;
grant execute on function get_my_bookings to authenticated;   -- not anon — guests have no account to list

-- ─────────────────────────────────────────────────────────────────
-- §5 redirect chain prevention — practical guard against the realistic
-- editor mistake of chaining two redirects, checked from both directions.
-- ─────────────────────────────────────────────────────────────────
create or replace function prevent_redirect_chains() returns trigger as $$
begin
  if new.target_type = 'path' and exists (
    select 1 from url_redirects r
    where r.source_path = new.target_path and r.is_active and r.id <> new.id
  ) then
    raise exception 'redirect chain: target_path % is itself an active redirect source', new.target_path;
  end if;

  if exists (
    select 1 from url_redirects r
    where r.target_type = 'path' and r.target_path = new.source_path and r.is_active and r.id <> new.id
  ) then
    raise exception 'redirect chain: source_path % is already the target of another active redirect', new.source_path;
  end if;

  return new;
end;
$$ language plpgsql set search_path = public, pg_temp;

create trigger url_redirects_no_chains
  before insert or update on url_redirects
  for each row execute function prevent_redirect_chains();

-- ─────────────────────────────────────────────────────────────────
-- §9 location hierarchy integrity — rejects invalid parent/child type
-- pairs (looked up from location_type_hierarchy_rules), self-parenting,
-- and cycles (walked via the real parent_id chain, not the path column).
-- ─────────────────────────────────────────────────────────────────
create or replace function enforce_location_hierarchy() returns trigger as $$
declare
  v_parent_type text;
begin
  if new.parent_id is null then
    if not exists (select 1 from location_type_hierarchy_rules where parent_type is null and child_type = new.location_type) then
      raise exception 'location_type % is not permitted as a root location', new.location_type;
    end if;
    return new;
  end if;

  if new.parent_id = new.id then
    raise exception 'a location cannot be its own parent';
  end if;

  select location_type into v_parent_type from locations where id = new.parent_id;
  if v_parent_type is null then
    raise exception 'parent_id % does not reference an existing location', new.parent_id;
  end if;

  if not exists (
    select 1 from location_type_hierarchy_rules
    where parent_type = v_parent_type and child_type = new.location_type
  ) then
    raise exception 'location_type % is not a permitted child of parent type %', new.location_type, v_parent_type;
  end if;

  if exists (
    with recursive ancestors as (
      select id, parent_id from locations where id = new.parent_id
      union all
      select l.id, l.parent_id from locations l join ancestors a on l.id = a.parent_id
    )
    select 1 from ancestors where id = new.id
  ) then
    raise exception 'assigning parent_id % would create a cycle', new.parent_id;
  end if;

  return new;
end;
$$ language plpgsql set search_path = public, pg_temp;

create trigger locations_hierarchy_check
  before insert or update of parent_id, location_type on locations
  for each row execute function enforce_location_hierarchy();

-- ─────────────────────────────────────────────────────────────────
-- §9 ltree path synchronization — recomputes a location's path from its
-- (possibly new) parent and slug, then cascades the prefix change to every
-- descendant in one bulk update. Fires on reparenting and on slug rename
-- (slug lives on nodes, hence the second trigger).
-- ─────────────────────────────────────────────────────────────────
create or replace function recompute_location_path(p_location_id uuid) returns void as $$
declare
  v_parent_id    uuid;
  v_slug         text;
  v_parent_path  ltree;
  v_old_path     ltree;
  v_new_path     ltree;
  v_label        text;
begin
  select l.parent_id, n.slug, l.path
    into v_parent_id, v_slug, v_old_path
    from locations l join nodes n on n.id = l.id
    where l.id = p_location_id;

  -- ltree labels allow only [A-Za-z0-9_]; slugs may contain hyphens.
  v_label := replace(v_slug, '-', '_');

  if v_parent_id is null then
    v_new_path := text2ltree(v_label);
  else
    select path into v_parent_path from locations where id = v_parent_id;
    v_new_path := v_parent_path || text2ltree(v_label);
  end if;

  update locations set path = v_new_path where id = p_location_id;

  if v_old_path is not null and v_old_path <> v_new_path then
    update locations
      set path = v_new_path || subpath(path, nlevel(v_old_path))
      where path <@ v_old_path and id <> p_location_id;
  end if;
end;
$$ language plpgsql set search_path = public, pg_temp;

create or replace function trigger_recompute_location_path() returns trigger as $$
begin
  perform recompute_location_path(new.id);
  return new;
end;
$$ language plpgsql set search_path = public, pg_temp;

create trigger locations_path_on_reparent
  after insert or update of parent_id on locations
  for each row execute function trigger_recompute_location_path();

create trigger nodes_path_on_slug_change
  after update of slug on nodes
  for each row when (new.node_type = 'location')
  execute function trigger_recompute_location_path();

-- ─────────────────────────────────────────────────────────────────
-- §10 RLS helpers. SECURITY DEFINER so their internal profiles lookup
-- bypasses RLS — otherwise a policy on profiles itself calling is_staff()
-- could recurse into profiles' own RLS evaluation.
-- ─────────────────────────────────────────────────────────────────
create or replace function is_staff() returns boolean
language sql stable security definer set search_path = public, pg_temp as $$
  select exists (select 1 from profiles p where p.id = auth.uid() and p.role in ('editor','admin'));
$$;

create or replace function is_admin() returns boolean
language sql stable security definer set search_path = public, pg_temp as $$
  select exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'admin');
$$;

revoke all on function is_staff from public;
revoke all on function is_admin from public;
grant execute on function is_staff to anon, authenticated;
grant execute on function is_admin to anon, authenticated;

-- ─────────────────────────────────────────────────────────────────
-- §10 profiles.role self-escalation guard — a second, independent layer
-- beyond RLS, since RLS's USING/WITH CHECK gates rows, not columns.
-- ─────────────────────────────────────────────────────────────────
create or replace function prevent_profile_role_self_escalation() returns trigger as $$
begin
  if new.role is distinct from old.role and not is_admin() then
    raise exception 'only an admin may change profiles.role';
  end if;
  return new;
end;
$$ language plpgsql set search_path = public, pg_temp;

create trigger profiles_prevent_role_self_escalation
  before update on profiles
  for each row execute function prevent_profile_role_self_escalation();

-- ─────────────────────────────────────────────────────────────────
-- Convenience: create a profiles row automatically when a new auth user
-- signs up, so `role` always has a sane default and profile-dependent
-- policies (is_staff/is_admin) never hit a missing row.
-- ─────────────────────────────────────────────────────────────────
create or replace function handle_new_auth_user() returns trigger as $$
begin
  insert into profiles (id) values (new.id)
  on conflict (id) do nothing;
  return new;
end;
$$ language plpgsql security definer set search_path = public, pg_temp;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function handle_new_auth_user();
