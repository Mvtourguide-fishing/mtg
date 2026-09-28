/**
 * MTG icon set (Task 12). Hand-rolled inline SVGs rather than an icon
 * library dependency — the site only needs a small, fixed icon vocabulary
 * (nav, socials, a few UI affordances), so a dependency-free set keeps the
 * bundle minimal per the task's performance guidance. All icons are
 * `aria-hidden` by default; callers supply the accessible label on the
 * surrounding link/button.
 */
import type { SVGProps } from "react";

export type IconProps = SVGProps<SVGSVGElement>;

function base(props: IconProps) {
  return {
    xmlns: "http://www.w3.org/2000/svg",
    viewBox: "0 0 24 24",
    fill: "none",
    stroke: "currentColor",
    strokeWidth: 1.75,
    strokeLinecap: "round" as const,
    strokeLinejoin: "round" as const,
    "aria-hidden": true,
    ...props,
  };
}

export function MenuIcon(props: IconProps) {
  return (
    <svg {...base(props)}>
      <path d="M4 7h16M4 12h16M4 17h16" />
    </svg>
  );
}

export function CloseIcon(props: IconProps) {
  return (
    <svg {...base(props)}>
      <path d="M6 6l12 12M18 6L6 18" />
    </svg>
  );
}

export function ChevronRightIcon(props: IconProps) {
  return (
    <svg {...base(props)}>
      <path d="M9 6l6 6-6 6" />
    </svg>
  );
}

export function SearchIcon(props: IconProps) {
  return (
    <svg {...base(props)}>
      <circle cx="11" cy="11" r="7" />
      <path d="M21 21l-4.35-4.35" />
    </svg>
  );
}

export function MapPinIcon(props: IconProps) {
  return (
    <svg {...base(props)}>
      <path d="M12 21s-7-6.1-7-11.5A7 7 0 0 1 19 9.5C19 14.9 12 21 12 21z" />
      <circle cx="12" cy="9.5" r="2.5" />
    </svg>
  );
}

export function ArrowRightIcon(props: IconProps) {
  return (
    <svg {...base(props)}>
      <path d="M5 12h14M13 6l6 6-6 6" />
    </svg>
  );
}

/** Resorts / places to stay. */
export function BedIcon(props: IconProps) {
  return (
    <svg {...base(props)}>
      <path d="M3 18v-7a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v7" />
      <path d="M3 18v2M21 18v2" />
      <path d="M3 13v-2a2 2 0 0 1 2-2h6v4" />
      <circle cx="7.5" cy="10.5" r="1.25" />
    </svg>
  );
}

/** Activities. */
export function CompassIcon(props: IconProps) {
  return (
    <svg {...base(props)}>
      <circle cx="12" cy="12" r="9" />
      <path d="M15 9l-2 6-4 2 2-6z" />
    </svg>
  );
}

/** Fishing. */
export function FishIcon(props: IconProps) {
  return (
    <svg {...base(props)}>
      <path d="M3 12c3-4 8-6 12-4a9 9 0 0 1 5 4 9 9 0 0 1-5 4c-4 2-9 0-12-4z" />
      <path d="M17.5 8.5 21 6M17.5 15.5 21 18" />
      <circle cx="8" cy="12" r="0.75" fill="currentColor" stroke="none" />
    </svg>
  );
}

/** Diving. */
export function DivingIcon(props: IconProps) {
  return (
    <svg {...base(props)}>
      <path d="M4 17c1.5 1.5 3 1.5 4.5 0s3-1.5 4.5 0 3 1.5 4.5 0" />
      <path d="M4 12c1.5 1.5 3 1.5 4.5 0s3-1.5 4.5 0 3 1.5 4.5 0" />
      <circle cx="12" cy="6" r="2.25" />
    </svg>
  );
}

/** Transfers. */
export function BoatIcon(props: IconProps) {
  return (
    <svg {...base(props)}>
      <path d="M3 15h18l-2 4H5z" />
      <path d="M6 15V8h9l3 7" />
      <path d="M11 8V4h1a3 3 0 0 1 3 3v1" />
    </svg>
  );
}

/** Packages. */
export function PackageIcon(props: IconProps) {
  return (
    <svg {...base(props)}>
      <path d="M21 8 12 3 3 8l9 5 9-5z" />
      <path d="M3 8v9l9 5 9-5V8" />
      <path d="M12 13v9" />
    </svg>
  );
}

/** Travel guide / articles. */
export function BookIcon(props: IconProps) {
  return (
    <svg {...base(props)}>
      <path d="M4 5.5A2.5 2.5 0 0 1 6.5 3H20v15.5a1 1 0 0 1-1 1H6.5A2.5 2.5 0 0 0 4 22Z" />
      <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
    </svg>
  );
}

