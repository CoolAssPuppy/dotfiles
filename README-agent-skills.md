# Agent skills

One copy of every skill, published to both Claude Code and OpenAI Codex by symlink.

## Architecture

Skills are authored in two canonical directories and nowhere else:

| Source | Path | What lives there |
| --- | --- | --- |
| `dotfiles` | `~/Developer/dotfiles/claude/skills` | General skills that travel with the dotfiles repo, including partner skills from Stripe and Supabase |
| `brain` | `~/Developer/brain/.claude/skills` | Skills tied to the writing and marketing work in the brain repo |

Two runtimes read them:

| Runtime | Path | How it gets populated |
| --- | --- | --- |
| Claude Code | `~/.claude/skills` | one symlink per skill, created by the sync script |
| Codex | `~/.agents/skills` | one symlink per skill, created by the sync script |

Every link uses an absolute target, so it resolves the same however you reach it.

Nothing is ever copied. Edit a skill in its canonical directory and both runtimes
see the change immediately. There is no build step and nothing to re-run after an
edit. You only run the sync script when a skill is added, renamed, or removed.

### Why the targets are directories of links, not one link each

`~/.claude/skills` used to be a single symlink to `~/Developer/dotfiles/claude/skills`.
That made the Claude Code path an alias for one source repo, which left nowhere for
the brain skills to go and no way to publish either set to Codex. The sync script
migrates that layout to a real directory the first time it runs. No content moves;
every skill the old link exposed is relinked individually.

`claude/setup.sh` no longer symlinks `skills` for the same reason. It calls the
sync script at the end instead.

### Shared material

`~/Developer/brain/.claude/skills/_shared/` holds voice and formatting files that
about twenty brain skills reference as `../_shared/voice.md`. It is not a skill, so
it has no `SKILL.md`. The sync script links any directory whose name starts with an
underscore alongside the skills, which is what keeps those relative paths resolving
inside the target directories.

## Running validation

```bash
python3 ~/Developer/dotfiles/scripts/validate-agent-skills.py
```

Read-only. Uses the standard library, plus PyYAML when it happens to be installed.
It writes two reports and prints a summary:

- `reports/agent-skills-validation.json` — full machine-readable findings
- `reports/agent-skills-inventory.md` — per-skill table of source, description,
  status, Claude-specific features, Codex concerns, and duplicate status

What it checks:

- directory naming, and whether the skill file is `SKILL.md` or `skill.md`
- YAML frontmatter parses, and carries `name` and `description`
- frontmatter `name` matches the directory name, which is what slash invocation uses
- Markdown links to local files resolve, and do not point outside the skill
- files named in backticks under a directory the skill ships actually exist
- absolute paths that would not survive being cloned to another machine
- credential-shaped files (`.env`, `*.pem`, `*.key`) and values that look like live
  keys or tokens. A suspected secret is reported by prefix, length, and a short
  hash. The value is never printed.

Exit codes: `0` clean, `1` errors or unresolved conflicts, `2` bad invocation.
Pass `--fail-on warn` to treat warnings as failures, or `--fail-on never` to always
exit `0`.

## Dry run

```bash
~/Developer/dotfiles/scripts/sync-agent-skills.sh --dry-run --verbose
```

Prints every link it would create, repair, or remove, and every collision it would
refuse to touch. Writes nothing. Run this first after adding or renaming a skill.

## Synchronising

```bash
~/Developer/dotfiles/scripts/sync-agent-skills.sh
```

Idempotent. A second run reports everything as unchanged. It will:

- create `~/.claude/skills` and `~/.agents/skills` if they are missing
- migrate a target that is itself a symlink into a canonical source
- create an absolute symlink for each valid skill in both targets
- repoint its own links when a skill moves between sources
- delete its own links whose source skill no longer exists

It will never overwrite a real file or directory, and never replace a symlink that
points outside the canonical sources. Those are reported as collisions and skipped,
and the script exits `1` so the collision does not pass unnoticed.

Useful flags:

| Flag | Effect |
| --- | --- |
| `--dry-run` | report without writing |
| `--verbose` | also list unchanged links and every action taken |
| `--adopt-identical` | replace a real target directory with a symlink, but only when its contents are byte-for-byte identical to the canonical source, so nothing can be lost |

`--adopt-identical` is how you clear out stale copies that a third-party installer
left in `~/.agents/skills`. It refuses to act on any directory whose contents have
drifted from the canonical version.

## How duplicate conflicts are handled

A name appearing in both sources is compared file by file.

Identical in both: the `dotfiles` copy is linked and the brain copy is ignored. No
conflict, nothing to decide.

Contents differ: **both copies are skipped in both targets**, and the script exits
`1`. Neither version is silently chosen. The report names the differing files and
which side is newer by git history and by file mtime. Resolve by hand:

1. Read the inventory section for that skill in `reports/agent-skills-inventory.md`
   and diff the two copies.
2. Decide which one survives. Delete the other, or rename one of them so both can
   coexist under distinct names.
3. Re-run the sync script.

## Adding a new skill

1. Create `<canonical-source>/<skill-name>/SKILL.md`. Use lowercase kebab-case for
   the directory.
2. Give it frontmatter with at least `name` and `description`, where `name` matches
   the directory exactly.
3. Keep every file the skill needs inside the skill directory, and reference those
   files by relative path.
4. Run the validator, then the sync script's dry run, then the sync script.

Put it in `dotfiles` if it is general and should travel with the dotfiles repo. Put
it in `brain` if it depends on that repo's material.

## Invoking a skill

**Claude Code.** Skills with `user-invocable: true` in their frontmatter are
available as `/<skill-name>`. Others are picked up automatically when the
description matches what you are doing. Directory name wins over the frontmatter
`name`, which is why a mismatch is reported as an error.

**Codex.** Skills are read from `~/.agents/skills`. Codex reads `name`,
`description`, and the Markdown body. It does not implement Claude Code's
frontmatter extensions.

## Claude-specific features

The validator reports these and never removes them. All are safe to leave in place:
Codex ignores frontmatter keys it does not recognise, so a skill carrying them still
works in both runtimes, just without the Claude-side behaviour.

| Feature | What happens under Codex |
| --- | --- |
| `allowed-tools` | ignored; the skill runs with the session's tools instead of the narrower set |
| `disable-model-invocation` | ignored; the skill may be selected automatically |
| `user-invocable` | ignored; there is no slash-command registry |
| `context`, `agent`, `model` | ignored |

Two body-level features do need a change, because they fail quietly rather than
being ignored:

| Pattern | Problem | Smallest fix |
| --- | --- | --- |
| `${CLAUDE_SKILL_DIR}` | Codex does not export the variable, so the path expands to nothing | use a path relative to the skill directory |
| `!command` interpolation | Codex reads the line as literal text | put the command in a fenced code block and instruct the agent to run it |

Neither pattern is currently present in any skill.

## Files

| Path | Purpose |
| --- | --- |
| `scripts/sync-agent-skills.sh` | creates and repairs the symlinks |
| `scripts/validate-agent-skills.py` | validates skills, writes both reports |
| `reports/agent-skills-validation.json` | generated, do not edit |
| `reports/agent-skills-inventory.md` | generated, do not edit |
| `claude/setup.sh` | links the rest of `~/.claude`, then calls the sync script |
| `claude/AGENT_SKILLS.md` | provenance of the third-party skills in the dotfiles source |
