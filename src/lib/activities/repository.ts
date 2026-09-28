import "server-only";

import { cachedRead } from "@/lib/cache/cached-read";
import { getLocationSummariesByIds, getLocationSummaryById } from "@/lib/locations/repository";
import type { LocationSummary } from "@/lib/locations/types";
import { getHeroMediaByNodeIds, getMediaForNode } from "@/lib/media/repository";
import type { MediaAsset } from "@/lib/media/types";
import { getProviderSummariesByIds } from "@/lib/providers/repository";
import type { ProviderSummary } from "@/lib/providers/types";
import { createClient } from "@/lib/supabase/public";
import type {
  ActivityCategory,
  ActivityDetail,
  ActivityDifficulty,
  ActivityFilters,
  ActivitySummary,
  PaginatedResult,
} from "@/lib/activities/types";

/**
 * Server-side activity data-access layer, following the same pattern as
 * src/lib/accommodations/repository.ts: pages call these functions, never
 * Supabase directly. Every function only returns published activities.
 *
 * Task 6 note: fishing, diving, and surfing are activity_category values
 * on this same shared table (not separate tables) — later tasks give them
 * dedicated pages/fields, but the data and this repository already cover
 * them today.
 *
 * N+1 avoidance follows the exact batching pattern established in
 * src/lib/accommodations/repository.ts (base rows in one query, then
 * batched location/provider lookups) — see that file for the rationale.
 */

// `activities!inner(...)` — not a plain embed. See the identical note in
// src/lib/locations/repository.ts: without `!inner`, filtering on an
// embedded column doesn't restrict which `nodes` rows come back.
const NODE_ACTIVITY_SELECT =
  "id, slug, title, summary, meta_title, meta_description, activities!inner(activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, currency, max_participants)";

type ActivityFields = {
  activity_category: ActivityCategory;
  operated_by_provider_id: string | null;
  duration_minutes: number | null;
  min_age: number | null;
  difficulty: ActivityDifficulty | null;
  price_from: number | null;
  currency: string | null;
  max_participants: number | null;
};

type NodeActivityRow = {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  meta_title: string | null;
  meta_description: string | null;
  // Defensive-coded as possibly-an-array — see the identical note in
  // src/lib/locations/repository.ts (could not be verified end-to-end
  // against a live PostgREST instance in this sandbox).
  activities: ActivityFields | ActivityFields[] | null;
};

interface BareActivity {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  metaTitle: string | null;
  metaDescription: string | null;
  activityCategory: ActivityCategory;
  providerId: string | null;
  durationMinutes: number | null;
  minAge: number | null;
  difficulty: ActivityDifficulty | null;
  priceFrom: number | null;
  currency: string | null;
  maxParticipants: number | null;
}

function bareActivityOf(row: NodeActivityRow): BareActivity | null {
  const a = Array.isArray(row.activities) ? row.activities[0] : row.activities;
  if (!a) return null;

  return {
    id: row.id,
    slug: row.slug,
    title: row.title,
    summary: row.summary,
    metaTitle: row.meta_title,
    metaDescription: row.meta_description,
    activityCategory: a.activity_category,
    providerId: a.operated_by_provider_id,
    durationMinutes: a.duration_minutes,
    minAge: a.min_age,
    difficulty: a.difficulty,
    priceFrom: a.price_from,
    currency: a.currency,
    maxParticipants: a.max_participants,
  };
}

function toSummary(bare: BareActivity, primaryLocation: LocationSummary | null, heroImage: MediaAsset | null): ActivitySummary {
  return {
    id: bare.id,
    slug: bare.slug,
    title: bare.title,
    summary: bare.summary,
    activityCategory: bare.activityCategory,
    durationMinutes: bare.durationMinutes,
    difficulty: bare.difficulty,
    priceFrom: bare.priceFrom,
    currency: bare.currency,
    primaryLocation,
    heroImage,
  };
}

/** Batch-resolve each node's *primary* location — one query for the join
 * rows, one batched query for the location details, regardless of N. */
async function attachPrimaryLocations(nodeIds: string[]): Promise<Map<string, LocationSummary>> {
  const result = new Map<string, LocationSummary>();
  if (nodeIds.length === 0) return result;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("node_locations")
    .select("node_id, location_id")
    .eq("relation", "primary")
    .in("node_id", nodeIds)
    .returns<Array<{ node_id: string; location_id: string }>>();

  if (error || !data) return result;

  const locationsById = await getLocationSummariesByIds(data.map((row) => row.location_id));
  for (const row of data) {
    const loc = locationsById.get(row.location_id);
    if (loc) result.set(row.node_id, loc);
  }
  return result;
}

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

