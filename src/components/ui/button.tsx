import Link from "next/link";
import type { AnchorHTMLAttributes, ButtonHTMLAttributes, ReactNode } from "react";

export type ButtonVariant = "primary" | "secondary" | "ghost" | "inverted";
export type ButtonSize = "md" | "sm";

const VARIANT_CLASS: Record<ButtonVariant, string> = {
  primary: "bg-maldives-600 text-white hover:bg-ocean-800",
  secondary: "border border-neutral-300 bg-white text-ocean-900 hover:border-maldives-500 hover:text-maldives-600",
  ghost: "text-maldives-600 hover:text-ocean-800",
  // For use on dark/ocean-gradient backgrounds (e.g. the hero).
  inverted: "bg-white text-ocean-900 hover:bg-lagoon-100",
};

const SIZE_CLASS: Record<ButtonSize, string> = {
  md: "px-5 py-2.5 text-sm",
  sm: "px-3.5 py-2 text-sm",
};

const BASE =
  "inline-flex items-center justify-center gap-2 rounded-full font-medium transition-colors focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-maldives-500 disabled:opacity-50 disabled:pointer-events-none";

interface BaseProps {
  variant?: ButtonVariant;
  size?: ButtonSize;
  className?: string;
  children: ReactNode;
}

type ButtonAsButtonProps = BaseProps &
  Omit<ButtonHTMLAttributes<HTMLButtonElement>, "className"> & { href?: undefined };

type ButtonAsLinkProps = BaseProps &
  Omit<AnchorHTMLAttributes<HTMLAnchorElement>, "className"> & { href: string };

/** Renders a `<Link>` when `href` is given, otherwise a `<button>` — one
 * component covers both a call-to-action link and a form/action button
 * with identical visual treatment. */
export function Button({ variant = "primary", size = "md", className = "", children, ...rest }: ButtonAsButtonProps | ButtonAsLinkProps) {
  const classes = [BASE, VARIANT_CLASS[variant], SIZE_CLASS[size], className].filter(Boolean).join(" ");

  if (rest.href) {
    const { href, ...anchorRest } = rest as ButtonAsLinkProps;
    return (
      <Link href={href} className={classes} {...anchorRest}>
        {children}
      </Link>
    );
  }

  return (
    <button className={classes} {...(rest as ButtonHTMLAttributes<HTMLButtonElement>)}>
      {children}
    </button>
  );
}

/** A circular icon-only button (menu toggle, etc.) with an accessible
 * label and a comfortable minimum touch target. */
export function IconButton({
  label,
  className = "",
  children,
  ...rest
}: { label: string; className?: string; children: ReactNode } & ButtonHTMLAttributes<HTMLButtonElement>) {
  return (
    <button
      aria-label={label}
      className={[
        "min-touch-target inline-flex items-center justify-center rounded-full text-ocean-900 transition-colors hover:bg-lagoon-100 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-maldives-500",
        className,
      ]
        .filter(Boolean)
        .join(" ")}
      {...rest}
    >
      {children}
    </button>
  );
}
