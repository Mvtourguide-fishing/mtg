import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

/**
 * Admin-only (not just staff — see requireAdmin() in every caller). The
 * one legitimate use of the service-role client for a READ in this
 * codebase: `auth.users` (where email lives) isn't exposed to PostgREST at
 * all, so there is no RLS-respecting way to list it — this is exactly the
 * "RLS genuinely cannot express" case src/lib/supabase/admin.ts's own doc
 * comment reserves createAdminClient() for. `profiles` (role, display
 * name) is still read through the normal RLS-respecting client — its
 * `profiles_public_read` policy already allows any authenticated caller to
 * read all profiles, so nothing new is exposed by reading it here.
 */

export type UserRole = "user" | "editor" | "admin";

export interface AdminUserItem {
  id: string;
  email: string | null;
  displayName: string | null;
  role: UserRole;
  createdAt: string;
}

interface ProfileRow {
  id: string;
  display_name: string | null;
  role: UserRole;
  created_at: string;
}

async function listAllAuthEmails(): Promise<Map<string, string>> {
  const admin = createAdminClient();
  const emailById = new Map<string, string>();
  let page = 1;
  // Small user base expected (staff only) — a few pages at most.
  while (true) {
    const { data, error } = await admin.auth.admin.listUsers({ page, perPage: 200 });
    if (error || !data) break;
    for (const u of data.users) {
      if (u.email) emailById.set(u.id, u.email);
    }
    if (data.users.length < 200) break;
    page += 1;
  }
  return emailById;
}

export async function getUsersAdmin(): Promise<AdminUserItem[]> {
  const supabase = await createClient();
  const { data: profiles } = await supabase
    .from("profiles")
    .select("id, display_name, role, created_at")
    .order("created_at", { ascending: false })
    .returns<ProfileRow[]>();

  const emailById = await listAllAuthEmails();

  return (profiles ?? []).map((p) => ({
    id: p.id,
    email: emailById.get(p.id) ?? null,
    displayName: p.display_name,
    role: p.role,
    createdAt: p.created_at,
  }));
}
