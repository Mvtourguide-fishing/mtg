"use client";

import { useRouter } from "next/navigation";
import { useTransition } from "react";

import { updateCommentStatus } from "@/lib/admin/comments-actions";

export function CommentModerationButtons({ commentId, status }: { commentId: string; status: string }) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();

  function setStatus(next: string) {
    startTransition(async () => {
      await updateCommentStatus(commentId, next);
      router.refresh();
    });
  }

  return (
    <div className="flex gap-2">
      {status !== "visible" && (
        <button
          type="button"
          disabled={isPending}
          onClick={() => setStatus("visible")}
          className="rounded-full bg-maldives-600 px-3 py-1.5 text-xs font-medium text-white hover:bg-ocean-800 disabled:opacity-50"
        >
          Approve
        </button>
      )}
      {status !== "flagged" && (
        <button
          type="button"
          disabled={isPending}
          onClick={() => setStatus("flagged")}
          className="rounded-full border border-neutral-300 px-3 py-1.5 text-xs font-medium text-neutral-700 hover:border-amber-400 disabled:opacity-50"
        >
          Flag
        </button>
      )}
      {status !== "removed" && (
        <button
          type="button"
          disabled={isPending}
          onClick={() => setStatus("removed")}
          className="rounded-full border border-neutral-300 px-3 py-1.5 text-xs font-medium text-neutral-700 hover:border-red-400 hover:text-red-600 disabled:opacity-50"
        >
          Remove
        </button>
      )}
    </div>
  );
}
