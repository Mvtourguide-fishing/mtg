import "server-only";

import { getAccommodationsByLocation } from "@/lib/accommodations/repository";
import { getCategoryBySlug, getNodeIdsByCategory } from "@/lib/categories/repository";
import { getLocationSummariesByIds } from "@/lib/locations/repository";
import { getHeroMediaByNodeIds } from "@/lib/media/repository";
import type { MediaAsset } from "@/lib/media/types";
import { getProviderSummariesByIds } from "@/lib/providers/repository";
import { createClient } from "@/lib/supabase/public";
import type {
  GetTransferRoutesOptions,
  PaginatedResult,
  SharedOrPrivate,
  TransferRouteDetail,
  TransferRouteSummary,
  TransferService,
  TransferServiceSchedule,
  TransferServiceStatus,
  TransferType,
} from "@/lib/transfers/types";

/**
 * Server-side transfer data-access layer, following the same pattern as
 * src/lib/activities/repository.ts: pages call these functions, never
 * Supabase directly. Every function only returns published routes /
 * active-by-default services.
 *
 * `transfer_routes` is embedded under `nodes` with a plain `!inner` (no FK
 * name needed) because there is exactly one relationship between the two
 * tables — the direct `transfer_routes_id_fkey`. No junction table
 * connects them a second way, so this is NOT the same ambiguity class that
 * hit `locations`/`categories`; confirmed by introspecting the live
 * schema's actual foreign-key constraints before writing this file.
 *
 * Origin/destination locations and service providers are deliberately
 * NOT embedded inline (that would require naming
 * `transfer_routes_origin_location_id_fkey` /
 * `transfer_routes_destination_location_id_fkey` explicitly, since
 * `transfer_routes` has two separate FK columns to the same `locations`
 * table — a different, real ambiguity). Instead they're batch-resolved via
 * the existing, already-fixed `getLocationSummariesByIds` /
 * `getProviderSummariesByIds` helpers, exactly like the N+1-avoidance
 * pattern already established in src/lib/activities/repository.ts. This
 * reuses proven-safe code paths rather than adding a new nested embed.
 */

const NODE_TRANSFER_ROUTE_SELECT =
  "id, slug, title, summary, meta_title, meta_description, transfer_routes!inner(origin_location_id, destination_location_id, distance_km, typical_duration_minutes)";

type TransferRouteFields = {
  origin_location_id: string;
  destination_location_id: string;
  distance_km: number | null;
  typical_duration_minutes: number | null;
};

type NodeTransferRouteRow = {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  meta_title: string | null;
  meta_description: string | null;
  // Defensive-coded as possibly-an-array — see the identical note in
  // src/lib/locations/repository.ts (one-to-one embed shape couldn't be
  // verified end-to-end before this task's live Supabase access).
  transfer_routes: TransferRouteFields | TransferRouteFields[] | null;
};

interface BareRoute {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  metaTitle: string | null;
  metaDescription: string | null;
  originLocationId: string;
  destinationLocationId: string;
  distanceKm: number | null;
  typicalDurationMinutes: number | null;
}

function bareRouteOf(row: NodeTransferRouteRow): BareRoute | null {
  const r = Array.isArray(row.transfer_routes) ? row.transfer_routes[0] : row.transfer_routes;
  if (!r) return null;

  return {
    id: row.id,
    slug: row.slug,
    title: row.title,
    summary: row.summary,
    metaTitle: row.meta_title,
    metaDescription: row.meta_description,
    originLocationId: r.origin_location_id,
    destinationLocationId: r.destination_location_id,
    distanceKm: r.distance_km,
    typicalDurationMinutes: r.typical_duration_minutes,
  };
}

