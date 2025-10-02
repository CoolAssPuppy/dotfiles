#!/usr/bin/env bash
set -euo pipefail

# Ensure output dir
mkdir -p "${PWD}/machine-setup/node-globals"
OUTDIR="${PWD}/machine-setup"

# 1) Brewfile
if command -v brew >/dev/null 2>&1; then
  brew update
  brew bundle dump --all --describe --force --file="${OUTDIR}/Brewfile"
else
  echo "brew not found; skipping Brewfile export" >&2
fi

# 2) Node managers
# nvm versions
if command -v nvm >/dev/null 2>&1; then
  nvm ls --no-colors > "${OUTDIR}/nvm-versions.txt" || true
fi

# volta pinned tools (informational)
if command -v volta >/dev/null 2>&1; then
  volta list all > "${OUTDIR}/volta-list.txt" || true
fi

# asdf tools
if command -v asdf >/dev/null 2>&1; then
  asdf list > "${OUTDIR}/asdf-tool-versions.txt" || true
fi

# 3) Global package snapshots
# npm globals: json -> dependency names; exclude npm itself
if command -v npm >/dev/null 2>&1; then
  npm ls -g --depth=0 --json \
    | jq -r '(.dependencies // {}) | keys[] | select(. != "npm")' \
    | sort -u > "${OUTDIR}/node-globals/npm-global.txt" || true
fi

# yarn v1 globals: stream of JSON lines; pick "list" event
if command -v yarn >/dev/null 2>&1; then
  (yarn global list --json 2>/dev/null \
    | jq -r 'select(.type=="list") | .data.trees[]?.name' \
    | sed 's/@[^@]*$//' \
    | sort -u > "${OUTDIR}/node-globals/yarn-global.txt") || true
fi

# pnpm globals: handle both array and object forms; guard nulls
if command -v pnpm >/dev/null 2>&1; then
  pnpm list -g --depth=0 --json 2>/dev/null \
    | jq -r '
      def names(obj):
        if (obj | type) == "object" and (obj | has("dependencies"))
          then (obj.dependencies // {}) | keys
        elif (obj | type) == "array" and (obj | length) > 0 and (obj[0] | has("dependencies"))
          then (obj[0].dependencies // {}) | keys
        else [] end;
      names(.)[]' \
    | sort -u > "${OUTDIR}/node-globals/pnpm-global.txt" || true
fi

# 4) Git and shell
git config --global --list > "${OUTDIR}/git-global-config.txt" || true
echo "${SHELL:-}" > "${OUTDIR}/default-shell.txt" || true

# 5) Dotfiles snapshot (best effort; copy only if present)
mkdir -p "${OUTDIR}/dotfiles"
for f in ~/.zshrc ~/.zprofile ~/.bashrc ~/.bash_profile ~/.gitconfig ~/.gitignore_global ~/.config/alacritty ~/.config/starship.toml ~/.ssh/config; do
  if [ -e "$f" ]; then
    base="$(basename "$f")"
    if [ -d "$f" ]; then
      rsync -a --delete "$f" "${OUTDIR}/dotfiles/" 2>/dev/null || true
    else
      cp "$f" "${OUTDIR}/dotfiles/$base" 2>/dev/null || true
    fi
  fi
done

echo "Wrote exports to: ${OUTDIR}"

