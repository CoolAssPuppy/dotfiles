#!/usr/bin/env bash
#
# sync-agent-skills.sh — moved.
#
# This script used to publish skills from two canonical directories,
# dotfiles/claude/skills and brain/.claude/skills. There is one canonical
# directory now, ~/Developer/brain/skills, and its installer lives beside it:
#
#     ~/Developer/brain/scripts/link-skills.sh
#
# Skills are no longer authored in this repo. dotfiles/claude/skills is a
# directory of symlinks that the installer creates, the same as ~/.claude/skills
# and ~/.agents/skills.
#
# Kept as a forwarding shim so existing invocations and any script that calls
# this path keep working. Every argument is passed straight through.
#
# Read ../README-agent-skills.md for the layout.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BRAIN="${BRAIN:-$(cd "$REPO_ROOT/.." && pwd)/brain}"
INSTALLER="$BRAIN/scripts/link-skills.sh"

if [ ! -x "$INSTALLER" ]; then
  echo "error: the skill installer is not at $INSTALLER" >&2
  echo "       Clone the brain repo next to dotfiles, or set BRAIN to its path." >&2
  exit 2
fi

echo "sync-agent-skills.sh now forwards to $INSTALLER"
echo ""

# --adopt-identical was an option of the old script and has no equivalent: the
# installer never replaces a real directory, identical contents or not.
ARGS=()
for arg in "$@"; do
  case "$arg" in
    --adopt-identical)
      echo "note: --adopt-identical is gone. The installer reports a real directory"
      echo "      sitting in a target and leaves it alone. Move it yourself, then rerun."
      echo "" ;;
    --target-claude|--target-codex)
      echo "note: $arg is gone. Use --target PATH, which is repeatable."
      echo "" ;;
    *) ARGS[${#ARGS[@]}]="$arg" ;;
  esac
done

exec "$INSTALLER" ${ARGS[@]+"${ARGS[@]}"}
