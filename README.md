# Claude Playbook

A collection of instructions, conventions, and skills I've found work well when working with Claude, both for coding (via Claude Code, the VS Code extension, or the API) and for everyday tasks (via Claude Desktop / Cowork).

This is opinionated. None of it is doctrine. Take what works for you, leave what doesn't, fork it and make it yours.

## What's in here

```
claude-playbook/
├── CLAUDE.md             # The "always loaded" instructions. Short by design.
└── claude/
    ├── instructions/         # Detailed instructions, loaded on demand. Each file is one instruction.
    │   ├── working-style/    # How Claude should interact (push back, ask first, verify own work).
    │   ├── code/             # Coding conventions (TDD, naming, docstrings, comments).
    │   ├── git-and-prs/      # Commit messages, PR descriptions, plan files.
    │   ├── language/         # Word choice and framing (neutral language, etc.).
    │   └── tools-and-shell/  # Working around shell-permission edge cases.
    ├── stacks/           # Stack-specific conventions. Copy if you use that stack.
    ├── skills/           # Reusable skills. Drop into your .claude/skills/.
    └── meta/             # Lessons about the system itself (CLAUDE.md vs memory, etc).
```

## How to use it

The recommended way is to clone this repo *once* and reference it from each of your projects. That way there's a single source of truth: when you refine an instruction, every project picks up the change next session, no copying.

### Recommended: clone as a sibling, import via `@`

1. Clone the playbook somewhere convenient. The simplest layout is to put it as a sibling of your other repos:

   ```bash
   cd ~/Programming   # or wherever you keep your repos
   git clone git@github.com:evanbernstein/claude-playbook.git
   ```

2. In each project that should use the playbook, create (or extend) a `CLAUDE.md` at the project root with this content:

   ```markdown
   # Instructions

   This project's general instructions live in a different repo imported below.

   **If the import on the next line did not load** (no playbook content appears after it), stop and tell the user:

   > The claude-playbook repo isn't where I expected. Please clone it so  `../claude-playbook` (relative to this project) resolves, then restart this session. Or, if you've cloned it elsewhere, tell me the path and I'll create a symlink.

   @../claude-playbook/CLAUDE.md

   ## Project-specific

   <!-- Anything that only applies to this codebase: stack notes, local conventions, quirks. Delete this section if there's nothing project-specific. -->
   ```

3. Commit that `CLAUDE.md` to your project. Teammates who clone it will see the "yell if missing" message on first session if they don't have the playbook cloned yet, and they'll know what to do.

That's it. The `@../claude-playbook/CLAUDE.md` line is a Claude Code import: at session start it expands inline as if the playbook's `CLAUDE.md` had been pasted directly into your project's file.

### What if I clone my project somewhere weird?

If your project isn't a sibling of `claude-playbook`, the import won't resolve and Claude will see the "yell if missing" instruction and ask you to fix it. The fix is one of:

- Clone the playbook so it ends up as a sibling
- Or symlink to an existing checkout: `ln -s ~/path/to/claude-playbook ../claude-playbook`.

Then restart the session.

### I only want some of the playbook

The stub above pulls in *everything* in the playbook's `CLAUDE.md`. If you only want some of the rules, two options:

- **Pick rules à la carte.** Skip the `@../claude-playbook/CLAUDE.md` import. Instead, copy the specific `## Always` lines you want from the playbook's `CLAUDE.md` into your project's `CLAUDE.md` directly, and replace the `Details:` links with absolute `@../claude-playbook/...` imports if you want Claude to load the longer explanations on demand. You lose automatic updates for those rules, but you get exactly the set you want.
- **Frozen copy.** Copy the playbook files into your project and commit them. See the "Frozen copy" section below.

### If you want the voice rules everywhere, not just in this project

The `## Always` block at the top of `CLAUDE.md` holds voice/working-style rules; they apply to every chat, every file, every project. Install them at user scope so they fire even in projects that don't have the playbook reference. See [claude/install-globally.md](claude/install-globally.md) for the copy-paste for Claude Code, claude.ai, Claude Desktop / Cowork, and the API.

If you only use Claude Code (CLI or VS Code), there's a shortcut: put `@~/Programming/claude-playbook/CLAUDE.md` (adjusted to your checkout path) in `~/.claude/CLAUDE.md`. That imports the playbook globally for every project, no per-project stub needed. Works for solo setups; not portable to teammates.

### If you want a skill

```bash
cp -R claude-playbook/claude/skills/obsidian-article-saver your-project/.claude/skills/
```

…or for user-scoped (available across all your projects):

```bash
cp -R claude-playbook/claude/skills/obsidian-article-saver ~/.claude/skills/
```

See [claude/skills/README.md](claude/skills/README.md) for more.

### Alternative: frozen copy

If you'd rather check the playbook directly into your project (no external dependency, no "yell if missing" failure mode, but no automatic updates either), copy the files in:

```bash
cp claude-playbook/CLAUDE.md your-project/
cp -R claude-playbook/claude your-project/
```

Then trim `CLAUDE.md` and the corresponding files under `claude/instructions/` down to the rules you want.

## How the playbook works under the hood

Three short reads on how Claude's instruction-and-memory systems actually behave, useful both for using this playbook well and for designing your own:

- **[CLAUDE.md vs memory vs skills](claude/meta/claude-md-vs-memory.md):** when to put an instruction in CLAUDE.md vs the memory system vs a skill, and the bias toward CLAUDE.md.
- **[Keep CLAUDE.md small](claude/meta/keep-claude-md-small.md):** why this file is short and how to keep yours short. Every line costs context on every session.
- **[Reloading instructions](claude/meta/reloading-instructions.md):** instruction files are loaded once at session start and aren't re-read mid-conversation. What that means, and the three workarounds.

## For non-developers

If you're using Claude Desktop or Cowork rather than Claude Code, the `@import` trick doesn't apply (those tools don't resolve project-relative imports the same way). Most of this playbook still applies, though. The files in `claude/instructions/working-style/` in particular (push back, ask first, describe plans before executing, tell me how to see changes) are language- and tool-agnostic. They work just as well for "help me organize my files" as for "implement this feature."

You don't have a project-level `CLAUDE.md` in those tools, but you can paste the working-style instructions into your user preferences (Settings → Personalization in Claude.ai, or your `~/.claude/CLAUDE.md`) to get the same effect. See [claude/install-globally.md](claude/install-globally.md).

The `claude/skills/` directory is also useful; skills work the same way across Claude products.

## Why this exists

These are instructions I've accumulated across multiple projects, cleaned up so other people can use them.

## License

[CC0](LICENSE): public-domain dedication. Take it, use it, modify it, no attribution required.

## Contributing

Issues and PRs welcome. If you've got an instruction that's been working well for you, or a refinement to one that's here, open a PR.
