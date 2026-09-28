import type { Metadata } from "next";
import Link from "next/link";

import { SurfBreakCard } from "@/components/surfing/surf-break-card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import { PageHero } from "@/components/ui/page-hero";
import { Pagination } from "@/components/ui/pagination";
import { getSurfBreaks } from "@/lib/surfing/repository";
import type { SurfBreakType } from "@/lib/surfing/types";
import { getAtollBySlug } from "@/lib/locations/repository";
import { canonicalUrl } from "@/lib/seo/site";

const BREAK_TYPE_LABEL: Record<SurfBreakType, string> = {
  reef_break: "Reef break",
  point_break: "Point break",
  beach_break: "Beach break",
  channel: "Channel",
};

const BREAK_TYPES = Object.keys(BREAK_TYPE_LABEL) as SurfBreakType[];
const PAGE_SIZE = 48;

export interface SurfBreakDirectorySearchParams {
  page?: string;
  type?: string;
  atoll?: string;
}

function hasAnyFilter(sp: SurfBreakDirectorySearchParams): boolean {
  return Boolean(sp.type || sp.atoll);
}

export async function surfBreakDirectoryMetadata(searchParams: Promise<SurfBreakDirectorySearchParams>): Promise<Metadata> {
  const sp = await searchParams;
  const title = "Maldives Surf Breaks | MTG";
  const description = "Real, documented Maldives surf breaks — reef, point, and beach breaks, and channels — by atoll and type.";
  const url = canonicalUrl("/maldives/surf-breaks");

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
    robots: hasAnyFilter(sp) ? { index: false, follow: true } : undefined,
  };
}

export async function SurfBreakDirectoryPage({
  searchParams,
}: {
  searchParams: Promise<SurfBreakDirectorySearchParams>;
}) {
  const sp = await searchParams;
  const page = Math.max(1, Number(sp.page) || 1);
  const breakType = BREAK_TYPES.includes(sp.type as SurfBreakType) ? (sp.type as SurfBreakType) : undefined;

  const atoll = sp.atoll ? await getAtollBySlug(sp.atoll) : null;
  const results = await getSurfBreaks({ page, pageSize: PAGE_SIZE, atollId: atoll?.id, breakType });
  const totalPages = Math.max(1, Math.ceil(results.total / PAGE_SIZE));

  return (
    <main>
      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Surf Breaks" }]}
        eyebrow="Surfing"
        title="Maldives Surf Breaks"
        description="Physical surf breaks, not bookable products — see surfing activities for lessons and trips that visit them."
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        <p className="text-sm text-neutral-600">
          See{" "}
          <Link href="/maldives/surfing/" className="underline">
            surfing activities
          </Link>{" "}
          for lessons and trips that visit them.
        </p>

        {atoll && (
          <p className="mt-3 text-sm text-neutral-600">
            Filtered to {atoll.title}.{" "}
            <Link href="/maldives/surf-breaks/" className="underline">
              Clear
            </Link>
          </p>
        )}

        <nav aria-label="Filter by break type" className="mt-6 flex flex-wrap gap-2 text-sm">
          <Link
            href="/maldives/surf-breaks/"
            className={`rounded-full border px-3 py-1 ${!breakType ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
          >
            All types
          </Link>
          {BREAK_TYPES.map((type) => (
            <Link
              key={type}
              href={`/maldives/surf-breaks/?type=${type}`}
              className={`rounded-full border px-3 py-1 ${breakType === type ? "border-maldives-600 bg-maldives-600 text-white" : "border-neutral-300 text-neutral-700"}`}
            >
              {BREAK_TYPE_LABEL[type]}
            </Link>
          ))}
        </nav>

        {results.items.length === 0 ? (
          <EmptyState title="No surf breaks recorded for this filter yet" />
        ) : (
          <ul className="mt-8 grid grid-cols-1 gap-3 sm:grid-cols-2">
            {results.items.map((surfBreak) => (
              <SurfBreakCard key={surfBreak.id} surfBreak={surfBreak} />
            ))}
          </ul>
        )}

        <Pagination page={page} totalPages={totalPages} basePath="/maldives/surf-breaks/" />
      </div>
    </main>
  );
}
