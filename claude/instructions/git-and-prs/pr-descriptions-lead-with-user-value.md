# PR descriptions lead with the user-visible change

Open every PR description with a tight, factual statement of what a user can now do — concrete capability, in the active voice. The reader is reviewing the code; they don't need to be sold on the motivation.

**Why:** A rhetorical opener ("Which song tonight had the longest gap? When was each song last played?") forces the reviewer to wade through framing before learning what changed. A factual opener ("A user can now view every setlist as a table showing the number of shows since each song was last played, plus its last played date") makes the user-visible change unmistakable in one read.

**How to apply:**

- Open with a paragraph or short list stating what the user can now do.
- Save technical motivation (perf wins, refactors, infra changes) for follow-up paragraphs.
- Skip rhetorical questions, "today you'd have to…" phrasing, and persona setup.
- Active voice, concrete verbs: "adds", "removes", "shows", "enables".
- The code describes the WHAT in detail; the description's job is to make the user-visible change obvious.

**Good:**

> A user can now view every setlist as a table that includes the number of shows since each song was last played (the "gap"), and its last-played date. Each setlist card has a toggle to switch between views.

**Bad:**

> Setlist viewers often wonder which song had the longest gap, or when each song was last played. Today, finding that information requires clicking through to the song's page individually. This PR adds…
