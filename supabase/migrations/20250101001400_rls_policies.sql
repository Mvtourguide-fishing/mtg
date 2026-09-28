-- MTG foundation: Row Level Security. Default-deny on every table; policies
-- below are the concrete implementation of Task 2 Revision 3 §10.

-- ═══════════════════════════════════════════════════════════════════
-- nodes — public read when published; all writes staff-only.
-- ═══════════════════════════════════════════════════════════════════
alter table nodes enable row level security;
create policy nodes_public_read on nodes for select using (status = 'published');
create policy nodes_staff_read   on nodes for select using (is_staff());
create policy nodes_staff_write  on nodes for insert with check (is_staff());
create policy nodes_staff_update on nodes for update using (is_staff()) with check (is_staff());
create policy nodes_staff_delete on nodes for delete using (is_staff());

-- ═══════════════════════════════════════════════════════════════════
-- 1:1 detail tables sharing nodes.id — public read gated on the parent
-- node being published; all writes staff-only.
-- ═══════════════════════════════════════════════════════════════════
alter table locations enable row level security;
create policy locations_public_read on locations for select
  using (exists (select 1 from nodes n where n.id = locations.id and n.status = 'published'));
create policy locations_staff_all on locations for all
  using (is_staff()) with check (is_staff());

alter table categories enable row level security;
create policy categories_public_read on categories for select
  using (exists (select 1 from nodes n where n.id = categories.id and n.status = 'published'));
create policy categories_staff_all on categories for all
  using (is_staff()) with check (is_staff());

alter table providers enable row level security;
create policy providers_public_read on providers for select
  using (exists (select 1 from nodes n where n.id = providers.id and n.status = 'published'));
create policy providers_staff_all on providers for all
  using (is_staff()) with check (is_staff());

alter table accommodations enable row level security;
create policy accommodations_public_read on accommodations for select
  using (exists (select 1 from nodes n where n.id = accommodations.id and n.status = 'published'));
create policy accommodations_staff_all on accommodations for all
  using (is_staff()) with check (is_staff());

alter table activities enable row level security;
create policy activities_public_read on activities for select
  using (exists (select 1 from nodes n where n.id = activities.id and n.status = 'published'));
create policy activities_staff_all on activities for all
  using (is_staff()) with check (is_staff());

alter table transfer_routes enable row level security;
create policy transfer_routes_public_read on transfer_routes for select
  using (exists (select 1 from nodes n where n.id = transfer_routes.id and n.status = 'published'));
create policy transfer_routes_staff_all on transfer_routes for all
  using (is_staff()) with check (is_staff());

alter table packages enable row level security;
create policy packages_public_read on packages for select
  using (exists (select 1 from nodes n where n.id = packages.id and n.status = 'published'));
create policy packages_staff_all on packages for all
  using (is_staff()) with check (is_staff());

alter table articles enable row level security;
create policy articles_public_read on articles for select
  using (exists (select 1 from nodes n where n.id = articles.id and n.status = 'published'));
create policy articles_staff_all on articles for all
  using (is_staff()) with check (is_staff());

-- ═══════════════════════════════════════════════════════════════════
-- attribute_definitions / location_type_hierarchy_rules — configuration,
-- not content: public read (harmless, needed to drive public filter UIs),
-- staff write.
-- ═══════════════════════════════════════════════════════════════════
alter table attribute_definitions enable row level security;
create policy attribute_definitions_public_read on attribute_definitions for select using (true);
create policy attribute_definitions_staff_all on attribute_definitions for all
  using (is_staff()) with check (is_staff());

alter table location_type_hierarchy_rules enable row level security;
create policy location_type_hierarchy_rules_public_read on location_type_hierarchy_rules for select using (true);
create policy location_type_hierarchy_rules_staff_all on location_type_hierarchy_rules for all
  using (is_staff()) with check (is_staff());

-- ═══════════════════════════════════════════════════════════════════
-- Junctions / child tables gated through their parent node.
-- ═══════════════════════════════════════════════════════════════════
alter table node_locations enable row level security;
create policy node_locations_public_read on node_locations for select
  using (exists (select 1 from nodes n where n.id = node_locations.node_id and n.status = 'published'));
create policy node_locations_staff_all on node_locations for all
  using (is_staff()) with check (is_staff());

alter table node_categories enable row level security;
create policy node_categories_public_read on node_categories for select
  using (exists (select 1 from nodes n where n.id = node_categories.node_id and n.status = 'published'));
create policy node_categories_staff_all on node_categories for all
  using (is_staff()) with check (is_staff());

alter table node_media enable row level security;
create policy node_media_public_read on node_media for select
  using (exists (select 1 from nodes n where n.id = node_media.node_id and n.status = 'published'));
create policy node_media_staff_all on node_media for all
  using (is_staff()) with check (is_staff());

alter table bookable_products enable row level security;
create policy bookable_products_public_read on bookable_products for select
  using (exists (select 1 from nodes n where n.id = bookable_products.id and n.status = 'published'));
create policy bookable_products_staff_all on bookable_products for all
  using (is_staff()) with check (is_staff());
-- (enforce_bookable_product_node_type() trigger applies underneath regardless of role)

-- ═══════════════════════════════════════════════════════════════════
-- media_assets — no publish gate of its own; public read, staff write.
-- ═══════════════════════════════════════════════════════════════════
alter table media_assets enable row level security;
create policy media_assets_public_read on media_assets for select using (true);
create policy media_assets_staff_all   on media_assets for all using (is_staff()) with check (is_staff());

