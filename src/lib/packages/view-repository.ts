import "server-only";

import { getLocationSummaryById } from "@/lib/locations/repository";
import type { LocationSummary } from "@/lib/locations/types";
import {
  getPackageBySlug,
  getPackages,
  getPackagesByAccommodation,
  getPackagesByActivity,
  getPackagesByTransferRoute,
} from "@/lib/packages/repository";
import type { PackageSummary } from "@/lib/packages/types";
import { getDemoPackageViewBySlug, getDemoPackageViews, getDemoPackagesReferencingNode } from "@/lib/packages/demo";
import { realPackageToView, withAtoll } from "@/lib/packages/view";
import type { PackageCategorySlug, PackageDurationBandSlug, PackageSortOption, PackageView } from "@/lib/packages/view-types";
import { PACKAGE_DURATION_BANDS } from "@/lib/packages/view-types";

/**
 * Task 21: the single place every package UI page reads from. Merges
 * real DB packages (Task 11 — only 6 exist right now) with the demo
 * inventory (demo.ts) into one PackageView[] list, then applies
 * search/filter/sort entirely in application code — deliberately not a
 * SQL query, since half the dataset (demo packages) has no DB rows to
 * query against. At this project's real scale (a few dozen packages
 * total, ever, until real commercial inventory grows far beyond what a
 * curated travel guide would list), doing this in memory is simpler and
 * just as fast as a database round trip, and it's the only way to filter
 * both sources uniformly.
 */

async function resolveAtollForDestinations(destinations: LocationSummary[]): Promise<LocationSummary | null> {
  const first = destinations[0];
  if (!first) return null;
  if (first.locationType === "atoll") return first;
  if (first.parentId) return getLocationSummaryById(first.parentId);
  return null;
}

let cachedRealViews: Promise<PackageView[]> | null = null;

async function getAllRealPackageViews(): Promise<PackageView[]> {
  if (!cachedRealViews) {
    cachedRealViews = (async () => {
      const summaries = await getPackages({ pageSize: 100 });
      const details = await Promise.all(summaries.items.map((s) => getPackageBySlug(s.slug)));
      const views = await Promise.all(
        details
          .filter((d): d is NonNullable<typeof d> => d !== null)
          .map(async (detail) => {
            const view = realPackageToView(detail);
            const atoll = await resolveAtollForDestinations(view.destinations);
            return withAtoll(view, atoll);
          }),
      );
      return views;
    })();
  }
  return cachedRealViews;
}

export async function getAllPackageViews(): Promise<PackageView[]> {
  const [real, demo] = await Promise.all([getAllRealPackageViews(), getDemoPackageViews()]);
  return [...real, ...demo];
}

export async function getPackageViewBySlug(slug: string): Promise<PackageView | null> {
  const real = await getPackageBySlug(slug);
  if (real) {
    const view = realPackageToView(real);
    const atoll = await resolveAtollForDestinations(view.destinations);
    return withAtoll(view, atoll);
  }
  return getDemoPackageViewBySlug(slug);
}

export interface PackageViewFilters {
  q?: string;
  category?: PackageCategorySlug;
  atollSlug?: string;
  duration?: PackageDurationBandSlug;
  minPrice?: number;
  maxPrice?: number;
  minRating?: number;
}

function matchesQuery(view: PackageView, q: string): boolean {
  const needle = q.toLowerCase();
  const haystack = [
    view.title,
    view.shortDescription ?? "",
    ...view.destinations.map((d) => d.title),
    view.atoll?.title ?? "",
    ...view.categories,
    ...view.activities.map((a) => a.activity.title),
    ...view.accommodations.map((a) => a.accommodation.title),
  ]
    .join(" ")
    .toLowerCase();
  return haystack.includes(needle);
}

export function filterPackageViews(views: PackageView[], filters: PackageViewFilters): PackageView[] {
  let result = views;

  if (filters.q?.trim()) {
    const q = filters.q.trim();
    result = result.filter((v) => matchesQuery(v, q));
  }
  if (filters.category) {
    const category = filters.category;
    result = result.filter((v) => v.categories.includes(category));
  }
  if (filters.atollSlug) {
    result = result.filter((v) => v.atoll?.slug === filters.atollSlug);
  }
  if (filters.duration) {
    const band = PACKAGE_DURATION_BANDS.find((b) => b.slug === filters.duration);
    if (band) {
      result = result.filter((v) => v.nights !== null && v.nights >= band.min && (band.max === null || v.nights <= band.max));
    }
  }
  if (filters.minPrice !== undefined) {
    const min = filters.minPrice;
    result = result.filter((v) => v.price !== null && v.price >= min);
  }
  if (filters.maxPrice !== undefined) {
    const max = filters.maxPrice;
    result = result.filter((v) => v.price !== null && v.price <= max);
  }
  if (filters.minRating !== undefined) {
    const min = filters.minRating;
    result = result.filter((v) => v.rating !== null && v.rating >= min);
  }

  return result;
}

