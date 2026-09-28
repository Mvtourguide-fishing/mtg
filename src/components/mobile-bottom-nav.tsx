"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

import { BedIcon, BoatIcon, CompassIcon, DivingIcon, FishIcon } from "@/components/ui/icons";

const ITEMS = [
  { label: "Resorts", href: "/maldives/resorts/", Icon: BedIcon },
  { label: "Activities", href: "/maldives/activities/", Icon: CompassIcon },
  { label: "Fishing", href: "/maldives/fishing/", Icon: FishIcon },
  { label: "Diving", href: "/maldives/diving/", Icon: DivingIcon },
  { label: "Transfers", href: "/maldives/transfers/", Icon: BoatIcon },
] as const;

/**
 * Fixed, mobile-only app-style bottom navigation (Task 12 §5). Exactly the
 * five destinations the brief specifies — this is not a general nav
 * replacement, so it deliberately does not try to cover every section of
 * the site. `layout.tsx` adds matching bottom padding to the page content
 * so this never covers anything.
 */
export function MobileBottomNav() {
  const pathname = usePathname();

  return (
    <nav
      aria-label="Primary"
      className="pb-safe fixed inset-x-0 bottom-0 z-40 border-t border-neutral-200 bg-white/95 backdrop-blur supports-[backdrop-filter]:bg-white/90 lg:hidden"
    >
      <ul className="grid grid-cols-5">
        {ITEMS.map(({ label, href, Icon }) => {
          const active = pathname === href || pathname.startsWith(href);
          return (
            <li key={href}>
              <Link
                href={href}
                aria-current={active ? "page" : undefined}
                className="min-touch-target flex flex-col items-center justify-center gap-0.5 py-2 text-[11px] font-medium text-neutral-500 transition-colors hover:text-maldives-600"
              >
                <Icon className={`h-6 w-6 ${active ? "text-maldives-600" : "text-neutral-400"}`} />
                <span className={active ? "text-maldives-600" : ""}>{label}</span>
              </Link>
            </li>
          );
        })}
      </ul>
    </nav>
  );
}
