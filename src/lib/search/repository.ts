import "server-only";

import { getAccommodations, searchAccommodations } from "@/lib/accommodations/repository";
import { ACCOMMODATION_TYPE_SEGMENT, type AccommodationSummary, type AccommodationType } from "@/lib/accommodations/types";
import { getActivities, searchActivities } from "@/lib/activities/repository";
import { activityHref } from "@/lib/activities/types";
import type { ActivityCategory, ActivitySummary } from "@/lib/activities/types";
import { getArticlesRelatedToNodes, searchArticles } from "@/lib/articles/repository";
import { articleHref, type ArticleSummary } from "@/lib/articles/types";
import type { CategorySummary } from "@/lib/categories/types";
import { getLocationSummariesByIds, searchLocations } from "@/lib/locations/repository";
import type { LocationSummary, LocationType } from "@/lib/locations/types";
import {
  getPackageDurationBandsInUse,
  getPackageInclusionsInUse,
  getPackageStylesInUse,
  getPackageThemesInUse,
  getPackageTravelerTypesInUse,
  getPackages,
  searchPackages,
} from "@/lib/packages/repository";
import type { PackageSummary } from "@/lib/packages/types";
import {
  EXPANSION_MATCH_SCORE,
  expandKnownPlaceNames,
  normalizeQuery,
  scoreTitleMatch,
  tokenize,
  tokensAllPresent,
} from "@/lib/search/normalize";
import type {
  SearchFilterType,
  SearchGroupKey,
  SearchPageOptions,
  SearchPageResult,
  SearchResult,
  SearchResultGroup,
  SearchResultType,
} from "@/lib/search/types";
import { getTransferRoutes, searchTransferRoutes } from "@/lib/transfers/repository";
import type { TransferRouteSummary, TransferType } from "@/lib/transfers/types";

/**
 * Site-wide search (Task 13). This module owns no data of its own — every
 * result is produced by the same repository functions every directory
 * page already calls (searchLocations, searchAccommodations, ...), just
 * normalized into one SearchResult shape and merged. No new PostgREST
 * embeds are introduced here, so the `categories`/`locations` ambiguity
 * fixed in commit 06a9254 can't regress through this module.
 */

// ── URL / label helpers ─────────────────────────────────────────────────

const LOCATION_TYPE_LABEL: Partial<Record<LocationType, string>> = {
  country: "Maldives",
  atoll: "Atoll",
  island: "Island",
  dive_site: "Dive Site",
  surf_break: "Surf Break",
  poi: "Attraction",
};

/** Only location types with a real, independent detail page get a result
 * — never a fake/temporary URL (Task 13 §21). Airports, localities, and
 * other supporting location rows are reachable through the entities that
 * reference them (transfers, accommodation) but aren't independently
 * browsable, so they're intentionally excluded here. */
function locationHref(loc: { locationType: LocationType; slug: string }): string | null {
  switch (loc.locationType) {
    case "country":
      return "/maldives/";
    case "atoll":
      return `/maldives/atolls/${loc.slug}/`;
    case "island":
      return `/maldives/islands/${loc.slug}/`;
    case "dive_site":
      return `/maldives/dive-sites/${loc.slug}/`;
    case "surf_break":
      return `/maldives/surf-breaks/${loc.slug}/`;
    case "poi":
      return `/maldives/attractions/${loc.slug}/`;
    default:
      return null;
  }
}

function locationResultType(locationType: LocationType): SearchResultType | null {
  switch (locationType) {
    case "country":
      return "country";
    case "atoll":
      return "atoll";
    case "island":
      return "island";
    case "dive_site":
      return "dive_site";
    case "surf_break":
      return "surf_break";
    case "poi":
      return "attraction";
    default:
      return null;
  }
}

/** "other" shares the /hotels/ segment with `hotel` (see
 * ACCOMMODATION_TYPE_SEGMENT) — same convention as the rest of the site.
 * `villa` has no route yet (no villa-type accommodation exists either),
 * so it intentionally yields no result rather than a fake URL. */
