#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BREWFILE="$SCRIPT_DIR/Brewfile"

# shellcheck source=lib.sh
. "$SCRIPT_DIR/lib.sh"

if [[ ! -f "$BREWFILE" ]]; then
  fail "Brewfile not found at $BREWFILE"
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  fail "Homebrew not found. Install it first from https://brew.sh"
  exit 1
fi

step "Homebrew metadata" brew update

trust_taps() {
  brew trust --help >/dev/null 2>&1 || return 0
  while read -r tap_name; do
    brew trust --tap "$tap_name"
  done < <(sed -n 's/^tap "\([^"]*\)".*/\1/p' "$BREWFILE")
}
step "Trust third-party taps" trust_taps

step "Packages from Brewfile" brew bundle --file="$BREWFILE"
