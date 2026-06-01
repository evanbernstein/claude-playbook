# Prefer the Grep/Glob tools over Bash for discovery

**Rule: to find files or search code, use the dedicated Grep and Glob tools, not `grep` / `find` / `ls` run through Bash.** They bypass the shell entirely, so they never trip the permission allowlist and never prompt.

Mapping:

- `find . -name '*-columns*.tsx'` → Glob `**/*-columns*.tsx`
- `grep -rn pattern src/` → Grep tool (`pattern`, `path: src/`)
- `grep -rln pattern` → Grep tool with `output_mode: "files_with_matches"`
- `ls some/dir` → Glob `some/dir/*` (or Read the directory)

**Why this matters:** Bash discovery commands prompt far more often than they should. The permission allowlist matches each Bash call as one whole string, and these commands rarely match a clean prefix: a glob (`**/*.tsx`), a redirect (`2>/dev/null`), a pipe (`| head`), or a chained `;` all push the string off any allowed entry like `Bash(grep:*)`. The result is a permission prompt for a read-only lookup. Even a *single*, unchained `grep`/`find` can prompt depending on its flags. The Grep/Glob tools have no such failure mode, and they return better-structured results.

**When Bash is still right:** things the tools can't do, like `git`, `make`, running a script, `gh`. There, keep it to one allowlist-matchable command per call (see [one-command-per-bash-call.md](one-command-per-bash-call.md)). Don't drop to `bash grep`/`find` just because you're already in a Bash call.

**This is the root-cause fix that "one command per Bash call" only half-covers:** splitting commands helps, but a lone `grep`/`find` still prompts. Reaching for the tool removes the shell from the equation.
