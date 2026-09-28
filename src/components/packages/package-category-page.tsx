import type { Metadata } from "next";
import Link from "next/link";

import { PackageCard } from "@/components/packages/package-card";
import { PackageFilterBar } from "@/components/packages/package-filter-bar";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import { PageHero } from "@/components/ui/page-hero";
import { Pagination } from "@/components/ui/pagination";
import { PACKAGE_CATEGORY_CONTENT } from "@/lib/packages/category-content";
import { PACKAGE_CATEGORY_FALLBACK_IMAGES, type PackageCategoryFallbackKey } from "@/lib/packages/category-images";
import {
  filterPackageViews,
  getAllPackageViews,
  getPackageAtollsInUse,
  getPackageCategoryCounts,
  getPackageDurationBandCounts,
  sortPackageViews,
} from "@/lib/packages/view-repository";
import type { PackageCategorySlug, PackageDurationBandSlug, PackageSortOption } from "@/lib/packages/view-types";
import { PACKAGE_CATEGORY_TITLE, PACKAGE_DURATION_BANDS } from "@/lib/packages/view-types";
import { breadcrumbJsonLd, canonicalUrl } from "@/lib/seo/site";

const PAGE_SIZE = 24;
const SORT_OPTIONS: PackageSortOption[] = ["recommended", "price-asc", "price-desc", "shortest", "longest", "rating", "newest"];

/** Maps a package category slug to its fallback hero image key — most
 * overlap 1:1 with category-images.ts; the two without a dedicated real
 * image (long-stay, solo) fall back to a genuinely close real photo. */
const CATEGORY_IMAGE_KEY: Record<PackageCategorySlug, PackageCategoryFallbackKey> = {
  luxury: "luxury",
  family: "family",
  "adults-only": "adultsOnly",
  "long-stay": "luxury",
  budget: "budget",
  honeymoon: "honeymoon",
  solo: "budget",
  diving: "diving",
  fishing: "fishing",
  surfing: "surfing",
  liveaboard: "liveaboard",
};

export interface PackageCategoryPageSearchParams {
  q?: string;
  page?: string;
  atoll?: string;
  duration?: string;
  minPrice?: string;
  maxPrice?: string;
  minRating?: string;
  sort?: string;
}

function hasAnyFilter(sp: PackageCategoryPageSearchParams): boolean {
  return Boolean(sp.q || sp.atoll || sp.duration || sp.minPrice || sp.maxPrice || sp.minRating);
}

export async function packageCategoryMetadata(category: PackageCategorySlug, searchParams: Promise<PackageCategoryPageSearchParams>): Promise<Metadata> {
  const sp = await searchParams;
  const content = PACKAGE_CATEGORY_CONTENT[category];
  const url = canonicalUrl(`/maldives/packages/${category}`);

  return {
    title: content.metaTitle,
    description: content.metaDescription,
    alternates: { canonical: url },
    openGraph: { title: content.metaTitle, description: content.metaDescription, url },
    robots: hasAnyFilter(sp) ? { index: false, follow: true } : undefined,
  };
}

function faqJsonLd(faqs: Array<{ question: string; answer: string }>) {
  return {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: faqs.map((faq) => ({ "@type": "Question", name: faq.question, acceptedAnswer: { "@type": "Answer", text: faq.answer } })),
  };
}

