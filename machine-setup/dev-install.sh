#!/usr/bin/env bash
set -euo pipefail

# Resolve paths relative to this script, regardless of current working directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BREWFILE="$SCRIPT_DIR/Brewfile"

if [[ ! -f "$BREWFILE" ]]; then
  echo "Brewfile not found at: $BREWFILE"
  exit 1
fi

# Require Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install it first from https://brew.sh"
  exit 1
fi

# Xcode Command Line Tools (no-op if already installed)
xcode-select -p >/dev/null 2>&1 || xcode-select --install || true

# Install from Brewfile
brew update
brew bundle --file="$BREWFILE"

# Detect Homebrew prefix for Apple Silicon vs Intel
if [[ -d "/opt/homebrew" ]]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
fi

# Shell config loader and nvm setup
mkdir -p "$HOME/.zshrc.d" "$HOME/.nvm"
ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"
if ! grep -Fq 'for f in ~/.zshrc.d/*' "$ZSHRC"; then
  {
    echo ""
    echo "# Load per-tool config"
    echo 'for f in ~/.zshrc.d/*; do [ -r "$f" ] && . "$f"; done'
  } >> "$ZSHRC"
fi

cat > "$HOME/.zshrc.d/nvm.zsh" <<EOF
export NVM_DIR="\$HOME/.nvm"
[ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && . "$BREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
EOF

# Load nvm for this shell
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && . "$BREW_PREFIX/opt/nvm/nvm.sh"

# Node via nvm
nvm install --lts
nvm alias default 'lts/*'
nvm use default

# pnpm via Corepack
if command -v corepack >/dev/null 2>&1; then
  corepack enable
  corepack prepare pnpm@latest --activate
fi

# Python basics (python@3.13 and pipx came from Brewfile)
pipx ensurepath || true

# Git defaults
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global color.ui auto

# Claude Code for VS Code
if command -v code >/dev/null 2>&1; then
  code --install-extension anthropic.claude || code --install-extension anthropic.claude-dev || true
fi

echo
echo "Versions:"
command -v node    >/dev/null 2>&1 && node -v    || echo "node not found"
command -v npm     >/dev/null 2>&1 && npm -v     || echo "npm not found"
command -v pnpm    >/dev/null 2>&1 && pnpm -v    || echo "pnpm not found"
command -v python3 >/dev/null 2>&1 && python3 --version || echo "python3 not found"
command -v pipx    >/dev/null 2>&1 && pipx --version   || echo "pipx not found"
command -v supabase>/dev/null 2>&1 && supabase --version || echo "supabase not found"
command -v vercel  >/dev/null 2>&1 && vercel --version   || echo "vercel not found"
command -v doppler >/dev/null 2>&1 && doppler --version  || echo "doppler not found"

echo
echo "Setup complete. Open a new terminal or run: source ~/.zshrc"