function accommodationResultType(type: AccommodationType): SearchResultType | null {
  if (type === "resort") return "resort";
  if (type === "hotel" || type === "other") return "hotel";
  if (type === "guesthouse") return "guesthouse";
  return null;
}

function accommodationHref(type: AccommodationType, slug: string): string {
  return `/maldives/${ACCOMMODATION_TYPE_SEGMENT[type]}/${slug}/`;
}

const ACCOMMODATION_TYPE_LABEL: Record<AccommodationType, string> = {
  hotel: "Hotel",
  resort: "Resort",
  guesthouse: "Guesthouse",
  villa: "Villa",
  liveaboard: "Liveaboard",
  other: "Accommodation",
};

function activityResultType(category: ActivityCategory): SearchResultType {
  if (category === "fishing") return "fishing";
  if (category === "diving") return "diving";
  if (category === "surfing") return "surfing";
  return "activity";
}

const ACTIVITY_TYPE_LABEL: Record<ActivityCategory, string> = {
  general: "Activity",
  fishing: "Fishing",
  diving: "Diving",
  surfing: "Surfing",
  watersports: "Activity",
  excursion: "Activity",
  island_hopping: "Activity",
  spa: "Activity",
  culture: "Activity",
};

// ── Batched context resolution (avoids N+1 atoll lookups) ──────────────

async function resolveAtollContext(parentIds: Array<string | null | undefined>): Promise<Map<string, LocationSummary>> {
  const ids = Array.from(new Set(parentIds.filter((id): id is string => Boolean(id))));
  return getLocationSummariesByIds(ids);
}

function contextFor(location: LocationSummary | null, atollByParentId: Map<string, LocationSummary>): string | null {
  if (!location) return null;
  if (location.parentId) return atollByParentId.get(location.parentId)?.title ?? location.title;
  return location.title;
}

// ── Result mappers ──────────────────────────────────────────────────────

function mapLocation(loc: LocationSummary, atollByParentId: Map<string, LocationSummary>, score: number): SearchResult | null {
  const href = locationHref(loc);
  const type = locationResultType(loc.locationType);
  if (!href || !type) return null;

  const context = loc.locationType === "atoll" ? "Maldives" : loc.parentId ? (atollByParentId.get(loc.parentId)?.title ?? null) : null;

  return {
    id: loc.id,
    type,
    // Attractions (location_type = 'poi') get their own "attractions"
    // group rather than "destinations" — Task 15 §21 asks for Activities
    // ("what can I DO?") and Attractions ("what can I SEE?") to stay
    // visually distinct, including in search results, not lumped in with
    // atolls/islands/dive sites.
    group: loc.locationType === "poi" ? "attractions" : "destinations",
    typeLabel: LOCATION_TYPE_LABEL[loc.locationType] ?? "Location",
    title: loc.title,
    href,
    description: loc.summary,
    context,
    score,
  };
}

function mapAccommodation(a: AccommodationSummary, atollByParentId: Map<string, LocationSummary>, score: number): SearchResult | null {
  const type = accommodationResultType(a.accommodationType);
  if (!type) return null;

  return {
    id: a.id,
    type,
    group: "stay",
    typeLabel: ACCOMMODATION_TYPE_LABEL[a.accommodationType],
    title: a.title,
    href: accommodationHref(a.accommodationType, a.slug),
    description: a.summary,
    context: contextFor(a.primaryLocation, atollByParentId),
    score,
  };
}

function mapActivity(a: ActivitySummary, atollByParentId: Map<string, LocationSummary>, score: number): SearchResult {
  return {
    id: a.id,
    type: activityResultType(a.activityCategory),
    group: "things-to-do",
    typeLabel: ACTIVITY_TYPE_LABEL[a.activityCategory],
    title: a.title,
    href: activityHref(a),
    description: a.summary,
    context: contextFor(a.primaryLocation, atollByParentId),
    score,
  };
}

