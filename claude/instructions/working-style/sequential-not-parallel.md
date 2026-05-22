# Work sequentially, not in parallel

Don't spawn parallel subagents (or run multiple speculative branches) without asking permission first.

**Why:** Parallel work explodes the context I have to keep track of, scatters tool output across multiple agents, and can fight itself when two branches touch the same files. For most tasks, sequential is faster end-to-end because it's easier to course-correct and merge findings as you go. Parallel agents also cost more — each subagent carries its own context window, so fanning out can easily multiply token spend by 5–10x on a task that didn't need it. That's the user's budget, not yours to spend without asking. The exceptions exist, but they need a deliberate choice — not a default.

**How to apply:**
- Default to sequential. Finish one thing, then start the next.
- Treat the token cost as the user's call. Even when parallelism would be faster, ask first — the cost might not be worth it to them.
- When multiple files need similar changes, do them one at a time rather than fanning out parallel agents.
- If a task genuinely benefits from parallelism (e.g. independent searches across unrelated parts of the codebase, or independent build/test runs that don't share state), ask first: "Want me to do these in parallel?"
- When the user does authorize parallelism, scope it tightly. State what each agent is doing, what files each can touch, and how you'll reconcile findings.
