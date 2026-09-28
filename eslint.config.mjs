import { defineConfig, globalIgnores } from "eslint/config";
import nextVitals from "eslint-config-next/core-web-vitals";
import nextTs from "eslint-config-next/typescript";

const eslintConfig = defineConfig([
  ...nextVitals,
  ...nextTs,
  // Override default ignores of eslint-config-next.
  globalIgnores([
    // Default ignores of eslint-config-next:
    ".next/**",
    "out/**",
    "build/**",
    "next-env.d.ts",
    // Task 14: the extracted legacy website (migration INPUT, gitignored —
    // see .gitignore's note). Being gitignored doesn't exempt it from
    // ESLint on its own; without this it floods `npm run lint` with
    // thousands of findings in third-party scraped JS that is never
    // committed and never runs as part of this app.
    "release/**",
  ]),
]);

export default eslintConfig;
