# Confirm commit messages and PR descriptions before posting

Never post a commit message or PR description without explicit approval first. These artifacts outlive the conversation: they're read by collaborators, reviewers, and future-you, and they're harder to fix than to write carefully once.

**Why:** "Create a PR" or "commit this" is permission to do the mechanics (push, run `git commit`, run `gh pr create`), not permission to skip review of the text that's about to ship. A PR description in particular is public and lives forever in the project's history.

**How to apply:**

- Draft the proposed text into a fresh tempfile the user can open in their editor (e.g. `/tmp/commit-msg-<shortsha>.md`, `/tmp/pr-body-<branch>.md`). Never reuse a generic name across sessions; stale content has been posted by mistake.
- Point the user at the file path and wait for explicit approval (or edits) before running the `git commit` / `gh pr create` / `gh pr edit` command.
- Don't paste the proposed body back into chat as the primary review surface; the file is the artifact under review.
- Immediately before posting, `Read` the file once more in case the user edited it after approving.
- Same rule applies to edits of an existing commit message or PR body (`git commit --amend`, `gh pr edit --body-file`): file first, then approval, then post.

## Not for ordinary file edits

File edits in a tracked repo are cheaply reversible (`git checkout <path>`, `git reset`, `git revert`). Apply approved file edits directly. The tempfile-and-confirm pattern is for content that ships to a remote or rewrites history: commit messages, PR descriptions, tag messages, release notes. If you find yourself drafting a tempfile for a file edit, stop and just edit the file.
