import type { Metadata } from "next";
import Link from "next/link";

import { AttractionCard } from "@/components/attractions/attraction-card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import { PageHero } from "@/components/ui/page-hero";
import { Pagination } from "@/components/ui/pagination";
import { getAttractions } from "@/lib/attractions/repository";
import {
  ATTRACTION_SUPER_GROUP,
  ATTRACTION_SUPER_GROUP_LABEL,
  type AttractionSuperGroup,
  ATTRACTION_TYPE_LABEL,
  type AttractionSummary,
  type AttractionType,
} from "@/lib/attractions/types";
import { attractionHref } from "@/lib/attractions/types";
import { getAtollBySlug } from "@/lib/locations/repository";
import { breadcrumbJsonLd, canonicalUrl, itemListJsonLd } from "@/lib/seo/site";

const ATTRACTION_TYPES = Object.keys(ATTRACTION_TYPE_LABEL) as AttractionType[];
const SUPER_GROUP_ORDER: AttractionSuperGroup[] = ["cultural", "natural", "marine"];
const PAGE_SIZE = 48;

function groupBySuperGroup(items: AttractionSummary[]): Map<AttractionSuperGroup, AttractionSummary[]> {
  const groups = new Map<AttractionSuperGroup, AttractionSummary[]>();
  for (const item of items) {
    if (!item.attractionType) continue;
    const group = ATTRACTION_SUPER_GROUP[item.attractionType];
    if (!groups.has(group)) groups.set(group, []);
    groups.get(group)!.push(item);
  }
  return groups;
}

export interface AttractionDirectorySearchParams {
  page?: string;
  type?: string;
  atoll?: string;
}

function hasAnyFilter(sp: AttractionDirectorySearchParams): boolean {
  return Boolean(sp.type || sp.atoll);
}

export async function attractionDirectoryMetadata(searchParams: Promise<AttractionDirectorySearchParams>): Promise<Metadata> {
  const sp = await searchParams;
  const title = "Maldives Attractions | Landmarks, Museums & Places to Visit";
  const description = "Real, individually documented Maldives attractions — mosques, museums, monuments, beaches and markets — starting with Malé's must-see landmarks.";
  const url = canonicalUrl("/maldives/attractions");

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
    robots: hasAnyFilter(sp) ? { index: false, follow: true } : undefined,
  };
}

export async function AttractionDirectoryPage({
  searchParams,
}: {
  searchParams: Promise<AttractionDirectorySearchParams>;
}) {
  const sp = await searchParams;
  const page = Math.max(1, Number(sp.page) || 1);
  const attractionType = ATTRACTION_TYPES.includes(sp.type as AttractionType) ? (sp.type as AttractionType) : undefined;

  const atoll = sp.atoll ? await getAtollBySlug(sp.atoll) : null;
  const results = await getAttractions({ page, pageSize: PAGE_SIZE, atollId: atoll?.id, attractionType });
  const totalPages = Math.max(1, Math.ceil(results.total / PAGE_SIZE));
  const isUnfiltered = !attractionType && !atoll;
  const superGroups = isUnfiltered ? groupBySuperGroup(results.items) : null;

  // A real, populated list of atolls to browse by — only atolls that
  // actually have an attraction, never every administrative atoll (Task
  // 15 §14: "do NOT automatically create a page/section for every atoll
  // unless enough attraction data exists"). Reuses the unfiltered result
  // set when there's no active filter; only fetches separately when a
  // filter has already narrowed `results`.
  const allForAtollNav = isUnfiltered ? results.items : (await getAttractions({ pageSize: PAGE_SIZE })).items;
  const atollsInUse = Array.from(new Map(allForAtollNav.filter((a) => a.atoll).map((a) => [a.atoll!.id, a.atoll!])).values()).sort((a, b) =>
    a.title.localeCompare(b.title),
  );

  return (
    <main>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbJsonLd([{ label: "Maldives", href: "/maldives/" }, { label: "Attractions" }], "/maldives/attractions")) }} />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(
            itemListJsonLd(
              results.items.map((a) => ({ title: a.title, href: attractionHref(a), summary: a.summary })),
              "TouristAttraction",
            ),
          ),
        }}
      />

      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Attractions" }]}
        eyebrow="Places to visit"
        title="Maldives Attractions"
        description="Real, individually documented landmarks, museums, monuments and public beaches — starting with Malé's must-see sights."
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        <p className="text-sm text-neutral-600">
          See{" "}
          <Link href="/maldives/activities/" className="underline">
            all activities
          </Link>{" "}
          for bookable trips and experiences.
        </p>

        {atoll && (
          <p className="mt-3 text-sm text-neutral-600">
            Filtered to {atoll.title}.{" "}
            <Link href="/maldives/attractions/" className="underline">
              Clear
            </Link>
          </p>
        )}

        <nav aria-label="Filter by attraction type" className="mt-6 flex flex-wrap gap-2 text-sm">
          <Link
            href="/maldives/attractions/"
            className={`rounded-full border px-3 py-1 ${!attractionType ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
          >
            All types
          </Link>
          {ATTRACTION_TYPES.map((type) => (
            <Link
              key={type}
              href={`/maldives/attractions/?type=${type}`}
              className={`rounded-full border px-3 py-1 ${attractionType === type ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
            >
              {ATTRACTION_TYPE_LABEL[type]}
            </Link>
          ))}
        </nav>

        {atollsInUse.length > 1 && (
          <nav aria-label="Filter by atoll" className="mt-3 flex flex-wrap gap-2 text-sm">
            {atollsInUse.map((a) => (
              <Link
                key={a.id}
                href={`/maldives/attractions/?atoll=${a.slug}`}
                className={`rounded-full border px-3 py-1 ${atoll?.id === a.id ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
              >
                Attractions in {a.title}
              </Link>
            ))}
          </nav>
        )}

        {results.items.length === 0 ? (
          <EmptyState title="No attractions recorded for this filter yet" />
        ) : superGroups ? (
          <div className="mt-8 space-y-12">
            {SUPER_GROUP_ORDER.filter((group) => superGroups.has(group)).map((group) => (
              <section key={group}>
                <h2 className="text-xl font-semibold text-ocean-900">{ATTRACTION_SUPER_GROUP_LABEL[group]}</h2>
                <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
                  {superGroups.get(group)!.map((attraction) => (
                    <AttractionCard key={attraction.id} attraction={attraction} />
                  ))}
                </ul>
              </section>
            ))}
          </div>
        ) : (
          <ul className="mt-8 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {results.items.map((attraction) => (
              <AttractionCard key={attraction.id} attraction={attraction} />
            ))}
          </ul>
        )}

        <Pagination page={page} totalPages={totalPages} basePath="/maldives/attractions/" />
      </div>
    </main>
  );
}
