"use client";

import { useEffect, useId, useRef, useState } from "react";

import type { FinderEndpoint, FinderEndpointKind } from "@/lib/transfers/finder";

const DEBOUNCE_MS = 200;
const MIN_QUERY_LENGTH = 2;

const KIND_ICON: Record<FinderEndpointKind, string> = {
  island: "🏝",
  atoll: "📍",
  airport: "✈",
  locality: "📍",
  resort: "🏨",
  hotel: "🏨",
  guesthouse: "🏨",
  villa: "🏨",
};

const KIND_LABEL: Record<FinderEndpointKind, string> = {
  island: "Island",
  atoll: "Atoll",
  airport: "Airport",
  locality: "City",
  resort: "Resort",
  hotel: "Hotel",
  guesthouse: "Guesthouse",
  villa: "Villa",
};

/**
 * From/To combobox for the transfer finder (Task 20 §6-7): a real,
 * keyboard-accessible autocomplete over locations + accommodations, not a
 * plain <datalist>. Renders two hidden inputs (`${name}` = slug,
 * `${name}Label` is purely visual) so the parent stays a plain <form> —
 * no client-side form-state lifting needed for the Search button to work.
 */
export function LocationCombobox({
  name,
  label,
  placeholder,
  defaultSlug,
  defaultLabel,
}: {
  name: string;
  label: string;
  placeholder: string;
  defaultSlug?: string;
  defaultLabel?: string;
}) {
  const listId = useId();
  const containerRef = useRef<HTMLDivElement>(null);
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const requestIdRef = useRef(0);

  const [value, setValue] = useState(defaultLabel ?? "");
  const [selectedSlug, setSelectedSlug] = useState(defaultSlug ?? "");
  const [suggestions, setSuggestions] = useState<FinderEndpoint[]>([]);
  const [open, setOpen] = useState(false);
  const [activeIndex, setActiveIndex] = useState(-1);

  useEffect(() => {
    return () => {
      if (debounceRef.current) clearTimeout(debounceRef.current);
    };
  }, []);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) setOpen(false);
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  function handleChange(event: React.ChangeEvent<HTMLInputElement>) {
    const next = event.target.value;
    setValue(next);
    setSelectedSlug("");
    setOpen(true);

    if (debounceRef.current) clearTimeout(debounceRef.current);
    const query = next.trim();
    if (query.length < MIN_QUERY_LENGTH) {
      requestIdRef.current++;
      setSuggestions([]);
      return;
    }

    debounceRef.current = setTimeout(async () => {
      const requestId = ++requestIdRef.current;
      try {
        const res = await fetch(`/api/transfers/finder-suggest?q=${encodeURIComponent(query)}`);
        if (!res.ok) return;
        const data = (await res.json()) as { results: FinderEndpoint[] };
        if (requestId === requestIdRef.current) {
          setSuggestions(data.results);
          setActiveIndex(-1);
        }
      } catch {
        // leave existing suggestions on a network hiccup
      }
    }, DEBOUNCE_MS);
  }

  function selectEndpoint(endpoint: FinderEndpoint) {
    setValue(endpoint.title);
    setSelectedSlug(endpoint.locationSlug);
    setOpen(false);
    setSuggestions([]);
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
      if (open && activeIndex >= 0 && suggestions[activeIndex]) {
        event.preventDefault();
        selectEndpoint(suggestions[activeIndex]);
      }
    } else if (event.key === "Escape") {
      setOpen(false);
    }
  }

  const showDropdown = open && value.trim().length >= MIN_QUERY_LENGTH && suggestions.length > 0;

  return (
    <div ref={containerRef} className="relative">
      <label htmlFor={`${listId}-input`} className="mb-1 block text-xs font-medium text-neutral-600">
        {label}
      </label>
      <input
        id={`${listId}-input`}
        type="text"
        role="combobox"
        aria-expanded={showDropdown}
        aria-controls={listId}
        aria-autocomplete="list"
        aria-activedescendant={activeIndex >= 0 ? `${listId}-option-${activeIndex}` : undefined}
        autoComplete="off"
        value={value}
        onChange={handleChange}
        onFocus={() => setOpen(true)}
        onKeyDown={handleKeyDown}
        placeholder={placeholder}
        className="min-touch-target w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
      />
      {/* The real value the form submits — a location slug, only ever set
          by selecting a real suggestion, never typed freehand, so the
          server side can never receive a fabricated endpoint. */}
      <input type="hidden" name={name} value={selectedSlug} />

      {showDropdown && (
        <div
          id={listId}
          role="listbox"
          aria-label={`${label} suggestions`}
          className="absolute left-0 right-0 z-50 mt-2 max-h-72 overflow-y-auto rounded-2xl border border-neutral-200 bg-white py-2 shadow-lg"
        >
          {suggestions.map((endpoint, index) => (
            <button
              key={`${endpoint.kind}:${endpoint.locationId}`}
              id={`${listId}-option-${index}`}
              role="option"
              aria-selected={index === activeIndex}
              type="button"
              onMouseDown={(event) => event.preventDefault()}
              onClick={() => selectEndpoint(endpoint)}
              onMouseEnter={() => setActiveIndex(index)}
              className={`flex w-full items-center gap-3 px-4 py-2.5 text-left text-sm transition-colors ${
                index === activeIndex ? "bg-lagoon-100" : "hover:bg-neutral-50"
              }`}
            >
              <span aria-hidden="true" className="text-base">
                {KIND_ICON[endpoint.kind]}
              </span>
              <span className="min-w-0">
                <span className="block truncate font-medium text-ocean-900">{endpoint.title}</span>
                <span className="block truncate text-xs text-neutral-500">
                  {KIND_LABEL[endpoint.kind]}
                  {endpoint.subtitle ? ` · ${endpoint.subtitle}` : ""}
                </span>
              </span>
            </button>
          ))}
        </div>
      )}
    </div>
  );
}
