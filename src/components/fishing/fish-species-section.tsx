import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { MediaImage } from "@/components/ui/media-image";
import { fishSpeciesByCategory } from "@/lib/fishing/fish-species";

/**
 * Real fish species content recovered from the legacy site's own
 * fish-species-maldives.html — see src/lib/fishing/fish-species.ts for the
 * full source data and image-verification notes.
 */
export function FishSpeciesSection() {
  const grouped = fishSpeciesByCategory();

  return (
    <section id="fish-species" className="mt-12 scroll-mt-20 border-t border-neutral-200 pt-10">
      <h2 className="text-xl font-semibold text-ocean-900">Types of Fishes in the Maldives</h2>
      <p className="mt-2 text-sm text-neutral-700">
        Over 1,100 fish species inhabit Maldivian waters — from colorful reef dwellers to powerful pelagic predators. Here are the species you&rsquo;re
        most likely to see or catch, grouped by where they&rsquo;re found.
      </p>

      <div className="mt-8 space-y-10">
        {grouped.map(({ category, species }) => (
          <div key={category.slug} id={category.slug} className="scroll-mt-20">
            <h3 className="text-lg font-semibold text-ocean-900">{category.title}</h3>
            <p className="mt-1 text-sm text-neutral-700">{category.intro}</p>
            <ul className="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
              {species.map((fish) => (
                <li key={fish.slug} className={CARD_CLASS}>
                  <div className={CARD_IMAGE_BLEED_CLASS}>
                    <MediaImage asset={fish.image} alt={fish.name} aspectClassName="aspect-[4/3]" />
                  </div>
                  <h4 className="text-base font-medium text-ocean-900">{fish.name}</h4>
                  <p className="text-xs italic text-neutral-500">{fish.scientificName}</p>
                  <dl className="mt-2 space-y-0.5 text-xs text-neutral-600">
                    <div className="flex gap-1">
                      <dt className="font-medium text-neutral-700">Size:</dt>
                      <dd>{fish.size}</dd>
                    </div>
                    <div className="flex gap-1">
                      <dt className="font-medium text-neutral-700">Habitat:</dt>
                      <dd>{fish.habitat}</dd>
                    </div>
                    <div className="flex gap-1">
                      <dt className="font-medium text-neutral-700">{fish.dietOrSeasonLabel}:</dt>
                      <dd>{fish.dietOrSeason}</dd>
                    </div>
                  </dl>
                  <p className="mt-2 text-sm text-neutral-700">{fish.description}</p>
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>
    </section>
  );
}
