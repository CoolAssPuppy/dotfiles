# Third-party agent skills

Skills installed from external providers (Stripe, Supabase, etc.) and committed to this dotfiles repo so they ship with `~/.claude/skills/` on every machine you clone to.

Promoting these to the global Claude Code path means a fresh machine gets all the partner skills automatically once dotfiles is cloned and the symlinks are wired up by `setup.sh`. No per-machine reinstall.

## How they got here

Originally installed by an Anthropic Agent Skills installer (likely Stripe's or Supabase's flavor of `skills.sh`) that detected every AI tool you might run and dumped per-tool symlinks into `claude/skills/.<tool-name>/skills/` for 27 different tools. The actual content lived in `claude/skills/.agents/skills/<name>/` and was symlinked from each tool dir.

That layout had three problems:

1. Claude Code couldn't see any of these skills because `claude/skills/.agents/skills/<name>/SKILL.md` is too deeply nested. Claude Code looks for `claude/skills/<name>/SKILL.md` directly.
2. 27 per-tool subdirectories cluttered the repo for tools you'll never use (Augment, Codebuddy, Crush, Goose, Iflow, Kilocode, Kode, Mcpjam, Mux, Neovate, Openhands, Pi, Pochi, Qoder, Qwen, Roo, Vibe, Zencoder, Adal, Commandcode, etc.).
3. The top-level `claude/skills/supabase-postgres-best-practices@` symlink had a wrong relative path and was broken.

The fix was to promote the canonical content to `claude/skills/<name>/` and delete the per-tool dirs.

## Skills currently committed

If you ever need to reinstall any of these from upstream (e.g., to pick up updates), here is what's installed and where it likely came from.

### Stripe (3 skills)

Source: docs.stripe.com/building-with-ai or agentskills.io

- **stripe-best-practices** (6 files) — Stripe integration decisions: API selection (Checkout Sessions vs PaymentIntents), Connect platform setup, billing/subscriptions, Treasury, integration surfaces, security best practices. References cover billing, connect, payments, security, treasury.
- **stripe-projects** (1 file) — Setting up a new app or local repo with Stripe Projects, provisioning a software stack, bootstrapping the Projects CLI.
- **upgrade-stripe** (1 file) — Upgrading Stripe API versions and SDKs.

### Supabase (2 skills)

Source: supabase.com or agentskills.io. Author metadata: `author: supabase`.

- **supabase** (3 files) — Triggers on any Supabase task: Database, Auth, Edge Functions, Realtime, Storage, Vectors, Cron, Queues, supabase-js, @supabase/ssr, RLS, migrations, security audits.
- **supabase-postgres-best-practices** (35 files) — Postgres performance optimization. References cover 8 categories: connection management, query performance, indexes, locking, monitoring, schema design, security/RLS, advanced features (full-text search, JSONB).

### Data (2 skills)

Source: unclear, possibly Anthropic or community. No author metadata in frontmatter.

- **data-storytelling** (1 file) — Transforming data into narratives using visualization, context, persuasive structure. For analytics presentations and executive reports.
- **data-visualization** (1 file) — Creating effective charts with Python (matplotlib, seaborn, plotly). Marked `user-invocable: false` so only Claude can invoke it.

## Skills previously installed but removed

These were installed at some earlier point (likely by a Vercel-flavored agent skill installer) and committed as top-level symlinks pointing into a `.agents/skills/` location that never existed in this repo. They have been broken since installation and surfaced nothing to Claude Code. They were removed during the cleanup that produced this document. Reinstall via the relevant installer if you want them back.

- **deploy-to-vercel** — Vercel deployment guidance.
- **find-skills** — Skill discovery helper.
- **remotion-best-practices** — Remotion video framework patterns.
- **vercel-composition-patterns** — Vercel app composition patterns.
- **vercel-react-best-practices** — React-on-Vercel best practices.
- **vercel-react-native-skills** — React Native on Vercel.
- **web-design-guidelines** — General web design guidelines.

## How to refresh from upstream

If a partner ships a new version of a skill, you have two paths:

### Path 1: Re-run the install script with the global flag

Find the installer (the user said `skills.sh` but it lives at the provider's URL, not in this repo). Run it pointing at `~/.claude/skills/` so it installs at the global Claude Code path, which symlinks back into this repo. Commit the diff.

### Path 2: Manual replace

Download the upstream zip, extract over `claude/skills/<skill-name>/`, commit. Faster and you can see exactly what changed.

## What NOT to commit

Future skill installers may try to dump per-tool subdirs into `claude/skills/.<tool>/skills/` again. The repo `.gitignore` blocks these patterns:

```gitignore
claude/skills/.*/
claude/skills/skills/
```

If you see new per-tool dirs appear after running an installer, they will not be tracked. To clean them up: `rm -rf claude/skills/.*/`

## On Codex and Cursor

You also use Codex (OpenAI CLI) and Cursor sometimes. Neither has a skills system equivalent to Claude Code's:

- **Codex** uses `AGENTS.md` for context files (similar to `CLAUDE.md`), not modular skills.
- **Cursor** uses `.cursorrules` or `.cursor/rules/` for rules and `.cursor/commands/` for commands, not skills.

If a partner ships a Cursor- or Codex-shaped equivalent of these skills in the future, they would land at different paths and would not conflict with the Claude Code skills committed here.
