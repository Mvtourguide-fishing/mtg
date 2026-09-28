"use server";

import { revalidatePath } from "next/cache";

import { requireStaff } from "@/lib/admin/auth";
import { createClient } from "@/lib/supabase/server";

export interface AdminActionResult {
  ok: boolean;
  error?: string;
}

/** Toggle only — no create/edit of source_path/target here, see the
 * repository file's header comment for why. Flipping `is_active` is safe:
 * the chain-prevention trigger (`prevent_redirect_chains()`) re-runs on
 * every update including this one, but it only re-checks this row's own
 * unchanged source_path/target_path against the rest of the table — since
 * this update never touches those columns, a row that was valid stays
 * valid. It's also easily reversible, and exactly the "eventually" bar the
 * spec sets for this round. */
export async function toggleRedirectActive(id: string, isActive: boolean): Promise<AdminActionResult> {
  await requireStaff();

  const supabase = await createClient();
  const { error } = await supabase
    .from("url_redirects")
    .update({ is_active: isActive } as unknown as never)
    .eq("id", id);
  if (error) return { ok: false, error: error.message };

  revalidatePath("/admin/redirects");
  revalidatePath("/admin");
  return { ok: true };
}
