# DRY and single responsibility

**Keep code DRY.** Avoid duplicating logic — extract shared code into helpers, base classes, or common methods when the same pattern appears in multiple places.

**Single responsibility.** Each class, component, or function should have a single focus. If something is doing two unrelated things, split it up.

**Why:** Duplicated logic decays. When a bug or requirement change comes in, one copy gets updated and the others rot — and the discrepancy is usually noticed only when the rotten copy causes a production incident. Functions that do two things are also harder to test, harder to read, and harder to compose; the two responsibilities almost always change at different rates.

**How to apply:**

- When you find yourself copy-pasting a block of code, stop. Either factor out the shared part now, or note it as a follow-up before the duplication multiplies.
- Applies to test code too — shared fixture builders/helpers over copy-pasted setup.
- If a function's name needs an "and" to describe it ("parses input and writes to disk"), it's probably two functions.
- Don't extract too early. A pattern that appears twice can stay duplicated; the third occurrence is the signal to extract. (Rule of three.)
- Don't sacrifice clarity for DRY. If extracting a helper requires passing 6 awkward parameters or a config object to express "the difference between the two callers", the two call sites probably weren't actually the same logic.
