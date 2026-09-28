"use client";

import dynamic from "next/dynamic";

import type { DiveSitesMapSite } from "@/components/diving/dive-sites-map";

// Leaflet touches `window` at module-evaluation time, so the component that
// imports it can never be part of the server-rendered bundle — `next/dynamic`
// with `ssr: false` is only permitted inside a Client Component (see
// node_modules/next/dist/docs/01-app/02-guides/lazy-loading.md), hence this
// thin client-only wrapper around the actual map component.
const DiveSitesMapInner = dynamic(() => import("@/components/diving/dive-sites-map").then((mod) => mod.DiveSitesMap), {
  ssr: false,
});

export function DiveSitesMap({ sites }: { sites: DiveSitesMapSite[] }) {
  return <DiveSitesMapInner sites={sites} />;
}
