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

### If you just want the instructions

Copy `CLAUDE.md` and the `claude/` folder into the root of your project. Done. Next Claude session, the instructions apply.

```bash
cp claude-playbook/CLAUDE.md your-project/
cp -R claude-playbook/claude your-project/
```

If you only want some of the instructions, open `CLAUDE.md` and delete the lines for ones you don't want. (And delete the corresponding files under `claude/instructions/` if you want a tidy directory.)

### If you want the voice rules everywhere, not just in this project

The `## Always` block at the top of `CLAUDE.md` holds voice/working-style rules; they apply to every chat, every file, every project. Install them at user scope so they fire even in projects that don't have the playbook. See [claude/install-globally.md](claude/install-globally.md) for the copy-paste for Claude Code, claude.ai, Claude Desktop / Cowork, and the API.

### If you want stack-specific conventions

Copy the relevant file from `claude/stacks/` into your project and link to it from your CLAUDE.md.

### If you want a skill

```bash
cp -R claude-playbook/claude/skills/obsidian-article-saver your-project/.claude/skills/
```

…or for user-scoped (available across all your projects):

```bash
cp -R claude-playbook/claude/skills/obsidian-article-saver ~/.claude/skills/
```

See [claude/skills/README.md](claude/skills/README.md) for more.

## How the playbook works under the hood

Three short reads on how Claude's instruction-and-memory systems actually behave, useful both for using this playbook well and for designing your own:

- **[CLAUDE.md vs memory vs skills](claude/meta/claude-md-vs-memory.md):** when to put an instruction in CLAUDE.md vs the memory system vs a skill, and the bias toward CLAUDE.md.
- **[Keep CLAUDE.md small](claude/meta/keep-claude-md-small.md):** why this file is short and how to keep yours short. Every line costs context on every session.
- **[Reloading instructions](claude/meta/reloading-instructions.md):** instruction files are loaded once at session start and aren't re-read mid-conversation. What that means, and the three workarounds.

## For non-developers

If you're using Claude Desktop or Cowork rather than Claude Code, most of this playbook still applies. The files in `claude/instructions/working-style/` in particular (push back, ask first, describe plans before executing, tell me how to see changes) are language- and tool-agnostic. They work just as well for "help me organize my files" as for "implement this feature."

You don't have a project-level `CLAUDE.md` in those tools, but you can paste the working-style instructions into your user preferences (Settings → Personalization in Claude.ai, or your `~/.claude/CLAUDE.md`) to get the same effect.

The `claude/skills/` directory is also useful; skills work the same way across Claude products.

## Why this exists

These are instructions I've accumulated across multiple projects, cleaned up so other people can use them.

## License

[CC0](LICENSE): public-domain dedication. Take it, use it, modify it, no attribution required.

## Contributing

Issues and PRs welcome. If you've got an instruction that's been working well for you, or a refinement to one that's here, open a PR.
