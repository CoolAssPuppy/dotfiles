# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:$HOME/.docker/bin"
# End of Docker Desktop section.

# Tools needed by login shells, including remote build commands.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
export NVM_DIR="$HOME/.nvm"
if [[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]]; then
  source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
fi
if [[ -r "$HOME/.zshrc.d/dev-tools.zsh" ]]; then
  source "$HOME/.zshrc.d/dev-tools.zsh"
fi
export PATH="$HOME/.local/bin:$PATH"
