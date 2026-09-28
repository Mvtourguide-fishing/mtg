import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";

import { ActivityCard } from "@/components/activity/activity-card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { PageHero } from "@/components/ui/page-hero";
import { getSurfBreakBySlug, getSurfingActivitiesAtBreak } from "@/lib/surfing/repository";
import { canonicalUrl } from "@/lib/seo/site";

const BREAK_TYPE_LABEL: Record<string, string> = {
  reef_break: "Reef break",
  point_break: "Point break",
  beach_break: "Beach break",
  channel: "Channel",
};

export async function surfBreakDetailMetadata(slug: string): Promise<Metadata> {
  const surfBreak = await getSurfBreakBySlug(slug);
  if (!surfBreak) return {};

  const title = `${surfBreak.title} | Maldives Surf Breaks | MTG`;
  const description = surfBreak.summary ?? `${surfBreak.title}, a Maldives surf break.`;
  const url = canonicalUrl(`/maldives/surf-breaks/${surfBreak.slug}`);

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
  };
}

export async function SurfBreakDetailPage({ slug }: { slug: string }) {
  const surfBreak = await getSurfBreakBySlug(slug);
  if (!surfBreak) notFound();

  const activities = await getSurfingActivitiesAtBreak(surfBreak.id);

  return (
    <main>
      <PageHero
        breadcrumbs={[
          { label: "Maldives", href: "/maldives/" },
          { label: "Surf Breaks", href: "/maldives/surf-breaks/" },
          { label: surfBreak.title },
        ]}
        eyebrow="Surf break"
        title={surfBreak.title}
        description={surfBreak.summary ?? undefined}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
      <p className="text-xs uppercase tracking-wide text-neutral-500">
        A physical surf break — not a bookable product. See surfing activities below for operators running lessons or trips here.
      </p>

      <dl className="mt-6 grid grid-cols-2 gap-4 text-sm sm:grid-cols-3">
        {surfBreak.breakType && (
          <div>
            <dt className="text-neutral-500">Break type</dt>
            <dd className="font-medium">{BREAK_TYPE_LABEL[surfBreak.breakType] ?? surfBreak.breakType}</dd>
          </div>
        )}
        {surfBreak.difficulty && (
          <div>
            <dt className="text-neutral-500">Level</dt>
            <dd className="font-medium capitalize">{surfBreak.difficulty.replace("_", " ")}</dd>
          </div>
        )}
        {surfBreak.atoll && (
          <div>
            <dt className="text-neutral-500">Atoll</dt>
            <dd className="font-medium">
              <Link href={`/maldives/atolls/${surfBreak.atoll.slug}/`} className="hover:underline">
                {surfBreak.atoll.title}
              </Link>
            </dd>
          </div>
        )}
        {surfBreak.nearbyIsland && (
          <div>
            <dt className="text-neutral-500">Nearby island</dt>
            <dd className="font-medium">
              <Link href={`/maldives/islands/${surfBreak.nearbyIsland.slug}/`} className="hover:underline">
                {surfBreak.nearbyIsland.title}
              </Link>
            </dd>
          </div>
        )}
      </dl>

      {(surfBreak.waveNotes || surfBreak.seasonNotes || surfBreak.accessNotes) && (
        <dl className="mt-6 space-y-4 text-sm">
          {surfBreak.waveNotes && (
            <div>
              <dt className="text-neutral-500">Wave characteristics</dt>
              <dd className="mt-1">{surfBreak.waveNotes}</dd>
            </div>
          )}
          {surfBreak.seasonNotes && (
            <div>
              <dt className="text-neutral-500">Season</dt>
              <dd className="mt-1">{surfBreak.seasonNotes}</dd>
            </div>
          )}
          {surfBreak.accessNotes && (
            <div>
              <dt className="text-neutral-500">Access</dt>
              <dd className="mt-1">{surfBreak.accessNotes}</dd>
            </div>
          )}
        </dl>
      )}

      {activities.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Surfing activities at {surfBreak.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2">
            {activities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </section>
      )}
      </div>
    </main>
  );
}
