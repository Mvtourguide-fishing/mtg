import Link from "next/link";

import { CONTAINER_CLASS } from "@/components/ui/container";
import {
  FacebookIcon,
  InstagramIcon,
  PinterestIcon,
  TikTokIcon,
  WhatsAppIcon,
  XIcon,
  YouTubeIcon,
} from "@/components/ui/icons";

const TRAVEL_LINKS = [
  { label: "Maldives", href: "/maldives/" },
  { label: "Atolls", href: "/maldives/atolls/" },
  { label: "Islands", href: "/maldives/islands/" },
  { label: "Resorts", href: "/maldives/resorts/" },
  { label: "Hotels", href: "/maldives/hotels/" },
  { label: "Guesthouses", href: "/maldives/guesthouses/" },
  { label: "Activities", href: "/maldives/activities/" },
  { label: "Fishing", href: "/maldives/fishing/" },
  { label: "Diving", href: "/maldives/diving/" },
  { label: "Surfing", href: "/maldives/surfing/" },
  { label: "Transfers", href: "/maldives/transfers/" },
  { label: "Airport Transfers", href: "/maldives/airport-transfers/" },
  { label: "Resort Transfers", href: "/maldives/resort-transfers/" },
  { label: "Island Transfers", href: "/maldives/island-transfers/" },
  { label: "Private Speedboat Charter", href: "/maldives-speedboats-charter/" },
  { label: "Ferry Schedule", href: "/maldives-ferry-schedule/" },
  { label: "Packages", href: "/maldives/packages/" },
  { label: "Travel Guide", href: "/maldives/travel-guide/" },
];

const WHATSAPP_URL = "https://wa.me/9607794332";

// Real, verified MTG profiles only — see Task 12 brief. Do not add any
// account not explicitly supplied.
const SOCIAL_LINKS = [
  { label: "YouTube", href: "https://www.youtube.com/@Maldives-Holiday", Icon: YouTubeIcon },
  { label: "Facebook", href: "https://web.facebook.com/maldivestourguide", Icon: FacebookIcon },
  { label: "X", href: "https://x.com/maldivestourg", Icon: XIcon },
  { label: "Pinterest", href: "https://www.pinterest.com/themaldivesholidays/", Icon: PinterestIcon },
  { label: "TikTok", href: "https://www.tiktok.com/@maldivestourguides?lang=en", Icon: TikTokIcon },
  { label: "Instagram", href: "https://www.instagram.com/themaldivesholiday/", Icon: InstagramIcon },
];

export function SiteFooter() {
  const year = new Date().getFullYear();

  return (
    <footer className="border-t border-neutral-200 bg-ocean-950 text-lagoon-100">
      <div className={`${CONTAINER_CLASS} py-12`}>
        <div className="grid gap-10 lg:grid-cols-[2fr_3fr_2fr]">
          <div>
            <p className="text-lg font-semibold text-white">
              <span className="text-lagoon-300">MTG</span> · Maldives Tour Guide
            </p>
            <p className="mt-3 max-w-xs text-sm text-lagoon-100/80">
              A directory and travel guide for the Maldives — real atolls, islands, resorts, activities and transfers,
              sourced and kept up to date.
            </p>
            <a
              href={WHATSAPP_URL}
              target="_blank"
              rel="noopener noreferrer"
              className="mt-5 inline-flex items-center gap-2 rounded-full bg-white/10 px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-white/20"
            >
              <WhatsAppIcon className="h-4 w-4" />
              Chat with us on WhatsApp
            </a>
          </div>

          <div>
            <p className="text-xs font-semibold uppercase tracking-wide text-lagoon-300">Travel</p>
            <ul className="mt-4 grid grid-cols-2 gap-x-6 gap-y-2 text-sm sm:grid-cols-3">
              {TRAVEL_LINKS.map((link) => (
                <li key={link.href}>
                  <Link href={link.href} className="text-lagoon-100/80 transition-colors hover:text-white">
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          <div>
            <p className="text-xs font-semibold uppercase tracking-wide text-lagoon-300">Follow MTG</p>
            <ul className="mt-4 flex flex-wrap gap-2">
              {SOCIAL_LINKS.map(({ label, href, Icon }) => (
                <li key={label}>
                  <a
                    href={href}
                    target="_blank"
                    rel="noopener noreferrer"
                    aria-label={`MTG on ${label} (opens in a new tab)`}
                    className="min-touch-target inline-flex items-center justify-center rounded-full bg-white/10 text-white transition-colors hover:bg-white/20"
                  >
                    <Icon className="h-5 w-5" />
                  </a>
                </li>
              ))}
            </ul>
          </div>
        </div>

        <div className="mt-10 flex flex-col gap-2 border-t border-white/10 pt-6 text-xs text-lagoon-100/60 sm:flex-row sm:items-center sm:justify-between">
          <p>© {year} Maldives Tour Guide (MTG). All information is provided for travel planning purposes.</p>
        </div>
      </div>
    </footer>
  );
}
