import "server-only";

import { createClient } from "@/lib/supabase/public";
import type { Review } from "@/lib/reviews/types";

type ReviewRow = {
  id: string;
  rating: number;
  title: string | null;
  body: string | null;
  guest_name: string | null;
  created_at: string;
};

/** Only status='published' rows — a submitted review sits at 'pending'
 * until moderated, so it never appears as if it were vetted instantly. */
export async function getReviewsForNode(nodeId: string): Promise<Review[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("reviews")
    .select("id, rating, title, body, guest_name, created_at")
    .eq("node_id", nodeId)
    .eq("status", "published")
    .order("created_at", { ascending: false })
    .returns<ReviewRow[]>();

  if (error || !data) return [];

  return data.map((row) => ({
    id: row.id,
    rating: row.rating,
    title: row.title,
    body: row.body,
    reviewerName: row.guest_name ?? "Verified traveller",
    createdAt: row.created_at,
  }));
}
