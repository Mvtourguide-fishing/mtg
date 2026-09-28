import type { Metadata } from "next";
import Link from "next/link";

import { PackageCard } from "@/components/packages/package-card";
import { PackageFilterBar } from "@/components/packages/package-filter-bar";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import { PageHero } from "@/components/ui/page-hero";
import { Pagination } from "@/components/ui/pagination";
import { PACKAGE_CATEGORY_FALLBACK_IMAGES } from "@/lib/packages/category-images";
import { isPackageCategorySlug } from "@/lib/packages/view";
import {
  filterPackageViews,
  getAllPackageViews,
  getFeaturedPackageViews,
  getPackageAtollsInUse,
  getPackageCategoryCounts,
  getPackageDurationBandCounts,
  sortPackageViews,
} from "@/lib/packages/view-repository";
import type { PackageDurationBandSlug, PackageSortOption } from "@/lib/packages/view-types";
import { PACKAGE_CATEGORIES, PACKAGE_DURATION_BANDS } from "@/lib/packages/view-types";
import { breadcrumbJsonLd, canonicalUrl } from "@/lib/seo/site";

const PAGE_SIZE = 24;

const SORT_OPTIONS: PackageSortOption[] = ["recommended", "price-asc", "price-desc", "shortest", "longest", "rating", "newest"];

const FAQS = [
  {
    question: "How many nights should I spend in the Maldives?",
    answer: "Most first-time visitors spend 5–7 nights. Shorter trips (3–4 nights) suit a quick resort escape; long-stay packages (10+ nights) suit travelers combining a resort and a local island, or wanting genuine downtime.",
  },
  {
    question: "Are Maldives packages inclusive of airport transfers?",
    answer: "It varies by package — check the Included section on each package's own page. Most resort-based packages include a speedboat or seaplane transfer; local-island packages usually use the public ferry.",
  },
  {
    question: "Are Maldives holiday packages available for families?",
    answer: "Yes — see our Family Packages category for options built around family-friendly resorts and local islands with real activities on record.",
  },
  {
    question: "Can I customize a Maldives package?",
    answer: "Yes — every package's enquiry form lets you note your preferred dates and any changes. We confirm what's actually possible before you book, real availability permitting.",
  },
  {
    question: "Can I combine multiple islands in one trip?",
    answer: "Yes — see our Island Hopping-style packages, or enquire about combining a resort stay with a local island on any package.",
  },
  {
    question: "Are flights included in package prices?",
    answer: "No — international flights to Velana International Airport are never included in any package price on this site; see each package's Excluded section.",
  },
  {
    question: "Can I add diving or fishing to any package?",
    answer: "Often, yes — enquire on the package you're interested in and mention the activity; we'll check real availability with the relevant operator.",
  },
  {
    question: "Can I request a private speedboat instead of a shared transfer?",
    answer: "Yes — see Private Speedboat Charter for our own fleet, available alongside any package.",
  },
];

export interface PackageDirectorySearchParams {
  q?: string;
  page?: string;
  category?: string;
  atoll?: string;
  duration?: string;
  minPrice?: string;
  maxPrice?: string;
  minRating?: string;
  sort?: string;
}

function hasAnyFilter(sp: PackageDirectorySearchParams): boolean {
  return Boolean(sp.q || sp.category || sp.atoll || sp.duration || sp.minPrice || sp.maxPrice || sp.minRating);
}

export async function packageDirectoryMetadata(searchParams: Promise<PackageDirectorySearchParams>): Promise<Metadata> {
  const sp = await searchParams;
  const title = "Maldives Packages | Holiday, Vacation & Travel Packages";
  const description =
    "Real Maldives holiday, honeymoon, family, diving, fishing, surfing, luxury and budget packages — search by destination, filter by duration, price and category, and enquire directly.";
  const url = canonicalUrl("/maldives/packages");

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
    robots: hasAnyFilter(sp) ? { index: false, follow: true } : undefined,
  };
}

function faqJsonLd() {
  return {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: FAQS.map((faq) => ({ "@type": "Question", name: faq.question, acceptedAnswer: { "@type": "Answer", text: faq.answer } })),
  };
}

