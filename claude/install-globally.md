# Install voice rules globally

The `## Always` block at the top of [CLAUDE.md](../CLAUDE.md) holds voice/working-style rules that apply to every chat reply, every file, every commit message, on every project. If you only install them per-project (via the playbook's `CLAUDE.md`), they only fire in projects that have the playbook installed.

For consistent behavior across every project and every Claude product, install the `## Always` block at user scope.

**Single source of truth:** the rule text lives in `CLAUDE.md`. This file just tells you how to copy it into each Claude product. When the rules in `CLAUDE.md` change, re-paste.

## Claude Code (CLI, VS Code extension)

```bash
mkdir -p ~/.claude
$EDITOR ~/.claude/CLAUDE.md
```

Open `CLAUDE.md` from this repo, copy the entire `## Always` section (from the `## Always` heading through the blank line before `## Working style`), and paste it into `~/.claude/CLAUDE.md`. The `Details:` links will be broken at user scope (the playbook isn't on the path), so delete the `Details: [...]` sentence from the end of each rule, or leave them if you don't mind the dead links.

## claude.ai web and Claude Desktop / Cowork

There's no user-level `CLAUDE.md` for the web app or Cowork, and Cowork doesn't resolve `@imports`. Use **Profile Instructions** instead. The same field covers both claude.ai web and Cowork: Cowork injects your Profile Instructions into every session automatically, no separate setup needed.

1. Open [claude.ai](https://claude.ai), click your initials (bottom left), then **Settings → Personalization**.
2. Open `CLAUDE.md` from this repo and copy the `## Always` section (rule text only; skip the `Details:` links since they're project-relative).
3. Paste into the "What personal preferences should Claude consider in responses?" field.
4. Save.

To verify it took in Cowork, open a fresh Cowork session with no folder selected and ask: *"What user preferences do you see in your context? Quote them exactly."* The reply should quote your `## Always` block verbatim. If it's paraphrased or missing, the field didn't save or got truncated.

## Anthropic API

If you call the API directly, copy the rule text from the `## Always` section of `CLAUDE.md` (skip the `Details:` links) and prepend it to your system prompt. They're short and worth the tokens for the voice consistency.

## Keeping it in sync

The rule text lives in `CLAUDE.md`. If you update a rule there, you'll need to re-paste into the global location to get the change. A `git diff CLAUDE.md` between the version you last installed and the current version tells you what to re-copy.
