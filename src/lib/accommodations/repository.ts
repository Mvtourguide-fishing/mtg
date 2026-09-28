import "server-only";

import { getLocationSummariesByIds, getLocationSummaryById, getNodeAttributesByIds } from "@/lib/locations/repository";
import type { LocationSummary } from "@/lib/locations/types";
import { getHeroMediaByNodeIds, getMediaAssetsByIds, getMediaForNode } from "@/lib/media/repository";
import type { MediaAsset } from "@/lib/media/types";
import { getProviderSummariesByIds } from "@/lib/providers/repository";
import type { ProviderSummary } from "@/lib/providers/types";
import { createClient } from "@/lib/supabase/public";
import type {
  AccommodationDetail,
  AccommodationFilters,
  AccommodationRoom,
  AccommodationSummary,
  AccommodationType,
  PaginatedResult,
  PriceTier,
} from "@/lib/accommodations/types";

/**
 * Server-side accommodation data-access layer, following the same pattern
 * as src/lib/locations/repository.ts and src/lib/providers/repository.ts:
 * pages call these functions, never Supabase directly. Every function here
 * only returns published accommodations (public read, no user context).
 *
 * N+1 avoidance: directory-style functions fetch the base accommodation
 * rows in one query, then resolve primary locations (and, on detail pages,
 * providers/atolls) via a small number of additional *batched* queries —
 * never one extra query per accommodation. This mirrors the
 * island-count-per-atoll pattern from the Task 4 location repository.
 */

// `accommodations!inner(...)` — not a plain embed. See the identical note
// in src/lib/locations/repository.ts: without `!inner`, filtering on an
// embedded column doesn't restrict which `nodes` rows come back.
const NODE_ACCOMMODATION_SELECT =
  "id, slug, title, summary, meta_title, meta_description, accommodations!inner(accommodation_type, star_rating, price_tier, room_count, all_inclusive, overwater_villas, check_in_time, check_out_time, currency, operated_by_provider_id, price_from, video_youtube_id)";

type AccommodationFields = {
  accommodation_type: AccommodationType;
  star_rating: number | null;
  price_tier: PriceTier | null;
  room_count: number | null;
  all_inclusive: boolean | null;
  overwater_villas: boolean | null;
  check_in_time: string | null;
  check_out_time: string | null;
  currency: string | null;
  operated_by_provider_id: string | null;
  price_from: number | null;
  video_youtube_id: string | null;
};

type NodeAccommodationRow = {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  meta_title: string | null;
  meta_description: string | null;
  // Defensive-coded as possibly-an-array — see the identical note in
  // src/lib/locations/repository.ts (could not be verified end-to-end
  // against a live PostgREST instance in this sandbox).
  accommodations: AccommodationFields | AccommodationFields[] | null;
};

interface BareAccommodation {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  metaTitle: string | null;
  metaDescription: string | null;
  accommodationType: AccommodationType;
  starRating: number | null;
  priceTier: PriceTier | null;
  roomCount: number | null;
  allInclusive: boolean | null;
  overwaterVillas: boolean | null;
  checkInTime: string | null;
  checkOutTime: string | null;
  currency: string | null;
  providerId: string | null;
  priceFrom: number | null;
  videoYoutubeId: string | null;
}

function bareAccommodationOf(row: NodeAccommodationRow): BareAccommodation | null {
  const a = Array.isArray(row.accommodations) ? row.accommodations[0] : row.accommodations;
  if (!a) return null;

  return {
    id: row.id,
    slug: row.slug,
    title: row.title,
    summary: row.summary,
    metaTitle: row.meta_title,
    metaDescription: row.meta_description,
    accommodationType: a.accommodation_type,
    starRating: a.star_rating,
    priceTier: a.price_tier,
    roomCount: a.room_count,
    allInclusive: a.all_inclusive,
    overwaterVillas: a.overwater_villas,
    checkInTime: a.check_in_time,
    checkOutTime: a.check_out_time,
    currency: a.currency,
    providerId: a.operated_by_provider_id,
    priceFrom: a.price_from,
    videoYoutubeId: a.video_youtube_id,
  };
}

