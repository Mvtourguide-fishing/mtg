import "server-only";

import { createClient } from "@/lib/supabase/server";

/**
 * Admin-only review reads/writes. `reviews_staff_read` lets staff see every
 * status (public/`getReviewsForNode` in src/lib/reviews/repository.ts only
 * ever sees `status='published'`); `reviews_staff_moderate` lets staff
 * update status. Node titles are resolved with a separate batched lookup,
 * same reasoning as src/lib/admin/bookings-repository.ts.
 */

const PAGE_SIZE = 25;
export const REVIEW_STATUSES = ["pending", "published", "rejected"] as const;
export type ReviewStatus = (typeof REVIEW_STATUSES)[number];

export interface AdminReviewItem {
  id: string;
  nodeId: string;
  nodeTitle: string;
  rating: number;
  title: string | null;
  body: string | null;
  status: ReviewStatus;
  reviewerName: string;
  reviewerEmail: string | null;
  createdAt: string;
}

interface ReviewRow {
  id: string;
  node_id: string;
  user_id: string | null;
  rating: number;
  title: string | null;
  body: string | null;
  status: ReviewStatus;
  guest_name: string | null;
  guest_email: string | null;
  created_at: string;
}

export interface AdminReviewListResult {
  items: AdminReviewItem[];
  total: number;
  page: number;
  pageSize: number;
}

export async function getReviewsAdmin(options: { status?: ReviewStatus; page?: number } = {}): Promise<AdminReviewListResult> {
  const page = Math.max(1, options.page ?? 1);
  const from = (page - 1) * PAGE_SIZE;
  const to = from + PAGE_SIZE - 1;

  const supabase = await createClient();
  let query = supabase.from("reviews").select("*", { count: "exact" }).order("created_at", { ascending: false });
  if (options.status) query = query.eq("status", options.status);

  const { data, error, count } = await query.range(from, to).returns<ReviewRow[]>();
  if (error || !data) return { items: [], total: 0, page, pageSize: PAGE_SIZE };

  const nodeIds = [...new Set(data.map((r) => r.node_id))];
  const { data: nodes } = nodeIds.length
    ? await supabase.from("nodes").select("id, title").in("id", nodeIds).returns<Array<{ id: string; title: string }>>()
    : { data: [] as Array<{ id: string; title: string }> };
  const nodeTitleById = new Map((nodes ?? []).map((n) => [n.id, n.title]));

  const items: AdminReviewItem[] = data.map((r) => ({
    id: r.id,
    nodeId: r.node_id,
    nodeTitle: nodeTitleById.get(r.node_id) ?? "(unknown)",
    rating: r.rating,
    title: r.title,
    body: r.body,
    status: r.status,
    reviewerName: r.guest_name ?? "(account holder)",
    reviewerEmail: r.guest_email,
    createdAt: r.created_at,
  }));

  return { items, total: count ?? items.length, page, pageSize: PAGE_SIZE };
}
