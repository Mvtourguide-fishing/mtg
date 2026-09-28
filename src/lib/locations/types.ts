// Domain types for the location read layer. Hand-written rather than
// derived from src/types/database.ts because that file is still the
// Task 3 placeholder (no live Supabase project was available to generate
// real types from — see that file's header and the Task 4 report for why).
// Once real generated types exist, these can be narrowed to
// `Database["public"]["Tables"]["nodes"]["Row"]` etc.

import type { MediaAsset } from "@/lib/media/types";

export type LocationType =
  | "country"
  | "atoll"
  | "island"
  | "locality"
  | "airport"
  | "seaport"
  | "harbour"
  | "poi"
  | "dive_site"
  | "surf_break"
  | "fishing_spot";

/** Shared fields every location listing/detail view needs. */
export interface LocationSummary {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  locationType: LocationType;
  parentId: string | null;
  isInhabited: boolean | null;
  /** Real legacy/uploaded photo, when one has been attached (see
   * scripts/attach-island-images.mjs) — never a placeholder. Most
   * locations don't have one; null is the normal case, not an error. */
  heroImage: MediaAsset | null;
}

/** Adds the fields a detail page needs beyond a listing card. */
export interface LocationDetail extends LocationSummary {
  metaTitle: string | null;
  metaDescription: string | null;
  lat: number | null;
  lng: number | null;
  administrativeCode: string | null;
  path: string;
}

export interface AtollSummary extends LocationSummary {
  locationType: "atoll";
  islandCount: number;
}

export interface AtollDetail extends LocationDetail {
  locationType: "atoll";
}

export interface IslandSummary extends LocationSummary {
  locationType: "island";
  atollId: string | null;
}

export interface IslandDetail extends LocationDetail {
  locationType: "island";
}

export interface PaginatedResult<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
}

/** Destination guide content stored in an island's own `nodes.attributes`
 * jsonb (see getNodeAttributes) — MTG's own previously-published guide
 * content, cleaned and restructured, never fabricated facts (see
 * scripts/import-legacy-island-content.mjs for the sanitization pass that
 * strips unverifiable prices/transfer-times before this is written). Not
 * every island has one — only those with usable legacy source content. */
export interface IslandQuickFact {
  label: string;
  value: string;
}

export interface IslandContentSection {
  heading: string;
  paragraphs: string[];
}

export interface IslandFaq {
  question: string;
  answer: string;
}

export interface IslandContentProfile {
  contentSource: string;
  quickFacts: IslandQuickFact[];
  overview: string[];
  sections: IslandContentSection[];
  faqs: IslandFaq[];
  nearbyIslandSlugs: string[];
}

/** Same idea as IslandContentProfile, for atolls — see
 * scripts/import-legacy-atoll-content.mjs. */
export interface AtollContentProfile {
  contentSource: string;
  sections: IslandContentSection[];
}
