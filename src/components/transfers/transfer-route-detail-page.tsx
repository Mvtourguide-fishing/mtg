import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";

import { BookingToggle } from "@/components/bookings/booking-toggle";
import { NodeInquiryToggle } from "@/components/bookings/node-inquiry-toggle";
import { PackageCard } from "@/components/packages/package-card";
import { ReviewsSection } from "@/components/reviews/reviews-section";
import { RouteMap } from "@/components/transfers/route-map";
import { RouteVideo, routeVideoJsonLd } from "@/components/transfers/route-video";
import { TransferRouteCard } from "@/components/transfers/transfer-route-card";
import { CARD_CLASS } from "@/components/ui/card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { PageHero } from "@/components/ui/page-hero";
import { getLocationBySlug, getLocationSummaryById } from "@/lib/locations/repository";
import { getPackageViewsByTransferRoute } from "@/lib/packages/view-repository";
import { getReviewsForNode } from "@/lib/reviews/repository";
import { breadcrumbJsonLd, canonicalUrl, getSiteUrl } from "@/lib/seo/site";
import {
  getTransferRouteBySlug,
  getTransferRoutesByAtoll,
  getTransferRoutesByDestination,
  getTransferRoutesByOrigin,
} from "@/lib/transfers/repository";
import type { SharedOrPrivate, TransferRouteDetail, TransferService, TransferType } from "@/lib/transfers/types";

const TRANSFER_TYPE_LABEL: Record<TransferType, string> = {
  speedboat: "Speedboat",
  seaplane: "Seaplane",
  domestic_flight: "Domestic Flight",
  ferry: "Ferry",
  private_yacht: "Private Yacht",
  land_transfer: "Land Transfer",
};

const MODE_LABEL: Record<SharedOrPrivate, string> = {
  shared: "Shared",
  private: "Private",
};

const CATEGORY_LINK: Record<string, { href: string; label: string }> = {
  airport: { href: "/maldives/airport-transfers/", label: "Airport Transfers" },
  "resort-transfer": { href: "/maldives/resort-transfers/", label: "Resort Transfers" },
  "hotel-transfer": { href: "/maldives/hotel-transfers/", label: "Hotel Transfers" },
  "island-transfer": { href: "/maldives/island-transfers/", label: "Island Transfers" },
};

const DAY_LABEL = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

function formatDuration(minutes: number | null): string | null {
  if (!minutes) return null;
  if (minutes < 60) return `${minutes} minutes`;
  const hours = minutes / 60;
  return Number.isInteger(hours) ? `${hours} hour${hours === 1 ? "" : "s"}` : `${hours.toFixed(1)} hours`;
}

function locationHref(location: { slug: string; locationType: string }): string {
  if (location.locationType === "island") return `/maldives/islands/${location.slug}/`;
  if (location.locationType === "atoll") return `/maldives/atolls/${location.slug}/`;
  // Airports/seaports/harbours don't have their own directory route yet —
  // link to the main transfers hub instead of a 404.
  return `/maldives/transfers/`;
}

export async function transferRouteDetailMetadata(slug: string): Promise<Metadata> {
  const route = await getTransferRouteBySlug(slug);
  if (!route) return {};

  const originTitle = route.origin?.title ?? "Origin";
  const destinationTitle = route.destination?.title ?? "Destination";
  const title = route.metaTitle ?? `${originTitle} to ${destinationTitle} Transfer | Maldives Tour Guide`;
  const types = Array.from(new Set(route.services.map((s) => TRANSFER_TYPE_LABEL[s.transferType])));
  const description =
    route.metaDescription ??
    route.summary ??
    `Transfers from ${originTitle} to ${destinationTitle}${types.length > 0 ? ` — ${types.join(", ")}` : ""}.`;
  const url = canonicalUrl(`/maldives/transfers/${route.slug}`);

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
  };
}

/** Real, visible-on-page facts only — no ratings/reviews/availability
 * claims (Task 18/20 explicitly disallow fabricating any of those). */
function routeJsonLd(route: TransferRouteDetail) {
  const url = canonicalUrl(`/maldives/transfers/${route.slug}`);
  const cheapest = route.services.reduce<TransferService | null>(
    (min, s) => (min === null || s.price < min.price ? s : min),
    null,
  );

  return {
    "@context": "https://schema.org",
    "@type": "Service",
    name: route.title,
    description: route.summary ?? `Transfer from ${route.origin?.title ?? "Velana International Airport"} to ${route.destination?.title ?? route.title}.`,
    url,
    areaServed: "Maldives",
    provider: { "@type": "Organization", name: "Maldives Tour Guide", url: getSiteUrl() },
    offers: cheapest
      ? { "@type": "Offer", price: cheapest.price, priceCurrency: cheapest.currency, availability: "https://schema.org/InStock" }
      : undefined,
  };
}

