import type { LocationSummary } from "@/lib/locations/types";
import type { MediaAsset } from "@/lib/media/types";

/**
 * Maldives Attractions — real, physical points of interest (landmarks,
 * museums, monuments, public beaches, markets). Represented as `locations`
 * rows (location_type = 'poi'), the exact same architecture already used
 * for dive sites (location_type = 'dive_site') and surf breaks
 * (location_type = 'surf_break') — no new table, no duplicate entity
 * model. An attraction is a place, never a bookable product — it is
 * deliberately NOT an `activities` row.
 */
export type AttractionType =
  | "religious"
  | "museum"
  | "monument"
  | "park"
  | "beach"
  | "market"
  | "landmark"
  | "infrastructure"
  | "natural"
  | "marine";

/** Broad groupings for the "browse by type" view (Task 15 §6/§11) — a
 * coarser layer over AttractionType, the same relationship
 * SearchGroupKey has to SearchResultType. Every AttractionType maps to
 * exactly one group. */
export type AttractionSuperGroup = "natural" | "marine" | "cultural";

export const ATTRACTION_SUPER_GROUP: Record<AttractionType, AttractionSuperGroup> = {
  natural: "natural",
  beach: "natural",
  park: "natural",
  marine: "marine",
  religious: "cultural",
  museum: "cultural",
  monument: "cultural",
  market: "cultural",
  landmark: "cultural",
  infrastructure: "cultural",
};

export const ATTRACTION_SUPER_GROUP_LABEL: Record<AttractionSuperGroup, string> = {
  natural: "Natural Attractions",
  marine: "Marine & Wildlife",
  cultural: "Cultural & Historical",
};

export const ATTRACTION_TYPE_LABEL: Record<AttractionType, string> = {
  religious: "Religious site",
  museum: "Museum",
  monument: "Monument",
  park: "Park",
  beach: "Beach",
  market: "Market",
  landmark: "Landmark",
  infrastructure: "Landmark",
  natural: "Natural site",
  marine: "Marine & wildlife site",
};

export interface AttractionSummary {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  attractionType: AttractionType | null;
  heroImage: MediaAsset | null;
  island: LocationSummary | null;
  atoll: LocationSummary | null;
}

export interface AttractionDetail extends AttractionSummary {
  body: string | null;
  bestFor: string | null;
  sourceArticleSlug: string | null;
}

export interface GetAttractionsOptions {
  page?: number;
  pageSize?: number;
  atollId?: string;
  islandId?: string;
  attractionType?: AttractionType;
}

export interface PaginatedResult<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
}

export function attractionHref(attraction: { slug: string }): string {
  return `/maldives/attractions/${attraction.slug}/`;
}
