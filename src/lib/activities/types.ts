import type { LocationSummary } from "@/lib/locations/types";
import type { MediaAsset } from "@/lib/media/types";
import type { ProviderSummary } from "@/lib/providers/types";
import { canonicalUrl } from "@/lib/seo/site";

export type ActivityCategory =
  | "general"
  | "fishing"
  | "diving"
  | "surfing"
  | "watersports"
  | "excursion"
  | "island_hopping"
  | "spa"
  | "culture";

export type ActivityDifficulty = "beginner" | "intermediate" | "advanced" | "all_levels";

export interface ActivitySummary {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  activityCategory: ActivityCategory;
  durationMinutes: number | null;
  difficulty: ActivityDifficulty | null;
  priceFrom: number | null;
  currency: string | null;
  primaryLocation: LocationSummary | null;
  heroImage: MediaAsset | null;
}

export interface ActivityDetail extends ActivitySummary {
  minAge: number | null;
  maxParticipants: number | null;
  metaTitle: string | null;
  metaDescription: string | null;
  provider: ProviderSummary | null;
  atoll: LocationSummary | null;
  isBookable: boolean;
  gallery: MediaAsset[];
}

export interface PaginatedResult<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
}

export interface ActivityFilters {
  category?: ActivityCategory;
  atollId?: string;
  locationId?: string;
  providerId?: string;
  difficulty?: ActivityDifficulty;
  minDurationMinutes?: number;
  maxDurationMinutes?: number;
  minAge?: number;
  maxPriceFrom?: number;
  maxParticipants?: number;
  /** Restrict results to this exact set of node ids — used to compose a
   * further filter (e.g. "tagged with fishing type X" via node_categories)
   * on top of the relational filters above, without duplicating query
   * logic in a specialized-vertical repository. Added in Task 7. */
  nodeIds?: string[];
}

/**
 * URL segment each activity category resolves to. Categories with their
 * own dedicated vertical (fishing since Task 7, diving since Task 8,
 * surfing since Task 9) map to their own segment — that is their one
 * canonical location, per
 * docs/SYSTEM_ARCHITECTURE_AND_DATABASE_DESIGN.md §13/§19. Every other
 * category falls back to the shared /maldives/activities/ directory
 * established in Task 6.
 */
export const ACTIVITY_CATEGORY_SEGMENT: Partial<Record<ActivityCategory, string>> = {
  fishing: "fishing",
  diving: "diving",
  surfing: "surfing",
};

export function activityDirectorySegment(category: ActivityCategory): string {
  return ACTIVITY_CATEGORY_SEGMENT[category] ?? "activities";
}

export function activityHref(activity: { activityCategory: ActivityCategory; slug: string }): string {
  return `/maldives/${activityDirectorySegment(activity.activityCategory)}/${activity.slug}/`;
}

/** True when `category` has moved to its own dedicated vertical route and
 * should no longer be independently reachable at /maldives/activities/. */
export function hasDedicatedRoute(category: ActivityCategory): boolean {
  return category in ACTIVITY_CATEGORY_SEGMENT;
}

/**
 * Shared `Service`/`Offer` structured data for any activity detail page
 * (generic /maldives/activities/, and the fishing/diving/surfing dedicated
 * verticals) — one implementation instead of four near-duplicates. Offer
 * pricing is included only when `priceFrom` is a real configured price
 * (Task 15 §48/§27: never a fabricated $0 placeholder); activities without
 * one still get the base Service entry, just no `offers`.
 */
export function activityServiceJsonLd(activity: ActivityDetail) {
  const url = canonicalUrl(activityHref(activity));
  const base = {
    "@context": "https://schema.org",
    "@type": "Service",
    name: activity.title,
    description: activity.summary ?? undefined,
    url,
    image: activity.heroImage ? [activity.heroImage.storagePath] : undefined,
    areaServed: activity.primaryLocation?.title ?? "Maldives",
    provider: activity.provider ? { "@type": "Organization", name: activity.provider.title } : undefined,
  };

  if (activity.priceFrom === null) return base;

  return {
    ...base,
    offers: {
      "@type": "Offer",
      price: activity.priceFrom,
      priceCurrency: activity.currency ?? "USD",
      availability: "https://schema.org/InStock",
      url,
    },
  };
}
