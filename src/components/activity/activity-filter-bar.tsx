import Link from "next/link";

import type { LocationSummary } from "@/lib/locations/types";
import { activityDirectorySegment, hasDedicatedRoute, type ActivityCategory, type ActivityDifficulty } from "@/lib/activities/types";

const CATEGORY_LABEL: Record<ActivityCategory, string> = {
  general: "General",
  fishing: "Fishing",
  diving: "Diving",
  surfing: "Surfing",
  watersports: "Watersports",
  excursion: "Excursion",
  island_hopping: "Island Hopping",
  spa: "Spa",
  culture: "Culture",
};

const DIFFICULTY_LABEL: Record<ActivityDifficulty, string> = {
  beginner: "Beginner",
  intermediate: "Intermediate",
  advanced: "Advanced",
  all_levels: "All levels",
};

const CATEGORIES = (Object.keys(CATEGORY_LABEL) as ActivityCategory[]).filter((c) => !hasDedicatedRoute(c));
const DEDICATED_CATEGORIES = (Object.keys(CATEGORY_LABEL) as ActivityCategory[]).filter((c) => hasDedicatedRoute(c));

export interface ActivityFilterBarProps {
  basePath: string;
  currentParams: URLSearchParams;
  activeCategory: ActivityCategory | undefined;
  atolls: LocationSummary[];
  activeAtoll: string | undefined;
  activeDifficulty: ActivityDifficulty | undefined;
  maxPrice: string;
  query: string;
  resultCount: number;
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

export function ActivityFilterBar({
  basePath,
  currentParams,
  activeCategory,
  atolls,
  activeAtoll,
  activeDifficulty,
  maxPrice,
  query,
  resultCount,
}: ActivityFilterBarProps) {
  const activeChips: Array<{ label: string; clearHref: string }> = [];
  if (activeCategory) activeChips.push({ label: CATEGORY_LABEL[activeCategory], clearHref: linkWith(basePath, currentParams, { category: undefined }) });
  if (activeAtoll) activeChips.push({ label: atolls.find((a) => a.slug === activeAtoll)?.title ?? activeAtoll, clearHref: linkWith(basePath, currentParams, { atoll: undefined }) });
  if (activeDifficulty) activeChips.push({ label: DIFFICULTY_LABEL[activeDifficulty], clearHref: linkWith(basePath, currentParams, { difficulty: undefined }) });
  if (maxPrice) activeChips.push({ label: `Up to USD ${maxPrice}`, clearHref: linkWith(basePath, currentParams, { maxPrice: undefined }) });

  return (
    <div>
      <form method="get" action={basePath} className="flex flex-wrap gap-2">
        <label htmlFor="activity-search" className="sr-only">
          Search activities
        </label>
        <input
          id="activity-search"
          type="search"
          name="q"
          defaultValue={query}
          placeholder="Search activities…"
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
          <div>
            <p className="text-xs font-semibold uppercase tracking-wide text-neutral-500">Category</p>
            <nav aria-label="Filter by category" className="mt-2 flex flex-wrap gap-2 text-sm">
              {CATEGORIES.map((c) => (
                <Link
                  key={c}
                  href={linkWith(basePath, currentParams, { category: activeCategory === c ? undefined : c })}
                  className={`rounded-full border px-3 py-1 ${activeCategory === c ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
                >
                  {CATEGORY_LABEL[c]}
                </Link>
              ))}
              {DEDICATED_CATEGORIES.map((c) => (
                <Link key={c} href={`/maldives/${activityDirectorySegment(c)}/`} className="rounded-full border border-dashed border-neutral-400 px-3 py-1 text-neutral-700">
                  {CATEGORY_LABEL[c]} →
                </Link>
              ))}
            </nav>
          </div>

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

          <form method="get" action={basePath} className="grid grid-cols-2 gap-3 sm:flex sm:flex-wrap sm:items-end sm:gap-4">
            {activeCategory && <input type="hidden" name="category" value={activeCategory} />}
            {activeAtoll && <input type="hidden" name="atoll" value={activeAtoll} />}
            {query && <input type="hidden" name="q" value={query} />}

            <label className="text-sm">
              <span className="mb-1 block text-xs font-semibold uppercase tracking-wide text-neutral-500">Difficulty</span>
              <select name="difficulty" defaultValue={activeDifficulty ?? ""} className="w-full rounded-xl border border-neutral-300 px-3 py-1.5 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1 sm:w-36">
                <option value="">Any</option>
                {(Object.keys(DIFFICULTY_LABEL) as ActivityDifficulty[]).map((d) => (
                  <option key={d} value={d}>
                    {DIFFICULTY_LABEL[d]}
                  </option>
                ))}
              </select>
            </label>
            <label className="text-sm">
              <span className="mb-1 block text-xs font-semibold uppercase tracking-wide text-neutral-500">Max price (USD)</span>
              <input type="number" name="maxPrice" min={0} defaultValue={maxPrice} className="w-full rounded-xl border border-neutral-300 px-3 py-1.5 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1 sm:w-28" />
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

      <p className="mt-4 text-sm text-neutral-600">
        {resultCount} activit{resultCount === 1 ? "y" : "ies"}
      </p>
    </div>
  );
}
