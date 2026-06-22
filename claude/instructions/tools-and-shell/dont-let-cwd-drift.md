# Don't let the shell working directory drift

**Rule: the Bash working directory persists across tool calls. If you `cd` into a subdirectory in one call, every later call starts there too, until you `cd` back.** A repo-root command run from a drifted cwd fails confusingly.

**The failure mode:** an earlier `cd packages/core && ...` leaves cwd at `packages/core`. A later bare `make tc` (a root-level target) then dies with `make: *** No rule to make target 'tc'. Stop.` — which reads like the target doesn't exist, not like you're in the wrong directory. You can burn several calls chasing a phantom Makefile problem before noticing the cwd moved.

**So:**

- **Prefer not to `cd` at all.** Use the tool's own path flag — `make -C dir`, `git -C dir`, `bun --cwd dir`, absolute paths. cwd never moves, so nothing downstream breaks. (Same lever as [one-command-per-bash-call.md](one-command-per-bash-call.md)'s atomic-`cd` exception.)
- **If you must `cd`, scope it to that one call** as `cd dir && cmd` (the playbook already allows a standalone or atomic `cd`), so cwd is unchanged for the next call.
- **When a root-level command fails with "No rule to make target" / "no such file" and you've `cd`'d earlier this session, suspect cwd drift first.** Run `pwd`, then `cd` back to the repo root in a standalone call before retrying. Don't re-debug the target.

**Why a standalone `cd` is the safe form:** a bare `cd /path` (or `cd /path && cmd`) is shell-safe and doesn't trip the dollar-path hook ([no-bash-on-dollar-paths.md](no-bash-on-dollar-paths.md)); the thing to avoid is letting an earlier directory change silently outlive the call that needed it.
