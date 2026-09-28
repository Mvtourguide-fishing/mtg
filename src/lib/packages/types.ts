import type { AccommodationSummary } from "@/lib/accommodations/types";
import type { ActivitySummary } from "@/lib/activities/types";
import type { CategorySummary } from "@/lib/categories/types";
import type { LocationSummary } from "@/lib/locations/types";
import type { ProviderSummary } from "@/lib/providers/types";
import type { TransferRouteSummary, TransferService } from "@/lib/transfers/types";

/**
 * A package is a `nodes` row (node_type = 'package') — the canonical,
 * SEO-indexable entity. Its itinerary is built from
 * `package_itinerary_stages` (a day RANGE, e.g. "Days 1-5 at Hotel A") each
 * holding `package_itinerary_items`, which REFERENCE existing entities
 * (an accommodation/activity node, or a Task 10 transfer_service) rather
 * than duplicating their data — see
 * supabase/migrations/20250101000700_packages.sql's own header comment.
 */

export type PackageItineraryComponentRole =
  | "accommodation"
  | "activity"
  | "transfer"
  | "meal"
  | "free_time"
  | "excursion"
  | "other";

export interface PackageItineraryItem {
  id: string;
  componentRole: PackageItineraryComponentRole;
  quantity: number;
  notes: string | null;
  sortOrder: number;
  /** At most one of these is set, depending on componentRole/what the item
   * actually references — never fabricated when nothing was linked. */
  accommodation: AccommodationSummary | null;
  activity: ActivitySummary | null;
  transferService: TransferService | null;
  transferRoute: TransferRouteSummary | null;
}

export interface PackageItineraryStage {
  id: string;
  stageNumber: number;
  dayStart: number;
  dayEnd: number;
  nightCount: number;
  title: string | null;
  description: string | null;
  sortOrder: number;
  items: PackageItineraryItem[];
}

export interface PackageSummary {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  durationNights: number | null;
  priceFrom: number | null;
  currency: string | null;
  provider: ProviderSummary | null;
  /** Every location this package touches, derived from its own
   * node_locations tags (set at seed time from the itinerary's real
   * referenced entities — see data/maldives/packages/SOURCES.md). */
  destinations: LocationSummary[];
}

export interface PackageDetail extends PackageSummary {
  metaTitle: string | null;
  metaDescription: string | null;
  isBookable: boolean;
  /** True when this package has no operator — an MTG-curated itinerary,
   * never falsely attributed to a third party (Task 11 §18). */
  isMtgCurated: boolean;
  stages: PackageItineraryStage[];
  travelerTypes: CategorySummary[];
  styles: CategorySummary[];
  durationBand: CategorySummary | null;
  themes: CategorySummary[];
  inclusions: CategorySummary[];
}

export interface GetPackagesOptions {
  page?: number;
  pageSize?: number;
  travelerType?: string;
  style?: string;
  theme?: string;
  durationBand?: string;
  inclusion?: string;
  atollId?: string;
  locationId?: string;
  /** Restrict to this exact set of node ids — used to compose a further
   * filter (e.g. "packages referencing accommodation X") on top of the
   * relational/taxonomy filters, same pattern as ActivityFilters.nodeIds. */
  nodeIds?: string[];
}

export interface PaginatedResult<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
}
