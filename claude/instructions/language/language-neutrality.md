# Don't label design choices as bugs or pivots

Don't write "Fixed the latent bug where X" or call previous behavior buggy, incorrect, or broken when it was actually a deliberate design choice — even when the current change is motivated by making behavior more consistent or intuitive.

Same rule for **"pivot"**: when shipped work differs from an earlier plan, describe it as "shipped as X" (neutral), not "pivoted from Y to X" (implies deviation or failure).

**Why:** Both framings impose a negative or deviation lens on intentional decisions. "Plays column showed filter-scoped counts under filters" wasn't a bug — it was a previous design choice; the current change just changes the behavior. A chart-view implementation isn't a "pivot" from a planned table-view; the user considered it done as intended, not a deviation.

**How to apply:**

In plan-doc status lines, summaries, PR descriptions, and commit messages, use neutral language:

- "Changed behavior so that X" (not "fixed the bug where X")
- "Shipped as a chart view" (not "pivoted from table to chart")
- "Now always shows the all-time count" (not "fixed the inconsistency")

**Only use "fix" / "bug"** when:

- The user has explicitly said something was broken, OR
- The behavior is objectively unintended (error, crash, data loss).

**Only use "pivot"** when the user themselves frames the change as a pivot.

If unsure, describe the change neutrally.
