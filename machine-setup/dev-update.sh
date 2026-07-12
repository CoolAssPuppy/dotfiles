#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BRAIN="${BRAIN:-$(cd "$REPO_ROOT/.." && pwd)/brain}"

# shellcheck source=lib.sh
. "$SCRIPT_DIR/lib.sh"

"$SCRIPT_DIR/brew-sync.sh"

step "Homebrew cleanup" brew cleanup

if [[ -d "$BRAIN" ]]; then
  step "Codex mirror" "$SCRIPT_DIR/link-codex.sh"
fi

echo
version "node    " node -v
version "pnpm    " pnpm -v
version "gh      " gh --version
version "supabase" supabase --version
version "vercel  " vercel --version
version "doppler " doppler --version
version "stripe  " stripe --version
