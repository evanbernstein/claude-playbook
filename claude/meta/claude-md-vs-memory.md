# CLAUDE.md vs memory vs skills: when to use what

Claude offers a few different mechanisms for persisting context across conversations. They serve different purposes; mixing them up is a common mistake.

## The three mechanisms

### 1. CLAUDE.md (project-level instructions)

A markdown file at the root of a project that's automatically loaded into every Claude conversation about that project.

- **Lives in:** `<project-root>/CLAUDE.md` (and optionally nested, e.g. `<project-root>/apps/web/CLAUDE.md` for sub-package conventions).
- **Visibility:** Checked into the repo. Travels with the project. Same on every machine and every collaborator.
- **Use for:** Project-specific conventions, build commands, architectural instructions, naming conventions, dependency management; anything that should apply consistently when working on this project, regardless of who's at the keyboard.

### 2. ~/.claude/CLAUDE.md (user-level instructions)

A markdown file in your home directory that's automatically loaded into every Claude conversation, regardless of which project.

- **Lives in:** `~/.claude/CLAUDE.md`.
- **Visibility:** Local to your machine. Not committed anywhere by default.
- **Use for:** Personal preferences that span all your work: tone, working style, things like "ask clarifying questions before building" or "don't be a yes-man".

### 3. Memory system (`~/.claude/projects/<encoded-project-path>/memory/`)

Files that Claude writes and reads automatically based on the project you're in.

- **Lives in:** `~/.claude/projects/-Users-you-Programming-yourproject/memory/MEMORY.md` and adjacent files.
- **Visibility:** Local to your machine. Not committed.
- **Use for:** Things that genuinely can't go in the repo: cross-project context, references to external systems, user-profile info, active-but-unshipped project plans, transient lessons from sessions.

### 4. Skills

Reusable, self-contained packages that bundle instructions (and sometimes scripts) for a specific task, e.g. "save articles to my Obsidian vault", "add a new book to the PriceCheck scraper".

- **Lives in:** `<project-root>/.claude/skills/<skill-name>/SKILL.md` (project-scoped) or `~/.claude/skills/<skill-name>/SKILL.md` (user-scoped).
- **Visibility:** Project-scoped skills are committed; user-scoped are local.
- **Use for:** Multi-step procedures with a clear trigger, where the description in the frontmatter helps Claude know when to apply them.

## The rule of thumb

**Prefer CLAUDE.md.** When the user gives feedback or states a preference, it should go in CLAUDE.md unless there's a specific reason it can't:

- **Other developers will benefit from the same instruction** → CLAUDE.md (committed).
- **It only matters on my machine** → user-level `~/.claude/CLAUDE.md`.
- **It's a multi-step procedure with a clear trigger** → a skill.
- **It's transient or external context** (active project state, references to systems outside the repo, user-profile data) → memory.

The bias should be CLAUDE.md. Memory is local to one machine; CLAUDE.md travels with the repo. If a future collaborator hits the same rough edge you did, they should benefit from the same guardrail without you having to migrate it.

## Migration pattern

If you find yourself accumulating useful lessons in the memory system that aren't truly local, periodically lift them into CLAUDE.md. The memory file becomes a staging area for "is this a real, repeatable instruction?" Once you're sure, promote it.
