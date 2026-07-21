# Confirm commit messages and PR descriptions before posting

Never post a commit message or PR description without explicit approval first. These artifacts outlive the conversation: they're read by collaborators, reviewers, and future-you, and they're harder to fix than to write carefully once.

**Why:** "Create a PR" or "commit this" is permission to do the mechanics (push, run `git commit`, run `gh pr create`), not permission to skip review of the text that's about to ship. A PR description in particular is public and lives forever in the project's history.

**How to apply:**

- Draft the proposed text into a file the user can open in their editor; a file is simply the easiest review surface. Location doesn't matter (a tempfile, a scratch file, wherever is convenient) as long as it's a fresh, uniquely-named file, never a generic name reused across sessions (stale content has been posted by mistake), and won't get swept into the commit itself.
- Point the user at the file with a clickable markdown link so they can open it directly, and wait for explicit approval (or edits) before running the `git commit` / `gh pr create` / `gh pr edit` command. **When the file lives outside the working directory (e.g. the scratchpad under `/private/tmp/...` or `/tmp/...`), the link href MUST be the absolute path, not a `../../` relative traversal.** The terminal resolves relative hrefs against the working directory, and hand-counting `../` hops up and across trees is easy to get wrong by one level, which produces a dead link. Absolute path = always correct, zero counting. Reserve relative hrefs for files inside the repo.
- Don't paste the proposed body back into chat as the primary review surface; the file is the artifact under review.
- Immediately before posting, `Read` the file once more in case the user edited it after approving.
- Same rule applies to edits of an existing commit message or PR body (`git commit --amend`, `gh pr edit --body-file`): file first, then approval, then post.

## Not for ordinary file edits

File edits in a tracked repo are cheaply reversible (`git checkout <path>`, `git reset`, `git revert`). Apply approved file edits directly. The tempfile-and-confirm pattern is for content that ships to a remote or rewrites history: commit messages, PR descriptions, tag messages, release notes. If you find yourself drafting a tempfile for a file edit, stop and just edit the file.
