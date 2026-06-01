# No Bash on unquoted `$`-paths

**Rule: never run Bash on an *unquoted* `$`-path** (React Router dynamic segments like `$slug.tsx`, `$action.tsx`). Unquoted, the shell expands `$slug` to nothing and the command silently reads the **wrong** file. For reading, editing, or searching, use Read/Edit/Grep/Glob: they take the path directly, with no shell and no `$` to get wrong.

**Verified behavior.** What the *shell* does with the path and what the `allow-shell-reads.sh` hook decides are independent. Tested empirically with a real file named `$slug.test.tsx`, `eval`-ing each form and piping each to the hook (with a read-only command, `cat`):

| Form | Shell expansion | Hook verdict |
| --- | --- | --- |
| unquoted `$slug.test.tsx` | expands to empty, reads the **wrong** path | deny |
| double-quoted, escaped `"\$slug.test.tsx"` | literal `$`, reads the real file | allow |
| single-quoted `'$slug.test.tsx'` | literal `$`, reads the real file | allow |
| no `$` (`plain.test.tsx`) | reads the real file | allow |

So only the **unquoted** form is the footgun; single-quoted and `\$`-escaped forms are shell-safe. The hook denies only the expanding case (unquoted, or double-quoted without a `\`). For a non-read command (a test or build run), a quoted `$`-path is not denied either, but it falls through to a single prompt rather than an auto-allow.

**In practice:**

- Reading/searching a `$`-path: use Read/Grep/Glob. No prompt, nothing to quote.
- A non-read command on a `$`-path (a `git` op, one test file): single-quote the path (shell-safe), and to skip the one prompt, target the parent directory or add the literal command to `.claude/settings.local.json`:
  - `git diff main -- apps/web/app/routes/songs/` rather than `... songs/$slug.tsx`.
  - a test run scoped to the parent dir plus a test-name filter.
