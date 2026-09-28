import type { AccommodationSummary } from "@/lib/accommodations/types";
import type { ActivitySummary } from "@/lib/activities/types";
import type { LocationSummary } from "@/lib/locations/types";
import type { MediaAsset } from "@/lib/media/types";
import type { ProviderSummary } from "@/lib/providers/types";

/**
 * Task 21: the unified read-model every package UI component renders,
 * whatever the underlying source. Two sources feed it:
 *   - REAL packages — real `nodes`/`packages`/`package_itinerary_*` rows
 *     (Task 11), mapped by realPackageToView() in ./view.ts. Only 6 exist
 *     right now (see data/maldives/packages/packages.json) — every field
 *     below is populated from genuine linked data, never invented.
 *   - DEMO packages — ./demo-packages.ts, plain TypeScript objects the
 *     owner explicitly asked for ("commercial inventory is not ready
 *     yet"), each grounded in a REAL accommodation/activity/island so its
 *     image, links, and destination are all genuine — only the package
 *     itself (its existence as a bookable product, its price, its
 *     itinerary) is demo content. `isDemo: true` on every one, checked
 *     everywhere a UI or structured-data decision depends on it (never
 *     show demo content as a real commercial offer — Task 21 §15/§38/§41).
 *
 * This file has zero Supabase/server-only code — both real and demo
 * mapping produce this same plain type so every component in
 * src/components/packages/ only ever needs to know about PackageView.
 */

export type PackagePriceType = "per-person" | "per-couple" | "per-package";

/** The 11 categories the owner asked for (Task 21 §6) — a package can
 * belong to several. Deliberately a flat string union rather than routing
 * every category through the DB traveler-type/theme split real packages
 * use internally: demo packages need to declare these directly, and a
 * package card/filter never needs to know which taxonomy group a tag
 * technically lives in. realPackageToView() maps DB category slugs onto
 * this same set. */
export type PackageCategorySlug =
  | "luxury"
  | "family"
  | "adults-only"
  | "long-stay"
  | "budget"
  | "honeymoon"
  | "solo"
  | "diving"
  | "fishing"
  | "surfing"
  | "liveaboard";

export interface PackageCategoryInfo {
  slug: PackageCategorySlug;
  title: string;
}

export const PACKAGE_CATEGORIES: PackageCategoryInfo[] = [
  { slug: "luxury", title: "Luxury Packages" },
  { slug: "family", title: "Family Packages" },
  { slug: "adults-only", title: "Adults Only Packages" },
  { slug: "long-stay", title: "Long Stay Packages" },
  { slug: "budget", title: "Budget Holiday Packages" },
  { slug: "honeymoon", title: "Honeymoon Packages" },
  { slug: "solo", title: "Solo Packages" },
  { slug: "diving", title: "Diving Packages" },
  { slug: "fishing", title: "Fishing Holiday Packages" },
  { slug: "surfing", title: "Surfing Packages" },
  { slug: "liveaboard", title: "Liveaboard Packages" },
];

export const PACKAGE_CATEGORY_TITLE: Record<PackageCategorySlug, string> = Object.fromEntries(
  PACKAGE_CATEGORIES.map((c) => [c.slug, c.title]),
) as Record<PackageCategorySlug, string>;

export type PackageDurationBandSlug = "1-3" | "4-5" | "6-7" | "8-10" | "11-14" | "15-plus";

export interface PackageDurationBand {
  slug: PackageDurationBandSlug;
  label: string;
  min: number;
  max: number | null;
}

export const PACKAGE_DURATION_BANDS: PackageDurationBand[] = [
  { slug: "1-3", label: "1–3 nights", min: 1, max: 3 },
  { slug: "4-5", label: "4–5 nights", min: 4, max: 5 },
  { slug: "6-7", label: "6–7 nights", min: 6, max: 7 },
  { slug: "8-10", label: "8–10 nights", min: 8, max: 10 },
  { slug: "11-14", label: "11–14 nights", min: 11, max: 14 },
  { slug: "15-plus", label: "15+ nights", min: 15, max: null },
];

export type PackageSortOption = "recommended" | "price-asc" | "price-desc" | "shortest" | "longest" | "rating" | "newest";

/** One normalized itinerary day/stage — both a real package's
 * multi-day `package_itinerary_stages` row and a demo package's
 * single-day entry map into this same shape, so there is exactly one
 * itinerary renderer (ItineraryList) for both. */
export interface PackageItineraryDayView {
  dayLabel: string;
  nightCount: number | null;
  title: string;
  description: string | null;
  links: Array<{ label: string; href: string }>;
}

export interface PackageLinkedActivity {
  activity: ActivitySummary;
  href: string;
}

export interface PackageLinkedAccommodation {
  accommodation: AccommodationSummary;
  href: string;
}

export interface PackageFaq {
  question: string;
  answer: string;
}

export interface PackageView {
  id: string;
  slug: string;
  title: string;
  shortDescription: string | null;
  description: string | null;

  categories: PackageCategorySlug[];

  destinations: LocationSummary[];
  /** The single real atoll this package is filed under for the location
   * filter — the first destination's own atoll (or the destination itself
   * when it IS an atoll). Null only when no destination resolves to a
   * real atoll. */
  atoll: LocationSummary | null;

  nights: number | null;
  days: number | null;

  price: number | null;
  currency: string | null;
  priceType: PackagePriceType | null;

  /** Demo packages only — never populated (and never rendered as
   * Review/AggregateRating structured data) for a real package, which has
   * no genuine review data yet (Task 21 §10/§38). */
  rating: number | null;
  ratingCount: number | null;

  heroImage: MediaAsset | null;
  images: MediaAsset[];
  /** A real YouTube video id for this specific package, when one exists —
   * null means no video section renders (Task 21 follow-up: the plumbing
   * exists so a real video can be wired in later, but nothing is
   * fabricated in the meantime). */
  youtubeId: string | null;

  highlights: string[];
  bestFor: string[];
  included: string[];
  excluded: string[];

  accommodationIncluded: boolean;
  transferIncluded: boolean | null;
  mealsIncluded: string | null;
  activityIncluded: boolean;
  flightIncluded: boolean;

  transferHref: string | null;
  transferLabel: string | null;
  activities: PackageLinkedActivity[];
  accommodations: PackageLinkedAccommodation[];

  itinerary: PackageItineraryDayView[];

  faqs: PackageFaq[];

  provider: ProviderSummary | null;
  isMtgCurated: boolean;
  isBookable: boolean;
  isDemo: boolean;

  createdAt: string | null;
}