function mapTransferRoute(r: TransferRouteSummary, score: number): SearchResult {
  return {
    id: r.id,
    type: "transfer",
    group: "transfers",
    typeLabel: "Transfer",
    title: r.title,
    href: `/maldives/transfers/${r.slug}/`,
    description: r.summary,
    context: r.origin && r.destination ? `${r.origin.title} → ${r.destination.title}` : null,
    score,
  };
}

function mapArticle(a: ArticleSummary, score: number): SearchResult {
  return {
    id: a.id,
    type: "article",
    group: "travel-guide",
    typeLabel: a.category?.title ?? "Travel Guide",
    title: a.title,
    href: articleHref(a),
    description: a.summary,
    context: null,
    score,
  };
}

function mapPackage(p: PackageSummary, score: number): SearchResult {
  return {
    id: p.id,
    type: "package",
    group: "packages",
    typeLabel: "Package",
    title: p.title,
    href: `/maldives/packages/${p.slug}/`,
    description: p.summary,
    context: p.destinations[0]?.title ?? null,
    score,
  };
}

// ── Dedupe + stable ordering ────────────────────────────────────────────

function dedupe(results: SearchResult[]): SearchResult[] {
  const best = new Map<string, SearchResult>();
  for (const r of results) {
    const key = `${r.type}:${r.id}`;
    const existing = best.get(key);
    if (!existing || r.score > existing.score) best.set(key, r);
  }
  return Array.from(best.values()).sort((a, b) => b.score - a.score || a.title.localeCompare(b.title) || a.id.localeCompare(b.id));
}

// ── Base title search (parallel, one call per vertical) ────────────────

async function baseSearch(query: string, perSourceLimit: number) {
  const [locations, accommodations, activities, transferRoutes, packages, articles] = await Promise.all([
    searchLocations(query, { limit: perSourceLimit }),
    searchAccommodations(query, { limit: perSourceLimit }),
    searchActivities(query, { limit: perSourceLimit }),
    searchTransferRoutes(query, { limit: perSourceLimit }),
    searchPackages(query, { limit: perSourceLimit }),
    searchArticles(query, { limit: perSourceLimit }),
  ]);
  return { locations, accommodations, activities, transferRoutes, packages, articles };
}

async function mapBaseResults(
  base: Awaited<ReturnType<typeof baseSearch>>,
  query: string,
): Promise<SearchResult[]> {
  const atollByParentId = await resolveAtollContext([
    ...base.locations.map((l) => l.parentId),
    ...base.accommodations.map((a) => a.primaryLocation?.parentId),
    ...base.activities.map((a) => a.primaryLocation?.parentId),
  ]);

  const results: SearchResult[] = [];
  for (const loc of base.locations) {
    const mapped = mapLocation(loc, atollByParentId, scoreTitleMatch(loc.title, query));
    if (mapped) results.push(mapped);
  }
  for (const a of base.accommodations) {
    const mapped = mapAccommodation(a, atollByParentId, scoreTitleMatch(a.title, query));
    if (mapped) results.push(mapped);
  }
  for (const a of base.activities) {
    results.push(mapActivity(a, atollByParentId, scoreTitleMatch(a.title, query)));
  }
  for (const r of base.transferRoutes) {
    results.push(mapTransferRoute(r, scoreTitleMatch(r.title, query)));
  }
  for (const p of base.packages) {
    results.push(mapPackage(p, scoreTitleMatch(p.title, query)));
  }
  for (const a of base.articles) {
    results.push(mapArticle(a, scoreTitleMatch(a.title, query)));
  }
  return results;
}

