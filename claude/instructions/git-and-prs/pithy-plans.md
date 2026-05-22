# Keep plan files pithy

Plan files are short and scannable. Important details stay (file paths, key data shape, test cases, non-obvious decisions), but cut the prose.

**Why:** I read plans top to bottom. Verbose plans bury the load-bearing decisions under context preambles, restated memory content, and exhaustive verification checklists I don't actually need to see.

**How to apply:**

- Aim for ~1 screen per plan when feasible.
- Use compact bullet lists, terse headings, code blocks only for non-obvious shapes (data structures, API contracts, regex).
- **Cut:** long Context sections, restated memory content, "rationale" subsections, exhaustive verification steps (3-5 critical checks max).
- **Keep:** branch name, files to touch, key data shape, test list, the one or two design decisions that aren't obvious from the file list.

## Skeleton

```
# Plan: <short title>

Branch: `<branch-name>`

## Files to touch
- `path/to/file.ts`: what changes
- `path/to/other.ts`: what changes

## Key decisions
- One or two design choices that aren't obvious from the file list.

## Tests
- Test 1
- Test 2
- Test 3

## Done when
- 3-5 concrete checks max.
```

Anything more than this should justify its presence.
