"use client";

import { useRouter } from "next/navigation";
import { useEffect, useId, useRef, useState } from "react";

import { SearchIcon } from "@/components/ui/icons";
import type { SearchResult } from "@/lib/search/types";

const DEBOUNCE_MS = 250;
const MIN_QUERY_LENGTH = 2;

/**
 * Shared search input + autocomplete dropdown (Task 13 §25: one
 * implementation, used by the desktop header, the mobile header, and the
 * homepage). Debounces suggestion requests, supports arrow-key
 * navigation, and always submits to /maldives/search/?q=... — the same
 * page every entry point lands on.
 */
export function SearchBox({
  variant = "inline",
  placeholder = "Search resorts, islands, activities…",
  autoFocus = false,
  onNavigate,
  className = "",
}: {
  variant?: "inline" | "header";
  placeholder?: string;
  autoFocus?: boolean;
  onNavigate?: () => void;
  className?: string;
}) {
  const router = useRouter();
  const listId = useId();
  const inputRef = useRef<HTMLInputElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const requestIdRef = useRef(0);

  const [value, setValue] = useState("");
  const [suggestions, setSuggestions] = useState<SearchResult[]>([]);
  const [open, setOpen] = useState(false);
  const [activeIndex, setActiveIndex] = useState(-1);
  const [loading, setLoading] = useState(false);

  // Debouncing lives in the change handler (an event, not an effect) so
  // there's no state-during-render/effect tension to manage — fetching in
  // response to a user keystroke is a plain event-driven side effect.
  useEffect(() => {
    return () => {
      if (debounceRef.current) clearTimeout(debounceRef.current);
    };
  }, []);

  function handleChange(event: React.ChangeEvent<HTMLInputElement>) {
    const next = event.target.value;
    setValue(next);
    setOpen(true);

    if (debounceRef.current) clearTimeout(debounceRef.current);

    const query = next.trim();
    if (query.length < MIN_QUERY_LENGTH) {
      requestIdRef.current++;
      setLoading(false);
      return;
    }

    setLoading(true);
    debounceRef.current = setTimeout(async () => {
      const requestId = ++requestIdRef.current;
      try {
        const res = await fetch(`/api/search/suggest?q=${encodeURIComponent(query)}`);
        if (!res.ok) return;
        const data = (await res.json()) as { results: SearchResult[] };
        // Ignore stale responses that resolve out of order.
        if (requestId === requestIdRef.current) {
          setSuggestions(data.results);
          setActiveIndex(-1);
        }
      } catch {
        // Network hiccup — leave whatever suggestions are already shown.
      } finally {
        if (requestId === requestIdRef.current) setLoading(false);
      }
    }, DEBOUNCE_MS);
  }

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  function goToSearchPage(query: string) {
    const trimmed = query.trim();
    if (!trimmed) return;
    setOpen(false);
    onNavigate?.();
    router.push(`/maldives/search/?q=${encodeURIComponent(trimmed)}`);
  }

  function goToResult(result: SearchResult) {
    setOpen(false);
    onNavigate?.();
    router.push(result.href);
  }

  function handleKeyDown(event: React.KeyboardEvent<HTMLInputElement>) {
    if (event.key === "ArrowDown") {
      event.preventDefault();
      if (!open) setOpen(true);
      setActiveIndex((i) => Math.min(i + 1, suggestions.length - 1));
    } else if (event.key === "ArrowUp") {
      event.preventDefault();
      setActiveIndex((i) => Math.max(i - 1, -1));
    } else if (event.key === "Enter") {
      event.preventDefault();
      if (activeIndex >= 0 && suggestions[activeIndex]) {
        goToResult(suggestions[activeIndex]);
      } else {
        goToSearchPage(value);
      }
    } else if (event.key === "Escape") {
      if (open) {
        setOpen(false);
        setActiveIndex(-1);
      } else {
        inputRef.current?.blur();
      }
    }
  }

  const showDropdown = open && value.trim().length >= MIN_QUERY_LENGTH;
  const visibleSuggestions = showDropdown ? suggestions : [];

  return (
    <div ref={containerRef} className={`relative ${className}`.trim()}>
      <form
        role="search"
        onSubmit={(event) => {
          event.preventDefault();
          goToSearchPage(value);
        }}
      >
        <label htmlFor={`${listId}-input`} className="sr-only">
          Search MTG
        </label>
        <div className="relative">
          <SearchIcon className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-neutral-400" />
          <input
            ref={inputRef}
            id={`${listId}-input`}
            type="search"
            role="combobox"
            aria-expanded={showDropdown}
            aria-controls={listId}
            aria-autocomplete="list"
            aria-activedescendant={activeIndex >= 0 ? `${listId}-option-${activeIndex}` : undefined}
            autoComplete="off"
            autoFocus={autoFocus}
            value={value}
            onChange={handleChange}
            onFocus={() => setOpen(true)}
            onKeyDown={handleKeyDown}
            placeholder={placeholder}
            className={
              variant === "header"
                ? "w-56 rounded-full border border-neutral-300 bg-white py-2 pl-9 pr-3 text-sm text-ocean-900 focus:w-72 focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1 transition-[width]"
                : "w-full rounded-full border border-neutral-300 bg-white py-3 pl-11 pr-4 text-base text-ocean-900 shadow-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
            }
          />
        </div>
      </form>

      {showDropdown && (
        <div
          id={listId}
          role="listbox"
          aria-label="Search suggestions"
          className="absolute left-0 right-0 z-50 mt-2 max-h-96 overflow-y-auto rounded-2xl border border-neutral-200 bg-white py-2 shadow-lg"
        >
          {loading && visibleSuggestions.length === 0 && (
            <p className="px-4 py-3 text-sm text-neutral-500">Searching…</p>
          )}

          {!loading && visibleSuggestions.length === 0 && (
            <p className="px-4 py-3 text-sm text-neutral-500">No quick matches — press Enter to search everything.</p>
          )}

          {visibleSuggestions.map((result, index) => (
            <button
              key={`${result.type}:${result.id}`}
              id={`${listId}-option-${index}`}
              role="option"
              aria-selected={index === activeIndex}
              type="button"
              onMouseDown={(event) => event.preventDefault()}
              onClick={() => goToResult(result)}
              onMouseEnter={() => setActiveIndex(index)}
              className={`flex w-full items-center justify-between gap-3 px-4 py-2.5 text-left text-sm transition-colors ${
                index === activeIndex ? "bg-lagoon-100" : "hover:bg-neutral-50"
              }`}
            >
              <span className="min-w-0">
                <span className="block truncate font-medium text-ocean-900">{result.title}</span>
                <span className="block truncate text-xs text-neutral-500">
                  {result.typeLabel}
                  {result.context ? ` · ${result.context}` : ""}
                </span>
              </span>
            </button>
          ))}

          {value.trim().length >= MIN_QUERY_LENGTH && (
            <button
              type="button"
              onMouseDown={(event) => event.preventDefault()}
              onClick={() => goToSearchPage(value)}
              className="mt-1 block w-full border-t border-neutral-100 px-4 py-2.5 text-left text-sm font-medium text-maldives-600 hover:bg-neutral-50"
            >
              View all results for “{value.trim()}”
            </button>
          )}
        </div>
      )}
    </div>
  );
}
