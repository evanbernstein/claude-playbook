#!/usr/bin/env bash
# Test harness for allow-shell-reads.sh. Feeds each command to the hook as the
# real PreToolUse JSON payload and checks whether it auto-approves (ALLOW) or
# falls through to the normal permission flow (PASS).
#
# Run: claude/hooks/allow-shell-reads.test.sh

set -uo pipefail

HOOK="$(dirname "$0")/allow-shell-reads.sh"
pass=0
fail=0

# verdict <command> -> prints ALLOW, DENY, or PASS
verdict() {
  local out
  out=$(jq -n --arg c "$1" '{tool_input: {command: $c}}' | bash "$HOOK" 2>/dev/null)
  if printf '%s' "$out" | jq -e '.hookSpecificOutput.permissionDecision == "allow"' >/dev/null 2>&1; then
    printf 'ALLOW'
  elif printf '%s' "$out" | jq -e '.hookSpecificOutput.permissionDecision == "deny"' >/dev/null 2>&1; then
    printf 'DENY'
  else
    printf 'PASS'
  fi
}

check() {
  local expected="$1" cmd="$2" got
  got=$(verdict "$cmd")
  if [[ "$got" == "$expected" ]]; then
    ((pass++))
    # printf 'ok   %-6s %s\n' "$got" "$cmd"
  else
    ((fail++))
    printf 'FAIL expected=%-6s got=%-6s  %s\n' "$expected" "$got" "$cmd"
  fi
}

# --- Read-only commands that should be auto-approved ---------------------------
check ALLOW 'grep -rn foo app/'
check ALLOW 'grep -rn "count\|photos\|gap-1" app/components/x.test.tsx 2>/dev/null | head'
check ALLOW 'find . -name "*.ts" | xargs grep foo | sort | uniq -c'
check ALLOW 'cat file | grep x'
check ALLOW 'rg pattern'
check ALLOW 'ls -la dir'
check ALLOW 'git log --oneline | grep fix'
check ALLOW 'git -C /repo status'
check ALLOW 'git diff HEAD~1'
check ALLOW 'gh pr view 123'
check ALLOW 'gh issue list'
check ALLOW 'gh pr diff'
check ALLOW 'cat "$f"'
check ALLOW 'grep "$(date +%Y)" file'
check ALLOW 'echo hi'
check ALLOW 'wc -l file'
check ALLOW 'find . -name "*.tsx"'
check ALLOW 'xargs -I {} grep foo'
check ALLOW 'xargs -0 grep foo'
check ALLOW 'sort file | uniq -c'
check ALLOW 'grep foo f && grep bar g'
check ALLOW 'printf "%s" "$x"'
check ALLOW 'head -20 file; tail -5 file'
check ALLOW 'FOO=bar grep x file'
check ALLOW 'jq ".items[]" file.json | head'

# --- Commands that must fall through to a prompt -------------------------------
check PASS 'grep foo f > out.txt'
check PASS 'find . -name x -delete'
check PASS 'echo hi && rm -rf build'
check PASS 'gh pr create --body-file /tmp/x'
check PASS 'gh issue create --title x'
check PASS 'git commit -m x'
check PASS 'git push'
check PASS 'git checkout -b new'
check PASS 'git branch -D feature'
check PASS 'git tag -d v1'
check PASS 'sed -i "s/x/y/" file'
check PASS 'sort -o out.txt file'
check PASS 'tee file'
check PASS 'cat f | tee out'
check PASS 'grep x f; rm y'
check PASS 'echo `rm x`'
check PASS 'grep "$(rm x)" f'
check PASS 'grep "$(echo hi > /tmp/x)" f'
check PASS 'rm -rf /'
check PASS 'mv a b'
check PASS 'npm install'
check PASS 'yq -i ".x=1" file'
check PASS 'find . -exec rm {} \;'
check PASS 'cat f > /tmp/out'
check PASS 'xargs rm'
check PASS 'bash -c "rm x"'
check PASS 'awk "{print \$1}" file'
check PASS 'sed "s/x/y/" file'
check PASS 'env rm -rf x'
check PASS 'cat <(rm x)'
check PASS 'sudo cat /etc/shadow'

# --- Bash on a `$`-path must be denied outright (no-bash-on-dollar-paths) ------
# The allowlist (Bash(sed:*)/Bash(grep:*)/Bash(cat:*)) would otherwise approve a
# read pipeline over a React Router dynamic-segment file; a hard deny is the only
# verdict that overrides an allow rule and redirects to Read/Grep.
check DENY 'grep -n foo apps/web/app/routes/songs/\$slug.tsx'
check DENY 'sed -n 1,16p /tmp/\$slug.tsx | cat -n'
check DENY 'cat /tmp/\$action.tsx'
check DENY 'grep -nE "loader|service" apps/web/app/routes/songs/\$slug.tsx'
check DENY "grep -n foo '/tmp/\$slug.tsx'"

# --- Benign `$` (shell vars, substitutions, regex anchors) must NOT be denied --
check ALLOW 'echo $HOME'
check ALLOW "grep 'foo\$' file"

printf '\n%d passed, %d failed\n' "$pass" "$fail"
[[ $fail -eq 0 ]]
