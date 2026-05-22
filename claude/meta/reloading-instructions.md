# How Claude loads instructions, and what to do when you change them mid-session

## When CLAUDE.md gets read

Claude reads `CLAUDE.md` (project-level) and `~/.claude/CLAUDE.md` (user-level) at the start of every session. They're loaded into a specific position in the context window with a framing that tells Claude "these override default behavior." That's the workhorse mechanism.

## What this means in practice

Two consequences worth knowing:

**Changes to CLAUDE.md don't take effect until the next session.** If you edit an instruction file mid-conversation, Claude doesn't automatically re-read it. The version Claude loaded at session start is the version that applies for the rest of the session.

**Mid-session instructions live in the regular conversation, not in the "instructions" slot.** Claude still follows them, but they don't carry the same framing CLAUDE.md does. On a long session with lots of tool output between the instruction and the moment it should apply, mid-session instructions can get diluted — Claude pays close attention to recent tool output, and a single line of guidance from 200 turns ago less so.

If you've ever been frustrated that Claude seemed to follow an instruction early in a session and then drifted away from it later, this is probably why.

## What to do when you change an instruction mid-session

Three workarounds, from heaviest to lightest:

1. **Paste the new instruction into the chat.** Most reliable. Once it's in the conversation, Claude attends to it for the rest of the session, and usually weights it heavily because it's recent and explicit. Only lasts this session.

2. **Ask Claude to re-read the file.** E.g. "re-read `claude/instructions/working-style/sequential-not-parallel.md`". Claude runs `Read` and the updated content enters the conversation. Same effect as pasting, less typing on your end.

3. **Tell Claude what changed in plain language.** E.g. "I just added a token-cost note to the sequential-not-parallel instruction — apply that going forward." Often the lightest-weight option; the instruction itself is the instruction.

## Insurance for long sessions

Even instructions loaded properly at session start can lose weight on a long session with lots of intervening tool output. If something matters and the session has been running a while, restating it once more near the moment it applies is cheap insurance.
