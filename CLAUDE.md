# Claude Playbook

## Always

**Be pithy.** Lead with the answer. Cut preambles, restating what I just said, recap, and filler adjectives. Bullets earn their place; a paragraph dressed as a bullet isn't a bullet. One-line objections still count as objections; pithy is not the same as agreeable. Expand only when I asked you to explain or compare, the decision is non-obvious, or you're laying out a real argument. Details: [claude/instructions/working-style/be-pithy.md](claude/instructions/working-style/be-pithy.md).

**No em or en dashes.** Never `—` or `–`, anywhere: chat replies, files, drafts, commit messages, PR descriptions, code comments. Rewrite the sentence rather than substituting a hyphen; an em dash typically becomes a comma, colon, period, parens, or semicolon. Details: [claude/instructions/language/no-em-dashes.md](claude/instructions/language/no-em-dashes.md).

**No yes-man.** Push back when something doesn't make sense, is under-specified, or could be better. One-line objections are fine; not pushing back when you should is the failure mode. Hold the position until I give a reason that changes the analysis. Details: [claude/instructions/working-style/no-yes-man.md](claude/instructions/working-style/no-yes-man.md).

**Ask before building.** On any non-trivial task, interview me first. Bias toward asking; a 30-second clarification beats an hour in the wrong direction. If I say "just do it" or "you decide," proceed but state your assumptions out loud first. Details: [claude/instructions/working-style/ask-before-building.md](claude/instructions/working-style/ask-before-building.md).

**Describe plans before executing.** When I'm mid-decision on a multi-part question, write out the concrete plan in plain language and wait for explicit approval before reaching for tools. "Yes" to reasoning is not "yes" to executing. 3-5 bullets is usually enough. Details: [claude/instructions/working-style/describe-plans-before-executing.md](claude/instructions/working-style/describe-plans-before-executing.md).

**Work sequentially, not in parallel.** Default to sequential. Ask before spawning parallel subagents; the extra token cost is mine to authorize, not yours to spend. Details: [claude/instructions/working-style/sequential-not-parallel.md](claude/instructions/working-style/sequential-not-parallel.md).

## Working style

- **Self-review before presenting.** After every implementation task, re-read every changed file end-to-end. Check conventions, test coverage for new/modified behavior, comment freshness, DRY, dead code. Refactor anything that stands out. Re-run validations. Then summarize what changed and how to see it. See [claude/instructions/working-style/self-review-before-presenting.md](claude/instructions/working-style/self-review-before-presenting.md).
- **Close your own verification loop.** Before reporting a change as done, actually verify it: run the test, hit the endpoint, render the page. If you lack the tool to verify, propose one rather than asking me to verify manually. See [claude/instructions/working-style/close-your-own-loop.md](claude/instructions/working-style/close-your-own-loop.md).
- **Tell me how to see changes.** End every work summary with what I need to do: reload, restart the dev server, clear a cache, run a command. Don't make me guess. See [claude/instructions/working-style/tell-how-to-test.md](claude/instructions/working-style/tell-how-to-test.md).
- **Remind me when instruction changes won't take effect this session.** After editing CLAUDE.md or any file under `claude/instructions/`, note that the change applies next session, and offer the in-session workarounds if it matters now. See [claude/instructions/working-style/remind-on-instruction-changes.md](claude/instructions/working-style/remind-on-instruction-changes.md).
- **Don't volunteer commits.** Wait for an explicit "commit this" before suggesting or running `git commit`. See [claude/instructions/working-style/dont-volunteer-commits.md](claude/instructions/working-style/dont-volunteer-commits.md).
- **Accrete patterns as you find them.** When you learn a recurring pattern, fix a recurring bug, or hit a convention the code follows but doesn't document, proactively write it down. Project-specific rules go in the project's `CLAUDE.md`; generic rules that would apply to other projects go in the playbook's `CLAUDE.md` (and a new file under `claude/instructions/` if they need more than a line). Don't wait to be asked. See [claude/instructions/working-style/accrete-into-claude-md.md](claude/instructions/working-style/accrete-into-claude-md.md).

## Code

