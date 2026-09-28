import type { Metadata } from "next";
import Link from "next/link";

import { ArticleCard } from "@/components/articles/article-card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import { PageHero } from "@/components/ui/page-hero";
import { Pagination } from "@/components/ui/pagination";
import { getArticleCategoriesInUse, getArticles } from "@/lib/articles/repository";
import { canonicalUrl } from "@/lib/seo/site";

const PAGE_SIZE = 24;

export interface ArticleDirectorySearchParams {
  page?: string;
  category?: string;
}

export async function articleDirectoryMetadata(searchParams: Promise<ArticleDirectorySearchParams>): Promise<Metadata> {
  const sp = await searchParams;
  const title = "Maldives Travel Guide | MTG";
  const description = "Real, in-depth Maldives travel guides — islands, atolls, diving, weather, culture, and more.";
  const url = canonicalUrl("/maldives/travel-guide");

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
    // A category filter narrows results to a non-canonical view — keep it
    // out of the index; the plain directory (and its pagination) stays
    // indexable, same rule as the packages/search directories.
    robots: sp.category ? { index: false, follow: true } : undefined,
  };
}

export async function ArticleDirectoryPage({ searchParams }: { searchParams: Promise<ArticleDirectorySearchParams> }) {
  const sp = await searchParams;
  const page = Math.max(1, Number(sp.page) || 1);

  const categories = await getArticleCategoriesInUse();
  const activeCategory = sp.category && categories.some((c) => c.slug === sp.category) ? sp.category : undefined;

  const results = await getArticles({ page, pageSize: PAGE_SIZE, category: activeCategory });
  const totalPages = Math.max(1, Math.ceil(results.total / PAGE_SIZE));

  return (
    <main>
      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Travel Guide" }]}
        eyebrow="Travel Guide"
        title="Maldives Travel Guide"
        description="Real, in-depth guides to the islands, atolls, diving, weather, and culture of the Maldives."
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        {categories.length > 0 && (
          <nav aria-label="Filter by category" className="flex flex-wrap gap-2 text-sm">
            <Link
              href="/maldives/travel-guide/"
              className={`rounded-full border px-3 py-1 ${!activeCategory ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
            >
              All topics
            </Link>
            {categories.map((category) => (
              <Link
                key={category.slug}
                href={`/maldives/travel-guide/?category=${category.slug}`}
                className={`rounded-full border px-3 py-1 ${activeCategory === category.slug ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
              >
                {category.title}
              </Link>
            ))}
          </nav>
        )}

        {results.items.length === 0 ? (
          <EmptyState title="No articles in this category yet" />
        ) : (
          <ul className="mt-8 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {results.items.map((article) => (
              <ArticleCard key={article.id} article={article} />
            ))}
          </ul>
        )}

        <Pagination
          page={page}
          totalPages={totalPages}
          basePath="/maldives/travel-guide/"
          baseQuery={activeCategory ? `category=${activeCategory}` : undefined}
        />
      </div>
    </main>
  );
}