/** "Recommended" is a stable, curated order (newest real packages first,
 * then demo packages by their own authored createdAt) — never implies
 * popularity, bookings, or sales (Task 21 §11). */
export function sortPackageViews(views: PackageView[], sort: PackageSortOption): PackageView[] {
  const sorted = [...views];
  switch (sort) {
    case "price-asc":
      return sorted.sort((a, b) => (a.price ?? Number.MAX_SAFE_INTEGER) - (b.price ?? Number.MAX_SAFE_INTEGER));
    case "price-desc":
      return sorted.sort((a, b) => (b.price ?? -1) - (a.price ?? -1));
    case "shortest":
      return sorted.sort((a, b) => (a.nights ?? Number.MAX_SAFE_INTEGER) - (b.nights ?? Number.MAX_SAFE_INTEGER));
    case "longest":
      return sorted.sort((a, b) => (b.nights ?? -1) - (a.nights ?? -1));
    case "rating":
      return sorted.sort((a, b) => (b.rating ?? -1) - (a.rating ?? -1));
    case "newest":
      return sorted.sort((a, b) => (b.createdAt ?? "").localeCompare(a.createdAt ?? ""));
    case "recommended":
    default:
      // Real (curated, MTG's own commercial packages) first, then demo
      // in their authored order — a stable, non-random, non-"popularity"
      // ordering.
      return sorted.sort((a, b) => {
        if (a.isDemo !== b.isDemo) return a.isDemo ? 1 : -1;
        return 0;
      });
  }
}

/** Every category with at least one real-or-demo package tagged — the
 * "only show a filter chip that can return something" rule this codebase
 * uses everywhere else, applied across the merged dataset. */
export async function getPackageCategoryCounts(): Promise<Map<PackageCategorySlug, number>> {
  const all = await getAllPackageViews();
  const counts = new Map<PackageCategorySlug, number>();
  for (const view of all) {
    for (const category of view.categories) {
      counts.set(category, (counts.get(category) ?? 0) + 1);
    }
  }
  return counts;
}

export async function getPackageAtollsInUse(): Promise<LocationSummary[]> {
  const all = await getAllPackageViews();
  const byId = new Map<string, LocationSummary>();
  for (const view of all) {
    if (view.atoll) byId.set(view.atoll.id, view.atoll);
  }
  return Array.from(byId.values()).sort((a, b) => a.title.localeCompare(b.title));
}

export async function getPackageDurationBandCounts(): Promise<Map<PackageDurationBandSlug, number>> {
  const all = await getAllPackageViews();
  const counts = new Map<PackageDurationBandSlug, number>();
  for (const band of PACKAGE_DURATION_BANDS) {
    const count = all.filter((v) => v.nights !== null && v.nights >= band.min && (band.max === null || v.nights <= band.max)).length;
    if (count > 0) counts.set(band.slug, count);
  }
  return counts;
}

/** 4-6 packages genuinely related by shared category, destination,
 * similar duration, or similar price — never random (Task 21 §31). */
export async function getRelatedPackageViews(current: PackageView, limit = 6): Promise<PackageView[]> {
  const all = await getAllPackageViews();
  const candidates = all.filter((v) => v.slug !== current.slug);

  const scored = candidates.map((v) => {
    let score = 0;
    const sharedCategories = v.categories.filter((c) => current.categories.includes(c)).length;
    score += sharedCategories * 3;
    if (current.atoll && v.atoll?.slug === current.atoll.slug) score += 2;
    if (current.nights !== null && v.nights !== null && Math.abs(current.nights - v.nights) <= 2) score += 1;
    if (current.price !== null && v.price !== null && current.price > 0) {
      const ratio = Math.abs(current.price - v.price) / current.price;
      if (ratio <= 0.4) score += 1;
    }
    return { view: v, score };
  });

  return scored
    .filter((s) => s.score > 0)
    .sort((a, b) => b.score - a.score)
    .slice(0, limit)
    .map((s) => s.view);
}