export interface GetActivitiesOptions extends ActivityFilters {
  page?: number;
  pageSize?: number;
}

async function getActivitiesUncached(options: GetActivitiesOptions = {}): Promise<PaginatedResult<ActivitySummary>> {
  const page = Math.max(1, options.page ?? 1);
  const pageSize = Math.min(100, Math.max(1, options.pageSize ?? 24));
  const from = (page - 1) * pageSize;
  const to = from + pageSize - 1;

  const supabase = await createClient();

  let nodeIdFilter: string[] | null = null;
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
    nodeIdFilter = await getNodeIdsAtLocations(locationIds);
    if (nodeIdFilter.length === 0) return { items: [], total: 0, page, pageSize };
  }

  let query = supabase
    .from("nodes")
    .select(NODE_ACTIVITY_SELECT, { count: "exact" })
    .eq("node_type", "activity")
    .eq("status", "published");

  if (options.category) query = query.eq("activities.activity_category", options.category);
  if (options.providerId) query = query.eq("activities.operated_by_provider_id", options.providerId);
  if (options.difficulty) query = query.eq("activities.difficulty", options.difficulty);
  if (options.minDurationMinutes !== undefined) query = query.gte("activities.duration_minutes", options.minDurationMinutes);
  if (options.maxDurationMinutes !== undefined) query = query.lte("activities.duration_minutes", options.maxDurationMinutes);
  if (options.minAge !== undefined) query = query.lte("activities.min_age", options.minAge);
  if (options.maxPriceFrom !== undefined) query = query.lte("activities.price_from", options.maxPriceFrom);
  if (options.maxParticipants !== undefined) query = query.gte("activities.max_participants", options.maxParticipants);
  if (nodeIdFilter) query = query.in("id", nodeIdFilter);
  if (options.nodeIds) query = query.in("id", options.nodeIds);

  const { data, error, count } = await query
    .order("title", { ascending: true })
    .range(from, to)
    .returns<NodeActivityRow[]>();

  if (error || !data) return { items: [], total: 0, page, pageSize };

  const bares = data.map(bareActivityOf).filter((b): b is BareActivity => b !== null);
  const [locationsByNodeId, heroByNodeId] = await Promise.all([
    attachPrimaryLocations(bares.map((b) => b.id)),
    getHeroMediaByNodeIds(bares.map((b) => b.id)),
  ]);

  const items = bares.map((b) => toSummary(b, locationsByNodeId.get(b.id) ?? null, heroByNodeId.get(b.id) ?? null));
  return { items, total: count ?? items.length, page, pageSize };
}

// The directory/filter pages (fishing, diving, activities) call this on
// every page view with no caching anywhere, including crawler traffic
// hitting many filter-param permutations — see src/lib/cache/cached-read.ts
// for why that was exhausting Supabase compute/disk-IO.
export const getActivities = cachedRead(getActivitiesUncached, ["activities:list"], 300);

export async function getActivitiesByCategory(
  category: ActivityCategory,
  options: Omit<GetActivitiesOptions, "category"> = {},
): Promise<PaginatedResult<ActivitySummary>> {
  return getActivities({ ...options, category });
}

export async function getActivitiesByLocation(locationId: string): Promise<ActivitySummary[]> {
  const result = await getActivities({ locationId, pageSize: 100 });
  return result.items;
}

export async function getActivitiesByAtoll(atollId: string): Promise<ActivitySummary[]> {
  const result = await getActivities({ atollId, pageSize: 100 });
  return result.items;
}

export interface NearbyActivities {
  /** Activities on the exact same island/resort location as the given
   * accommodation, atoll, or other location-bearing entity. */
  islandActivities: ActivitySummary[];
  /** Activities elsewhere in the same atoll, excluding anything already
   * returned in `islandActivities` — a genuinely wider-but-real tier, not
   * a "nearest six" cutoff. */
  atollActivities: ActivitySummary[];
}

/**
 * Location-aware activity matching for any page that wants to answer
 * "what can I do near here" without an explicit accommodation↔activity
 * relationship — accommodation pages today, potentially island/attraction
 * pages later. Deliberately two tiers only (island, then atoll): a
 * "same property" tier would need a real accommodation↔activity
 * relationship this schema doesn't have, and a geographic-distance tier
 * would need real coordinates most locations don't have — inventing
 * either would violate the "no fabricated proximity claims" rule this was
 * built under, so both are left for a future task with real data to
 * support them, rather than faked here.
 */
