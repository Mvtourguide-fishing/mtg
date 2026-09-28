import "server-only";

import {
  getActivities,
  getActivityBySlug,
  searchActivities,
  type GetActivitiesOptions,
} from "@/lib/activities/repository";
import type { ActivityDetail, ActivitySummary, PaginatedResult as ActivityPaginatedResult } from "@/lib/activities/types";
import { getCategoriesByGroup, getCategoryBySlug, getNodeIdsByCategory } from "@/lib/categories/repository";
import type { CategorySummary } from "@/lib/categories/types";
import { createClient } from "@/lib/supabase/public";
import {
  getLocationBySlugAndType,
  getLocationIdsForNode,
  getLocationSummariesByIds,
  getLocationSummaryById,
  getLocationsByType,
  getLocationsByTypeAndAtoll,
  getNodeAttributesByIds,
  getNodeIdsAtLocation,
} from "@/lib/locations/repository";
import type { LocationSummary } from "@/lib/locations/types";
import type {
  GetSurfBreaksOptions,
  PaginatedResult,
  SurfBreakDetail,
  SurfBreakSummary,
  SurfBreakType,
} from "@/lib/surfing/types";

/**
 * Surfing is a specialized *view* over two existing systems, not a new data
 * model — the same pattern Task 7 established for fishing and Task 8 for
 * diving:
 *
 * - Surfing ACTIVITIES (lessons, coaching, guided trips, camps, rentals) are
 *   `activities` rows (activity_category = 'surfing') — see
 *   src/lib/diving/repository.ts for the identical composition approach.
 * - Physical surf BREAKS (reef/point/beach breaks, channels) are `locations`
 *   rows (location_type = 'surf_break') — never activities, never bookable
 *   products, per Task 9 §2.
 *
 * No new tables, no duplicated query logic.
 */

// ─────────────────────────────────────────────────────────────────
// Surfing activities (composes the Task 6 activity repository, identical
// shape to src/lib/diving/repository.ts)
// ─────────────────────────────────────────────────────────────────

export type GetSurfingActivitiesOptions = Omit<GetActivitiesOptions, "category">;

export async function getSurfingActivities(
  options: GetSurfingActivitiesOptions = {},
): Promise<ActivityPaginatedResult<ActivitySummary>> {
  return getActivities({ ...options, category: "surfing" });
}

export async function getSurfingActivityBySlug(slug: string): Promise<ActivityDetail | null> {
  const activity = await getActivityBySlug(slug);
  if (!activity || activity.activityCategory !== "surfing") return null;
  return activity;
}

export async function getSurfingActivitiesByLocation(locationId: string): Promise<ActivitySummary[]> {
  const result = await getSurfingActivities({ locationId, pageSize: 100 });
  return result.items;
}

export async function getSurfingActivitiesByAtoll(atollId: string): Promise<ActivitySummary[]> {
  const result = await getSurfingActivities({ atollId, pageSize: 100 });
  return result.items;
}

export async function getSurfingActivitiesByProvider(providerId: string): Promise<ActivitySummary[]> {
  const result = await getSurfingActivities({ providerId, pageSize: 100 });
  return result.items;
}

export async function searchSurfingActivities(query: string, options: { limit?: number } = {}): Promise<ActivitySummary[]> {
  const results = await searchActivities(query, options);
  return results.filter((a) => a.activityCategory === "surfing");
}

/** Every "activity-type" taxonomy tag actually applied to at least one
 * surfing activity — the surf-type filter chips are driven entirely by
 * what the seeded data supports, same pattern as fishing/diving types. */
export async function getSurfingTypesInUse(): Promise<CategorySummary[]> {
  const allTypes = await getCategoriesByGroup("activity-type");
  if (allTypes.length === 0) return [];

  // Only types actually tagged on a *surfing* activity (an "activity-type"
  // category could in principle be reused by another vertical too).
  const surfing = await getSurfingActivities({ pageSize: 100 });
  const surfingIds = new Set(surfing.items.map((a) => a.id));

  const taggedIdSets = await Promise.all(allTypes.map((t) => getNodeIdsByCategory(t.id)));
  return allTypes.filter((_, i) => taggedIdSets[i].some((id) => surfingIds.has(id)));
}

