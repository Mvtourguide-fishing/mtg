import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

/**
 * Refreshes the Supabase auth session cookie on every request so server
 * components always see a valid (or correctly expired) session. This does
 * not implement authorization decisions — those belong to RLS policies and,
 * where relevant, route-level checks added when the gated routes exist.
 */
export async function updateSession(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request });

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  // No Supabase project connected yet (e.g. local dev before .env.local is
  // filled in). Every request goes through this proxy, so failing hard here
  // would 500 the entire site — including routes that don't touch Supabase
  // at all. Pass the request through unmodified instead; pages that
  // actually need data still fail informatively at the point they call
  // createClient().
  if (!url || !anonKey) {
    if (process.env.NODE_ENV !== "production") {
      console.warn(
        "[proxy] NEXT_PUBLIC_SUPABASE_URL / NEXT_PUBLIC_SUPABASE_ANON_KEY are not set — skipping session refresh.",
      );
    }
    return supabaseResponse;
  }

  // The overwhelming majority of requests — every anonymous visitor and
  // every crawler/bot hitting the public catalog pages — carry no Supabase
  // auth cookie at all. There is no session to refresh for them, so
  // calling auth.getUser() here would do nothing except make a wasted
  // network round trip to the Supabase Auth API on every single one of
  // those requests. Since this proxy runs on almost every route (see the
  // matcher below), that wasted call was happening on every page view of
  // every visitor, all day, and was a major contributor to the project's
  // Supabase compute/disk-IO exhaustion (see the incident note this fix
  // was added for). Only pay for the auth round trip when a session
  // cookie is actually present.
  const hasSupabaseAuthCookie = request.cookies.getAll().some((cookie) => cookie.name.startsWith("sb-") && cookie.name.endsWith("-auth-token"));
  if (!hasSupabaseAuthCookie) {
    return supabaseResponse;
  }

  const supabase = createServerClient(
    url,
    anonKey,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value));
          supabaseResponse = NextResponse.next({ request });
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options),
          );
        },
      },
    },
  );

  // Touching auth.getUser() is what actually triggers a token refresh when needed.
  await supabase.auth.getUser();

  return supabaseResponse;
}
