# No abbreviations in identifiers

Do not abbreviate words in code identifiers: variable names, function names, fixture helpers, argument names, test names. Write out the full word.

**Why:** Abbreviations save a few keystrokes but cost readability, especially in multi-phase projects where unfamiliar code is read more often than it's written. `performance` is clearer than `perf`, `performances` than `perfs`, `random_generator` than `rng`, `meta_game_controller` than `meta`. Consistency also matters: mixing `perf` in one file with `performance` in another creates friction.

**How to apply:**

- When writing new code, use full words.
- When reading user-provided code/patterns, mirror what's already there. If the codebase established an abbreviation (e.g. `db` in many services), don't diverge.
- This rule is about NEW identifiers you introduce, not about reverting conventions already in production code.
- Applies to: local variables, fixture factory functions (`makePerformance` not `makePerf`), function parameters, test descriptions, TypeScript type aliases.
- Does **not** apply to: standard abbreviations that are industry conventions (`id`, `db`, `url`, `http`, `json`, `css`, `env`), or field names that already exist in types/schemas you can't change.
