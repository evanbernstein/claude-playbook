# Prefer the Grep/Glob tools over Bash for discovery

**Rule: for a plain lookup (find files, search code, list a directory), reach for the Grep and Glob tools first.** Drop to a Bash pipeline when you genuinely need to transform results (count, dedup, sort, cross-file aggregation), not for a lookup a tool does directly.

Mapping:

- `find . -name '*-columns*.tsx'` → Glob `**/*-columns*.tsx`
- `grep -rn pattern src/` → Grep tool (`pattern`, `path: src/`)
- `grep -rln pattern` → Grep tool with `output_mode: "files_with_matches"`
- `ls some/dir` → Glob `some/dir/*` (or Read the directory)

**Why (the reason that survives the allow-shell-reads hook):** the hook auto-approves read-only Bash pipelines, so "it prompts" is no longer the reason. Bash discovery is now frictionless, which is exactly why it gets overused. The reasons that still hold are about cost and blast radius, not prompts:

- **Bounded output.** The Grep tool caps and structures results (`head_limit`, output modes, context lines); a bare `grep -rn` returns unbounded text that bloats context and tempts re-grepping. Unbounded output is the real token sink, not the choice of tool per se.
- **No detonation.** A Bash discovery call that hits an edge (a `$`-path, an odd flag) can be denied and take a whole parallel batch down with it (see [batch-safety-and-recovery.md](batch-safety-and-recovery.md)); the first-party tools have no such failure mode.

**When Bash is right:** genuine aggregation (`... | sort | uniq -c`, `xargs grep`, cross-file counts) and things the tools can't do (`git`, `make`, `gh`, running a script). "More efficient" is a real reason only when there's actual transformation; for a plain lookup it isn't. Keep each Bash call to one allowlist-matchable command (see [one-command-per-bash-call.md](one-command-per-bash-call.md)).

**Reading large payloads once:** when you do produce a big artifact (a Playwright snapshot or DOM, a long log), read it once with the Read tool (a line range or targeted slice) instead of re-grepping the same file repeatedly with tweaked patterns. Never dump full DOM via `browser_evaluate`; prefer `browser_snapshot` or a small, targeted evaluate. Repeated greps over the same large payload are a common, avoidable burn.
