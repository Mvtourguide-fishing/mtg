import Link from "next/link";

import { ActivityCard } from "@/components/activity/activity-card";
import type { NearbyActivities } from "@/lib/activities/repository";

export interface NearbyActivitiesSectionProps {
  nearby: NearbyActivities;
  /** e.g. "Things to Do Near Hard Rock Hotel Maldives" */
  heading: string;
  islandTitle: string | null;
  atollTitle: string | null;
  viewAllHref?: string;
}

/**
 * Location-aware activity discovery for accommodation (and similar)
 * pages — never a random internal-link list. Two honestly labeled tiers
 * only: activities on the exact same island, and activities elsewhere in
 * the same atoll (clearly marked as a wider area, never implied to be at
 * the property itself). Renders nothing when neither tier has real data,
 * rather than falling back to unrelated activities.
 */
export function NearbyActivitiesSection({ nearby, heading, islandTitle, atollTitle, viewAllHref }: NearbyActivitiesSectionProps) {
  const { islandActivities, atollActivities } = nearby;
  if (islandActivities.length === 0 && atollActivities.length === 0) return null;

  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">{heading}</h2>
      <p className="mt-1 text-sm text-neutral-600">Real activities and experiences available in this area — not bookable through this listing directly.</p>

      {islandActivities.length > 0 && (
        <div className="mt-4">
          {atollActivities.length > 0 && islandTitle && (
            <h3 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">Activities on {islandTitle}</h3>
          )}
          <ul className={`grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3 ${atollActivities.length > 0 && islandTitle ? "mt-3" : ""}`}>
            {islandActivities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </div>
      )}

      {atollActivities.length > 0 && (
        <div className="mt-6">
          <h3 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">
            More Activities in {atollTitle ?? "the Area"}
          </h3>
          <ul className="mt-3 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {atollActivities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </div>
      )}

      {viewAllHref && (
        <Link href={viewAllHref} className="mt-4 inline-block text-sm font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
          View all activities →
        </Link>
      )}
    </section>
  );
}
