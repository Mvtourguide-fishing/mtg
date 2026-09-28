import Link from "next/link";

import { Badge } from "@/components/ui/badge";
import { CARD_CLASS } from "@/components/ui/card";
import type { SearchResult } from "@/lib/search/types";

export function SearchResultCard({ result }: { result: SearchResult }) {
  return (
    <li className={CARD_CLASS}>
      <div className="flex items-start justify-between gap-2">
        <Link href={result.href} className="text-lg font-medium text-ocean-900 transition-colors hover:text-maldives-600">
          {result.title}
        </Link>
        <Badge tone="outline" className="shrink-0">
          {result.typeLabel}
        </Badge>
      </div>
      {result.context && <p className="mt-1 text-sm text-neutral-500">{result.context}</p>}
      {result.description && <p className="mt-2 line-clamp-2 text-sm text-neutral-600">{result.description}</p>}
    </li>
  );
}
