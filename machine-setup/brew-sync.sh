#!/usr/bin/env bash
# Runs under macOS's stock bash 3.2 on a fresh machine, before the Brewfile has
# installed bash 5. Keep this file free of mapfile, associative arrays and other
# bash 4+ features.
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
  sed -n 's/^tap "\([^"]*\)".*/\1/p' "$BREWFILE" | while read -r name; do
    brew trust --tap "$name"
  done
}
step "Trust third-party taps" trust_taps

entries() { sed -n "s/^$1 \"\([^\"]*\)\".*/\1/p" "$BREWFILE"; }

have_formulae="$(brew list --formula -1 2>/dev/null || true)"
have_casks="$(brew list --cask -1 2>/dev/null || true)"
have_vscode="$(command -v code >/dev/null 2>&1 && code --list-extensions 2>/dev/null || true)"
outdated="$(brew outdated --quiet 2>/dev/null || true)"

missing() {
  # $1 = newline-separated installed list. Reads wanted names on stdin.
  local installed="$1" want
  while read -r want; do
    [ -n "$want" ] || continue
    grep -qxF "${want##*/}" <<<"$installed" || printf '%s\n' "$want"
  done
}

new_formulae="$(entries brew   | missing "$have_formulae")"
new_casks="$(entries cask      | missing "$have_casks")"
new_vscode="$(entries vscode   | missing "$have_vscode")"

# Only upgrade things the Brewfile actually asks for.
wanted_names="$( { entries brew; entries cask; } | sed 's|.*/||' )"
upgrades="$(printf '%s\n' $outdated | while read -r o; do
  [ -n "$o" ] && grep -qxF "$o" <<<"$wanted_names" && printf '%s\n' "$o"
done)"

count() { [ -z "$1" ] && echo 0 || printf '%s\n' "$1" | wc -l | tr -d ' '; }
n_formulae=$(count "$new_formulae")
n_casks=$(count "$new_casks")
n_vscode=$(count "$new_vscode")
n_upgrades=$(count "$upgrades")
total=$(( n_formulae + n_casks + n_vscode + n_upgrades ))

if [ "$total" -eq 0 ]; then
  ok "Brewfile is already installed and current"
  exit 0
fi

oneline() { printf '%s\n' "$1" | sed 's|.*/||' | tr '\n' ' '; }

echo
note "Plan"
[ "$n_formulae" -gt 0 ] && note "  $n_formulae formulae:   $(oneline "$new_formulae")"
[ "$n_casks"    -gt 0 ] && note "  $n_casks apps:       $(oneline "$new_casks")"
[ "$n_upgrades" -gt 0 ] && note "  $n_upgrades upgrades:   $(oneline "$upgrades")"
[ "$n_vscode"   -gt 0 ] && note "  $n_vscode VS Code extensions"
echo

# Casks install into /Applications, which needs admin rights. Ask once, up
# front, with a reason, instead of springing a bare Password: prompt in the
# middle of an otherwise silent step.
if [ "$n_casks" -gt 0 ]; then
  note "Installing apps into /Applications needs your admin password."
  sudo -v
  while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit 0; done 2>/dev/null &
  keepalive=$!
  trap 'kill "$keepalive" 2>/dev/null || true' EXIT
  echo
fi

# Names never contain spaces, so plain word splitting keeps these loops in the
# parent shell, where a failing step can still abort the run.
for f in $new_formulae; do
  step "Install ${f##*/}" brew install --formula "$f"
done

for c in $new_casks; do
  step "Install $c" brew install --cask "$c"
done

for o in $upgrades; do
  step "Upgrade $o" brew upgrade "$o"
done

if [ "$n_vscode" -gt 0 ]; then
  # VS Code leaves half-written temp dirs behind after an interrupted install,
  # and a later install of the same extension dies with ENOTEMPTY on rename.
  find "$HOME/.vscode/extensions" -maxdepth 1 -name '.*-*-*-*-*' -type d -exec rm -rf {} + 2>/dev/null || true

  # An extension that will not install is not worth failing the machine over.
  for e in $new_vscode; do
    soft_step "Extension $e" code --install-extension "$e"
  done

  if [ -n "${SOFT_FAILURES:-}" ]; then
    echo
    fail "Extensions that did not install: $SOFT_FAILURES"
    note "  Everything else is set up. Retry with: code --install-extension <id>"
  fi
fi
