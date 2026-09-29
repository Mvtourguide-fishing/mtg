import "server-only";

import { cachedRead } from "@/lib/cache/cached-read";
import { getHeroMediaByNodeIds } from "@/lib/media/repository";
import type { MediaAsset } from "@/lib/media/types";
import { createClient } from "@/lib/supabase/public";
import type {
  AtollContentProfile,
  AtollDetail,
  AtollSummary,
  IslandContentProfile,
  IslandDetail,
  IslandFaq,
  IslandQuickFact,
  IslandSummary,
  LocationDetail,
  LocationSummary,
  LocationType,
  PaginatedResult,
} from "@/lib/locations/types";

/**
 * Server-side location data-access layer. Pages/components should call
 * these functions instead of querying Supabase directly — this is the only
 * place that knows the `nodes` + `locations` table shapes and how they
 * embed via PostgREST.
 *
 * Every function here only returns published locations: these are public
 * read paths with no user context, matching the `nodes_public_read` /
 * `locations_public_read` RLS policies (status = 'published').
 */

// `locations!locations_id_fkey!inner(...)` — not a plain `locations(...)`
// embed. Every query below filters on an embedded `locations` column
// (location_type or parent_id). Without `!inner`, PostgREST only filters
// which embedded rows are attached to a match, not which parent `nodes`
// rows are returned at all — the filter would silently do nothing at the
// top level and every location node (islands, atolls, sites, ...) would
// come back regardless of the intended location_type/parent_id filter.
// `!inner` makes it a real join-level filter that actually restricts the
// result set. The relationship name is also required (not just `!inner`):
// `nodes` and `locations` are connected by two real relationships — the
// direct `locations.id -> nodes.id` FK, and a second, indirect path via the
// `node_locations` junction table — so PostgREST refuses to guess which one
// is meant and returns PGRST201 ("more than one relationship was found")
// unless the FK is named explicitly. Confirmed against a live Supabase
// project; this couldn't be caught earlier since no live PostgREST instance
// was available through Task 9.
const NODE_LOCATION_SELECT =
  "id, slug, title, summary, meta_title, meta_description, locations!locations_id_fkey!inner(location_type, parent_id, lat, lng, is_inhabited, administrative_code, path)";

type NodeLocationRow = {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  meta_title: string | null;
  meta_description: string | null;
  // PostgREST returns a one-to-one embed as an object, but is defensive-
  // coded here as possibly-an-array since this couldn't be verified
  // end-to-end against a live PostgREST instance in this environment
  // (see the Task 4 report).
  locations:
    | {
        location_type: LocationType;
        parent_id: string | null;
        lat: number | null;
        lng: number | null;
        is_inhabited: boolean | null;
        administrative_code: string | null;
        path: string;
      }
    | Array<{
        location_type: LocationType;
        parent_id: string | null;
        lat: number | null;
        lng: number | null;
        is_inhabited: boolean | null;
        administrative_code: string | null;
        path: string;
      }>
    | null;
};

function locationDetailOf(row: NodeLocationRow, heroImage: MediaAsset | null = null): LocationDetail | null {
  const loc = Array.isArray(row.locations) ? row.locations[0] : row.locations;
  if (!loc) return null;

  return {
    id: row.id,
    slug: row.slug,
    title: row.title,
    summary: row.summary,
    locationType: loc.location_type,
    parentId: loc.parent_id,
    isInhabited: loc.is_inhabited,
    heroImage,
    metaTitle: row.meta_title,
    metaDescription: row.meta_description,
    lat: loc.lat,
    lng: loc.lng,
    administrativeCode: loc.administrative_code,
    path: loc.path,
  };
}

function locationSummaryOf(row: NodeLocationRow, heroImage: MediaAsset | null = null): LocationSummary | null {
  const detail = locationDetailOf(row, heroImage);
  if (!detail) return null;
  const { id, slug, title, summary, locationType, parentId, lat, lng, isInhabited } = detail;
  return { id, slug, title, summary, locationType, parentId, lat, lng, isInhabited, heroImage };
}

/** The single `location_type = 'country'` node (Maldives). */
async function getCountryUncached(): Promise<LocationDetail | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT)
    .eq("node_type", "location")
    .eq("status", "published")
    .eq("locations.location_type", "country")
    .limit(1)
    .maybeSingle<NodeLocationRow>();

  if (error || !data) return null;
  const heroImage = (await getHeroMediaByNodeIds([data.id])).get(data.id) ?? null;
  return locationDetailOf(data, heroImage);
}

export const getCountry = cachedRead(getCountryUncached, ["locations:country"], 900);

