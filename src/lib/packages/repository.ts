import "server-only";

import { getAccommodationSummariesByIds } from "@/lib/accommodations/repository";
import { getActivitySummariesByIds } from "@/lib/activities/repository";
import { getCategoriesByGroup, getCategoryBySlug, getNodeIdsByCategory } from "@/lib/categories/repository";
import type { CategoryGroup, CategorySummary } from "@/lib/categories/types";
import { getLocationSummariesByIds } from "@/lib/locations/repository";
import type { LocationSummary } from "@/lib/locations/types";
import { getProviderSummariesByIds } from "@/lib/providers/repository";
import type { ProviderSummary } from "@/lib/providers/types";
import { createClient } from "@/lib/supabase/public";
import { getTransferRoutesByIds, getTransferServicesByIds } from "@/lib/transfers/repository";
import type {
  GetPackagesOptions,
  PackageDetail,
  PackageItineraryComponentRole,
  PackageItineraryItem,
  PackageItineraryStage,
  PackageSummary,
  PaginatedResult,
} from "@/lib/packages/types";

/**
 * Server-side package data-access layer (Task 11), following the same
 * pattern as every other vertical repository in this codebase: pages call
 * these functions, never Supabase directly, and every function only
 * returns published packages.
 *
 * `packages!inner(...)` is a plain embed with no FK name required — unlike
 * `locations`/`categories` (fixed earlier this session, see commit
 * 06a9254), no junction table connects `nodes` and `packages` a second way,
 * so there is only one relationship path here. Confirmed by checking
 * supabase/migrations/20250101000700_packages.sql before writing this file.
 *
 * Itinerary reverse-lookups (packages referencing a given accommodation/
 * activity/transfer route) deliberately avoid embeds entirely, resolving
 * `package_itinerary_items -> package_itinerary_stages -> package_id` as
 * two/three separate batched queries instead. This sidesteps any need to
 * reason about ambiguity for a third table pairing, following the same
 * "when in doubt, don't embed" rule used for transfer route
 * origin/destination lookups in src/lib/transfers/repository.ts.
 */

const NODE_PACKAGE_SELECT =
  "id, slug, title, summary, meta_title, meta_description, packages!inner(duration_nights, price_from, currency, operated_by_provider_id)";

type PackageFields = {
  duration_nights: number | null;
  price_from: number | null;
  currency: string | null;
  operated_by_provider_id: string | null;
};

type NodePackageRow = {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  meta_title: string | null;
  meta_description: string | null;
  // Defensive-coded as possibly-an-array — see the identical note in
  // src/lib/locations/repository.ts.
  packages: PackageFields | PackageFields[] | null;
};

interface BarePackage {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  metaTitle: string | null;
  metaDescription: string | null;
  durationNights: number | null;
  priceFrom: number | null;
  currency: string | null;
  providerId: string | null;
}

function barePackageOf(row: NodePackageRow): BarePackage | null {
  const p = Array.isArray(row.packages) ? row.packages[0] : row.packages;
  if (!p) return null;

  return {
    id: row.id,
    slug: row.slug,
    title: row.title,
    summary: row.summary,
    metaTitle: row.meta_title,
    metaDescription: row.meta_description,
    durationNights: p.duration_nights,
    priceFrom: p.price_from,
    currency: p.currency,
    providerId: p.operated_by_provider_id,
  };
}

function toSummary(bare: BarePackage, provider: ProviderSummary | null, destinations: LocationSummary[]): PackageSummary {
  return {
    id: bare.id,
    slug: bare.slug,
    title: bare.title,
    summary: bare.summary,
    durationNights: bare.durationNights,
    priceFrom: bare.priceFrom,
    currency: bare.currency,
    provider,
    destinations,
  };
}

/** Batch-resolve every destination a set of packages is tagged with (ANY
 * node_locations relation, not just 'primary' — a package can genuinely
 * touch several islands, unlike a single accommodation/activity). Primary
 * destinations are sorted first. */
