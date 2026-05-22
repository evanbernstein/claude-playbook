# Keep your CLAUDE.md small

Every line of CLAUDE.md is loaded into Claude's context on every session. Context is a finite, valuable resource — every token spent on `CLAUDE.md` is a token unavailable for the actual task.

**Instruction:** CLAUDE.md should be roughly one screen of high-signal content, with links out to detailed files that Claude loads on demand.

**Why:**

- A long CLAUDE.md crowds out the user's actual problem. The longer the always-loaded instructions, the less attention each one gets.
- Most instructions don't apply to every task. An instruction about Prisma migrations is irrelevant when the user asks you to refactor a CSS file. Loading it anyway just adds noise.
- Context is paid for in latency, cost, and (sometimes) accuracy. Conserving it pays compounding dividends across the session.

**How to apply:**

1. **In the root CLAUDE.md, write the instruction headline and a one-sentence summary** — enough that Claude knows it exists and roughly what it means.
2. **Link to a detail file** for the *why* and the *how to apply*. Claude will read that file when the instruction is actually relevant.
3. **Group instructions under section headers** so it's scannable. Headers also let Claude quickly find the right one when something comes up.
4. **Stack-specific instructions** (e.g. Python `uv` conventions, React Router v7 quirks) go in their own files under `stacks/` and are linked from CLAUDE.md as conditional includes ("if the project uses X, also load…").

## The shape

```
# Project name

Two-sentence positioning of this CLAUDE.md.

## Group 1

- **Headline.** One-sentence summary. See [link/to/detail.md].
- **Headline.** One-sentence summary. See [link/to/detail.md].

## Group 2

- ...

## Stack-specific (load when relevant)

- React Router v7: [stacks/rrv7.md]
- Prisma: [stacks/prisma.md]
```

That's it. A CLAUDE.md that takes 60 seconds to read carries dozens of detail files behind it, loaded only when relevant. **Small front door, deep house.**
