# Red/green TDD for all implementation

When planning and implementing work, follow the red/green TDD cycle:

1. **Write the test first.** It should fail (red).
2. **Implement the code** to make the test pass (green).
3. Repeat for the next behavior.

**Why:** Catches design issues early, produces tighter tests, and ensures tests actually verify what they claim to. A test that was never red might pass for the wrong reason; for example, asserting against the same default value the code returns when no code path actually exercises the new behavior.

**How to apply:**
- In execution plans, order steps as: write test → run test (confirm red) → implement → run test (confirm green). Not: implement → write test.
- When adding a new function/hook/component, write its test file first with the expected behavior, confirm it fails, then write the implementation.
- When refactoring, write tests covering the existing behavior first (if not already covered), confirm green, then refactor, confirm still green.
- When fixing a bug and all existing tests pass, write a test that fails first, then fix the bug. This ensures the bug is actually covered by the test suite going forward.
- When in doubt, ask: "Is there a test I could write that would fail right now?" If yes, write it first.
