import type { Metadata } from "next";
import Link from "next/link";

import { AccommodationCard } from "@/components/accommodation/accommodation-card";
import { AccommodationFilterBar } from "@/components/accommodation/accommodation-filter-bar";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import { PageHero } from "@/components/ui/page-hero";
import { Pagination } from "@/components/ui/pagination";
import { getAccommodations, searchAccommodations } from "@/lib/accommodations/repository";
import { ACCOMMODATION_TYPE_SEGMENT, type AccommodationType, type PriceTier } from "@/lib/accommodations/types";
import { getAtollBySlug, getAtolls, getIslandBySlug } from "@/lib/locations/repository";
import { canonicalUrl } from "@/lib/seo/site";

const TYPE_LABEL: Record<AccommodationType, string> = {
  hotel: "Hotels",
  resort: "Resorts",
  guesthouse: "Guesthouses",
  villa: "Villas",
  liveaboard: "Liveaboards",
  other: "Accommodation",
};

const PAGE_SIZE = 24;

export interface AccommodationDirectorySearchParams {
  q?: string;
  page?: string;
  atoll?: string;
  island?: string;
  priceTier?: string;
  starRating?: string;
  allInclusive?: string;
  overwater?: string;
}

function hasAnyFilter(sp: AccommodationDirectorySearchParams): boolean {
  return Boolean(sp.q || sp.atoll || sp.island || sp.priceTier || sp.starRating || sp.allInclusive || sp.overwater);
}

export async function accommodationDirectoryMetadata(
  type: AccommodationType,
  searchParams: Promise<AccommodationDirectorySearchParams>,
): Promise<Metadata> {
  const sp = await searchParams;
  const segment = ACCOMMODATION_TYPE_SEGMENT[type];
  const label = TYPE_LABEL[type];
  const title = `Maldives ${label} | MTG`;
  const description = `${label} in the Maldives, by atoll and island.`;
  const url = canonicalUrl(`/maldives/${segment}`);

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
    // Any filter/search state is a discovery view, not a canonical page —
    // keep it out of the index (matches the /maldives/islands/ pattern).
    robots: hasAnyFilter(sp) ? { index: false, follow: true } : undefined,
  };
}

export async function AccommodationDirectoryPage({
  type,
  searchParams,
}: {
  type: AccommodationType;
  searchParams: Promise<AccommodationDirectorySearchParams>;
}) {
  const sp = await searchParams;
  const segment = ACCOMMODATION_TYPE_SEGMENT[type];
  const label = TYPE_LABEL[type];
  const page = Math.max(1, Number(sp.page) || 1);
  const query = sp.q?.trim() ?? "";
  const isSearching = query.length > 0;

  const [atoll, island, atolls] = await Promise.all([
    sp.atoll ? getAtollBySlug(sp.atoll) : Promise.resolve(null),
    sp.island ? getIslandBySlug(sp.island) : Promise.resolve(null),
    getAtolls(),
  ]);

  const priceTier = sp.priceTier as PriceTier | undefined;
  const starRating = sp.starRating ? Number(sp.starRating) : undefined;
  const allInclusive = sp.allInclusive === "true";
  const overwater = sp.overwater === "true";

  const results = isSearching
    ? { items: (await searchAccommodations(query, { limit: 100 })).filter((a) => a.accommodationType === type), total: 0, page: 1, pageSize: 100 }
    : await getAccommodations({
        type,
        page,
        pageSize: PAGE_SIZE,
        atollId: island ? undefined : atoll?.id,
        locationId: island?.id,
        priceTier,
        starRating,
        allInclusive: allInclusive ? true : undefined,
        overwaterVillas: overwater ? true : undefined,
      });

  const totalPages = isSearching ? 1 : Math.max(1, Math.ceil(results.total / PAGE_SIZE));

  const currentParams = new URLSearchParams();
  if (sp.atoll) currentParams.set("atoll", sp.atoll);
  if (sp.island) currentParams.set("island", sp.island);
  if (sp.priceTier) currentParams.set("priceTier", sp.priceTier);
  if (sp.starRating) currentParams.set("starRating", sp.starRating);
  if (sp.allInclusive) currentParams.set("allInclusive", sp.allInclusive);
  if (sp.overwater) currentParams.set("overwater", sp.overwater);
  if (query) currentParams.set("q", query);
  const baseQuery = currentParams.toString() || undefined;

  return (
    <main>
      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label }]}
        eyebrow="Places to stay"
        title={`${label} in the Maldives`}
        description={(atoll || island) ? undefined : `Real, individually verified ${label.toLowerCase()} across the Maldives.`}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        {(atoll || island) && (
          <p className="text-sm text-neutral-600">
            Filtered to {island ? island.title : atoll?.title}.{" "}
            <Link href={`/maldives/${segment}/`} className="underline">
              Clear
            </Link>
          </p>
        )}

        <div className="mt-2">
          <AccommodationFilterBar
            basePath={`/maldives/${segment}/`}
            currentParams={currentParams}
            atolls={atolls}
            activeAtollSlug={sp.atoll}
            activePriceTier={priceTier}
            activeStarRating={starRating}
            activeAllInclusive={allInclusive}
            activeOverwater={overwater}
            query={query}
            resultCount={isSearching ? results.items.length : results.total}
            label={label}
          />
        </div>

        {results.items.length === 0 ? (
          <EmptyState
            title={`No ${label.toLowerCase()} recorded ${island || atoll ? "for this location " : ""}yet`}
          />
        ) : (
          <ul className="mt-8 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {results.items.map((accommodation) => (
              <AccommodationCard key={accommodation.id} accommodation={accommodation} />
            ))}
          </ul>
        )}

        {!isSearching && <Pagination page={page} totalPages={totalPages} basePath={`/maldives/${segment}/`} baseQuery={baseQuery} />}
      </div>
    </main>
  );
}