async function attachDestinations(packageIds: string[]): Promise<Map<string, LocationSummary[]>> {
  const result = new Map<string, LocationSummary[]>();
  if (packageIds.length === 0) return result;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("node_locations")
    .select("node_id, location_id, relation")
    .in("node_id", packageIds)
    .returns<Array<{ node_id: string; location_id: string; relation: string }>>();

  if (error || !data) return result;

  const locationsById = await getLocationSummariesByIds(data.map((row) => row.location_id));
  const sorted = [...data].sort((a) => (a.relation === "primary" ? -1 : 1));

  for (const row of sorted) {
    const loc = locationsById.get(row.location_id);
    if (!loc) continue;
    const list = result.get(row.node_id) ?? [];
    list.push(loc);
    result.set(row.node_id, list);
  }
  return result;
}

/** node_ids of every node whose node_locations includes any of `locationIds`
 * — duplicated per this codebase's existing convention (see the identical
 * helper in src/lib/accommodations/repository.ts and
 * src/lib/activities/repository.ts). */
async function getNodeIdsAtLocations(locationIds: string[]): Promise<string[]> {
  if (locationIds.length === 0) return [];
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("node_locations")
    .select("node_id")
    .in("location_id", locationIds)
    .returns<Array<{ node_id: string }>>();

  if (error || !data) return [];
  return Array.from(new Set(data.map((row) => row.node_id)));
}

const TAXONOMY_FILTERS: Array<{ key: "travelerType" | "style" | "theme" | "durationBand" | "inclusion"; group: CategoryGroup }> = [
  { key: "travelerType", group: "traveler-type" },
  { key: "style", group: "package-style" },
  { key: "theme", group: "theme" },
  { key: "durationBand", group: "duration-band" },
  { key: "inclusion", group: "inclusion" },
];

/** Resolves every active taxonomy filter to a node-id allowlist and
 * intersects them. Returns `null` when no taxonomy filter was requested
 * (meaning "don't filter"), as opposed to `[]` which means a filter was
 * requested but matched nothing. */
async function resolveTaxonomyNodeIdFilter(options: GetPackagesOptions): Promise<string[] | null> {
  const filterSets: string[][] = [];

  for (const { key, group } of TAXONOMY_FILTERS) {
    const slug = options[key];
    if (!slug) continue;
    const category = await getCategoryBySlug(slug, group);
    if (!category) return [];
    filterSets.push(await getNodeIdsByCategory(category.id));
  }

  if (filterSets.length === 0) return null;

  let intersected = filterSets[0];
  for (let i = 1; i < filterSets.length; i++) {
    const set = new Set(filterSets[i]);
    intersected = intersected.filter((id) => set.has(id));
  }
  return Array.from(new Set(intersected));
}

export async function getPackages(options: GetPackagesOptions = {}): Promise<PaginatedResult<PackageSummary>> {
  const page = Math.max(1, options.page ?? 1);
  const pageSize = Math.min(100, Math.max(1, options.pageSize ?? 24));
  const from = (page - 1) * pageSize;
  const to = from + pageSize - 1;

  const supabase = await createClient();

  const nodeIdFilters: string[][] = [];

  const taxonomyFilter = await resolveTaxonomyNodeIdFilter(options);
  if (taxonomyFilter !== null) nodeIdFilters.push(taxonomyFilter);

  if (options.atollId || options.locationId) {
    const locationIds: string[] = [];
    if (options.locationId) locationIds.push(options.locationId);
    if (options.atollId) {
      const { data: islands } = await supabase
        .from("locations")
        .select("id")
        .eq("parent_id", options.atollId)
        .returns<Array<{ id: string }>>();
      locationIds.push(options.atollId, ...(islands ?? []).map((i) => i.id));
    }
    nodeIdFilters.push(await getNodeIdsAtLocations(locationIds));
  }

  if (options.nodeIds) nodeIdFilters.push(options.nodeIds);

  let nodeIdFilter: string[] | null = null;
  if (nodeIdFilters.length > 0) {
    nodeIdFilter = nodeIdFilters.reduce((acc, cur) => {
      const set = new Set(cur);
      return acc.filter((id) => set.has(id));
    });
    if (nodeIdFilter.length === 0) return { items: [], total: 0, page, pageSize };
  }

  let query = supabase
    .from("nodes")
    .select(NODE_PACKAGE_SELECT, { count: "exact" })
    .eq("node_type", "package")
    .eq("status", "published");

  if (nodeIdFilter) query = query.in("id", nodeIdFilter);

  const { data, error, count } = await query
    .order("title", { ascending: true })
    .range(from, to)
    .returns<NodePackageRow[]>();

  if (error || !data) return { items: [], total: 0, page, pageSize };

  const bares = data.map(barePackageOf).filter((b): b is BarePackage => b !== null);
  const providerIds = Array.from(new Set(bares.map((b) => b.providerId).filter((id): id is string => Boolean(id))));
  const [providersById, destinationsById] = await Promise.all([
    getProviderSummariesByIds(providerIds),
    attachDestinations(bares.map((b) => b.id)),
  ]);

  const items = bares.map((b) =>
    toSummary(b, b.providerId ? providersById.get(b.providerId) ?? null : null, destinationsById.get(b.id) ?? []),
  );
  return { items, total: count ?? items.length, page, pageSize };
}

