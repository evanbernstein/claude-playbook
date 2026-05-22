# Skills

A **skill** is a self-contained package that bundles instructions (and sometimes scripts and templates) for a specific task. Claude loads a skill when its description matches the user's request; for example, a "save article to Obsidian" skill triggers when the user pastes a URL into chat.

## How a skill is structured

```
<skill-name>/
├── SKILL.md          # Required. Frontmatter (name, description) + body instructions.
└── ...               # Optional: templates, scripts, helpers the SKILL.md references.
```

The `SKILL.md` frontmatter is what Claude uses to decide whether to load the skill:

```yaml
---
name: my-skill-name
description: >
  Plain-language description of when this skill should trigger. Be specific about
  the user phrases and intents that should activate it. Mention the common usage
  pattern (e.g. "even when the user just pastes a bare URL").
---
```

The body of `SKILL.md` is the actual instructions Claude follows when the skill is active.

## How to install a skill

### Project-scoped (committed to a repo)

```
<your-project>/
└── .claude/
    └── skills/
        └── <skill-name>/
            └── SKILL.md
```

### User-scoped (available across all your projects)

```
~/.claude/skills/<skill-name>/SKILL.md
```

## How to install a skill from this repo

Copy the skill folder into your `.claude/skills/` directory:

```bash
# Project-scoped
cp -R claude/skills/obsidian-article-saver path/to/your/project/.claude/skills/

# User-scoped
cp -R claude/skills/obsidian-article-saver ~/.claude/skills/
```

That's it. The next Claude conversation will pick up the new skill automatically.

## What's in this directory

- **`obsidian-article-saver/`:** Save articles and blog posts to an Obsidian vault. Triggered when the user shares a URL with the intent of archiving it. Specific to Obsidian; adapt the vault paths in `SKILL.md` to match your own setup.