type TransferServiceRow = {
  id: string;
  route_id: string;
  provider_id: string | null;
  transfer_type: TransferType;
  vehicle_type: string | null;
  shared_or_private: SharedOrPrivate;
  duration_minutes: number | null;
  price: number;
  currency: string;
  capacity: number | null;
  luggage_allowance: string | null;
  status: TransferServiceStatus;
  pickup_instructions: string | null;
  dropoff_instructions: string | null;
  booking_requirements: string | null;
  cancellation_policy: string | null;
  description: string | null;
  is_bookable: boolean;
  facilities: string[];
};

type TransferServiceScheduleRow = {
  id: string;
  transfer_service_id: string;
  day_of_week: number | null;
  departure_time: string | null;
  arrival_time: string | null;
  duration_minutes: number | null;
  effective_from: string | null;
  effective_to: string | null;
  status: "active" | "inactive";
  sort_order: number;
};

function scheduleOf(row: TransferServiceScheduleRow): TransferServiceSchedule {
  return {
    id: row.id,
    dayOfWeek: row.day_of_week,
    departureTime: row.departure_time,
    arrivalTime: row.arrival_time,
    durationMinutes: row.duration_minutes,
    effectiveFrom: row.effective_from,
    effectiveTo: row.effective_to,
    status: row.status,
    sortOrder: row.sort_order,
  };
}

/** Every schedule row for a set of services, in one batched query — same
 * N+1-avoidance shape as attachPrimaryLocations in the activities repo. */
async function getSchedulesByServiceIds(serviceIds: string[]): Promise<Map<string, TransferServiceSchedule[]>> {
  const map = new Map<string, TransferServiceSchedule[]>();
  if (serviceIds.length === 0) return map;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("transfer_service_schedules")
    .select("id, transfer_service_id, day_of_week, departure_time, arrival_time, duration_minutes, effective_from, effective_to, status, sort_order")
    .in("transfer_service_id", serviceIds)
    .eq("status", "active")
    .order("sort_order", { ascending: true })
    .returns<TransferServiceScheduleRow[]>();

  if (error || !data) return map;

  for (const row of data) {
    const list = map.get(row.transfer_service_id) ?? [];
    list.push(scheduleOf(row));
    map.set(row.transfer_service_id, list);
  }
  return map;
}

/** Every service row for a set of routes, with providers and schedules
 * batch-resolved, in one pass — used by both the route-detail page (one
 * route) and any future multi-route listing that wants service counts. */
async function getServicesByRouteIds(routeIds: string[]): Promise<Map<string, TransferService[]>> {
  const map = new Map<string, TransferService[]>();
  if (routeIds.length === 0) return map;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("transfer_services")
    .select(
      "id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes, price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions, booking_requirements, cancellation_policy, description, is_bookable, facilities",
    )
    .in("route_id", routeIds)
    .eq("status", "active")
    .order("price", { ascending: true })
    .returns<TransferServiceRow[]>();

  if (error || !data) return map;

  const providerIds = Array.from(new Set(data.map((s) => s.provider_id).filter((id): id is string => Boolean(id))));
  const serviceIds = data.map((s) => s.id);

  const [providersById, schedulesById] = await Promise.all([
    getProviderSummariesByIds(providerIds),
    getSchedulesByServiceIds(serviceIds),
  ]);

  for (const row of data) {
    const service: TransferService = {
      id: row.id,
      routeId: row.route_id,
      provider: row.provider_id ? providersById.get(row.provider_id) ?? null : null,
      transferType: row.transfer_type,
      vehicleType: row.vehicle_type,
      sharedOrPrivate: row.shared_or_private,
      durationMinutes: row.duration_minutes,
      price: row.price,
      currency: row.currency,
      capacity: row.capacity,
      luggageAllowance: row.luggage_allowance,
      status: row.status,
      pickupInstructions: row.pickup_instructions,
      dropoffInstructions: row.dropoff_instructions,
      bookingRequirements: row.booking_requirements,
      cancellationPolicy: row.cancellation_policy,
      description: row.description,
      isBookable: row.is_bookable,
      facilities: row.facilities ?? [],
      schedules: schedulesById.get(row.id) ?? [],
    };
    const list = map.get(row.route_id) ?? [];
    list.push(service);
    map.set(row.route_id, list);
  }
  return map;
}

