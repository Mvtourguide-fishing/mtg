import "server-only";

import type { AttractionDetail, AttractionSummary, AttractionType, GetAttractionsOptions, PaginatedResult } from "@/lib/attractions/types";
import {
  getLocationBySlugAndType,
  getLocationSummariesByIds,
  getLocationSummaryById,
  getLocationsByType,
  getLocationsByTypeAndAtoll,
  getNodeAttributesByIds,
} from "@/lib/locations/repository";
import type { LocationSummary } from "@/lib/locations/types";
import { getHeroMediaByNodeIds } from "@/lib/media/repository";
import type { MediaAsset } from "@/lib/media/types";

/**
 * Attractions compose the existing location repository exactly the way
 * src/lib/diving/repository.ts composes it for dive sites — no new query
 * logic, no new table.
 */

function toAttractionSummary(
  location: LocationSummary,
  attributes: Record<string, unknown> | undefined,
  heroImage: MediaAsset | null,
  island: LocationSummary | null,
  atoll: LocationSummary | null,
): AttractionSummary {
  const attractionType = typeof attributes?.attraction_type === "string" ? (attributes.attraction_type as AttractionType) : null;
  return {
    id: location.id,
    slug: location.slug,
    title: location.title,
    summary: location.summary,
    attractionType,
    heroImage,
    island,
    atoll,
  };
}

export async function getAttractions(options: GetAttractionsOptions = {}): Promise<PaginatedResult<AttractionSummary>> {
  const page = options.page ?? 1;
  const pageSize = options.pageSize ?? 48;

  let items: LocationSummary[];
  let total: number;
  if (options.atollId) {
    items = await getLocationsByTypeAndAtoll("poi", options.atollId);
    total = items.length;
  } else {
    const result = await getLocationsByType("poi", { page, pageSize });
    items = result.items;
    total = result.total;
  }

  if (options.islandId) {
    items = items.filter((i) => i.parentId === options.islandId);
    total = items.length;
  }

  const [attrsById, heroById, directParentById] = await Promise.all([
    getNodeAttributesByIds(items.map((i) => i.id)),
    getHeroMediaByNodeIds(items.map((i) => i.id)),
    getDirectParentsById(items),
  ]);
  const atollById = await getAtollsForDirectParents(directParentById);
  let attractions = items.map((i) => {
    const directParent = directParentById.get(i.id) ?? null;
    const island = directParent?.locationType === "island" ? directParent : null;
    return toAttractionSummary(i, attrsById.get(i.id), heroById.get(i.id) ?? null, island, atollById.get(i.id) ?? null);
  });

  if (options.attractionType) {
    attractions = attractions.filter((a) => a.attractionType === options.attractionType);
    total = attractions.length;
  }

  return { items: attractions, total, page, pageSize };
}

/** Every attraction's direct parent location is the island it's physically
 * on — or, for a handful not tied to one inhabited island (Hanifaru Bay,
 * an open-water reserve; Ozen Maadhoo, an unseeded resort island), the
 * atoll directly. A single batched getLocationSummariesByIds over each
 * item's parentId, no per-item round trip. */
async function getDirectParentsById(items: LocationSummary[]): Promise<Map<string, LocationSummary>> {
  const parentIds = Array.from(new Set(items.map((i) => i.parentId).filter((id): id is string => Boolean(id))));
  if (parentIds.length === 0) return new Map();
  const parentsById = await getLocationSummariesByIds(parentIds);
  const result = new Map<string, LocationSummary>();
  for (const item of items) {
    if (item.parentId && parentsById.has(item.parentId)) result.set(item.id, parentsById.get(item.parentId)!);
  }
  return result;
}

/** The atoll for each item: its direct parent when that's already an
 * atoll, otherwise its island parent's own parent — resolved with one
 * more batched lookup, never per item. */
async function getAtollsForDirectParents(directParentById: Map<string, LocationSummary>): Promise<Map<string, LocationSummary>> {
  const result = new Map<string, LocationSummary>();
  const islandParentIdsToResolve = new Set<string>();
  for (const parent of directParentById.values()) {
    if (parent.locationType === "island" && parent.parentId) islandParentIdsToResolve.add(parent.parentId);
  }
  const atollsByIslandParentId = islandParentIdsToResolve.size > 0 ? await getLocationSummariesByIds(Array.from(islandParentIdsToResolve)) : new Map();

  for (const [itemId, parent] of directParentById) {
    if (parent.locationType === "atoll") {
      result.set(itemId, parent);
    } else if (parent.locationType === "island" && parent.parentId) {
      const atoll = atollsByIslandParentId.get(parent.parentId);
      if (atoll?.locationType === "atoll") result.set(itemId, atoll);
    }
  }
  return result;
}

export async function getAttractionsByIsland(islandId: string): Promise<AttractionSummary[]> {
  const result = await getAttractions({ islandId, pageSize: 100 });
  return result.items;
}

export async function getAttractionsByAtoll(atollId: string): Promise<AttractionSummary[]> {
  const result = await getAttractions({ atollId, pageSize: 100 });
  return result.items;
}

export interface NearbyAttractions {
  islandAttractions: AttractionSummary[];
  /** Attractions elsewhere in the same atoll, excluding anything already
   * in `islandAttractions`. */
  atollAttractions: AttractionSummary[];
}

/** Same two-tier (island, then atoll) matching as
 * src/lib/activities/repository.ts's getNearbyActivities, and for the
 * same reason: no fabricated "same property" or distance tier. */
export async function getNearbyAttractions(
  location: { islandId?: string | null; atollId?: string | null },
  limit = 6,
): Promise<NearbyAttractions> {
  const islandAttractionsFull = location.islandId ? await getAttractionsByIsland(location.islandId) : [];
  const atollAttractionsFull = location.atollId ? await getAttractionsByAtoll(location.atollId) : [];

  const islandIds = new Set(islandAttractionsFull.map((a) => a.id));
  const atollOnly = atollAttractionsFull.filter((a) => !islandIds.has(a.id));

  return {
    islandAttractions: islandAttractionsFull.slice(0, limit),
    atollAttractions: atollOnly.slice(0, limit),
  };
}

export async function getAttractionBySlug(slug: string): Promise<AttractionDetail | null> {
  const location = await getLocationBySlugAndType(slug, "poi");
  if (!location) return null;

  const [attrs, hero, parent] = await Promise.all([
    getNodeAttributesByIds([location.id]).then((m) => m.get(location.id) ?? {}),
    getHeroMediaByNodeIds([location.id]).then((m) => m.get(location.id) ?? null),
    location.parentId ? getLocationSummaryById(location.parentId) : Promise.resolve(null),
  ]);

  // The direct parent is an island for most attractions; a handful
  // (Hanifaru Bay, Ozen Maadhoo) have no single host island and are
  // parented straight to their atoll instead.
  const island = parent?.locationType === "island" ? parent : null;
  const atoll = parent?.locationType === "atoll" ? parent : island?.parentId ? await getLocationSummaryById(island.parentId) : null;

  return {
    ...toAttractionSummary(location, attrs, hero, island, atoll?.locationType === "atoll" ? atoll : null),
    body: typeof attrs.body === "string" ? attrs.body : null,
    bestFor: typeof attrs.best_for === "string" ? attrs.best_for : null,
    sourceArticleSlug: typeof attrs.source_article_slug === "string" ? attrs.source_article_slug : null,
  };
}

export type { AttractionType };
