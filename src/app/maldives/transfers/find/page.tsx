import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";

import { TransferFinder } from "@/components/transfers/transfer-finder";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { PageHero } from "@/components/ui/page-hero";
import { getLocationBySlug } from "@/lib/locations/repository";
import { findRouteBetween } from "@/lib/transfers/finder";

/**
 * The transfer finder's results step (Task 20 §8-9). A search here is
 * never itself the SEO destination — when a real route exists, this
 * redirects straight to the actual route page (the thing Google should
 * index); when none exists, it shows an honest empty state with a
 * private-charter CTA rather than fabricating a route. Always noindex:
 * this is a dynamic search state, not landing-page content.
 */

interface SearchParams {
  from?: string;
  to?: string;
  type?: string;
}

export function generateMetadata(): Metadata {
  return { robots: { index: false, follow: true } };
}

export default async function TransferFindPage({ searchParams }: { searchParams: Promise<SearchParams> }) {
  const sp = await searchParams;

  const [fromLocation, toLocation] = await Promise.all([
    sp.from ? getLocationBySlug(sp.from) : Promise.resolve(null),
    sp.to ? getLocationBySlug(sp.to) : Promise.resolve(null),
  ]);

  if (fromLocation && toLocation) {
    const { route } = await findRouteBetween(fromLocation.id, toLocation.id);
    if (route) redirect(`/maldives/transfers/${route.slug}/`);
  }

  const bothChosen = Boolean(fromLocation && toLocation);

  return (
    <main>
      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Transfers", href: "/maldives/transfers/" }, { label: "Find a transfer" }]}
        eyebrow="Transfer finder"
        title="Find your Maldives transfer"
        description="Search by airport, island, resort, or hotel — we'll show you the real route if one exists."
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        <TransferFinder defaultFromSlug={fromLocation?.slug} defaultFromLabel={fromLocation?.title} />

        {bothChosen && (
          <div className="mt-10 rounded-2xl border border-amber-200 bg-amber-50 p-6 text-center">
            <p className="text-lg font-semibold text-ocean-900">
              No direct transfer is currently listed for {fromLocation?.title} → {toLocation?.title}.
            </p>
            <p className="mt-2 text-sm text-neutral-700">
              We only list real, verified transfer routes — this specific route isn&rsquo;t in our records yet. A private charter can
              usually still get you there.
            </p>
            <Link
              href="/maldives-speedboats-charter/"
              className="mt-4 inline-flex items-center justify-center rounded-full bg-maldives-600 px-5 py-2.5 text-sm font-medium text-white hover:bg-ocean-800"
            >
              Request a Private Transfer
            </Link>
          </div>
        )}

        {!bothChosen && (
          <p className="mt-8 text-sm text-neutral-600">
            Choose both a starting point and a destination above to search real Maldives transfer routes, or browse the{" "}
            <Link href="/maldives/transfers/" className="text-maldives-600 underline">
              full transfer directory
            </Link>
            .
          </p>
        )}
      </div>
    </main>
  );
}
