---
name: obsidian-article-saver
description: >
  Save articles and blog posts to the user's Obsidian vault. Use this skill whenever the user
  shares a URL and wants it added to their collection, or mentions saving/clipping/archiving an
  article, blog post, or web page to Obsidian. Also trigger when the user says things like
  "add this to my collection", "save this article", "clip this", or pastes a URL with the
  expectation that it should be processed into their vault. Even if the user just pastes a bare
  URL with no other context, this skill should trigger — that's the most common usage pattern.
  IMPORTANT: Never ask the user for clarification about what to do. Just fetch the article,
  create the file, suggest tags and a folder, and present the result. The user wants the full
  article text saved — always proceed with that as the default, no options menu needed.
---

# Obsidian Article Saver

You are helping the user build and maintain an Obsidian-based collection of articles, blog posts,
and other web content. The user saves the full text of articles (as insurance against link rot)
along with metadata and tags so they can find things later.

**Core rule: always save the full article text.** Every article gets the complete body content
under `# Website`, no matter how short. Never summarize, truncate, or ask whether to save. Never
offer a "just the quote" option. The whole point of this vault is a complete offline archive.

## The Vault

The user's Obsidian vault is mounted at `/sessions/*/mnt/ManagerNotes/` (use the actual session
path). Key locations:

- **Articles folder**: `Articles/` — organized into topic subfolders
- **Templates folder**: `templates/` — contains the base template
- **Review folder**: `to organize/` — where new articles go for the user to review before filing

## Workflow

When the user shares a URL:

### 1. Fetch the article

Use `WebFetch` to retrieve the article content. Extract:
- The **full article text** (the body content, not navigation/ads/footers)
- The **title**
- The **author** (look in bylines, meta tags, or the article text itself)
- The **publication date** (look in datelines, meta tags, or URL patterns)

If the author or date can't be determined, note that in the frontmatter with "Unknown" or leave
the date as today's date, and mention this to the user so they can correct it.

**Blocked domains**: Some domains are blocked by the egress proxy and `WebFetch` will fail or
return an error. Known blocked domains include `simonwillison.net`. For these, skip WebFetch
entirely and go straight to Claude in Chrome — do not ask the user what to do, just use Chrome:
1. `mcp__Claude_in_Chrome__tabs_context_mcp` (with `createIfEmpty: true`) -> get tab ID
2. `mcp__Claude_in_Chrome__navigate` -> load the URL
3. `mcp__Claude_in_Chrome__get_page_text` -> extract article text
4. `mcp__Claude_in_Chrome__javascript_tool` -> capture hyperlinks:
   `Array.from(document.querySelector('.entry, article, main').querySelectorAll('a[href]')).filter(a => !a.href.includes('/tag') && !a.href.startsWith('javascript')).map(a => ({text: a.textContent.trim(), href: a.href}))`

If WebFetch returns an error or unusably sparse content for any domain (not just known ones),
silently fall back to Chrome the same way. Never present the user with a list of options —
just fetch via Chrome and proceed.

**Paywalled content**: If an article is behind a paywall and the full text is not accessible
(e.g. Medium members-only posts), save what is available — the title, lede, and any visible
text — and note clearly in the `# Claude Summary` section that the full text was paywalled.
Do not ask the user what to do; just save what you can and flag it.

Always preserve links from the article body in the `# Website` markdown.

### 2. Fetch tags and folders in parallel

While processing the article, run these two Bash commands to get live vault context:

**Existing tags** (scan frontmatter across all articles):
`grep -rh "^  - " /sessions/*/mnt/ManagerNotes/Articles --include="*.md" | sort -u`

**Existing folders** (live directory tree):
`find /sessions/*/mnt/ManagerNotes/Articles -type d | sort`

Use these results for steps 3 and 4. Do not rely on any hardcoded lists.

### 3. Create the markdown file

Use this exact template structure:

---
tags:
  - tag-one
  - tag-two
url: <the source URL>
author: <author name>
created: <YYYY-MM-DD publication date>
---
# Highlights



# Claude Summary

<Your 3-5 sentence summary of the article's key ideas and why it matters>


# Website

<Full article text in markdown format>

Leave extra blank lines between each top-level # section so they have visual breathing room
in the editor.

**Important details about the template:**
- `# Highlights` is left **empty** by default — this is where the user adds their own notes
  later, typically as Obsidian blockquotes (e.g. `> This is a key insight`). If the user
  provides a highlight or quote when sharing the article, add it here as a blockquote.
- `# Claude Summary` is a section YOU fill in with a concise summary (3-5 sentences) of the
  article's core argument, key takeaways, and why an engineering leader might find it valuable.
  Write it in a way that helps the user decide at a glance whether to re-read the full article.
- `# Website` contains the **complete article text** converted to clean markdown. Preserve
  headings, lists, block quotes, and emphasis. Remove navigation elements, ads, cookie banners,
  and other non-content elements. **Heading levels must be adjusted** so that everything under
  `# Website` nests below it — if the article has `#` (h1) headings, demote them to `##`, and
  shift all other headings down accordingly. The highest heading level in the article text
  should be `##` so it collapses under the `# Website` section in Obsidian.

### 4. Suggest tags

Use the tag list from the grep command in step 2. Suggest 3-8 tags that accurately reflect the
article's themes. Strongly prefer existing tags — the goal is to keep the tag vocabulary tight
and useful, not to create a unique tag for every article.

