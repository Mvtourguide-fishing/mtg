import type { ReactNode } from "react";

/**
 * The shared visual shell for every directory card (accommodation,
 * activity, transfer, package, dive site, surf break…). Exported as a
 * class string, not just a component, because most existing cards are
 * `<li>` elements (a list of results) rather than `<div>`s — callers apply
 * `CARD_CLASS` directly to whatever element they already render, instead
 * of restructuring their markup around a wrapper component.
 */
export const CARD_CLASS =
  "overflow-hidden rounded-2xl border border-neutral-200 bg-white p-4 shadow-sm transition-shadow hover:shadow-md";

/** Applied to a MediaImage wrapper placed as the first child of a
 * CARD_CLASS element, to bleed the image to the card's edges/rounded
 * corners despite the card's own p-4 padding (Task 14 §20). */
export const CARD_IMAGE_BLEED_CLASS = "-mx-4 -mt-4 mb-3";

export function Card({ className = "", children }: { className?: string; children: ReactNode }) {
  return <div className={[CARD_CLASS, className].filter(Boolean).join(" ")}>{children}</div>;
}