/** Simple string hash -> [0, 1) float, used only to give the featured-
 * package shuffle below a seed that changes with each ISR revalidation
 * (see `revalidate` on the homepage) without needing real randomness —
 * deterministic within one render, different across revalidations. */
function seededFraction(seed: string): number {
  let hash = 0;
  for (let i = 0; i < seed.length; i++) hash = (hash * 31 + seed.charCodeAt(i)) | 0;
  return (hash >>> 0) / 0xffffffff;
}

export async function getFeaturedPackageViews(limit = 6): Promise<PackageView[]> {
  const all = await getAllPackageViews();
  // Real (curated, MTG's own commercial) packages are preferred over demo
  // ones, but real packages are deduped by category too — otherwise the
  // 14 real fishing packages alone fill every slot, since they'd all sort
  // ahead of every other category's demo packages (the bug the site owner
  // reported: all 6 featured cards were fishing). One representative per
  // category, real packages winning ties, so the 6 cards are genuinely 6
  // different kinds of holiday.
  const seenCategories = new Set<string>();
  function firstPerCategory(views: PackageView[]): PackageView[] {
    return views.filter((v) => {
      const newCategory = v.categories.some((c) => !seenCategories.has(c));
      v.categories.forEach((c) => seenCategories.add(c));
      return newCategory;
    });
  }
  const real = all.filter((v) => !v.isDemo);
  const demo = all.filter((v) => v.isDemo);
  const diverse = [...firstPerCategory(real), ...firstPerCategory(demo)];

  // Shuffled (seeded by the current hour, since the homepage caches for
  // revalidate = 3600s) so the same 6 categories don't always land in the
  // same order/selection every time this rebuilds — a genuinely different
  // spread of holiday types, not a fixed one, per the site owner's request.
  const seed = String(Math.floor(Date.now() / (60 * 60 * 1000)));
  const shuffled = diverse
    .map((view, i) => ({ view, r: seededFraction(`${seed}:${view.slug}:${i}`) }))
    .sort((a, b) => a.r - b.r)
    .map((entry) => entry.view);

  return shuffled.slice(0, limit);
}

async function realSummariesToViews(summaries: PackageSummary[]): Promise<PackageView[]> {
  const details = await Promise.all(summaries.map((s) => getPackageBySlug(s.slug)));
  return Promise.all(
    details
      .filter((d): d is NonNullable<typeof d> => d !== null)
      .map(async (detail) => {
        const view = realPackageToView(detail);
        const atoll = await resolveAtollForDestinations(view.destinations);
        return withAtoll(view, atoll);
      }),
  );
}

/** Task 21 §23/§24/§29/§53: reverse "Featured in these packages" links —
 * real DB packages (via the existing itinerary-reference repository
 * functions) PLUS demo packages anchored to the same real entity, so the
 * new demo inventory shows up on the resort/activity pages it's actually
 * about, not just on the packages hub. */
export async function getPackageViewsByAccommodation(accommodationNodeId: string): Promise<PackageView[]> {
  const [real, demo] = await Promise.all([getPackagesByAccommodation(accommodationNodeId), getDemoPackagesReferencingNode(accommodationNodeId)]);
  return [...(await realSummariesToViews(real)), ...demo];
}

export async function getPackageViewsByActivity(activityNodeId: string): Promise<PackageView[]> {
  const [real, demo] = await Promise.all([getPackagesByActivity(activityNodeId), getDemoPackagesReferencingNode(activityNodeId)]);
  return [...(await realSummariesToViews(real)), ...demo];
}

/** Real packages only — demo packages' transfer links aren't tied to a
 * specific real route (most just point at the transfers hub in general),
 * so there's nothing genuine to match against a specific route id here. */
export async function getPackageViewsByTransferRoute(routeId: string): Promise<PackageView[]> {
  const real = await getPackagesByTransferRoute(routeId);
  return realSummariesToViews(real);
}

/** Every real-or-demo package whose resolved atoll matches — reuses the
 * already-merged, already-atoll-resolved dataset rather than a second
 * DB-only lookup, so demo packages are included automatically. */
export async function getPackageViewsByAtoll(atollId: string): Promise<PackageView[]> {
  const all = await getAllPackageViews();
  return all.filter((v) => v.atoll?.id === atollId);
}

/** Every real-or-demo package whose destinations include this exact
 * location (island) — same reasoning as getPackageViewsByAtoll. */
export async function getPackageViewsByLocation(locationId: string): Promise<PackageView[]> {
  const all = await getAllPackageViews();
  return all.filter((v) => v.destinations.some((d) => d.id === locationId));
}
