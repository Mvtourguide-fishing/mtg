"use client";

import { useRouter } from "next/navigation";
import { useState, useTransition } from "react";

import { Button } from "@/components/ui/button";
import { updateLocation, type LocationFieldsInput } from "@/lib/admin/locations-actions";
import { NODE_STATUSES, type NodeCoreInput, type NodeStatus } from "@/lib/admin/node-actions";

export interface LocationFormInitial {
  id: string;
  core: NodeCoreInput;
  fields: LocationFieldsInput;
  locationType: string;
  parentTitle: string | null;
}

export function LocationForm({ initial }: { initial: LocationFormInitial }) {
  const router = useRouter();
  const [core, setCore] = useState<NodeCoreInput>(initial.core);
  const [fields, setFields] = useState<LocationFieldsInput>(initial.fields);
  const [error, setError] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();

  const wasPublished = initial.core.status === "published";
  const slugChanged = core.slug !== initial.core.slug;

  function save() {
    setError(null);
    startTransition(async () => {
      const result = await updateLocation(initial.id, core, fields);
      if (!result.ok) {
        setError(result.error ?? "Something went wrong.");
        return;
      }
      router.push("/admin/locations");
      router.refresh();
    });
  }

  return (
    <div className="max-w-2xl space-y-6">
      <section className="space-y-4 rounded-2xl border border-neutral-200 bg-white p-4">
        <h2 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">Basics</h2>

        <div className="grid grid-cols-2 gap-4 text-sm">
          <div>
            <span className="block font-medium text-neutral-500">Location type</span>
            <span className="mt-1 block capitalize text-neutral-900">{initial.locationType.replace(/_/g, " ")}</span>
          </div>
          <div>
            <span className="block font-medium text-neutral-500">Parent</span>
            <span className="mt-1 block text-neutral-900">{initial.parentTitle ?? "— (top level)"}</span>
          </div>
        </div>
        <p className="text-xs text-neutral-500">
          Location type and parent aren&rsquo;t editable here — changing either affects the location hierarchy and is handled outside the admin
          panel for now.
        </p>

        <label className="block text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Title *</span>
          <input
            value={core.title}
            onChange={(e) => setCore((c) => ({ ...c, title: e.target.value }))}
            className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
          />
        </label>

        <label className="block text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Slug *</span>
          <input
            value={core.slug}
            onChange={(e) => setCore((c) => ({ ...c, slug: e.target.value }))}
            className="w-full rounded-xl border border-neutral-300 px-3 py-2 font-mono text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
          />
          {wasPublished && slugChanged && (
            <p className="mt-1 text-xs text-amber-600">
              This location is published — changing the slug will break its current URL (and every descendant location&rsquo;s URL) for anyone
              already linked to it. No redirect is created automatically.
            </p>
          )}
        </label>

        <label className="block text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Summary</span>
          <textarea
            value={core.summary ?? ""}
            onChange={(e) => setCore((c) => ({ ...c, summary: e.target.value }))}
            rows={4}
            className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
          />
        </label>

        <label className="block text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Status</span>
          <select
            value={core.status}
            onChange={(e) => setCore((c) => ({ ...c, status: e.target.value as NodeStatus }))}
            className="rounded-xl border border-neutral-300 px-3 py-2 text-sm"
          >
            {NODE_STATUSES.map((s) => (
              <option key={s} value={s}>
                {s}
              </option>
            ))}
          </select>
        </label>
      </section>

      <section className="space-y-4 rounded-2xl border border-neutral-200 bg-white p-4">
        <h2 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">Geography</h2>
        <div className="grid grid-cols-2 gap-4">
          <label className="block text-sm">
            <span className="mb-1 block font-medium text-neutral-700">Latitude</span>
            <input
              type="number"
              step="0.000001"
              value={fields.lat ?? ""}
              onChange={(e) => setFields((f) => ({ ...f, lat: e.target.value === "" ? null : Number(e.target.value) }))}
              className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
            />
          </label>
          <label className="block text-sm">
            <span className="mb-1 block font-medium text-neutral-700">Longitude</span>
            <input
              type="number"
              step="0.000001"
              value={fields.lng ?? ""}
              onChange={(e) => setFields((f) => ({ ...f, lng: e.target.value === "" ? null : Number(e.target.value) }))}
              className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
            />
          </label>
        </div>

        <label className="block text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Administrative code</span>
          <input
            value={fields.administrativeCode ?? ""}
            onChange={(e) => setFields((f) => ({ ...f, administrativeCode: e.target.value }))}
            className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
          />
        </label>

        <label className="flex items-center gap-2 text-sm">
          <input
            type="checkbox"
            checked={fields.isInhabited ?? false}
            onChange={(e) => setFields((f) => ({ ...f, isInhabited: e.target.checked }))}
          />
          <span className="font-medium text-neutral-700">Inhabited</span>
        </label>
      </section>

      <section className="space-y-4 rounded-2xl border border-neutral-200 bg-white p-4">
        <h2 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">SEO</h2>
        <label className="block text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Meta title</span>
          <input
            value={core.metaTitle ?? ""}
            onChange={(e) => setCore((c) => ({ ...c, metaTitle: e.target.value }))}
            className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
          />
        </label>
        <label className="block text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Meta description</span>
          <textarea
            value={core.metaDescription ?? ""}
            onChange={(e) => setCore((c) => ({ ...c, metaDescription: e.target.value }))}
            rows={2}
            className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
          />
        </label>
      </section>

      {error && (
        <p role="alert" className="text-sm text-red-600">
          {error}
        </p>
      )}

      <Button onClick={save} disabled={isPending}>
        {isPending ? "Saving…" : "Save changes"}
      </Button>
    </div>
  );
}
