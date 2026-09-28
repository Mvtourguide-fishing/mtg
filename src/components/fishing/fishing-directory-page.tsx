import type { Metadata } from "next";
import { unstable_cache } from "next/cache";
import Link from "next/link";

import { ActivityCard } from "@/components/activity/activity-card";
import { ArticleCard } from "@/components/articles/article-card";
import { fishingDurationBucketToMinutes, FishingFilterBar, isFishingDurationBucket } from "@/components/fishing/fishing-filter-bar";
import { FishingGallerySection } from "@/components/fishing/fishing-gallery-section";
import { FishingVideo, fishingVideoJsonLd } from "@/components/fishing/fishing-video";
import { FishSpeciesSection } from "@/components/fishing/fish-species-section";
import { PackageCard } from "@/components/packages/package-card";
import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import { MediaImage } from "@/components/ui/media-image";
import { PageHero } from "@/components/ui/page-hero";
import { Pagination } from "@/components/ui/pagination";
import { activityHref } from "@/lib/activities/types";
import { getArticleBySlug } from "@/lib/articles/repository";
import {
  getFishingActivities,
  getFishingActivitiesByType,
  getFishingActivityBySlug,
  getFishingTypesInUse,
  searchFishingActivities,
} from "@/lib/fishing/repository";
import { getAtollBySlug, getAtolls, getIslandBySlug } from "@/lib/locations/repository";
import { FISHING_HERO_IMAGE } from "@/lib/packages/category-images";
import { filterPackageViews, getAllPackageViews } from "@/lib/packages/view-repository";
import { getProviderBySlug } from "@/lib/providers/repository";
import { breadcrumbJsonLd, canonicalUrl, itemListJsonLd } from "@/lib/seo/site";

const PAGE_SIZE = 24;

const CHARTER_SLUGS = [
  "private-full-day-fishing-charter",
  "private-half-day-fishing-charter",
  "fly-fishing-full-day-charter",
  "fly-fishing-half-day-charter",
];

// Real Travel Guide articles tagged under the "Fishing" article-category
// (see supabase/migrations/20250127000100_fishing_guide_articles.sql).
const GUIDE_SLUGS = [
  "maldives-fishing-seasons-month-by-month-guide",
  "maldives-fishing-techniques-guide",
  "gaafu-atoll-fishing-guide-mfh-maamendhoo",
];

// Real providers already on record for fishing trips in this dataset
// (data/maldives/fishing/SOURCES.md + SOURCES-mfh.md) — never invented.
const OPERATOR_SLUGS = [
  "maldives-fishing-and-holiday",
  "active-watersports-maafushi",
  "kaani-hotels",
  "icom-tours",
  "knight-at-sea",
  "universal-resorts",
  "soneva-management-bvi-limited",
];

const FISHING_TYPE_CONTENT: Record<string, { title: string; body: string }> = {
  "big-game-fishing": {
    title: "Big Game Fishing",
    body: "Trolling lures at speed for large pelagic species — tuna, wahoo, sailfish, marlin — usually a half-day or full-day trip further offshore. Several resort-run and independent trips on record are tagged big game fishing below.",
  },
  "sport-fishing": {
    title: "Sport Fishing",
    body: "A broader private-charter style trip, often targeting whatever's running that day rather than one specific technique — closest in spirit to MFH's own full-day and half-day private charters.",
  },
  "reef-fishing": {
    title: "Reef Fishing",
    body: "Bottom and light-tackle fishing over the reef itself, usually calmer and closer to shore than a big-game run — a good option for a shorter trip or less experienced anglers.",
  },
  "handline-fishing": {
    title: "Handline (Traditional) Fishing",
    body: "The traditional Maldivian method — reel, line, hook and bait, no rod required — taught to guests with no experience needed. Usually the base technique on a sunset fishing trip.",
  },
  "night-fishing": {
    title: "Night Fishing",
    body: "After-dark trips targeting different species than daytime fishing, often paired with a sunset departure. A genuinely different experience from a standard sunset trip, not just the same thing later.",
  },
  "traditional-fishing": {
    title: "Traditional Fishing",
    body: "Multi-technique trips run by local fishermen or resort dhonis, sometimes spanning several traditional methods in one outing rather than one specific style.",
  },
  "fly-fishing": {
    title: "Fly Fishing",
    body: "Sight-casting a fly to fish on the flats and reef edges rather than trolling or bait fishing — a specialist technique that rewards accurate casting over shallow, clear water. Our own full-day and half-day fly fishing charters run from the same private operation as our general charters; bring your own fly rod and gear.",
  },
};

