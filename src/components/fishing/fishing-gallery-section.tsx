import { MediaImage } from "@/components/ui/media-image";
import { asset } from "@/lib/packages/category-images";

/**
 * The owner's own newly-uploaded fishing gallery photos
 * (assets/uploads/fishing/images/gallery/) — real photos of the charter
 * boat, catches, and the Maldives atolls, registered by
 * scripts/attach-fishing-uploads.mjs. Not tied to any single node, so kept
 * as a plain hardcoded list here (same pattern as fishing-video.tsx).
 */
const GALLERY_IMAGES = [
  asset("8c2e8baf-376e-b0b6-a222-a8450b073a09", "uploads/assets/uploads/fishing/images/gallery/maldives-atoll-aerial-view.webp", "Maldives atoll aerial view"),
  asset("cd447d34-97f4-718f-3b87-779345d99c1f", "uploads/assets/uploads/fishing/images/gallery/fishing-liveaboard-maldives.webp", "Fishing liveaboard in the Maldives"),
  asset("c1e3ca08-0e43-1f98-3061-c6d9951c6834", "uploads/assets/uploads/fishing/images/gallery/giant-trevally.webp", "Giant trevally caught fishing in the Maldives"),
  asset("a1f586e2-ef91-87af-5d6f-c1b39315a7d7", "uploads/assets/uploads/fishing/images/gallery/reef-fishing-grouper.webp", "Reef fishing grouper in the Maldives"),
  asset("d647a2a4-2099-8667-168f-88c292b6de0d", "uploads/assets/uploads/fishing/images/gallery/sailfish-maldives.webp", "Sailfish caught fishing in the Maldives"),
  asset("a8ba6833-886f-504b-136f-7cb31111c497", "uploads/assets/uploads/fishing/images/gallery/yellowfin-tuna-fishing-maldives.webp", "Yellowfin tuna caught fishing in the Maldives"),
  asset("dbd93db3-e064-94a9-5883-96ea6c3aebf1", "uploads/assets/uploads/fishing/images/gallery/blue-marlin.avif", "Blue marlin caught fishing in the Maldives"),
  // Round 2 (20 more files added to the same folder — see
  // scripts/attach-fishing-gallery-round2.mjs). 4 of that batch replaced a
  // broken legacy photo reference on a specific fish-species card instead
  // (see src/lib/fishing/fish-species.ts) and 1 was a byte-identical
  // duplicate — both excluded here to avoid showing the same photo twice.
  asset("d21c225c-e40a-7361-63fa-3e072dd81026", "uploads/assets/uploads/fishing/images/gallery/ari-atoll-spots.webp", "Trevally caught fishing in the Maldives"),
  asset("095196ab-f287-c9a6-604f-6b6a0a9c5a83", "uploads/assets/uploads/fishing/images/gallery/best-time-fishing.webp", "Sailfish caught fishing in the Maldives"),
  asset("2193250b-9c16-35ad-5cff-27dd8bee233d", "uploads/assets/uploads/fishing/images/gallery/big-game-fishing-in-maldives.webp", "Sailfish caught fishing in the Maldives"),
  asset("6bf81059-4559-5a1b-0f5f-2a8dee9ca99b", "uploads/assets/uploads/fishing/images/gallery/deep-sea-fishing-maldives.webp", "Coral grouper caught fishing in the Maldives"),
  asset("f7b6b8e0-4d72-6329-b52b-62c5f8b24472", "uploads/assets/uploads/fishing/images/gallery/fishing-in-maldives.webp", "Trevally caught fishing in the Maldives"),
  asset("8dc28836-323e-85d9-d5ad-4d4ddd294c13", "uploads/assets/uploads/fishing/images/gallery/fishing-tours-maldives.webp", "Yellowfin tuna caught on a Maldives fishing trip"),
  asset("9af0b52c-d5bf-c732-f0aa-cb9272c6e983", "uploads/assets/uploads/fishing/images/gallery/fly-fishing-maldives.webp", "Fly fishing on the flats in the Maldives"),
  asset("65ce543b-f8cb-5760-a0ed-e49aefe7280d", "uploads/assets/uploads/fishing/images/gallery/giant-yellowfin-tuna.webp", "Yellowfin tuna catch on a Maldives fishing charter"),
  asset("63d606ab-e290-cc62-fe6e-b1fcf3bf5415", "uploads/assets/uploads/fishing/images/gallery/gt-fishing-guide.webp", "Giant trevally caught fishing in the Maldives"),
  asset("d82258a7-f7ae-f6ea-c603-5c18159eff68", "uploads/assets/uploads/fishing/images/gallery/maldives-fishing-charters.webp", "Giant trevally caught on a Maldives fishing charter"),
  asset("0b224be8-cf15-e001-f9b4-7d32c3b664ea", "uploads/assets/uploads/fishing/images/gallery/maldives-fishing-packages.webp", "Tuna caught on a Maldives fishing trip"),
  asset("437c760e-0079-e191-b056-ebe871a06643", "uploads/assets/uploads/fishing/images/gallery/maldives-fishing-trips.webp", "Fish caught on a Maldives fishing trip"),
  asset("720ed678-f61d-74c4-00d3-13879c709508", "uploads/assets/uploads/fishing/images/gallery/maldives-fishing.webp", "Coral grouper caught fishing in the Maldives"),
  asset("f561202d-6944-41a5-6bb8-7d414cbb0447", "uploads/assets/uploads/fishing/images/gallery/sail-fishing-maldives.webp", "Sailfish caught fishing in the Maldives"),
  asset("7fb94bc0-e308-f850-82cf-10a86c0ee91d", "uploads/assets/uploads/fishing/images/gallery/sports-fishing-maldives.webp", "Mahi-mahi caught fishing in the Maldives"),
];

export function FishingGallerySection() {
  return (
    <section id="fishing-gallery" className="mt-12 scroll-mt-20 border-t border-neutral-200 pt-10">
      <h2 className="text-xl font-semibold text-ocean-900">Fishing Gallery</h2>
      <p className="mt-2 text-sm text-neutral-700">Real photos from Maldives fishing charters and catches — the boat, the crew, and what comes up on the line.</p>
      <ul className="mt-4 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
        {GALLERY_IMAGES.map((image) => (
          <li key={image.id} className="overflow-hidden rounded-xl">
            <MediaImage asset={image} alt={image.altText ?? "Maldives fishing"} aspectClassName="aspect-square" />
          </li>
        ))}
      </ul>
    </section>
  );
}
