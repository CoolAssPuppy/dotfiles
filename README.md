# Dotfiles

Personal dotfiles that Prashant Sridharan uses on all of his Macs. Includes shell configurations, machine setup scripts, Claude Code agents, skills, commands, and prompts for developer marketing workflows.

The Claude files are derived from best practices found on the Internet plus distillations of Prashant's best-selling book about marketing: [Picks and Shovels: Marketing to Developers During the AI Gold Rush](https://www.picksandshovels.dev).

## Directory structure

```
dotfiles/
├── claude/                    # Claude Code AI assistant configuration
│   ├── CLAUDE.md              # Master coding standards and configuration
│   ├── agents/                # Autonomous development agents
│   ├── commands/              # Slash commands for workflows
│   ├── docs/                  # Reference documentation
│   ├── skills/                # Developer marketing expertise
│   └── work-prompts/          # Standalone prompts for content creation
├── machine-setup/             # macOS development environment setup
│   ├── dev-install.sh         # Fresh machine setup script
│   ├── dev-update.sh          # Update existing installation
│   ├── Brewfile               # Homebrew packages and casks
│   ├── dotfiles/              # Shell and SSH configurations
│   ├── node-globals/          # Global npm/yarn/pnpm packages
│   └── git-global-config.txt  # Git configuration
└── shells/                    # Alternative shell configurations
    ├── zshrc                  # Zsh configuration with git prompt
    └── bash_profile           # Bash configuration
```

## Machine setup

Scripts and configurations for setting up a new Mac development environment.

```bash
# Fresh install
./machine-setup/dev-install.sh

# Update existing
./machine-setup/dev-update.sh
```

The Brewfile includes common development tools, applications, and fonts.

## Shell configurations

The `shells/` directory contains zsh and bash configurations with:

- Git branch display in prompt
- Color-coded ls output
- Custom aliases
- `gitsync` helper function for quick commits

## Claude Code configuration

Configuration for [Claude Code](https://claude.ai/claude-code), Anthropic's AI coding assistant.

### Master configuration (CLAUDE.md)

Defines coding standards including:

- TypeScript/Swift best practices
- Test-driven development requirements
- Supabase and Next.js conventions
- Security standards and RLS policies
- File size and architecture guidelines

### Agents

Autonomous agents that handle specific development tasks:

| Agent | Purpose |
|-------|---------|
| `tdd-guardian` | Enforces test-driven development practices |
| `ts-enforcer` | TypeScript best practices and type safety |
| `docs-guardian` | Documentation quality standards |
| `refactor-scan` | Identifies code improvement opportunities |
| `wip-guardian` | Work-in-progress tracking across sessions |
| `adr` | Architecture decision records |
| `learn` | Captures learnings into CLAUDE.md |
| `use-case-data-patterns` | Maps use cases to data architecture |

### Commands

Slash commands for common workflows:

| Command | Purpose |
|---------|---------|
| `/clean-and-refactor` | Codebase cleanup and refactoring |
| `/add-tests` | Comprehensive test implementation |
| `/verify-supabase` | Supabase security and best practices audit |
| `/app-store-prep` | iOS/macOS App Store deployment automation |
| `/new-blog` | Data-driven blog post creation |
| `/check-seo-aeo` | SEO and AI engine optimization audit |

### Skills

Developer marketing expertise based on the "Picks and Shovels" methodology:

| Skill | Purpose |
|-------|---------|
| `positioning` | Product positioning and messaging frameworks |
| `competitive-analysis` | Battle cards and competitor teardowns |
| `content-strategy` | Developer content planning |
| `blog-post-ideation` | Data-driven content ideation |
| `webinar-planning` | Technical webinar execution |
| `launch` | Product launch campaigns |
| `gtm-strategy` | Go-to-market strategy (PLG, SLG, hybrid) |
| `ios-macos-deployment` | Fastlane and App Store deployment |

### Work prompts

Standalone prompts for developer marketing content creation:

- `case-study-prompt` - Customer success stories
- `competitive-analysis-prompt` - Competitor research
- `content-strategy-prompt` - Content planning
- `developer-persona-prompt` - Persona development
- `event-brief-prompt` - Event planning documents
- `go-to-market-plan-prompt` - GTM planning
- `positioning-framework-prompt` - Positioning exercises
- `product-detail-page-prompt` - Product page copy
- `product-launch-blog-prompt` - Launch announcements
- `remotion-video-prompt` - Video scripting
- `sales-email-prompt` - Sales outreach
- `thought-leadership-blog-prompt` - Opinion pieces
- `webinar-planning-prompt` - Webinar content

### Reference documentation

The `docs/` directory contains detailed guides on testing, TypeScript, code style, and workflow patterns.

## Installation

### Machine setup

Run the install script for a fresh Mac:

```bash
./machine-setup/dev-install.sh
```

### Claude Code

Copy the `claude/` directory contents to your `~/.claude/` directory:

```bash
cp -r claude/* ~/.claude/
```

## Learn more

The developer marketing skills in this repository are based on methodologies from:

- [Strategic Nerds](https://www.strategicnerds.com) - Blog covering developer marketing, DevRel, and go-to-market strategy
- [Picks and Shovels](https://www.picksandshovels.dev) - The definitive resource for technical marketing during the AI gold rush

## License

MIT