/** Every published atoll, with its inhabited-island count, ordered by name. */
async function getAtollsUncached(): Promise<AtollSummary[]> {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT)
    .eq("node_type", "location")
    .eq("status", "published")
    .eq("locations.location_type", "atoll")
    .order("title", { ascending: true })
    .returns<NodeLocationRow[]>();

  if (error || !data) return [];

  const atollIds = data.map((row) => row.id).filter(Boolean);
  const [counts, heroByNodeId] = await Promise.all([getIslandCountsByAtoll(atollIds), getHeroMediaByNodeIds(atollIds)]);

  return data
    .map((row) => {
      const summary = locationSummaryOf(row, heroByNodeId.get(row.id) ?? null);
      if (!summary || summary.locationType !== "atoll") return null;
      return { ...summary, locationType: "atoll" as const, islandCount: counts.get(summary.id) ?? 0 };
    })
    .filter((a): a is AtollSummary => a !== null);
}

export const getAtolls = cachedRead(getAtollsUncached, ["locations:atolls"], 900);

/**
 * Inhabited-island counts per atoll in a single grouped query, so the
 * atoll directory never runs one count query per atoll (no N+1). Filtered
 * to is_inhabited=true — every caller of getAtolls() presents this number
 * as "N islands"/"N inhabited islands", so it must exclude both the
 * uninhabited resort islands (Task 5) and any local island whose
 * community has since relocated (e.g. Kalhaidhoo, Gaadhoo).
 */
async function getIslandCountsByAtoll(atollIds: string[]): Promise<Map<string, number>> {
  const counts = new Map<string, number>();
  if (atollIds.length === 0) return counts;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("locations")
    .select("parent_id")
    .eq("location_type", "island")
    .eq("is_inhabited", true)
    .in("parent_id", atollIds)
    .returns<Array<{ parent_id: string | null }>>();

  if (error || !data) return counts;

  for (const row of data) {
    if (!row.parent_id) continue;
    counts.set(row.parent_id, (counts.get(row.parent_id) ?? 0) + 1);
  }
  return counts;
}

async function getAtollBySlugUncached(slug: string): Promise<AtollDetail | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT)
    .eq("node_type", "location")
    .eq("status", "published")
    .eq("slug", slug)
    .eq("locations.location_type", "atoll")
    .maybeSingle<NodeLocationRow>();

  if (error || !data) return null;
  const heroImage = (await getHeroMediaByNodeIds([data.id])).get(data.id) ?? null;
  const detail = locationDetailOf(data, heroImage);
  if (!detail || detail.locationType !== "atoll") return null;
  return { ...detail, locationType: "atoll" };
}

export const getAtollBySlug = cachedRead(getAtollBySlugUncached, ["locations:atoll-by-slug"], 900);

export interface GetIslandsOptions {
  page?: number;
  pageSize?: number;
}

/** All published islands, paginated (the Maldives has ~190+ inhabited islands). */
async function getIslandsUncached(options: GetIslandsOptions = {}): Promise<PaginatedResult<IslandSummary>> {
  const page = Math.max(1, options.page ?? 1);
  const pageSize = Math.min(100, Math.max(1, options.pageSize ?? 48));
  const from = (page - 1) * pageSize;
  const to = from + pageSize - 1;

  const supabase = await createClient();
  const { data, error, count } = await supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT, { count: "exact" })
    .eq("node_type", "location")
    .eq("status", "published")
    .eq("locations.location_type", "island")
    .order("title", { ascending: true })
    .range(from, to)
    .returns<NodeLocationRow[]>();

  if (error || !data) {
    return { items: [], total: 0, page, pageSize };
  }

  const heroByNodeId = await getHeroMediaByNodeIds(data.map((row) => row.id));
  const items = data
    .map((row) => {
      const summary = locationSummaryOf(row, heroByNodeId.get(row.id) ?? null);
      if (!summary || summary.locationType !== "island") return null;
      return { ...summary, locationType: "island" as const, atollId: summary.parentId };
    })
    .filter((i): i is IslandSummary => i !== null);

  return { items, total: count ?? items.length, page, pageSize };
}

export const getIslands = cachedRead(getIslandsUncached, ["locations:islands"], 900);

/** All islands belonging to one atoll (by atoll node id) — a single query,
 * not one per island. Split out from getIslandsByAtoll() below so a caller
 * that already has the atoll's id (e.g. an island's own parentId) can skip
 * the extra slug->id lookup that function does. */
