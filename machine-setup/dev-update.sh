#!/usr/bin/env bash
set -euo pipefail

# Require Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install Homebrew first: https://brew.sh"
  exit 1
fi

echo "Updating Homebrew metadata..."
brew update

update_brew_formula() {
  local formula="$1"
  if brew list --formula --versions "$formula" >/dev/null 2>&1; then
    echo "Upgrading $formula via Homebrew..."
    brew upgrade "$formula" || true
  else
    echo "$formula is not managed by Homebrew. Skipping."
  fi
}

# Supabase CLI
update_brew_formula "supabase/tap/supabase"

# Doppler CLI
update_brew_formula "dopplerhq/cli/doppler"

# Vercel CLI
if brew list --formula --versions vercel-cli >/dev/null 2>&1; then
  echo "Upgrading vercel-cli via Homebrew..."
  brew upgrade vercel-cli || true
else
  if command -v vercel >/dev/null 2>&1; then
    if command -v pnpm >/dev/null 2>&1; then
      echo "Updating Vercel via pnpm global..."
      pnpm add -g vercel@latest || true
    elif command -v npm >/dev/null 2>&1; then
      echo "Updating Vercel via npm global..."
      npm -g install vercel@latest || true
    else
      echo "Neither pnpm nor npm found to update Vercel outside Homebrew."
    fi
  else
    echo "Vercel CLI not found."
  fi
fi

# Claude Code for VS Code
if command -v code >/dev/null 2>&1; then
  echo "Updating Claude Code extension..."
  code --install-extension anthropic.claude --force || code --install-extension anthropic.claude-dev --force || true
fi

echo
echo "Versions after update:"
command -v supabase >/dev/null 2>&1 && supabase --version || echo "supabase not found"
command -v doppler  >/dev/null 2>&1 && doppler  --version || echo "doppler not found"
command -v vercel   >/dev/null 2>&1 && vercel   --version || echo "vercel not found"

