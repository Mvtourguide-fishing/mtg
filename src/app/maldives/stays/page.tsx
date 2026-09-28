import type { Metadata } from "next";
import Link from "next/link";

import { AccommodationCard } from "@/components/accommodation/accommodation-card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { PageHero } from "@/components/ui/page-hero";
import { getAccommodations } from "@/lib/accommodations/repository";
import { canonicalUrl } from "@/lib/seo/site";

export const revalidate = 3600;

export function generateMetadata(): Metadata {
  const title = "Maldives Stays — Resorts, Hotels & Guesthouses | MTG";
  const description = "Real, source-verified Maldives resorts, hotels and guesthouses — with real rooms, photos, and prices where we have them.";
  const url = canonicalUrl("/maldives/stays");
  return { title, description, alternates: { canonical: url }, openGraph: { title, description, url } };
}

const TYPES = [
  {
    type: "resort" as const,
    label: "Resorts",
    href: "/maldives/resorts/",
    description: "Private-island resorts across the Maldives, each with real rooms, photos and (where we have one) a starting price.",
  },
  {
    type: "hotel" as const,
    label: "Hotels",
    href: "/maldives/hotels/",
    description: "City and local-island hotels — Malé, Hulhumalé, Maafushi and more.",
  },
  {
    type: "guesthouse" as const,
    label: "Guesthouses",
    href: "/maldives/guesthouses/",
    description: "Budget-friendly guesthouses on local islands, for the local-island tourism side of the Maldives.",
  },
];

export default async function StaysPage() {
  const [resorts, hotels, guesthouses] = await Promise.all([
    getAccommodations({ type: "resort", pageSize: 3 }),
    getAccommodations({ type: "hotel", pageSize: 3 }),
    getAccommodations({ type: "guesthouse", pageSize: 3 }),
  ]);

  const totals = { resort: resorts.total, hotel: hotels.total, guesthouse: guesthouses.total };
  const samples = { resort: resorts.items, hotel: hotels.items, guesthouse: guesthouses.items };

  return (
    <main>
      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Stays" }]}
        eyebrow="Where to Stay"
        title="Maldives Stays"
        description="Resorts, hotels and guesthouses across the Maldives — real properties, migrated from our own records, never invented."
        variant="ocean"
      />

      <div className={`${CONTAINER_CLASS} space-y-14 py-10 sm:py-14`}>
        {TYPES.map(({ type, label, href, description }) => (
          <section key={type}>
            <div className="flex items-end justify-between gap-4">
              <div>
                <h2 className="text-xl font-semibold text-ocean-900">
                  {label} <span className="font-normal text-neutral-500">({totals[type]})</span>
                </h2>
                <p className="mt-1 text-sm text-neutral-600">{description}</p>
              </div>
              <Link href={href} className="shrink-0 text-sm font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
                View all {label.toLowerCase()} →
              </Link>
            </div>
            {samples[type].length > 0 ? (
              <ul className="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
                {samples[type].map((a) => (
                  <AccommodationCard key={a.id} accommodation={a} />
                ))}
              </ul>
            ) : (
              <p className="mt-4 text-sm text-neutral-500">No {label.toLowerCase()} published yet.</p>
            )}
          </section>
        ))}

        <section className="rounded-2xl border border-neutral-200 bg-neutral-50 p-6">
          <h2 className="text-lg font-semibold text-ocean-900">Liveaboards</h2>
          <p className="mt-2 text-sm text-neutral-600">
            We don&rsquo;t yet have a real, verified liveaboard directory — the Maldives liveaboard scene is real and popular, but we&rsquo;d
            rather wait until we have genuine per-vessel details (operator, cabins, real pricing) than publish a generic listing that
            isn&rsquo;t tied to an actual boat. Check back, or message us on WhatsApp if you&rsquo;re looking for a liveaboard trip and
            we&rsquo;ll point you in the right direction.
          </p>
        </section>
      </div>
    </main>
  );
}