/** Every category this package is tagged with, split by taxonomy group —
 * one `node_categories` query, then filtered against each group's already
 * fetched category list. Deliberately avoids embedding `categories` (or
 * `nodes` through it) here: `category_id` references `categories`, and
 * `categories.id` is itself a `nodes.id` FK (a category IS a node), so the
 * same two-path ambiguity already fixed for `nodes <-> categories`
 * elsewhere (via `categories!categories_id_fkey!inner(...)`, commit
 * 06a9254) would apply to any embed reached through this table too.
 * Confirmed against the live schema's actual FK constraints: `node_id`
 * references `nodes` directly, `category_id` references `categories`. */
async function getCategoriesForPackage(packageId: string): Promise<Record<CategoryGroup, CategorySummary[]>> {
  const empty: Record<CategoryGroup, CategorySummary[]> = {
    "accommodation-type": [],
    "activity-type": [],
    amenity: [],
    "traveler-type": [],
    "package-style": [],
    "duration-band": [],
    inclusion: [],
    theme: [],
    "article-category": [],
    "transfer-category": [],
  };

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("node_categories")
    .select("category_id")
    .eq("node_id", packageId)
    .returns<Array<{ category_id: string }>>();

  if (error || !data || data.length === 0) return empty;

  const categoryIds = new Set(data.map((row) => row.category_id));
  const groups: CategoryGroup[] = ["traveler-type", "package-style", "duration-band", "inclusion", "theme"];
  const results = await Promise.all(groups.map((group) => getCategoriesByGroup(group)));

  groups.forEach((group, i) => {
    empty[group] = results[i].filter((c) => categoryIds.has(c.id));
  });
  return empty;
}

type StageRow = {
  id: string;
  stage_number: number;
  day_start: number;
  day_end: number;
  night_count: number;
  title: string | null;
  description: string | null;
  sort_order: number;
};

type ItemRow = {
  id: string;
  stage_id: string;
  component_type: "node" | "transfer_service";
  component_node_id: string | null;
  transfer_service_id: string | null;
  component_role: PackageItineraryComponentRole;
  quantity: number;
  notes: string | null;
  sort_order: number;
};

function stageOf(row: StageRow, items: PackageItineraryItem[]): PackageItineraryStage {
  return {
    id: row.id,
    stageNumber: row.stage_number,
    dayStart: row.day_start,
    dayEnd: row.day_end,
    nightCount: row.night_count,
    title: row.title,
    description: row.description,
    sortOrder: row.sort_order,
    items,
  };
}

/** node_type for a batch of node ids — used to tell which
 * component_node_id values are accommodations vs. activities before
 * batch-resolving each against its own repository. */
async function getNodeTypesByIds(ids: string[]): Promise<Map<string, string>> {
  const map = new Map<string, string>();
  if (ids.length === 0) return map;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select("id, node_type")
    .in("id", ids)
    .returns<Array<{ id: string; node_type: string }>>();

  if (error || !data) return map;
  for (const row of data) map.set(row.id, row.node_type);
  return map;
}

