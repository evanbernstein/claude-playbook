# Claude Playbook

## Working style

- **No yes-man.** Push back when an idea has problems, is under-specified, or could be better. See [claude/instructions/working-style/no-yes-man.md](claude/instructions/working-style/no-yes-man.md).
- **Ask before building.** On any non-trivial task, interview me first — one question at a time. Don't run off and execute until we've aligned on what I actually need. See [claude/instructions/working-style/ask-before-building.md](claude/instructions/working-style/ask-before-building.md).
- **Describe plans before executing.** When I'm mid-decision on a multi-part question, write out the concrete plan in plain language and wait for explicit approval before reaching for tools. "Yes" to reasoning is not "yes" to executing. See [claude/instructions/working-style/describe-plans-before-executing.md](claude/instructions/working-style/describe-plans-before-executing.md).
- **Self-review before presenting.** After every implementation task, re-read every changed file end-to-end. Check conventions, test coverage for new/modified behavior, comment freshness, DRY, dead code. Refactor anything that stands out. Re-run validations. Then summarize what changed and how to see it. See [claude/instructions/working-style/self-review-before-presenting.md](claude/instructions/working-style/self-review-before-presenting.md).
- **Close your own verification loop.** Before reporting a change as done, actually verify it — run the test, hit the endpoint, render the page. If you lack the tool to verify, propose one rather than asking me to verify manually. See [claude/instructions/working-style/close-your-own-loop.md](claude/instructions/working-style/close-your-own-loop.md).
- **Tell me how to see changes.** End every work summary with what I need to do — reload, restart the dev server, clear a cache, run a command. Don't make me guess. See [claude/instructions/working-style/tell-how-to-test.md](claude/instructions/working-style/tell-how-to-test.md).
- **Remind me when instruction changes won't take effect this session.** After editing CLAUDE.md or any file under `claude/instructions/`, note that the change applies next session, and offer the in-session workarounds if it matters now. See [claude/instructions/working-style/remind-on-instruction-changes.md](claude/instructions/working-style/remind-on-instruction-changes.md).
- **Don't volunteer commits.** Wait for an explicit "commit this" before suggesting or running `git commit`. See [claude/instructions/working-style/dont-volunteer-commits.md](claude/instructions/working-style/dont-volunteer-commits.md).
- **Work sequentially, not in parallel.** Don't spawn parallel subagents without asking permission first. See [claude/instructions/working-style/sequential-not-parallel.md](claude/instructions/working-style/sequential-not-parallel.md).
- **Default to pithy.** Short and to the point. Lead with the answer, cut preambles and recap, expand only when the topic requires it or I ask. See [claude/instructions/working-style/be-pithy.md](claude/instructions/working-style/be-pithy.md).

## Code

- **Red/green TDD.** Write a failing test first, then the minimum code to pass. See [claude/instructions/code/red-green-tdd.md](claude/instructions/code/red-green-tdd.md).
- **No abbreviations in identifiers.** Full words. `performance` not `perf`, `random_generator` not `rng`. Industry-standard short names (`id`, `db`, `url`, `http`, `json`, `env`) are fine. See [claude/instructions/code/no-abbreviations.md](claude/instructions/code/no-abbreviations.md).
- **DRY and single responsibility.** No duplicated logic — extract shared code. Each class/component/function does one thing. See [claude/instructions/code/dry-and-single-responsibility.md](claude/instructions/code/dry-and-single-responsibility.md).
- **Docstrings focus on *why*.** Every class/method gets a docstring explaining why it exists and how it's used. Don't narrate what the code does. Test docstrings describe the scenario and what the test proves — never document parameters. See [claude/instructions/code/docstring-style.md](claude/instructions/code/docstring-style.md).
- **Comments describe what IS.** No forward-looking ("Phase N will…"), no counterfactual ("unlike the old version…"), no post-fix narration ("fixes the case where…"). Comments must make sense to a reader who has no context for the current change. See [claude/instructions/code/comments-describe-present.md](claude/instructions/code/comments-describe-present.md).

## Git, PRs, and plans

- **Commit and PR messages describe the final state.** Before→after, not the journey. No phase references, no intermediate-iteration commentary, no "bonus" sections. See [claude/instructions/git-and-prs/commit-pr-message-style.md](claude/instructions/git-and-prs/commit-pr-message-style.md).
- **PR descriptions lead with the user-visible change.** Open with what the user can now do, in the active voice. Save technical motivation for follow-up paragraphs. See [claude/instructions/git-and-prs/pr-descriptions-lead-with-user-value.md](claude/instructions/git-and-prs/pr-descriptions-lead-with-user-value.md).
- **Confirm commit messages and PR descriptions before posting.** Draft to a tempfile, point me at the path, wait for explicit approval before running `git commit` / `gh pr create` / `gh pr edit`. See [claude/instructions/git-and-prs/confirm-commit-and-pr-text.md](claude/instructions/git-and-prs/confirm-commit-and-pr-text.md).
- **Pithy plans.** Plan files are ~1 screen. Branch name, files to touch, key data shape, test list, the one or two non-obvious decisions. Cut everything else. See [claude/instructions/git-and-prs/pithy-plans.md](claude/instructions/git-and-prs/pithy-plans.md).

## Writing style

- **Don't call design choices bugs.** Neutral language for intentional changes. Reserve "fix" / "bug" / "pivot" for behavior the user explicitly framed that way. See [claude/instructions/language/language-neutrality.md](claude/instructions/language/language-neutrality.md).
- **No em dashes.** Never use `—` or `–`, anywhere. Rewrite the sentence (comma, colon, period) instead of substituting a hyphen. See [claude/instructions/language/no-em-dashes.md](claude/instructions/language/no-em-dashes.md).

## Tools and shell

- **No Bash on `$`-named paths.** Quoting and backslash-escaping both still prompt. Use Read / Edit / Grep / Glob instead — they bypass the shell. See [claude/instructions/tools-and-shell/no-bash-on-dollar-paths.md](claude/instructions/tools-and-shell/no-bash-on-dollar-paths.md).

## Stack-specific conventions

If the project uses these stacks, also load:

- Python with `uv` and `ruff`: [claude/stacks/python-uv.md](claude/stacks/python-uv.md)
- TypeScript with Bun and Biome: [claude/stacks/typescript-bun.md](claude/stacks/typescript-bun.md)
- React Router v7: [claude/stacks/react-router-v7.md](claude/stacks/react-router-v7.md)
- Redis: [claude/stacks/redis.md](claude/stacks/redis.md)
