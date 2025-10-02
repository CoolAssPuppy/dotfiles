#!/usr/bin/env bash
set -euo pipefail

ROOT="$(pwd)"
echo "Restoring development environment from $ROOT"

# 1) Xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install || true
  until xcode-select -p >/dev/null 2>&1; do sleep 5; done
fi

# 2) Rosetta (Apple Silicon only)
if [ "$(uname -m)" = "arm64" ]; then
  echo "Installing Rosetta..."
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license || true
fi

# 3) Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ "$(uname -m)" = "arm64" ]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# 4) Restore Brewfile
if [ -f "$ROOT/machine-setup/Brewfile" ]; then
  echo "Restoring Homebrew packages..."
  brew bundle --file="$ROOT/machine-setup/Brewfile"
fi

# 5) Restore shell
if [ -f "$ROOT/machine-setup/default-shell.txt" ]; then
  DESIRED_SHELL=$(cat "$ROOT/machine-setup/default-shell.txt")
  if [ -n "$DESIRED_SHELL" ] && [ "$SHELL" != "$DESIRED_SHELL" ] && [ -x "$DESIRED_SHELL" ]; then
    echo "Setting default shell to $DESIRED_SHELL"
    chsh -s "$DESIRED_SHELL"
  fi
fi

# 6) Restore dotfiles snapshot
if [ -d "$ROOT/machine-setup/dotfiles" ]; then
  echo "Copying dotfiles snapshot..."
  rsync -a "$ROOT/machine-setup/dotfiles/" ~/
fi

# 7) Custom: install CLAUDE.md and commands/
echo "Setting up ~/.claude..."
mkdir -p ~/.claude
cp "$ROOT/CLAUDE.md" ~/.claude/CLAUDE.md
rsync -a "$ROOT/commands/" ~/.claude/commands/

# 8) Custom: install shell configs
if [ -f "$ROOT/shells/bash_profile" ]; then
  echo "Installing ~/.bash_profile"
  cp "$ROOT/shells/bash_profile" ~/.bash_profile
fi
if [ -f "$ROOT/shells/zshrc" ]; then
  echo "Installing ~/.zshrc"
  cp "$ROOT/shells/zshrc" ~/.zshrc
fi

# 9) Restore git global config
if [ -f "$ROOT/machine-setup/git-global-config.txt" ]; then
  echo "Restoring git global config..."
  while IFS= read -r line; do
    KEY="${line%%=*}"
    VAL="${line#*=}"
    git config --global "$KEY" "$VAL"
  done < "$ROOT/machine-setup/git-global-config.txt"
fi

# 10) Node toolchains
if [ -f "$ROOT/machine-setup/nvm-versions.txt" ]; then
  echo "Restoring Node versions with nvm..."
  if ! command -v nvm >/dev/null 2>&1; then
    brew install nvm
    mkdir -p ~/.nvm
    {
      echo 'export NVM_DIR="$HOME/.nvm"'
      echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"'
    } >> ~/.zshrc
    . ~/.zshrc
  fi
  grep -E 'v[0-9]+\.[0-9]+' "$ROOT/machine-setup/nvm-versions.txt" | sed 's/->.*//' | tr -d ' *' | while read -r v; do
    nvm install "$v" || true
  done
fi

if [ -f "$ROOT/machine-setup/volta-list.txt" ]; then
  echo "Volta detected — install Volta and it will pin per repo."
  brew install volta || true
fi

if [ -f "$ROOT/machine-setup/asdf-tool-versions.txt" ]; then
  echo "asdf detected — install asdf and plugins as needed."
  brew install asdf || true
fi

# 11) Restore global Node packages
if [ -f "$ROOT/machine-setup/node-globals/npm-global.txt" ]; then
  echo "Restoring npm globals..."
  xargs -I {} npm install -g {} < "$ROOT/machine-setup/node-globals/npm-global.txt" || true
fi
if [ -f "$ROOT/machine-setup/node-globals/yarn-global.txt" ]; then
  echo "Restoring yarn globals..."
  xargs -I {} yarn global add {} < "$ROOT/machine-setup/node-globals/yarn-global.txt" || true
fi
if [ -f "$ROOT/machine-setup/node-globals/pnpm-global.txt" ]; then
  echo "Restoring pnpm globals..."
  xargs -I {} pnpm add -g {} < "$ROOT/machine-setup/node-globals/pnpm-global.txt" || true
fi

# 12) Doppler
if ! command -v doppler >/dev/null 2>&1; then
  echo "Installing Doppler..."
  brew install dopplerhq/cli/doppler
fi
echo "Run 'doppler login' to restore secrets."

echo "Restore complete."

