import type { Metadata } from "next";
import Link from "next/link";

import { ActivityCard } from "@/components/activity/activity-card";
import { DiveSiteCard } from "@/components/diving/dive-site-card";
import { DiveSitesMap } from "@/components/diving/dive-sites-map-loader";
import { DivingFilterBar } from "@/components/diving/diving-filter-bar";
import { DivingVideo, divingVideoJsonLd } from "@/components/diving/diving-video";
import { PackageCard } from "@/components/packages/package-card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import { PageHero } from "@/components/ui/page-hero";
import { Pagination } from "@/components/ui/pagination";
import { activityHref, type ActivityDifficulty } from "@/lib/activities/types";
import { getArticleBySlug } from "@/lib/articles/repository";
import { articleHref } from "@/lib/articles/types";
import {
  getDiveSites,
  getDivingActivities,
  getDivingActivitiesByType,
  getDivingContentUpdatedAt,
  getDivingTypesInUse,
  searchDivingActivities,
} from "@/lib/diving/repository";
import { getAtollBySlug, getAtolls, getIslandBySlug } from "@/lib/locations/repository";
import { DIVING_HERO_IMAGE } from "@/lib/packages/category-images";
import { filterPackageViews, getAllPackageViews } from "@/lib/packages/view-repository";
import { breadcrumbJsonLd, canonicalUrl, itemListJsonLd } from "@/lib/seo/site";

const DIFFICULTIES: ActivityDifficulty[] = ["beginner", "intermediate", "advanced", "all_levels"];

const PAGE_SIZE = 24;

const FAQS = [
  {
    question: "Do I need a diving certification to dive in the Maldives?",
    answer: "No — Discover Scuba Diving sessions and PADI Open Water courses (see below) are available for complete beginners with no prior certification.",
  },
  {
    question: "What's the difference between a dive site and a diving activity?",
    answer: "A dive site is a physical location — a reef, channel or wreck. A diving activity is a bookable trip or course run by an operator, which may visit one or more sites — see the activities above, and Dive Sites below for the locations themselves.",
  },
  {
    question: "When is the best time to dive in the Maldives?",
    answer: "It varies by region and season — check each dive site's own page for what's known about it, and enquire with the operator running your chosen activity for current conditions.",
  },
  {
    question: "Can I combine diving with a package holiday?",
    answer: "Yes — see Diving Packages below for multi-night holidays that include diving, or enquire on any package to ask about adding a dive.",
  },
];

function faqJsonLd() {
  return {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: FAQS.map((faq) => ({ "@type": "Question", name: faq.question, acceptedAnswer: { "@type": "Answer", text: faq.answer } })),
  };
}

export interface DivingDirectorySearchParams {
  q?: string;
  page?: string;
  type?: string;
  atoll?: string;
  island?: string;
  difficulty?: string;
  maxPrice?: string;
}

function hasAnyFilter(sp: DivingDirectorySearchParams): boolean {
  return Boolean(sp.q || sp.type || sp.atoll || sp.island || sp.difficulty || sp.maxPrice);
}

export async function divingDirectoryMetadata(searchParams: Promise<DivingDirectorySearchParams>): Promise<Metadata> {
  const sp = await searchParams;
  // Real, live-counted total — never a hand-set number that can go stale,
  // since this route has no revalidate/ISR cache and re-runs every request.
  const { total: diveSiteTotal } = await getDiveSites({ pageSize: 1 });
  const year = new Date().getFullYear();
  const title =
    diveSiteTotal > 0
      ? `Maldives Diving ${year} | ${diveSiteTotal} Dive Sites, Trips & Packages`
      : "Maldives Diving | Dive Trips, Packages & Dive Sites";
  const description = "Real, source-verified Maldives diving activities, dive centers, dive sites and diving packages — search by type, location and provider.";
  const url = canonicalUrl("/maldives/diving");

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
    robots: hasAnyFilter(sp) ? { index: false, follow: true } : undefined,
  };
}