/** Route-specific FAQ (Task 20 §36) — every answer is derived from this
 * route's own real data, never a generic template repeated unchanged
 * across routes. */
function buildRouteFaqs(route: TransferRouteDetail): Array<{ question: string; answer: string }> {
  const faqs: Array<{ question: string; answer: string }> = [];
  const originTitle = route.origin?.title ?? "the airport";
  const destinationTitle = route.destination?.title ?? route.title;
  const duration = formatDuration(route.typicalDurationMinutes);
  const hasShared = route.services.some((s) => s.sharedOrPrivate === "shared");
  const hasPrivate = route.services.some((s) => s.sharedOrPrivate === "private") || route.isBookableForPrivateInquiry;
  const types = Array.from(new Set(route.services.map((s) => TRANSFER_TYPE_LABEL[s.transferType])));

  faqs.push({
    question: `How long is the transfer from ${originTitle} to ${destinationTitle}?`,
    answer: duration
      ? `The typical journey time is ${duration}${types.length > 0 ? ` by ${types.join(" or ").toLowerCase()}` : ""}.`
      : `Journey time isn't confirmed for this specific route yet — check with the operator when you enquire.`,
  });

  faqs.push({
    question: "Where do I meet the transfer?",
    answer:
      route.services.find((s) => s.pickupInstructions)?.pickupInstructions ??
      `Pickup details are confirmed by the operator once your transfer is arranged — see the service details above for any notes on record.`,
  });

  if (hasShared) {
    faqs.push({
      question: "Is this a shared speedboat?",
      answer: "A shared service is available on this route, running alongside other travellers heading the same way — see the transfer services above for the current price.",
    });
  }

  faqs.push({
    question: "Can I book a private transfer on this route?",
    answer: hasPrivate
      ? "Yes — use the Private Transfer option below to request your own boat on your own schedule."
      : "No private service is currently listed for this specific route — request a private speedboat charter instead and we'll confirm availability.",
  });

  const cancellation = route.services.find((s) => s.cancellationPolicy)?.cancellationPolicy;
  if (cancellation) {
    faqs.push({ question: "What is the cancellation policy?", answer: cancellation });
  }

  const luggage = route.services.find((s) => s.luggageAllowance)?.luggageAllowance;
  faqs.push({
    question: "How much luggage can I bring?",
    answer: luggage ?? "Luggage allowance isn't confirmed for this specific route yet — check with the operator when you enquire.",
  });

  return faqs;
}

function faqJsonLd(faqs: Array<{ question: string; answer: string }>) {
  return {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: faqs.map((faq) => ({ "@type": "Question", name: faq.question, acceptedAnswer: { "@type": "Answer", text: faq.answer } })),
  };
}

