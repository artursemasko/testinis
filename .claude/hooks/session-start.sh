#!/bin/bash
# Installs claude-mem (if missing) and starts its worker in cloud sessions.
set -euo pipefail
[ "${CLAUDE_CODE_REMOTE:-}" = "true" ] || exit 0

command -v claude-mem >/dev/null 2>&1 || npm install -g claude-mem

if [ ! -d "$HOME/.claude/plugins/marketplaces/thedotmack" ]; then
  claude-mem install --ide claude-code --provider claude --no-auto-start </dev/null
fi

claude-mem start || true
