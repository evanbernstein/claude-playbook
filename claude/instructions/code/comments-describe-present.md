# Comments describe what IS, not what was or what will be

Code comments describe **what the code is and does today** — not what a future phase will do, and not how today's code differs from a previous or counterfactual version. Both variants are noise:

- They go stale immediately when plans shift.
- A reader who isn't in the current planning conversation has no idea what "Phase 8" or "the songs-table unification project" means.
- They create invisible coupling between code and ephemeral planning docs.

**Why:** "Phase 8's tag-count SQL must use the same definition" is meaningful right now to me and you, but a future contributor has no context for it. The reference will outlive the project documentation it points to.

**How to apply:**

- Write comments that describe the code's current behavior, invariants, and rationale.
- Explaining *why* the code is the way it is = good. ("This runs first because X short-circuits Y.")
- Explaining *what future work might want to do* = bad. No `TODO`, no "if we ever…", no "consider X someday". If a forward-looking thought is worth preserving, it goes in a ticket or design doc — not a code comment.
- Explaining *how the new code differs from an older / never-shipped version* = bad. If a refactor moved label-building from a card to a loader, the loader's comment should justify its current shape on its own terms, not say "labels are built here (not in the card)". The reader sees only what shipped; the counterfactual is invisible.
- TDD gates / `test.skip` blocks are an exception **if** the comment is pinned to a ticket/issue link, not a phase name. "Pending `meta.width` implementation, see #123" — fine.
- Commit messages and PR descriptions are fine places for forward references — they're ephemeral and time-stamped.
- Project plans in your planning docs and memory files can reference phases freely — they're planning docs.

## Post-fix narration is the same anti-pattern

When you write a comment immediately after fixing a bug, the framing trap is *describing the fix*. Don't. The comment should read as if the code had always been this way.

Anti-patterns to refuse, especially in test comments:

- "Re-rating regression: when X happens, Y should Z." → just say "Y is Z when X."
- "Without this, [behavior]." → just describe what the code currently guarantees.
- "Fixes the case where…" / "Used to do X, now does Y." → describe what it does.
- "Captures the fix for…" / "Regression test for #1234." → describe the invariant the test pins.

**Self-check before writing any comment:** if I delete the bug context, does the comment still make sense as a description of what the code does? If not, rewrite it.

Apply this at write time, not review time.