export async function getSurfingActivitiesByType(
  typeSlug: string,
  options: GetSurfingActivitiesOptions = {},
): Promise<ActivityPaginatedResult<ActivitySummary>> {
  const category = await getCategoryBySlug(typeSlug, "activity-type");
  if (!category) return { items: [], total: 0, page: options.page ?? 1, pageSize: options.pageSize ?? 24 };

  const nodeIds = await getNodeIdsByCategory(category.id);
  if (nodeIds.length === 0) return { items: [], total: 0, page: options.page ?? 1, pageSize: options.pageSize ?? 24 };

  return getSurfingActivities({ ...options, nodeIds });
}

/** The surf-type tag(s) attached to one activity, for detail-page display. */
export async function getSurfingTypesForActivity(nodeId: string): Promise<CategorySummary[]> {
  const supabase = await createClient();
  const { data } = await supabase
    .from("node_categories")
    .select("category_id")
    .eq("node_id", nodeId)
    .returns<Array<{ category_id: string }>>();

  const categoryIds = (data ?? []).map((row) => row.category_id);
  if (categoryIds.length === 0) return [];

  const allTypes = await getCategoriesByGroup("activity-type");
  return allTypes.filter((t) => categoryIds.includes(t.id));
}

/** The specific surf break(s) a surfing activity visits, ONLY where the
 * source data names one (node_locations secondary tag) — most surfing
 * activities won't have one, and that's expected. */
export async function getSurfBreaksForActivity(activityId: string): Promise<SurfBreakSummary[]> {
  const locationIds = await getLocationIdsForNode(activityId);
  if (locationIds.length === 0) return [];

  const summaries = await getLocationSummariesByIds(locationIds);
  const breakSummaries = Array.from(summaries.values()).filter((l) => l.locationType === "surf_break");
  if (breakSummaries.length === 0) return [];

  const [attrsById, atollById] = await Promise.all([
    getNodeAttributesByIds(breakSummaries.map((s) => s.id)),
    getAtollsByParentId(breakSummaries),
  ]);
  return breakSummaries.map((s) => toSurfBreakSummary(s, attrsById.get(s.id), atollById.get(s.id) ?? null));
}

// ─────────────────────────────────────────────────────────────────
// Surf breaks (composes the Task 4 location repository — generic
// getLocationsByType/getLocationBySlugAndType added in Task 8, reused
// here unmodified)
// ─────────────────────────────────────────────────────────────────

function toSurfBreakSummary(
  location: LocationSummary,
  attributes: Record<string, unknown> | undefined,
  atoll: LocationSummary | null = null,
): SurfBreakSummary {
  const breakType = typeof attributes?.break_type === "string" ? (attributes.break_type as SurfBreakType) : null;
  return {
    id: location.id,
    slug: location.slug,
    title: location.title,
    summary: location.summary,
    breakType,
    // location.heroImage already comes populated from the shared locations
    // repository (getLocationsByType/getLocationSummariesByIds/etc. all
    // batch-fetch it) — no separate media lookup needed here.
    heroImage: location.heroImage,
    atoll,
  };
}

/** Every surf break's parent location IS its atoll (same seed convention
 * as dive sites — see diving/repository.ts's getAtollsByParentId), so a
 * single batched lookup over each item's parentId is enough. */
async function getAtollsByParentId(items: LocationSummary[]): Promise<Map<string, LocationSummary>> {
  const parentIds = Array.from(new Set(items.map((i) => i.parentId).filter((id): id is string => Boolean(id))));
  if (parentIds.length === 0) return new Map();
  const atollsById = await getLocationSummariesByIds(parentIds);
  const result = new Map<string, LocationSummary>();
  for (const item of items) {
    if (item.parentId && atollsById.has(item.parentId)) result.set(item.id, atollsById.get(item.parentId)!);
  }
  return result;
}

