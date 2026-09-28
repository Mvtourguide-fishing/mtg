import type { LocationSummary } from "@/lib/locations/types";
import type { MediaAsset } from "@/lib/media/types";

/**
 * Physical surf breaks are represented as `locations` rows
 * (location_type = 'surf_break', already supported by the architecture
 * since Task 3 — no schema change). Break-specific descriptive facts
 * (wave characteristics, season, access) live in `nodes.attributes` JSONB,
 * per the architecture's JSONB-boundaries rule (genuinely flexible,
 * category-specific descriptive attributes, not core relational data).
 * They are deliberately NOT `activities` — a break is a place, not a
 * commercial product (see docs/SYSTEM_ARCHITECTURE_AND_DATABASE_DESIGN.md
 * §10 and the Task 8/9 briefs).
 */
export type SurfBreakType = "reef_break" | "point_break" | "beach_break" | "channel";

export interface SurfBreakSummary {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  breakType: SurfBreakType | null;
  heroImage: MediaAsset | null;
  atoll: LocationSummary | null;
}

export interface SurfBreakDetail extends SurfBreakSummary {
  nearbyIsland: LocationSummary | null;
  difficulty: string | null;
  waveNotes: string | null;
  seasonNotes: string | null;
  accessNotes: string | null;
}

export interface GetSurfBreaksOptions {
  page?: number;
  pageSize?: number;
  atollId?: string;
  breakType?: SurfBreakType;
}

export interface PaginatedResult<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
}