export async function PackageDirectoryPage({ searchParams }: { searchParams: Promise<PackageDirectorySearchParams> }) {
  const sp = await searchParams;
  const page = Math.max(1, Number(sp.page) || 1);
  const query = sp.q?.trim() ?? "";
  const sort: PackageSortOption = SORT_OPTIONS.includes(sp.sort as PackageSortOption) ? (sp.sort as PackageSortOption) : "recommended";
  const activeCategory = sp.category && isPackageCategorySlug(sp.category) ? sp.category : undefined;
  const activeDuration = PACKAGE_DURATION_BANDS.some((b) => b.slug === sp.duration) ? (sp.duration as PackageDurationBandSlug) : undefined;

  const [allViews, categoryCounts, atolls, durationCounts, featured] = await Promise.all([
    getAllPackageViews(),
    getPackageCategoryCounts(),
    getPackageAtollsInUse(),
    getPackageDurationBandCounts(),
    getFeaturedPackageViews(6),
  ]);

  const filtered = filterPackageViews(allViews, {
    q: query || undefined,
    category: activeCategory,
    atollSlug: sp.atoll,
    duration: activeDuration,
    minPrice: sp.minPrice ? Number(sp.minPrice) : undefined,
    maxPrice: sp.maxPrice ? Number(sp.maxPrice) : undefined,
    minRating: sp.minRating ? Number(sp.minRating) : undefined,
  });
  const sorted = sortPackageViews(filtered, sort);
  const totalPages = Math.max(1, Math.ceil(sorted.length / PAGE_SIZE));
  const pageItems = sorted.slice((page - 1) * PAGE_SIZE, page * PAGE_SIZE);

  const currentParams = new URLSearchParams();
  if (query) currentParams.set("q", query);
  if (activeCategory) currentParams.set("category", activeCategory);
  if (sp.atoll) currentParams.set("atoll", sp.atoll);
  if (activeDuration) currentParams.set("duration", activeDuration);
  if (sp.minPrice) currentParams.set("minPrice", sp.minPrice);
  if (sp.maxPrice) currentParams.set("maxPrice", sp.maxPrice);
  if (sp.minRating) currentParams.set("minRating", sp.minRating);
  if (sort !== "recommended") currentParams.set("sort", sort);
  const baseQuery = currentParams.toString();

  return (
    <main>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbJsonLd([{ label: "Maldives", href: "/maldives/" }, { label: "Packages" }], "/maldives/packages")) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd()) }} />

      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Packages" }]}
        eyebrow="Maldives holidays"
        title="Maldives Holiday Packages"
        description="Discover Maldives holiday, honeymoon, family, diving, fishing, surfing, luxury and budget packages — search, filter, and enquire directly."
        image={PACKAGE_CATEGORY_FALLBACK_IMAGES.mainHub}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        <PackageFilterBar
          basePath="/maldives/packages/"
          currentParams={currentParams}
          categoryCounts={categoryCounts}
          activeCategory={activeCategory}
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
          resultLabel={`Maldives package${sorted.length === 1 ? "" : "s"}`}
        />

        {pageItems.length === 0 ? (
          <EmptyState title="No packages match your selected filters." description="Try clearing a filter or searching a different term." />
        ) : (
          <ul className="mt-6 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
            {pageItems.map((pkg) => (
              <PackageCard key={pkg.slug} pkg={pkg} />
            ))}
          </ul>
        )}

        <Pagination page={page} totalPages={totalPages} basePath="/maldives/packages/" baseQuery={baseQuery} />

        {!hasAnyFilter(sp) && (
          <>
            <section className="mt-14 border-t border-neutral-200 pt-10">
              <h2 className="text-xl font-semibold text-ocean-900">Featured Maldives Packages</h2>
              <ul className="mt-4 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
                {featured.map((pkg) => (
                  <PackageCard key={pkg.slug} pkg={pkg} />
                ))}
              </ul>
            </section>

            <section className="mt-14 border-t border-neutral-200 pt-10">
              <h2 className="text-xl font-semibold text-ocean-900">Browse Packages by Travel Style</h2>
              <div className="mt-4 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
                {PACKAGE_CATEGORIES.filter((c) => (categoryCounts.get(c.slug) ?? 0) > 0).map((c) => (
                  <Link
                    key={c.slug}
                    href={`/maldives/packages/${c.slug}/`}
                    className="rounded-2xl border border-neutral-200 p-4 text-center transition-colors hover:border-maldives-500 hover:bg-maldives-50"
                  >
                    <span className="font-medium text-ocean-900">{c.title}</span>
                    <span className="mt-1 block text-xs text-neutral-500">{categoryCounts.get(c.slug)} package{categoryCounts.get(c.slug) === 1 ? "" : "s"}</span>
                  </Link>
                ))}
              </div>
            </section>

            <section className="mt-14 border-t border-neutral-200 pt-10">
              <h2 className="text-xl font-semibold text-ocean-900">Popular Package Durations</h2>
              <nav aria-label="Browse by duration" className="mt-4 flex flex-wrap gap-2">
                {PACKAGE_DURATION_BANDS.filter((b) => (durationCounts.get(b.slug) ?? 0) > 0).map((b) => (
                  <Link
                    key={b.slug}
                    href={`/maldives/packages/?duration=${b.slug}`}
                    className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600"
                  >
                    {b.label} ({durationCounts.get(b.slug)})
                  </Link>
                ))}
              </nav>
            </section>

            {atolls.length > 0 && (
              <section className="mt-14 border-t border-neutral-200 pt-10">
                <h2 className="text-xl font-semibold text-ocean-900">Packages by Destination</h2>
                <nav aria-label="Browse by destination" className="mt-4 flex flex-wrap gap-2">
                  {atolls.map((atoll) => (
                    <Link
                      key={atoll.slug}
                      href={`/maldives/packages/?atoll=${atoll.slug}`}
                      className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600"
                    >
                      {atoll.title}
                    </Link>
                  ))}
                </nav>
              </section>
            )}

            <section className="mt-14 border-t border-neutral-200 pt-10">
              <h2 className="text-xl font-semibold text-ocean-900">Maldives Package Guide</h2>
              <dl className="mt-4 grid grid-cols-1 gap-6 sm:grid-cols-2">
                <div>
                  <dt className="font-medium text-ocean-900">Resort island vs. local island</dt>
                  <dd className="mt-1 text-sm text-neutral-700">A resort island is a single private property with an all-inclusive feel; a local island (like Maafushi or Ukulhas) is a genuine Maldivian community with independent guesthouses, at a fraction of resort prices.</dd>
                </div>
                <div>
                  <dt className="font-medium text-ocean-900">Budget considerations</dt>
                  <dd className="mt-1 text-sm text-neutral-700">Local-island packages run from roughly USD 150–250/night; resort packages vary widely, from mid-range to several thousand dollars a night at the top end.</dd>
                </div>
                <div>
                  <dt className="font-medium text-ocean-900">Planning a honeymoon</dt>
                  <dd className="mt-1 text-sm text-neutral-700">Overwater villas, adult-focused resorts, and private dining are the usual honeymoon staples — see our Honeymoon Packages for real options.</dd>
                </div>
                <div>
                  <dt className="font-medium text-ocean-900">Traveling with family</dt>
                  <dd className="mt-1 text-sm text-neutral-700">Look for resorts close to the airport (shorter transfer with kids) and a real range of family activities on record — see our Family Packages.</dd>
                </div>
                <div>
                  <dt className="font-medium text-ocean-900">Diving holidays</dt>
                  <dd className="mt-1 text-sm text-neutral-700">Both resort dive centres and local-island operators run real courses and guided dives — see our Diving Packages, or Liveaboard Packages for a multi-site week aboard a dive vessel.</dd>
                </div>
                <div>
                  <dt className="font-medium text-ocean-900">Fishing and surfing holidays</dt>
                  <dd className="mt-1 text-sm text-neutral-700">Sunset, night and big-game fishing trips, and genuine surf breaks near islands like Thulusdhoo, are all real, bookable activities — see Fishing and Surfing Packages.</dd>
                </div>
              </dl>
            </section>
          </>
        )}

        <section className="mt-14 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Frequently Asked Questions</h2>
          <dl className="mt-4 space-y-6">
            {FAQS.map((faq) => (
              <div key={faq.question}>
                <dt className="font-medium text-ocean-900">{faq.question}</dt>
                <dd className="mt-1 text-sm text-neutral-700">{faq.answer}</dd>
              </div>
            ))}
          </dl>
        </section>
      </div>
    </main>
  );
}
