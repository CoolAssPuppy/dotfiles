#!/bin/bash
# Restore VS Code settings from dotfiles repo

DOTFILES_VSCODE="$HOME/Developer/dotfiles/vscode"
VSCODE_USER="$HOME/Library/Application Support/Code/User"

# Ensure VS Code user directory exists
mkdir -p "$VSCODE_USER"

# Restore settings
if [ -f "$DOTFILES_VSCODE/settings.json" ]; then
    cp "$DOTFILES_VSCODE/settings.json" "$VSCODE_USER/settings.json"
    echo "Restored settings.json"
fi

# Restore keybindings
if [ -f "$DOTFILES_VSCODE/keybindings.json" ]; then
    cp "$DOTFILES_VSCODE/keybindings.json" "$VSCODE_USER/keybindings.json"
    echo "Restored keybindings.json"
fi

# Restore snippets
if [ -d "$DOTFILES_VSCODE/snippets" ]; then
    mkdir -p "$VSCODE_USER/snippets"
    cp -R "$DOTFILES_VSCODE/snippets/"* "$VSCODE_USER/snippets/"
    echo "Restored snippets/"
fi

# Install extensions
if [ -f "$DOTFILES_VSCODE/extensions.txt" ]; then
    echo "Installing extensions..."
    while IFS= read -r extension; do
        code --install-extension "$extension" --force 2>/dev/null
    done < "$DOTFILES_VSCODE/extensions.txt"
    echo "Installed $(wc -l < "$DOTFILES_VSCODE/extensions.txt" | tr -d ' ') extensions"
fi

echo "VS Code restore complete."
