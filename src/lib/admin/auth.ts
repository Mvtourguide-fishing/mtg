import "server-only";

import { redirect } from "next/navigation";

import { createClient } from "@/lib/supabase/server";

/**
 * Single choke point for admin authorization (Task 15 — Admin/CMS). Every
 * admin page/layout/server action calls one of these instead of rolling its
 * own auth.getUser()/is_staff() check — same pattern as
 * src/lib/providers/repository.ts's providerDetailOf() being the one place
 * that funnels a cross-cutting concern.
 *
 * This reuses the existing `is_staff()`/`is_admin()` SECURITY DEFINER RPCs
 * (supabase/migrations/20250101001300_functions_triggers.sql) exactly as
 * they already govern every `*_staff_all` RLS policy — it does not
 * reimplement authorization logic, it just calls the same functions the
 * database itself trusts. That also means the RLS layer is a second,
 * independent enforcement point: even if a bug ever let an unauthorized
 * request reach a server action, the underlying `is_staff()`-gated RLS
 * policy on the table being written still blocks it.
 *
 * Called from src/app/admin/layout.tsx (redirects before any admin page
 * renders — this is a Server Component check, so it runs on every request
 * including a direct URL hit with no JS, not just a client-side guard) and
 * again from src/app/admin/users/page.tsx via requireAdmin() for the one
 * admin-only surface that manages roles and reads auth.users emails.
 */

export interface StaffContext {
  userId: string;
  email: string | null;
  isAdmin: boolean;
}

/** Redirects to /admin/login if unauthenticated, or to / if authenticated
 * but not staff (never to a login loop — the account is real, it just
 * isn't staff, so bouncing to the public site is the honest outcome). */
export async function requireStaff(): Promise<StaffContext> {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/admin/login");

  // src/types/database.ts is a placeholder (`Functions: Record<string,
  // never>` — see its own header comment), so this RPC call is narrowly
  // cast the same way src/lib/bookings/actions.ts already does.
  const { data: isStaffResult } = await supabase.rpc("is_staff" as unknown as never);
  if (!isStaffResult) redirect("/");

  const { data: isAdminResult } = await supabase.rpc("is_admin" as unknown as never);

  return { userId: user.id, email: user.email ?? null, isAdmin: Boolean(isAdminResult) };
}

/** Stricter gate for admin-only surfaces (user/role management). Bounces a
 * staff-but-not-admin user back to the main admin dashboard, not the
 * public site — they're still legitimate staff, just not authorized for
 * this one page. */
export async function requireAdmin(): Promise<StaffContext> {
  const context = await requireStaff();
  if (!context.isAdmin) redirect("/admin");
  return context;
}
