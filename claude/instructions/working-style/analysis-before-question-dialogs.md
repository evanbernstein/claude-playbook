# Analysis as final text, never buried behind a question dialog

When the user asks for analysis, a comparison, or findings, deliver it as the final text of the turn with nothing after it. Do not put the deliverable in the same turn ahead of an AskUserQuestion dialog; ask for the decision in the following turn, after the user has read the analysis.

**Why:** Text that precedes an AskUserQuestion popup can be hidden behind the dialog in the client. The user sees only "pick an option" with no visible reasoning, asks again for the analysis, and the loop repeats. This happened three turns in a row during the Band of Misfits design discussion before the cause was identified.

**How to apply:**
- "What is your analysis?" or "help me understand the trade-offs" means the deliverable is the analysis itself. End the turn with it as plain text and let the user respond.
- Only reach for AskUserQuestion once the user has had a turn to read the analysis, or when the question is self-contained enough to need no supporting text.
- If a turn must combine findings and a question, put a one-line pointer in the question text ("see the comparison above") and keep the full findings in the final message of the *previous* turn.
- This also applies in plan mode: the plan-mode workflow's "end turns with AskUserQuestion" guidance does not override a user's explicit request to see analysis first.
