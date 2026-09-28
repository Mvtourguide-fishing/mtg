"use client";

import { useRouter } from "next/navigation";
import { useTransition } from "react";

import { updateReviewStatus } from "@/lib/admin/reviews-actions";

export function ReviewModerationButtons({ reviewId, status }: { reviewId: string; status: string }) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();

  function setStatus(next: string) {
    startTransition(async () => {
      await updateReviewStatus(reviewId, next);
      router.refresh();
    });
  }

  return (
    <div className="flex gap-2">
      {status !== "published" && (
        <button
          type="button"
          disabled={isPending}
          onClick={() => setStatus("published")}
          className="rounded-full bg-maldives-600 px-3 py-1.5 text-xs font-medium text-white hover:bg-ocean-800 disabled:opacity-50"
        >
          Approve
        </button>
      )}
      {status !== "rejected" && (
        <button
          type="button"
          disabled={isPending}
          onClick={() => setStatus("rejected")}
          className="rounded-full border border-neutral-300 px-3 py-1.5 text-xs font-medium text-neutral-700 hover:border-red-400 hover:text-red-600 disabled:opacity-50"
        >
          Reject
        </button>
      )}
      {status !== "pending" && (
        <button
          type="button"
          disabled={isPending}
          onClick={() => setStatus("pending")}
          className="rounded-full border border-neutral-300 px-3 py-1.5 text-xs font-medium text-neutral-700 hover:border-maldives-400 disabled:opacity-50"
        >
          Reset to pending
        </button>
      )}
    </div>
  );
}
