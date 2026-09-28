"use client";

import { useRouter } from "next/navigation";
import { useTransition } from "react";

import { toggleRedirectActive } from "@/lib/admin/redirects-actions";

export function RedirectToggleButton({ redirectId, isActive }: { redirectId: string; isActive: boolean }) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();

  return (
    <button
      type="button"
      disabled={isPending}
      onClick={() => {
        startTransition(async () => {
          await toggleRedirectActive(redirectId, !isActive);
          router.refresh();
        });
      }}
      className={`rounded-full px-3 py-1.5 text-xs font-medium disabled:opacity-50 ${
        isActive ? "border border-neutral-300 text-neutral-700 hover:border-red-400 hover:text-red-600" : "bg-maldives-600 text-white hover:bg-ocean-800"
      }`}
    >
      {isPending ? "…" : isActive ? "Disable" : "Enable"}
    </button>
  );
}
