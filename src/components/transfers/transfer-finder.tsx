"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";

import { LocationCombobox } from "@/components/transfers/location-combobox";
import { Button } from "@/components/ui/button";

const TRANSFER_TYPE_OPTIONS = [
  { value: "", label: "Any transfer type" },
  { value: "speedboat", label: "Speedboat Transfer" },
  { value: "seaplane", label: "Seaplane Transfer" },
  { value: "domestic_flight", label: "Domestic Flight Transfer" },
  { value: "ferry", label: "Ferry" },
  { value: "land_transfer", label: "Car Transfer" },
];

/**
 * The one intelligent transfer finder (Task 20 §6) — Transfer Type, From,
 * To, Search. Submits to /maldives/transfers/find/, which does the real
 * route-aware matching server-side (src/lib/transfers/finder.ts) and
 * either redirects straight to the real route page or shows an honest
 * "no direct transfer" state — this component never claims a route
 * exists on its own.
 */
export function TransferFinder({
  defaultFromSlug,
  defaultFromLabel,
}: {
  defaultFromSlug?: string;
  defaultFromLabel?: string;
}) {
  const router = useRouter();
  const [pending, setPending] = useState(false);

  return (
    <form
      className="rounded-2xl border border-neutral-200 bg-white p-4 shadow-sm sm:p-6"
      onSubmit={(event) => {
        event.preventDefault();
        const form = event.currentTarget;
        const data = new FormData(form);
        const params = new URLSearchParams();
        const from = String(data.get("from") ?? "");
        const to = String(data.get("to") ?? "");
        const type = String(data.get("type") ?? "");
        if (from) params.set("from", from);
        if (to) params.set("to", to);
        if (type) params.set("type", type);
        setPending(true);
        router.push(`/maldives/transfers/find/?${params.toString()}`);
      }}
    >
      <h2 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">Find your Maldives transfer</h2>
      <div className="mt-3 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-[1fr_1fr_1fr_auto]">
        <label className="block text-sm sm:col-span-2 lg:col-span-1">
          <span className="mb-1 block text-xs font-medium text-neutral-600">Transfer type</span>
          <select
            name="type"
            defaultValue=""
            className="min-touch-target w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
          >
            {TRANSFER_TYPE_OPTIONS.map((opt) => (
              <option key={opt.value} value={opt.value}>
                {opt.label}
              </option>
            ))}
          </select>
        </label>

        <LocationCombobox
          name="from"
          label="From"
          placeholder="Airport, island, resort, hotel…"
          defaultSlug={defaultFromSlug}
          defaultLabel={defaultFromLabel}
        />
        <LocationCombobox name="to" label="To" placeholder="Airport, island, resort, hotel…" />

        <Button type="submit" disabled={pending} className="self-end">
          {pending ? "Searching…" : "Search Transfers"}
        </Button>
      </div>
    </form>
  );
}
