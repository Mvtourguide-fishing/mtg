import "server-only";

import { createClient as createSupabaseClient } from "@supabase/supabase-js";

import type { Database } from "@/types/database";

/**
 * Privileged Supabase client using the SERVICE ROLE key. This bypasses Row
 * Level Security entirely — it must never be used to serve a request on
 * behalf of an untrusted caller, and must never be imported into a Client
 * Component.
 *
 * The `server-only` import above makes any accidental import from client
 * code a build-time error, on top of the service role key itself never
 * being exposed to the browser (it is not prefixed with NEXT_PUBLIC_, so
 * Next.js never inlines it into client bundles).
 *
 * Reserve this for operations RLS genuinely cannot express — e.g. an Edge
 * Function writing to `booking_notifications`, or an admin-only maintenance
 * script. Ordinary reads/writes should go through
 * `src/lib/supabase/server.ts` (or the `create_booking_inquiry` /
 * `get_my_bookings` RPCs for the anonymous booking flow) so they stay
 * governed by RLS.
 */
export function createAdminClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!url || !serviceRoleKey) {
    throw new Error(
      "createAdminClient() requires NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY to be set.",
    );
  }

  return createSupabaseClient<Database>(url, serviceRoleKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  });
}