/** A route's destination island's own real accommodation photo (already
 * migrated via Task 14's media pipeline) — never a generic stock/
 * speedboat image standing in for a specific resort. Most destinations
 * (especially the ~55 new ones Task 18 recovered directly from legacy
 * transfer pages) have no matching accommodation in the current small
 * catalogue yet and simply get no hero image, which is the honest
 * outcome — not a fabricated substitute. */
async function attachDestinationHeroImages(destinationLocationIds: string[]): Promise<Map<string, MediaAsset>> {
  const result = new Map<string, MediaAsset>();
  const uniqueIds = Array.from(new Set(destinationLocationIds));
  const accommodationLists = await Promise.all(uniqueIds.map((id) => getAccommodationsByLocation(id)));
  uniqueIds.forEach((id, index) => {
    const withImage = accommodationLists[index].find((a) => a.heroImage);
    if (withImage?.heroImage) result.set(id, withImage.heroImage);
  });
  return result;
}

/** transfer-category slugs (Task 20 §22) tagged on a set of route node
 * ids, via the shared node_categories table — one query, then grouped in
 * application code, same "when in doubt, don't embed" reasoning as every
 * other category lookup in this codebase. */
async function getTransferCategoriesForRoutes(routeIds: string[]): Promise<Map<string, string[]>> {
  const map = new Map<string, string[]>();
  if (routeIds.length === 0) return map;

  const supabase = await createClient();
  const { data: tagRows, error: tagError } = await supabase
    .from("node_categories")
    .select("node_id, category_id")
    .in("node_id", routeIds)
    .returns<Array<{ node_id: string; category_id: string }>>();

  if (tagError || !tagRows || tagRows.length === 0) return map;

  const categoryIds = Array.from(new Set(tagRows.map((r) => r.category_id)));
  const { data: categoryRows, error: categoryError } = await supabase
    .from("nodes")
    // Explicit FK name (categories!categories_id_fkey), not the bare
    // categories!inner(...) this file used to have — nodes/categories can
    // be joined two ways (this direct FK, and via node_categories), and a
    // bare embed name is exactly the ambiguity this project has been
    // burned by before (see src/lib/locations/repository.ts's identical
    // note for the same pattern with locations). Task 17 production audit.
    .select("id, slug, categories!categories_id_fkey!inner(category_group)")
    .in("id", categoryIds)
    .eq("categories.category_group", "transfer-category")
    .returns<Array<{ id: string; slug: string }>>();

  if (categoryError || !categoryRows) return map;
  const slugById = new Map(categoryRows.map((c) => [c.id, c.slug]));

  for (const row of tagRows) {
    const slug = slugById.get(row.category_id);
    if (!slug) continue;
    const list = map.get(row.node_id) ?? [];
    list.push(slug);
    map.set(row.node_id, list);
  }
  return map;
}

async function attachOriginDestination(bares: BareRoute[]): Promise<TransferRouteSummary[]> {
  const locationIds = Array.from(new Set(bares.flatMap((b) => [b.originLocationId, b.destinationLocationId])));
  const routeIds = bares.map((b) => b.id);
  const [locationsById, heroImageByDestinationId, routeOwnHeroById, servicesByRoute, categoriesByRoute] = await Promise.all([
    getLocationSummariesByIds(locationIds),
    attachDestinationHeroImages(bares.map((b) => b.destinationLocationId)),
    getHeroMediaByNodeIds(routeIds),
    getServicesByRouteIds(routeIds),
    getTransferCategoriesForRoutes(routeIds),
  ]);

  return bares.map((b) => {
    const services = servicesByRoute.get(b.id) ?? [];
    const cheapest = services.length > 0 ? services[0] : null;
    return {
      id: b.id,
      slug: b.slug,
      title: b.title,
      summary: b.summary,
      origin: locationsById.get(b.originLocationId) ?? null,
      destination: locationsById.get(b.destinationLocationId) ?? null,
      distanceKm: b.distanceKm,
      typicalDurationMinutes: b.typicalDurationMinutes,
      priceFrom: cheapest?.price ?? null,
      currency: cheapest?.currency ?? null,
      // The route's own recovered legacy image (a real "airport to X"
      // photo from the old site) is more specific to the actual transfer
      // than a generic accommodation interior shot, so it takes priority
      // when both exist.
      heroImage: routeOwnHeroById.get(b.id) ?? heroImageByDestinationId.get(b.destinationLocationId) ?? null,
      categories: categoriesByRoute.get(b.id) ?? [],
    };
  });
}

