# One command per Bash call

**Rule: don't chain shell commands with `&&`, `||`, `;`, or pipes when each piece could stand alone.** Issue them as separate Bash tool calls. Compound commands match Claude Code's permission allowlist as a single long string; separate calls each match the allowlist individually.

**Why this matters:** A pattern like `Bash(git status:*)` is prefix-matched against the literal command. `git status` matches. `git -C /repo status && echo "---" && git -C /other status` does not, because the command doesn't start with `git status` and doesn't match any other allow entry as a whole-string. The result is a permission prompt for what should be three auto-allowed operations.

**Verified behavior** (with a typical read-only allowlist):

- `git status` in two Bash calls: both run unprompted.
- `git -C /a status && git -C /b status`: prompts, even with `Bash(git -C * status:*)` allowed, because the `&&` keeps the whole string from matching either alternative.
- `cat file1 && cat file2`: prompts. Two separate `cat` calls do not.

**When chaining is fine:** real pipelines where the second command depends on the first's stdout, like `git log --format=%H | head -5` or `find . -name '*.ts' | xargs wc -l`. The allowlist can cover these with explicit entries (`Bash(xargs cat:*)`, etc.). Don't reach for `&&` just to save round-trips; the round-trips are cheap and the prompts are not.

**The exception that proves the rule:** if the operations genuinely must be atomic (e.g., `cd dir && command` where the `cd` must apply to the command), prefer the tool's own path argument (`git -C dir`, `make -C dir`, `--cwd`, etc.) over `cd && ...`. Almost every common tool has one.
