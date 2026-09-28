import type { LocationSummary } from "@/lib/locations/types";
import type { MediaAsset } from "@/lib/media/types";
import type { ProviderSummary } from "@/lib/providers/types";

/**
 * Transfer routes are `nodes` (node_type = 'transfer_route') — the
 * canonical, SEO-indexable, directional origin -> destination entity.
 * Transfer services are NOT nodes; they are the commercial offerings shown
 * on their route's page (a route can have several). This mirrors the
 * schema's own top-of-file comment in
 * supabase/migrations/20250101000600_transfers.sql exactly — see that file
 * for the authoritative shape. No new tables, no schema changes.
 */

export type TransferType = "speedboat" | "seaplane" | "domestic_flight" | "ferry" | "private_yacht" | "land_transfer";

export type SharedOrPrivate = "shared" | "private";

export type TransferServiceStatus = "active" | "seasonal" | "suspended" | "discontinued";

export interface TransferServiceSchedule {
  id: string;
  dayOfWeek: number | null;
  departureTime: string | null;
  arrivalTime: string | null;
  durationMinutes: number | null;
  effectiveFrom: string | null;
  effectiveTo: string | null;
  status: "active" | "inactive";
  sortOrder: number;
}

export interface TransferService {
  id: string;
  routeId: string;
  provider: ProviderSummary | null;
  transferType: TransferType;
  vehicleType: string | null;
  sharedOrPrivate: SharedOrPrivate;
  durationMinutes: number | null;
  price: number;
  currency: string;
  capacity: number | null;
  luggageAllowance: string | null;
  status: TransferServiceStatus;
  pickupInstructions: string | null;
  dropoffInstructions: string | null;
  bookingRequirements: string | null;
  cancellationPolicy: string | null;
  description: string | null;
  isBookable: boolean;
  /** Real, per-service attributes only (Task 20 §35) — never a generic
   * checklist. Empty for the great majority of services, which have no
   * sourced facility list. */
  facilities: string[];
  schedules: TransferServiceSchedule[];
}

export interface TransferRouteSummary {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  origin: LocationSummary | null;
  destination: LocationSummary | null;
  distanceKm: number | null;
  typicalDurationMinutes: number | null;
  /** Cheapest active service price on this route, for card display — null
   * when the route has no priced services (should not normally happen
   * given transfer_services.price is NOT NULL, but a route can exist with
   * zero services). */
  priceFrom: number | null;
  currency: string | null;
  /** The destination island's own real accommodation photo, when one is
   * already migrated and matched — never a generic stock image. Null for
   * most destinations (see attachDestinationHeroImages in the repository
   * for why that's the honest, expected outcome for most routes). */
  heroImage: MediaAsset | null;
  /** transfer-category slugs this route is tagged with (Task 20 §22:
   * airport / resort-transfer / hotel-transfer / island-transfer) —
   * derived from real data (origin is an airport, destination's
   * is_inhabited flag, a real hotel/guesthouse at the destination), never
   * mutually exclusive. */
  categories: string[];
}

export interface TransferRouteDetail extends TransferRouteSummary {
  metaTitle: string | null;
  metaDescription: string | null;
  services: TransferService[];
  /** True when this route can take a private-transfer inquiry (Task 20
   * §29) — every real route has this by default; only false if the route
   * somehow predates the bookable_products backfill. */
  isBookableForPrivateInquiry: boolean;
}

export interface GetTransferRoutesOptions {
  page?: number;
  pageSize?: number;
  originLocationId?: string;
  destinationLocationId?: string;
  /** Either endpoint (origin OR destination) at this location. */
  locationId?: string;
  atollId?: string;
  transferType?: TransferType;
  sharedOrPrivate?: SharedOrPrivate;
  /** transfer-category slug (Task 20 §22) — airport / resort-transfer /
   * hotel-transfer / island-transfer. */
  category?: string;
}

export interface PaginatedResult<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
}
