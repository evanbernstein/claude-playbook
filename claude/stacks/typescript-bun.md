# TypeScript with Bun and Biome

Conventions for TypeScript projects using Bun as the runtime and Biome as the formatter/linter.

## Tooling

- **Use Bun, not Node.** Run scripts with `bun run <script>`, install packages with `bun install` or `bun add <pkg>`.
- **Use `yarn` for frontend tooling** *when the project specifies it*. Some projects pin `yarn` for biome, vitest, and similar tools. Never reach for `npx` in those projects; use the project's package manager.
- **Use `make` commands when the project has a Makefile.** They handle environment setup and proper execution paths. Defer to the targets the project actually defines.

## Formatting and linting

- **Use `biome check --fix`**, not `biome format --write`. The `check` command includes import sorting and lint fixes; `format` only formats.
  - `bunx biome check --fix <files>` (or `yarn biome check --fix <files>` depending on the project)
- **Only format files you changed.** Never run project-wide formatting. Biome handles formatting, import sorting, and lint fixes; never use Prettier or other formatters.
- **Never use ESLint or Prettier** if Biome is configured. Biome replaces both.

## Type checking and tests

- Type-check at the project root, not from sub-package directories. In a monorepo this means running the type-checker from the workspace root so cross-package types resolve.
- Test files are colocated with source: `*.test.{ts,tsx}`.
- Run tests with `bun run test`.

## Verifying UI changes

When the user gives you a screenshot or visual feedback, confirm which file actually renders the element before editing. Shared UI primitives are usually wrapped by multiple parents, and editing the wrong wrapper produces no visible change.

1. **Grep for visible text from the screenshot** to find candidate components.
2. **Check the route or page-level component** to see which child it actually renders. Don't assume the lowest-level primitive in your search results is the one; the parent may have its own styling that overrides it.
3. **Only then edit.** If multiple files render the same primitive, be explicit about which one you're changing and whether the change should apply to all.

30 seconds of verification beats five minutes of editing the wrong file.

## Package structure

Every package should have a clear public API via `index.ts` (or `index.js`). Code outside the package imports from the package root; code inside imports from internal files directly.

1. Each package exports its public API from `index.ts`. Consumers import from the package root, not from internal files.
2. **No cross-package re-exports.** If package A needs a type defined in package B, package A imports it from B; A does not re-export B's type for "ergonomics." Cross-package re-exports introduce import cycles, slow down builds, and make it ambiguous which package owns a type.