-- ═══════════════════════════════════════════════════════════════════
-- Transfer-specific tables — gated through the route's node status and the
-- service/schedule's own operational status.
-- ═══════════════════════════════════════════════════════════════════
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

-- ═══════════════════════════════════════════════════════════════════
-- Package itinerary — staff-managed content, gated on the package's
-- published status for reads (a draft package's itinerary isn't public).
-- ═══════════════════════════════════════════════════════════════════
alter table package_itinerary_stages enable row level security;
create policy package_itinerary_stages_public_read on package_itinerary_stages for select
  using (exists (select 1 from nodes n where n.id = package_itinerary_stages.package_id and n.status = 'published'));
create policy package_itinerary_stages_staff_all on package_itinerary_stages for all
  using (is_staff()) with check (is_staff());

alter table package_itinerary_items enable row level security;
create policy package_itinerary_items_public_read on package_itinerary_items for select
  using (
    exists (
      select 1 from package_itinerary_stages s join nodes n on n.id = s.package_id
      where s.id = package_itinerary_items.stage_id and n.status = 'published'
    )
  );
create policy package_itinerary_items_staff_all on package_itinerary_items for all
  using (is_staff()) with check (is_staff());

-- ═══════════════════════════════════════════════════════════════════
-- User-generated content — identity-bound (an account is required to
-- review, comment, or favorite; bookings are the deliberate exception,
-- handled separately below).
-- ═══════════════════════════════════════════════════════════════════
alter table reviews enable row level security;
create policy reviews_public_read    on reviews for select using (status = 'published');
create policy reviews_own_read       on reviews for select using (auth.uid() = user_id);
create policy reviews_staff_read     on reviews for select using (is_staff());
create policy reviews_own_insert     on reviews for insert with check (auth.uid() = user_id);
create policy reviews_own_update     on reviews for update using (auth.uid() = user_id);
create policy reviews_own_delete     on reviews for delete using (auth.uid() = user_id);
create policy reviews_staff_moderate on reviews for update using (is_staff());
create policy reviews_staff_delete   on reviews for delete using (is_staff());

alter table article_comments enable row level security;
create policy article_comments_public_read on article_comments for select using (status = 'visible');
create policy article_comments_own_read    on article_comments for select using (auth.uid() = user_id);
create policy article_comments_staff_read  on article_comments for select using (is_staff());
create policy article_comments_own_insert  on article_comments for insert with check (auth.uid() = user_id);
create policy article_comments_own_update  on article_comments for update using (auth.uid() = user_id);
create policy article_comments_own_delete  on article_comments for delete using (auth.uid() = user_id);
create policy article_comments_staff_moderate on article_comments for update using (is_staff());
create policy article_comments_staff_delete   on article_comments for delete using (is_staff());

alter table favorites enable row level security;
create policy favorites_owner_all on favorites for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
-- no public policy, no staff override — favorites are private and carry no moderation-relevant content

-- ═══════════════════════════════════════════════════════════════════
-- profiles — public read (display name/avatar shown alongside reviews/
-- comments), self-update, admin override. Self-escalation on `role` is
-- additionally blocked by the trigger in the functions/triggers migration.
-- ═══════════════════════════════════════════════════════════════════
alter table profiles enable row level security;
create policy profiles_public_read on profiles for select using (true);
create policy profiles_self_update on profiles for update
  using (auth.uid() = id) with check (auth.uid() = id);
create policy profiles_admin_all on profiles for all
  using (is_admin()) with check (is_admin());

-- ═══════════════════════════════════════════════════════════════════
-- Bookings and support tables — no policy anywhere relies on
-- auth.uid() = user_id as a write gate (guest bookings have no auth.uid()).
-- Table owner (postgres) bypasses RLS on tables it owns, which is what
-- lets the SECURITY DEFINER RPCs below write/read despite no
-- anon/authenticated policy granting it directly.
-- ═══════════════════════════════════════════════════════════════════
alter table bookings enable row level security;
create policy bookings_staff_read   on bookings for select using (is_staff());
create policy bookings_staff_update on bookings for update using (is_staff()) with check (is_staff());
-- No insert/delete policy for any client role, and no policy referencing
-- auth.uid() = user_id. All inserts: create_booking_inquiry(). Self-service
-- reads: get_my_bookings(). Both are SECURITY DEFINER, defined already.

alter table booking_notifications enable row level security;
create policy booking_notifications_staff_read on booking_notifications for select using (is_staff());
-- writes: service_role only (Edge Function), which bypasses RLS by design

alter table platform_settings enable row level security;
create policy platform_settings_admin_read  on platform_settings for select using (is_admin());
create policy platform_settings_admin_write on platform_settings for all using (is_admin()) with check (is_admin());

alter table booking_reference_counters enable row level security;
-- zero client-role policies — touched only internally by the
-- booking_reference trigger, in the same privileged insert context.

-- ═══════════════════════════════════════════════════════════════════
-- url_redirects — public read for active rows (middleware resolves
-- redirects on every unmatched request, not as an authenticated staff
-- session); writes staff-only.
-- ═══════════════════════════════════════════════════════════════════
alter table url_redirects enable row level security;
create policy url_redirects_public_read on url_redirects for select using (is_active);
create policy url_redirects_staff_all   on url_redirects for all using (is_staff()) with check (is_staff());
