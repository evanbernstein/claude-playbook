# Remind the user when instruction changes won't apply this session

Instruction files are loaded once at session start and never re-read. When the user edits `CLAUDE.md`, any file under `claude/instructions/`, or any other Claude instruction file mid-session, the change does *not* automatically take effect for the rest of this conversation.

**Why this matters:** A user who edits an instruction file may reasonably assume it's now active. When Claude keeps doing the old thing, the user is confused and frustrated — and the cause (instruction files are session-bootstrap, not live-reload) isn't obvious from the outside.

**How to apply:**

- After any edit to an instruction file (CLAUDE.md, anything in `claude/instructions/`, `~/.claude/CLAUDE.md`, project-level CLAUDE.md, etc.), end the response with a brief reminder that the change applies next session, not this one.
- If the change is relevant to the current session, offer the in-session workarounds: paste the new instruction into chat, ask Claude to re-read the file, or restate it inline in plain language.
- Keep the reminder short — one or two sentences. Don't lecture every time; one line at the end of the work summary is enough.

Example phrasing: *"This change applies next session — instruction files aren't re-read mid-conversation. If you want it to apply now, paste the new text into chat or ask me to re-read the file."*
