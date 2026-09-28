import * as cheerio from "cheerio";
import type { AnyNode, Element, Text } from "domhandler";

import type { EntityLinkTarget } from "@/lib/linking/entity-link-map";

/**
 * Rewrites real-world entity mentions in already-published HTML content
 * (article/guide body text) into real internal links — see
 * entity-link-map.ts for where the map comes from. Deliberately
 * conservative, per Task 23's own safety rules:
 *
 *   - Only the FIRST occurrence of each entity anywhere in the document
 *     gets linked (never every repeated mention).
 *   - Never descends into an existing <a>, a heading (h1-h6), <code>,
 *     <pre>, <script>, <style>, or <button> — so an existing link is never
 *     nested inside another, and a heading's own text is never rewritten.
 *   - Longer, more specific phrases (full accommodation names, "Kaafu
 *     Atoll") are tried before shorter ones, so "Kaafu Atoll" is never
 *     partially swallowed by a bare "Kaafu" match.
 *   - Word-boundary matching only — never mid-word.
 *   - A hard cap on total links inserted per document, and the current
 *     page's own href (if given) is always excluded — no self-links.
 *   - Uses a real HTML parser (cheerio/domhandler), never a blind
 *     string/regex replace over the whole document, so existing markup is
 *     never corrupted.
 */

const EXCLUDED_TAGS = new Set(["a", "h1", "h2", "h3", "h4", "h5", "h6", "code", "pre", "script", "style", "button", "textarea"]);

const DEFAULT_MAX_LINKS = 15;

export function escapeHtml(text: string): string {
  return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function escapeRegExp(text: string): string {
  return text.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function buildAlternationRegex(entities: EntityLinkTarget[]): RegExp | null {
  if (entities.length === 0) return null;
  // Longest phrase first, so the regex engine's left-to-right alternation
  // preference naturally picks the more specific match at a given position.
  const sorted = [...entities].sort((a, b) => b.phrase.length - a.phrase.length);
  const pattern = sorted.map((e) => escapeRegExp(e.phrase)).join("|");
  return new RegExp(`\\b(?:${pattern})\\b`, "gi");
}

function collectEligibleTextNodes(node: AnyNode, out: Text[]): void {
  const el = node as Element;
  const children = "children" in el ? el.children : undefined;
  if (!children) return;
  for (const child of children) {
    if (child.type === "text") {
      out.push(child as Text);
    } else if (child.type === "tag" && !EXCLUDED_TAGS.has((child as Element).name)) {
      collectEligibleTextNodes(child, out);
    }
    // Anything else (comments, excluded tags' subtrees, etc.) is skipped
    // entirely — never descended into.
  }
}

interface LinkState {
  remaining: EntityLinkTarget[];
  byLowerPhrase: Map<string, EntityLinkTarget>;
  usedHrefs: Set<string>;
  linksInserted: number;
  maxLinks: number;
}

/** Links at most the first occurrence of each still-unused entity found in
 * this one text node's string, honoring the global per-document link cap.
 * Returns the replacement HTML (escaped plain text interleaved with real
 * `<a>` tags), or null if nothing in this node should change. */
function linkifyTextNode(rawText: string, state: LinkState): string | null {
  if (state.linksInserted >= state.maxLinks || state.remaining.length === 0) return null;

  let regex = buildAlternationRegex(state.remaining);
  if (!regex) return null;

  let result = "";
  let lastIndex = 0;
  let changed = false;
  let match: RegExpExecArray | null;

  while (state.linksInserted < state.maxLinks && (match = regex.exec(rawText))) {
    const matchedText = match[0];
    const entity = state.byLowerPhrase.get(matchedText.toLowerCase());
    if (!entity || state.usedHrefs.has(entity.href)) {
      // Stale match from a phrase used up earlier in this same node's scan
      // (shouldn't normally happen since we rebuild the regex below, but a
      // defensive guard costs nothing) — skip forward past it.
      continue;
    }

    result += escapeHtml(rawText.slice(lastIndex, match.index));
    result += `<a href="${entity.href}">${escapeHtml(matchedText)}</a>`;
    lastIndex = match.index + matchedText.length;
    changed = true;

    state.usedHrefs.add(entity.href);
    state.linksInserted += 1;
    state.remaining = state.remaining.filter((e) => e.href !== entity.href);

    regex = buildAlternationRegex(state.remaining);
    if (!regex) break;
    regex.lastIndex = lastIndex;
  }

  if (!changed) return null;
  result += escapeHtml(rawText.slice(lastIndex));
  return result;
}

export function applyContextualLinks(
  html: string,
  entityMap: EntityLinkTarget[],
  options: { maxLinks?: number; excludeHref?: string } = {},
): string {
  if (!html || entityMap.length === 0) return html;

  const usable = options.excludeHref ? entityMap.filter((e) => e.href !== options.excludeHref) : entityMap;
  if (usable.length === 0) return html;

  const $ = cheerio.load(html, null, false);
  const root = $.root()[0];

  const textNodes: Text[] = [];
  collectEligibleTextNodes(root, textNodes);
  if (textNodes.length === 0) return html;

  const state: LinkState = {
    remaining: usable,
    byLowerPhrase: new Map(usable.map((e) => [e.phrase.toLowerCase(), e])),
    usedHrefs: new Set(),
    linksInserted: 0,
    maxLinks: options.maxLinks ?? DEFAULT_MAX_LINKS,
  };

  for (const textNode of textNodes) {
    if (state.linksInserted >= state.maxLinks) break;
    const raw = textNode.data;
    if (!raw || !raw.trim()) continue;
    const replacement = linkifyTextNode(raw, state);
    if (replacement !== null) {
      $(textNode).replaceWith(replacement);
    }
  }

  return $.root().html() ?? html;
}