export async function getTransferRoutes(options: GetTransferRoutesOptions = {}): Promise<PaginatedResult<TransferRouteSummary>> {
  const page = Math.max(1, options.page ?? 1);
  const pageSize = Math.min(100, Math.max(1, options.pageSize ?? 24));
  const from = (page - 1) * pageSize;
  const to = from + pageSize - 1;

  const supabase = await createClient();

  let query = supabase
    .from("nodes")
    .select(NODE_TRANSFER_ROUTE_SELECT, { count: "exact" })
    .eq("node_type", "transfer_route")
    .eq("status", "published");

  if (options.originLocationId) query = query.eq("transfer_routes.origin_location_id", options.originLocationId);
  if (options.destinationLocationId) query = query.eq("transfer_routes.destination_location_id", options.destinationLocationId);

  const { data, error, count } = await query.order("title", { ascending: true }).returns<NodeTransferRouteRow[]>();

  if (error || !data) return { items: [], total: 0, page, pageSize };

  let bares = data.map(bareRouteOf).filter((b): b is BareRoute => b !== null);

  // `locationId` (either endpoint) and `atollId` can't be expressed as a
  // single PostgREST filter against two different columns, so they're
  // applied in application code after the base fetch — the route table is
  // small enough (one row per real directional pair) for this to be fine,
  // matching the same pragmatic approach used for atoll-scoped activity
  // filters elsewhere in this codebase.
  if (options.locationId || options.atollId) {
    const locationIds = Array.from(new Set(bares.flatMap((b) => [b.originLocationId, b.destinationLocationId])));
    const locationsById = await getLocationSummariesByIds(locationIds);

    if (options.locationId) {
      const target = options.locationId;
      bares = bares.filter((b) => b.originLocationId === target || b.destinationLocationId === target);
    }
    if (options.atollId) {
      const target = options.atollId;
      bares = bares.filter((b) => {
        const origin = locationsById.get(b.originLocationId);
        const destination = locationsById.get(b.destinationLocationId);
        return (
          origin?.id === target ||
          destination?.id === target ||
          origin?.parentId === target ||
          destination?.parentId === target
        );
      });
    }
  }

  if (options.category) {
    const category = await getCategoryBySlug(options.category, "transfer-category");
    const taggedNodeIds = category ? new Set(await getNodeIdsByCategory(category.id)) : new Set<string>();
    bares = bares.filter((b) => taggedNodeIds.has(b.id));
  }

  const total = options.locationId || options.atollId || options.category ? bares.length : (count ?? bares.length);
  const pageItems = bares.slice(from, to + 1);
  let items = await attachOriginDestination(pageItems);

  if (options.transferType || options.sharedOrPrivate) {
    // Service-level filters require knowing each route's services, which
    // attachOriginDestination already fetched — refetch with the filter
    // applied at the route-summary stage would double-query, so filter the
    // already-resolved summaries by re-deriving from the batched services.
    const routeIds = pageItems.map((b) => b.id);
    const servicesByRoute = await getServicesByRouteIds(routeIds);
    items = items.filter((route) => {
      const services = servicesByRoute.get(route.id) ?? [];
      return services.some(
        (s) =>
          (!options.transferType || s.transferType === options.transferType) &&
          (!options.sharedOrPrivate || s.sharedOrPrivate === options.sharedOrPrivate),
      );
    });
  }

  return { items, total, page, pageSize };
}

