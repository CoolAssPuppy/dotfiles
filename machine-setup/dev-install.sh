#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BRAIN="${BRAIN:-$(cd "$REPO_ROOT/.." && pwd)/brain}"
DOTFILES="$SCRIPT_DIR/dotfiles"

# shellcheck source=lib.sh
. "$SCRIPT_DIR/lib.sh"

if [[ -d "/opt/homebrew" ]]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
fi

install_xcode_tools() {
  xcode-select -p >/dev/null 2>&1 || xcode-select --install
}
step "Xcode command line tools" install_xcode_tools

"$SCRIPT_DIR/brew-sync.sh"

mkdir -p "$HOME/.zshrc.d" "$HOME/.nvm" "$HOME/.ssh" "$HOME/.config/zed" "$HOME/.config/ghostty"

BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link_dotfile() {
  local src="$1" dst="$2"
  if [[ -L "$dst" ]]; then
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    mkdir -p "$BACKUP/$(dirname "${dst#"$HOME"/}")"
    mv "$dst" "$BACKUP/${dst#"$HOME"/}"
    echo "Backed up $dst to $BACKUP/${dst#"$HOME"/}"
  fi
  ln -s "$src" "$dst"
}

link_all_dotfiles() {
  link_dotfile "$DOTFILES/.zshrc"                   "$HOME/.zshrc"
  link_dotfile "$DOTFILES/.bash_profile"            "$HOME/.bash_profile"
  link_dotfile "$DOTFILES/.gitconfig"               "$HOME/.gitconfig"
  link_dotfile "$DOTFILES/config"                   "$HOME/.ssh/config"
  link_dotfile "$DOTFILES/zed/settings.json"        "$HOME/.config/zed/settings.json"
  link_dotfile "$DOTFILES/ghostty/config"           "$HOME/.config/ghostty/config"
  link_dotfile "$DOTFILES/ghostty/ghostty-layout.sh" "$HOME/.config/ghostty/ghostty-layout.sh"
}
step "Shell, git, ssh, zed and ghostty dotfiles" link_all_dotfiles

step "Claude Code config" "$REPO_ROOT/claude/setup.sh"

if [[ -d "$BRAIN" ]]; then
  link_brain() { ln -sfn ../dotfiles/claude/work-prompts "$BRAIN/work-prompts"; }
  step "Brain repo work-prompts" link_brain
  step "Codex mirror" "$SCRIPT_DIR/link-codex.sh"
else
  fail "Brain repo not found at $BRAIN"
  note "  Clone it beside dotfiles and re-run to link skills and prompts."
fi

export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && . "$BREW_PREFIX/opt/nvm/nvm.sh"

setup_node() {
  nvm install --lts
  nvm alias default 'lts/*'
  nvm use default
}
step "Node LTS via nvm" setup_node

setup_pnpm() {
  command -v corepack >/dev/null 2>&1 || return 0
  corepack enable
  corepack prepare pnpm@latest --activate
}
step "pnpm via corepack" setup_pnpm

step "pipx path" pipx ensurepath

echo
version "node    " node -v
version "pnpm    " pnpm -v
version "python  " python3 --version
version "gh      " gh --version
version "supabase" supabase --version
version "vercel  " vercel --version
version "doppler " doppler --version
version "stripe  " stripe --version

echo
note "Setup complete. Open a new terminal or run: source ~/.zshrc"
