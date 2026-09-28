import "server-only";

import {
  getActivities,
  getActivityBySlug,
  searchActivities,
  type GetActivitiesOptions,
} from "@/lib/activities/repository";
import type { ActivityDetail, ActivitySummary, PaginatedResult } from "@/lib/activities/types";
import { getCategoriesByGroup, getCategoryBySlug, getNodeIdsByCategory } from "@/lib/categories/repository";
import type { CategorySummary } from "@/lib/categories/types";
import { createClient } from "@/lib/supabase/public";

/**
 * Fishing is a specialized *view* over the common activity system from
 * Task 6 — not a parallel data model. Every function here composes the
 * existing activity/category repositories (category = "fishing" is
 * already a relational `activities.activity_category` value; fishing
 * *type* — big game, night fishing, handline, etc. — is a
 * `category_group = "activity-type"` taxonomy tag via node_categories,
 * per the architecture's "use categories, not boolean columns" rule).
 * No new tables, no duplicated query logic.
 */

export type GetFishingActivitiesOptions = Omit<GetActivitiesOptions, "category">;

export async function getFishingActivities(
  options: GetFishingActivitiesOptions = {},
): Promise<PaginatedResult<ActivitySummary>> {
  return getActivities({ ...options, category: "fishing" });
}

export async function getFishingActivityBySlug(slug: string): Promise<ActivityDetail | null> {
  const activity = await getActivityBySlug(slug);
  if (!activity || activity.activityCategory !== "fishing") return null;
  return activity;
}

export async function getFishingActivitiesByLocation(locationId: string): Promise<ActivitySummary[]> {
  const result = await getFishingActivities({ locationId, pageSize: 100 });
  return result.items;
}

export async function getFishingActivitiesByAtoll(atollId: string): Promise<ActivitySummary[]> {
  const result = await getFishingActivities({ atollId, pageSize: 100 });
  return result.items;
}

export async function getFishingActivitiesByProvider(providerId: string): Promise<ActivitySummary[]> {
  const result = await getFishingActivities({ providerId, pageSize: 100 });
  return result.items;
}

export async function searchFishingActivities(query: string, options: { limit?: number } = {}): Promise<ActivitySummary[]> {
  const results = await searchActivities(query, options);
  return results.filter((a) => a.activityCategory === "fishing");
}

/** Every "activity-type" taxonomy tag actually applied to at least one
 * fishing activity — the fishing-type filter chips are driven entirely by
 * what the seeded data supports, never a hardcoded list. */
export async function getFishingTypesInUse(): Promise<CategorySummary[]> {
  const allTypes = await getCategoriesByGroup("activity-type");
  if (allTypes.length === 0) return [];

  const supabase = await createClient();
  const { data } = await supabase
    .from("node_categories")
    .select("category_id")
    .in(
      "category_id",
      allTypes.map((t) => t.id),
    )
    .returns<Array<{ category_id: string }>>();

  const usedIds = new Set((data ?? []).map((row) => row.category_id));
  return allTypes.filter((t) => usedIds.has(t.id));
}

export async function getFishingActivitiesByType(
  typeSlug: string,
  options: GetFishingActivitiesOptions = {},
): Promise<PaginatedResult<ActivitySummary>> {
  const category = await getCategoryBySlug(typeSlug, "activity-type");
  if (!category) return { items: [], total: 0, page: options.page ?? 1, pageSize: options.pageSize ?? 24 };

  const nodeIds = await getNodeIdsByCategory(category.id);
  if (nodeIds.length === 0) return { items: [], total: 0, page: options.page ?? 1, pageSize: options.pageSize ?? 24 };

  return getFishingActivities({ ...options, nodeIds });
}

/** The fishing-type tag(s) attached to one activity, for detail-page display. */
export async function getFishingTypesForActivity(nodeId: string): Promise<CategorySummary[]> {
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
