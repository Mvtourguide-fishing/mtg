import type { Metadata } from "next";
import Link from "next/link";

import { SearchBox } from "@/components/search/search-box";
import { SearchResultCard } from "@/components/search/search-result-card";
import { CARD_CLASS } from "@/components/ui/card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import {
  BedIcon,
  BoatIcon,
  CompassIcon,
  DivingIcon,
  FishIcon,
  MapPinIcon,
  PackageIcon,
} from "@/components/ui/icons";
import { PageHero } from "@/components/ui/page-hero";
import { Pagination } from "@/components/ui/pagination";
import { SectionHeader } from "@/components/ui/section-header";
import { searchSite } from "@/lib/search/repository";
import {
  SEARCH_FILTER_LABEL,
  SEARCH_FILTER_TYPES,
  type SearchFilterType,
  type SearchGroupKey,
} from "@/lib/search/types";
import { canonicalUrl } from "@/lib/seo/site";

const PAGE_SIZE = 12;

export interface SearchPageSearchParams {
  q?: string;
  type?: string;
  page?: string;
}

const SEARCH_FILTER_TYPE_SET: ReadonlySet<string> = new Set(SEARCH_FILTER_TYPES);

function isSearchFilterType(value: string | undefined): value is SearchFilterType {
  return Boolean(value && SEARCH_FILTER_TYPE_SET.has(value));
}

/** Every filter chip value that can appear inside a given result group —
 * used to build "view all" links for groups that mix several filter
 * types (things-to-do = activity/fishing/diving/surfing). */
const GROUP_FILTER_TYPES: Record<SearchGroupKey, SearchFilterType[]> = {
  destinations: ["location"],
  stay: ["resort", "hotel", "guesthouse"],
  "things-to-do": ["activity", "fishing", "diving", "surfing"],
  attractions: ["attraction"],
  transfers: ["transfer"],
  packages: ["package"],
  "travel-guide": ["article"],
};

function chipClass(active: boolean): string {
  return `rounded-full border px-3 py-1 text-sm ${
    active ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"
  }`;
}

export async function searchPageMetadata(searchParams: Promise<SearchPageSearchParams>): Promise<Metadata> {
  const sp = await searchParams;
  const q = sp.q?.trim() ?? "";
  const canonical = canonicalUrl("/maldives/search");

  const title = q ? `Search results for "${q}" | MTG` : "Search | Maldives Tour Guide";
  const description = q
    ? `Search results for "${q}" across Maldives atolls, islands, resorts, hotels, guesthouses, activities, transfers, and packages.`
    : "Search MTG for real Maldives atolls, islands, resorts, hotels, guesthouses, activities, diving, fishing, surfing, transfers, and packages.";

  return {
    title,
    description,
    // Task 13 §5/§28: the canonical URL always stays the clean search
    // page — query/filter/page params never become their own indexable
    // landing pages.
    alternates: { canonical },
    openGraph: { title, description, url: canonical },
    // Any actual query is a dynamic, per-visitor discovery view — keep it
    // out of the index while still letting crawlers follow its links.
    robots: q ? { index: false, follow: true } : undefined,
  };
}

const BROWSE_CATEGORIES = [
  { label: "Atolls", href: "/maldives/atolls/", Icon: MapPinIcon },
  { label: "Islands", href: "/maldives/islands/", Icon: MapPinIcon },
  { label: "Resorts", href: "/maldives/resorts/", Icon: BedIcon },
  { label: "Hotels", href: "/maldives/hotels/", Icon: BedIcon },
  { label: "Guesthouses", href: "/maldives/guesthouses/", Icon: BedIcon },
  { label: "Activities", href: "/maldives/activities/", Icon: CompassIcon },
  { label: "Fishing", href: "/maldives/fishing/", Icon: FishIcon },
  { label: "Diving", href: "/maldives/diving/", Icon: DivingIcon },
  { label: "Surfing", href: "/maldives/surfing/", Icon: CompassIcon },
  { label: "Transfers", href: "/maldives/transfers/", Icon: BoatIcon },
  { label: "Packages", href: "/maldives/packages/", Icon: PackageIcon },
] as const;

