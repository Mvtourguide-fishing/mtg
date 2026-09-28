const YOUTUBE_VIDEO_ID = "VI-9L68aBMg";
const YOUTUBE_VIDEO_TITLE = "Maldives Fishing";

/**
 * Task 22 §21: a real video recovered from the legacy site
 * (release/public_html/maldives-fishing-trips.html), embedded properly —
 * never an invented id. Same pattern as
 * src/components/transfers/route-video.tsx.
 */
export function FishingVideo() {
  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">Fishing in the Maldives — Video</h2>
      <p className="mt-2 text-sm text-neutral-700">A look at what a real Maldives fishing trip looks like on the water.</p>
      <div className="mt-4 aspect-video w-full overflow-hidden rounded-2xl bg-neutral-100">
        <iframe
          className="h-full w-full"
          src={`https://www.youtube.com/embed/${YOUTUBE_VIDEO_ID}`}
          title={YOUTUBE_VIDEO_TITLE}
          loading="lazy"
          allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
          referrerPolicy="strict-origin-when-cross-origin"
          allowFullScreen
        />
      </div>
    </section>
  );
}

export function fishingVideoJsonLd() {
  return {
    "@context": "https://schema.org",
    "@type": "VideoObject",
    name: YOUTUBE_VIDEO_TITLE,
    description: "A look at Maldives fishing trips, recovered from Maldives Tour Guide's own legacy content.",
    embedUrl: `https://www.youtube.com/embed/${YOUTUBE_VIDEO_ID}`,
    thumbnailUrl: [`https://i.ytimg.com/vi/${YOUTUBE_VIDEO_ID}/hqdefault.jpg`],
  };
}
