# Enable color output for ls
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

export CLAUDE_CODE_NO_FLICKER=1

# Aliases
alias ls='ls -GpFh'
alias cloyo='claude --dangerously-skip-permissions'
alias killdev='lsof -ti:3000,3001,3002,4000,5000,5173,8000,8080 2>/dev/null | xargs kill -9 2>/dev/null; pkill -f "next dev" 2>/dev/null; pkill -f "turbo dev" 2>/dev/null; pkill -f "vite" 2>/dev/null; echo "Dev servers killed"'

# Git branch in prompt
parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# gitsync helper function
gitsync() {
  # Show git status
  git status

  # Stage all changes
  git add .

  # Use provided commit message or fallback
  COMMIT_MSG="${1:-test message}"
  git commit -m "$COMMIT_MSG"

  # Get current branch name
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

  # Switch to main, merge current, push, and switch back
  git checkout main
  git merge "$CURRENT_BRANCH"
  git push origin main
  git checkout "$CURRENT_BRANCH"
}

# Colors
BGREEN="%F{green}"
GREEN="%F{green}"
BRED="%F{red}"
RED="%F{red}"
BBLUE="%F{blue}"
BLUE="%F{blue}"
NORMAL="%f"

# Prompt
setopt PROMPT_SUBST
PROMPT="${BGREEN}(${GREEN}%~ ${RED}\$(parse_git_branch)${BGREEN}) ${BLUE}%# ${NORMAL}"

# Load Homebrew environment
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Load PostgreSQL tools
export PATH="$(brew --prefix libpq)/bin:$PATH"

# Latest Ruby
export PATH="$(brew --prefix ruby)/bin:$PATH"

# pipx and other user-local binaries
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# Load NVM (installed via Homebrew)
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && source "$(brew --prefix nvm)/nvm.sh"

# Auto-switch Node version when entering a directory with .nvmrc
autoload -U add-zsh-hook
load-nvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use --silent
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    nvm use default --silent
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Docker CLI completions
if [ -d "$HOME/.docker/completions" ]; then
  fpath=("$HOME/.docker/completions" $fpath)
fi
autoload -Uz compinit
compinit

# Machine-specific config, not tracked in dotfiles
for f in ~/.zshrc.d/*.zsh(N); do [ -r "$f" ] && . "$f"; done
setopt interactivecomments

# command prompt for remote server connections
  if [[ -n "${SSH_CONNECTION:-}" ]]; then
    PROMPT='%F{yellow}[home-server]%f %F{cyan}%~%f %# '
  fi