export async function DivingDirectoryPage({
  searchParams,
}: {
  searchParams: Promise<DivingDirectorySearchParams>;
}) {
  const sp = await searchParams;
  const page = Math.max(1, Number(sp.page) || 1);
  const query = sp.q?.trim() ?? "";
  const isSearching = query.length > 0;

  const [atoll, island, atolls, divingTypes, diveSites, allPackages, divingArticle, contentUpdatedAt] = await Promise.all([
    sp.atoll ? getAtollBySlug(sp.atoll) : Promise.resolve(null),
    sp.island ? getIslandBySlug(sp.island) : Promise.resolve(null),
    getAtolls(),
    getDivingTypesInUse(),
    getDiveSites({ pageSize: 12 }),
    getAllPackageViews(),
    getArticleBySlug("best-maldives-diving-spots-ultimate-guide"),
    getDivingContentUpdatedAt(),
  ]);
  const divingPackages = filterPackageViews(allPackages, { category: "diving" });

  const activeType = sp.type ? divingTypes.find((t) => t.slug === sp.type) : undefined;
  const difficulty = DIFFICULTIES.includes(sp.difficulty as ActivityDifficulty) ? (sp.difficulty as ActivityDifficulty) : undefined;
  const maxPrice = sp.maxPrice ? Number(sp.maxPrice) : undefined;
  const locationOptions = { atollId: island ? undefined : atoll?.id, locationId: island?.id };
  const filterOptions = { ...locationOptions, difficulty, maxPriceFrom: maxPrice };

  const results = isSearching
    ? { items: await searchDivingActivities(query, { limit: 100 }), total: 0, page: 1, pageSize: 100 }
    : activeType
      ? await getDivingActivitiesByType(activeType.slug, { page, pageSize: PAGE_SIZE, ...filterOptions })
      : await getDivingActivities({ page, pageSize: PAGE_SIZE, ...filterOptions });

  const totalPages = isSearching ? 1 : Math.max(1, Math.ceil(results.total / PAGE_SIZE));

  const baseParams = new URLSearchParams();
  if (sp.type) baseParams.set("type", sp.type);
  if (sp.atoll) baseParams.set("atoll", sp.atoll);
  if (sp.island) baseParams.set("island", sp.island);
  if (difficulty) baseParams.set("difficulty", difficulty);
  if (maxPrice !== undefined) baseParams.set("maxPrice", String(maxPrice));
  const baseQuery = baseParams.toString();

  return (
    <main>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbJsonLd([{ label: "Maldives", href: "/maldives/" }, { label: "Diving" }], "/maldives/diving")) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd()) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(divingVideoJsonLd()) }} />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(
            itemListJsonLd(
              results.items.map((a) => ({ title: a.title, href: activityHref(a), summary: a.summary })),
              "Service",
            ),
          ),
        }}
      />

      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Diving" }]}
        eyebrow="Maldives diving"
        title="Maldives Diving"
        description="Real, individually verified diving activities, dive sites and diving packages — sourced from official operator and resort information rather than a generic directory."
        image={DIVING_HERO_IMAGE}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        <section className="prose-sm max-w-none text-sm text-neutral-700">
          <p>
            The Maldives is one of the world&rsquo;s best-known diving destinations — warm water year-round, real visibility, and reef systems
            spanning thila (submerged pinnacles), kandu (channels) and wall dives across the country&rsquo;s atolls. Whether you&rsquo;re
            starting with a Discover Scuba Diving session, working toward a PADI Open Water certification, or already certified and looking
            for a specific site, the activities and dive sites below are real, individually sourced entries — not a generic stock listing.
          </p>
        </section>

        <section className="mt-8 rounded-2xl border border-neutral-200 bg-sand-50 p-6">
          <h2 className="text-lg font-semibold text-ocean-900">Maldives Diving: Essential Information</h2>
          <dl className="mt-4 grid grid-cols-1 gap-4 text-sm sm:grid-cols-2">
            <div>
              <dt className="text-neutral-500">Water temperature</dt>
              <dd className="font-medium">26–30°C (79–86°F) year-round</dd>
            </div>
            <div>
              <dt className="text-neutral-500">Visibility</dt>
              <dd className="font-medium">15–40+ meters (50–130+ feet)</dd>
            </div>
            <div>
              <dt className="text-neutral-500">Northeast monsoon (Dec–Apr)</dt>
              <dd className="mt-1">
                Best visibility in the eastern atolls, calmer seas — manta cleaning stations (Jan–Apr) and hammerhead sharks in Rasdhoo Atoll
                (early morning).
              </dd>
            </div>
            <div>
              <dt className="text-neutral-500">Southwest monsoon (May–Nov)</dt>
              <dd className="mt-1">
                Stronger currents bring more pelagic species — manta rays gather at Hanifaru Bay (Jul–Nov), and whale sharks are regularly
                sighted in South Ari Atoll year-round.
              </dd>
            </div>
          </dl>
          {divingArticle && (
            <p className="mt-4 text-sm text-neutral-700">
              For a full site-by-site breakdown — depth, currents and marine life at named dive sites across every atoll — read{" "}
              <Link href={articleHref(divingArticle)} className="font-medium text-maldives-600 hover:underline">
                {divingArticle.title}
              </Link>
              .
            </p>
          )}
        </section>

        <p className="mt-6 text-sm text-neutral-600">
          See{" "}
          <Link href="/maldives/activities/" className="underline">
            all activities
          </Link>{" "}
          for other things to do.
        </p>

        {(atoll || island) && (
          <p className="mt-3 text-sm text-neutral-600">
            Filtered to {island ? island.title : atoll?.title}.{" "}
            <Link href="/maldives/diving/" className="underline">
              Clear
            </Link>
          </p>
        )}

        <div className="mt-6">
          <DivingFilterBar
            basePath="/maldives/diving/"
            currentParams={baseParams}
            divingTypes={divingTypes}
            activeType={activeType}
            atolls={atolls}
            activeAtoll={sp.atoll}
            activeDifficulty={difficulty}
            maxPrice={sp.maxPrice ?? ""}
            query={query}
            resultCount={isSearching ? results.items.length : results.total}
          />
        </div>

        {results.items.length === 0 ? (
          <EmptyState title="No diving activities recorded for this filter yet" />
        ) : (
          <ul className="mt-8 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {results.items.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        )}

        {!isSearching && <Pagination page={page} totalPages={totalPages} basePath="/maldives/diving/" baseQuery={baseQuery} />}

        {diveSites.items.length > 0 && (
          <section className="mt-12">
            <h2 className="text-xl font-semibold text-ocean-900">Dive sites</h2>
            <p className="mt-1 text-sm text-neutral-600">
              Physical dive sites — not bookable themselves; see the operators above for trips that visit them.
            </p>
            <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {diveSites.items.map((site) => (
                <DiveSiteCard key={site.id} site={site} />
              ))}
            </ul>
            <Link href="/maldives/dive-sites/" className="mt-4 inline-block text-sm font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
              View all dive sites →
            </Link>

            <DiveSitesMap sites={diveSites.items} />
          </section>
        )}

        {divingPackages.length > 0 && (
          <section className="mt-12 border-t border-neutral-200 pt-10">
            <div className="flex flex-wrap items-baseline justify-between gap-2">
              <h2 className="text-xl font-semibold text-ocean-900">Maldives Diving Packages</h2>
              <Link href="/maldives/packages/diving/" className="text-sm font-medium text-maldives-600 hover:underline">
                See all diving packages ({divingPackages.length}) →
              </Link>
            </div>
            <ul className="mt-4 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
              {divingPackages.slice(0, 6).map((pkg) => (
                <PackageCard key={pkg.slug} pkg={pkg} />
              ))}
            </ul>
          </section>
        )}

        <DivingVideo />

        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Diving Guides</h2>
          {divingArticle ? (
            <p className="mt-2 text-sm text-neutral-700">
              <Link href={articleHref(divingArticle)} className="text-maldives-600 hover:underline">
                {divingArticle.title}
              </Link>{" "}
              — {divingArticle.summary}
            </p>
          ) : (
            <p className="mt-2 text-sm text-neutral-700">
              Browse our{" "}
              <Link href="/maldives/travel-guide/" className="text-maldives-600 hover:underline">
                Travel Guide
              </Link>{" "}
              for more Maldives planning content.
            </p>
          )}
        </section>

        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Explore More Maldives</h2>
          <nav aria-label="Related Maldives links" className="mt-4 flex flex-wrap gap-2">
            {[
              { href: "/maldives/fishing/", label: "Fishing" },
              { href: "/maldives/surfing/", label: "Surfing" },
              { href: "/maldives/activities/", label: "All Activities" },
              { href: "/maldives/packages/", label: "All Packages" },
              { href: "/maldives/packages/diving/", label: "Diving Packages" },
              { href: "/maldives/resorts/", label: "Resorts" },
              { href: "/maldives/travel-guide/", label: "Travel Guide" },
            ].map((link) => (
              <Link key={link.href} href={link.href} className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
                {link.label}
              </Link>
            ))}
          </nav>
        </section>

        <section className="mt-12 border-t border-neutral-200 pt-10">
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

        <p className="mt-10 text-xs text-neutral-500">
          Diving activities and dive sites on this page are sourced from official operator and resort information.
          {contentUpdatedAt &&
            ` Content last updated ${new Date(contentUpdatedAt).toLocaleDateString("en-US", { month: "long", day: "numeric", year: "numeric" })}.`}
        </p>
      </div>
    </main>
  );
}
