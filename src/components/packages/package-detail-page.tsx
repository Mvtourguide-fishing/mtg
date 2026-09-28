import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";

import { NodeInquiryToggle } from "@/components/bookings/node-inquiry-toggle";
import { PackageCard } from "@/components/packages/package-card";
import { Badge } from "@/components/ui/badge";
import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { MediaImage } from "@/components/ui/media-image";
import { PageHero } from "@/components/ui/page-hero";
import { bookingCta, FISHING_PACKAGE_CTA } from "@/lib/bookings/copy";
import { MFH_PRICE_TABLES } from "@/lib/packages/mfh-price-tables";
import { getRelatedPackageViews, getPackageViewBySlug } from "@/lib/packages/view-repository";
import { PACKAGE_CATEGORY_TITLE } from "@/lib/packages/view-types";
import type { PackageView } from "@/lib/packages/view-types";
import { breadcrumbJsonLd, canonicalUrl, getSiteUrl } from "@/lib/seo/site";

const WHATSAPP_NUMBER = "9607794332";

const PRICE_TYPE_LABEL: Record<string, string> = {
  "per-person": "per person",
  "per-couple": "per couple",
  "per-package": "per package",
};

export async function packageDetailMetadata(slug: string): Promise<Metadata> {
  const pkg = await getPackageViewBySlug(slug);
  if (!pkg) return {};

  const title = `${pkg.title} | ${pkg.nights ?? "?"} Nights / ${pkg.days ?? "?"} Days`;
  const description = pkg.shortDescription ?? undefined;
  const url = canonicalUrl(`/maldives/packages/${pkg.slug}`);

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
    // Demo packages are real, useful content but not a real commercial
    // offer yet — never let search engines index them as if they were
    // (Task 21 §59/§60). Real packages stay fully indexable.
    robots: pkg.isDemo ? { index: false, follow: true } : undefined,
  };
}

/** Product/Offer only for REAL, bookable packages — a demo package is
 * never described to search engines as a real commercial offer (Task 21
 * §41). No Review/AggregateRating is ever emitted, for either kind —
 * this project has no genuine package review data yet. */
function packageJsonLd(pkg: PackageView) {
  const url = canonicalUrl(`/maldives/packages/${pkg.slug}`);
  const breadcrumb = breadcrumbJsonLd(
    [{ label: "Maldives", href: "/maldives/" }, { label: "Packages", href: "/maldives/packages/" }, { label: pkg.title }],
    `/maldives/packages/${pkg.slug}`,
  );

  if (pkg.isDemo || pkg.price === null) return [breadcrumb];

  const product = {
    "@context": "https://schema.org",
    "@type": "Product",
    name: pkg.title,
    description: pkg.shortDescription ?? undefined,
    url,
    brand: { "@type": "Organization", name: "Maldives Tour Guide", url: getSiteUrl() },
    offers: {
      "@type": "Offer",
      price: pkg.price,
      priceCurrency: pkg.currency ?? "USD",
      availability: "https://schema.org/InStock",
      url,
    },
  };
  return [breadcrumb, product];
}

function faqJsonLd(pkg: PackageView) {
  return {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: pkg.faqs.map((faq) => ({ "@type": "Question", name: faq.question, acceptedAnswer: { "@type": "Answer", text: faq.answer } })),
  };
}

function DemoEnquiryCta({ pkg }: { pkg: PackageView }) {
  const message = encodeURIComponent(`Hi, I'm interested in the "${pkg.title}" package (${pkg.nights} nights) — is something like this available?`);
  return (
    <div className="mt-4 rounded-2xl border border-amber-200 bg-amber-50 p-4">
      <p className="text-sm text-amber-900">
        This is a sample itinerary while our real commercial package inventory is being finalized. Message us and we&rsquo;ll help build a real
        package around what you want.
      </p>
      <a
        href={`https://wa.me/${WHATSAPP_NUMBER}?text=${message}`}
        target="_blank"
        rel="noopener noreferrer"
        className="mt-3 inline-flex items-center justify-center gap-2 rounded-full bg-[#25D366] px-5 py-2.5 text-sm font-medium text-white hover:opacity-90"
      >
        Enquire on WhatsApp
      </a>
    </div>
  );
}

