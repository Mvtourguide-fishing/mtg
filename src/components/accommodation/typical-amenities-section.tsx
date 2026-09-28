import type { AccommodationType } from "@/lib/accommodations/types";

/**
 * The Phase 1 legacy-content audit found the "Property Facilities and
 * Services" list on every migrated resort/hotel/guesthouse page to be
 * byte-for-byte identical boilerplate — the same ten items regardless of
 * the property's actual amenities. Per the resulting decision, this is
 * shown but clearly labeled as a general/typical list, never asserted as
 * verified for this specific property.
 */
const TYPICAL_AMENITIES = ["Pool", "Free Wi-Fi", "Bar", "Laundry service", "Spa", "Restaurant/meals", "Gift shop", "Diving & water sports", "Fitness centre", "First-aid clinic"];

const LABEL: Record<AccommodationType, string> = {
  resort: "Typical amenities at Maldives resorts",
  hotel: "Typical amenities at Maldives hotels",
  guesthouse: "Typical amenities at Maldives guesthouses",
  villa: "Typical amenities at Maldives villas",
  liveaboard: "Typical amenities on Maldives liveaboards",
  other: "Typical amenities at Maldives accommodations",
};

export function TypicalAmenitiesSection({ accommodationType }: { accommodationType: AccommodationType }) {
  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">{LABEL[accommodationType]}</h2>
      <p className="mt-1 text-sm text-neutral-600">
        A general guide to what properties of this type commonly offer — not a verified list of this specific property&rsquo;s own
        facilities. Confirm exact amenities with the property when you request an offer.
      </p>
      <ul className="mt-4 flex flex-wrap gap-2">
        {TYPICAL_AMENITIES.map((item) => (
          <li key={item} className="rounded-full border border-neutral-200 px-3 py-1.5 text-sm text-neutral-700">
            {item}
          </li>
        ))}
      </ul>
    </section>
  );
}
