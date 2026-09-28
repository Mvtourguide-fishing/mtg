"use client";

import Image from "next/image";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useState } from "react";

import { SearchBox } from "@/components/search/search-box";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { CloseIcon, MenuIcon, SearchIcon } from "@/components/ui/icons";

const PRIMARY_NAV = [
  { label: "Maldives", href: "/maldives/" },
  { label: "Stays", href: "/maldives/stays/" },
  { label: "Activities", href: "/maldives/activities/" },
  { label: "Diving", href: "/maldives/diving/" },
  { label: "Fishing", href: "/maldives/fishing/" },
  { label: "Transfers", href: "/maldives/transfers/" },
  { label: "Packages", href: "/maldives/packages/" },
  { label: "Travel Guide", href: "/maldives/travel-guide/" },
];

const WHATSAPP_URL = "https://wa.me/9607794332";

// Site search is temporarily disabled in the header (not removed — the
// owner may re-enable it later). Flip this back to true to restore it.
const SEARCH_ENABLED = false;

function isActive(pathname: string, href: string): boolean {
  if (href === "/maldives/") return pathname === "/maldives" || pathname === "/maldives/";
  return pathname === href || pathname.startsWith(href);
}

type MobilePanel = "none" | "nav" | "search";

export function SiteHeader() {
  const pathname = usePathname();
  const [mobilePanel, setMobilePanel] = useState<MobilePanel>("none");

  // Close whichever mobile panel is open on route change, so it never
  // lingers open after a navigation. Adjusting state during render
  // (React's recommended pattern for resetting state in response to a
  // derived value changing) rather than in an effect.
  const [lastPathname, setLastPathname] = useState(pathname);
  if (pathname !== lastPathname) {
    setLastPathname(pathname);
    setMobilePanel("none");
  }

  function toggle(panel: MobilePanel) {
    setMobilePanel((current) => (current === panel ? "none" : panel));
  }

  return (
    <header className="sticky top-0 z-40 border-b border-neutral-200 bg-white/95 backdrop-blur supports-[backdrop-filter]:bg-white/80">
      <div className={`${CONTAINER_CLASS} flex h-16 items-center justify-between gap-4`}>
        <Link href="/" className="flex shrink-0 items-center">
          {/* unoptimized: Next's image optimizer flattens this PNG's
              transparent background onto white when it re-encodes a
              resized variant — verified by fetching the optimized
              srcset URL directly and checking its alpha channel. This is
              a small, always-visible static asset, so skipping
              optimization (serving the original file's bytes verbatim)
              is the simplest fix and costs nothing in practice. */}
          <Image src="/logo.png" alt="Maldives Tour Guide" width={445} height={300} priority unoptimized className="h-10 w-auto sm:h-12" />
        </Link>

        <nav aria-label="Primary" className="hidden items-center gap-1 lg:flex">
          {PRIMARY_NAV.map((item) => {
            const active = isActive(pathname, item.href);
            return (
              <Link
                key={item.href}
                href={item.href}
                prefetch={false}
                aria-current={active ? "page" : undefined}
                className={`rounded-full px-3.5 py-2 text-sm font-medium transition-colors ${
                  active ? "bg-lagoon-100 text-ocean-900" : "text-neutral-600 hover:bg-neutral-100 hover:text-ocean-900"
                }`}
              >
                {item.label}
              </Link>
            );
          })}
        </nav>

        <div className="hidden shrink-0 items-center gap-3 lg:flex">
          {SEARCH_ENABLED && <SearchBox variant="header" placeholder="Search MTG…" />}
          <a
            href={WHATSAPP_URL}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center justify-center rounded-full bg-maldives-600 px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-ocean-800"
          >
            Get in touch
          </a>
        </div>

        <div className="flex items-center gap-1 lg:hidden">
          {SEARCH_ENABLED && (
            <button
              type="button"
              aria-label={mobilePanel === "search" ? "Close search" : "Search"}
              aria-expanded={mobilePanel === "search"}
              aria-controls="mobile-search-panel"
              onClick={() => toggle("search")}
              className="min-touch-target inline-flex items-center justify-center rounded-full text-ocean-900 transition-colors hover:bg-neutral-100"
            >
              {mobilePanel === "search" ? <CloseIcon className="h-6 w-6" /> : <SearchIcon className="h-6 w-6" />}
            </button>
          )}
          <button
            type="button"
            aria-label={mobilePanel === "nav" ? "Close menu" : "Open menu"}
            aria-expanded={mobilePanel === "nav"}
            aria-controls="mobile-nav-panel"
            onClick={() => toggle("nav")}
            className="min-touch-target inline-flex items-center justify-center rounded-full text-ocean-900 transition-colors hover:bg-neutral-100"
          >
            {mobilePanel === "nav" ? <CloseIcon className="h-6 w-6" /> : <MenuIcon className="h-6 w-6" />}
          </button>
        </div>
      </div>

      {SEARCH_ENABLED && mobilePanel === "search" && (
        <div id="mobile-search-panel" className="border-t border-neutral-200 bg-white p-4 lg:hidden">
          <SearchBox variant="inline" autoFocus placeholder="Search resorts, islands, activities…" onNavigate={() => setMobilePanel("none")} />
        </div>
      )}

      {mobilePanel === "nav" && (
        <div id="mobile-nav-panel" className="border-t border-neutral-200 bg-white lg:hidden">
          <nav aria-label="Primary" className={`${CONTAINER_CLASS} flex flex-col gap-1 py-3`}>
            {PRIMARY_NAV.map((item) => {
              const active = isActive(pathname, item.href);
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  prefetch={false}
                  aria-current={active ? "page" : undefined}
                  className={`rounded-lg px-3 py-2.5 text-base font-medium transition-colors ${
                    active ? "bg-lagoon-100 text-ocean-900" : "text-neutral-700 hover:bg-neutral-100"
                  }`}
                >
                  {item.label}
                </Link>
              );
            })}
            <a
              href={WHATSAPP_URL}
              target="_blank"
              rel="noopener noreferrer"
              className="mt-2 inline-flex items-center justify-center rounded-full bg-maldives-600 px-4 py-2.5 text-sm font-medium text-white"
            >
              Get in touch
            </a>
          </nav>
        </div>
      )}
    </header>
  );
}
