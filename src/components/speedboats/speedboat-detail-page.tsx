import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";

import { NodeInquiryToggle } from "@/components/bookings/node-inquiry-toggle";
import { ReviewsSection } from "@/components/reviews/reviews-section";
import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { MediaImage } from "@/components/ui/media-image";
import { PageHero } from "@/components/ui/page-hero";
import { getReviewsForNode } from "@/lib/reviews/repository";
import { breadcrumbJsonLd, canonicalUrl, getSiteUrl } from "@/lib/seo/site";
import { getSpeedboatBySlug, getSpeedboats } from "@/lib/speedboats/repository";
import type { SpeedboatDetail } from "@/lib/speedboats/types";

export async function speedboatDetailMetadata(slug: string): Promise<Metadata> {
  const boat = await getSpeedboatBySlug(slug);
  if (!boat) return {};
  const title = boat.metaTitle ?? `${boat.title} Private Speedboat Charter | Maldives Tour Guide`;
  const description = boat.metaDescription ?? boat.summary ?? `Charter the ${boat.title} in the Maldives.`;
  const url = canonicalUrl(`/maldives-speedboats-charter/${boat.slug}`);
  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
  };
}

function speedboatJsonLd(boat: SpeedboatDetail) {
  return {
    "@context": "https://schema.org",
    "@type": "Service",
    name: `${boat.title} Private Speedboat Charter`,
    description: boat.summary ?? undefined,
    url: canonicalUrl(`/maldives-speedboats-charter/${boat.slug}`),
    areaServed: "Maldives",
    provider: { "@type": "Organization", name: "Maldives Tour Guide", url: getSiteUrl() },
  };
}

export async function SpeedboatDetailPage({ slug }: { slug: string }) {
  const boat = await getSpeedboatBySlug(slug);
  if (!boat) notFound();

  const [allBoats, reviews] = await Promise.all([getSpeedboats(), getReviewsForNode(boat.id)]);
  const relatedBoats = allBoats.filter((b) => b.id !== boat.id).slice(0, 3);

  return (
    <main>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(speedboatJsonLd(boat)) }} />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(
            breadcrumbJsonLd(
              [{ label: "Maldives", href: "/maldives/" }, { label: "Private Speedboat Charter", href: "/maldives-speedboats-charter/" }, { label: boat.title }],
              `/maldives-speedboats-charter/${boat.slug}`,
            ),
          ),
        }}
      />

      <PageHero
        breadcrumbs={[
          { label: "Maldives", href: "/maldives/" },
          { label: "Private Speedboat Charter", href: "/maldives-speedboats-charter/" },
          { label: boat.title },
        ]}
        eyebrow="Private charter"
        title={boat.title}
        description={boat.summary ?? undefined}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        {boat.gallery.length > 0 && (
          <div className="grid grid-cols-2 gap-2 sm:grid-cols-3">
            {boat.gallery.map((asset) => (
              <MediaImage key={asset.id} asset={asset} alt={boat.title} aspectClassName="aspect-[4/3]" />
            ))}
          </div>
        )}

        <dl className="mt-6 grid grid-cols-2 gap-4 text-sm sm:grid-cols-4">
          <div>
            <dt className="text-neutral-500">Capacity</dt>
            <dd className="font-medium">{boat.capacity} passengers</dd>
          </div>
          {boat.lengthFeet && (
            <div>
              <dt className="text-neutral-500">Length</dt>
              <dd className="font-medium">{boat.lengthFeet} ft</dd>
            </div>
          )}
          {boat.engineCount && (
            <div>
              <dt className="text-neutral-500">Engine</dt>
              <dd className="font-medium">
                {boat.engineCount === 2 ? "Twin engine" : "Single engine"}
                {boat.horsepower ? ` (${boat.horsepower} hp)` : ""}
              </dd>
            </div>
          )}
          {boat.topSpeedKnots && (
            <div>
              <dt className="text-neutral-500">Top speed</dt>
              <dd className="font-medium">{boat.topSpeedKnots} knots</dd>
            </div>
          )}
        </dl>

        {boat.facilities.length > 0 && (
          <section className="mt-8">
            <h2 className="text-xl font-semibold text-ocean-900">Facilities</h2>
            <ul className="mt-3 flex flex-wrap gap-2">
              {boat.facilities.map((f) => (
                <li key={f} className="rounded-full border border-neutral-300 px-3 py-1 text-sm text-neutral-700">
                  {f}
                </li>
              ))}
            </ul>
          </section>
        )}

        <section className="mt-8">
          <h2 className="text-xl font-semibold text-ocean-900">Charter options</h2>
          <ul className="mt-3 flex flex-wrap gap-2">
            {boat.charterOptions.map((option) => (
              <li key={option} className="rounded-full bg-lagoon-50 px-3 py-1 text-sm text-ocean-800">
                {option}
              </li>
            ))}
          </ul>
          <p className="mt-3 text-sm text-neutral-600">
            No fixed public price — charter cost depends on duration, destination, and group size. Request a quote and we&rsquo;ll follow up
            directly.
          </p>
          {boat.isBookable && (
            <NodeInquiryToggle
              productNodeId={boat.id}
              productTitle={`${boat.title} (Private Speedboat Charter)`}
              source="transfer"
              submitLabel="Request Private Charter"
              toggleLabel="Request Private Charter"
            />
          )}
        </section>

        <ReviewsSection nodeId={boat.id} reviews={reviews} />

        {relatedBoats.length > 0 && (
          <section className="mt-10 border-t border-neutral-200 pt-10">
            <h2 className="text-xl font-semibold text-ocean-900">Other boats in the fleet</h2>
            <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-3">
              {relatedBoats.map((b) => (
                <li key={b.id} className={CARD_CLASS}>
                  {b.heroImage && (
                    <div className={CARD_IMAGE_BLEED_CLASS}>
                      <MediaImage asset={b.heroImage} alt={b.title} aspectClassName="aspect-[4/3]" />
                    </div>
                  )}
                  <Link href={`/maldives-speedboats-charter/${b.slug}/`} className="font-medium text-ocean-900 hover:text-maldives-600">
                    {b.title}
                  </Link>
                  <p className="mt-1 text-sm text-neutral-600">
                    {b.capacity} seats{b.lengthFeet ? ` · ${b.lengthFeet} ft` : ""}
                  </p>
                </li>
              ))}
            </ul>
          </section>
        )}

        <div className="mt-10 border-t border-neutral-200 pt-6">
          <Link href="/maldives-speedboats-charter/" className="text-sm font-medium text-maldives-600 hover:underline">
            ← All private speedboats
          </Link>
        </div>
      </div>
    </main>
  );
}
