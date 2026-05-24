#!/usr/bin/env bash
# PreToolUse Bash hook. Denies bash read commands that contain $ (variable
# expansion or command substitution) AND invoke a command with a dedicated
# Claude Code tool equivalent. That combination usually triggers a permission
# prompt; the dedicated tools (Grep/Glob/Read) bypass the shell and don't.
#
# Wired in via the PreToolUse entry in claude/settings.json.
#
# Allow:  grep foo file.txt          (no $)
# Allow:  git log | grep foo         (no $)
# Allow:  echo "$HOME"               (no read-op)
# Allow:  cd $HOME && bun run build  (no read-op)
# Deny:   grep foo "$f"              ($ + read-op)
# Deny:   for f in a b; do grep x $f; done
# Deny:   c=$(grep -c x "$f")
# Deny:   grep foo /path/\$slug.tsx  ($ even when escaped)

set -euo pipefail

input=$(cat)
command=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

# No $ => no risk of a prompt from variable/substitution. Allow.
[[ "$command" == *'$'* ]] || exit 0

# No read-op in the command. Allow.
read_op_pattern='(^|[^A-Za-z0-9_])(grep|rg|find|cat|head|tail|ls|wc)([^A-Za-z0-9_]|$)'
if ! printf '%s' "$command" | grep -qE "$read_op_pattern"; then
  exit 0
fi

cat >&2 <<'EOF'
Blocked by redirect-shell-reads hook.

This Bash command contains $ (variable or command substitution) AND a read
operation (grep/rg/find/cat/head/tail/ls/wc). That combination typically
triggers a permission prompt, and there is a dedicated tool that bypasses
the shell entirely:

  grep / rg          -> Grep tool
  find / ls          -> Glob tool
  cat / head / tail  -> Read tool

Re-run as the dedicated tool. For a for-loop, issue one tool call per
iteration, or use a single glob pattern that captures every target.
EOF
exit 2
