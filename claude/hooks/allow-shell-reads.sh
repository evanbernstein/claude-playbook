#!/usr/bin/env bash
# PreToolUse Bash hook. Auto-approves commands that are provably read-only so
# research (grep/find/cat pipelines, with redirects, $vars, and command
# substitutions) never triggers a permission prompt. Anything not provably
# read-only falls through to the normal permission flow unchanged -- a
# misclassification of the read-only set at worst means "you still get asked",
# never "something destructive ran silently".
#
# The one command class the hook actively DENIES (rather than falling through)
# is Bash on a path containing a literal `$`, which an allow rule would otherwise
# run silently; see the dollar-path guard below.
#
# Wired in via the PreToolUse entry in claude/settings.json.
#
# A command is approved only when EVERY pipeline/sequence segment's leading
# command is in the read-only allowlist (plus read-only git/gh subcommands and
# read-only xargs targets), there is no file-writing redirection, and no
# write-capable flag (sort -o, yq -i, find -exec/-delete, ...). Command
# substitutions are validated recursively; backticks and constructs we can't
# parse confidently cause a safe fall-through.
#
#   Allow:  grep -rn foo app/ 2>/dev/null | head
#   Allow:  find . -name '*.ts' | xargs grep foo | sort | uniq -c
#   Allow:  cat "$f" | grep "$(date +%Y)"
#   Allow:  git log --oneline | grep fix
#   Pass :  gh pr create --body-file /tmp/x   (gh write subcommand)
#   Pass :  grep foo f > out.txt              (file write)
#   Pass :  find . -name x -delete            (mutating action)
#   Pass :  echo hi && rm -rf build           (rm not read-only)

set -uo pipefail

input=$(cat)
command=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

# Nothing to classify -> let normal flow handle it.
[[ -n "$command" ]] || exit 0

# Bash on a path containing a literal `$` (React Router dynamic segments like
# `$slug.tsx`, written backslash-escaped `\$slug` or single-quoted `'/x/$slug'`)
# must never run through the shell -- the first-party Read/Edit/Grep/Glob tools
# take such paths directly. The normal permission screen prompts on a bare
# `grep ... $slug.tsx`, but an allowlisted command (Bash(grep:*)/Bash(sed:*)) or
# this hook's own read-only approval would otherwise let it through silently, so
# this is the one case the hook actively DENIES (overriding any allow rule)
# instead of falling through.
#
# Matches `$name` only when it reads as a path: preceded by `/`, or followed by
# a `.ext`. Leaves shell variables/substitutions and regex anchors alone
# (`$f`, `$HOME`, `$(...)`, `${x}`, `foo$`); a `$VAR` embedded in a path is a
# rare, accepted false positive.
if printf '%s' "$command" | grep -qE '(/\\?\$[A-Za-z_]|\\?\$[A-Za-z_][A-Za-z0-9_]*\.[A-Za-z])'; then
  jq -n '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: "Bash on a path containing \"$\" is blocked (no-bash-on-dollar-paths). Use Read/Edit/Grep/Glob, which take the path directly and bypass the shell. For git, target the parent directory instead of naming the $ file."}}'
  exit 0
fi

# Backticks execute even inside double quotes and are painful to validate
# safely; fall through rather than risk it.
[[ "$command" == *'`'* ]] && exit 0

# Read-only command allowlist. Membership test via a case statement so the set
# stays readable. Commands that can write are deliberately excluded; the few
# allowed commands that CAN write given a flag (sort -o, yq -i, find actions)
# are guarded in is_forbidden below.
#
# awk, sed, and env are intentionally absent: each can write a file or execute
# another command from inside a quoted argument (awk 'system(...)' / '{print >
# "f"}', sed -i / 'w f', env <cmd>), which this hook can't see once quotes are
# stripped. A pipeline containing them falls through to a normal prompt.
is_read_only_cmd() {
  case "$1" in
    grep | egrep | fgrep | rg | ag | find | ls | cat | bat | head | tail | wc | \
      sort | uniq | cut | tr | nl | tac | rev | fold | column | comm | join | paste | \
      jq | yq | tree | stat | file | which | type | echo | printf | pwd | date | \
      basename | dirname | realpath | readlink | hostname | whoami | id | uname | \
      df | du | cksum | md5sum | sha1sum | sha256sum | true | false | test)
      return 0 ;;
    *) return 1 ;;
  esac
}

# Read-only git subcommands (everything else -- commit, push, checkout-with-args,
# config writes -- falls through to a prompt).
is_read_only_git_sub() {
  case "$1" in
    log | show | diff | status | blame | ls-tree | ls-files | rev-parse | cat-file | \
      describe | shortlog | reflog | grep | whatchanged | name-rev | rev-list)
      return 0 ;;
    *) return 1 ;;
  esac
}

# Strip wrapping quotes, a leading backslash, and any directory prefix so
# "/usr/bin/grep", "'grep'", and "\grep" all normalize to "grep".
normalize_cmd() {
  local c="$1"
  c="${c//\"/}"
  c="${c//\'/}"
  c="${c#\\}"
  c="${c##*/}"
  printf '%s' "$c"
}

