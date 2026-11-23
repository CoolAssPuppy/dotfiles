#!/usr/bin/env bash
# Clone missing repositories and install local dependencies. Never pull existing work.
set -euo pipefail
case "${1:-}" in
  --plan)
    for repo in futurenerds tripmaster mail-notifier meeting-notifier ship; do
      echo "Prepare CoolAssPuppy/$repo"
    done
    echo 'No repositories or services changed.'
    exit 0 ;;
  '') ;;
  *) echo 'Usage: prepare-projects.sh [--plan]' >&2; exit 2 ;;
esac
command -v gh >/dev/null || { echo 'Run dev-install.sh first.' >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo 'Run gh auth login first.' >&2; exit 1; }
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
. "$(brew --prefix nvm)/nvm.sh"
mkdir -p "$HOME/Developer/utils"
for repo in futurenerds tripmaster mail-notifier meeting-notifier ship; do
  destination="$HOME/Developer/$repo"
  [[ "$repo" == ship ]] && destination="$HOME/Developer/utils/ship"
  if [[ ! -e "$destination" ]]; then
    gh repo clone "CoolAssPuppy/$repo" "$destination"
  fi
  git -C "$destination" rev-parse --is-inside-work-tree >/dev/null
  origin="$(git -C "$destination" remote get-url origin)"
  case "$origin" in
    "https://github.com/CoolAssPuppy/$repo"|"https://github.com/CoolAssPuppy/$repo.git"|"git@github.com:CoolAssPuppy/$repo.git") ;;
    *) echo "Unexpected origin in $destination; stopping." >&2; exit 1 ;;
  esac
  if [[ -n "$(git -C "$destination" status --porcelain)" ]]; then
    echo "$destination has local changes; leave them intact and prepare this project manually." >&2
    exit 1
  fi
  (
    cd "$destination"
    if [[ -f package.json ]]; then
      if [[ -f .nvmrc ]]; then nvm install; else nvm install 24; fi
      command -v pnpm >/dev/null || npm install --global pnpm@11.1.0
      pnpm install --frozen-lockfile
    fi
    if [[ "$repo" == ship ]]; then
      uv tool install --editable "$destination"
    fi
  )
  echo "Prepared $destination; existing branches were not updated."
done
echo 'Use each project’s documented setup and verification commands next. No tests, databases, or releases were started.'
