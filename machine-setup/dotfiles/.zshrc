# Enable color output for ls
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Claude Code: disable terminal flicker
export CLAUDE_CODE_NO_FLICKER=1

# Aliases
alias ls='ls -GpFh'
alias cloyo='claude --dangerously-skip-permissions'

# Kill all dev servers
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
setopt interactivecomments
PROMPT="${BGREEN}(${GREEN}%~ ${RED}\$(parse_git_branch)${BGREEN}) ${BLUE}%# ${NORMAL}"

# Load Homebrew environment
if [ -x /opt/homebrew/bin/brew ]; then
  export HOMEBREW_PREFIX=/opt/homebrew
elif [ -x /usr/local/bin/brew ]; then
  export HOMEBREW_PREFIX=/usr/local
fi
if [ -n "$HOMEBREW_PREFIX" ]; then
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

# Latest Ruby. Hardcoded rather than $(brew --prefix ruby): each brew --prefix
# call spawns a process and costs ~45ms of startup.
[ -d "$HOMEBREW_PREFIX/opt/ruby/bin" ] && export PATH="$HOMEBREW_PREFIX/opt/ruby/bin:$PATH"

# PostgreSQL tools
[ -d "$HOMEBREW_PREFIX/opt/libpq/bin" ] && export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"

# Java - use Android Studio's embedded JDK
if [ -d "/Applications/Android Studio.app/Contents/jbr/Contents/Home" ]; then
  export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
  export PATH="$JAVA_HOME/bin:$PATH"
fi

# Android SDK
if [ -d "$HOME/Library/Android/sdk" ]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH"
fi

# pipx and other user-local binaries
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# Node via nvm.
#
# Sourcing nvm.sh plainly costs ~820ms per shell, because nvm resolves the
# `default` alias and validates the version on every startup. Two things avoid
# that: --no-use skips the automatic `nvm use`, and the default version goes on
# PATH by reading the alias file directly.
#
# This requires `default` to be a concrete version, not a moving alias:
#   nvm alias default 24.18.0     # fast
#   nvm alias default lts/*       # slow, forces nvm to resolve it every shell
# If the alias is not concrete the fallback below still works, but pays the cost.
export NVM_DIR="$HOME/.nvm"
for _nvm_sh in "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" "$NVM_DIR/nvm.sh"; do
  if [ -s "$_nvm_sh" ]; then
    source "$_nvm_sh" --no-use
    break
  fi
done
unset _nvm_sh

if command -v nvm >/dev/null 2>&1; then
  _nvm_default=""
  [ -r "$NVM_DIR/alias/default" ] && _nvm_default="$(<"$NVM_DIR/alias/default")"
  if [ -d "$NVM_DIR/versions/node/v${_nvm_default#v}/bin" ]; then
    export PATH="$NVM_DIR/versions/node/v${_nvm_default#v}/bin:$PATH"
  else
    # Alias is a moving target (lts/*, node, a named alias) or the version is
    # gone. Fall back to nvm's own resolution so node is still on PATH.
    nvm use default --silent >/dev/null 2>&1
  fi
  unset _nvm_default
fi

# Auto-switch Node version when entering a directory with .nvmrc.
# The .nvmrc lookup uses shell builtins so directories without one never invoke
# nvm, which is the expensive path.
autoload -U add-zsh-hook
_find_nvmrc() {
  local dir="${1:-$PWD}"
  while [ -n "$dir" ] && [ "$dir" != "/" ]; do
    [ -e "$dir/.nvmrc" ] && { print -r -- "$dir/.nvmrc"; return 0; }
    dir="${dir:h}"
  done
  return 1
}
load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(_find_nvmrc)"
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use --silent
    fi
    _NVM_SWITCHED=1
  elif [ -n "$_NVM_SWITCHED" ]; then
    # Only revert when a previous directory actually switched us off default.
    nvm use default --silent
    unset _NVM_SWITCHED
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Docker CLI completions
if [ -d "$HOME/.docker/completions" ]; then
  fpath=("$HOME/.docker/completions" $fpath)
fi

# Completions. compinit's security audit and dump rebuild cost ~230ms, so the
# cached dump is reused and only fully rebuilt once a day.
autoload -Uz compinit
zmodload -F zsh/stat b:zstat
zmodload zsh/datetime
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -f "$_zcompdump" ]] \
  && zstat -A _zcompdump_mtime +mtime "$_zcompdump" 2>/dev/null \
  && (( EPOCHSECONDS - _zcompdump_mtime < 86400 )); then
  compinit -C -d "$_zcompdump"
else
  compinit -d "$_zcompdump"
fi
unset _zcompdump _zcompdump_mtime

# Ghostty: change background color based on working directory
if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
  _ghostty_update_bg() {
    case "$PWD" in
      "$HOME"/Developer/brain|"$HOME"/Developer/brain/*)
        # Warm dark tint for the brain repo
        printf "\033]11;#1a1b2e\007"
        ;;
      *)
        # Default Catppuccin Mocha background
        printf "\033]11;#1e1e2e\007"
        ;;
    esac
  }
  chpwd_functions+=(_ghostty_update_bg)
  _ghostty_update_bg
fi

# Load private machine-specific configuration
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local

# command prompt for remote server connections
if [[ -n "${SSH_CONNECTION:-}" ]]; then
  PROMPT='%F{yellow}[home-server]%f %F{cyan}%~%f %# '
fi