# True when the string carries a write side effect that a read-only-looking
# leading command would otherwise hide. Run on a quote-stripped string so
# quoted data (e.g. a `>` inside a search pattern) doesn't false-trigger.
is_forbidden() {
  local s="$1"
  # Remove the harmless redirect forms, then any remaining > or >( or >> means
  # a write to a real file (or a process substitution that writes).
  local r="$s"
  r="${r//2>\/dev\/null/}"
  r="${r//\&>\/dev\/null/}"
  r="${r//>\/dev\/null/}"
  r="${r//2>&1/}"
  r="${r//1>&2/}"
  r="${r//>&2/}"
  [[ "$r" == *'>'* ]] && return 0
  # Process substitution that reads (<(...)) can run anything inside it.
  [[ "$s" == *'<('* ]] && return 0
  # Write-capable flags on otherwise-read-only commands, and shell-escape hatches.
  local patterns='(\btee\b|\bsudo\b|\beval\b|\bsource\b|\bexec\b|[[:space:]]-exec\b|[[:space:]]-execdir\b|[[:space:]]-delete\b|[[:space:]]-ok\b|[[:space:]]-okdir\b|[[:space:]]-fls\b|[[:space:]]-fprint|\bsort\b[^|;&]*[[:space:]]-o\b|\byq\b[^|;&]*[[:space:]]-i\b|system\()'
  printf '%s' "$s" | grep -qE "$patterns" && return 0
  return 1
}

# Validate one pipeline/sequence segment: its leading command (after env-var
# assignments) must be read-only, or a read-only git/gh/xargs invocation.
validate_segment() {
  local seg="$1"
  # Trim leading whitespace.
  seg="${seg#"${seg%%[![:space:]]*}"}"
  [[ -n "$seg" ]] || return 0
  local toks
  read -ra toks <<<"$seg"
  local n=${#toks[@]} i=0
  # Skip leading VAR=value assignments.
  while [[ $i -lt $n && "${toks[$i]}" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; do ((i++)); done
  [[ $i -lt $n ]] || return 0
  local cmd
  cmd=$(normalize_cmd "${toks[$i]}")
  [[ -n "$cmd" ]] || return 0

  case "$cmd" in
    git)
      # Find the subcommand, skipping global options (and the arg of those
      # that take one).
      local j=$((i + 1))
      while [[ $j -lt $n ]]; do
        case "${toks[$j]}" in
          -C | --git-dir | --work-tree | --namespace | -c)
            ((j += 2)) ;;
          -*) ((j++)) ;;
          *) break ;;
        esac
      done
      [[ $j -lt $n ]] && is_read_only_git_sub "$(normalize_cmd "${toks[$j]}")"
      return $?
      ;;
    gh)
      # gh <noun> <verb>: approve only read verbs.
      local noun="${toks[$((i + 1))]:-}" verb="${toks[$((i + 2))]:-}"
      case "$noun $verb" in
        "pr view" | "pr list" | "pr diff" | "pr checks" | "pr status" | \
          "issue view" | "issue list" | "run view" | "run list" | "run watch" | \
          "repo view" | "release view" | "release list" | "workflow view" | "workflow list")
          return 0 ;;
        *) return 1 ;;
      esac
      ;;
    xargs)
      # The real command is the first token after xargs that isn't an option,
      # an option value, or the {} replacement string.
      local j=$((i + 1))
      while [[ $j -lt $n ]]; do
        case "${toks[$j]}" in
          -I | -i | -n | -P | -L | -s | -d | -E | -a | --max-args | --max-procs | \
            --replace | --delimiter | --max-lines | --arg-file)
            ((j += 2)) ;;
          --) ((j++)); break ;;
          -*) ((j++)) ;;
          '{}') ((j++)) ;;
          *) break ;;
        esac
      done
      [[ $j -lt $n ]] && is_read_only_cmd "$(normalize_cmd "${toks[$j]}")"
      return $?
      ;;
    *)
      is_read_only_cmd "$cmd"
      return $?
      ;;
  esac
}

# Validate a full command string: strip quoted data, reject write side effects,
# then require every operator-separated segment to be read-only.
validate_string() {
  local s="$1"
  # Quoted strings are data, not commands; remove them so embedded operators
  # and metacharacters don't confuse segmentation. (Command substitutions are
  # extracted and removed by the caller before this runs.)
  s=$(printf '%s' "$s" | sed -E 's/"[^"]*"/ /g')
  s=$(printf '%s' "$s" | sed "s/'[^']*'/ /g")
  is_forbidden "$s" && return 1
  # Split on pipeline/sequence operators into one segment per line.
  local segs
  segs=$(printf '%s' "$s" | sed -E 's/\|\|/\n/g; s/&&/\n/g; s/;/\n/g; s/\|&/\n/g; s/\|/\n/g')
  local line
  while IFS= read -r line; do
    validate_segment "$line" || return 1
  done <<<"$segs"
  return 0
}

# Validate and then strip $(...) command substitutions. A nested $( inside a
# substitution, or an unbalanced one, means we can't parse it confidently.
subs=$(printf '%s' "$command" | grep -oE '\$\([^)]*\)' || true)
if [[ -n "$subs" ]]; then
  while IFS= read -r sub; do
    [[ -n "$sub" ]] || continue
    inner="${sub#\$(}"
    inner="${inner%)}"
    [[ "$inner" == *'$('* ]] && exit 0
    validate_string "$inner" || exit 0
  done <<<"$subs"
fi
stripped=$(printf '%s' "$command" | sed -E 's/\$\([^)]*\)/ /g')
[[ "$stripped" == *'$('* ]] && exit 0

validate_string "$stripped" || exit 0

# Every segment is read-only: auto-approve.
jq -n '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "allow", permissionDecisionReason: "All pipeline segments are read-only (allow-shell-reads hook)."}}'
exit 0
