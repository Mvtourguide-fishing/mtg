"use client";

import { useEffect } from "react";

import { Button } from "@/components/ui/button";
import { CONTAINER_CLASS } from "@/components/ui/container";

// Task 17 §7/§30: the site had no error boundary before this — an
// uncaught render error fell through to Next.js's own default error UI.
// This is a Client Component by Next.js's own error.tsx convention (it
// needs `reset()` to retry rendering). Never renders `error.message` or
// `error.stack` to the visitor — only `error.digest` (an opaque id Next
// generates to correlate with server-side logs, not sensitive) is shown,
// and the full error is logged to the browser console for debugging only.
export default function GlobalError({ error, reset }: { error: Error & { digest?: string }; reset: () => void }) {
  useEffect(() => {
    console.error("Unhandled page error:", error);
  }, [error]);

  return (
    <main className={`${CONTAINER_CLASS} flex flex-1 flex-col items-center justify-center py-20 text-center`}>
      <p className="text-sm font-semibold uppercase tracking-wide text-maldives-600">Something went wrong</p>
      <h1 className="mt-2 text-3xl font-semibold text-ocean-900 sm:text-4xl">We hit a snag loading this page</h1>
      <p className="mt-3 max-w-md text-neutral-600">
        Please try again. If this keeps happening, contact us on WhatsApp and we&rsquo;ll take a look.
      </p>
      {error.digest && <p className="mt-2 font-mono text-xs text-neutral-400">Reference: {error.digest}</p>}

      <div className="mt-6 flex flex-wrap items-center justify-center gap-3">
        <Button onClick={() => reset()}>Try again</Button>
        <Button href="/" variant="secondary">
          Go to homepage
        </Button>
      </div>
    </main>
  );
}