export async function getNearbyActivities(
  location: { islandId?: string | null; atollId?: string | null },
  limit = 6,
): Promise<NearbyActivities> {
  const islandActivitiesFull = location.islandId ? await getActivitiesByLocation(location.islandId) : [];
  const atollActivitiesFull = location.atollId ? await getActivitiesByAtoll(location.atollId) : [];

  const islandIds = new Set(islandActivitiesFull.map((a) => a.id));
  const atollOnly = atollActivitiesFull.filter((a) => !islandIds.has(a.id));

  return {
    islandActivities: islandActivitiesFull.slice(0, limit),
    atollActivities: atollOnly.slice(0, limit),
  };
}

export async function getActivitiesByProvider(providerId: string): Promise<ActivitySummary[]> {
  const result = await getActivities({ providerId, pageSize: 100 });
  return result.items;
}

async function getActivityBySlugUncached(slug: string): Promise<ActivityDetail | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_ACTIVITY_SELECT)
    .eq("node_type", "activity")
    .eq("status", "published")
    .eq("slug", slug)
    .maybeSingle<NodeActivityRow>();

  if (error || !data) return null;
  const bare = bareActivityOf(data);
  if (!bare) return null;

  const [primaryLocation, media, providersById, bookableRow] = await Promise.all([
    attachPrimaryLocations([bare.id]).then((m) => m.get(bare.id) ?? null),
    getMediaForNode(bare.id),
    bare.providerId ? getProviderSummariesByIds([bare.providerId]) : Promise.resolve(new Map<string, ProviderSummary>()),
    supabase.from("bookable_products").select("id").eq("id", bare.id).maybeSingle(),
  ]);
  const heroImage = media.find((m) => m.role === "hero")?.asset ?? null;
  const gallery = media.filter((m) => m.role === "gallery").map((m) => m.asset);

  const atoll = primaryLocation?.parentId ? await getLocationSummaryById(primaryLocation.parentId) : null;

  return {
    ...toSummary(bare, primaryLocation, heroImage),
    minAge: bare.minAge,
    maxParticipants: bare.maxParticipants,
    metaTitle: bare.metaTitle,
    metaDescription: bare.metaDescription,
    provider: bare.providerId ? providersById.get(bare.providerId) ?? null : null,
    atoll,
    isBookable: Boolean(bookableRow.data),
    gallery,
  };
}

export const getActivityBySlug = cachedRead(getActivityBySlugUncached, ["activities:by-slug"], 300);

/** Batch lookup by node id — used by the package repository to resolve
 * itinerary items without an N+1 query per item (Task 11). */
async function getActivitySummariesByIdsUncached(ids: string[]): Promise<Map<string, ActivitySummary>> {
  const map = new Map<string, ActivitySummary>();
  if (ids.length === 0) return map;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_ACTIVITY_SELECT)
    .eq("node_type", "activity")
    .eq("status", "published")
    .in("id", ids)
    .returns<NodeActivityRow[]>();

  if (error || !data) return map;

  const bares = data.map(bareActivityOf).filter((b): b is BareActivity => b !== null);
  const [locationsByNodeId, heroByNodeId] = await Promise.all([
    attachPrimaryLocations(bares.map((b) => b.id)),
    getHeroMediaByNodeIds(bares.map((b) => b.id)),
  ]);
  for (const bare of bares) {
    map.set(bare.id, toSummary(bare, locationsByNodeId.get(bare.id) ?? null, heroByNodeId.get(bare.id) ?? null));
  }
  return map;
}

export const getActivitySummariesByIds = cachedRead(getActivitySummariesByIdsUncached, ["activities:by-ids"], 300);

export interface SearchActivitiesOptions {
  limit?: number;
}

export async function searchActivities(query: string, options: SearchActivitiesOptions = {}): Promise<ActivitySummary[]> {
  const trimmed = query.trim();
  if (trimmed.length === 0) return [];

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_ACTIVITY_SELECT)
    .eq("node_type", "activity")
    .eq("status", "published")
    .ilike("title", `%${trimmed}%`)
    .order("title", { ascending: true })
    .limit(options.limit ?? 20)
    .returns<NodeActivityRow[]>();

  if (error || !data) return [];

  const bares = data.map(bareActivityOf).filter((b): b is BareActivity => b !== null);
  const [locationsByNodeId, heroByNodeId] = await Promise.all([
    attachPrimaryLocations(bares.map((b) => b.id)),
    getHeroMediaByNodeIds(bares.map((b) => b.id)),
  ]);
  return bares.map((b) => toSummary(b, locationsByNodeId.get(b.id) ?? null, heroByNodeId.get(b.id) ?? null));
}
