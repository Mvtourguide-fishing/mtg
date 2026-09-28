import type { Metadata } from "next";
import Link from "next/link";

import { Button } from "@/components/ui/button";
import { CONTAINER_CLASS } from "@/components/ui/container";

// Task 17 §7: the site had no custom 404 before this — Next.js was
// serving its bare generic default. This renders inside the root layout
// (header/footer/mobile nav included automatically, same as every other
// page) and Next.js gives the response a real 404 status code on its own
// for this file — `robots: { index: false }` is just explicit belt-and-
// braces on top of that, not the only thing keeping it out of the index.
export const metadata: Metadata = {
  title: "Page not found | MTG",
  robots: { index: false, follow: true },
};

const POPULAR_LINKS = [
  { label: "Resorts & hotels", href: "/maldives/stays/" },
  { label: "Diving", href: "/maldives/diving/" },
  { label: "Fishing", href: "/maldives/fishing/" },
  { label: "Activities", href: "/maldives/activities/" },
  { label: "Transfers", href: "/maldives/transfers/" },
  { label: "Packages", href: "/maldives/packages/" },
  { label: "Travel Guide", href: "/maldives/travel-guide/" },
];

export default function NotFound() {
  return (
    <main className={`${CONTAINER_CLASS} flex flex-1 flex-col items-center justify-center py-20 text-center`}>
      <p className="text-sm font-semibold uppercase tracking-wide text-maldives-600">404</p>
      <h1 className="mt-2 text-3xl font-semibold text-ocean-900 sm:text-4xl">We couldn&rsquo;t find that page</h1>
      <p className="mt-3 max-w-md text-neutral-600">
        The page you&rsquo;re looking for may have moved or no longer exists. Try one of these instead:
      </p>

      <div className="mt-6 flex flex-wrap items-center justify-center gap-3">
        <Button href="/">Go to homepage</Button>
        <Button href="/maldives/search/" variant="secondary">
          Search the site
        </Button>
      </div>

      <nav aria-label="Popular sections" className="mt-10 flex flex-wrap justify-center gap-2">
        {POPULAR_LINKS.map((link) => (
          <Link
            key={link.href}
            href={link.href}
            className="rounded-full border border-neutral-300 px-4 py-2 text-sm font-medium text-neutral-700 hover:border-maldives-500 hover:text-maldives-600"
          >
            {link.label}
          </Link>
        ))}
      </nav>
    </main>
  );
}
