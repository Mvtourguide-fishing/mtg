"use server";

import { revalidatePath } from "next/cache";

import { requireStaff } from "@/lib/admin/auth";
import { REVIEW_STATUSES, type ReviewStatus } from "@/lib/admin/reviews-repository";
import { createClient } from "@/lib/supabase/server";

export interface AdminActionResult {
  ok: boolean;
  error?: string;
}

/**
 * No delete action here by design (spec §16: prefer archive/status change
 * over destructive deletion) — moderation is entirely a status transition
 * governed by `reviews_staff_moderate` RLS. There's also no per-review
 * audit trail in the schema (reviews has no `updated_at`/history table),
 * so per spec §19 ("don't build an enormous audit platform unless
 * genuinely required") this round doesn't add one — flagged as a known
 * gap in the final report rather than silently skipped.
 */
export async function updateReviewStatus(id: string, status: string): Promise<AdminActionResult> {
  await requireStaff();
  if (!(REVIEW_STATUSES as readonly string[]).includes(status)) return { ok: false, error: "Invalid status." };

  const supabase = await createClient();
  const { error } = await supabase
    .from("reviews")
    .update({ status: status as ReviewStatus } as unknown as never)
    .eq("id", id);
  if (error) return { ok: false, error: error.message };

  revalidatePath("/admin/reviews");
  revalidatePath("/admin");
  return { ok: true };
}
