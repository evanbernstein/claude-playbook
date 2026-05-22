# Never use Bash on paths containing `$`

**Rule: if a file path contains `$`, do not use Bash on it.** Use Read, Edit, Write, Grep, or Glob; they take paths directly and don't go through a shell. Quoting and backslash-escaping both still prompt; the only reliable fix is to bypass the shell entirely.

This affects React Router v7 dynamic segments (`$slug.tsx`, `$action.tsx`) and any other path with `$`. It covers every kind of operation: reading, editing, counting lines, counting matches, searching, listing, diffing-by-content. The first-party tools can do all of it.

**Verified behavior** (tested empirically with a typical `Bash(grep:*)` allowlist entry):

- `grep -n foo /tmp/plain.tsx`: runs unprompted.
- `grep -n foo '/tmp/$slug.tsx'`: prompts.
- `grep -n foo /tmp/\$slug.tsx`: prompts.
- `echo X; grep ...`: prompts, because the first token isn't `grep` and the allowlist match fails.

**Why "no Bash at all" rather than "avoid `$`":** The permission system pre-screens Bash command text for shell metacharacters. `$` is confirmed to prompt regardless of quoting. Others (`` ` ``, `$(...)`, `;`, `&&`, `||`, `|`, `>`, `<`) are likely to as well. Constructing a "clever" Bash command that avoids `$` by using a parent-dir glob or regex usually trips a different metacharacter. Skip the cleverness; use the tools that don't go through the shell.

**Rare cases where Bash really is needed:**

- `git` operations on a specific dynamic-segment file. Use the parent directory instead of naming the file: `git diff main -- apps/web/app/routes/songs/` rather than `... songs/$slug.tsx`. Accept the slightly broader output.
- Running a single specific test file. Use the parent dir + a test name filter, or add the literal command to `.claude/settings.local.json` (Claude Code only) for a permanent allowlist entry.