export async function getTransferRouteBySlug(slug: string): Promise<TransferRouteDetail | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_TRANSFER_ROUTE_SELECT)
    .eq("node_type", "transfer_route")
    .eq("status", "published")
    .eq("slug", slug)
    .maybeSingle<NodeTransferRouteRow>();

  if (error || !data) return null;
  const bare = bareRouteOf(data);
  if (!bare) return null;

  const [summaries, services, bookableRow] = await Promise.all([
    attachOriginDestination([bare]),
    getServicesByRouteIds([bare.id]).then((m) => m.get(bare.id) ?? []),
    supabase.from("bookable_products").select("id").eq("id", bare.id).maybeSingle(),
  ]);
  const summary = summaries[0];

  return {
    ...summary,
    metaTitle: bare.metaTitle,
    metaDescription: bare.metaDescription,
    services,
    isBookableForPrivateInquiry: Boolean(bookableRow.data),
  };
}

export async function getTransferRoutesByOrigin(originLocationId: string): Promise<TransferRouteSummary[]> {
  const result = await getTransferRoutes({ originLocationId, pageSize: 100 });
  return result.items;
}

export async function getTransferRoutesByDestination(destinationLocationId: string): Promise<TransferRouteSummary[]> {
  const result = await getTransferRoutes({ destinationLocationId, pageSize: 100 });
  return result.items;
}

/** Every route touching a location, in either direction — used by island/
 * atoll pages ("transfers from/to here"). */
export async function getTransferRoutesByLocation(locationId: string): Promise<TransferRouteSummary[]> {
  const result = await getTransferRoutes({ locationId, pageSize: 100 });
  return result.items;
}

export async function getTransferRoutesByAtoll(atollId: string): Promise<TransferRouteSummary[]> {
  const result = await getTransferRoutes({ atollId, pageSize: 100 });
  return result.items;
}

export interface SearchTransferRoutesOptions {
  limit?: number;
}

/** Matches on origin or destination title — e.g. searching "Maafushi"
 * finds both "Velana International Airport to Maafushi" and "Maafushi to
 * Velana International Airport". Reuses the location hierarchy already in
 * place rather than maintaining a second location search index. */
export async function searchTransferRoutes(query: string, options: SearchTransferRoutesOptions = {}): Promise<TransferRouteSummary[]> {
  const trimmed = query.trim();
  if (trimmed.length === 0) return [];

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_TRANSFER_ROUTE_SELECT)
    .eq("node_type", "transfer_route")
    .eq("status", "published")
    .ilike("title", `%${trimmed}%`)
    .order("title", { ascending: true })
    .limit(options.limit ?? 20)
    .returns<NodeTransferRouteRow[]>();

  if (error || !data) return [];
  const bares = data.map(bareRouteOf).filter((b): b is BareRoute => b !== null);
  return attachOriginDestination(bares);
}

/** Transfer services belonging to one provider, across all of that
 * provider's routes — used by the provider detail page. */
