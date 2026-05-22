# Self-review before presenting, with a change summary

After every implementation task, no matter how small, do a self-review pass before presenting the work. Then present a concise summary that tells the user what changed and how to see it.

**Why:** A disciplined pre-present review catches stale code, uncovered behavior, copy-paste duplication, and comments that describe vanished code in seconds. Skipping it burns a round-trip. The user also wants to see the diff described in plain terms; they should not have to read the diff to learn what landed.

**Re-read every changed file end to end.** List every file touched (`git status`, `git diff --stat`). Open each one and check:

- **Conventions.** Does it follow root `CLAUDE.md` and any per-package `CLAUDE.md`? Formatting, naming, structure, file placement.
- **Tests.** Does every new or modified behavior have a unit test? Added a prop, branch, helper, or edge case without a test → write one now. Modified behavior without updating the corresponding test → update it now. "The existing tests still pass" is not enough; the new behavior must be covered.
- **Comments describe current code.** Strip comments that describe what the code *used to be*, what a *future phase* will do, or how this differs from a *never-shipped* version. Every remaining comment must describe what the code *is and does today*.
- **DRY.** Look for duplication introduced by this change: two copies of the same branch, near-identical blocks in sibling files, repeated conditionals, copy-pasted fixture setup. If the same logic appears twice, extract it. Applies to production code *and* tests.
- **Dead code.** Remove anything this change orphaned: unused imports, unused params, abandoned branches, vestigial hooks.

**Refactor anything that stands out** in the same unit of work. Don't defer cleanup.

**Re-run validations** after refactoring: the project's typecheck, test, and lint commands. Format only the files you touched. The cleanup itself can introduce regressions; verify.

**End the turn with a clear summary:**

- **What changed:** bullet list of the concrete changes (file: what + why), in plain English. Not a changelog of every edit; the shape and intent of the final diff.
- **How to test:** what to run to see the change. Include the specific URL / command, the golden path to click through, and any cache clears or restarts required.

Only after that summary is the task "done."
