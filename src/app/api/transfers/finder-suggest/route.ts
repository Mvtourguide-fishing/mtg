import { NextResponse } from "next/server";

import { searchTransferEndpoints } from "@/lib/transfers/finder";

/** Backs the transfer finder's From/To combobox (Task 20 §6-7) — same
 * thin-endpoint pattern as /api/search/suggest, calling the one shared
 * searchTransferEndpoints() implementation so the API and any future
 * server-rendered use of it can never disagree. */
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const q = searchParams.get("q") ?? "";

  const results = await searchTransferEndpoints(q, 8);

  return NextResponse.json(
    { results },
    { headers: { "Cache-Control": "private, max-age=30" } },
  );
}
