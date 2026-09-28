import Link from "next/link";

import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { MediaImage } from "@/components/ui/media-image";
import { activityHref, type ActivitySummary } from "@/lib/activities/types";

const CATEGORY_LABEL: Record<string, string> = {
  general: "General",
  fishing: "Fishing",
  diving: "Diving",
  surfing: "Surfing",
  watersports: "Watersports",
  excursion: "Excursion",
  island_hopping: "Island Hopping",
  spa: "Spa",
  culture: "Culture",
};

function formatDuration(minutes: number | null): string | null {
  if (!minutes) return null;
  if (minutes < 60) return `${minutes} min`;
  const hours = minutes / 60;
  return Number.isInteger(hours) ? `${hours} hr` : `${hours.toFixed(1)} hr`;
}

export function ActivityCard({ activity }: { activity: ActivitySummary }) {
  const duration = formatDuration(activity.durationMinutes);

  return (
    <li className={CARD_CLASS}>
      {activity.heroImage && (
        <div className={CARD_IMAGE_BLEED_CLASS}>
          <MediaImage asset={activity.heroImage} alt={activity.title} aspectClassName="aspect-[4/3]" />
        </div>
      )}
      <Link href={activityHref(activity)} className="text-lg font-medium text-ocean-900 transition-colors hover:text-maldives-600">
        {activity.title}
      </Link>
      <div className="mt-1.5 flex flex-wrap gap-x-3 gap-y-1 text-sm text-neutral-600">
        <span>{CATEGORY_LABEL[activity.activityCategory] ?? activity.activityCategory}</span>
        {activity.primaryLocation && <span>{activity.primaryLocation.title}</span>}
        {duration && <span>{duration}</span>}
        {activity.difficulty && <span className="capitalize">{activity.difficulty.replace("_", " ")}</span>}
        {activity.priceFrom && (
          <span>
            From {activity.currency ?? "USD"} {activity.priceFrom}
          </span>
        )}
      </div>
    </li>
  );
}