async function getIslandsByAtollIdUncached(atollId: string): Promise<IslandSummary[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT)
    .eq("node_type", "location")
    .eq("status", "published")
    .eq("locations.location_type", "island")
    .eq("locations.parent_id", atollId)
    .order("title", { ascending: true })
    .returns<NodeLocationRow[]>();

  if (error || !data) return [];

  const heroByNodeId = await getHeroMediaByNodeIds(data.map((row) => row.id));
  return data
    .map((row) => {
      const summary = locationSummaryOf(row, heroByNodeId.get(row.id) ?? null);
      if (!summary || summary.locationType !== "island") return null;
      return { ...summary, locationType: "island" as const, atollId: summary.parentId };
    })
    .filter((i): i is IslandSummary => i !== null);
}

export const getIslandsByAtollId = cachedRead(getIslandsByAtollIdUncached, ["locations:islands-by-atoll-id"], 900);

/** All islands belonging to one atoll (by atoll slug) — a single query, not
 * one per island. */
export async function getIslandsByAtoll(atollSlug: string): Promise<IslandSummary[]> {
  const atoll = await getAtollBySlug(atollSlug);
  if (!atoll) return [];
  return getIslandsByAtollId(atoll.id);
}

async function getIslandBySlugUncached(slug: string): Promise<IslandDetail | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT)
    .eq("node_type", "location")
    .eq("status", "published")
    .eq("slug", slug)
    .eq("locations.location_type", "island")
    .maybeSingle<NodeLocationRow>();

  if (error || !data) return null;
  const heroImage = (await getHeroMediaByNodeIds([data.id])).get(data.id) ?? null;
  const detail = locationDetailOf(data, heroImage);
  if (!detail || detail.locationType !== "island") return null;
  return { ...detail, locationType: "island" };
}

export const getIslandBySlug = cachedRead(getIslandBySlugUncached, ["locations:island-by-slug"], 900);

/** Any locations parented under `locationId` (localities, sites, etc.). */
async function getChildLocationsUncached(locationId: string): Promise<LocationSummary[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT)
    .eq("node_type", "location")
    .eq("status", "published")
    .eq("locations.parent_id", locationId)
    .order("title", { ascending: true })
    .returns<NodeLocationRow[]>();

  if (error || !data) return [];

  const heroByNodeId = await getHeroMediaByNodeIds(data.map((row) => row.id));
  return data.map((row) => locationSummaryOf(row, heroByNodeId.get(row.id) ?? null)).filter((l): l is LocationSummary => l !== null);
}

export const getChildLocations = cachedRead(getChildLocationsUncached, ["locations:children"], 900);

export interface SearchLocationsOptions {
  locationType?: LocationType;
  limit?: number;
}

/** Basic name search — a starting point for a future autocomplete/filter UI. */
export async function searchLocations(
  query: string,
  options: SearchLocationsOptions = {},
): Promise<LocationSummary[]> {
  const trimmed = query.trim();
  if (trimmed.length === 0) return [];

  const supabase = await createClient();
  let builder = supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT)
    .eq("node_type", "location")
    .eq("status", "published")
    .ilike("title", `%${trimmed}%`)
    .order("title", { ascending: true })
    .limit(options.limit ?? 20);

  if (options.locationType) {
    builder = builder.eq("locations.location_type", options.locationType);
  }

  const { data, error } = await builder.returns<NodeLocationRow[]>();
  if (error || !data) return [];

  const heroByNodeId = await getHeroMediaByNodeIds(data.map((row) => row.id));
  return data.map((row) => locationSummaryOf(row, heroByNodeId.get(row.id) ?? null)).filter((l): l is LocationSummary => l !== null);
}

/**
 * Batch lookup by id, added for Task 5: the accommodation repository needs
 * to resolve a set of primary-location ids (islands, resort islands, ...)
 * without one query per accommodation. Kept here rather than duplicated in
 * the accommodation repository, since this module already owns the
 * nodes+locations join shape.
 */
async function getLocationSummariesByIdsUncached(ids: string[]): Promise<Map<string, LocationSummary>> {
  const map = new Map<string, LocationSummary>();
  if (ids.length === 0) return map;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT)
    .eq("node_type", "location")
    .eq("status", "published")
    .in("id", ids)
    .returns<NodeLocationRow[]>();

  if (error || !data) return map;

  const heroByNodeId = await getHeroMediaByNodeIds(data.map((row) => row.id));
  for (const row of data) {
    const summary = locationSummaryOf(row, heroByNodeId.get(row.id) ?? null);
    if (summary) map.set(summary.id, summary);
  }
  return map;
}

export const getLocationSummariesByIds = cachedRead(getLocationSummariesByIdsUncached, ["locations:by-ids"], 900);

export async function getLocationSummaryById(id: string): Promise<LocationSummary | null> {
  const map = await getLocationSummariesByIds([id]);
  return map.get(id) ?? null;
}