export async function PackageDetailPage({ slug }: { slug: string }) {
  const pkg = await getPackageViewBySlug(slug);
  if (!pkg) notFound();

  const related = await getRelatedPackageViews(pkg, 6);

  return (
    <main>
      {packageJsonLd(pkg).map((entry, i) => (
        <script key={i} type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(entry) }} />
      ))}
      {pkg.faqs.length > 0 && <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd(pkg)) }} />}

      <PageHero
        breadcrumbs={[
          { label: "Maldives", href: "/maldives/" },
          { label: "Packages", href: "/maldives/packages/" },
          { label: pkg.title },
        ]}
        eyebrow="Maldives package"
        title={pkg.title}
        description={pkg.shortDescription ?? undefined}
        image={pkg.heroImage}
        meta={
          <div className="flex flex-wrap items-center gap-2">
            {pkg.isMtgCurated && !pkg.isDemo && <Badge tone="aqua">MTG-curated</Badge>}
            {pkg.provider && !pkg.isDemo && <span className="text-neutral-600">Operated by {pkg.provider.title}</span>}
            {pkg.categories.map((c) => (
              <Link key={c} href={`/maldives/packages/${c}/`} className="rounded-full border border-white/40 px-2.5 py-1 text-xs text-white hover:bg-white/10">
                {PACKAGE_CATEGORY_TITLE[c]}
              </Link>
            ))}
          </div>
        }
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        {/* Price + duration + CTA */}
        <div className="flex flex-wrap items-end justify-between gap-4 rounded-2xl border border-neutral-200 p-5">
          <div>
            {pkg.nights !== null && (
              <p className="text-xl font-semibold text-ocean-900">
                {pkg.nights} Night{pkg.nights === 1 ? "" : "s"} / {pkg.days} Days
              </p>
            )}
            <p className="mt-1 text-lg text-neutral-800">
              {pkg.price !== null ? (
                <>
                  From <span className="font-semibold text-ocean-900">{pkg.currency ?? "USD"} {pkg.price.toLocaleString()}</span>{" "}
                  {pkg.priceType && <span className="text-sm text-neutral-500">{PRICE_TYPE_LABEL[pkg.priceType]}</span>}
                </>
              ) : (
                "Quote on request"
              )}
            </p>
            {pkg.rating !== null && (
              <p className="mt-1 flex items-center gap-1 text-sm text-amber-600">
                <span aria-hidden="true">&#9733;</span>
                <span className="font-medium">{pkg.rating.toFixed(1)}</span>
                {pkg.ratingCount !== null && <span className="text-neutral-500">({pkg.ratingCount} demo ratings)</span>}
              </p>
            )}
          </div>
          {pkg.isDemo ? (
            <DemoEnquiryCta pkg={pkg} />
          ) : (
            <NodeInquiryToggle
              productNodeId={pkg.id}
              productTitle={pkg.title}
              source={pkg.categories.includes("fishing") ? "fishing" : "package"}
              {...(pkg.categories.includes("fishing") ? FISHING_PACKAGE_CTA : bookingCta("package"))}
            />
          )}
        </div>

        {/* Guest-count pricing table — only present for packages sourced from
            a real per-guest-tier rate sheet (currently just the MFH fishing
            packages). pkg.price already shows the 5-guest "best value" rate
            above; this table is the full 1-5 guest breakdown from the same
            source, never a separate/different figure. */}
        {MFH_PRICE_TABLES[pkg.slug] && (
          <section className="mt-8">
            <h2 className="text-lg font-semibold text-ocean-900">Price by Group Size</h2>
            <p className="mt-1 text-sm text-neutral-600">Per person, based on guests sharing the boat — from our own rate sheet.</p>
            <div className="mt-3 overflow-x-auto">
              <table className="min-w-full text-sm">
                <thead>
                  <tr className="border-b border-neutral-200 text-left text-neutral-500">
                    <th className="py-2 pr-4 font-medium">Guests</th>
                    <th className="py-2 pr-4 font-medium">Price per person</th>
                  </tr>
                </thead>
                <tbody>
                  {MFH_PRICE_TABLES[pkg.slug].map((row) => (
                    <tr key={row.guests} className={`border-b border-neutral-100 ${row.isBestValue ? "bg-lagoon-50" : ""}`}>
                      <td className="py-2 pr-4">
                        {row.guests} guest{row.guests === 1 ? "" : "s"}
                        {row.isBestValue && <span className="ml-2 rounded-full bg-maldives-600 px-2 py-0.5 text-xs font-medium text-white">Best value</span>}
                      </td>
                      <td className="py-2 pr-4 font-medium text-ocean-900">
                        USD {row.websitePrice.toLocaleString()}
                        <span className="ml-2 text-xs font-normal text-neutral-400 line-through">USD {row.sourcePrice.toLocaleString()}</span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </section>
        )}

        {/* Overview */}
        {pkg.description && (
          <section className="mt-10">
            <h2 className="text-xl font-semibold text-ocean-900">Overview</h2>
            <p className="mt-2 text-sm text-neutral-700">{pkg.description}</p>
          </section>
        )}

        {/* Gallery */}
        {pkg.images.length > 0 && (
          <section className="mt-8">
            <h2 className="text-xl font-semibold text-ocean-900">Gallery</h2>
            <div className="mt-3 grid grid-cols-2 gap-2 sm:grid-cols-3">
              {pkg.images.map((image) => (
                <MediaImage key={image.id} asset={image} alt={pkg.title} aspectClassName="aspect-[4/3]" />
              ))}
            </div>
          </section>
        )}

        {/* Video */}
        {pkg.youtubeId && (
          <section className="mt-8">
            <h2 className="text-xl font-semibold text-ocean-900">Video</h2>
            <div className="mt-3 aspect-video w-full overflow-hidden rounded-2xl bg-neutral-100">
              <iframe
                className="h-full w-full"
                src={`https://www.youtube.com/embed/${pkg.youtubeId}`}
                title={pkg.title}
                loading="lazy"
                allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                referrerPolicy="strict-origin-when-cross-origin"
                allowFullScreen
              />
            </div>
          </section>
        )}

        {/* Highlights */}
        {pkg.highlights.length > 0 && (
          <section className="mt-8">
            <h2 className="text-xl font-semibold text-ocean-900">Highlights</h2>
            <ul className="mt-3 grid grid-cols-1 gap-2 sm:grid-cols-2">
              {pkg.highlights.map((h) => (
                <li key={h} className="flex items-start gap-2 text-sm text-neutral-700">
                  <span aria-hidden="true" className="mt-0.5 text-maldives-600">
                    &#10003;
                  </span>
                  <span>{h}</span>
                </li>
              ))}
            </ul>
          </section>
        )}

        {/* Who it's for */}
        {pkg.bestFor.length > 0 && (
          <section className="mt-8">
            <h2 className="text-xl font-semibold text-ocean-900">Who This Package Is For</h2>
            <div className="mt-3 flex flex-wrap gap-2">
              {pkg.bestFor.map((b) => (
                <span key={b} className="rounded-full bg-lagoon-50 px-3 py-1 text-sm text-ocean-800">
                  {b}
                </span>
              ))}
            </div>
          </section>
        )}

        {/* Itinerary */}
        {pkg.itinerary.length > 0 && (
          <section className="mt-10">
            <h2 className="text-xl font-semibold text-ocean-900">Itinerary</h2>
            <ol className="mt-4 space-y-4">
              {pkg.itinerary.map((day) => (
                <li key={day.dayLabel} className={CARD_CLASS}>
                  <div className="flex flex-wrap items-baseline justify-between gap-2">
                    <h3 className="text-lg font-medium text-ocean-900">{day.title}</h3>
                    <span className="text-sm text-neutral-500">{day.dayLabel}</span>
                  </div>
                  {day.description && <p className="mt-2 text-sm text-neutral-700">{day.description}</p>}
                  {day.links.length > 0 && (
                    <ul className="mt-2 flex flex-wrap gap-2">
                      {day.links.map((link) => (
                        <li key={link.href + link.label}>
                          <Link href={link.href} className="rounded-full border border-neutral-300 px-2.5 py-1 text-xs text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
                            {link.label}
                          </Link>
                        </li>
                      ))}
                    </ul>
                  )}
                </li>
              ))}
            </ol>
          </section>
        )}

        {/* Accommodation */}
        {pkg.accommodations.length > 0 && (
          <section className="mt-10">
            <h2 className="text-xl font-semibold text-ocean-900">Accommodation</h2>
            <ul className="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2">
              {pkg.accommodations.map((a) => (
                <li key={a.accommodation.id} className={CARD_CLASS}>
                  {a.accommodation.heroImage && (
                    <div className={CARD_IMAGE_BLEED_CLASS}>
                      <MediaImage asset={a.accommodation.heroImage} alt={a.accommodation.title} aspectClassName="aspect-[16/10]" />
                    </div>
                  )}
                  <Link href={a.href} className="font-medium text-ocean-900 hover:text-maldives-600">
                    {a.accommodation.title}
                  </Link>
                  {a.accommodation.primaryLocation && <p className="mt-1 text-sm text-neutral-600">{a.accommodation.primaryLocation.title}</p>}
                </li>
              ))}
            </ul>
          </section>
        )}

        {/* Included / Excluded */}
        <div className="mt-10 grid grid-cols-1 gap-6 sm:grid-cols-2">
          {pkg.included.length > 0 && (
            <section>
              <h2 className="text-lg font-semibold text-ocean-900">What&rsquo;s Included</h2>
              <ul className="mt-3 space-y-1.5 text-sm text-neutral-700">
                {pkg.included.map((i) => (
                  <li key={i} className="flex items-start gap-2">
                    <span aria-hidden="true" className="mt-0.5 text-maldives-600">
                      &#10003;
                    </span>
                    <span>{i}</span>
                  </li>
                ))}
              </ul>
            </section>
          )}
          {pkg.excluded.length > 0 && (
            <section>
              <h2 className="text-lg font-semibold text-ocean-900">What&rsquo;s Not Included</h2>
              <ul className="mt-3 space-y-1.5 text-sm text-neutral-700">
                {pkg.excluded.map((e) => (
                  <li key={e} className="flex items-start gap-2">
                    <span aria-hidden="true" className="mt-0.5 text-neutral-400">
                      &#10005;
                    </span>
                    <span>{e}</span>
                  </li>
                ))}
              </ul>
            </section>
          )}
        </div>

        {/* Activities */}
        {pkg.activities.length > 0 && (
          <section className="mt-10">
            <h2 className="text-xl font-semibold text-ocean-900">Activities</h2>
            <ul className="mt-3 flex flex-wrap gap-2">
              {pkg.activities.map((a) => (
                <li key={a.activity.id}>
                  <Link href={a.href} className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
                    {a.activity.title}
                  </Link>
                </li>
              ))}
            </ul>
          </section>
        )}

        {/* Transfers */}
        {pkg.transferHref && (
          <section className="mt-8">
            <h2 className="text-xl font-semibold text-ocean-900">Transfers</h2>
            <p className="mt-2 text-sm text-neutral-700">
              {pkg.transferIncluded ? "Airport Transfer Included" : "Airport Transfer Available"}
              {pkg.transferLabel && ` — ${pkg.transferLabel}`}.{" "}
              <Link href={pkg.transferHref} className="text-maldives-600 hover:underline">
                {pkg.transferLabel ?? "See Maldives Transfers"}
              </Link>
            </p>
          </section>
        )}

        {/* Destination information */}
        {pkg.destinations.length > 0 && (
          <section className="mt-8">
            <h2 className="text-xl font-semibold text-ocean-900">Destination</h2>
            <p className="mt-2 flex flex-wrap gap-x-1 text-sm text-neutral-700">
              {pkg.destinations.map((d, i) => (
                <span key={d.id}>
                  {i > 0 && ", "}
                  <Link href={d.locationType === "atoll" ? `/maldives/atolls/${d.slug}/` : `/maldives/islands/${d.slug}/`} className="text-maldives-600 hover:underline">
                    {d.title}
                  </Link>
                </span>
              ))}
              {pkg.atoll && !pkg.destinations.some((d) => d.id === pkg.atoll?.id) && (
                <>
                  {" · "}
                  <Link href={`/maldives/atolls/${pkg.atoll.slug}/`} className="text-maldives-600 hover:underline">
                    {pkg.atoll.title}
                  </Link>
                </>
              )}
            </p>
          </section>
        )}

        {/* FAQs */}
        {pkg.faqs.length > 0 && (
          <section className="mt-12 border-t border-neutral-200 pt-10">
            <h2 className="text-xl font-semibold text-ocean-900">Frequently Asked Questions</h2>
            <dl className="mt-4 space-y-6">
              {pkg.faqs.map((faq) => (
                <div key={faq.question}>
                  <dt className="font-medium text-ocean-900">{faq.question}</dt>
                  <dd className="mt-1 text-sm text-neutral-700">{faq.answer}</dd>
                </div>
              ))}
            </dl>
          </section>
        )}

        {/* Related packages */}
        {related.length > 0 && (
          <section className="mt-12 border-t border-neutral-200 pt-10">
            <h2 className="text-xl font-semibold text-ocean-900">You May Also Like</h2>
            <ul className="mt-4 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
              {related.map((r) => (
                <PackageCard key={r.slug} pkg={r} />
              ))}
            </ul>
          </section>
        )}

        {/* Related Maldives content */}
        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Explore More Maldives</h2>
          <nav aria-label="Related Maldives links" className="mt-4 flex flex-wrap gap-2">
            {[
              { href: "/maldives/packages/", label: "All Maldives Packages" },
              ...pkg.categories.map((c) => ({ href: `/maldives/packages/${c}/`, label: PACKAGE_CATEGORY_TITLE[c] })),
              { href: "/maldives/transfers/", label: "Maldives Transfers" },
              { href: "/maldives/travel-guide/", label: "Travel Guide" },
            ].map((link) => (
              <Link key={link.href} href={link.href} className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
                {link.label}
              </Link>
            ))}
          </nav>
        </section>
      </div>
    </main>
  );
}