async function getStagesForPackage(packageId: string): Promise<PackageItineraryStage[]> {
  const supabase = await createClient();
  const { data: stageRows, error: stageError } = await supabase
    .from("package_itinerary_stages")
    .select("id, stage_number, day_start, day_end, night_count, title, description, sort_order")
    .eq("package_id", packageId)
    .order("sort_order", { ascending: true })
    .returns<StageRow[]>();

  if (stageError || !stageRows || stageRows.length === 0) return [];

  const stageIds = stageRows.map((s) => s.id);
  const { data: itemRows, error: itemError } = await supabase
    .from("package_itinerary_items")
    .select(
      "id, stage_id, component_type, component_node_id, transfer_service_id, component_role, quantity, notes, sort_order",
    )
    .in("stage_id", stageIds)
    .order("sort_order", { ascending: true })
    .returns<ItemRow[]>();

  if (itemError || !itemRows) return stageRows.map((s) => stageOf(s, []));

  const nodeIds = itemRows.map((i) => i.component_node_id).filter((id): id is string => Boolean(id));
  const transferServiceIds = itemRows.map((i) => i.transfer_service_id).filter((id): id is string => Boolean(id));

  const nodeTypesById = await getNodeTypesByIds(nodeIds);
  const accommodationIds = nodeIds.filter((id) => nodeTypesById.get(id) === "accommodation");
  const activityIds = nodeIds.filter((id) => nodeTypesById.get(id) === "activity");

  const [accommodationsById, activitiesById, servicesById] = await Promise.all([
    getAccommodationSummariesByIds(accommodationIds),
    getActivitySummariesByIds(activityIds),
    getTransferServicesByIds(transferServiceIds),
  ]);

  const routeIds = Array.from(
    new Set(
      transferServiceIds.map((id) => servicesById.get(id)?.routeId).filter((id): id is string => Boolean(id)),
    ),
  );
  const routesById = await getTransferRoutesByIds(routeIds);

  const itemsByStage = new Map<string, PackageItineraryItem[]>();
  for (const row of itemRows) {
    const accommodation = row.component_node_id ? accommodationsById.get(row.component_node_id) ?? null : null;
    const activity = row.component_node_id ? activitiesById.get(row.component_node_id) ?? null : null;
    const transferService = row.transfer_service_id ? servicesById.get(row.transfer_service_id) ?? null : null;
    const transferRoute = transferService ? routesById.get(transferService.routeId) ?? null : null;

    const item: PackageItineraryItem = {
      id: row.id,
      componentRole: row.component_role,
      quantity: row.quantity,
      notes: row.notes,
      sortOrder: row.sort_order,
      accommodation,
      activity,
      transferService,
      transferRoute,
    };
    const list = itemsByStage.get(row.stage_id) ?? [];
    list.push(item);
    itemsByStage.set(row.stage_id, list);
  }

  return stageRows.map((s) => stageOf(s, itemsByStage.get(s.id) ?? []));
}

export async function getPackageBySlug(slug: string): Promise<PackageDetail | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_PACKAGE_SELECT)
    .eq("node_type", "package")
    .eq("status", "published")
    .eq("slug", slug)
    .maybeSingle<NodePackageRow>();

  if (error || !data) return null;
  const bare = barePackageOf(data);
  if (!bare) return null;

  const [providersById, destinationsById, categories, stages, bookableRow] = await Promise.all([
    bare.providerId
      ? getProviderSummariesByIds([bare.providerId])
      : Promise.resolve(new Map<string, ProviderSummary>()),
    attachDestinations([bare.id]),
    getCategoriesForPackage(bare.id),
    getStagesForPackage(bare.id),
    supabase.from("bookable_products").select("id").eq("id", bare.id).maybeSingle(),
  ]);

  const provider = bare.providerId ? providersById.get(bare.providerId) ?? null : null;

  return {
    ...toSummary(bare, provider, destinationsById.get(bare.id) ?? []),
    metaTitle: bare.metaTitle,
    metaDescription: bare.metaDescription,
    isBookable: Boolean(bookableRow.data),
    // MTG-curated = no operator on record — see data/maldives/packages/SOURCES.md
    // and Task 11 §18: never falsely attribute a package to a third party.
    isMtgCurated: provider === null,
    stages,
    travelerTypes: categories["traveler-type"],
    styles: categories["package-style"],
    durationBand: categories["duration-band"][0] ?? null,
    themes: categories.theme,
    inclusions: categories.inclusion,
  };
}

