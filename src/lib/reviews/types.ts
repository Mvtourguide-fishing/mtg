/**
 * Guest-safe reviews (Task 20 §34) — real, moderated submissions only.
 * Never fabricated; a node with zero published reviews renders an honest
 * "No reviews yet" state, not a synthetic rating.
 */

export interface Review {
  id: string;
  rating: number;
  title: string | null;
  body: string | null;
  reviewerName: string;
  createdAt: string;
}