export async function PackageCategoryPage({
  category,
  searchParams,
}: {
  category: PackageCategorySlug;
  searchParams: Promise<PackageCategoryPageSearchParams>;
}) {
  const sp = await searchParams;
  const page = Math.max(1, Number(sp.page) || 1);
  const query = sp.q?.trim() ?? "";
  const sort: PackageSortOption = SORT_OPTIONS.includes(sp.sort as PackageSortOption) ? (sp.sort as PackageSortOption) : "recommended";
  const activeDuration = PACKAGE_DURATION_BANDS.some((b) => b.slug === sp.duration) ? (sp.duration as PackageDurationBandSlug) : undefined;
  const content = PACKAGE_CATEGORY_CONTENT[category];

  const [allViews, categoryCounts, atolls, durationCounts] = await Promise.all([
    getAllPackageViews(),
    getPackageCategoryCounts(),
    getPackageAtollsInUse(),
    getPackageDurationBandCounts(),
  ]);

  const filtered = filterPackageViews(allViews, {
    q: query || undefined,
    category,
    atollSlug: sp.atoll,
    duration: activeDuration,
    minPrice: sp.minPrice ? Number(sp.minPrice) : undefined,
    maxPrice: sp.maxPrice ? Number(sp.maxPrice) : undefined,
    minRating: sp.minRating ? Number(sp.minRating) : undefined,
  });
  const sorted = sortPackageViews(filtered, sort);
  const totalPages = Math.max(1, Math.ceil(sorted.length / PAGE_SIZE));
  const pageItems = sorted.slice((page - 1) * PAGE_SIZE, page * PAGE_SIZE);

  const basePath = `/maldives/packages/${category}/`;
  const currentParams = new URLSearchParams();
  if (query) currentParams.set("q", query);
  if (sp.atoll) currentParams.set("atoll", sp.atoll);
  if (activeDuration) currentParams.set("duration", activeDuration);
  if (sp.minPrice) currentParams.set("minPrice", sp.minPrice);
  if (sp.maxPrice) currentParams.set("maxPrice", sp.maxPrice);
  if (sp.minRating) currentParams.set("minRating", sp.minRating);
  if (sort !== "recommended") currentParams.set("sort", sort);
  const baseQuery = currentParams.toString();

  return (
    <main>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(
            breadcrumbJsonLd([{ label: "Maldives", href: "/maldives/" }, { label: "Packages", href: "/maldives/packages/" }, { label: PACKAGE_CATEGORY_TITLE[category] }], `/maldives/packages/${category}`),
          ),
        }}
      />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd(content.faqs)) }} />

      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Packages", href: "/maldives/packages/" }, { label: PACKAGE_CATEGORY_TITLE[category] }]}
        eyebrow="Maldives packages"
        title={PACKAGE_CATEGORY_TITLE[category]}
        description={content.intro}
        image={PACKAGE_CATEGORY_FALLBACK_IMAGES[CATEGORY_IMAGE_KEY[category]]}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        <PackageFilterBar
          basePath={basePath}
          currentParams={currentParams}
          showCategoryFilter={false}
          categoryCounts={categoryCounts}
          activeCategory={category}
          atolls={atolls}
          activeAtoll={sp.atoll}
          durationCounts={durationCounts}
          activeDuration={activeDuration}
          minPrice={sp.minPrice ?? ""}
          maxPrice={sp.maxPrice ?? ""}
          minRating={sp.minRating ?? ""}
          query={query}
          sort={sort}
          resultCount={sorted.length}
          resultLabel={`${PACKAGE_CATEGORY_TITLE[category]}`}
        />

        {pageItems.length === 0 ? (
          <EmptyState title={`No ${PACKAGE_CATEGORY_TITLE[category].toLowerCase()} match your selected filters yet.`} description="Try clearing a filter, or browse all Maldives packages." />
        ) : (
          <ul className="mt-6 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
            {pageItems.map((pkg) => (
              <PackageCard key={pkg.slug} pkg={pkg} />
            ))}
          </ul>
        )}

        <Pagination page={page} totalPages={totalPages} basePath={basePath} baseQuery={baseQuery} />

        <section className="mt-14 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Frequently Asked Questions</h2>
          <dl className="mt-4 space-y-6">
            {content.faqs.map((faq) => (
              <div key={faq.question}>
                <dt className="font-medium text-ocean-900">{faq.question}</dt>
                <dd className="mt-1 text-sm text-neutral-700">{faq.answer}</dd>
              </div>
            ))}
          </dl>
        </section>

        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Related Maldives Links</h2>
          <nav aria-label="Related links" className="mt-4 flex flex-wrap gap-2">
            {[{ href: "/maldives/packages/", label: "All Maldives Packages" }, ...content.relatedLinks].map((link) => (
              <Link key={link.href} href={link.href} className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
                {link.label}
              </Link>
            ))}
          </nav>
        </section>
      </div>
    </main>
  );
}
