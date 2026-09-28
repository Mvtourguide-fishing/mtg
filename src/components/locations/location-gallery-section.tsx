import { MediaImage } from "@/components/ui/media-image";
import type { MediaAsset } from "@/lib/media/types";

/** Real gallery photos attached via node_media (role='gallery') — the
 * generic counterpart to the accommodation GallerySection, for islands and
 * atolls, which don't have their own dedicated gallery UI otherwise. */
export function LocationGallerySection({ title, images }: { title: string; images: MediaAsset[] }) {
  if (images.length === 0) return null;

  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">{title} Gallery</h2>
      <ul className="mt-4 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
        {images.map((image) => (
          <li key={image.id} className="overflow-hidden rounded-xl">
            <MediaImage asset={image} alt={image.altText ?? title} aspectClassName="aspect-square" />
          </li>
        ))}
      </ul>
    </section>
  );
}
