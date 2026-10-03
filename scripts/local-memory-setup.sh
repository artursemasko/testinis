#!/bin/bash
# Run on YOUR computer (macOS/Linux): keeps claude-mem data in ~/Dropbox/claude/memory.
set -euo pipefail

TARGET="${1:-$HOME/Dropbox/claude/memory}"
LINK="$HOME/.claude-mem"

command -v claude-mem >/dev/null 2>&1 || npm install -g claude-mem
[ -d "$HOME/.claude/plugins/marketplaces/thedotmack" ] || claude-mem install --ide claude-code --provider claude

claude-mem stop >/dev/null 2>&1 || true   # release the SQLite files before moving

mkdir -p "$TARGET"
if [ -L "$LINK" ]; then
  echo "$LINK is already a symlink -> $(readlink "$LINK")"
elif [ -d "$LINK" ]; then
  # keep existing data: copy into Dropbox without overwriting what is already there
  cp -an "$LINK"/. "$TARGET"/
  mv "$LINK" "$LINK.bak.$(date +%s)"
  ln -s "$TARGET" "$LINK"
else
  ln -s "$TARGET" "$LINK"
fi

claude-mem start
claude-mem status
echo "Memory now lives in: $TARGET"
