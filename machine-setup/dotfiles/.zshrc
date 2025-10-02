# Enable color output for ls
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Silence macOS zsh warning (BASH_SILENCE_DEPRECATION_WARNING is Bash-specific, not needed in zsh)

# Aliases
alias ls='ls -GpFh'

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
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load PostgreSQL tools
export PATH="$(brew --prefix libpq)/bin:$PATH"

# Load NVM (installed via Homebrew)
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"

# Automatically switch to latest installed Node version
nvm use node &> /dev/null
