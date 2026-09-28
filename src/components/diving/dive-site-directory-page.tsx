import type { Metadata } from "next";
import Link from "next/link";

import { DiveSiteCard } from "@/components/diving/dive-site-card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import { PageHero } from "@/components/ui/page-hero";
import { Pagination } from "@/components/ui/pagination";
import { getDiveSites } from "@/lib/diving/repository";
import type { DiveSiteType } from "@/lib/diving/types";
import { getAtollBySlug } from "@/lib/locations/repository";
import { canonicalUrl } from "@/lib/seo/site";

const SITE_TYPE_LABEL: Record<DiveSiteType, string> = {
  reef: "Reef",
  thila: "Thila",
  channel: "Channel",
  wreck: "Wreck",
  pinnacle: "Pinnacle",
  wall: "Wall",
  cave: "Cave",
};

const SITE_TYPES = Object.keys(SITE_TYPE_LABEL) as DiveSiteType[];
const PAGE_SIZE = 48;

export interface DiveSiteDirectorySearchParams {
  page?: string;
  type?: string;
  atoll?: string;
}

function hasAnyFilter(sp: DiveSiteDirectorySearchParams): boolean {
  return Boolean(sp.type || sp.atoll);
}

export async function diveSiteDirectoryMetadata(searchParams: Promise<DiveSiteDirectorySearchParams>): Promise<Metadata> {
  const sp = await searchParams;
  const title = "Maldives Dive Sites | MTG";
  const description = "Real, documented Maldives dive sites — reefs, thilas, channels, and wrecks — by atoll and type.";
  const url = canonicalUrl("/maldives/dive-sites");

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
    robots: hasAnyFilter(sp) ? { index: false, follow: true } : undefined,
  };
}

export async function DiveSiteDirectoryPage({
  searchParams,
}: {
  searchParams: Promise<DiveSiteDirectorySearchParams>;
}) {
  const sp = await searchParams;
  const page = Math.max(1, Number(sp.page) || 1);
  const siteType = SITE_TYPES.includes(sp.type as DiveSiteType) ? (sp.type as DiveSiteType) : undefined;

  const atoll = sp.atoll ? await getAtollBySlug(sp.atoll) : null;
  const results = await getDiveSites({ page, pageSize: PAGE_SIZE, atollId: atoll?.id, siteType });
  const totalPages = Math.max(1, Math.ceil(results.total / PAGE_SIZE));

  return (
    <main>
      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Dive Sites" }]}
        eyebrow="Diving"
        title="Maldives Dive Sites"
        description="Physical dive sites, not bookable products — see diving activities for operators running trips to them."
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        <p className="text-sm text-neutral-600">
          See{" "}
          <Link href="/maldives/diving/" className="underline">
            diving activities
          </Link>{" "}
          for operators running trips to them.
        </p>

        {atoll && (
          <p className="mt-3 text-sm text-neutral-600">
            Filtered to {atoll.title}.{" "}
            <Link href="/maldives/dive-sites/" className="underline">
              Clear
            </Link>
          </p>
        )}

        <nav aria-label="Filter by site type" className="mt-6 flex flex-wrap gap-2 text-sm">
          <Link
            href="/maldives/dive-sites/"
            className={`rounded-full border px-3 py-1 ${!siteType ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
          >
            All types
          </Link>
          {SITE_TYPES.map((type) => (
            <Link
              key={type}
              href={`/maldives/dive-sites/?type=${type}`}
              className={`rounded-full border px-3 py-1 ${siteType === type ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
            >
              {SITE_TYPE_LABEL[type]}
            </Link>
          ))}
        </nav>

        {results.items.length === 0 ? (
          <EmptyState title="No dive sites recorded for this filter yet" />
        ) : (
          <ul className="mt-8 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {results.items.map((site) => (
              <DiveSiteCard key={site.id} site={site} />
            ))}
          </ul>
        )}

        <Pagination page={page} totalPages={totalPages} basePath="/maldives/dive-sites/" />
      </div>
    </main>
  );
}
