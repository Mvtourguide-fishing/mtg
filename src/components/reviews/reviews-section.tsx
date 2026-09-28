"use client";

import { useState } from "react";

import { WriteReviewForm } from "@/components/reviews/write-review-form";
import { Button } from "@/components/ui/button";
import type { Review } from "@/lib/reviews/types";

function Stars({ rating }: { rating: number }) {
  return (
    <span aria-label={`${rating} out of 5 stars`} className="text-amber-500">
      {"★".repeat(rating)}
      <span className="text-neutral-300">{"★".repeat(5 - rating)}</span>
    </span>
  );
}

/** Task 20 §34: real reviews only, an honest empty state, and a real
 * submission flow. Never renders aggregate-rating structured data — that
 * only makes sense once genuine review volume exists (Task 20 explicitly
 * disallows it from demo/early data). */
export function ReviewsSection({ nodeId, reviews }: { nodeId: string; reviews: Review[] }) {
  const [showForm, setShowForm] = useState(false);

  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">Customer Reviews</h2>

      {reviews.length === 0 ? (
        <p className="mt-2 text-sm text-neutral-600">No reviews yet. Be the first to review this transfer.</p>
      ) : (
        <ul className="mt-4 space-y-4">
          {reviews.map((review) => (
            <li key={review.id} className="rounded-xl border border-neutral-200 p-4">
              <div className="flex flex-wrap items-baseline justify-between gap-2">
                <Stars rating={review.rating} />
                <span className="text-xs text-neutral-500">{new Date(review.createdAt).toLocaleDateString("en-GB", { year: "numeric", month: "short", day: "numeric" })}</span>
              </div>
              {review.title && <p className="mt-1 font-medium text-ocean-900">{review.title}</p>}
              {review.body && <p className="mt-1 text-sm text-neutral-700">{review.body}</p>}
              <p className="mt-1 text-xs text-neutral-500">{review.reviewerName}</p>
            </li>
          ))}
        </ul>
      )}

      {showForm ? (
        <div className="mt-4 border-t border-neutral-200 pt-4">
          <WriteReviewForm nodeId={nodeId} />
        </div>
      ) : (
        <Button variant="secondary" size="sm" className="mt-4" onClick={() => setShowForm(true)}>
          Write a Review
        </Button>
      )}
    </section>
  );
}
