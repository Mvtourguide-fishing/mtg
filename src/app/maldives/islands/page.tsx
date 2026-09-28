import type { Metadata } from "next";
import Link from "next/link";

import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import { PageHero } from "@/components/ui/page-hero";
import { Pagination } from "@/components/ui/pagination";
import { SearchIcon } from "@/components/ui/icons";
import { getIslands, searchLocations } from "@/lib/locations/repository";
import { canonicalUrl } from "@/lib/seo/site";

const PAGE_SIZE = 48;

interface SearchParams {
  q?: string;
  page?: string;
}

export function generateMetadata({
  searchParams,
}: {
  searchParams: Promise<SearchParams>;
}): Promise<Metadata> {
  return searchParams.then(({ q }) => {
    const title = "Maldives Islands | MTG";
    const description = "Every inhabited island in the Maldives, by atoll.";
    return {
      title,
      description,
      alternates: { canonical: canonicalUrl("/maldives/islands") },
      openGraph: { title, description, url: canonicalUrl("/maldives/islands") },
      // A search query narrows results to an arbitrary, non-canonical view —
      // keep it out of the index; the plain directory (and its pagination)
      // stays indexable.
      robots: q ? { index: false, follow: true } : undefined,
    };
  });
}

export default async function IslandsPage({
  searchParams,
}: {
  searchParams: Promise<SearchParams>;
}) {
  const { q, page: pageParam } = await searchParams;
  const page = Math.max(1, Number(pageParam) || 1);

  const query = q?.trim() ?? "";
  const isSearching = query.length > 0;

  const results = isSearching
    ? { items: await searchLocations(query, { locationType: "island", limit: 100 }), total: 0, page: 1, pageSize: 100 }
    : await getIslands({ page, pageSize: PAGE_SIZE });

  const totalPages = isSearching ? 1 : Math.max(1, Math.ceil(results.total / PAGE_SIZE));

  return (
    <main>
      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Islands" }]}
        eyebrow="Destinations"
        title="Islands of the Maldives"
        description="Every inhabited island, searchable across all atolls."
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        <form method="get" className="flex gap-2">
          <label htmlFor="island-search" className="sr-only">
            Search islands
          </label>
          <div className="relative w-full max-w-sm">
            <SearchIcon className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-neutral-400" />
            <input
              id="island-search"
              type="search"
              name="q"
              defaultValue={query}
              placeholder="Search islands…"
              className="w-full rounded-full border border-neutral-300 py-2 pl-9 pr-3 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
            />
          </div>
          <button type="submit" className="rounded-full bg-maldives-600 px-4 py-2 text-sm font-medium text-white hover:bg-ocean-800">
            Search
          </button>
        </form>

        {isSearching && (
          <p className="mt-4 text-sm text-neutral-600">
            {results.items.length} result{results.items.length === 1 ? "" : "s"} for &ldquo;{query}&rdquo; —{" "}
            <Link href="/maldives/islands/" className="underline">
              clear search
            </Link>
          </p>
        )}

        {results.items.length === 0 ? (
          <EmptyState title="No islands found" description="Try a different search term." />
        ) : (
          <ul className="mt-6 grid grid-cols-2 gap-x-6 gap-y-2 sm:grid-cols-3 lg:grid-cols-4">
            {results.items.map((island) => (
              <li key={island.id}>
                <Link href={`/maldives/islands/${island.slug}/`} className="text-sm text-ocean-900 hover:text-maldives-600 hover:underline">
                  {island.title}
                </Link>
              </li>
            ))}
          </ul>
        )}

        {!isSearching && <Pagination page={page} totalPages={totalPages} basePath="/maldives/islands/" />}
      </div>
    </main>
  );
}