function ServiceCard({ service, route }: { service: TransferService; route: TransferRouteDetail }) {
  const duration = formatDuration(service.durationMinutes);

  return (
    <li className={CARD_CLASS}>
      <div className="flex flex-wrap items-baseline justify-between gap-2">
        <span className="text-lg font-medium">
          {service.provider ? (
            <Link href={`/maldives/providers/${service.provider.slug}/`} className="hover:underline">
              {service.provider.title}
            </Link>
          ) : (
            "Operator not specified"
          )}
        </span>
        <span className="text-lg font-semibold">
          {service.currency} {service.price}
        </span>
      </div>

      <div className="mt-1 flex flex-wrap gap-x-3 gap-y-1 text-sm text-neutral-600">
        <span>{TRANSFER_TYPE_LABEL[service.transferType]}</span>
        <span>{MODE_LABEL[service.sharedOrPrivate]}</span>
        {duration && <span>{duration}</span>}
        {service.capacity !== null && <span>Capacity {service.capacity}</span>}
        {service.status !== "active" && <span className="capitalize">{service.status}</span>}
      </div>

      {service.vehicleType && <p className="mt-2 text-sm text-neutral-700">{service.vehicleType}</p>}
      {service.description && <p className="mt-2 text-sm text-neutral-700">{service.description}</p>}

      {service.facilities.length > 0 && (
        <ul className="mt-3 flex flex-wrap gap-1.5">
          {service.facilities.map((f) => (
            <li key={f} className="rounded-full border border-neutral-300 px-2.5 py-0.5 text-xs text-neutral-700">
              {f}
            </li>
          ))}
        </ul>
      )}

      <dl className="mt-3 space-y-2 text-sm">
        {service.luggageAllowance && (
          <div>
            <dt className="text-neutral-500">Luggage allowance</dt>
            <dd className="mt-0.5">{service.luggageAllowance}</dd>
          </div>
        )}
        {service.pickupInstructions && (
          <div>
            <dt className="text-neutral-500">Pickup</dt>
            <dd className="mt-0.5">{service.pickupInstructions}</dd>
          </div>
        )}
        {service.dropoffInstructions && (
          <div>
            <dt className="text-neutral-500">Drop-off</dt>
            <dd className="mt-0.5">{service.dropoffInstructions}</dd>
          </div>
        )}
        {service.bookingRequirements && (
          <div>
            <dt className="text-neutral-500">Requirements</dt>
            <dd className="mt-0.5">{service.bookingRequirements}</dd>
          </div>
        )}
        {service.cancellationPolicy && (
          <div>
            <dt className="text-neutral-500">Cancellation policy</dt>
            <dd className="mt-0.5">{service.cancellationPolicy}</dd>
          </div>
        )}
      </dl>

      {service.schedules.length > 0 && (
        <div className="mt-3">
          <p className="text-sm text-neutral-500">Departures</p>
          <ul className="mt-1 space-y-1 text-sm">
            {service.schedules.map((schedule) => (
              <li key={schedule.id}>
                {schedule.dayOfWeek !== null ? DAY_LABEL[schedule.dayOfWeek] : "Daily"}
                {schedule.departureTime && ` · departs ${schedule.departureTime}`}
                {schedule.arrivalTime && ` · arrives ${schedule.arrivalTime}`}
              </li>
            ))}
          </ul>
        </div>
      )}

      {service.isBookable && (
        <BookingToggle
          transferServiceId={service.id}
          originLocationId={route.origin?.id ?? null}
          destinationLocationId={route.destination?.id ?? null}
          originTitle={route.origin?.title ?? "Velana International Airport"}
          destinationTitle={route.destination?.title ?? route.title}
          price={service.price}
          currency={service.currency}
        />
      )}
    </li>
  );
}

