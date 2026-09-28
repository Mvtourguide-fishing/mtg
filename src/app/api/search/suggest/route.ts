import { NextResponse } from "next/server";

import { suggestSite } from "@/lib/search/repository";

/**
 * Lightweight JSON endpoint backing the header/homepage autocomplete
 * (Task 13 §7/§14). Deliberately thin — all the real work is in
 * suggestSite(), which is also what the /maldives/search/ page itself
 * calls for consistency (Task 13 §25: one shared search implementation).
 */
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const q = searchParams.get("q") ?? "";

  const results = await suggestSite(q, 8);

  return NextResponse.json(
    { results },
    {
      headers: {
        // Suggestions reflect live, publicly-readable content — safe to
        // cache briefly at the edge/browser, never treated as a stable
        // SEO resource.
        "Cache-Control": "private, max-age=30",
      },
    },
  );
}