/** Batched slug lookup — used to resolve IslandContentProfile.nearbyIslandSlugs
 * (real MTG island slugs, verified at import time — see
 * import-legacy-island-content.mjs) into renderable summaries without one
 * query per nearby island. */
async function getLocationSummariesBySlugsUncached(slugs: string[]): Promise<Map<string, LocationSummary>> {
  const map = new Map<string, LocationSummary>();
  if (slugs.length === 0) return map;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT)
    .eq("node_type", "location")
    .eq("status", "published")
    .in("slug", slugs)
    .returns<NodeLocationRow[]>();

  if (error || !data) return map;

  const heroByNodeId = await getHeroMediaByNodeIds(data.map((row) => row.id));
  for (const row of data) {
    const summary = locationSummaryOf(row, heroByNodeId.get(row.id) ?? null);
    if (summary) map.set(summary.slug, summary);
  }
  return map;
}

export const getLocationSummariesBySlugs = cachedRead(
  getLocationSummariesBySlugsUncached,
  ["locations:summaries-by-slugs"],
  900,
);

/**
 * Generic site-type queries, added for Task 8. Dive sites, and later surf
 * breaks (Task 9), are both `locations` rows distinguished only by
 * `location_type` — rather than writing a `dive_site`-specific version of
 * `getIslands`/`getIslandsByAtoll`/`getIslandBySlug` and then a near-
 * identical `surf_break` version next task, these take `locationType` as a
 * parameter so every "site" vertical composes the same three functions.
 */

export interface GetLocationsByTypeOptions {
  page?: number;
  pageSize?: number;
}

async function getLocationsByTypeUncached(
  locationType: LocationType,
  options: GetLocationsByTypeOptions = {},
): Promise<PaginatedResult<LocationSummary>> {
  const page = Math.max(1, options.page ?? 1);
  const pageSize = Math.min(100, Math.max(1, options.pageSize ?? 48));
  const from = (page - 1) * pageSize;
  const to = from + pageSize - 1;

  const supabase = await createClient();
  const { data, error, count } = await supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT, { count: "exact" })
    .eq("node_type", "location")
    .eq("status", "published")
    .eq("locations.location_type", locationType)
    .order("title", { ascending: true })
    .range(from, to)
    .returns<NodeLocationRow[]>();

  if (error || !data) return { items: [], total: 0, page, pageSize };

  const heroByNodeId = await getHeroMediaByNodeIds(data.map((row) => row.id));
  const items = data.map((row) => locationSummaryOf(row, heroByNodeId.get(row.id) ?? null)).filter((l): l is LocationSummary => l !== null);
  return { items, total: count ?? items.length, page, pageSize };
}

export const getLocationsByType = cachedRead(getLocationsByTypeUncached, ["locations:by-type"], 900);

async function getLocationsByTypeAndAtollUncached(locationType: LocationType, atollId: string): Promise<LocationSummary[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT)
    .eq("node_type", "location")
    .eq("status", "published")
    .eq("locations.location_type", locationType)
    .eq("locations.parent_id", atollId)
    .order("title", { ascending: true })
    .returns<NodeLocationRow[]>();

  if (error || !data) return [];
  const heroByNodeId = await getHeroMediaByNodeIds(data.map((row) => row.id));
  return data.map((row) => locationSummaryOf(row, heroByNodeId.get(row.id) ?? null)).filter((l): l is LocationSummary => l !== null);
}

export const getLocationsByTypeAndAtoll = cachedRead(getLocationsByTypeAndAtollUncached, ["locations:by-type-and-atoll"], 900);

async function getLocationBySlugAndTypeUncached(slug: string, locationType: LocationType): Promise<LocationDetail | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT)
    .eq("node_type", "location")
    .eq("status", "published")
    .eq("slug", slug)
    .eq("locations.location_type", locationType)
    .maybeSingle<NodeLocationRow>();

  if (error || !data) return null;
  const heroImage = (await getHeroMediaByNodeIds([data.id])).get(data.id) ?? null;
  return locationDetailOf(data, heroImage);
}

export const getLocationBySlugAndType = cachedRead(getLocationBySlugAndTypeUncached, ["locations:by-slug-and-type"], 900);

/** Same as getLocationBySlugAndType but without a location_type filter —
 * for callers (Task 10 transfers) where the endpoint can legitimately be
 * more than one type (an island or an airport), so the caller doesn't
 * already know which type to ask for. */