function toSummary(bare: BareAccommodation, primaryLocation: LocationSummary | null, heroImage: MediaAsset | null): AccommodationSummary {
  return {
    id: bare.id,
    slug: bare.slug,
    title: bare.title,
    summary: bare.summary,
    accommodationType: bare.accommodationType,
    starRating: bare.starRating,
    priceTier: bare.priceTier,
    allInclusive: bare.allInclusive,
    overwaterVillas: bare.overwaterVillas,
    primaryLocation,
    heroImage,
    priceFrom: bare.priceFrom,
    priceFromCurrency: bare.priceFrom !== null ? (bare.currency ?? "USD") : null,
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

/** node_ids of every node whose node_locations includes any of `locationIds`. */
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

export interface GetAccommodationsOptions extends AccommodationFilters {
  page?: number;
  pageSize?: number;
}

export async function getAccommodations(
  options: GetAccommodationsOptions = {},
): Promise<PaginatedResult<AccommodationSummary>> {
  const page = Math.max(1, options.page ?? 1);
  const pageSize = Math.min(100, Math.max(1, options.pageSize ?? 24));
  const from = (page - 1) * pageSize;
  const to = from + pageSize - 1;

  const supabase = await createClient();

  // atollId/locationId filters resolve to a node-id allowlist first (via
  // node_locations), since "accommodation.island/atoll" isn't a column on
  // `nodes` or `accommodations` — it's a relationship.
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
    if (nodeIdFilter.length === 0) {
      return { items: [], total: 0, page, pageSize };
    }
  }

  let query = supabase
    .from("nodes")
    .select(NODE_ACCOMMODATION_SELECT, { count: "exact" })
    .eq("node_type", "accommodation")
    .eq("status", "published");

  if (options.type) query = query.eq("accommodations.accommodation_type", options.type);
  if (options.priceTier) query = query.eq("accommodations.price_tier", options.priceTier);
  // "N stars and up" (matches the filter UI's "N★+" labeling), not an exact match.
  if (options.starRating) query = query.gte("accommodations.star_rating", options.starRating);
  if (options.allInclusive !== undefined) query = query.eq("accommodations.all_inclusive", options.allInclusive);
  if (options.overwaterVillas !== undefined)
    query = query.eq("accommodations.overwater_villas", options.overwaterVillas);
  if (nodeIdFilter) query = query.in("id", nodeIdFilter);

  const { data, error, count } = await query
    .order("title", { ascending: true })
    .range(from, to)
    .returns<NodeAccommodationRow[]>();

  if (error || !data) return { items: [], total: 0, page, pageSize };

  const bares = data.map(bareAccommodationOf).filter((b): b is BareAccommodation => b !== null);
  const [locationsByNodeId, heroByNodeId] = await Promise.all([
    attachPrimaryLocations(bares.map((b) => b.id)),
    getHeroMediaByNodeIds(bares.map((b) => b.id)),
  ]);

  const items = bares.map((b) => toSummary(b, locationsByNodeId.get(b.id) ?? null, heroByNodeId.get(b.id) ?? null));
  return { items, total: count ?? items.length, page, pageSize };
}

export async function getAccommodationsByType(
  type: AccommodationType,
  options: Omit<GetAccommodationsOptions, "type"> = {},
): Promise<PaginatedResult<AccommodationSummary>> {
  return getAccommodations({ ...options, type });
}

export async function getAccommodationsByLocation(locationId: string): Promise<AccommodationSummary[]> {
  const result = await getAccommodations({ locationId, pageSize: 100 });
  return result.items;
}

export async function getAccommodationsByAtoll(atollId: string): Promise<AccommodationSummary[]> {
  const result = await getAccommodations({ atollId, pageSize: 100 });
  return result.items;
}

export interface NearbyAccommodations {
  islandAccommodations: AccommodationSummary[];
  /** Accommodation elsewhere in the same atoll, excluding anything
   * already in `islandAccommodations`. */
  atollAccommodations: AccommodationSummary[];
}

/** The reverse of getNearbyActivities/getNearbyAttractions — "where can I
 * stay for this activity/attraction" — same two real tiers, same reason
 * for stopping there (see that function's own comment). */
export async function getNearbyAccommodations(
  location: { islandId?: string | null; atollId?: string | null },
  limit = 6,
): Promise<NearbyAccommodations> {
  const islandFull = location.islandId ? await getAccommodationsByLocation(location.islandId) : [];
  const atollFull = location.atollId ? await getAccommodationsByAtoll(location.atollId) : [];

  const islandIds = new Set(islandFull.map((a) => a.id));
  const atollOnly = atollFull.filter((a) => !islandIds.has(a.id));

  return {
    islandAccommodations: islandFull.slice(0, limit),
    atollAccommodations: atollOnly.slice(0, limit),
  };
}

/** Every accommodation operated by a given provider — powers the reverse
 * "Provider → Accommodations" link (§17). */
export async function getAccommodationsByProvider(providerId: string): Promise<AccommodationSummary[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_ACCOMMODATION_SELECT)
    .eq("node_type", "accommodation")
    .eq("status", "published")
    .eq("accommodations.operated_by_provider_id", providerId)
    .order("title", { ascending: true })
    .returns<NodeAccommodationRow[]>();

  if (error || !data) return [];

  const bares = data.map(bareAccommodationOf).filter((b): b is BareAccommodation => b !== null);
  const [locationsByNodeId, heroByNodeId] = await Promise.all([
    attachPrimaryLocations(bares.map((b) => b.id)),
    getHeroMediaByNodeIds(bares.map((b) => b.id)),
  ]);
  return bares.map((b) => toSummary(b, locationsByNodeId.get(b.id) ?? null, heroByNodeId.get(b.id) ?? null));
}

