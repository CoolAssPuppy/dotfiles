#!/usr/bin/env bash
set -euo pipefail

# Repo-relative Brewfile
BREWFILE="$(cd "$(dirname "$0")" && pwd)/machine-setup/Brewfile"
[[ -f "$BREWFILE" ]] || { echo "Brewfile not found at $BREWFILE"; exit 1; }

# Xcode Command Line Tools
xcode-select -p >/dev/null 2>&1 || xcode-select --install || true

# Homebrew bundle
brew update
brew bundle --file="$BREWFILE"

# Detect Homebrew prefix
if [[ -d "/opt/homebrew" ]]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
fi

# Shell config for nvm
mkdir -p "$HOME/.zshrc.d" "$HOME/.nvm"
ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"
if ! grep -Fq '~/.zshrc.d/*' "$ZSHRC"; then
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

# Load nvm in this shell
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && . "$BREW_PREFIX/opt/nvm/nvm.sh"

# Node via nvm
nvm install --lts
nvm alias default 'lts/*'
nvm use default

# pnpm via Corepack
corepack enable
corepack prepare pnpm@latest --activate

# Python basics
# python@3.13 and pipx are installed via Homebrew
pipx ensurepath || true

# Git sane defaults
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global color.ui auto

echo "Versions:"
node -v || true
npm -v || true
pnpm -v || true
python3 --version || true
pipx --version || true
supabase --version || true
vercel --version || true
doppler --version || true

echo "Done. Open a new terminal or run: source ~/.zshrc"

