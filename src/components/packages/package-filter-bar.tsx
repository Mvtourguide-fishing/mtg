import Link from "next/link";

import { PackageSortSelect } from "@/components/packages/package-sort-select";
import type { LocationSummary } from "@/lib/locations/types";
import type { PackageCategorySlug, PackageDurationBandSlug, PackageSortOption } from "@/lib/packages/view-types";
import { PACKAGE_CATEGORIES, PACKAGE_DURATION_BANDS } from "@/lib/packages/view-types";

export interface PackageFilterBarProps {
  basePath: string;
  currentParams: URLSearchParams;
  /** Omitted entirely on a category landing page, where the category is
   * implied by the URL rather than chosen from a chip row (Task 21 §25 —
   * the category page itself IS the filter). */
  showCategoryFilter?: boolean;
  categoryCounts: Map<PackageCategorySlug, number>;
  activeCategory: PackageCategorySlug | undefined;
  atolls: LocationSummary[];
  activeAtoll: string | undefined;
  durationCounts: Map<PackageDurationBandSlug, number>;
  activeDuration: PackageDurationBandSlug | undefined;
  minPrice: string;
  maxPrice: string;
  minRating: string;
  query: string;
  sort: PackageSortOption;
  resultCount: number;
  resultLabel: string;
}

function linkWith(basePath: string, currentParams: URLSearchParams, overrides: Record<string, string | undefined>): string {
  const params = new URLSearchParams(currentParams);
  for (const [key, value] of Object.entries(overrides)) {
    if (value === undefined) params.delete(key);
    else params.set(key, value);
  }
  const query = params.toString();
  return `${basePath}${query ? `?${query}` : ""}`;
}

export function PackageFilterBar({
  basePath,
  currentParams,
  showCategoryFilter = true,
  categoryCounts,
  activeCategory,
  atolls,
  activeAtoll,
  durationCounts,
  activeDuration,
  minPrice,
  maxPrice,
  minRating,
  query,
  sort,
  resultCount,
  resultLabel,
}: PackageFilterBarProps) {
  const activeChips: Array<{ label: string; clearHref: string }> = [];
  if (activeCategory) activeChips.push({ label: PACKAGE_CATEGORIES.find((c) => c.slug === activeCategory)?.title ?? activeCategory, clearHref: linkWith(basePath, currentParams, { category: undefined }) });
  if (activeAtoll) activeChips.push({ label: atolls.find((a) => a.slug === activeAtoll)?.title ?? activeAtoll, clearHref: linkWith(basePath, currentParams, { atoll: undefined }) });
  if (activeDuration) activeChips.push({ label: PACKAGE_DURATION_BANDS.find((b) => b.slug === activeDuration)?.label ?? activeDuration, clearHref: linkWith(basePath, currentParams, { duration: undefined }) });
  if (minPrice || maxPrice) activeChips.push({ label: `${minPrice || "0"}–${maxPrice || "∞"} USD`, clearHref: linkWith(basePath, currentParams, { minPrice: undefined, maxPrice: undefined }) });
  if (minRating) activeChips.push({ label: `${minRating}+ rating`, clearHref: linkWith(basePath, currentParams, { minRating: undefined }) });

  return (
    <div>
      <form method="get" action={basePath} className="flex flex-wrap gap-2">
        <label htmlFor="package-search" className="sr-only">
          Search packages
        </label>
        <input
          id="package-search"
          type="search"
          name="q"
          defaultValue={query}
          placeholder="Search by name, island, atoll, or activity…"
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
          {showCategoryFilter && (
            <div>
              <p className="text-xs font-semibold uppercase tracking-wide text-neutral-500">Category</p>
              <nav aria-label="Filter by category" className="mt-2 flex flex-wrap gap-2 text-sm">
                {PACKAGE_CATEGORIES.filter((c) => (categoryCounts.get(c.slug) ?? 0) > 0).map((c) => (
                  <Link
                    key={c.slug}
                    href={linkWith(basePath, currentParams, { category: activeCategory === c.slug ? undefined : c.slug })}
                    className={`rounded-full border px-3 py-1 ${activeCategory === c.slug ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
                  >
                    {c.title} ({categoryCounts.get(c.slug)})
                  </Link>
                ))}
              </nav>
            </div>
          )}

          {atolls.length > 0 && (
            <div>
              <p className="text-xs font-semibold uppercase tracking-wide text-neutral-500">Location</p>
              <nav aria-label="Filter by atoll" className="mt-2 flex flex-wrap gap-2 text-sm">
                {atolls.map((atoll) => (
                  <Link
                    key={atoll.slug}
                    href={linkWith(basePath, currentParams, { atoll: activeAtoll === atoll.slug ? undefined : atoll.slug })}
                    className={`rounded-full border px-3 py-1 ${activeAtoll === atoll.slug ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
                  >
                    {atoll.title}
                  </Link>
                ))}
              </nav>
            </div>
          )}

          <div>
            <p className="text-xs font-semibold uppercase tracking-wide text-neutral-500">Duration</p>
            <nav aria-label="Filter by duration" className="mt-2 flex flex-wrap gap-2 text-sm">
              {PACKAGE_DURATION_BANDS.filter((b) => (durationCounts.get(b.slug) ?? 0) > 0).map((band) => (
                <Link
                  key={band.slug}
                  href={linkWith(basePath, currentParams, { duration: activeDuration === band.slug ? undefined : band.slug })}
                  className={`rounded-full border px-3 py-1 ${activeDuration === band.slug ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
                >
                  {band.label} ({durationCounts.get(band.slug)})
                </Link>
              ))}
            </nav>
          </div>

          <form method="get" action={basePath} className="grid grid-cols-2 gap-3 sm:flex sm:flex-wrap sm:items-end sm:gap-4">
            {activeCategory && <input type="hidden" name="category" value={activeCategory} />}
            {activeAtoll && <input type="hidden" name="atoll" value={activeAtoll} />}
            {activeDuration && <input type="hidden" name="duration" value={activeDuration} />}
            {query && <input type="hidden" name="q" value={query} />}

            <label className="text-sm">
              <span className="mb-1 block text-xs font-semibold uppercase tracking-wide text-neutral-500">Min price (USD)</span>
              <input type="number" name="minPrice" min={0} defaultValue={minPrice} className="w-full rounded-xl border border-neutral-300 px-3 py-1.5 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1 sm:w-28" />
            </label>
            <label className="text-sm">
              <span className="mb-1 block text-xs font-semibold uppercase tracking-wide text-neutral-500">Max price (USD)</span>
              <input type="number" name="maxPrice" min={0} defaultValue={maxPrice} className="w-full rounded-xl border border-neutral-300 px-3 py-1.5 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1 sm:w-28" />
            </label>
            <label className="text-sm">
              <span className="mb-1 block text-xs font-semibold uppercase tracking-wide text-neutral-500">Min rating</span>
              <select name="minRating" defaultValue={minRating} className="w-full rounded-xl border border-neutral-300 px-3 py-1.5 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1 sm:w-28">
                <option value="">Any</option>
                <option value="4">4.0+</option>
                <option value="4.5">4.5+</option>
              </select>
            </label>
            <button type="submit" className="rounded-full bg-maldives-600 px-4 py-1.5 text-sm font-medium text-white hover:bg-ocean-800">
              Apply
            </button>
          </form>
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

      <div className="mt-4 flex flex-wrap items-center justify-between gap-3">
        <p className="text-sm text-neutral-600">
          {resultCount} {resultLabel}
        </p>
        <PackageSortSelect basePath={basePath} current={sort} />
      </div>
    </div>
  );
}
