import type { ReactNode } from "react";

type BadgeTone = "neutral" | "maldives" | "aqua" | "outline";

const TONE_CLASS: Record<BadgeTone, string> = {
  neutral: "bg-neutral-100 text-neutral-700",
  maldives: "bg-maldives-600/10 text-maldives-600",
  aqua: "bg-aqua-500/10 text-aqua-500",
  outline: "border border-neutral-300 text-neutral-700",
};

export function Badge({
  tone = "neutral",
  className = "",
  children,
}: {
  tone?: BadgeTone;
  className?: string;
  children: ReactNode;
}) {
  return (
    <span className={[`inline-flex items-center gap-1 rounded-full px-2.5 py-1 text-xs font-medium`, TONE_CLASS[tone], className].filter(Boolean).join(" ")}>
      {children}
    </span>
  );
}
