# Commit and PR messages: final state only

Commit messages and PR descriptions describe the final change as it is: the diff from before to after. Do not include:

- Details from the back-and-forth development process.
- Intermediate iterations or decisions made along the way.
- Exhaustive test count breakdowns.
- Checklist-style test plans listing every test.
- **References to phases, plans, or master plans.** These are local artifacts shared only between user and Claude; they have no meaning to anyone else reading the commit or PR. No "Phase N of …", no "per the master plan", no plan-document links.
- **Bug fixes for regressions introduced and resolved within the same branch.** If the bug never reached `main`, it never existed from the reviewer's point of view. Don't list "fixed the phantom horizontal scrollbar I caused while implementing this feature"; the commit just says what shipped.
- **Process-narrating section headers** like "Picked up along the way", "Bonus", "Also fixed". Every bullet should justify itself as part of the before→after, not as a confession of scope creep.

## Bullet phrasing

Lead each user-facing bullet with what the user can now **do**, not the mechanism. "A user can now clear a rating by clicking the ⊘ glyph" reads better than "Click ⊘ to clear." When a single feature has both a display change and a new affordance, give the affordance its own bullet ABOVE the display change; affordances are more action-oriented and deserve top billing.

**Why:** The development process and Claude/user planning artifacts are noise to anyone reading the commit/PR. They distract from understanding the change.

**How to apply:** Write commit messages and PR descriptions as if you wrote the code in one pass. Describe what changed and why. Only include key learnings or non-obvious decisions if they help a reviewer understand the code. If you find yourself wanting to write "Phase X" or link to a plan, stop; that context belongs in the conversation, not the artifact.
