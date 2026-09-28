import type { MetadataRoute } from "next";

import { getAccommodations } from "@/lib/accommodations/repository";
import { ACCOMMODATION_TYPE_SEGMENT } from "@/lib/accommodations/types";
import { getActivities } from "@/lib/activities/repository";
import { activityHref } from "@/lib/activities/types";
import { getArticles } from "@/lib/articles/repository";
import { getAttractions } from "@/lib/attractions/repository";
import { articleHref } from "@/lib/articles/types";
import { getDiveSites } from "@/lib/diving/repository";
import { getAtolls, getIslands } from "@/lib/locations/repository";
import { getPackages } from "@/lib/packages/repository";
import { getProviders } from "@/lib/providers/repository";
import { getSiteUrl } from "@/lib/seo/site";
import { getSpeedboats } from "@/lib/speedboats/repository";
import { getSurfBreaks } from "@/lib/surfing/repository";
import { getTransferRoutes } from "@/lib/transfers/repository";

/**
 * Task 16 §30: the sitemap must contain only real, currently-live
 * canonical URLs — never an old redirected `.html` path, never a
 * duplicate. Every URL here is built from the exact same repository
 * functions the pages themselves use, so this can never list a page that
 * doesn't actually exist.
 */

const PAGE_SIZE = 100; // matches every repository's own pageSize cap

async function fetchAllPages<T>(fetchPage: (page: number) => Promise<{ items: T[]; total: number }>): Promise<T[]> {
  const all: T[] = [];
  let page = 1;
  for (;;) {
    const result = await fetchPage(page);
    all.push(...result.items);
    if (all.length >= result.total || result.items.length === 0) break;
    page += 1;
  }
  return all;
}

const STATIC_PATHS = [
  "/",
  "/maldives/",
  "/maldives/activities/",
  "/maldives/attractions/",
  "/maldives/atolls/",
  "/maldives/dive-sites/",
  "/maldives/diving/",
  "/maldives/fishing/",
  "/maldives/guesthouses/",
  "/maldives/hotels/",
  "/maldives/islands/",
  "/maldives/packages/",
  "/maldives/packages/luxury/",
  "/maldives/packages/family/",
  "/maldives/packages/adults-only/",
  "/maldives/packages/long-stay/",
  "/maldives/packages/budget/",
  "/maldives/packages/honeymoon/",
  "/maldives/packages/solo/",
  "/maldives/packages/diving/",
  "/maldives/packages/fishing/",
  "/maldives/packages/surfing/",
  "/maldives/packages/liveaboard/",
  "/maldives/providers/",
  "/maldives/resorts/",
  "/maldives/stays/",
  "/maldives/surf-breaks/",
  "/maldives/surfing/",
  "/maldives/transfers/",
  "/maldives/airport-transfers/",
  "/maldives/resort-transfers/",
  "/maldives/hotel-transfers/",
  "/maldives/island-transfers/",
  "/maldives/speedboat-transfers/",
  "/maldives-speedboats-charter/",
  "/maldives-ferry-schedule/",
  "/maldives/travel-guide/",
];

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const siteUrl = getSiteUrl();
  const url = (path: string) => `${siteUrl}${path}`;

  const [atolls, islands, accommodations, activities, attractions, diveSites, surfBreaks, packages, transferRoutes, articles, providers, speedboats] = await Promise.all([
    getAtolls(),
    fetchAllPages((page) => getIslands({ page, pageSize: PAGE_SIZE })),
    fetchAllPages((page) => getAccommodations({ page, pageSize: PAGE_SIZE })),
    fetchAllPages((page) => getActivities({ page, pageSize: PAGE_SIZE })),
    fetchAllPages((page) => getAttractions({ page, pageSize: PAGE_SIZE })),
    fetchAllPages((page) => getDiveSites({ page, pageSize: PAGE_SIZE })),
    fetchAllPages((page) => getSurfBreaks({ page, pageSize: PAGE_SIZE })),
    fetchAllPages((page) => getPackages({ page, pageSize: PAGE_SIZE })),
    fetchAllPages((page) => getTransferRoutes({ page, pageSize: PAGE_SIZE })),
    fetchAllPages((page) => getArticles({ page, pageSize: PAGE_SIZE })),
    fetchAllPages((page) => getProviders({ page, pageSize: PAGE_SIZE })),
    getSpeedboats(),
  ]);

  const entries: MetadataRoute.Sitemap = STATIC_PATHS.map((path) => ({ url: url(path), changeFrequency: "weekly", priority: path === "/" || path === "/maldives/" ? 1 : 0.6 }));

  for (const a of atolls) entries.push({ url: url(`/maldives/atolls/${a.slug}/`), changeFrequency: "monthly", priority: 0.7 });
  for (const i of islands) entries.push({ url: url(`/maldives/islands/${i.slug}/`), changeFrequency: "monthly", priority: 0.6 });
  for (const a of accommodations) entries.push({ url: url(`/maldives/${ACCOMMODATION_TYPE_SEGMENT[a.accommodationType]}/${a.slug}/`), changeFrequency: "weekly", priority: 0.7 });
  for (const a of activities) entries.push({ url: url(activityHref(a)), changeFrequency: "monthly", priority: 0.6 });
  for (const a of attractions) entries.push({ url: url(`/maldives/attractions/${a.slug}/`), changeFrequency: "monthly", priority: 0.5 });
  for (const d of diveSites) entries.push({ url: url(`/maldives/dive-sites/${d.slug}/`), changeFrequency: "monthly", priority: 0.5 });
  for (const s of surfBreaks) entries.push({ url: url(`/maldives/surf-breaks/${s.slug}/`), changeFrequency: "monthly", priority: 0.5 });
  // getPackages() only ever returns real DB packages — Task 21's demo
  // package inventory (src/lib/packages/demo-packages.ts) is deliberately
  // excluded here (each demo package page is also `noindex,follow` — see
  // packageDetailMetadata) so it's never presented to search engines as
  // real commercial inventory.
  for (const p of packages) entries.push({ url: url(`/maldives/packages/${p.slug}/`), changeFrequency: "weekly", priority: 0.7 });
  for (const t of transferRoutes) entries.push({ url: url(`/maldives/transfers/${t.slug}/`), changeFrequency: "monthly", priority: 0.6 });
  for (const b of speedboats) entries.push({ url: url(`/maldives-speedboats-charter/${b.slug}/`), changeFrequency: "monthly", priority: 0.5 });
  for (const a of articles) entries.push({ url: url(articleHref(a)), changeFrequency: "monthly", priority: 0.6, lastModified: a.publishedAt ?? undefined });
  for (const p of providers) entries.push({ url: url(`/maldives/providers/${p.slug}/`), changeFrequency: "monthly", priority: 0.4 });

  return entries;
}