type AccommodationRoomRow = {
  id: string;
  name: string;
  price_from: number | null;
  price_currency: string | null;
  bed_type: string | null;
  max_occupancy: number | null;
};

/** Real room/villa-type rows for one property, with their 1-2 real
 * per-room photos batched in — never an N+1 (one query for rooms, one
 * for the room->media join, one for the media assets themselves). Detail
 * pages only; listing/card queries never fetch rooms. */
async function getAccommodationRooms(accommodationId: string): Promise<AccommodationRoom[]> {
  const supabase = await createClient();
  const { data: roomRows, error } = await supabase
    .from("accommodation_rooms")
    .select("id, name, price_from, price_currency, bed_type, max_occupancy")
    .eq("accommodation_id", accommodationId)
    .order("sort_order", { ascending: true })
    .returns<AccommodationRoomRow[]>();

  if (error || !roomRows || roomRows.length === 0) return [];

  const { data: mediaRows } = await supabase
    .from("accommodation_room_media")
    .select("room_id, media_id, sort_order")
    .in("room_id", roomRows.map((r) => r.id))
    .order("sort_order", { ascending: true })
    .returns<Array<{ room_id: string; media_id: string; sort_order: number }>>();

  const mediaIds = Array.from(new Set((mediaRows ?? []).map((r) => r.media_id)));
  const assetsById = await getMediaAssetsByIds(mediaIds);

  const imagesByRoom = new Map<string, MediaAsset[]>();
  for (const row of mediaRows ?? []) {
    const asset = assetsById.get(row.media_id);
    if (!asset) continue;
    const list = imagesByRoom.get(row.room_id) ?? [];
    list.push(asset);
    imagesByRoom.set(row.room_id, list);
  }

  return roomRows.map((r) => ({
    id: r.id,
    name: r.name,
    priceFrom: r.price_from,
    currency: r.price_currency,
    bedType: r.bed_type,
    maxOccupancy: r.max_occupancy,
    images: imagesByRoom.get(r.id) ?? [],
  }));
}

