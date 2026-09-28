import type { Metadata } from "next";
import Link from "next/link";

import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { MediaImage } from "@/components/ui/media-image";
import { PageHero } from "@/components/ui/page-hero";
import { getAtolls } from "@/lib/locations/repository";
import { getHeroMediaByNodeIds } from "@/lib/media/repository";
import { canonicalUrl } from "@/lib/seo/site";

export function generateMetadata(): Metadata {
  const title = "Maldives Atolls | MTG";
  const description = "Every administrative atoll of the Maldives, with its inhabited islands.";
  return {
    title,
    description,
    alternates: { canonical: canonicalUrl("/maldives/atolls") },
    openGraph: { title, description, url: canonicalUrl("/maldives/atolls") },
  };
}

export default async function AtollsPage() {
  const atolls = await getAtolls();
  const heroByAtollId = await getHeroMediaByNodeIds(atolls.map((a) => a.id));

  return (
    <main>
      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Atolls" }]}
        eyebrow="Destinations"
        title="Atolls of the Maldives"
        description={`${atolls.length} administrative atolls, each made up of inhabited islands.`}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        <ul className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
          {atolls.map((atoll) => (
            <li key={atoll.id}>
              <Link href={`/maldives/atolls/${atoll.slug}/`} className={`${CARD_CLASS} block`}>
                {heroByAtollId.get(atoll.id) && (
                  <div className={CARD_IMAGE_BLEED_CLASS}>
                    <MediaImage asset={heroByAtollId.get(atoll.id)} alt={atoll.title} aspectClassName="aspect-[16/10]" />
                  </div>
                )}
                <span className="text-lg font-medium text-ocean-900">{atoll.title}</span>
                <p className="mt-1 text-sm text-neutral-600">
                  {atoll.islandCount} inhabited island{atoll.islandCount === 1 ? "" : "s"}
                </p>
              </Link>
            </li>
          ))}
        </ul>
      </div>
    </main>
  );
}
