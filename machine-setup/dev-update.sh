#!/usr/bin/env bash
set -euo pipefail

# Ensure Homebrew exists
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
    echo "$formula not managed by Homebrew. Skipping Homebrew upgrade for $formula."
  fi
}

# Supabase CLI (Homebrew)
update_brew_formula "supabase/tap/supabase"

# Doppler CLI (Homebrew)
update_brew_formula "dopplerhq/cli/doppler"

# Vercel CLI: prefer Homebrew if managed there; otherwise fall back to npm global
if brew list --formula --versions vercel-cli >/dev/null 2>&1; then
  echo "Upgrading vercel-cli via Homebrew..."
  brew upgrade vercel-cli || true
else
  if command -v vercel >/dev/null 2>&1; then
    if command -v npm >/dev/null 2>&1; then
      echo "Updating vercel (npm global) to latest..."
      npm -g install vercel@latest || true
    else
      echo "npm not found, cannot update Vercel installed outside Homebrew."
    fi
  else
    echo "Vercel CLI not found in PATH."
  fi
fi

echo
echo "Versions after update:"
command -v supabase >/dev/null 2>&1 && supabase --version || echo "supabase not found"
command -v doppler  >/dev/null 2>&1 && doppler  --version || echo "doppler not found"
command -v vercel   >/dev/null 2>&1 && vercel   --version || echo "vercel not found"

