import type { LocationSummary } from "@/lib/locations/types";
import type { MediaAsset } from "@/lib/media/types";
import type { ProviderSummary } from "@/lib/providers/types";

export type AccommodationType = "hotel" | "resort" | "guesthouse" | "villa" | "liveaboard" | "other";
export type PriceTier = "budget" | "mid" | "luxury" | "ultra_luxury";

export interface AccommodationSummary {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  accommodationType: AccommodationType;
  starRating: number | null;
  priceTier: PriceTier | null;
  allInclusive: boolean | null;
  overwaterVillas: boolean | null;
  primaryLocation: LocationSummary | null;
  /** Null for the vast majority of accommodations — only entities the
   * Task 14 legacy media migration matched with real confidence have one.
   * Never a placeholder/stock image (see MediaImage). */
  heroImage: MediaAsset | null;
  /** The cheapest real room/villa rate found for this property (its own
   * legacy pricing, not a live rate) — shown on cards/listings as "From
   * $X". Never shown on the property's OWN detail page as a guaranteed
   * price; that page always says "Request an Offer" instead (prices go
   * stale, and legacy figures are marketing snapshots, not live rates).
   * Null when no room pricing was found. */
  priceFrom: number | null;
  priceFromCurrency: string | null;
}

/** One real room/villa type a property lists — deliberately lightweight
 * (name/price/bed/occupancy/photos only). The Phase 1 legacy-content audit
 * found the "Room Facilities" list under every room type on every
 * property, luxury and budget alike, to be byte-for-byte identical
 * boilerplate — not real per-room data — so this type has no facilities
 * field; inventing one would fabricate data the source never had. */
export interface AccommodationRoom {
  id: string;
  name: string;
  priceFrom: number | null;
  currency: string | null;
  bedType: string | null;
  maxOccupancy: number | null;
  images: MediaAsset[];
}

export interface AccommodationDetail extends AccommodationSummary {
  roomCount: number | null;
  checkInTime: string | null;
  checkOutTime: string | null;
  currency: string | null;
  metaTitle: string | null;
  metaDescription: string | null;
  provider: ProviderSummary | null;
  atoll: LocationSummary | null;
  isBookable: boolean;
  /** Bare YouTube video id (e.g. "CZGxcfCXJz0"), never a full URL — see
   * media/types.ts's youtubeId convention. Null when no real video was
   * found (most hotels/guesthouses; 109/110 resorts have one). */
  videoYoutubeId: string | null;
  rooms: AccommodationRoom[];
  /** Real legacy marketing description paragraphs (nodes.attributes.
   * overview_paragraphs) — verbatim source text, never rewritten. Empty
   * for the original 14 Task 5 accommodations, which predate this field. */
  overviewParagraphs: string[];
  /** Every gallery-role image attached to this property (role='gallery'
   * in node_media) — separate from heroImage. */
  galleryImages: MediaAsset[];
}

export interface PaginatedResult<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
}

export interface AccommodationFilters {
  type?: AccommodationType;
  atollId?: string;
  locationId?: string;
  priceTier?: PriceTier;
  starRating?: number;
  allInclusive?: boolean;
  overwaterVillas?: boolean;
}

/** URL path segment per accommodation type — the canonical routing rule
 * from docs/SYSTEM_ARCHITECTURE_AND_DATABASE_DESIGN.md §13/§19 (Rev 3). */
export const ACCOMMODATION_TYPE_SEGMENT: Record<AccommodationType, string> = {
  hotel: "hotels",
  resort: "resorts",
  guesthouse: "guesthouses",
  villa: "villas",
  // No real liveaboard inventory exists yet (the Phase 1 legacy audit
  // found zero real per-vessel content) — the segment/type exist so the
  // route is ready the moment real data does, but nothing seeds this
  // type or links to it this round.
  liveaboard: "liveaboards",
  other: "hotels", // no dedicated segment specified for "other"; grouped with hotels
};