// ── Related-article expansion (search-page only, not autocomplete) ─────
// A query that matches a real entity by title (e.g. "Baros Maldives")
// should also surface an article that genuinely discusses it, even when
// the query never appears in that article's own title. Reuses the exact
// node_relationships/node_locations rows Task 15 §41-42 persists from the
// article's own side (see getArticlesRelatedToNodes) — no separate index,
// no full-text search, just one more real relationship already on hand.

async function expandArticlesByRelatedEntity(base: Awaited<ReturnType<typeof baseSearch>>, limit: number): Promise<SearchResult[]> {
  const nodeIds = [
    ...base.locations.map((l) => l.id),
    ...base.accommodations.map((a) => a.id),
    ...base.activities.map((a) => a.id),
    ...base.transferRoutes.map((r) => r.id),
    ...base.packages.map((p) => p.id),
  ];
  if (nodeIds.length === 0) return [];
  const articles = await getArticlesRelatedToNodes(nodeIds);
  return articles.slice(0, limit).map((a) => mapArticle(a, EXPANSION_MATCH_SCORE));
}

// ── Keyword-driven expansion (search-page only, not autocomplete) ──────
// Handles combined queries a single title ILIKE can't express, e.g.
// "resort dhaalu" or "guesthouse thulusdhoo" — a type keyword plus a
// location name. Reuses each vertical's own filtered listing function
// (getAccommodations/getActivities/getTransferRoutes), never a bespoke
// query. Bounded to a handful of extra requests per search-page load.

const ACCOMMODATION_TYPE_KEYWORDS: Record<string, AccommodationType> = {
  resort: "resort",
  resorts: "resort",
  hotel: "hotel",
  hotels: "hotel",
  guesthouse: "guesthouse",
  guesthouses: "guesthouse",
};

const ACTIVITY_CATEGORY_KEYWORDS: Record<string, ActivityCategory> = {
  diving: "diving",
  dive: "diving",
  scuba: "diving",
  fishing: "fishing",
  fish: "fishing",
  surfing: "surfing",
  surf: "surfing",
};

const TRANSFER_TYPE_KEYWORDS: Record<string, TransferType> = {
  speedboat: "speedboat",
  speedboats: "speedboat",
  ferry: "ferry",
  ferries: "ferry",
  seaplane: "seaplane",
  seaplanes: "seaplane",
  yacht: "private_yacht",
};

async function expandByKeyword(tokens: string[], limit: number): Promise<SearchResult[]> {
  if (tokens.length === 0) return [];
  const [first, ...rest] = tokens;
  const restQuery = rest.join(" ");
  const results: SearchResult[] = [];

  const accType = ACCOMMODATION_TYPE_KEYWORDS[first];
  const activityCategory = ACTIVITY_CATEGORY_KEYWORDS[first];
  const transferType = TRANSFER_TYPE_KEYWORDS[first];

  if (!accType && !activityCategory && !transferType) return [];

  const matchedLocations = restQuery ? await searchLocations(restQuery, { limit: 3 }) : [];
  const atollByParentId = await resolveAtollContext(matchedLocations.map((l) => l.parentId));

  if (accType && (matchedLocations.length > 0 || !restQuery)) {
    const pages =
      matchedLocations.length > 0
        ? await Promise.all(
            matchedLocations.map((loc) =>
              getAccommodations({
                type: accType,
                atollId: loc.locationType === "atoll" ? loc.id : undefined,
                locationId: loc.locationType === "atoll" ? undefined : loc.id,
                pageSize: limit,
              }),
            ),
          )
        : [await getAccommodations({ type: accType, pageSize: limit })];
    for (const page of pages) {
      for (const a of page.items) {
        const mapped = mapAccommodation(a, atollByParentId, EXPANSION_MATCH_SCORE);
        if (mapped) results.push(mapped);
      }
    }
  }

  if (activityCategory && (matchedLocations.length > 0 || !restQuery)) {
    const pages =
      matchedLocations.length > 0
        ? await Promise.all(
            matchedLocations.map((loc) =>
              getActivities({
                category: activityCategory,
                atollId: loc.locationType === "atoll" ? loc.id : undefined,
                locationId: loc.locationType === "atoll" ? undefined : loc.id,
                pageSize: limit,
              }),
            ),
          )
        : [await getActivities({ category: activityCategory, pageSize: limit })];
    for (const page of pages) {
      for (const a of page.items) results.push(mapActivity(a, atollByParentId, EXPANSION_MATCH_SCORE));
    }
  }

  if (transferType) {
    const page = await getTransferRoutes({ transferType, pageSize: limit });
    for (const r of page.items) results.push(mapTransferRoute(r, EXPANSION_MATCH_SCORE));
  }

  return results;
}

