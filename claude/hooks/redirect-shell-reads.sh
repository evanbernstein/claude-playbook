#!/usr/bin/env bash
# Compatibility shim. The hook moved to allow-shell-reads.sh; settings.json now
# points there. This file only exists so a session that started while the
# PreToolUse entry still referenced this path keeps working until its next
# restart. Safe to delete once no running session references it.
exec bash "$(dirname "$0")/allow-shell-reads.sh"
