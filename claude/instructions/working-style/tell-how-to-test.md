# Tell the user how to see changes

End every work summary with what the user needs to do to see the changes: reload, restart the dev server, clear a cache, run a command, or nothing at all. Don't make them guess.

**Why:** The user shouldn't have to wonder whether a hot-reload covers the change or whether they need to restart the dev server, clear Redis, or rebuild a generated client. Stale-cache confusion has burned hours of debugging that wasn't actually a bug.

**How to apply:**

Add a short note at the end of each work summary. Match the change type:

- **Frontend route/component edits with HMR:** "Just reload the page; dev server hot-reloads."
- **Library/package code edits:** "Restart the dev server to pick up the package changes."
- **Cached loader data changed:** "Clear the relevant cache key (e.g. `redis-cli DEL <key>`) before reloading."
- **New dependency added:** "Restart the dev server."
- **Config file changed (vite, tsconfig, etc.):** "Restart the dev server."
- **Database schema/migration:** "Run migrations (`<project-specific command>`) before reloading."
- **Generated client (Prisma, GraphQL codegen):** "Regenerate the client, then restart."
- **Test-only changes:** "No reload needed; run the tests."

Be specific about commands. Don't write "you might need to restart"; either you need to or you don't.