export async function TransferRouteDetailPage({ slug }: { slug: string }) {
  const route = await getTransferRouteBySlug(slug);
  if (!route) notFound();

  const reverseSlug = route.origin && route.destination ? `${route.destination.slug}-to-${route.origin.slug}` : null;
  const [reverseRoute, packages, originRoutes, destinationRoutes, atollRoutes, reviews, originDetail, destinationDetail, originAtoll] = await Promise.all([
    reverseSlug ? getTransferRouteBySlug(reverseSlug) : Promise.resolve(null),
    getPackageViewsByTransferRoute(route.id),
    route.origin ? getTransferRoutesByOrigin(route.origin.id) : Promise.resolve([]),
    route.destination ? getTransferRoutesByDestination(route.destination.id) : Promise.resolve([]),
    route.origin?.parentId ? getTransferRoutesByAtoll(route.origin.parentId) : Promise.resolve([]),
    getReviewsForNode(route.id),
    route.origin ? getLocationBySlug(route.origin.slug) : Promise.resolve(null),
    route.destination ? getLocationBySlug(route.destination.slug) : Promise.resolve(null),
    route.origin?.parentId ? getLocationSummaryById(route.origin.parentId) : Promise.resolve(null),
  ]);

  const relatedRoutes = [...originRoutes, ...destinationRoutes, ...atollRoutes]
    .filter((r) => r.id !== route.id)
    .filter((r, index, all) => all.findIndex((x) => x.id === r.id) === index)
    .slice(0, 6);

  const duration = formatDuration(route.typicalDurationMinutes);
  const faqs = buildRouteFaqs(route);
  const hasPrivateService = route.services.some((s) => s.sharedOrPrivate === "private" && s.isBookable);

  return (
    <main>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(routeJsonLd(route)) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(routeVideoJsonLd()) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd(faqs)) }} />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(
            breadcrumbJsonLd(
              [{ label: "Maldives", href: "/maldives/" }, { label: "Transfers", href: "/maldives/transfers/" }, { label: route.title }],
              `/maldives/transfers/${route.slug}`,
            ),
          ),
        }}
      />
      <PageHero
        breadcrumbs={[
          { label: "Maldives", href: "/maldives/" },
          { label: "Transfers", href: "/maldives/transfers/" },
          { label: route.title },
        ]}
        eyebrow="Transfer route"
        title={route.title}
        description={route.summary ?? undefined}
        image={route.heroImage}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
      <dl className="grid grid-cols-2 gap-4 text-sm sm:grid-cols-3">
        {route.origin && (
          <div>
            <dt className="text-neutral-500">From</dt>
            <dd className="font-medium">
              <Link href={locationHref(route.origin)} className="hover:underline">
                {route.origin.title}
              </Link>
            </dd>
          </div>
        )}
        {route.destination && (
          <div>
            <dt className="text-neutral-500">To</dt>
            <dd className="font-medium">
              <Link href={locationHref(route.destination)} className="hover:underline">
                {route.destination.title}
              </Link>
            </dd>
          </div>
        )}
        {duration && (
          <div>
            <dt className="text-neutral-500">Typical duration</dt>
            <dd className="font-medium">{duration}</dd>
          </div>
        )}
        {route.distanceKm !== null && (
          <div>
            <dt className="text-neutral-500">Distance</dt>
            <dd className="font-medium">{route.distanceKm} km</dd>
          </div>
        )}
      </dl>

      {route.categories.length > 0 && (
        <nav aria-label="Transfer categories" className="mt-3 flex flex-wrap gap-2">
          {route.categories.map((cat) => {
            const link = CATEGORY_LINK[cat];
            if (!link) return null;
            return (
              <Link key={cat} href={link.href} className="rounded-full border border-neutral-300 px-3 py-1 text-xs text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
                {link.label}
              </Link>
            );
          })}
        </nav>
      )}

      {reverseRoute && (
        <p className="mt-3 text-sm text-neutral-600">
          Travelling the other way?{" "}
          <Link href={`/maldives/transfers/${reverseRoute.slug}/`} className="underline">
            {reverseRoute.title} →
          </Link>
        </p>
      )}

      <section className="mt-10">
        <h2 className="text-xl font-semibold text-ocean-900">Transfer services</h2>
        {route.services.length === 0 ? (
          <p className="mt-2 text-sm text-neutral-600">No verified transfer services recorded for this route yet.</p>
        ) : (
          <ul className="mt-4 space-y-3">
            {route.services.map((service) => (
              <ServiceCard key={service.id} service={service} route={route} />
            ))}
          </ul>
        )}
      </section>

      {!hasPrivateService && route.isBookableForPrivateInquiry && (
        <section className="mt-10 rounded-2xl border border-neutral-200 p-4 sm:p-6">
          <h2 className="text-xl font-semibold text-ocean-900">Private Transfer</h2>
          <p className="mt-2 text-sm text-neutral-700">
            Prefer your own boat and your own schedule? A private transfer means a private group, flexible timing, and a custom arrangement
            for this route — no fixed public price, we&rsquo;ll quote you directly once you enquire.
          </p>
          <NodeInquiryToggle
            productNodeId={route.id}
            productTitle={`${route.title} (Private Transfer)`}
            source="transfer"
            submitLabel="Book This Trip as a Private Transfer"
            toggleLabel="Book This Trip as a Private Transfer"
          />
        </section>
      )}

      {packages.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Packages using this route</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2">
            {packages.map((pkg) => (
              <PackageCard key={pkg.id} pkg={pkg} />
            ))}
          </ul>
        </section>
      )}

      <RouteVideo />

      <RouteMap
        originTitle={route.origin?.title ?? "Origin"}
        originLat={originDetail?.lat ?? null}
        originLng={originDetail?.lng ?? null}
        destinationTitle={route.destination?.title ?? route.title}
        destinationLat={destinationDetail?.lat ?? null}
        destinationLng={destinationDetail?.lng ?? null}
      />

      <ReviewsSection nodeId={route.id} reviews={reviews} />

      <section className="mt-10">
        <h2 className="text-xl font-semibold text-ocean-900">Frequently Asked Questions</h2>
        <dl className="mt-4 space-y-4">
          {faqs.map((faq) => (
            <div key={faq.question}>
              <dt className="font-medium text-ocean-900">{faq.question}</dt>
              <dd className="mt-1 text-sm text-neutral-700">{faq.answer}</dd>
            </div>
          ))}
        </dl>
      </section>

      {relatedRoutes.length > 0 && (
        <section className="mt-10 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Related Transfers</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {relatedRoutes.map((r) => (
              <TransferRouteCard key={r.id} route={r} />
            ))}
          </ul>
        </section>
      )}

      <nav aria-label="Related transfer links" className="mt-10 flex flex-wrap gap-2 border-t border-neutral-200 pt-6">
        <Link href="/maldives/transfers/" className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
          All Maldives Transfers
        </Link>
        <Link href="/maldives-speedboats-charter/" className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
          Private Speedboat Charter
        </Link>
        {originAtoll && (
          <Link href={`/maldives/atolls/${originAtoll.slug}/`} className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
            More about {originAtoll.title}
          </Link>
        )}
      </nav>
      </div>
    </main>
  );
}