async function getLocationBySlugUncached(slug: string): Promise<LocationDetail | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT)
    .eq("node_type", "location")
    .eq("status", "published")
    .eq("slug", slug)
    .maybeSingle<NodeLocationRow>();

  if (error || !data) return null;
  const heroImage = (await getHeroMediaByNodeIds([data.id])).get(data.id) ?? null;
  return locationDetailOf(data, heroImage);
}

export const getLocationBySlug = cachedRead(getLocationBySlugUncached, ["locations:by-slug"], 900);

/** `nodes.attributes` for one node — the JSONB home for genuinely flexible,
 * category-specific descriptive facts (dive site depth/current/marine-life
 * notes, per the architecture's JSONB-boundaries rule), never for data that
 * needs relational filtering. */
export async function getNodeAttributes(nodeId: string): Promise<Record<string, unknown>> {
  const map = await getNodeAttributesByIds([nodeId]);
  return map.get(nodeId) ?? {};
}

async function getNodeAttributesByIdsUncached(nodeIds: string[]): Promise<Map<string, Record<string, unknown>>> {
  const map = new Map<string, Record<string, unknown>>();
  if (nodeIds.length === 0) return map;

  const supabase = await createClient();
  const { data } = await supabase
    .from("nodes")
    .select("id, attributes")
    .in("id", nodeIds)
    .returns<Array<{ id: string; attributes: Record<string, unknown> | null }>>();

  for (const row of data ?? []) {
    map.set(row.id, row.attributes ?? {});
  }
  return map;
}

export const getNodeAttributesByIds = cachedRead(getNodeAttributesByIdsUncached, ["locations:node-attributes"], 900);

/** An island's own destination-guide content, if it has one — reads the
 * `island_*` keys import-legacy-island-content.mjs writes into
 * `nodes.attributes` (see IslandContentProfile). Returns null rather than
 * an empty-arrays object when nothing was ever written for this island,
 * so callers can tell "no content" from "content, but every field empty". */
export async function getIslandContent(nodeId: string): Promise<IslandContentProfile | null> {
  const attrs = await getNodeAttributes(nodeId);
  const source = attrs.island_content_source;
  if (typeof source !== "string") return null;

  return {
    contentSource: source,
    quickFacts: Array.isArray(attrs.island_quick_facts) ? (attrs.island_quick_facts as IslandQuickFact[]) : [],
    overview: Array.isArray(attrs.island_overview) ? (attrs.island_overview as string[]) : [],
    sections: Array.isArray(attrs.island_sections) ? (attrs.island_sections as IslandContentProfile["sections"]) : [],
    faqs: Array.isArray(attrs.island_faqs) ? (attrs.island_faqs as IslandFaq[]) : [],
    nearbyIslandSlugs: Array.isArray(attrs.island_nearby_slugs) ? (attrs.island_nearby_slugs as string[]) : [],
  };
}

/** An atoll's own destination-guide content, if it has one — see
 * getIslandContent for the identical island-level pattern. */
export async function getAtollContent(nodeId: string): Promise<AtollContentProfile | null> {
  const attrs = await getNodeAttributes(nodeId);
  const source = attrs.atoll_content_source;
  if (typeof source !== "string") return null;

  return {
    contentSource: source,
    sections: Array.isArray(attrs.atoll_sections) ? (attrs.atoll_sections as AtollContentProfile["sections"]) : [],
  };
}

/** Every node tagged to `locationId` via node_locations, regardless of
 * relation (primary or secondary) — used to find, e.g., every diving
 * activity that visits a given dive site even though the site is usually
 * a secondary tag, not the activity's primary location. */
async function getNodeIdsAtLocationUncached(locationId: string): Promise<string[]> {
  const supabase = await createClient();
  const { data } = await supabase
    .from("node_locations")
    .select("node_id")
    .eq("location_id", locationId)
    .returns<Array<{ node_id: string }>>();
  return Array.from(new Set((data ?? []).map((row) => row.node_id)));
}

export const getNodeIdsAtLocation = cachedRead(getNodeIdsAtLocationUncached, ["locations:node-ids-at-location"], 900);

/** Every location tagged *to* `nodeId` via node_locations (any relation) —
 * the reverse of getNodeIdsAtLocation. Used to find, e.g., the specific
 * dive site(s) a diving activity visits when that's documented. */
async function getLocationIdsForNodeUncached(nodeId: string): Promise<string[]> {
  const supabase = await createClient();
  const { data } = await supabase
    .from("node_locations")
    .select("location_id")
    .eq("node_id", nodeId)
    .returns<Array<{ location_id: string }>>();
  return Array.from(new Set((data ?? []).map((row) => row.location_id)));
}

export const getLocationIdsForNode = cachedRead(getLocationIdsForNodeUncached, ["locations:location-ids-for-node"], 900);
