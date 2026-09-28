const YOUTUBE_VIDEO_ID = "1Wjic-JZ11g";
const YOUTUBE_VIDEO_TITLE = "The Best Ways to Travel Around the Maldives — Seaplane Transfers and Speedboats Explained";

/**
 * Task 20 §32: the one real video the task specifies, embedded properly
 * (a real iframe, not a bare URL), responsive, no autoplay, with an
 * accessible title. Introduced with route-relevant copy rather than
 * pretending it was filmed for this specific route.
 */
export function RouteVideo() {
  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">Getting Around the Maldives</h2>
      <p className="mt-2 text-sm text-neutral-700">
        A general look at how Maldives transfers work — speedboats, seaplanes, and the choice between them — useful context alongside this
        specific route.
      </p>
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

export function routeVideoJsonLd() {
  return {
    "@context": "https://schema.org",
    "@type": "VideoObject",
    name: YOUTUBE_VIDEO_TITLE,
    description: "A general explainer on Maldives transfers — speedboats and seaplanes — from Maldives Tour Guide.",
    embedUrl: `https://www.youtube.com/embed/${YOUTUBE_VIDEO_ID}`,
    thumbnailUrl: [`https://i.ytimg.com/vi/${YOUTUBE_VIDEO_ID}/hqdefault.jpg`],
  };
}
