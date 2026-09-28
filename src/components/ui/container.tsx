import type { ReactNode } from "react";

/**
 * The site-wide content width, applied consistently across every page.
 * Exported as a plain class string (not just a wrapper component) because
 * most pages need it on their own `<main>` landmark rather than on an
 * extra nested `<div>`.
 */
export const CONTAINER_CLASS = "mx-auto w-full max-w-6xl px-4 sm:px-6 lg:px-8";

export function Container({ children, className = "" }: { children: ReactNode; className?: string }) {
  return <div className={[CONTAINER_CLASS, className].filter(Boolean).join(" ")}>{children}</div>;
}