export async function getAccommodationBySlug(slug: string): Promise<AccommodationDetail | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_ACCOMMODATION_SELECT)
    .eq("node_type", "accommodation")
    .eq("status", "published")
    .eq("slug", slug)
    .maybeSingle<NodeAccommodationRow>();

  if (error || !data) return null;
  const bare = bareAccommodationOf(data);
  if (!bare) return null;

  const [primaryLocation, providersById, bookableRow, heroImage, rooms, galleryMedia, attributesById] = await Promise.all([
    attachPrimaryLocations([bare.id]).then((m) => m.get(bare.id) ?? null),
    bare.providerId ? getProviderSummariesByIds([bare.providerId]) : Promise.resolve(new Map<string, ProviderSummary>()),
    supabase.from("bookable_products").select("id").eq("id", bare.id).maybeSingle(),
    getHeroMediaByNodeIds([bare.id]).then((m) => m.get(bare.id) ?? null),
    getAccommodationRooms(bare.id),
    getMediaForNode(bare.id),
    getNodeAttributesByIds([bare.id]),
  ]);

  const overviewParagraphsRaw = attributesById.get(bare.id)?.overview_paragraphs;
  const overviewParagraphs = Array.isArray(overviewParagraphsRaw) ? overviewParagraphsRaw.filter((p): p is string => typeof p === "string") : [];

  const atoll = primaryLocation?.parentId ? await getLocationSummaryById(primaryLocation.parentId) : null;

  return {
    ...toSummary(bare, primaryLocation, heroImage),
    roomCount: bare.roomCount,
    checkInTime: bare.checkInTime,
    checkOutTime: bare.checkOutTime,
    currency: bare.currency,
    metaTitle: bare.metaTitle,
    metaDescription: bare.metaDescription,
    provider: bare.providerId ? providersById.get(bare.providerId) ?? null : null,
    atoll,
    isBookable: Boolean(bookableRow.data),
    videoYoutubeId: bare.videoYoutubeId,
    rooms,
    galleryImages: galleryMedia.filter((item) => item.role === "gallery").map((item) => item.asset),
    overviewParagraphs,
  };
}

/** Batch lookup by node id — used by the package repository to resolve
 * itinerary items without an N+1 query per item (Task 11). */
export async function getAccommodationSummariesByIds(ids: string[]): Promise<Map<string, AccommodationSummary>> {
  const map = new Map<string, AccommodationSummary>();
  if (ids.length === 0) return map;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_ACCOMMODATION_SELECT)
    .eq("node_type", "accommodation")
    .eq("status", "published")
    .in("id", ids)
    .returns<NodeAccommodationRow[]>();

  if (error || !data) return map;

  const bares = data.map(bareAccommodationOf).filter((b): b is BareAccommodation => b !== null);
  const [locationsByNodeId, heroByNodeId] = await Promise.all([
    attachPrimaryLocations(bares.map((b) => b.id)),
    getHeroMediaByNodeIds(bares.map((b) => b.id)),
  ]);
  for (const bare of bares) {
    map.set(bare.id, toSummary(bare, locationsByNodeId.get(bare.id) ?? null, heroByNodeId.get(bare.id) ?? null));
  }
  return map;
}

export interface SearchAccommodationsOptions {
  limit?: number;
}

export async function searchAccommodations(
  query: string,
  options: SearchAccommodationsOptions = {},
): Promise<AccommodationSummary[]> {
  const trimmed = query.trim();
  if (trimmed.length === 0) return [];

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_ACCOMMODATION_SELECT)
    .eq("node_type", "accommodation")
    .eq("status", "published")
    .ilike("title", `%${trimmed}%`)
    .order("title", { ascending: true })
    .limit(options.limit ?? 20)
    .returns<NodeAccommodationRow[]>();

  if (error || !data) return [];

  const bares = data.map(bareAccommodationOf).filter((b): b is BareAccommodation => b !== null);
  const [locationsByNodeId, heroByNodeId] = await Promise.all([
    attachPrimaryLocations(bares.map((b) => b.id)),
    getHeroMediaByNodeIds(bares.map((b) => b.id)),
  ]);
  return bares.map((b) => toSummary(b, locationsByNodeId.get(b.id) ?? null, heroByNodeId.get(b.id) ?? null));
}