export async function getTransferServicesByProvider(providerId: string): Promise<Array<TransferService & { route: TransferRouteSummary }>> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("transfer_services")
    .select(
      "id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes, price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions, booking_requirements, cancellation_policy, description, is_bookable, facilities",
    )
    .eq("provider_id", providerId)
    .eq("status", "active")
    .returns<TransferServiceRow[]>();

  if (error || !data || data.length === 0) return [];

  const routeIds = Array.from(new Set(data.map((s) => s.route_id)));
  const [routesById, schedulesById, providersById] = await Promise.all([
    getTransferRoutesByIds(routeIds),
    getSchedulesByServiceIds(data.map((s) => s.id)),
    getProviderSummariesByIds([providerId]),
  ]);
  const provider = providersById.get(providerId) ?? null;

  const results: Array<TransferService & { route: TransferRouteSummary }> = [];
  for (const row of data) {
    const route = routesById.get(row.route_id);
    if (!route) continue;
    results.push({
      id: row.id,
      routeId: row.route_id,
      provider,
      transferType: row.transfer_type,
      vehicleType: row.vehicle_type,
      sharedOrPrivate: row.shared_or_private,
      durationMinutes: row.duration_minutes,
      price: row.price,
      currency: row.currency,
      capacity: row.capacity,
      luggageAllowance: row.luggage_allowance,
      status: row.status,
      pickupInstructions: row.pickup_instructions,
      dropoffInstructions: row.dropoff_instructions,
      bookingRequirements: row.booking_requirements,
      cancellationPolicy: row.cancellation_policy,
      description: row.description,
      isBookable: row.is_bookable,
      facilities: row.facilities ?? [],
      schedules: schedulesById.get(row.id) ?? [],
      route,
    });
  }
  return results;
}

/** Batch lookup by transfer_routes node id — exported for the package
 * repository (Task 11), which needs route context (origin/destination) for
 * an itinerary item that only stores a transfer_service_id. */
export async function getTransferRoutesByIds(routeIds: string[]): Promise<Map<string, TransferRouteSummary>> {
  const map = new Map<string, TransferRouteSummary>();
  if (routeIds.length === 0) return map;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_TRANSFER_ROUTE_SELECT)
    .eq("node_type", "transfer_route")
    .eq("status", "published")
    .in("id", routeIds)
    .returns<NodeTransferRouteRow[]>();

  if (error || !data) return map;
  const bares = data.map(bareRouteOf).filter((b): b is BareRoute => b !== null);
  const summaries = await attachOriginDestination(bares);
  for (const s of summaries) map.set(s.id, s);
  return map;
}

export async function getTransferServicesByRoute(routeId: string): Promise<TransferService[]> {
  const map = await getServicesByRouteIds([routeId]);
  return map.get(routeId) ?? [];
}

/** Batch lookup by transfer_services.id (not a node id — transfer_services
 * are not nodes) — used by the package repository to resolve itinerary
 * items that reference a specific service without an N+1 query per item
 * (Task 11). */
export async function getTransferServicesByIds(ids: string[]): Promise<Map<string, TransferService>> {
  const map = new Map<string, TransferService>();
  if (ids.length === 0) return map;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("transfer_services")
    .select(
      "id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes, price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions, booking_requirements, cancellation_policy, description, is_bookable, facilities",
    )
    .in("id", ids)
    .returns<TransferServiceRow[]>();

  if (error || !data) return map;

  const providerIds = Array.from(new Set(data.map((s) => s.provider_id).filter((id): id is string => Boolean(id))));
  const [providersById, schedulesById] = await Promise.all([
    getProviderSummariesByIds(providerIds),
    getSchedulesByServiceIds(data.map((s) => s.id)),
  ]);

  for (const row of data) {
    map.set(row.id, {
      id: row.id,
      routeId: row.route_id,
      provider: row.provider_id ? providersById.get(row.provider_id) ?? null : null,
      transferType: row.transfer_type,
      vehicleType: row.vehicle_type,
      sharedOrPrivate: row.shared_or_private,
      durationMinutes: row.duration_minutes,
      price: row.price,
      currency: row.currency,
      capacity: row.capacity,
      luggageAllowance: row.luggage_allowance,
      status: row.status,
      pickupInstructions: row.pickup_instructions,
      dropoffInstructions: row.dropoff_instructions,
      bookingRequirements: row.booking_requirements,
      cancellationPolicy: row.cancellation_policy,
      description: row.description,
      isBookable: row.is_bookable,
      facilities: row.facilities ?? [],
      schedules: schedulesById.get(row.id) ?? [],
    });
  }
  return map;
}

