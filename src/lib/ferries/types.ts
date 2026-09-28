import type { LocationSummary } from "@/lib/locations/types";
import type { MediaAsset } from "@/lib/media/types";

/**
 * Province ferry schedule — information only, no booking (Task 20 §25).
 * Not node-backed: these are read-only reference listings, not
 * individually-indexed SEO pages, and there is only one page
 * (/maldives-ferry-schedule/) that renders them.
 */

export interface FerryStop {
  island: string;
  arrival: string | null;
  departure: string | null;
}

export interface FerryRoute {
  id: string;
  routeNumber: string;
  variantLabel: string | null;
  title: string;
  province: string;
  operatingDays: string;
  origin: LocationSummary | null;
  destination: LocationSummary | null;
  stops: FerryStop[];
  notes: string | null;
  sourceLegacyUrl: string | null;
  /** A real image from the legacy site's own ferry schedule page — never
   * a generic stock substitute. Null for routes without one recovered. */
  heroImage: MediaAsset | null;
}
