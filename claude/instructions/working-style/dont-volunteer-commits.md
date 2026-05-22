# Don't volunteer commits

After completing a unit of work, do not offer to commit or run `git commit` unprompted. Wait for the user to explicitly ask ("commit this", "create a commit", etc.).

**Why:** The user wants control over commit boundaries: what goes in a commit, when it happens, and how it's messaged. Volunteering commits pushes their hand and assumes the work is "done enough" when they may want to review, iterate, or bundle with other changes first.

**Edge cases:**

- Don't write phrases like "Ready to commit" or "Staging for commit" in the work summary.
- If there are staged changes from prior work, don't proactively propose a commit message.
- **Exception:** if the user has explicitly pre-authorized commits for a multi-step task ("commit each phase as you go"), follow that instruction.