/**
 * Everything here is identical for every visitor regardless of which
 * filters are in the URL -- unlike `results` further down in
 * FishingDirectoryPage, none of it depends on searchParams. Without
 * caching, a single page view paid for ~30+ separate Supabase round trips
 * (4 charter lookups + 3 guide lookups + 7 operator lookups + one
 * paginated query per fishing technique for the "by technique" preview
 * section, each with its own hero-media/location fan-out underneath) on
 * every single request. Wrapping it in unstable_cache turns that into one
 * shared cache entry, refreshed at most once an hour.
 */
const getFishingSupportingContent = unstable_cache(
  async () => {
    const [atolls, fishingTypes, charters, allPackages, operators, guides] = await Promise.all([
      getAtolls(),
      getFishingTypesInUse(),
      Promise.all(CHARTER_SLUGS.map((slug) => getFishingActivityBySlug(slug))),
      getAllPackageViews(),
      Promise.all(OPERATOR_SLUGS.map((slug) => getProviderBySlug(slug))),
      Promise.all(GUIDE_SLUGS.map((slug) => getArticleBySlug(slug))),
    ]);

    const typesWithActivities = await Promise.all(
      fishingTypes
        .filter((t) => FISHING_TYPE_CONTENT[t.slug])
        .map(async (t) => ({
          type: t,
          content: FISHING_TYPE_CONTENT[t.slug],
          activities: (await getFishingActivitiesByType(t.slug, { pageSize: 3 })).items,
        })),
    );

    return {
      atolls,
      fishingTypes,
      realCharters: charters.filter((c): c is NonNullable<typeof c> => c !== null),
      fishingPackages: filterPackageViews(allPackages, { category: "fishing" }),
      realOperators: operators.filter((p): p is NonNullable<typeof p> => p !== null),
      realGuides: guides.filter((g): g is NonNullable<typeof g> => g !== null),
      typesWithActivities,
    };
  },
  ["fishing-directory-supporting-content"],
  { revalidate: 3600 },
);

export interface FishingDirectorySearchParams {
  q?: string;
  page?: string;
  type?: string;
  atoll?: string;
  island?: string;
  duration?: string;
  maxPrice?: string;
}

function hasAnyFilter(sp: FishingDirectorySearchParams): boolean {
  return Boolean(sp.q || sp.type || sp.atoll || sp.island || sp.duration || sp.maxPrice);
}

export async function fishingDirectoryMetadata(searchParams: Promise<FishingDirectorySearchParams>): Promise<Metadata> {
  const sp = await searchParams;
  const title = "Maldives Fishing | Fishing Charters, Trips & Packages";
  const description =
    "Real Maldives fishing charters, trips and packages — private full-day and half-day charters, big game, reef and traditional fishing, sourced from real operators and a verified rate sheet, not a generic directory.";
  const url = canonicalUrl("/maldives/fishing");

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
    robots: hasAnyFilter(sp) ? { index: false, follow: true } : undefined,
  };
}

