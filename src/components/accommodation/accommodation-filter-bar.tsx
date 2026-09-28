import Link from "next/link";

import type { AtollSummary } from "@/lib/locations/types";
import type { PriceTier } from "@/lib/accommodations/types";

const PRICE_TIER_LABEL: Record<PriceTier, string> = {
  budget: "Budget",
  mid: "Mid-range",
  luxury: "Luxury",
  ultra_luxury: "Ultra-luxury",
};

const PRICE_TIERS: PriceTier[] = ["budget", "mid", "luxury", "ultra_luxury"];
const STAR_RATINGS = [5, 4, 3, 2, 1];

export interface AccommodationFilterBarProps {
  basePath: string;
  currentParams: URLSearchParams;
  atolls: AtollSummary[];
  activeAtollSlug: string | undefined;
  activePriceTier: PriceTier | undefined;
  activeStarRating: number | undefined;
  activeAllInclusive: boolean;
  activeOverwater: boolean;
  query: string;
  resultCount: number;
  label: string;
}

function linkWith(basePath: string, currentParams: URLSearchParams, overrides: Record<string, string | undefined>): string {
  const params = new URLSearchParams(currentParams);
  for (const [key, value] of Object.entries(overrides)) {
    if (value === undefined) params.delete(key);
    else params.set(key, value);
  }
  params.delete("page");
  const query = params.toString();
  return `${basePath}${query ? `?${query}` : ""}`;
}

export function AccommodationFilterBar({
  basePath,
  currentParams,
  atolls,
  activeAtollSlug,
  activePriceTier,
  activeStarRating,
  activeAllInclusive,
  activeOverwater,
  query,
  resultCount,
  label,
}: AccommodationFilterBarProps) {
  const activeChips: Array<{ label: string; clearHref: string }> = [];
  if (activeAtollSlug) {
    activeChips.push({
      label: atolls.find((a) => a.slug === activeAtollSlug)?.title ?? activeAtollSlug,
      clearHref: linkWith(basePath, currentParams, { atoll: undefined }),
    });
  }
  if (activePriceTier) activeChips.push({ label: PRICE_TIER_LABEL[activePriceTier], clearHref: linkWith(basePath, currentParams, { priceTier: undefined }) });
  if (activeStarRating) activeChips.push({ label: `${activeStarRating}★+`, clearHref: linkWith(basePath, currentParams, { starRating: undefined }) });
  if (activeAllInclusive) activeChips.push({ label: "All-inclusive", clearHref: linkWith(basePath, currentParams, { allInclusive: undefined }) });
  if (activeOverwater) activeChips.push({ label: "Overwater villas", clearHref: linkWith(basePath, currentParams, { overwater: undefined }) });

  return (
    <div>
      <form method="get" action={basePath} className="flex flex-wrap gap-2">
        <label htmlFor={`${basePath}-search`} className="sr-only">
          Search {label.toLowerCase()}
        </label>
        <input
          id={`${basePath}-search`}
          type="search"
          name="q"
          defaultValue={query}
          placeholder={`Search ${label.toLowerCase()}…`}
          className="w-full max-w-sm rounded-full border border-neutral-300 px-4 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
        />
        <button type="submit" className="rounded-full bg-maldives-600 px-4 py-2 text-sm font-medium text-white hover:bg-ocean-800">
          Search
        </button>
      </form>

      <details className="mt-4 group" open>
        <summary className="inline-flex cursor-pointer list-none items-center gap-1.5 rounded-full border border-neutral-300 px-4 py-2 text-sm font-medium text-neutral-700 [&::-webkit-details-marker]:hidden">
          Filters
          <span aria-hidden="true" className="transition-transform group-open:rotate-180">
            &#9662;
          </span>
        </summary>

        <div className="mt-3 space-y-4 rounded-2xl border border-neutral-200 p-4">
          {atolls.length > 0 && (
            <div>
              <p className="text-xs font-semibold uppercase tracking-wide text-neutral-500">Atoll</p>
              <nav aria-label="Filter by atoll" className="mt-2 flex flex-wrap gap-2 text-sm">
                {atolls.map((atoll) => (
                  <Link
                    key={atoll.id}
                    href={linkWith(basePath, currentParams, { atoll: activeAtollSlug === atoll.slug ? undefined : atoll.slug })}
                    className={`rounded-full border px-3 py-1 ${activeAtollSlug === atoll.slug ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
                  >
                    {atoll.title}
                  </Link>
                ))}
              </nav>
            </div>
          )}

          <div>
            <p className="text-xs font-semibold uppercase tracking-wide text-neutral-500">Price tier</p>
            <nav aria-label="Filter by price tier" className="mt-2 flex flex-wrap gap-2 text-sm">
              {PRICE_TIERS.map((tier) => (
                <Link
                  key={tier}
                  href={linkWith(basePath, currentParams, { priceTier: activePriceTier === tier ? undefined : tier })}
                  className={`rounded-full border px-3 py-1 ${activePriceTier === tier ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
                >
                  {PRICE_TIER_LABEL[tier]}
                </Link>
              ))}
            </nav>
          </div>

          <div>
            <p className="text-xs font-semibold uppercase tracking-wide text-neutral-500">Star rating</p>
            <nav aria-label="Filter by star rating" className="mt-2 flex flex-wrap gap-2 text-sm">
              {STAR_RATINGS.map((stars) => (
                <Link
                  key={stars}
                  href={linkWith(basePath, currentParams, { starRating: activeStarRating === stars ? undefined : String(stars) })}
                  className={`rounded-full border px-3 py-1 ${activeStarRating === stars ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
                >
                  {stars}★+
                </Link>
              ))}
            </nav>
          </div>

          <div>
            <p className="text-xs font-semibold uppercase tracking-wide text-neutral-500">Features</p>
            <nav aria-label="Filter by feature" className="mt-2 flex flex-wrap gap-2 text-sm">
              <Link
                href={linkWith(basePath, currentParams, { allInclusive: activeAllInclusive ? undefined : "true" })}
                className={`rounded-full border px-3 py-1 ${activeAllInclusive ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
              >
                All-inclusive
              </Link>
              <Link
                href={linkWith(basePath, currentParams, { overwater: activeOverwater ? undefined : "true" })}
                className={`rounded-full border px-3 py-1 ${activeOverwater ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
              >
                Overwater villas
              </Link>
            </nav>
          </div>
        </div>
      </details>

      {activeChips.length > 0 && (
        <div className="mt-3 flex flex-wrap items-center gap-2">
          {activeChips.map((chip) => (
            <Link key={chip.label} href={chip.clearHref} className="inline-flex items-center gap-1 rounded-full bg-neutral-100 px-3 py-1 text-xs text-neutral-700 hover:bg-neutral-200">
              {chip.label} <span aria-hidden="true">&#10005;</span>
            </Link>
          ))}
          <Link href={basePath} className="text-xs font-medium text-maldives-600 hover:underline">
            Clear all
          </Link>
        </div>
      )}

      <p className="mt-4 text-sm text-neutral-600">
        {resultCount} {label.toLowerCase()}
      </p>
    </div>
  );
}