// Package taxonomy keyword expansion: "honeymoon", "resort", "diving",
// "5 nights", etc. resolved against the package taxonomy actually in use
// (Task 11) rather than a hardcoded list — reuses the same
// getPackage*InUse() wrappers the packages directory filter chips use.
async function expandPackagesByTaxonomy(tokens: string[], limit: number): Promise<SearchResult[]> {
  if (tokens.length === 0) return [];

  const [travelerTypes, styles, themes, durationBands, inclusions] = await Promise.all([
    getPackageTravelerTypesInUse(),
    getPackageStylesInUse(),
    getPackageThemesInUse(),
    getPackageDurationBandsInUse(),
    getPackageInclusionsInUse(),
  ]);

  const groups: Array<{ key: "travelerType" | "style" | "theme" | "durationBand" | "inclusion"; categories: CategorySummary[] }> = [
    { key: "travelerType", categories: travelerTypes },
    { key: "style", categories: styles },
    { key: "theme", categories: themes },
    { key: "durationBand", categories: durationBands },
    { key: "inclusion", categories: inclusions },
  ];

  async function fetchFor(key: (typeof groups)[number]["key"], slug: string) {
    switch (key) {
      case "travelerType":
        return getPackages({ travelerType: slug, pageSize: limit });
      case "style":
        return getPackages({ style: slug, pageSize: limit });
      case "theme":
        return getPackages({ theme: slug, pageSize: limit });
      case "durationBand":
        return getPackages({ durationBand: slug, pageSize: limit });
      case "inclusion":
        return getPackages({ inclusion: slug, pageSize: limit });
    }
  }

  // Collect every matched (group, slug) pair first, then fetch them all
  // concurrently — a multi-word query matching several taxonomy groups
  // (e.g. "honeymoon diving 5 nights") previously issued one `await`ed
  // getPackages() call per match, serially, inside this nested loop.
  const matched = new Map<string, { key: (typeof groups)[number]["key"]; slug: string }>();
  for (const token of tokens) {
    for (const group of groups) {
      const match = group.categories.find((c) => c.title.toLowerCase() === token || c.slug === token);
      if (!match) continue;
      matched.set(`${group.key}:${match.slug}`, { key: group.key, slug: match.slug });
    }
  }

  const pages = await Promise.all(Array.from(matched.values()).map((m) => fetchFor(m.key, m.slug)));
  const results: SearchResult[] = [];
  for (const page of pages) {
    for (const p of page.items) results.push(mapPackage(p, EXPANSION_MATCH_SCORE));
  }
  return results;
}

function pickAnchorToken(tokens: string[]): string {
  return tokens.reduce((longest, token) => (token.length > longest.length ? token : longest), tokens[0]);
}

/**
 * Multi-word queries whose words don't appear contiguously and in order
 * in the real title (e.g. "airport maafushi" against "Velana
 * International Airport to Maafushi") would never match a single ILIKE
 * '%airport maafushi%' pattern. This broadens the fetch using just the
 * longest (most selective) token via the exact same searchX functions,
 * then keeps only the rows where every token is present somewhere in the
 * title (accent-folded — see tokensAllPresent). Only runs on the actual
 * search-results page, not autocomplete, to keep keystroke latency low.
 */
