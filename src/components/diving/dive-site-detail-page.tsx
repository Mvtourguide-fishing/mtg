import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";

import { ActivityCard } from "@/components/activity/activity-card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { PageHero } from "@/components/ui/page-hero";
import { getDiveSiteBySlug, getDivingActivitiesAtSite } from "@/lib/diving/repository";
import { breadcrumbJsonLd, canonicalUrl } from "@/lib/seo/site";

const SITE_TYPE_LABEL: Record<string, string> = {
  reef: "Reef",
  thila: "Thila",
  channel: "Channel",
  wreck: "Wreck",
  pinnacle: "Pinnacle",
  wall: "Wall",
  cave: "Cave",
};

export async function diveSiteDetailMetadata(slug: string): Promise<Metadata> {
  const site = await getDiveSiteBySlug(slug);
  if (!site) return {};

  const title = `${site.title} | Maldives Dive Sites | MTG`;
  const description = site.summary ?? `${site.title}, a Maldives dive site.`;
  const url = canonicalUrl(`/maldives/dive-sites/${site.slug}`);

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
  };
}

export async function DiveSiteDetailPage({ slug }: { slug: string }) {
  const site = await getDiveSiteBySlug(slug);
  if (!site) notFound();

  const activities = await getDivingActivitiesAtSite(site.id);

  return (
    <main>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(
            breadcrumbJsonLd(
              [{ label: "Maldives", href: "/maldives/" }, { label: "Dive Sites", href: "/maldives/dive-sites/" }, { label: site.title }],
              `/maldives/dive-sites/${site.slug}`,
            ),
          ),
        }}
      />

      <PageHero
        breadcrumbs={[
          { label: "Maldives", href: "/maldives/" },
          { label: "Dive Sites", href: "/maldives/dive-sites/" },
          { label: site.title },
        ]}
        eyebrow="Dive site"
        title={site.title}
        description={site.summary ?? undefined}
        image={site.heroImage}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
      <p className="text-xs uppercase tracking-wide text-neutral-500">
        A physical dive site — not a bookable product. See diving activities below for operators running trips here.
      </p>

      <dl className="mt-6 grid grid-cols-2 gap-4 text-sm sm:grid-cols-3">
        {site.siteType && (
          <div>
            <dt className="text-neutral-500">Site type</dt>
            <dd className="font-medium">{SITE_TYPE_LABEL[site.siteType] ?? site.siteType}</dd>
          </div>
        )}
        {(site.depthMinMeters !== null || site.depthMaxMeters !== null) && (
          <div>
            <dt className="text-neutral-500">Depth</dt>
            <dd className="font-medium">
              {site.depthMinMeters !== null && site.depthMaxMeters !== null
                ? `${site.depthMinMeters}–${site.depthMaxMeters} m`
                : `${site.depthMinMeters ?? site.depthMaxMeters} m`}
            </dd>
          </div>
        )}
        {site.experienceLevel && (
          <div>
            <dt className="text-neutral-500">Experience level</dt>
            <dd className="font-medium capitalize">{site.experienceLevel}</dd>
          </div>
        )}
        {site.atoll && (
          <div>
            <dt className="text-neutral-500">Atoll</dt>
            <dd className="font-medium">
              <Link href={`/maldives/atolls/${site.atoll.slug}/`} className="hover:underline">
                {site.atoll.title}
              </Link>
            </dd>
          </div>
        )}
        {site.nearbyIsland && (
          <div>
            <dt className="text-neutral-500">Nearby island</dt>
            <dd className="font-medium">
              <Link href={`/maldives/islands/${site.nearbyIsland.slug}/`} className="hover:underline">
                {site.nearbyIsland.title}
              </Link>
            </dd>
          </div>
        )}
      </dl>

      {(site.currentNotes || site.marineLifeNotes) && (
        <dl className="mt-6 space-y-4 text-sm">
          {site.currentNotes && (
            <div>
              <dt className="text-neutral-500">Conditions</dt>
              <dd className="mt-1">{site.currentNotes}</dd>
            </div>
          )}
          {site.marineLifeNotes && (
            <div>
              <dt className="text-neutral-500">Marine life</dt>
              <dd className="mt-1">{site.marineLifeNotes}</dd>
            </div>
          )}
        </dl>
      )}

      {activities.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Diving activities at {site.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {activities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </section>
      )}

      <p className="mt-10 text-sm text-neutral-600">
        Planning a trip?{" "}
        <Link href="/maldives/diving/" className="font-medium text-maldives-600 hover:underline">
          See all Maldives diving activities, packages and dive sites
        </Link>
        .
      </p>
      </div>
    </main>
  );
}
