import Link from "next/link";

import { AccommodationCard } from "@/components/accommodation/accommodation-card";
import type { NearbyAccommodations } from "@/lib/accommodations/repository";

export interface WhereToStaySectionProps {
  nearby: NearbyAccommodations;
  islandTitle: string | null;
  atollTitle: string | null;
}

/**
 * The reverse of NearbyActivitiesSection — real accommodations near an
 * activity/attraction, completing the two-way accommodation↔activity
 * graph (never claiming the activity is operated by or included with any
 * listed stay).
 */
export function WhereToStaySection({ nearby, islandTitle, atollTitle }: WhereToStaySectionProps) {
  const { islandAccommodations, atollAccommodations } = nearby;
  if (islandAccommodations.length === 0 && atollAccommodations.length === 0) return null;

  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">Where to Stay</h2>
      <p className="mt-1 text-sm text-neutral-600">Real places to stay in the area — not affiliated with or operating this activity.</p>

      {islandAccommodations.length > 0 && (
        <div className="mt-4">
          {atollAccommodations.length > 0 && islandTitle && (
            <h3 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">Stays on {islandTitle}</h3>
          )}
          <ul className={`grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3 ${atollAccommodations.length > 0 && islandTitle ? "mt-3" : ""}`}>
            {islandAccommodations.map((accommodation) => (
              <AccommodationCard key={accommodation.id} accommodation={accommodation} />
            ))}
          </ul>
        </div>
      )}

      {atollAccommodations.length > 0 && (
        <div className="mt-6">
          <h3 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">More Stays in {atollTitle ?? "the Area"}</h3>
          <ul className="mt-3 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {atollAccommodations.map((accommodation) => (
              <AccommodationCard key={accommodation.id} accommodation={accommodation} />
            ))}
          </ul>
        </div>
      )}

      <Link href="/maldives/resorts/" className="mt-4 inline-block text-sm font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
        Browse all places to stay →
      </Link>
    </section>
  );
}
