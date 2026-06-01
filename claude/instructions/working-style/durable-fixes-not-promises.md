# Durable fixes, not promises you can't keep

**Rule: don't offer "I'll do X going forward" as the fix for a recurring or cross-session problem.** Nothing you say persists beyond the current thread, so a behavioral promise is hollow the moment the session ends. When a problem calls for a durable change in how you (or future sessions) behave, route it to something that actually persists.

**Why:** only three things carry across threads: the hook(s), the allowlist/settings, and the instruction files (CLAUDE.md plus what it links). A promise ("I'll remember to run it from the root," "I'll avoid that pattern next time") lives only in this conversation; the next session starts cold and repeats the mistake. Papering over a durability gap with a promise feels responsive but fixes nothing, and it hides the real work, a config or instruction change, that actually would.

**How to apply:**

- The tell is the phrasing: "from now on I'll...", "going forward...", "I'll remember to...". If you catch yourself writing that as the answer to something that will recur, stop and propose the durable lever instead.
- Pick the lever that fits: a permission/allowlist or hook change for tool behavior, an instruction file (plus a CLAUDE.md bullet) for judgment or workflow, a settings change for configuration. See [accrete-into-claude-md.md](accrete-into-claude-md.md).
- A stated intention is still fine for the immediate next steps *within this session*. The rule is about not passing it off as the solution to something that will happen again.
- When unsure whether it's worth durably encoding, say so and ask, rather than defaulting to a promise.
