# Dotfiles

Personal configuration files for macOS development and Claude Code AI assistant customization.

## What's included

### Machine setup

Scripts and configurations for setting up a new Mac development environment.

```
machine-setup/
├── dev-install.sh      # Fresh machine setup script
├── dev-update.sh       # Update existing installation
├── Brewfile            # Homebrew packages and casks
├── dotfiles/           # Shell and SSH configurations
│   ├── .zshrc
│   ├── .bash_profile
│   ├── .gitconfig
│   └── config          # SSH config
├── node-globals/       # Global npm/yarn/pnpm packages
└── git-global-config.txt
```

### Shell configurations

Alternative shell configurations in `shells/` for zsh and bash with git branch display, aliases, and environment setup.

### Claude Code configuration

Comprehensive configuration for [Claude Code](https://claude.ai/claude-code), Anthropic's AI coding assistant.

```
claude/
├── CLAUDE.md           # Master configuration and coding standards
├── agents/             # Specialized autonomous agents
├── commands/           # Slash commands for common workflows
├── skills/             # Domain expertise prompts
└── docs/               # Reference documentation
```

#### Agents

Autonomous agents that handle specific tasks:

- **tdd-guardian** - Enforces test-driven development practices
- **ts-enforcer** - TypeScript best practices and type safety
- **docs-guardian** - Documentation quality standards
- **refactor-scan** - Code improvement opportunities
- **wip-guardian** - Work-in-progress tracking
- **adr** - Architecture decision records
- **learn** - Captures learnings into CLAUDE.md
- **use-case-data-patterns** - Maps use cases to data architecture

#### Commands

Slash commands for common workflows:

- **/clean-and-refactor** - Codebase cleanup and refactoring
- **/add-tests** - Comprehensive test implementation
- **/verify-supabase** - Supabase security and best practices audit
- **/app-store-prep** - iOS/macOS App Store deployment automation
- **/new-blog** - Data-driven blog post creation
- **/check-seo-aeo** - SEO and AI engine optimization audit

#### Skills

Domain expertise for developer marketing:

- **positioning.md** - Developer product positioning framework
- **competitive-analysis.md** - Honest competitive battlecards
- **content-strategy.md** - Developer content planning
- **blog-post-ideation.md** - Data-driven content ideation
- **webinar-planning.md** - Technical webinar execution
- **launch-planning.md** - Developer product launches
- **ios-macos-deployment.md** - Fastlane and App Store deployment

## Usage

### Machine setup

```bash
# Fresh install
./machine-setup/dev-install.sh

# Update existing
./machine-setup/dev-update.sh
```

### Claude Code

Copy the `claude/` directory contents to your `~/.claude/` directory:

```bash
cp -r claude/* ~/.claude/
```

The `CLAUDE.md` file defines coding standards, testing requirements, and development workflows that Claude Code will follow across all projects.

## Learn more

The developer marketing skills in this repository are based on methodologies from:

- [Strategic Nerds](https://www.strategicnerds.com) - Blog covering developer marketing, DevRel, and go-to-market strategy
- [Picks and Shovels](https://www.picksandshovels.dev) - The definitive resource for technical marketing during the AI gold rush

## License

MIT
