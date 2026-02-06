#!/bin/bash
# Back up VS Code settings to dotfiles repo

DOTFILES_VSCODE="$HOME/Developer/dotfiles/vscode"
VSCODE_USER="$HOME/Library/Application Support/Code/User"

# Back up settings
cp "$VSCODE_USER/settings.json" "$DOTFILES_VSCODE/settings.json" 2>/dev/null

# Back up keybindings (if they exist)
cp "$VSCODE_USER/keybindings.json" "$DOTFILES_VSCODE/keybindings.json" 2>/dev/null

# Back up snippets directory (if it has content)
if [ -d "$VSCODE_USER/snippets" ] && [ "$(ls -A "$VSCODE_USER/snippets")" ]; then
    mkdir -p "$DOTFILES_VSCODE/snippets"
    cp -R "$VSCODE_USER/snippets/"* "$DOTFILES_VSCODE/snippets/"
fi

# Back up extensions list
code --list-extensions > "$DOTFILES_VSCODE/extensions.txt"

echo "VS Code backup complete."
echo "  - settings.json"
[ -f "$VSCODE_USER/keybindings.json" ] && echo "  - keybindings.json"
[ -d "$DOTFILES_VSCODE/snippets" ] && echo "  - snippets/"
echo "  - extensions.txt ($(wc -l < "$DOTFILES_VSCODE/extensions.txt" | tr -d ' ') extensions)"
