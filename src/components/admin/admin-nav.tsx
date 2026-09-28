"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const NAV_ITEMS = [
  { label: "Dashboard", href: "/admin" },
  { label: "Bookings", href: "/admin/bookings" },
  { label: "Reviews", href: "/admin/reviews" },
  { label: "Comments", href: "/admin/comments" },
  { label: "Providers", href: "/admin/providers" },
  { label: "Locations", href: "/admin/locations" },
  { label: "Redirects", href: "/admin/redirects" },
];

function isActive(pathname: string, href: string): boolean {
  if (href === "/admin") return pathname === "/admin";
  return pathname === href || pathname.startsWith(`${href}/`);
}

export function AdminNav({ isAdmin }: { isAdmin: boolean }) {
  const pathname = usePathname();
  const items = isAdmin ? [...NAV_ITEMS, { label: "Users", href: "/admin/users" }] : NAV_ITEMS;

  return (
    <nav aria-label="Admin" className="flex flex-wrap gap-1">
      {items.map((item) => {
        const active = isActive(pathname, item.href);
        return (
          <Link
            key={item.href}
            href={item.href}
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
  );
}
