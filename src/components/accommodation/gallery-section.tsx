import { MediaImage } from "@/components/ui/media-image";
import type { MediaAsset } from "@/lib/media/types";

export function GallerySection({ images, accommodationTitle }: { images: MediaAsset[]; accommodationTitle: string }) {
  if (images.length === 0) return null;

  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">Gallery</h2>
      <ul className="mt-4 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
        {images.map((image, i) => (
          <li key={image.id} className="relative aspect-[4/3] overflow-hidden rounded-xl">
            <MediaImage asset={image} alt={`${accommodationTitle} — photo ${i + 1}`} fillParent />
          </li>
        ))}
      </ul>
    </section>
  );
}
