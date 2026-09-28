import type { LocationSummary } from "@/lib/locations/types";
import type { MediaAsset } from "@/lib/media/types";

/**
 * Physical dive sites are represented as `locations` rows
 * (location_type = 'dive_site', already supported by the architecture
 * since Task 3 — no schema change). Site-specific descriptive facts
 * (depth, current, marine life, experience level) live in `nodes.attributes`
 * JSONB, per the architecture's JSONB-boundaries rule (genuinely flexible,
 * category-specific descriptive attributes, not core relational data).
 * They are deliberately NOT `activities` — a site is a place, not a
 * commercial product (see docs/SYSTEM_ARCHITECTURE_AND_DATABASE_DESIGN.md
 * §10 and the Task 8 brief).
 */
export type DiveSiteType = "reef" | "thila" | "channel" | "wreck" | "pinnacle" | "wall" | "cave";

export interface DiveSiteSummary {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  siteType: DiveSiteType | null;
  heroImage: MediaAsset | null;
  atoll: LocationSummary | null;
}

export interface DiveSiteDetail extends DiveSiteSummary {
  nearbyIsland: LocationSummary | null;
  depthMinMeters: number | null;
  depthMaxMeters: number | null;
  experienceLevel: string | null;
  currentNotes: string | null;
  marineLifeNotes: string | null;
}

export interface GetDiveSitesOptions {
  page?: number;
  pageSize?: number;
  atollId?: string;
  siteType?: DiveSiteType;
}

export interface PaginatedResult<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
}
