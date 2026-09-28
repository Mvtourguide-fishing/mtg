/** Real videos recovered from the legacy site
 * (release/public_html/scuba-diving-in-maldives.html), embedded properly —
 * never an invented id. Same pattern as
 * src/components/transfers/route-video.tsx, extended to a small gallery
 * since the legacy page itself hosted several distinct diving videos. */
const VIDEOS = [
  {
    id: "1B5ULRsWNR4",
    title: "Best Places for Diving in the Maldives",
    description: "A look at some of the Maldives' best-known dive sites.",
  },
  {
    id: "1oJb1oIOtTc",
    title: "Full Day Dive Trip Maldives",
    description: "A full-day diving charter, visiting multiple sites in one trip.",
  },
  {
    id: "AgAYoXFnY-s",
    title: "Maldives Diving In Moofushi Kandu South Ari Atoll",
    description: "Diving at Moofushi Kandu, a channel dive site in South Ari Atoll.",
  },
  {
    id: "rao_dDgz0Rg",
    title: "Liveaboard Dive Vessels",
    description: "Liveaboard dive vessels used for multi-day diving trips around the Maldives.",
  },
] as const;

export function DivingVideo() {
  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">Diving in the Maldives — Videos</h2>
      <p className="mt-2 text-sm text-neutral-700">Real footage of Maldives dive sites, dive trips and liveaboard vessels.</p>
      <div className="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2">
        {VIDEOS.map((video) => (
          <div key={video.id}>
            <div className="aspect-video w-full overflow-hidden rounded-2xl bg-neutral-100">
              <iframe
                className="h-full w-full"
                src={`https://www.youtube.com/embed/${video.id}`}
                title={video.title}
                loading="lazy"
                allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                referrerPolicy="strict-origin-when-cross-origin"
                allowFullScreen
              />
            </div>
            <p className="mt-2 text-sm font-medium text-ocean-900">{video.title}</p>
          </div>
        ))}
      </div>
    </section>
  );
}

export function divingVideoJsonLd() {
  return {
    "@context": "https://schema.org",
    "@type": "ItemList",
    itemListElement: VIDEOS.map((video, index) => ({
      "@type": "ListItem",
      position: index + 1,
      item: {
        "@type": "VideoObject",
        name: video.title,
        description: `${video.description} Recovered from Maldives Tour Guide's own legacy content.`,
        embedUrl: `https://www.youtube.com/embed/${video.id}`,
        thumbnailUrl: [`https://i.ytimg.com/vi/${video.id}/hqdefault.jpg`],
      },
    })),
  };
}
