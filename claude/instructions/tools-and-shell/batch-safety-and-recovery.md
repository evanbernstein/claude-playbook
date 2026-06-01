# Batch safety and recovery

**Rule: only put calls in one parallel block when every one of them is read-only and already auto-approved. Never batch a call that writes, formats, commits, pushes, opens a PR, or could otherwise prompt or be denied.** When a batch is cancelled, reissue serially; never blind re-run it.

**Why:** when several tool calls are issued in one block and any one of them is denied, prompts, or fails, the harness cancels *every* sibling call in that block (`Cancelled: parallel tool call ... errored`). One bad call throws away all the good ones. The expensive part is what comes next: re-running the cancelled work (often re-batched with the same bad call, so it cancels again), plus reconciling a tree left half-applied when some cancelled siblings were writes. A single denial this way has burned a large fraction of a session. The trigger is not special: a `$`-path deny, an approval-gated write, or a failing command all detonate the batch identically. Issued alone, the bad call costs exactly one call.

**How to apply:**
- Batch freely for pure reads that already auto-approve (Grep/Glob/Read, read-only shell pipelines). That is what parallelism is for.
- Issue anything that mutates or could prompt **on its own**: writes/formats, `git commit`/`push`, `gh pr create`, a `$`-path command, a test/build that isn't allowlisted. Don't garnish it with sibling calls.
- The commit -> push -> PR sequence is always serial (and gated by the confirm-commit rule), never batched.
- When a batch comes back cancelled, **stop and read what actually failed**. Reissue only the still-needed calls, one at a time. Do not re-fire the whole block on reflex.
- Trust the first result. If output looks truncated or stale, narrow the query (or read a specific range), don't re-run the same command hoping for different output.

This is the batching counterpart to [sequential-not-parallel.md](../working-style/sequential-not-parallel.md) (which governs subagents) and [one-command-per-bash-call.md](one-command-per-bash-call.md) (which governs a single Bash call's contents).
