export function VideoSection({ youtubeId, accommodationTitle }: { youtubeId: string | null; accommodationTitle: string }) {
  if (!youtubeId) return null;

  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">Video</h2>
      <div className="mt-4 aspect-video w-full overflow-hidden rounded-2xl bg-neutral-100">
        <iframe
          className="h-full w-full"
          src={`https://www.youtube.com/embed/${youtubeId}`}
          title={`${accommodationTitle} — video`}
          loading="lazy"
          allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
          referrerPolicy="strict-origin-when-cross-origin"
          allowFullScreen
        />
      </div>
    </section>
  );
}

export function accommodationVideoJsonLd(youtubeId: string | null, accommodationTitle: string, description: string | null) {
  if (!youtubeId) return null;
  return {
    "@context": "https://schema.org",
    "@type": "VideoObject",
    name: `${accommodationTitle} — video`,
    description: description ?? `Video of ${accommodationTitle}, Maldives.`,
    embedUrl: `https://www.youtube.com/embed/${youtubeId}`,
    thumbnailUrl: [`https://i.ytimg.com/vi/${youtubeId}/hqdefault.jpg`],
  };
}