/** Batch lookup by node id — mirrors getAccommodationSummariesByIds /
 * getActivitySummariesByIds, kept for symmetry even though no caller needs
 * it yet within this task's scope. */
export async function getPackageSummariesByIds(ids: string[]): Promise<Map<string, PackageSummary>> {
  const map = new Map<string, PackageSummary>();
  if (ids.length === 0) return map;

  const result = await getPackages({ nodeIds: ids, pageSize: 100 });
  for (const item of result.items) map.set(item.id, item);
  return map;
}

export interface SearchPackagesOptions {
  limit?: number;
}

export async function searchPackages(query: string, options: SearchPackagesOptions = {}): Promise<PackageSummary[]> {
  const trimmed = query.trim();
  if (trimmed.length === 0) return [];

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_PACKAGE_SELECT)
    .eq("node_type", "package")
    .eq("status", "published")
    .ilike("title", `%${trimmed}%`)
    .order("title", { ascending: true })
    .limit(options.limit ?? 20)
    .returns<NodePackageRow[]>();

  if (error || !data) return [];

  const bares = data.map(barePackageOf).filter((b): b is BarePackage => b !== null);
  const providerIds = Array.from(new Set(bares.map((b) => b.providerId).filter((id): id is string => Boolean(id))));
  const [providersById, destinationsById] = await Promise.all([
    getProviderSummariesByIds(providerIds),
    attachDestinations(bares.map((b) => b.id)),
  ]);

  return bares.map((b) =>
    toSummary(b, b.providerId ? providersById.get(b.providerId) ?? null : null, destinationsById.get(b.id) ?? []),
  );
}

/** package_ids of every package with an itinerary item referencing `nodeId`
 * under one of `roles`, resolved as a two-step batched query
 * (package_itinerary_items -> package_itinerary_stages) rather than an
 * embed — see this file's header comment. */
async function getPackageIdsReferencingNode(nodeId: string, roles: PackageItineraryComponentRole[]): Promise<string[]> {
  const supabase = await createClient();
  const { data: itemRows, error: itemError } = await supabase
    .from("package_itinerary_items")
    .select("stage_id")
    .eq("component_node_id", nodeId)
    .in("component_role", roles)
    .returns<Array<{ stage_id: string }>>();

  if (itemError || !itemRows || itemRows.length === 0) return [];

  const stageIds = Array.from(new Set(itemRows.map((row) => row.stage_id)));
  const { data: stageRows, error: stageError } = await supabase
    .from("package_itinerary_stages")
    .select("package_id")
    .in("id", stageIds)
    .returns<Array<{ package_id: string }>>();

  if (stageError || !stageRows) return [];
  return Array.from(new Set(stageRows.map((row) => row.package_id)));
}

/** Every package whose itinerary stays at this accommodation — powers the
 * reverse "Featured in these packages" link on accommodation detail pages. */
export async function getPackagesByAccommodation(accommodationNodeId: string): Promise<PackageSummary[]> {
  const packageIds = await getPackageIdsReferencingNode(accommodationNodeId, ["accommodation"]);
  if (packageIds.length === 0) return [];
  const result = await getPackages({ nodeIds: packageIds, pageSize: 100 });
  return result.items;
}

/** Every package whose itinerary includes this activity, as either an
 * 'activity' or 'excursion' role item. */
export async function getPackagesByActivity(activityNodeId: string): Promise<PackageSummary[]> {
  const packageIds = await getPackageIdsReferencingNode(activityNodeId, ["activity", "excursion"]);
  if (packageIds.length === 0) return [];
  const result = await getPackages({ nodeIds: packageIds, pageSize: 100 });
  return result.items;
}

