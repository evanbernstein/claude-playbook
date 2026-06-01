# Accrete patterns as you find them

When you learn something during a session that would help on future tasks, proactively write it down. Examples: a recurring bug, a non-obvious pattern, a convention the code follows but doesn't document, a fix the next person will also hit. Don't wait to be asked.

**Where it goes depends on scope:**

- **Project-specific** (true only of this codebase: its test commands, its formatter, its file layout, its naming quirks) → add to the project's `CLAUDE.md`, in the existing `## Project-specific` section (or equivalent).
- **Generic** (would apply equally to another codebase: a working-style preference, a coding convention, a tooling habit) → add to the playbook's `CLAUDE.md` at `../claude-playbook/CLAUDE.md`. If it needs more than a line of explanation, also create a new file under `claude/instructions/<category>/` and link to it from the bullet.

When in doubt, ask: "Would I want this rule in my next project too?" If yes, it's generic; put it in the playbook. If no, it belongs in the project file.

**Instruction files, not feedback memory, are the home for durable rules.** A generalizable working-style, coding, or tooling rule goes in a `CLAUDE.md` / `claude/instructions/` file (per the scope split above), NOT in an auto-memory `feedback` entry. The auto-memory system describes `feedback` memories as "how you should work," which overlaps and tempts the wrong choice; resist it. Reserve `feedback` memory for genuinely transient or session-scoped context that doesn't belong in a checked-in instruction file. If a rule is worth remembering for the next task, it's worth a one-line instruction-file edit that every future session and project sees.

**Why:** Instruction files are how this project teaches the next Claude session. A pattern that lives only in this conversation evaporates when the session ends; a one-line addition survives. Putting it in the right repo also matters: generic rules in the playbook benefit every project; project-specific rules in the project file avoid polluting the playbook with one codebase's quirks.

**How to apply:**

- After fixing a recurring class of bug, ask: would a rule somewhere have prevented this? If yes, add it in the appropriate scope.
- When you discover a convention the codebase follows but doesn't state (naming, file placement, an idiom used in three places), add it. Project-specific → project `CLAUDE.md`. Codebase-agnostic style → playbook.
- When the user corrects you on something they're likely to correct again, write it down.
- Keep additions terse. One or two lines under an existing section beats a new section. Match the file's existing voice.
- Instruction files load at session start, so the new rule applies next session, not this one. Mention that when you add it.
