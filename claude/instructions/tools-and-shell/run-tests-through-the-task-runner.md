# Run tests through the task runner, not the test file

**Rule: to run a project's tests, invoke its task-runner target (`make test`, `just test`, `npm test`, `bun test`, `uv run pytest`), not the test file directly (`bash path/to/x.test.sh`, `./x.test.sh`, or piping into the script under test).**

**Why:** the task-runner targets are on the allowlist (`Bash(make test:*)`, `Bash(just test:*)`, `Bash(bun test:*)`, ...), so they auto-approve. *Executing a script directly never can* — running an arbitrary `.sh`/`.py` is not provably read-only, so the allow-shell-reads hook correctly falls through to a permission prompt every time. Same for piping a payload into the program under test (`... | ./hook.sh`): that *runs* the script and prompts. So the direct invocation is both more prompt-prone and easy to get wrong (wrong working directory, wrong interpreter, missing the harness's setup).

Before running tests, look for the target:

- `grep -nE '^[a-zA-Z_-]+:' Makefile` → use `make <target>`
- `just --list` / a `justfile` → use `just <target>`
- `package.json` `scripts` → use `npm run` / `bun run` (or `bun test`)

In the playbook repo specifically, the shell-hook suites run via **`make test`** (see [the Makefile](../../../Makefile)), which loops over every `claude/**/*.test.sh`. Use that; do not `bash claude/hooks/foo.test.sh` or pipe JSON into `allow-shell-reads.sh` to "spot-check" it — both prompt. Add a one-off case to the `.test.sh` and run `make test` instead.

If a project genuinely has no task-runner target for the tests, that's the signal to add one (and allowlist it), not to keep executing the file directly. See [durable-fixes-not-promises.md](../working-style/durable-fixes-not-promises.md).