async function multiTokenFallback(query: string, tokens: string[], perSourceLimit: number): Promise<SearchResult[]> {
  if (tokens.length < 2) return [];
  const anchor = pickAnchorToken(tokens);
  const anchorBase = await baseSearch(anchor, perSourceLimit * 4);
  const anchorMapped = await mapBaseResults(anchorBase, query);
  return anchorMapped.filter((r) => tokensAllPresent(r.title, tokens));
}

async function gatherCandidates(query: string, perSourceLimit: number): Promise<SearchResult[]> {
  const tokens = tokenize(query);
  const [base, multiToken, expansion, packageExpansion] = await Promise.all([
    baseSearch(query, perSourceLimit),
    multiTokenFallback(query, tokens, perSourceLimit),
    expandByKeyword(tokens, perSourceLimit),
    expandPackagesByTaxonomy(tokens, perSourceLimit),
  ]);
  const [baseResults, relatedArticles] = await Promise.all([
    mapBaseResults(base, query),
    expandArticlesByRelatedEntity(base, perSourceLimit),
  ]);
  return dedupe([...baseResults, ...multiToken, ...expansion, ...packageExpansion, ...relatedArticles]);
}

// ── Type-filtered flat results (the search page's single-type view) ────

async function fetchFlatResults(type: SearchFilterType, query: string, cap = 60): Promise<SearchResult[]> {
  const tokens = tokenize(query);
  // Same multi-word/accent fallback as the grouped view (Task 13 §8) —
  // computed once and filtered to this branch's result type(s) below.
  const multiToken = tokens.length > 1 ? await multiTokenFallback(query, tokens, cap) : [];

  switch (type) {
    case "location": {
      // Attractions (location_type = 'poi') have their own filter/group
      // below — excluded here so the "Locations" chip stays atolls/
      // islands/dive sites/surf breaks only (Task 15 §21).
      const items = (await searchLocations(query, { limit: cap })).filter((l) => l.locationType !== "poi");
      const atollByParentId = await resolveAtollContext(items.map((l) => l.parentId));
      const mapped = items
        .map((l) => mapLocation(l, atollByParentId, scoreTitleMatch(l.title, query)))
        .filter((r): r is SearchResult => r !== null);
      const fallback = multiToken.filter((r) => ["country", "atoll", "island", "dive_site", "surf_break"].includes(r.type));
      return dedupe([...mapped, ...fallback]);
    }
    case "attraction": {
      const items = (await searchLocations(query, { limit: cap })).filter((l) => l.locationType === "poi");
      const atollByParentId = await resolveAtollContext(items.map((l) => l.parentId));
      const mapped = items
        .map((l) => mapLocation(l, atollByParentId, scoreTitleMatch(l.title, query)))
        .filter((r): r is SearchResult => r !== null);
      const fallback = multiToken.filter((r) => r.type === "attraction");
      return dedupe([...mapped, ...fallback]);
    }
    case "resort":
    case "hotel":
    case "guesthouse": {
      const items = (await searchAccommodations(query, { limit: cap })).filter((a) => a.accommodationType === type);
      const atollByParentId = await resolveAtollContext(items.map((a) => a.primaryLocation?.parentId));
      const mapped = items
        .map((a) => mapAccommodation(a, atollByParentId, scoreTitleMatch(a.title, query)))
        .filter((r): r is SearchResult => r !== null);
      const fallback = multiToken.filter((r) => r.type === type);
      return dedupe([...mapped, ...fallback]);
    }
    case "activity":
    case "fishing":
    case "diving":
    case "surfing": {
      const items = await searchActivities(query, { limit: cap });
      const filtered =
        type === "activity"
          ? items.filter((a) => !["fishing", "diving", "surfing"].includes(a.activityCategory))
          : items.filter((a) => a.activityCategory === type);
      const atollByParentId = await resolveAtollContext(filtered.map((a) => a.primaryLocation?.parentId));
      const mapped = filtered.map((a) => mapActivity(a, atollByParentId, scoreTitleMatch(a.title, query)));
      const fallback = multiToken.filter((r) => r.type === type);
      return dedupe([...mapped, ...fallback]);
    }
    case "transfer": {
      const items = await searchTransferRoutes(query, { limit: cap });
      const mapped = items.map((r) => mapTransferRoute(r, scoreTitleMatch(r.title, query)));
      const fallback = multiToken.filter((r) => r.type === "transfer");
      return dedupe([...mapped, ...fallback]);
    }
    case "package": {
      const items = await searchPackages(query, { limit: cap });
      const taxonomyExpansion = await expandPackagesByTaxonomy(tokens, cap);
      const fallback = multiToken.filter((r) => r.type === "package");
      return dedupe([...items.map((p) => mapPackage(p, scoreTitleMatch(p.title, query))), ...taxonomyExpansion, ...fallback]);
    }
    case "article": {
      const [items, entityBase] = await Promise.all([searchArticles(query, { limit: cap }), baseSearch(query, cap)]);
      const relatedArticles = await expandArticlesByRelatedEntity(entityBase, cap);
      const fallback = multiToken.filter((r) => r.type === "article");
      return dedupe([...items.map((a) => mapArticle(a, scoreTitleMatch(a.title, query))), ...relatedArticles, ...fallback]);
    }
    default:
      return [];
  }
}

