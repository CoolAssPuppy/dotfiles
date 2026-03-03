# Git workflow and configuration

## Commit style

- Write commit messages in present tense: "Add feature" not "Added feature".
- Keep commits focused on a single logical change.
- Include the "why" in commit messages when the "what" isn't obvious.

## Standard .gitignore additions

Always ensure these files are ignored in projects:

```gitignore
# Claude Code and MCP configuration
.claude/settings.local.json
CLAUDE.local.md
mcp.json
.mcp.json

# Environment and secrets
.env
.env.local
.env.development
.env.test
.env.production

# Dependencies and build artifacts
node_modules/
dist/
build/
.next/

# IDE and editor files
.vscode/
.idea/
*.swp
*.swo

# OS generated files
.DS_Store
Thumbs.db

# iOS development
*.xcworkspace/xcuserdata/
*.xcuserstate
*.xcscmblueprint
DerivedData/
build/
*.ipa
*.dSYM.zip
*.dSYM
*.app
*.hmap
*.xcarchive
*.moved-aside
*.pbxuser
*.mode1v3
*.mode2v3
*.perspectivev3
project.xcworkspace/
xcuserdata/
*.xccheckout
*.xcworkspace/xcshareddata/
*.xcworkspace/contents.xcworkspacedata
```
