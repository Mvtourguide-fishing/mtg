"use client";

import { useRouter } from "next/navigation";
import { useState, useTransition } from "react";

import { Button } from "@/components/ui/button";
import { NODE_STATUSES, type NodeCoreInput, type NodeStatus } from "@/lib/admin/node-actions";
import { createProvider, updateProvider, type ProviderFieldsInput } from "@/lib/admin/providers-actions";

export interface ProviderFormInitial {
  id: string;
  core: NodeCoreInput;
  fields: ProviderFieldsInput;
}

const EMPTY_CORE: NodeCoreInput = { title: "", slug: "", summary: null, status: "draft", metaTitle: null, metaDescription: null };
const EMPTY_FIELDS: ProviderFieldsInput = {
  legalName: null,
  contactEmail: null,
  contactPhone: null,
  websiteUrl: null,
  licenseNumber: null,
  isVerified: false,
};

export function ProviderForm({ initial }: { initial?: ProviderFormInitial }) {
  const router = useRouter();
  const [core, setCore] = useState<NodeCoreInput>(initial?.core ?? EMPTY_CORE);
  const [fields, setFields] = useState<ProviderFieldsInput>(initial?.fields ?? EMPTY_FIELDS);
  const [slugTouched, setSlugTouched] = useState(Boolean(initial));
  const [error, setError] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();

  function slugify(value: string): string {
    return value
      .toLowerCase()
      .trim()
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-+|-+$/g, "");
  }

  const wasPublished = initial?.core.status === "published";
  const slugChanged = initial ? core.slug !== initial.core.slug : false;

  function save() {
    setError(null);
    startTransition(async () => {
      const result = initial ? await updateProvider(initial.id, core, fields) : await createProvider(core, fields);
      if (!result.ok) {
        setError(result.error ?? "Something went wrong.");
        return;
      }
      router.push("/admin/providers");
      router.refresh();
    });
  }

  return (
    <div className="max-w-2xl space-y-6">
      <section className="space-y-4 rounded-2xl border border-neutral-200 bg-white p-4">
        <h2 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">Basics</h2>

        <label className="block text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Title *</span>
          <input
            value={core.title}
            onChange={(e) => {
              const title = e.target.value;
              setCore((c) => ({ ...c, title, slug: slugTouched ? c.slug : slugify(title) }));
            }}
            className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
          />
        </label>

        <label className="block text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Slug *</span>
          <input
            value={core.slug}
            onChange={(e) => {
              setSlugTouched(true);
              setCore((c) => ({ ...c, slug: e.target.value }));
            }}
            className="w-full rounded-xl border border-neutral-300 px-3 py-2 font-mono text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
          />
          {wasPublished && slugChanged && (
            <p className="mt-1 text-xs text-amber-600">
              This provider is published — changing the slug will break its current URL for anyone who already linked to it. No redirect is
              created automatically; add one in Redirects if needed.
            </p>
          )}
        </label>

        <label className="block text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Summary</span>
          <textarea
            value={core.summary ?? ""}
            onChange={(e) => setCore((c) => ({ ...c, summary: e.target.value }))}
            rows={3}
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
        <h2 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">Provider details</h2>

        <label className="block text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Legal name</span>
          <input
            value={fields.legalName ?? ""}
            onChange={(e) => setFields((f) => ({ ...f, legalName: e.target.value }))}
            className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
          />
        </label>

        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <label className="block text-sm">
            <span className="mb-1 block font-medium text-neutral-700">Contact email</span>
            <input
              type="email"
              value={fields.contactEmail ?? ""}
              onChange={(e) => setFields((f) => ({ ...f, contactEmail: e.target.value }))}
              className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
            />
          </label>
          <label className="block text-sm">
            <span className="mb-1 block font-medium text-neutral-700">Contact phone</span>
            <input
              value={fields.contactPhone ?? ""}
              onChange={(e) => setFields((f) => ({ ...f, contactPhone: e.target.value }))}
              className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
            />
          </label>
        </div>

        <label className="block text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Website URL</span>
          <input
            value={fields.websiteUrl ?? ""}
            onChange={(e) => setFields((f) => ({ ...f, websiteUrl: e.target.value }))}
            className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
          />
        </label>

        <label className="block text-sm">
          <span className="mb-1 block font-medium text-neutral-700">License number</span>
          <input
            value={fields.licenseNumber ?? ""}
            onChange={(e) => setFields((f) => ({ ...f, licenseNumber: e.target.value }))}
            className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
          />
        </label>

        <label className="flex items-center gap-2 text-sm">
          <input type="checkbox" checked={fields.isVerified} onChange={(e) => setFields((f) => ({ ...f, isVerified: e.target.checked }))} />
          <span className="font-medium text-neutral-700">Verified</span>
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
        {isPending ? "Saving…" : initial ? "Save changes" : "Create provider"}
      </Button>
    </div>
  );
}
