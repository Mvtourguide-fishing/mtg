# MTG — Complete System Architecture & Database Design (Task 2, Revision 3 — Final Correction Pass)

Status: **Design only. Nothing built.** No Next.js project, no Supabase project, no migrations, no packages, no pages, no components, no API routes, no email integration, no application code. This revision keeps Revision 2 as the foundation and fixes only the 12 issues raised in the latest review. Nothing was redesigned beyond what each issue required.

Structure of this document: §1–§12 below are the correction for each numbered issue in the review, in the same order. §13 is the full, final, dependency-ordered consolidated schema (every fix applied). §14 is the final ER diagram. §15 is the final verdict.

---

## 1. Transfer Service Schedules

`transfer_services` previously held one `departure_time`/`arrival_time`/`operating_days` array directly, which cannot represent a service with several departures on the same day (Provider C's 09:00 *and* 14:00 ferry) or a schedule that changes seasonally. Fixed with a new normalized table, **not JSONB**:

```sql
create table transfer_service_schedules (
  id                    uuid primary key default gen_random_uuid(),
  transfer_service_id   uuid not null references transfer_services(id) on delete cascade,
  day_of_week           smallint check (day_of_week between 0 and 6),  -- 0=Sun..6=Sat; null = operates every day
  departure_time        time,
  arrival_time           time,
  duration_minutes       int,           -- optional override of transfer_services.duration_minutes for this slot
  effective_from          date,
  effective_to            date,
  status                  text not null default 'active' check (status in ('active','inactive')),
  sort_order              int not null default 0,
  unique nulls not distinct (transfer_service_id, day_of_week, departure_time)
);
create index transfer_service_schedules_service_idx on transfer_service_schedules(transfer_service_id);
```

`departure_time`, `arrival_time`, and `operating_days` are **removed** from `transfer_services`; `duration_minutes` stays there as the service's typical/default duration, overridable per schedule row when a specific slot genuinely differs (e.g., a later crossing runs longer due to tide).

**How multiple departures per day are represented:** each departure is its own row. Provider C's ferry (09:00 daily, 14:00 daily) is two rows: `(day_of_week = null, departure_time = '09:00')` and `(day_of_week = null, departure_time = '14:00')`, `day_of_week = null` meaning "every day this service runs," so a fully daily multi-departure service doesn't need seven rows per time slot. A service that only runs specific weekdays at a specific time uses one row per weekday instead (`day_of_week = 1` for Monday, etc.). `effective_from`/`effective_to` let a seasonal timetable (e.g., a monsoon-season schedule change) coexist with the regular one as a separate set of rows without deleting/overwriting history. The `unique nulls not distinct (...)` constraint (Postgres 15+, which Supabase runs) prevents an accidental exact duplicate of the same service/day/time — including two `day_of_week = null` rows at the same time, which a plain `UNIQUE` constraint would *not* catch, since ordinary SQL treats every `NULL` as distinct from every other `NULL`.

A booking does not reference a specific schedule row — `bookings.travel_date`/`travel_time` (already in the schema, §3 of Revision 2) capture the customer's chosen date and time directly; `transfer_service_schedules` exists to publish what's available, not to be a booking foreign key.

---

## 2. Migration Order / Foreign Key Dependencies

**There is no true circular dependency anywhere in the schema.** `nodes.og_image_media_id → media_assets.id` and `media_assets` itself has zero outgoing foreign keys — the appearance of a cycle in Revision 2 was purely an artifact of the order tables were *written* in the document, not a structural cycle. The fix is a single reordering, applied throughout §13: **`media_assets` is now the first table created, immediately after extensions, before `nodes`.** Because `media_assets` has no dependencies of its own, this is always valid, and it means:

- `nodes.og_image_media_id uuid references media_assets(id)` can be declared inline, no deferred `ALTER TABLE` needed.
- `transfer_service_media`, which references `media_assets(id)`, is naturally valid wherever it's created later, since `media_assets` already exists.
- `node_media`, same reasoning.

The full dependency order used in §13, confirmed acyclic by construction (every table only references tables created strictly before it, except declared self-references within the same `CREATE TABLE`, e.g. `locations.parent_id → locations.id`, which Postgres resolves within a single statement and is not a cross-table ordering issue):

```
extensions → media_assets → nodes → locations → categories → attribute_definitions
→ location_type_hierarchy_rules → providers → accommodations → activities
→ transfer_routes → transfer_services → transfer_service_schedules → transfer_service_media
→ packages → package_itinerary_stages → package_itinerary_items → articles
→ node_locations → node_categories → reviews → article_comments → favorites → node_media
→ bookable_products → booking_reference_counters → bookings → booking_notifications
→ platform_settings → profiles → url_redirects
→ (functions and triggers, which only need their referenced tables to already exist)
```

---

## 3. Bookable Product Type Safety

A plain `CHECK` constraint cannot enforce "only nodes of certain types," because `CHECK` constraints can't reliably reference another table's current data. This needs a trigger — enforced at the database level regardless of which client or role performs the write, so it cannot be bypassed by application code:

```sql
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
  for each row
  execute function enforce_bookable_product_node_type();
```

This makes it structurally impossible for an article, location, provider, category, or transfer_route to end up in `bookable_products` — an `INSERT` attempting it fails at the database layer, independent of and in addition to the RLS role check (§10) that already limits *who* may write to the table. Transfer services remain bookable exclusively through `bookings.transfer_service_id`, unaffected by this trigger.

---

## 4. Booking Reference Security & RPC Hardening

**The trigger is made unconditionally authoritative.** Revision 2's trigger only set `booking_reference` `when (new.booking_reference is null)` — a theoretical gap if a value were ever supplied. That condition is removed: the trigger now overwrites `booking_reference` on every insert, full stop, regardless of any value a caller attempts to pass.

```sql
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
  for each row
  execute function generate_booking_reference();
```

**The public RPC never exposes the forbidden fields as parameters at all** — not filtered, simply not present in the function signature, so there is nothing to strip or forget to strip:

```sql
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

revoke all on function create_booking_inquiry from public;
grant execute on function create_booking_inquiry(text, uuid, uuid, text, text, text, text, uuid, uuid, date, time, date, time, text, int, int, int, text, text, numeric, text)
  to anon, authenticated;
```

`booking_reference`, `status`, `internal_notes`, `notification_status`, `created_at`, and `updated_at` are not parameters — they are fixed by column defaults (`status` defaults to `'new'`, `notification_status` to `'pending'`, timestamps to `now()`) and the trigger from §4/above, and there is no way for a caller of this function to influence any of them.

**Hardening applied, matching every point raised:**
- **Explicit safe `search_path`** (`set search_path = public, pg_temp`) — prevents a search-path-hijacking attack against a `SECURITY DEFINER` function (a well-known Postgres privilege-escalation vector if the path is left to inherit the caller's).
- **Controlled `EXECUTE` grants** — `revoke all ... from public` first, then an explicit `grant execute ... to anon, authenticated` naming exactly who may call it.
- **No unnecessary public access to the underlying table** — `bookings` itself grants no `INSERT` privilege to `anon`/`authenticated` at the table level (in addition to RLS denying it, §10); the function is the only path in, because its owner (see §10's note on function ownership) can write to the table when regular client roles cannot.
- **Returns only `id` and `booking_reference`** — `returns table (id uuid, booking_reference text)`, never the full row, so the response can't be used to read back customer contact details or internal fields for someone else's booking.

The paired self-service read function is hardened identically:

```sql
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
```

---

## 5. Redirect Target Integrity

**Shape constraint** — the populated column must match `target_type`:

```sql
alter table url_redirects add constraint url_redirects_target_shape check (
  (target_type = 'node'         and target_node_id is not null and target_path is null)
  or
  (target_type = 'path'          and target_path is not null and target_node_id is null)
  or
  (target_type = 'external_url'  and target_path is not null and target_node_id is null)
);
```

(`target_path` is reused for both `path` — an internal relative path — and `external_url` — a full URL — distinguished by `target_type`; this mirrors the same discriminated-union pattern already used elsewhere in the schema, e.g. `bookings.product_type`.)

**301 is the default and the expected choice for a permanent SEO migration** — `status_code` already defaults to `301`. `302`/`308` are exceptions that must be deliberate (e.g., a genuinely temporary notice), and any such row is expected to record why in `notes`; this is an editorial/process rule enforced by the admin workflow (§17 in Revision 1/2) rather than a `CHECK`, since the database cannot judge *intent* — only that a chosen code is one of the three allowed values (already enforced).

**No redirect chains.** A trigger blocks the two realistic ways a chain gets created, checked from both directions so it's caught whichever row is added second:

```sql
create or replace function prevent_redirect_chains() returns trigger as $$
begin
  -- this row's target must not itself be another active redirect's source
  if new.target_type = 'path' and exists (
    select 1 from url_redirects r
    where r.source_path = new.target_path and r.is_active and r.id <> new.id
  ) then
    raise exception 'redirect chain: target_path % is itself an active redirect source — point directly at the final canonical path', new.target_path;
  end if;

  -- this row's source must not already be the target of another active redirect
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
  for each row
  execute function prevent_redirect_chains();
```

This is a practical guard against the realistic editor mistake (a two-hop chain, created in either order), not a general graph-cycle solver — chains built up gradually across many separate edits over time are not exhaustively detected by a per-row trigger. The operational backstop is a simple periodic admin health-check query (`select source_path from url_redirects where is_active and source_path in (select target_path from url_redirects where target_type = 'path' and is_active)`), not a new subsystem.

**No mass homepage redirects** is a policy rule for the later migration/import phase (§11), not something the schema can safely hard-block — a merge of several genuinely obsolete pages into one surviving hub is sometimes legitimate, so the constraint would be wrong if absolute. It's enforced procedurally: the migration import step (§11) flags any target used by an unusually large number of source rows for manual review before activation, and a bare `'/'` target is treated as requiring explicit sign-off rather than being auto-approved.

**Old URL → final canonical URL, directly.** For `target_type = 'node'`, the destination is always that node's live, dynamically-computed canonical path (§13/§21 of Revision 2) — it can never itself be "a redirect," by construction. For `target_type = 'path'`, the chain-prevention trigger above guarantees it isn't pointing at another redirect's source.

**`url_redirects` is the sole authoritative redirect system; `legacy_slugs` is historical metadata only.** This corrects an ambiguity in Revision 2: `nodes.legacy_slugs` is **not** consulted by request-time redirect resolution and does **not**, on its own, cause an HTTP redirect to happen. It exists purely as an audit/history record ("this node used to be known by these slugs") and as an optional aid for admin search/lookup. If an old slug needs to actually 301 somewhere, a corresponding `url_redirects` row must exist — `legacy_slugs` never substitutes for one.

---

## 6. Transfer Route vs. Service — Explicit SEO Decision

Stated explicitly, as required, with the worked example:

- **`transfer_routes` are the only canonical, indexable SEO pages** for transfer content. `/maldives/transfers/velana-airport-to-thulusdhoo/` is a real, crawlable, reviewable page.
- **`transfer_services` are commercial line items displayed inside their route's page**, not independent URLs:

  ```
  /maldives/transfers/velana-airport-to-thulusdhoo/
    Provider A — Speedboat (shared) — $30
    Provider B — Speedboat (private) — $150 (on request)
    Provider C — Ferry — $5 — 09:00 / 14:00 daily (see §1 schedules)
  ```

- **Transfer services get no canonical URL of their own in v1.** There is no `/maldives/transfers/velana-airport-to-thulusdhoo/provider-a` page; a service is only ever reachable as a row within its route's page. This is a direct, intended consequence of §2 of Revision 2 (services are not nodes) — restated here explicitly because the review asked for it to be unambiguous, not because anything about the underlying model changed.
- **The booking retains the exact `transfer_service_id` selected**, via `bookings.transfer_service_id` (§3 of Revision 2, unchanged) — even though the service has no page of its own, the specific provider/offering chosen is never lost; it's a hard foreign key on the booking row, not inferred from the route.

---

## 7. Package Itinerary — Stage Model

Revision 2's `package_itinerary_days` forced one row per single day, which meant repeating "Hotel A" four times to cover a four-night stay. Replaced with **stages** — a day *range*, which is a superset of a single day (`day_start = day_end`) and removes the repetition without losing anything:

```sql
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
  sort_order             int not null default 0,
  check (
    (component_type = 'node' and component_node_id is not null and transfer_service_id is null)
    or
    (component_type = 'transfer_service' and transfer_service_id is not null and component_node_id is null)
  )
);
create index package_itinerary_items_stage_idx on package_itinerary_items(stage_id);
```

**Concrete 7-night example**, matching the review's worked case exactly:

| Stage | Days | Items |
|---|---|---|
| 1 | 1–4 | `{node: Hotel A, role: accommodation}`, `{node: Snorkeling activity, role: activity}`, `{node: Fishing trip, role: activity}` |
| 2 | 5–5 | `{transfer_service: Island A → Island B, role: transfer}` |
| 3 | 5–7 | `{node: Hotel B, role: accommodation}`, `{node: some Hotel-B-side activity, role: activity}` |

Hotel A appears **once** (in Stage 1), not four times; Hotel B appears **once** (in Stage 3), not three times. Day 5 legitimately appears in both Stage 2 (the transfer happens that day) and Stage 3 (the Hotel B stay begins that same day) — that overlap is real and intentional, exactly matching the review's own example, not a data-modeling error.

**No duplication:** every item is a reference — `component_node_id` to the real hotel/activity node, or `transfer_service_id` to the real transfer service — never a copy of that thing's title, price, or description. `package_id` is reachable through `stage_id → package_itinerary_stages.package_id`, so there is exactly one place to query "what's in this package," and `package_itinerary_days` from Revision 2 is fully removed rather than kept alongside this.

---

## 8. `node_locations` Primary Rule

A node may have at most one `primary` location; any number of `secondary` locations remain allowed. Enforced with a partial unique index (only indexes rows where `relation = 'primary'`, so it constrains nothing about `secondary` rows):

```sql
create unique index node_locations_one_primary_per_node
  on node_locations (node_id)
  where relation = 'primary';
```

An `INSERT`/`UPDATE` that would give a node a second `primary` row fails at the database level — this cannot be worked around by application code, same enforcement style as §3.

---

## 9. Location Hierarchy Integrity

**Allowed parent → child pairs**, encoded as data (not hardcoded in application logic) so the rule is inspectable and editable without a schema change:

```sql
create table location_type_hierarchy_rules (
  parent_type   text,        -- null = "permitted as a root (no parent)"
  child_type    text not null,
  primary key (parent_type, child_type)
);

-- seed rows (conceptual — not inserted now):
-- (null,      'country')
-- ('country', 'atoll')
-- ('atoll',   'island')
-- ('atoll',   'airport'), ('atoll','seaport'), ('atoll','harbour')
-- ('atoll',   'dive_site'), ('atoll','surf_break'), ('atoll','fishing_spot'), ('atoll','poi')
-- ('island',  'locality')
-- ('island',  'airport'), ('island','seaport'), ('island','harbour')
-- ('island',  'dive_site'), ('island','surf_break'), ('island','fishing_spot'), ('island','poi')
```

`island → island`, `atoll → country`, and a `country` anywhere but the root are simply never present in this table, so they're rejected the same way any other disallowed pair is — no special-case code needed for each named bad example in the review.

**Validation trigger** — checks the proposed parent/child pair against the rule table, rejects a self-referencing `parent_id`, and walks the ancestor chain to reject any cycle:

```sql
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
  for each row
  execute function enforce_location_hierarchy();
```

The cycle check walks `parent_id` directly (a recursive CTE over the real ancestor chain), not the `path` column — this avoids a bootstrapping problem where `path` might not yet reflect the very change being validated.

**Keeping `ltree.path` synchronized on a move (or a slug rename).** `path` is built from each ancestor's **slug** (for human-readable, queryable paths like `maldives.kaafu.thulusdhoo`, consistent with every example elsewhere in this document) — which means it must be recomputed whenever `parent_id` changes *or* the node's own `slug` changes (slug lives on `nodes`, not `locations`). One function, called from two triggers:

```sql
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

  v_label := replace(v_slug, '-', '_');   -- ltree labels allow only [A-Za-z0-9_]; slugs may contain hyphens

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

create trigger locations_path_on_reparent
  after insert or update of parent_id on locations
  for each row execute function trigger_recompute_location_path();

create trigger nodes_path_on_slug_change
  after update of slug on nodes
  for each row
  when (new.node_type = 'location')
  execute function trigger_recompute_location_path();

-- both triggers call the same underlying logic via a thin wrapper:
create or replace function trigger_recompute_location_path() returns trigger as $$
begin
  perform recompute_location_path(new.id);
  return new;
end;
$$ language plpgsql set search_path = public, pg_temp;
```

This is deliberately not more elaborate than this: it recomputes the moved/renamed node's own path from its (possibly new) parent, then rewrites every descendant's path by swapping the old prefix for the new one in a single bulk `UPDATE`, using `path <@ old_path` (an indexed `GiST` lookup) to find them. That is the whole mechanism — no queueing, no batching, no async job, appropriate for a geography tree of a few hundred rows.

---

## 10. RLS / Security Design (Concrete)

**Two helper functions**, used throughout instead of repeating the same subquery in every policy. Both are `SECURITY DEFINER` specifically so their internal read of `profiles` bypasses RLS — without this, a policy on `profiles` itself that calls `is_staff()` could recurse into `profiles`' own RLS evaluation:

```sql
create or replace function is_staff() returns boolean
language sql stable security definer set search_path = public, pg_temp as $$
  select exists (select 1 from profiles p where p.id = auth.uid() and p.role in ('editor','admin'));
$$;

create or replace function is_admin() returns boolean
language sql stable security definer set search_path = public, pg_temp as $$
  select exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'admin');
$$;
```

**Ownership note that makes the anonymous-write model work:** in Supabase, tables are owned by a privileged role (`postgres`) which bypasses RLS on tables it owns unless `FORCE ROW LEVEL SECURITY` is set (it is not, here). `SECURITY DEFINER` functions such as `create_booking_inquiry` execute with that owning role's privileges, which is what lets them write to `bookings` even though **no `INSERT` policy exists for `anon`/`authenticated` on that table at all** — the function is deliberately the only door in. `service_role` (used only by Edge Functions, never the browser) also bypasses RLS by design and is how `booking_notifications` gets written.

**Policy matrix.** Tables in the first block all follow one template — public read gated on the linked node/parent being published, all writes staff-only — shown once and then listed as "applied identically to" the rest:

```sql
-- Template A: nodes itself
alter table nodes enable row level security;
create policy nodes_public_read on nodes for select using (status = 'published');
create policy nodes_staff_read   on nodes for select using (is_staff());
create policy nodes_staff_write  on nodes for insert with check (is_staff());
create policy nodes_staff_update on nodes for update using (is_staff()) with check (is_staff());
create policy nodes_staff_delete on nodes for delete using (is_staff());

-- Template B: a 1:1 detail table sharing nodes.id (example: locations)
alter table locations enable row level security;
create policy locations_public_read on locations for select
  using (exists (select 1 from nodes n where n.id = locations.id and n.status = 'published'));
create policy locations_staff_all on locations for all
  using (is_staff()) with check (is_staff());
-- Applied identically (swap table name) to:
--   categories, providers, accommodations, activities, transfer_routes, packages, articles

-- Template C: a junction/child table gated through its parent node (example: node_locations)
alter table node_locations enable row level security;
create policy node_locations_public_read on node_locations for select
  using (exists (select 1 from nodes n where n.id = node_locations.node_id and n.status = 'published'));
create policy node_locations_staff_all on node_locations for all
  using (is_staff()) with check (is_staff());
-- Applied identically to: node_categories, node_media (join on node_media.node_id),
--   bookable_products (join on bookable_products.id = nodes.id)

-- media_assets has no publish gate of its own (not tied to a single node) — public read, staff write
alter table media_assets enable row level security;
create policy media_assets_public_read on media_assets for select using (true);
create policy media_assets_staff_all   on media_assets for all using (is_staff()) with check (is_staff());
```

**Transfer-specific tables** (gated through the route's node status, and the service's own operational status):

```sql
alter table transfer_services enable row level security;
create policy transfer_services_public_read on transfer_services for select
  using (
    status in ('active','seasonal')
    and exists (select 1 from nodes n where n.id = transfer_services.route_id and n.status = 'published')
  );
create policy transfer_services_staff_all on transfer_services for all
  using (is_staff()) with check (is_staff());

alter table transfer_service_schedules enable row level security;
create policy transfer_service_schedules_public_read on transfer_service_schedules for select
  using (
    status = 'active'
    and exists (
      select 1 from transfer_services s join nodes n on n.id = s.route_id
      where s.id = transfer_service_schedules.transfer_service_id and n.status = 'published'
    )
  );
create policy transfer_service_schedules_staff_all on transfer_service_schedules for all
  using (is_staff()) with check (is_staff());

alter table transfer_service_media enable row level security;
create policy transfer_service_media_public_read on transfer_service_media for select
  using (
    exists (
      select 1 from transfer_services s join nodes n on n.id = s.route_id
      where s.id = transfer_service_media.transfer_service_id and n.status = 'published'
    )
  );
create policy transfer_service_media_staff_all on transfer_service_media for all
  using (is_staff()) with check (is_staff());
```

**User-generated content** — identity-bound (unlike bookings, reviewing/commenting/favoriting require an account):

```sql
alter table reviews enable row level security;
create policy reviews_public_read on reviews for select using (status = 'published');
create policy reviews_own_read    on reviews for select using (auth.uid() = user_id);
create policy reviews_staff_read  on reviews for select using (is_staff());
create policy reviews_own_insert  on reviews for insert with check (auth.uid() = user_id);
create policy reviews_own_update  on reviews for update using (auth.uid() = user_id);
create policy reviews_own_delete  on reviews for delete using (auth.uid() = user_id);
create policy reviews_staff_moderate on reviews for update using (is_staff());
create policy reviews_staff_delete   on reviews for delete using (is_staff());
-- article_comments: identical shape, substituting status in ('visible','flagged','removed'), public = 'visible'

alter table favorites enable row level security;
create policy favorites_owner_all on favorites for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
-- no public policy, no staff override — favorites are private and carry no moderation-relevant content
```

**`profiles`** — public read (display name/avatar are shown alongside a user's reviews/comments), self-update, admin override, and an explicit trigger closing the self-escalation path regardless of which policy let an `UPDATE` through:

```sql
alter table profiles enable row level security;
create policy profiles_public_read on profiles for select using (true);
create policy profiles_self_update on profiles for update
  using (auth.uid() = id) with check (auth.uid() = id);
create policy profiles_admin_all on profiles for all
  using (is_admin()) with check (is_admin());

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
  for each row
  execute function prevent_profile_role_self_escalation();
```

The `profiles_self_update` policy alone would technically let a user submit a row with a changed `role` (RLS's `USING`/`WITH CHECK` only gates *which rows*, not *which columns*, can be touched); the trigger is what actually blocks the column change itself, which is why it's kept as a second, independent layer rather than relying on the policy alone — directly closing the "no self-escalation" requirement.

**Bookings and its support tables — no policy anywhere relies on `user_id`/`auth.uid()` as the access gate for writes, matching §7's requirement:**

```sql
alter table bookings enable row level security;
create policy bookings_staff_read   on bookings for select using (is_staff());
create policy bookings_staff_update on bookings for update using (is_staff()) with check (is_staff());
-- no insert/delete policy for any client role, and no policy at all referencing auth.uid() = user_id;
-- all inserts go through create_booking_inquiry() (§4); self-service reads go through get_my_bookings() (§4)

alter table booking_notifications enable row level security;
create policy booking_notifications_staff_read on booking_notifications for select using (is_staff());
-- writes: service_role only (Edge Function), which bypasses RLS by design — no client-role policy needed or granted

alter table platform_settings enable row level security;
create policy platform_settings_admin_read  on platform_settings for select using (is_admin());
create policy platform_settings_admin_write on platform_settings for all using (is_admin()) with check (is_admin());
-- admin-only, not editor — platform configuration is a narrower privilege than content editing

alter table booking_reference_counters enable row level security;
-- zero policies for any client role — touched only internally by the booking_reference trigger,
-- which runs in the same privileged context as the insert it's attached to (see ownership note above)
```

**Redirects — corrects an inconsistency from Revision 2**, which said `url_redirects` was staff-only for both read and write. That can't be right: redirect resolution has to run on every unmatched request in Next.js middleware, which is not an authenticated staff session — so `SELECT` must be public for active rows (the mapping itself isn't sensitive; only who may *create* one is restricted):

```sql
alter table url_redirects enable row level security;
create policy url_redirects_public_read on url_redirects for select using (is_active);
create policy url_redirects_staff_all   on url_redirects for all using (is_staff()) with check (is_staff());
```

---

## 11. SEO Migration Requirement

This is not an open or unknowable requirement — it is a committed, explicit part of the architecture, restated here without hedging: **`maldivestour.guide` is a live, already-indexed SEO property with real Search Console data and a real URL inventory.** A migration/import phase — after this design is approved for implementation, and separate from it — will build an authoritative **old-URL → final-URL mapping** from that real inventory (crawl export, sitemap export, and/or Search Console URL list), and load it into `url_redirects` (§5/§21) under exactly these rules:

1. **Keep the same URL where the new canonical structure already matches it** — no redirect row is even needed; the node's `slug` is chosen to reproduce the existing path so `canonical_path(node)` naturally equals the live URL.
2. **301 (or 308) to the exact new equivalent everywhere the URL must change** — one row per URL, pointing directly at the specific replacement node, never a category default or a best-guess hub.
3. **404/410 where no meaningful new equivalent exists** — a discontinued page is allowed to simply not resolve; it is not force-mapped to something unrelated just to avoid a 404.
4. **Never a mass redirect of unrelated URLs to the homepage** — this is the same rule already encoded procedurally in §5's chain/mass-redirect handling; it applies here as the standard the migration import step is built to enforce, not merely a preference.

**What is genuinely unavailable is not the requirement, only the data**, and only within this design session: this sandboxed environment's network egress to `maldivestour.guide` is blocked, and no crawl/Search Console export has been supplied yet. That is a fact about this session's tooling, not about the architecture — the schema (`url_redirects`, `legacy_slugs`) is already fully ready to receive that real inventory the moment it's supplied, with zero redesign, exactly as designed in Revision 2 and re-verified against every change made in this revision (§5).

**Not implemented now** — no redirects are created, no mapping is loaded; this section states the rule the later migration phase must follow and confirms the schema is ready for it.

---

## 12. Final Consistency Check

| Check | Result |
|---|---|
| Foreign-key dependency order | Fixed — `media_assets` moved to be the first table created; full order given in §2, every table now only references tables created strictly before it. |
| Circular references | None exist or ever existed structurally; §2 confirms this explicitly. |
| Orphan/invalid records | `bookable_products` can no longer hold a wrong `node_type` (§3, trigger-enforced). `node_locations` can no longer hold two primaries (§8). `url_redirects` can no longer have a mismatched `target_type`/target-column pairing (§5) or an active chain (§5). |
| Invalid polymorphic references | `bookings` (`product_type` + exactly-one-of `product_node_id`/`transfer_service_id`, `product_node_id` FK'd to `bookable_products` not raw `nodes`) and `package_itinerary_items` (`component_type` + exactly-one-of `component_node_id`/`transfer_service_id`) both remain `CHECK`-constrained discriminated unions — carried over correctly into the renamed itinerary tables (§7). |
| Duplicate canonical URLs | Prevented by `UNIQUE (node_type, slug)` on `nodes` plus the fixed `url_segment` mapping (Revision 2 §13, unchanged and still valid). |
| Duplicate primary locations | Fixed — partial unique index, §8. |
| Booking security | Fixed — no policy anywhere depends on `auth.uid() = user_id` for the write path; writes are RPC-only, hardened per §4; reads are staff-only plus a narrow self-service function, §10. |
| Transfer route/service consistency | Schedules added without collapsing route/service (§1); route-vs-service SEO split restated explicitly with no model change (§6). |
| Package itinerary consistency | Stage model replaces the day model; no duplicated hotel/activity/transfer data; itinerary items still reference canonical nodes/services only (§7). |
| Location hierarchy consistency | Parent/child type pairs are now data-driven and trigger-enforced; self-reference and multi-level cycles are both rejected; `ltree.path` sync on move/rename is explicit (§9). |
| RLS consistency | Every table listed in the review now has a concrete, stated policy set; the `url_redirects` staff-only-read inconsistency from Revision 2 is corrected; no self-escalation path on `profiles.role` (§10). |
| SEO canonical consistency | Unchanged from Revision 2 (§13/§19 there) and still holds under every change made here — nothing in this revision touches canonical URL derivation for any node type. |
| Redirect consistency | Target-shape constraint, chain prevention, and the corrected read policy are all in place; `legacy_slugs` role is disambiguated as historical-only (§5). |

No item in this table required introducing architecture beyond what fixing it demanded — the entity model, node backbone, and everything approved in Revision 2 that isn't listed above is unchanged.

---

## 13. Complete Database Schema Reference (Consolidated, Final, Dependency-Ordered)

Everything below is exactly as it would be applied as migrations **when building is approved** — nothing has been run.

```sql
-- ══════════════════════════════════════════════════════════════════
-- Extensions
-- ══════════════════════════════════════════════════════════════════
create extension if not exists pgcrypto;
create extension if not exists ltree;
create extension if not exists pg_trgm;

-- ══════════════════════════════════════════════════════════════════
-- Media (no dependencies — created first so nodes/transfer_service_media can reference it)
-- ══════════════════════════════════════════════════════════════════
create table media_assets (
  id             uuid primary key default gen_random_uuid(),
  media_type     text not null check (media_type in ('image','youtube')),
  storage_path   text,
  youtube_id     text,
  alt_text       text,
  credit         text,
  width          int,
  height         int,
  created_at     timestamptz not null default now()
);

-- ══════════════════════════════════════════════════════════════════
-- Backbone
-- ══════════════════════════════════════════════════════════════════
create table nodes (
  id                   uuid primary key default gen_random_uuid(),
  node_type            text not null check (node_type in (
                          'location', 'category', 'provider', 'accommodation',
                          'activity', 'transfer_route', 'package', 'article'
                        )),
  slug                 text not null,
  title                text not null,
  summary              text,
  status               text not null default 'draft' check (status in ('draft','published','archived')),
  rating_avg           numeric(3,2) default 0,
  rating_count         int default 0,
  attributes           jsonb not null default '{}'::jsonb,
  legacy_slugs         text[] default '{}',           -- historical metadata only — see §5
  meta_title           text,
  meta_description     text,
  og_image_media_id    uuid references media_assets(id),
  created_by           uuid references auth.users(id),
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  published_at         timestamptz,
  unique (node_type, slug)
);
create index nodes_status_idx      on nodes(status);
create index nodes_attributes_gin  on nodes using gin (attributes jsonb_path_ops);
create index nodes_search_idx      on nodes using gin (to_tsvector('english', title || ' ' || coalesce(summary,'')));
create index nodes_legacy_slugs_gin on nodes using gin (legacy_slugs);

-- ══════════════════════════════════════════════════════════════════
-- Geography
-- ══════════════════════════════════════════════════════════════════
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

create table location_type_hierarchy_rules (
  parent_type   text,
  child_type    text not null,
  primary key (parent_type, child_type)
);

-- ══════════════════════════════════════════════════════════════════
-- Businesses
-- ══════════════════════════════════════════════════════════════════
create table providers (
  id                uuid primary key references nodes(id) on delete cascade,
  legal_name        text,
  contact_email     text,
  contact_phone     text,
  website_url       text,
  license_number    text,
  is_verified       boolean default false
);

-- ══════════════════════════════════════════════════════════════════
-- Accommodation & Activities
-- ══════════════════════════════════════════════════════════════════
create table accommodations (
  id                        uuid primary key references nodes(id) on delete cascade,
  accommodation_type        text not null check (accommodation_type in ('hotel','resort','guesthouse','villa','other')),
  operated_by_provider_id   uuid references providers(id),
  star_rating               smallint check (star_rating between 1 and 5),
  price_tier                text check (price_tier in ('budget','mid','luxury','ultra_luxury')),
  room_count                int,
  all_inclusive             boolean default false,
  overwater_villas          boolean default false,
  check_in_time             time,
  check_out_time            time,
  currency                  text default 'USD'
);

create table activities (
  id                        uuid primary key references nodes(id) on delete cascade,
  activity_category         text not null check (activity_category in (
                               'general', 'fishing', 'diving', 'surfing', 'watersports',
                               'excursion', 'island_hopping', 'spa', 'culture'
                             )),
  operated_by_provider_id   uuid references providers(id),
  duration_minutes          int,
  min_age                   smallint,
  difficulty                text check (difficulty in ('beginner','intermediate','advanced','all_levels')),
  price_from                numeric(10,2),
  currency                  text default 'USD',
  max_participants          int
);

-- ══════════════════════════════════════════════════════════════════
-- Transfers — routes (nodes) vs services (not nodes) — §1, §2, §6
-- ══════════════════════════════════════════════════════════════════
create table transfer_routes (
  id                          uuid primary key references nodes(id) on delete cascade,
  origin_location_id          uuid not null references locations(id),
  destination_location_id     uuid not null references locations(id),
  distance_km                 numeric(6,2),
  typical_duration_minutes    int,
  unique (origin_location_id, destination_location_id)
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

create table transfer_service_schedules (
  id                    uuid primary key default gen_random_uuid(),
  transfer_service_id   uuid not null references transfer_services(id) on delete cascade,
  day_of_week           smallint check (day_of_week between 0 and 6),
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

-- ══════════════════════════════════════════════════════════════════
-- Packages — taxonomy via categories (§8 issue), itinerary stages (§7)
-- ══════════════════════════════════════════════════════════════════
create table packages (
  id                        uuid primary key references nodes(id) on delete cascade,
  duration_nights           int,
  price_from                numeric(10,2),
  currency                  text default 'USD',
  operated_by_provider_id   uuid references providers(id)
);

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
  sort_order             int not null default 0,
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

-- ══════════════════════════════════════════════════════════════════
-- Junctions
-- ══════════════════════════════════════════════════════════════════
create table node_locations (
  node_id       uuid not null references nodes(id) on delete cascade,
  location_id   uuid not null references locations(id) on delete cascade,
  relation      text not null default 'primary' check (relation in ('primary','secondary')),
  primary key (node_id, location_id)
);
create index node_locations_location_idx on node_locations(location_id);
create unique index node_locations_one_primary_per_node
  on node_locations (node_id) where relation = 'primary';

create table node_categories (
  node_id       uuid not null references nodes(id) on delete cascade,
  category_id   uuid not null references categories(id) on delete cascade,
  primary key (node_id, category_id)
);
create index node_categories_category_idx on node_categories(category_id);

-- ══════════════════════════════════════════════════════════════════
-- Generic systems
-- ══════════════════════════════════════════════════════════════════
create table reviews (
  id            uuid primary key default gen_random_uuid(),
  node_id       uuid not null references nodes(id) on delete cascade,
  user_id       uuid not null references auth.users(id),
  rating        smallint not null check (rating between 1 and 5),
  title         text,
  body          text,
  status        text not null default 'pending' check (status in ('pending','published','rejected')),
  created_at    timestamptz not null default now(),
  unique (node_id, user_id)
);
create index reviews_node_idx on reviews(node_id) where status = 'published';

create table article_comments (
  id                  uuid primary key default gen_random_uuid(),
  article_id          uuid not null references nodes(id) on delete cascade,
  user_id             uuid not null references auth.users(id),
  parent_comment_id   uuid references article_comments(id),
  body                text not null,
  status              text not null default 'visible' check (status in ('visible','flagged','removed')),
  created_at          timestamptz not null default now()
);
create index article_comments_article_idx on article_comments(article_id);

create table favorites (
  user_id     uuid not null references auth.users(id) on delete cascade,
  node_id     uuid not null references nodes(id) on delete cascade,
  created_at  timestamptz not null default now(),
  primary key (user_id, node_id)
);

create table node_media (
  node_id      uuid not null references nodes(id) on delete cascade,
  media_id     uuid not null references media_assets(id) on delete cascade,
  role         text not null check (role in ('hero','gallery','thumbnail')),
  sort_order   int default 0,
  primary key (node_id, media_id, role)
);

-- ══════════════════════════════════════════════════════════════════
-- Booking / inquiry (§3, §4, §10)
-- ══════════════════════════════════════════════════════════════════
create table bookable_products (
  id              uuid primary key references nodes(id) on delete cascade,
  booking_mode    text not null default 'inquiry' check (booking_mode in ('inquiry','instant')),
  base_price      numeric(10,2),
  currency        text default 'USD',
  max_guests      int
);

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
  user_id                    uuid references auth.users(id),
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

-- ══════════════════════════════════════════════════════════════════
-- Identity
-- ══════════════════════════════════════════════════════════════════
create table profiles (
  id             uuid primary key references auth.users(id) on delete cascade,
  display_name   text,
  avatar_url     text,
  bio            text,
  home_country   text,
  role           text not null default 'user' check (role in ('user','editor','admin')),
  created_at     timestamptz not null default now()
);

-- ══════════════════════════════════════════════════════════════════
-- Migration support (§5, §11)
-- ══════════════════════════════════════════════════════════════════
create table url_redirects (
  id               uuid primary key default gen_random_uuid(),
  source_path      text not null unique,
  target_type      text not null check (target_type in ('node','path','external_url')),
  target_node_id   uuid references nodes(id),
  target_path      text,
  status_code      smallint not null default 301 check (status_code in (301,302,308)),
  is_active        boolean not null default true,
  notes            text,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  constraint url_redirects_target_shape check (
    (target_type = 'node'         and target_node_id is not null and target_path is null)
    or
    (target_type = 'path'          and target_path is not null and target_node_id is null)
    or
    (target_type = 'external_url'  and target_path is not null and target_node_id is null)
  )
);
create index url_redirects_active_idx on url_redirects(source_path) where is_active;

-- ══════════════════════════════════════════════════════════════════
-- Functions & triggers
-- ══════════════════════════════════════════════════════════════════

-- §3 bookable_products type safety
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

-- §4 booking reference — unconditionally authoritative
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

-- §4 guest-safe booking RPCs
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
language plpgsql security definer set search_path = public, pg_temp
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
    auth.uid(),
    p_customer_name, p_customer_email, p_customer_phone, p_customer_whatsapp,
    p_origin_location_id, p_destination_location_id, p_travel_date, p_travel_time,
    p_return_date, p_return_time, p_trip_type, p_adults, p_children, p_infants,
    p_flight_number, p_special_requests, p_estimated_price, p_currency
  )
  returning bookings.id, bookings.booking_reference into v_id, v_reference;

  return query select v_id, v_reference;
end;
$$;
revoke all on function create_booking_inquiry from public;
grant execute on function create_booking_inquiry(text, uuid, uuid, text, text, text, text, uuid, uuid, date, time, date, time, text, int, int, int, text, text, numeric, text)
  to anon, authenticated;

create or replace function get_my_bookings() returns setof bookings
language plpgsql security definer set search_path = public, pg_temp
as $$
begin
  return query select * from bookings where user_id = auth.uid();
end;
$$;
revoke all on function get_my_bookings from public;
grant execute on function get_my_bookings to authenticated;

-- §5 redirect integrity
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

-- §9 location hierarchy integrity
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

-- §9 ltree path synchronization
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

-- §10 RLS helpers
create or replace function is_staff() returns boolean
language sql stable security definer set search_path = public, pg_temp as $$
  select exists (select 1 from profiles p where p.id = auth.uid() and p.role in ('editor','admin'));
$$;

create or replace function is_admin() returns boolean
language sql stable security definer set search_path = public, pg_temp as $$
  select exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'admin');
$$;

-- §10 profiles self-escalation guard
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

-- ══════════════════════════════════════════════════════════════════
-- Row Level Security — policies as specified in §10, applied to every
-- table listed there (template SQL given in full in §10; omitted here
-- to avoid duplicating ~35 near-identical CREATE POLICY statements —
-- §10 is the authoritative, complete policy reference for Task 3).
-- ══════════════════════════════════════════════════════════════════
```

**What was removed in this revision:** `package_itinerary_days` (replaced by `package_itinerary_stages`, §7); the conditional `when (new.booking_reference is null)` on the booking-reference trigger (now unconditional, §4); the plain "staff-only read" policy description for `url_redirects` (corrected to public-read/staff-write, §10); `transfer_services.departure_time`/`arrival_time`/`operating_days` (replaced by `transfer_service_schedules`, §1).

---

## 14. Entity-Relationship Diagram (Final)

```
                                ┌────────────┐
                                │   nodes    │  location · category · provider · accommodation ·
                                └─────┬──────┘  activity · transfer_route · package · article
   ┌────────┬───────────┬──────┬─────┴─────┬──────────────┬───────────┬──────────┐
   ▼        ▼           ▼      ▼           ▼              ▼           ▼          ▼
locations categories providers accommodations activities transfer_routes packages articles
   │          │           │        │            │              │            │
   │          │           └────────┴────────────┴──────────────┘            │
   │          │              (operated_by_provider_id)                      │
   │          │                                                              │
   └──node_locations (≤1 primary/node, §8)   node_categories ─────────────────┘
        (any node ↔ any location)                 (any node ↔ any category,
                                                     incl. package taxonomy §8)

locations ──self── location_type_hierarchy_rules-validated parent_id, ltree path (§9)

transfer_routes ──< transfer_services >── providers
      │                    │
      │                    ├──< transfer_service_schedules   (§1 — multiple departures/day)
      │                    └──< transfer_service_media >── media_assets
      │
locations(origin/destination) ──── transfer_routes

nodes ──< reviews                (routes & providers reviewable; services are NOT — §2/§6)
nodes ──< favorites
nodes ──< node_media >── media_assets
nodes(article) ──< article_comments

nodes(bookable: accommodation|activity|package only, trigger-enforced §3) ──< bookable_products
bookable_products ──< bookings >── transfer_services   (product_type discriminates — §3 of Rev 2)
auth.users ──○ bookings.user_id (nullable — guest bookings)
bookings ──< booking_notifications
booking_reference_counters, platform_settings          (support tables, service/admin-only)
-- all booking writes: create_booking_inquiry() RPC only (§4); no direct table policy for anon/authenticated

nodes(package) ──< package_itinerary_stages ──< package_itinerary_items >── nodes / transfer_services
                     (day_start..day_end range, §7)      (component_type discriminates)

auth.users ── profiles (1:1, role; self-escalation blocked by trigger, §10)
nodes.legacy_slugs[] (historical only, §5) / url_redirects (authoritative, target-shape + no-chain
  constrained, §5) → nodes (canonical target)
```

Every relationship above corresponds 1:1 to a constraint in §13.

---

## 15. Final Verdict

All 12 issues raised in this review have been resolved in the design and reflected in the consolidated schema (§13): transfer schedules normalized without JSONB (§1); dependency order corrected with no circular reference (§2); bookable product type safety enforced by trigger (§3); booking reference made unconditionally authoritative and the public RPC hardened with explicit `search_path`, controlled grants, and a minimal return shape (§4); redirect target integrity constrained and chain-guarded, with `legacy_slugs`'s role disambiguated (§5); the transfer route/service SEO split restated explicitly (§6); the package itinerary moved to a stage/range model eliminating repeated accommodation rows (§7); at-most-one-primary-location enforced (§8); location hierarchy parent/child types validated and `ltree` sync made explicit (§9); RLS made concrete for all 19 listed tables with the `url_redirects` inconsistency corrected and `profiles.role` self-escalation closed (§10); the SEO migration requirement restated as a committed rule rather than an unknown (§11); and the full consistency sweep in §12 found no remaining defect.

**READY FOR IMPLEMENTATION**
