// Domain types for the site-wide search layer (Task 13). Search does not
// own any data — every result is assembled from the existing per-vertical
// repositories (locations, accommodations, activities, transfers,
// packages) and normalized into one shape here.

/** The specific kind of thing a result represents — drives the filter
 * chips and the small type badge shown on each result. */
export type SearchResultType =
  | "atoll"
  | "island"
  | "dive_site"
  | "surf_break"
  | "country"
  | "resort"
  | "hotel"
  | "guesthouse"
  | "activity"
  | "fishing"
  | "diving"
  | "surfing"
  | "transfer"
  | "package"
  | "article"
  | "attraction";

/** The broader section a result is grouped under on the search page —
 * coarser than SearchResultType (e.g. atoll/island/dive_site/surf_break
 * all group under "destinations"). */
export type SearchGroupKey = "destinations" | "stay" | "things-to-do" | "attractions" | "transfers" | "packages" | "travel-guide";

export interface SearchResult {
  id: string;
  type: SearchResultType;
  group: SearchGroupKey;
  /** Label shown on the result's type badge, e.g. "Resort", "Fishing". */
  typeLabel: string;
  title: string;
  href: string;
  description: string | null;
  /** Short place/category context line, e.g. "Kaafu Atoll" or "Maldives". */
  context: string | null;
  /** Internal relevance score (Task 13 §9) — not rendered, used for sorting. */
  score: number;
}

export interface SearchResultGroup {
  key: SearchGroupKey;
  label: string;
  results: SearchResult[];
  /** True when more results likely exist beyond what's shown here (the
   * group hit its display cap) — drives the "View all" link. */
  hasMore: boolean;
}

/** Content-type filter values accepted by the search page's `type` query
 * param — a deliberately flat, hardcoded list (Task 13 §11): every value
 * here has real seeded data and a real route (confirmed against the
 * Task 4-11 seed data), so there is no "in use" query needed and no dead
 * filter chip. `article` was added in Task 14 once the Travel Guide
 * migration gave it real data; villas remain omitted (no villa-type
 * accommodation exists). */
export const SEARCH_FILTER_TYPES = [
  "location",
  "resort",
  "hotel",
  "guesthouse",
  "activity",
  "fishing",
  "diving",
  "surfing",
  "attraction",
  "transfer",
  "package",
  "article",
] as const;

export type SearchFilterType = (typeof SEARCH_FILTER_TYPES)[number];

export const SEARCH_FILTER_LABEL: Record<SearchFilterType, string> = {
  location: "Locations",
  resort: "Resorts",
  hotel: "Hotels",
  guesthouse: "Guesthouses",
  activity: "Activities",
  fishing: "Fishing",
  diving: "Diving",
  surfing: "Surfing",
  attraction: "Attractions",
  transfer: "Transfers",
  package: "Packages",
  article: "Travel Guide",
};

export interface SearchPageOptions {
  type?: SearchFilterType;
  page?: number;
  pageSize?: number;
}

export interface SearchPageResult {
  query: string;
  /** Populated when no `type` filter is active — a mixed, grouped view. */
  groups: SearchResultGroup[];
  /** Populated when a `type` filter is active — one flat, paginated list. */
  flat: {
    items: SearchResult[];
    total: number;
    page: number;
    pageSize: number;
  } | null;
  total: number;
}
