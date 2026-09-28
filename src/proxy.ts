import { NextResponse, type NextRequest } from "next/server";

import { looksLikeLegacyPath, resolveLegacyRedirect } from "@/lib/redirects/resolve";
import { updateSession } from "@/lib/supabase/proxy";

export async function proxy(request: NextRequest) {
  // Legacy-URL redirects (Task 16) run first and short-circuit: a request
  // for an old site path never needs the Supabase session refreshed below,
  // and this check itself only ever touches the database for paths that
  // are structurally outside the new app's own routes (see
  // looksLikeLegacyPath's own comment) — the site's real traffic never
  // pays for this lookup.
  const { pathname } = request.nextUrl;
  if (looksLikeLegacyPath(pathname)) {
    const redirect = await resolveLegacyRedirect(pathname);
    if (redirect) {
      const destination = new URL(redirect.targetPath, request.url);
      return NextResponse.redirect(destination, redirect.statusCode);
    }
  }

  return updateSession(request);
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for static assets and image
     * optimization files, so the session cookie stays fresh on every
     * navigable route without doing unnecessary work on assets.
     */
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};
