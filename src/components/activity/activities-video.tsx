/** Real videos recovered from the legacy site (release/public_html), never
 * an invented id — same pattern as src/components/diving/diving-video.tsx,
 * extended to a small gallery covering the range of things to do the
 * Activities page itself lists. */
const VIDEOS = [
  {
    id: "4TvWBi1S13c",
    title: "Snorkeling in the Maldives",
    description: "A look at snorkeling, one of the most accessible things to do in the Maldives.",
  },
  {
    id: "AW-UqFyoiVc",
    title: "30 Best Things To Do in Maldives",
    description: "A roundup of things to do in the Maldives, from watersports to island hopping and local culture.",
  },
  {
    id: "1e3k1QK66ZI",
    title: "Maldives Island Hopping",
    description: "Island hopping between local islands, one of the most popular Maldives excursions.",
  },
  {
    id: "3wtrnR2BJoQ",
    title: "Hanifaru Bay",
    description: "Hanifaru Bay in Baa Atoll, a UNESCO biosphere reserve known for manta ray and whale shark encounters.",
  },
] as const;

export function ActivitiesVideo() {
  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">Maldives Activities — Videos</h2>
      <p className="mt-2 text-sm text-neutral-700">Real footage of some of the most popular things to do in the Maldives.</p>
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

export function activitiesVideoJsonLd() {
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