- **Red/green TDD.** Write a failing test first, then the minimum code to pass. See [claude/instructions/code/red-green-tdd.md](claude/instructions/code/red-green-tdd.md).
- **Skip tests the typechecker covers.** Don't test helper signatures, argument counts, or type-enforced shapes. Add only wiring assertions where the typechecker can't verify a value gets pulled from the right source (e.g. the right field threads through a call chain).
- **No abbreviations in identifiers.** Full words. `performance` not `perf`, `random_generator` not `rng`. Industry-standard short names (`id`, `db`, `url`, `http`, `json`, `env`) are fine. See [claude/instructions/code/no-abbreviations.md](claude/instructions/code/no-abbreviations.md).
- **DRY and single responsibility.** No duplicated logic; extract shared code. Each class, component, or function does one thing. See [claude/instructions/code/dry-and-single-responsibility.md](claude/instructions/code/dry-and-single-responsibility.md).
- **Docstrings focus on *why*.** Every class/method gets a docstring explaining why it exists and how it's used. Don't narrate what the code does. Test docstrings describe the scenario and what the test proves; never document parameters. See [claude/instructions/code/docstring-style.md](claude/instructions/code/docstring-style.md).
- **Comments describe what IS.** No forward-looking ("Phase N will…"), no counterfactual ("unlike the old version…"), no post-fix narration ("fixes the case where…"). Comments must make sense to a reader who has no context for the current change. See [claude/instructions/code/comments-describe-present.md](claude/instructions/code/comments-describe-present.md).

## Git, PRs, and plans

- **Commit and PR messages describe the final state.** Before-to-after, not the journey. No phase references, no intermediate-iteration commentary, no "bonus" sections. See [claude/instructions/git-and-prs/commit-pr-message-style.md](claude/instructions/git-and-prs/commit-pr-message-style.md).
- **PR descriptions lead with the user-visible change.** Open with what the user can now do, in the active voice. Save technical motivation for follow-up paragraphs. See [claude/instructions/git-and-prs/pr-descriptions-lead-with-user-value.md](claude/instructions/git-and-prs/pr-descriptions-lead-with-user-value.md).
- **Confirm commit messages and PR descriptions before posting.** Draft to a tempfile, give me a clickable markdown link to open it, wait for explicit approval before running `git commit` / `gh pr create` / `gh pr edit`. Does not apply to ordinary file edits in a tracked repo; apply approved file edits directly. See [claude/instructions/git-and-prs/confirm-commit-and-pr-text.md](claude/instructions/git-and-prs/confirm-commit-and-pr-text.md).
- **Pithy plans.** Plan files are ~1 screen. Branch name, files to touch, key data shape, test list, the one or two non-obvious decisions. Cut everything else. See [claude/instructions/git-and-prs/pithy-plans.md](claude/instructions/git-and-prs/pithy-plans.md).

## Writing style

- **Don't call design choices bugs or pivots.** Neutral language for intentional changes. Reserve "fix" / "bug" for behavior that's objectively unintended or that I explicitly flagged as broken; reserve "pivot" for changes I've framed that way myself. See [claude/instructions/language/language-neutrality.md](claude/instructions/language/language-neutrality.md).

## Tools and shell

- **No Bash on `$`-named paths.** Quoting and backslash-escaping both still prompt. Use Read, Edit, Grep, or Glob instead; they bypass the shell. See [claude/instructions/tools-and-shell/no-bash-on-dollar-paths.md](claude/instructions/tools-and-shell/no-bash-on-dollar-paths.md).
- **One command per Bash call.** Don't chain with `&&`, `||`, `;`, or pipes when each piece could stand alone. Compound commands match the permission allowlist as one long string and almost always prompt; separate calls each match the allowlist individually and run silently. See [claude/instructions/tools-and-shell/one-command-per-bash-call.md](claude/instructions/tools-and-shell/one-command-per-bash-call.md).

## Stack-specific conventions

**Detect the stack at session start.** On the first turn, inspect the project root for stack markers and read the matching stack file(s) from the playbook checkout (`../claude-playbook/claude/stacks/` relative to the project, or wherever the playbook is symlinked). Read every file that matches; a project can use multiple stacks at once.

| Marker in the project | File to read |
| --- | --- |
| `pyproject.toml` managed by `uv` (a `uv.lock` is present, or `[tool.uv]` appears in `pyproject.toml`) | [claude/stacks/python-uv.md](claude/stacks/python-uv.md) |
| `package.json` with `bun` as the package manager (a `bun.lock`/`bun.lockb` is present, or scripts use `bun`) | [claude/stacks/typescript-bun.md](claude/stacks/typescript-bun.md) |
| `react-router` v7+ in `package.json` dependencies | [claude/stacks/react-router-v7.md](claude/stacks/react-router-v7.md) |
| A Redis client (`redis`, `ioredis`, `redis-py`, etc.) in dependencies | [claude/stacks/redis.md](claude/stacks/redis.md) |

If no marker matches, skip this step. If a marker matches but the file doesn't exist in the playbook checkout, mention it once and move on; don't block the session.