export function WhatsAppIcon(props: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden {...props}>
      <path d="M12.04 2C6.58 2 2.13 6.45 2.13 11.91c0 1.77.46 3.45 1.34 4.95L2 22l5.28-1.38a9.9 9.9 0 0 0 4.76 1.21h.01c5.46 0 9.91-4.45 9.91-9.91 0-2.65-1.03-5.14-2.9-7.01A9.86 9.86 0 0 0 12.04 2Zm0 1.8a8.1 8.1 0 0 1 8.1 8.11c0 4.47-3.63 8.1-8.1 8.1a8.06 8.06 0 0 1-4.12-1.13l-.3-.17-3.13.82.84-3.05-.19-.31a8.05 8.05 0 0 1-1.24-4.36 8.1 8.1 0 0 1 8.14-8.01Zm-4.49 4.3c-.17 0-.44.06-.67.32-.23.25-.87.85-.87 2.08 0 1.22.89 2.4 1.01 2.57.13.17 1.75 2.78 4.31 3.78 2.13.84 2.56.68 3.03.63.46-.04 1.49-.6 1.7-1.19.21-.58.21-1.08.15-1.19-.06-.1-.23-.17-.48-.29-.25-.13-1.49-.74-1.72-.82-.23-.08-.4-.13-.57.13-.17.25-.65.82-.8 1-.15.17-.29.19-.54.06-.25-.13-1.05-.39-2-1.24-.74-.66-1.24-1.47-1.39-1.72-.15-.25-.02-.39.11-.51.11-.11.25-.29.38-.44.13-.15.17-.25.25-.42.08-.17.04-.31-.02-.44-.06-.13-.57-1.4-.79-1.91-.2-.5-.41-.43-.57-.44Z" />
    </svg>
  );
}

export function FacebookIcon(props: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden {...props}>
      <path d="M13.5 22v-8.4h2.82l.42-3.28h-3.24V8.2c0-.95.26-1.6 1.63-1.6h1.74V3.67c-.3-.04-1.33-.13-2.53-.13-2.5 0-4.22 1.53-4.22 4.33v2.42H7.3v3.28h2.82V22Z" />
    </svg>
  );
}

export function InstagramIcon(props: IconProps) {
  return (
    <svg {...base(props)} fill="none">
      <rect x="3.5" y="3.5" width="17" height="17" rx="4.5" />
      <circle cx="12" cy="12" r="4" />
      <circle cx="17" cy="7" r="0.75" fill="currentColor" stroke="none" />
    </svg>
  );
}

export function XIcon(props: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden {...props}>
      <path d="M4 3h3.6l4.2 5.7L16.6 3H20l-6.2 8.1L20.4 21H16.8l-4.6-6.2L7 21H3.6l6.6-8.6Z" />
    </svg>
  );
}

export function YouTubeIcon(props: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden {...props}>
      <path d="M21.6 7.6a2.9 2.9 0 0 0-2-2.1C17.9 5 12 5 12 5s-5.9 0-7.6.5a2.9 2.9 0 0 0-2 2.1A30 30 0 0 0 2 12a30 30 0 0 0 .4 4.4 2.9 2.9 0 0 0 2 2.1c1.7.5 7.6.5 7.6.5s5.9 0 7.6-.5a2.9 2.9 0 0 0 2-2.1A30 30 0 0 0 22 12a30 30 0 0 0-.4-4.4ZM10 15V9l5.2 3Z" />
    </svg>
  );
}

export function PinterestIcon(props: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden {...props}>
      <path d="M12 2a10 10 0 0 0-3.65 19.31c-.05-.8-.09-2.02.02-2.9.1-.78.65-4.97.65-4.97s-.17-.34-.17-.83c0-.78.45-1.36 1.02-1.36.48 0 .71.36.71.79 0 .48-.31 1.2-.46 1.87-.13.56.28 1.02.83 1.02 1 0 1.77-1.05 1.77-2.58 0-1.35-.97-2.29-2.36-2.29-1.6 0-2.55 1.2-2.55 2.45 0 .48.19.99.42 1.27a.17.17 0 0 1 .04.16l-.16.65c-.03.11-.09.13-.21.08-.78-.36-1.27-1.5-1.27-2.42 0-1.97 1.43-3.78 4.13-3.78 2.17 0 3.85 1.55 3.85 3.61 0 2.15-1.36 3.89-3.24 3.89-.63 0-1.23-.33-1.43-.72l-.39 1.49c-.14.54-.52 1.22-.78 1.63A10 10 0 1 0 12 2Z" />
    </svg>
  );
}

export function TikTokIcon(props: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden {...props}>
      <path d="M14.5 2h2.9c.18 1.5 1.02 2.83 2.35 3.6.6.35 1.28.56 2 .63v2.9a6.3 6.3 0 0 1-3.4-1.02v6.4a5.85 5.85 0 1 1-5.85-5.85c.2 0 .4.01.6.04v2.94a2.9 2.9 0 1 0 2.05 2.77V2Z" />
    </svg>
  );
}
