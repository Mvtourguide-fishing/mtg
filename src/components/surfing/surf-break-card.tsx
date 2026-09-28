import Link from "next/link";

import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { MediaImage } from "@/components/ui/media-image";
import type { SurfBreakSummary } from "@/lib/surfing/types";

const BREAK_TYPE_LABEL: Record<string, string> = {
  reef_break: "Reef break",
  point_break: "Point break",
  beach_break: "Beach break",
  channel: "Channel",
};

export function SurfBreakCard({ surfBreak }: { surfBreak: SurfBreakSummary }) {
  return (
    <li className={CARD_CLASS}>
      {surfBreak.heroImage && (
        <div className={CARD_IMAGE_BLEED_CLASS}>
          <MediaImage asset={surfBreak.heroImage} alt={surfBreak.title} aspectClassName="aspect-[4/3]" />
        </div>
      )}
      <Link href={`/maldives/surf-breaks/${surfBreak.slug}/`} className="text-lg font-medium text-ocean-900 transition-colors hover:text-maldives-600">
        {surfBreak.title}
      </Link>
      {surfBreak.breakType && (
        <div className="mt-1.5 text-sm text-neutral-600">{BREAK_TYPE_LABEL[surfBreak.breakType] ?? surfBreak.breakType}</div>
      )}
    </li>
  );
}
