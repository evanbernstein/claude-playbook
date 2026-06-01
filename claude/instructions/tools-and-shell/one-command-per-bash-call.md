# One command per Bash call

**Rule: for any command that isn't an auto-approved read, don't chain with `&&`, `||`, `;`, or pipes when each piece could stand alone.** Issue those as separate Bash tool calls.

**Why, and where the hook changed it:** the `allow-shell-reads.sh` hook validates every segment of a chain, so read-only chains and pipelines now auto-approve as one call: `cat a && cat b` and `git -C /x status && git -C /y status` run unprompted, and splitting them is optional. The rule still bites for commands the hook does **not** approve (writes, commits, anything non-read). Those fall back to the prefix-matched allowlist, and a chain like `git commit -m x && git push` matches no single allow entry as a whole string, so it prompts. Worse, a chained write that prompts or fails takes the rest of the chain down with it (the intra-call version of [batch-safety-and-recovery.md](batch-safety-and-recovery.md)).

**So:**

- Genuine read-only pipeline (`... | sort | uniq -c`, `find | xargs grep`): fine as one call; the hook approves it.
- Approval-gated or write commands: one per Bash call. Don't chain `git commit`, `git push`, `gh pr create`, formats, installs.
- Never chain just to save round-trips; round-trips are cheap, prompts and half-applied chains are not.

**The exception that proves the rule:** when operations must be atomic (`cd dir && command`), prefer the tool's own path argument (`git -C dir`, `make -C dir`, `--cwd`) over `cd && ...`. Almost every common tool has one.