// ── Public API ───────────────────────────────────────────────────────────

const GROUP_LABEL: Record<SearchGroupKey, string> = {
  destinations: "Destinations",
  stay: "Places to Stay",
  "things-to-do": "Things to Do",
  attractions: "Attractions",
  transfers: "Transfers",
  packages: "Packages",
  "travel-guide": "Travel Guide",
};

const GROUP_ORDER: SearchGroupKey[] = ["destinations", "stay", "things-to-do", "attractions", "transfers", "packages", "travel-guide"];
const GROUP_CAP = 6;

/** The full search-results page: either a mixed, grouped view (no `type`
 * filter) or one flat, paginated list (a `type` filter is active). */
export async function searchSite(rawQuery: string, options: SearchPageOptions = {}): Promise<SearchPageResult> {
  const normalized = normalizeQuery(rawQuery);
  if (!normalized) return { query: "", groups: [], flat: null, total: 0 };
  const query = expandKnownPlaceNames(normalized);

  if (options.type) {
    const page = Math.max(1, options.page ?? 1);
    const pageSize = Math.min(48, Math.max(1, options.pageSize ?? 12));
    const all = await fetchFlatResults(options.type, query);
    const start = (page - 1) * pageSize;
    const items = all.slice(start, start + pageSize);
    return { query, groups: [], flat: { items, total: all.length, page, pageSize }, total: all.length };
  }

  const candidates = await gatherCandidates(query, GROUP_CAP + 2);
  const groups: SearchResultGroup[] = [];
  for (const key of GROUP_ORDER) {
    const inGroup = candidates.filter((r) => r.group === key);
    if (inGroup.length === 0) continue;
    groups.push({
      key,
      label: GROUP_LABEL[key],
      results: inGroup.slice(0, GROUP_CAP),
      hasMore: inGroup.length > GROUP_CAP,
    });
  }

  return { query, groups, flat: null, total: candidates.length };
}

/** Lightweight autocomplete for the header search box — base title
 * search only (no keyword expansion), small per-source limits, so a
 * single debounced keystroke costs a fixed ~6 queries regardless of
 * what's typed. */
export async function suggestSite(rawQuery: string, limit = 8): Promise<SearchResult[]> {
  const normalized = normalizeQuery(rawQuery);
  if (normalized.length < 2) return [];
  const query = expandKnownPlaceNames(normalized);

  const base = await baseSearch(query, 4);
  const results = await mapBaseResults(base, query);
  return dedupe(results).slice(0, limit);
}