export async function getSurfBreaks(options: GetSurfBreaksOptions = {}): Promise<PaginatedResult<SurfBreakSummary>> {
  const page = options.page ?? 1;
  const pageSize = options.pageSize ?? 48;

  let items: LocationSummary[];
  let total: number;
  if (options.atollId) {
    items = await getLocationsByTypeAndAtoll("surf_break", options.atollId);
    total = items.length;
  } else {
    const result = await getLocationsByType("surf_break", { page, pageSize });
    items = result.items;
    total = result.total;
  }

  const [attrsById, atollById] = await Promise.all([getNodeAttributesByIds(items.map((i) => i.id)), getAtollsByParentId(items)]);
  let breaks = items.map((i) => toSurfBreakSummary(i, attrsById.get(i.id), atollById.get(i.id) ?? null));

  if (options.breakType) {
    breaks = breaks.filter((b) => b.breakType === options.breakType);
    total = breaks.length;
  }

  return { items: breaks, total, page, pageSize };
}

export async function getSurfBreaksByAtoll(atollId: string): Promise<SurfBreakSummary[]> {
  const result = await getSurfBreaks({ atollId, pageSize: 100 });
  return result.items;
}

/** Surf breaks tagged to a location (typically an island, via a secondary
 * node_locations relation) — the reverse of getSurfBreaksForActivity's
 * pattern, used for "surf breaks near this island". */
export async function getSurfBreaksByLocation(locationId: string): Promise<SurfBreakSummary[]> {
  const nodeIds = await getNodeIdsAtLocation(locationId);
  if (nodeIds.length === 0) return [];

  const summaries = await getLocationSummariesByIds(nodeIds);
  const breakSummaries = Array.from(summaries.values()).filter((l) => l.locationType === "surf_break");
  if (breakSummaries.length === 0) return [];

  const [attrsById, atollById] = await Promise.all([
    getNodeAttributesByIds(breakSummaries.map((s) => s.id)),
    getAtollsByParentId(breakSummaries),
  ]);
  return breakSummaries.map((s) => toSurfBreakSummary(s, attrsById.get(s.id), atollById.get(s.id) ?? null));
}

export async function getSurfBreakBySlug(slug: string): Promise<SurfBreakDetail | null> {
  const location = await getLocationBySlugAndType(slug, "surf_break");
  if (!location) return null;

  const [attrs, atoll, nearbyIslandId] = await Promise.all([
    getNodeAttributesByIds([location.id]).then((m) => m.get(location.id) ?? {}),
    location.parentId ? getLocationSummaryById(location.parentId) : Promise.resolve(null),
    getLocationIdsForNode(location.id).then(async (ids) => {
      const summaries = await getLocationSummariesByIds(ids);
      return Array.from(summaries.values()).find((l) => l.locationType === "island") ?? null;
    }),
  ]);

  return {
    ...toSurfBreakSummary(location, attrs, atoll),
    nearbyIsland: nearbyIslandId,
    difficulty: typeof attrs.difficulty === "string" ? attrs.difficulty : null,
    waveNotes: typeof attrs.wave_notes === "string" ? attrs.wave_notes : null,
    seasonNotes: typeof attrs.season_notes === "string" ? attrs.season_notes : null,
    accessNotes: typeof attrs.access_notes === "string" ? attrs.access_notes : null,
  };
}

/** Surfing activities that visit a given surf break (node_locations tag in
 * either direction — see getSurfBreaksForActivity for the activity side). */
export async function getSurfingActivitiesAtBreak(breakId: string): Promise<ActivitySummary[]> {
  return getSurfingActivitiesByLocation(breakId);
}

export type { SurfBreakType };
