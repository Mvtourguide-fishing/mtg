"use client";

import { useRouter, useSearchParams } from "next/navigation";

import type { PackageSortOption } from "@/lib/packages/view-types";

const SORT_LABEL: Record<PackageSortOption, string> = {
  recommended: "Recommended",
  "price-asc": "Price: Low to High",
  "price-desc": "Price: High to Low",
  shortest: "Shortest Stay",
  longest: "Longest Stay",
  rating: "Highest Rating",
  newest: "Newest",
};

const OPTIONS: PackageSortOption[] = ["recommended", "price-asc", "price-desc", "shortest", "longest", "rating", "newest"];

export function PackageSortSelect({ basePath, current }: { basePath: string; current: PackageSortOption }) {
  const router = useRouter();
  const searchParams = useSearchParams();

  return (
    <label className="flex items-center gap-2 text-sm">
      <span className="font-medium text-neutral-700">Sort by</span>
      <select
        value={current}
        onChange={(event) => {
          const params = new URLSearchParams(searchParams.toString());
          if (event.target.value === "recommended") params.delete("sort");
          else params.set("sort", event.target.value);
          const query = params.toString();
          router.push(`${basePath}${query ? `?${query}` : ""}`);
        }}
        className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
      >
        {OPTIONS.map((option) => (
          <option key={option} value={option}>
            {SORT_LABEL[option]}
          </option>
        ))}
      </select>
    </label>
  );
}