Tags should be sorted alphabetically in the frontmatter YAML list.

Only propose a new tag when the article covers a genuinely distinct topic that none of the
existing tags capture, and flag it clearly (e.g., "New tag suggestion: `remote-hiring` — none
of the existing tags cover this intersection"). The user should be able to say yes or no.

### 5. Suggest a folder

Use the folder tree from the find command in step 2. Suggest the **best-fit folder** for the
article. If it could go in multiple places, mention your top 2 choices with brief reasoning.
If nothing fits well, suggest `to organize` and explain why. You may propose a new folder or
subfolder, but be conservative — only suggest one when the article represents a topic that's
likely to recur and doesn't fit naturally into any existing folder. The goal is a folder
structure that stays navigable, not one that sprawls.

### 6. Save and present

- **File name**: Use the article title as the filename (e.g., `Article Title Here.md`)
- **Save location**: Always save initially to `to organize/` — never save directly to a final
  folder. The user confirms the folder in step 7.

After saving, you MUST make these two tool calls — in this order, every time, no exceptions.
NEVER print the obsidian:// URL as plain text. The only place it appears is inside the widget.

**Tool call 1 — call `mcp__visualize__show_widget` RIGHT NOW:**
- `title`: `obsidian_link` (plus a word from the article title)
- `loading_messages`: `["Building link..."]`
- `widget_code`: the HTML below, with ENCODED_PATH replaced by the actual encoded path

Determine the session path from the path you used to write the file (e.g. if you wrote to
`/sessions/abc-123/mnt/ManagerNotes/...` then the session path is `abc-123`).
Encode the path relative to the vault root: spaces -> `%20`, slashes -> `%2F`, no `.md` extension.
Example: file at `to organize/My Article.md` -> encoded path = `to%20organize%2FMy%20Article`

Widget HTML (replace ENCODED_PATH in both places):

<div style="padding:0.75rem 0"><h2 class="sr-only">Obsidian link</h2><div style="background:var(--color-background-secondary);border:0.5px solid var(--color-border-tertiary);border-radius:var(--border-radius-lg);padding:12px 16px;display:flex;align-items:center;gap:12px"><span style="font-family:var(--font-mono);font-size:12px;color:var(--color-text-secondary);flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">obsidian://open?vault=ManagerNotes&file=ENCODED_PATH</span><button id="copy-btn" onclick="copyLink()" style="flex-shrink:0;font-size:13px;padding:5px 14px;cursor:pointer">Copy</button></div></div><script>function copyLink(){navigator.clipboard.writeText('obsidian://open?vault=ManagerNotes&file=ENCODED_PATH').then(()=>{var b=document.getElementById('copy-btn');b.textContent='Copied!';setTimeout(()=>{b.textContent='Copy'},2000)})}</script>

**Tool call 2 — call `mcp__cowork__present_files` RIGHT NOW:**
Pass the absolute path to the file you just saved. Use the actual session path from your
environment — do not use a placeholder.
Example: `{"files": [{"file_path": "/sessions/abc-123/mnt/ManagerNotes/to organize/My Article.md"}]}`
This shows a clickable preview card in Cowork. It is required every time.

After both tool calls, ask about tags and folder:

Suggested tags: `tag-one`, `tag-two`, `tag-three`
Suggested folder: `Articles/Some/Path` — [one sentence of reasoning]
Confirm, or let me know if you'd like changes.

Do not move the file until the user confirms.

### 7. Handle user feedback

When the user confirms (or adjusts) the tags and folder:
1. Update the tags in the file's frontmatter if changed
2. Move the file from `to organize/` to the confirmed `Articles/<folder>/` path
3. Immediately call `mcp__visualize__show_widget` again with the new final encoded path
4. Immediately call `mcp__cowork__present_files` again with the new absolute final path
Do not skip steps 3 and 4 — the user needs the updated link and preview after the move.

## Important notes

- **Always save the full text**: Every article — long, short, a single quote, a brief link post
  — gets its complete body content under `# Website`. Never truncate, summarize in place of the
  text, or ask whether to save. Don't offer options like "just the quote" or "summary only."
- **Markdown quality**: Convert HTML to clean markdown. Use proper heading levels, preserve
  links, format code blocks, and maintain list structures.
- **Images**: Always preserve images from the article. When fetching via Chrome tools, use
  JavaScript to extract `<img>` elements from the article body: query all `img` tags within
  the article container and capture their `src` and `alt` attributes. Place images inline in
  the `# Website` section exactly where they appear in the original article using standard
  markdown syntax: `![alt text](image-url)`. For images with long or descriptive alt text,
  preserve the full alt text — it often describes screenshots usefully. Skip icons, avatars,
  and purely decorative images (e.g., author headshots, social sharing buttons). When using
  `WebFetch`, images are typically not present in the extracted text — use Chrome tools instead
  for articles with meaningful images (charts, diagrams, screenshots). The pattern to use in
  JavaScript: `Array.from(entry.querySelectorAll('img')).map(img => "["+img.alt+"]("+img.src+")")`.
- **iCloud sync**: Files in this vault sync via iCloud. If you encounter "Resource deadlock
  avoided" errors when trying to read files, this means the files haven't been downloaded from
  iCloud yet. Prompt the user to open Finder, navigate to the vault folder, right-click it,
  and select "Keep Downloaded" so macOS will sync the files locally. Then try again.