function SearchHomeState() {
  return (
    <div className="mt-10">
      <SectionHeader title="Browse by category" description="Every real section of MTG — jump straight in, or search above." />
      <ul className="mt-4 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
        {BROWSE_CATEGORIES.map(({ label, href, Icon }) => (
          <li key={href}>
            <Link href={href} className={`${CARD_CLASS} flex items-center gap-3`}>
              <Icon className="h-5 w-5 shrink-0 text-maldives-600" />
              <span className="font-medium text-ocean-900">{label}</span>
            </Link>
          </li>
        ))}
      </ul>
    </div>
  );
}

function SearchEmptyState({ query }: { query: string }) {
  return (
    <div className="mt-10">
      <EmptyState
        title={`No results for "${query}"`}
        description="Try a different spelling, a broader search, or searching for an island, resort, activity, or transfer."
      />
      <div className="mt-6 flex flex-wrap justify-center gap-x-5 gap-y-2 text-sm">
        <Link href="/maldives/" className="font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
          Explore Maldives
        </Link>
        <Link href="/maldives/resorts/" className="font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
          Resorts
        </Link>
        <Link href="/maldives/activities/" className="font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
          Activities
        </Link>
        <Link href="/maldives/transfers/" className="font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
          Transfers
        </Link>
      </div>
    </div>
  );
}

export async function SearchResultsPage({ searchParams }: { searchParams: Promise<SearchPageSearchParams> }) {
  const sp = await searchParams;
  const q = sp.q?.trim() ?? "";
  const activeType = isSearchFilterType(sp.type) ? sp.type : undefined;
  const page = Math.max(1, Number(sp.page) || 1);

  const result = q ? await searchSite(q, { type: activeType, page, pageSize: PAGE_SIZE }) : null;

  return (
    <main>
      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Search" }]}
        eyebrow="Search"
        title={q ? `Results for "${q}"` : "Search MTG"}
        description={
          q ? undefined : "Find real atolls, islands, resorts, hotels, guesthouses, activities, transfers, and packages across the Maldives."
        }
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        <SearchBox variant="inline" placeholder="Search resorts, islands, activities…" className="max-w-2xl" />

        {!q && <SearchHomeState />}

        {q && result && (
          <>
            <nav aria-label="Filter by type" className="mt-8 flex flex-wrap gap-2">
              <Link href={`/maldives/search/?q=${encodeURIComponent(q)}`} className={chipClass(!activeType)}>
                All
              </Link>
              {SEARCH_FILTER_TYPES.map((type) => (
                <Link key={type} href={`/maldives/search/?q=${encodeURIComponent(q)}&type=${type}`} className={chipClass(activeType === type)}>
                  {SEARCH_FILTER_LABEL[type]}
                </Link>
              ))}
            </nav>

            {result.total === 0 ? (
              <SearchEmptyState query={q} />
            ) : activeType && result.flat ? (
              <>
                <p className="mt-6 text-sm text-neutral-600">
                  {result.flat.total} result{result.flat.total === 1 ? "" : "s"}
                </p>
                <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2">
                  {result.flat.items.map((r) => (
                    <SearchResultCard key={`${r.type}:${r.id}`} result={r} />
                  ))}
                </ul>
                <Pagination
                  page={result.flat.page}
                  totalPages={Math.max(1, Math.ceil(result.flat.total / result.flat.pageSize))}
                  basePath="/maldives/search/"
                  baseQuery={`q=${encodeURIComponent(q)}&type=${activeType}`}
                />
              </>
            ) : (
              <div className="mt-8 space-y-10">
                {result.groups.map((group) => (
                  <section key={group.key}>
                    <SectionHeader title={group.label} />
                    <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2">
                      {group.results.map((r) => (
                        <SearchResultCard key={`${r.type}:${r.id}`} result={r} />
                      ))}
                    </ul>
                    {group.hasMore && (
                      <div className="mt-3 flex flex-wrap gap-x-4 gap-y-1 text-sm">
                        {GROUP_FILTER_TYPES[group.key].map((type) => (
                          <Link
                            key={type}
                            href={`/maldives/search/?q=${encodeURIComponent(q)}&type=${type}`}
                            className="font-medium text-maldives-600 hover:text-ocean-800 hover:underline"
                          >
                            View all {SEARCH_FILTER_LABEL[type]} →
                          </Link>
                        ))}
                      </div>
                    )}
                  </section>
                ))}
              </div>
            )}
          </>
        )}
      </div>
    </main>
  );
}
