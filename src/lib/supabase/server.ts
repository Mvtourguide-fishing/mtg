import { cookies } from "next/headers";
import { createServerClient } from "@supabase/ssr";

import type { Database } from "@/types/database";

/**
 * Supabase client for use in Server Components, Server Actions, and Route
 * Handlers. Uses the public anon key and the current request's session
 * cookie — every read/write goes through Row Level Security as the signed-in
 * user (or as an anonymous visitor, if not signed in).
 *
 * Must be called fresh per request (it reads `next/headers` cookies()), not
 * cached or reused across requests.
 */
export async function createClient() {
  const cookieStore = await cookies();

  return createServerClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options),
            );
          } catch {
            // Called from a Server Component rather than a Server Action or
            // Route Handler — cookies can't be written here. Safe to ignore
            // as long as `middleware.ts` is refreshing the session.
          }
        },
      },
    },
  );
}
