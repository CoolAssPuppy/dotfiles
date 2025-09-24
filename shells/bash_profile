# color version of ls
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# silence the warning message from macOS
export BASH_SILENCE_DEPRECATION_WARNING=1

# aliases ls
alias ls='ls -GpFh'

# git directory
function parse_git_branch {
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

# colors
BGREEN='\[\033[1;32m\]'
GREEN='\[\033[0;32m\]'
BRED='\[\033[1;31m\]'
RED='\[\033[0;31m\]'
BBLUE='\[\033[1;34m\]'
BLUE='\[\033[0;34m\]'
NORMAL='\[\033[00m\]'

# prompt
PS1="${BGREEN}(${GREEN}\w${BGREEN} ${RED}\$(parse_git_branch)${BGREEN}) ${BLUE}\$ ${NORMAL}"

# Load Homebrew environment
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load PostgreSQL tools
export PATH="$(brew --prefix libpq)/bin:$PATH"

# Load NVM (installed via Homebrew)
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

# Automatically switch to latest installed Node version
nvm use node &> /dev/null
