import "server-only";

import { createClient } from "@/lib/supabase/server";

/**
 * Admin-only article-comment reads. `article_comments` has RLS
 * (`article_comments_staff_read`/`_staff_moderate`/`_staff_delete`) and a
 * schema, but — per this session's audit — zero application code has ever
 * written to it: `user_id` is `not null` and this site has no sign-in flow
 * a customer could use, so no comment can exist yet. This page is still
 * worth having (the table/RLS are real, and the moment a customer-facing
 * comment UI + auth exists, rows will start appearing here with no further
 * admin-side work) — it will just show an empty state today.
 */

const PAGE_SIZE = 25;
export const COMMENT_STATUSES = ["visible", "flagged", "removed"] as const;
export type CommentStatus = (typeof COMMENT_STATUSES)[number];

export interface AdminCommentItem {
  id: string;
  articleId: string;
  articleTitle: string;
  body: string;
  status: CommentStatus;
  createdAt: string;
}

interface CommentRow {
  id: string;
  article_id: string;
  body: string;
  status: CommentStatus;
  created_at: string;
}

export interface AdminCommentListResult {
  items: AdminCommentItem[];
  total: number;
  page: number;
  pageSize: number;
}

export async function getCommentsAdmin(options: { status?: CommentStatus; page?: number } = {}): Promise<AdminCommentListResult> {
  const page = Math.max(1, options.page ?? 1);
  const from = (page - 1) * PAGE_SIZE;
  const to = from + PAGE_SIZE - 1;

  const supabase = await createClient();
  let query = supabase.from("article_comments").select("*", { count: "exact" }).order("created_at", { ascending: false });
  if (options.status) query = query.eq("status", options.status);

  const { data, error, count } = await query.range(from, to).returns<CommentRow[]>();
  if (error || !data) return { items: [], total: 0, page, pageSize: PAGE_SIZE };

  const articleIds = [...new Set(data.map((c) => c.article_id))];
  const { data: nodes } = articleIds.length
    ? await supabase.from("nodes").select("id, title").in("id", articleIds).returns<Array<{ id: string; title: string }>>()
    : { data: [] as Array<{ id: string; title: string }> };
  const titleById = new Map((nodes ?? []).map((n) => [n.id, n.title]));

  const items: AdminCommentItem[] = data.map((c) => ({
    id: c.id,
    articleId: c.article_id,
    articleTitle: titleById.get(c.article_id) ?? "(unknown article)",
    body: c.body,
    status: c.status,
    createdAt: c.created_at,
  }));

  return { items, total: count ?? items.length, page, pageSize: PAGE_SIZE };
}
