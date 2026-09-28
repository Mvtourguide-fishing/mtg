"use server";

import { revalidatePath } from "next/cache";

import { requireStaff } from "@/lib/admin/auth";
import { COMMENT_STATUSES, type CommentStatus } from "@/lib/admin/comments-repository";
import { createClient } from "@/lib/supabase/server";

export interface AdminActionResult {
  ok: boolean;
  error?: string;
}

export async function updateCommentStatus(id: string, status: string): Promise<AdminActionResult> {
  await requireStaff();
  if (!(COMMENT_STATUSES as readonly string[]).includes(status)) return { ok: false, error: "Invalid status." };

  const supabase = await createClient();
  const { error } = await supabase
    .from("article_comments")
    .update({ status: status as CommentStatus } as unknown as never)
    .eq("id", id);
  if (error) return { ok: false, error: error.message };

  revalidatePath("/admin/comments");
  revalidatePath("/admin");
  return { ok: true };
}