/** Every package with an itinerary item referencing a transfer_service on
 * this route — routeId -> transfer_services.id (many) -> itinerary items
 * -> stages -> package ids, all as separate batched queries. */
export async function getPackagesByTransferRoute(routeId: string): Promise<PackageSummary[]> {
  const supabase = await createClient();
  const { data: serviceRows, error: serviceError } = await supabase
    .from("transfer_services")
    .select("id")
    .eq("route_id", routeId)
    .returns<Array<{ id: string }>>();

  if (serviceError || !serviceRows || serviceRows.length === 0) return [];
  const serviceIds = serviceRows.map((row) => row.id);

  const { data: itemRows, error: itemError } = await supabase
    .from("package_itinerary_items")
    .select("stage_id")
    .in("transfer_service_id", serviceIds)
    .returns<Array<{ stage_id: string }>>();

  if (itemError || !itemRows || itemRows.length === 0) return [];
  const stageIds = Array.from(new Set(itemRows.map((row) => row.stage_id)));

  const { data: stageRows, error: stageError } = await supabase
    .from("package_itinerary_stages")
    .select("package_id")
    .in("id", stageIds)
    .returns<Array<{ package_id: string }>>();

  if (stageError || !stageRows || stageRows.length === 0) return [];
  const packageIds = Array.from(new Set(stageRows.map((row) => row.package_id)));

  const result = await getPackages({ nodeIds: packageIds, pageSize: 100 });
  return result.items;
}

/** Every package touching this location, via its own node_locations
 * destination tags (set at seed time — see this file's header comment and
 * data/maldives/packages/SOURCES.md). */
export async function getPackagesByLocation(locationId: string): Promise<PackageSummary[]> {
  const result = await getPackages({ locationId, pageSize: 100 });
  return result.items;
}

export async function getPackagesByAtoll(atollId: string): Promise<PackageSummary[]> {
  const result = await getPackages({ atollId, pageSize: 100 });
  return result.items;
}

/** Every category in `group` actually tagged on at least one published
 * package — the "only show a filter that can return something" rule
 * already used for diving/fishing/surfing types (Tasks 7-9). Deliberately
 * avoids embedding through `node_categories` (see getCategoriesForPackage's
 * comment on why) in favor of two plain queries intersected in application
 * code. */
async function getPackageCategoriesInUse(group: CategoryGroup): Promise<CategorySummary[]> {
  const all = await getCategoriesByGroup(group);
  if (all.length === 0) return [];

  const supabase = await createClient();
  const { data: packageRows, error: packageError } = await supabase
    .from("nodes")
    .select("id")
    .eq("node_type", "package")
    .eq("status", "published")
    .returns<Array<{ id: string }>>();

  if (packageError || !packageRows || packageRows.length === 0) return [];
  const packageIds = new Set(packageRows.map((row) => row.id));

  const { data: tagRows, error: tagError } = await supabase
    .from("node_categories")
    .select("node_id, category_id")
    .in(
      "category_id",
      all.map((c) => c.id),
    )
    .returns<Array<{ node_id: string; category_id: string }>>();

  if (tagError || !tagRows) return [];
  const inUseCategoryIds = new Set(tagRows.filter((row) => packageIds.has(row.node_id)).map((row) => row.category_id));
  return all.filter((c) => inUseCategoryIds.has(c.id));
}

export async function getPackageTravelerTypesInUse(): Promise<CategorySummary[]> {
  return getPackageCategoriesInUse("traveler-type");
}

export async function getPackageStylesInUse(): Promise<CategorySummary[]> {
  return getPackageCategoriesInUse("package-style");
}

export async function getPackageThemesInUse(): Promise<CategorySummary[]> {
  return getPackageCategoriesInUse("theme");
}

export async function getPackageDurationBandsInUse(): Promise<CategorySummary[]> {
  return getPackageCategoriesInUse("duration-band");
}

export async function getPackageInclusionsInUse(): Promise<CategorySummary[]> {
  return getPackageCategoriesInUse("inclusion");
}