const FAQS = [
  {
    question: "What does a private fishing charter in the Maldives cost?",
    answer: "Our own 32-foot private charter starts from USD 980 for a half day or USD 1,380 for a full day, per boat (up to 5 passengers) — see Fishing Charters below for the exact, currently-verified rate.",
  },
  {
    question: "What's the difference between a fishing charter and a fishing package?",
    answer: "A charter is the boat trip itself, for a half or full day. A package bundles a charter with accommodation, meals and transfers for a multi-night stay — see Fishing Packages below.",
  },
  {
    question: "Do I need fishing experience?",
    answer: "No — basic fishing gear and a professional captain and crew are included on every charter on this page, and traditional handline fishing needs no prior experience.",
  },
  {
    question: "What fish can I catch in the Maldives?",
    answer: "It depends on the technique and season — big game trips target tuna, wahoo, sailfish and marlin further offshore; reef and handline trips catch a wider range of reef species closer to shore. See Fishing by Technique below.",
  },
  {
    question: "Can I combine fishing with a resort stay?",
    answer: "Yes — many resorts on this site (see Fishing by Technique and the activities below) run their own fishing trips alongside a normal resort stay, separate from our own dedicated fishing packages.",
  },
  {
    question: "Are prices on this page fixed?",
    answer: "Prices shown are the operator's current verified rate, subject to their own booking conditions — availability, fuel surcharges and operational costs can change rates without notice. Enquire to confirm before booking.",
  },
  {
    question: "Can I catch giant trevally in the Maldives?",
    answer: "Yes — giant trevally are a common target for popping and jigging trips over channel edges and outer reef, including the Gaafu Atoll charters on this page. As with any wild fish, a catch isn't guaranteed on a given day.",
  },
  {
    question: "Is fishing available from local islands, not just resorts?",
    answer: "Yes — several charters on this page, including our own Gaafu Atoll operation, are run from local islands rather than resorts, alongside independent Maafushi-based operators.",
  },
  {
    question: "Do you provide fishing equipment?",
    answer: "Basic fishing gear is included on the private charters on this page. If you have your own preferred rod or reel, you're welcome to bring it — check with the operator when booking.",
  },
];

function faqJsonLd() {
  return {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: FAQS.map((faq) => ({ "@type": "Question", name: faq.question, acceptedAnswer: { "@type": "Answer", text: faq.answer } })),
  };
}

