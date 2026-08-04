#!/usr/bin/env bash
set -euo pipefail

# Symlink authored Claude Code config from dotfiles to ~/.claude/
# Safe to run multiple times. Backs up existing content before replacing.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.claude"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$TARGET_DIR/backups/pre-symlink-$TIMESTAMP"
BACKED_UP=false

# "skills" is deliberately absent. Linking the whole directory would make
# ~/.claude/skills an alias for this repo, leaving no room for the skills that
# live in ~/Developer/brain/.claude/skills and no way to publish either set to
# Codex. scripts/sync-agent-skills.sh links skills individually instead, and
# runs at the end of this script.
ITEMS=(
  "CLAUDE.md"
  "agents"
  "commands"
  "docs"
  "rules"
)

backup() {
  if [ "$BACKED_UP" = false ]; then
    mkdir -p "$BACKUP_DIR"
    BACKED_UP=true
  fi
  mv "$1" "$BACKUP_DIR/$(basename "$1")"
  echo "  Backed up to $BACKUP_DIR/$(basename "$1")"
}

echo "Setting up symlinks: $SCRIPT_DIR -> $TARGET_DIR"
echo ""

for item in "${ITEMS[@]}"; do
  source="$SCRIPT_DIR/$item"
  target="$TARGET_DIR/$item"

  if [ ! -e "$source" ]; then
    echo "SKIP $item (not found in dotfiles)"
    continue
  fi

  # Already a correct symlink
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    echo "OK   $item (already linked)"
    continue
  fi

  # Exists as file, directory, or wrong symlink: back it up
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "LINK $item (backing up existing)"
    backup "$target"
  else
    echo "LINK $item (new)"
  fi

  ln -s "$source" "$target"
done

echo ""
echo "Done. Verifying symlinks:"
echo ""

errors=0
for item in "${ITEMS[@]}"; do
  target="$TARGET_DIR/$item"
  if [ -L "$target" ] && [ -e "$target" ]; then
    echo "  OK $item -> $(readlink "$target")"
  else
    echo "  FAIL $item"
    errors=$((errors + 1))
  fi
done

if [ "$errors" -gt 0 ]; then
  echo ""
  echo "$errors symlink(s) failed."
  exit 1
fi

echo ""
echo "All symlinks verified."

SYNC_SKILLS="$SCRIPT_DIR/../scripts/sync-agent-skills.sh"
if [ -x "$SYNC_SKILLS" ]; then
  echo ""
  # A nonzero exit means unresolved duplicates or target collisions, which are
  # reported in full. Neither should stop the rest of the setup.
  "$SYNC_SKILLS" || echo "Skill sync finished with items needing a decision. See above."
else
  echo ""
  echo "SKIP skills (scripts/sync-agent-skills.sh not found or not executable)"
fi