export async function FishingDirectoryPage({
  searchParams,
}: {
  searchParams: Promise<FishingDirectorySearchParams>;
}) {
  const sp = await searchParams;
  const page = Math.max(1, Number(sp.page) || 1);
  const query = sp.q?.trim() ?? "";
  const isSearching = query.length > 0;

  const [atoll, island, supporting] = await Promise.all([
    sp.atoll ? getAtollBySlug(sp.atoll) : Promise.resolve(null),
    sp.island ? getIslandBySlug(sp.island) : Promise.resolve(null),
    getFishingSupportingContent(),
  ]);
  const { atolls, fishingTypes, realCharters, fishingPackages, realOperators, realGuides, typesWithActivities } = supporting;

  const activeType = sp.type ? fishingTypes.find((t) => t.slug === sp.type) : undefined;
  const activeDuration = isFishingDurationBucket(sp.duration) ? sp.duration : undefined;
  const maxPrice = sp.maxPrice?.trim() ?? "";
  const maxPriceFrom = maxPrice && !Number.isNaN(Number(maxPrice)) ? Number(maxPrice) : undefined;
  const filterOptions = {
    atollId: island ? undefined : atoll?.id,
    locationId: island?.id,
    ...fishingDurationBucketToMinutes(activeDuration),
    maxPriceFrom,
  };

  const results = isSearching
    ? {
        items: (await searchFishingActivities(query, { limit: 100 })),
        total: 0,
        page: 1,
        pageSize: 100,
      }
    : activeType
      ? await getFishingActivitiesByType(activeType.slug, { page, pageSize: PAGE_SIZE, ...filterOptions })
      : await getFishingActivities({ page, pageSize: PAGE_SIZE, ...filterOptions });

  const totalPages = isSearching ? 1 : Math.max(1, Math.ceil(results.total / PAGE_SIZE));

  const baseParams = new URLSearchParams();
  if (sp.type) baseParams.set("type", sp.type);
  if (sp.atoll) baseParams.set("atoll", sp.atoll);
  if (sp.island) baseParams.set("island", sp.island);
  if (activeDuration) baseParams.set("duration", activeDuration);
  if (maxPrice) baseParams.set("maxPrice", maxPrice);
  const baseQuery = baseParams.toString();

  return (
    <main>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbJsonLd([{ label: "Maldives", href: "/maldives/" }, { label: "Fishing" }], "/maldives/fishing")) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd()) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(fishingVideoJsonLd()) }} />
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
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Fishing" }]}
        eyebrow="Maldives fishing"
        title="Maldives Fishing"
        description="Real fishing charters, trips and packages — private full-day and half-day charters from a verified operator, plus big game, reef, handline, night and traditional fishing trips from real resort and independent operators across the Maldives."
        image={FISHING_HERO_IMAGE}
        action={
          <div className="flex flex-wrap gap-3">
            <a href="#fishing-charters" className="rounded-full bg-maldives-600 px-5 py-2.5 text-sm font-medium text-white hover:bg-ocean-800">
              Explore Fishing Charters
            </a>
            <a href="#fishing-packages" className="rounded-full border border-white/60 px-5 py-2.5 text-sm font-medium text-white hover:bg-white/10">
              Explore Fishing Packages
            </a>
          </div>
        }
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        {/* All Fishing Activities — the searchable/filterable directory,
            moved to the very top of the page per the site owner's request so
            it's the first thing visitors see, above the intro/SEO content. */}
        <section id="all-fishing-activities" className="scroll-mt-20">
          <h2 className="text-xl font-semibold text-ocean-900">All Fishing Activities</h2>
          <p className="mt-2 text-sm text-neutral-600">
            See{" "}
            <Link href="/maldives/activities/" className="underline">
              all activities
            </Link>{" "}
            for other things to do.
          </p>

          {island && (
            <p className="mt-3 text-sm text-neutral-600">
              Filtered to {island.title}.{" "}
              <Link href="/maldives/fishing/" className="underline">
                Clear
              </Link>
            </p>
          )}

          <div className="mt-6">
            <FishingFilterBar
              basePath="/maldives/fishing/"
              currentParams={baseParams}
              fishingTypes={fishingTypes}
              activeType={activeType}
              atolls={atolls}
              activeAtoll={sp.atoll}
              activeDuration={activeDuration}
              maxPrice={maxPrice}
              query={query}
              resultCount={isSearching ? results.items.length : results.total}
            />
          </div>

          {results.items.length === 0 ? (
            <EmptyState title="No fishing activities recorded for this filter yet" />
          ) : (
            <ul className="mt-8 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {results.items.map((activity) => (
                <ActivityCard key={activity.id} activity={activity} />
              ))}
            </ul>
          )}

          {!isSearching && <Pagination page={page} totalPages={totalPages} basePath="/maldives/fishing/" baseQuery={baseQuery} />}
        </section>

        {/* Intro / SEO content */}
        <section className="mt-12 border-t border-neutral-200 pt-10 prose-sm max-w-none text-sm text-neutral-700">
          <p>
            Fishing has always been part of everyday life in the Maldives, long before tourism — and today it&rsquo;s one of the country&rsquo;s
            most genuine, least commercialized activities. Whether that means a traditional handline sunset trip taught by a local crew, a
            private full-day charter chasing tuna and wahoo further offshore, or a multi-night fishing holiday built entirely around the boat,
            real operators across the Maldives run real, bookable trips — not a generic &ldquo;fishing excursion&rdquo; add-on.
          </p>
          <p>
            This page covers two distinct things travelers search for. A <strong>fishing charter</strong> is the boat trip itself — a half day
            or full day, usually priced per boat rather than per person. A <strong>fishing package</strong> bundles a charter with
            accommodation, meals and transfers into a complete multi-night holiday. Both are represented here with real, currently-verified
            pricing from our own rate sheet (valid until 31 December 2027), alongside individually
            sourced trips from resort dive/watersports centres and independent Maafushi and Malé-area operators.
          </p>
        </section>

        {/* Fishing in the Maldives — geography/context overview, the
            broad-topic coverage a pillar page needs beyond the charter/
            package listings below. */}
        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Fishing in the Maldives</h2>
          <div className="mt-3 space-y-3 text-sm text-neutral-700">
            <p>
              The Maldives is built from 26 natural atolls — rings of reef enclosing shallow lagoons, cut through by
              channels (locally, <em>kandu</em>) where the tide pushes bait and predators between the inner lagoon and
              the open ocean. That structure is what makes the fishing here varied rather than one single thing: reef
              flats and channel mouths for light tackle close to shore, outer reef drop-offs where the coral gives way
              to deep water, and open ocean beyond the atoll rim for trolling further out.
            </p>
            <p>
              Fishing has been part of daily life here for longer than tourism has existed — handline fishing off a
              local dhoni is still how many Maldivian families put food on the table, and it&rsquo;s also the
              technique most sunset trips teach visitors with no prior experience. Sport and big game fishing grew up
              alongside that tradition rather than replacing it, and most operators on this page — resort-based and
              independent — run both styles.
            </p>
          </div>
        </section>

        {/* Best Places for Fishing — atoll overview, deliberately not ranked
            (different atolls suit different styles/species, not a "best"
            vs "worst" list). */}
        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Best Places for Fishing in the Maldives</h2>
          <p className="mt-2 text-sm text-neutral-700">
            Which atoll suits you depends more on where you&rsquo;re staying and what kind of trip you want than any
            single &ldquo;best&rdquo; location — every inhabited atoll has real channels, reef and open ocean access.
          </p>
          <dl className="mt-6 grid grid-cols-1 gap-x-8 gap-y-6 sm:grid-cols-2">
            {[
              { atoll: "kaafu", name: "North & South Malé Atoll", body: "The most accessible fishing base — close to Velana International Airport, with the highest concentration of resort-run charters and independent Maafushi-based operators, covering everything from sunset handline trips to big game charters." },
              { atoll: "alif-alif", name: "Ari Atoll (North)", body: "A large atoll with a deep central lagoon and extensive outer reef, well known among divers for its pelagic life — the same channels that draw manta rays and whale sharks also concentrate baitfish and gamefish." },
              { atoll: "alif-dhaalu", name: "Ari Atoll (South)", body: "The southern half of the same atoll system, with its own set of channels and outer-reef drop-offs — resort-run charters here tend to run the same big game and reef techniques as North Ari." },
              { atoll: "baa", name: "Baa Atoll", body: "A UNESCO Biosphere Reserve, so fishing grounds sit alongside protected marine areas — check with your operator which channels and reefs are open before booking a trip here." },
              { atoll: "vaavu", name: "Vaavu Atoll", body: "One of the least populated atolls, with a reputation among local operators for strong channel currents and productive reef fishing, thanks to relatively light fishing pressure." },
              { atoll: "laamu", name: "Laamu Atoll", body: "A remote southern atoll with its own outer-reef and channel systems, reached by domestic flight rather than speedboat from Malé — fishing here is generally arranged through resort operators." },
              { atoll: "gaafu-alifu", name: "Gaafu Alifu Atoll", body: "Part of the same far-southern atoll pair as Gaafu Dhaalu — see Fishing in Gaafu Atoll below, where our own operation is based." },
              { atoll: "gaafu-dhaalu", name: "Gaafu Dhaalu Atoll", body: "The other half of the Huvadhoo Atoll system — one of the widest, deepest natural atolls in the Maldives, with correspondingly large channels and strong currents." },
              { atoll: "seenu", name: "Addu Atoll", body: "The southernmost atoll, closer to the equator than any other inhabited part of the Maldives, with its own distinct reef and channel system reached by domestic flight." },
            ].map((a) => (
              <div key={a.atoll}>
                <dt className="font-medium text-ocean-900">
                  <Link href={`/maldives/atolls/${a.atoll}/`} className="hover:text-maldives-600 hover:underline">
                    {a.name}
                  </Link>
                </dt>
                <dd className="mt-1 text-sm text-neutral-700">{a.body}</dd>
              </div>
            ))}
          </dl>
        </section>

        {/* Fishing in Gaafu Atoll — the deliberately detailed section, since
            this is real first-hand operating ground (Maldives Fishing and
            Holiday Pvt Ltd, Maamendhoo, Gaafu Alifu Atoll — see
            data/maldives/fishing/SOURCES-mfh.md), not a generic atoll
            writeup. Boats + how-to-get-there are folded in here rather
            than split into their own top-level sections, since both are
            specific to this one operation, not the page's fishing
            directory as a whole. */}
        <section id="gaafu-fishing" className="mt-12 scroll-mt-20 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Fishing in Gaafu Atoll</h2>
          <div className="mt-3 space-y-3 text-sm text-neutral-700">
            <p>
              Gaafu Alifu and Gaafu Dhaalu together form Huvadhoo, one of the widest natural atolls in the world —
              roughly 300&nbsp;km south of Malé, well outside the North/South Malé resort cluster most visitors think
              of first. Fewer resorts means less fishing pressure on the reefs and channels here, and the atoll&rsquo;s
              size means genuinely deep channels between the outer reef and the open ocean.
            </p>
            <p>
              Our own{" "}
              <Link href="/maldives/providers/maldives-fishing-and-holiday/" className="text-maldives-600 hover:underline">
                fishing operation
              </Link>{" "}
              runs out of{" "}
              <Link href="/maldives/islands/maamendhoo-gaafu-alifu/" className="text-maldives-600 hover:underline">
                Maamendhoo, Gaafu Alifu Atoll
              </Link>{" "}
              — real, currently-verified charters and multi-night packages, not a generic listing. Trips from here
              cover popping and jigging over the outer reef and channel edges (giant trevally and dogtooth tuna are
              the usual targets), trolling further out for yellowfin tuna, and reef fishing closer to the island for
              a calmer session.
            </p>
          </div>

          <div className="mt-8">
            <h3 className="text-lg font-semibold text-ocean-900">Our Fishing Boat</h3>
            <p className="mt-2 text-sm text-neutral-700">
              Charters run aboard <strong>Emperor</strong>, a 32-foot fishing boat with twin 200&nbsp;HP engines,
              carrying up to 5 passengers. Basic fishing gear is included on every trip — see{" "}
              <a href="#fishing-charters" className="text-maldives-600 hover:underline">
                Fishing Charters
              </a>{" "}
              below for current rates.
            </p>
          </div>

          <div className="mt-8">
            <h3 className="text-lg font-semibold text-ocean-900">How to Get There</h3>
            <p className="mt-2 text-sm text-neutral-700">
              The route is Velana International Airport → a domestic flight south to Gaafu Alifu Atoll&rsquo;s own
              airport → a boat transfer to Maamendhoo. Exact transfer arrangements and costs are confirmed directly
              with the operator when you book — see{" "}
              <a href="#fishing-packages" className="text-maldives-600 hover:underline">
                Fishing Packages
              </a>{" "}
              below, which bundle accommodation, meals and the return journey together.
            </p>
          </div>
        </section>

        {/* Fishing Charters & Activities — charter cards, technique/operator
            context, and the real operators list. The full searchable
            activities directory itself now lives at the very top of the
            page (#all-fishing-activities, per the site owner's request) —
            this section stays for the charter-specific content around it.
            Fishing Packages stays its own separate section right after. */}
        <section id="fishing-charters" className="mt-12 scroll-mt-20 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Maldives Fishing Charters &amp; Activities</h2>

          {realCharters.length > 0 && (
            <>
              <p className="mt-2 text-sm text-neutral-700">
                Our own private charter, aboard &ldquo;Emperor&rdquo;, a 32-foot fishing boat with twin
                200&nbsp;HP engines (max 5 passengers) — departing from Maamendhoo, Gaafu Alifu Atoll.
              </p>
              <ul className="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
                {realCharters.map((charter) => (
                  <li key={charter.id} className={CARD_CLASS}>
                    {charter.heroImage && (
                      <div className={CARD_IMAGE_BLEED_CLASS}>
                        <MediaImage asset={charter.heroImage} alt={charter.title} aspectClassName="aspect-[4/3]" />
                      </div>
                    )}
                    <Link href={`/maldives/fishing/${charter.slug}/`} className="text-lg font-medium text-ocean-900 hover:text-maldives-600">
                      {charter.title}
                    </Link>
                    <p className="mt-1 text-sm text-neutral-600">{charter.summary}</p>
                    <div className="mt-3 flex flex-wrap gap-x-4 gap-y-1 text-sm text-neutral-700">
                      {charter.maxParticipants && <span>Up to {charter.maxParticipants} passengers</span>}
                      {charter.primaryLocation && <span>{charter.primaryLocation.title}</span>}
                      {charter.provider && <span>Operated by {charter.provider.title}</span>}
                    </div>
                    {charter.priceFrom !== null && (
                      <p className="mt-2 text-lg font-semibold text-ocean-900">
                        From {charter.currency ?? "USD"} {charter.priceFrom}
                        <span className="ml-2 text-sm font-normal text-neutral-500">per boat</span>
                      </p>
                    )}
                    <Link
                      href={`/maldives/fishing/${charter.slug}/`}
                      className="mt-3 inline-flex items-center justify-center rounded-full bg-maldives-600 px-4 py-2 text-sm font-medium text-white hover:bg-ocean-800"
                    >
                      View Charter
                    </Link>
                  </li>
                ))}
              </ul>
            </>
          )}

          {/* Fishing by Technique */}
          {typesWithActivities.length > 0 && (
            <div className="mt-10">
              <h3 className="text-lg font-semibold text-ocean-900">Fishing by Technique</h3>
              <div className="mt-4 grid grid-cols-1 gap-6 sm:grid-cols-2">
                {typesWithActivities.map(({ type, content, activities }) => (
                  <div key={type.id}>
                    <h4 className="font-medium text-ocean-900">{content.title}</h4>
                    <p className="mt-1 text-sm text-neutral-700">{content.body}</p>
                    {activities.length > 0 && (
                      <ul className="mt-2 flex flex-wrap gap-2">
                        {activities.map((a) => (
                          <li key={a.id}>
                            <Link href={`/maldives/fishing/${a.slug}/`} className="rounded-full border border-neutral-300 px-3 py-1 text-xs text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
                              {a.title}
                            </Link>
                          </li>
                        ))}
                      </ul>
                    )}
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Operators */}
          {realOperators.length > 0 && (
            <div className="mt-10">
              <h3 className="text-lg font-semibold text-ocean-900">Fishing Operators</h3>
              <p className="mt-2 text-sm text-neutral-700">Real operators running fishing trips on record in this directory.</p>
              <ul className="mt-4 flex flex-wrap gap-2">
                {realOperators.map((p) => (
                  <li key={p.id}>
                    <Link href={`/maldives/providers/${p.slug}/`} className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
                      {p.title}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          )}

        </section>

        {/* Fishing Packages */}
        {fishingPackages.length > 0 && (
          <section id="fishing-packages" className="mt-12 scroll-mt-20 border-t border-neutral-200 pt-10">
            <div className="flex flex-wrap items-baseline justify-between gap-2">
              <h2 className="text-xl font-semibold text-ocean-900">Maldives Fishing Packages</h2>
              <Link href="/maldives/packages/fishing/" className="text-sm font-medium text-maldives-600 hover:underline">
                See all fishing packages ({fishingPackages.length}) →
              </Link>
            </div>
            <p className="mt-2 text-sm text-neutral-700">
              Multi-night fishing holidays combining accommodation, full-board meals, transfers and a private charter — from 2 to 8 nights, verified
              against our own packages rate sheet.
            </p>
            <ul className="mt-4 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
              {fishingPackages.slice(0, 6).map((pkg) => (
                <PackageCard key={pkg.slug} pkg={pkg} />
              ))}
            </ul>
          </section>
        )}

        {/* Maldives Fishing Seasons — general monsoon-pattern content, kept
            deliberately non-prescriptive (no single "best month" claim —
            different techniques/species have different real patterns). */}
        <section id="fishing-seasons" className="mt-12 scroll-mt-20 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Maldives Fishing Seasons</h2>
          <div className="mt-3 space-y-3 text-sm text-neutral-700">
            <p>
              The Maldives sits close enough to the equator that temperature barely changes year-round — what shifts
              is the monsoon, and with it sea conditions. The northeast monsoon (roughly December to April) brings
              calmer seas and clearer water, generally easier conditions for trolling and offshore trips. The
              southwest monsoon (roughly May to November) brings rougher water and more rain, though it can also
              stir up baitfish activity that some techniques benefit from.
            </p>
            <p>
              There isn&rsquo;t one single best month for every kind of fishing — a calm-water technique like
              trolling for tuna and wahoo can be productive through the northeast monsoon, while channel and reef
              fishing depend more on tide and current than on the season itself. Conditions vary year to year too, so
              treat any seasonal guidance as a general pattern rather than a guarantee.
            </p>
          </div>
        </section>

        <FishingGallerySection />

        <FishingVideo />

        <FishSpeciesSection />

        {/* Responsible Fishing — general, non-invented principles; no
            specific regulation is cited since none was confirmed for this
            page's sources. */}
        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Responsible Fishing in the Maldives</h2>
          <div className="mt-3 space-y-3 text-sm text-neutral-700">
            <p>
              Most operators on this page practice catch and release for anything not being kept for the table,
              handling fish carefully to give them the best chance after release — wet hands, minimal time out of the
              water, and a quick, careful unhooking. Anchoring away from live coral and following the crew&rsquo;s
              lead on where fishing is and isn&rsquo;t appropriate near a given island protects the same reefs the
              fishing itself depends on.
            </p>
            <p>
              Rules and protected areas vary by atoll and can change — your operator&rsquo;s crew is the right source
              for anything specific to where you&rsquo;re fishing, rather than a general guide like this one.
            </p>
          </div>
        </section>

        {/* Maldives Fishing Reports — honest stub, same pattern as the
            existing Fishing Guides section below: state plainly that no
            real reports exist yet rather than inventing sample ones, and
            describe what a future report will actually contain. */}
        <section id="fishing-reports" className="mt-12 scroll-mt-20 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Maldives Fishing Reports</h2>
          <p className="mt-2 text-sm text-neutral-700">
            We don&rsquo;t have real fishing reports published yet — when we do, each one will cover a real trip:
            date, location, technique used, species caught, sea conditions, the boat, trip duration and photos from
            that specific day. Check back here as real trips get logged.
          </p>
        </section>

        {/* Explore Maldives Fishing — cross-links to the sections above, per
            the requested page structure (charters, packages, fishes). */}
        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Explore Maldives Fishing</h2>
          <nav aria-label="Explore Maldives fishing sections" className="mt-4 flex flex-wrap gap-2">
            {[
              { href: "#all-fishing-activities", label: "All Fishing Activities" },
              { href: "#fishing-charters", label: "Maldives Fishing Charters" },
              { href: "#fishing-packages", label: "Maldives Fishing Packages" },
              { href: "#gaafu-fishing", label: "Fishing in Gaafu Atoll" },
              { href: "#fishing-seasons", label: "Fishing Seasons" },
              { href: "#fishing-gallery", label: "Fishing Gallery" },
              { href: "#fish-species", label: "Maldives Fishes" },
              { href: "#fishing-reports", label: "Fishing Reports" },
            ].map((link) => (
              <Link key={link.href} href={link.href} className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
                {link.label}
              </Link>
            ))}
          </nav>
        </section>

        {/* Guides */}
        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Fishing Guides</h2>
          {realGuides.length > 0 ? (
            <>
              <p className="mt-2 text-sm text-neutral-700">In-depth guides from our Travel Guide, covering seasons, techniques and a real operator writeup.</p>
              <ul className="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
                {realGuides.map((guide) => (
                  <ArticleCard key={guide.id} article={guide} />
                ))}
              </ul>
            </>
          ) : (
            <p className="mt-2 text-sm text-neutral-700">
              We don&rsquo;t yet have a dedicated Maldives fishing guide article — browse our{" "}
              <Link href="/maldives/travel-guide/" className="text-maldives-600 hover:underline">
                Travel Guide
              </Link>{" "}
              for more Maldives planning content in the meantime.
            </p>
          )}
        </section>

        {/* Related content */}
        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Explore More Maldives</h2>
          <nav aria-label="Related Maldives links" className="mt-4 flex flex-wrap gap-2">
            {[
              { href: "/maldives/diving/", label: "Diving" },
              { href: "/maldives/surfing/", label: "Surfing" },
              { href: "/maldives/activities/", label: "All Activities" },
              { href: "/maldives/packages/", label: "All Packages" },
              { href: "/maldives/packages/fishing/", label: "Fishing Packages" },
              { href: "/maldives/transfers/", label: "Maldives Transfers" },
              { href: "/maldives/resorts/", label: "Resorts" },
              { href: "/maldives/travel-guide/", label: "Travel Guide" },
            ].map((link) => (
              <Link key={link.href} href={link.href} className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
                {link.label}
              </Link>
            ))}
          </nav>
        </section>

        {/* FAQs */}
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
      </div>
    </main>
  );
}
