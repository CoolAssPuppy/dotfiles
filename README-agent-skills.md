# Agent skills

One copy of every skill, published to every agent by symlink.

Skills are no longer authored in this repo. They live in `brain`, and the
installer that publishes them lives beside them. This file explains the layout
and points at the scripts; dotfiles now only consumes the result.

## Architecture

The canonical directory is flat. Every immediate child is one complete skill.

```text
~/Developer/brain/skills/
```

Two kinds of entry sit there:

| Entry | Meaning |
| --- | --- |
| a real directory | a skill written locally, versioned in the brain repo |
| a symlink into `~/.agents/skills` | a skill installed by the skills CLI, which owns its real directory |

Four agent directories read it, each holding one symlink per skill:

| Directory | Read by |
| --- | --- |
| `~/.claude/skills` | Claude Code, globally |
| `~/.agents/skills` | Codex, Amp, Cursor, Gemini CLI, and everything else that follows the `.agents` convention |
| `~/Developer/brain/.claude/skills` | Claude Code, inside the brain repo |
| `~/Developer/dotfiles/claude/skills` | Claude Code, inside this repo |

`machine-setup/link-codex.sh` adds a fifth, `~/.codex/skills`.

Every link uses an absolute target and points at the real directory, never at
another symlink, so nothing resolves through a chain.

Nothing is ever copied. Edit a skill in `brain/skills` and every agent sees the
change immediately. There is no build step. Run the installer when a skill is
added, renamed, or removed.

### Why the skills CLI keeps its own directory

Twenty-one skills came from `npx skills`. The CLI records each one in
`~/.agents/.skill-lock.json` and, on `npx skills update`, deletes whatever sits
at `~/.agents/skills/<name>` and writes a fresh directory in its place. A
symlink there does not survive that, and the thing it pointed at is left stale
without a word.

So the CLI keeps its real directories where it expects them, and
`brain/skills/<name>` is a symlink pointing inward. The other agent directories
link straight to `~/.agents/skills/<name>`. Updating stays a one-liner and
nothing goes stale behind your back.

`brain/scripts/skills-provenance/` records where each one came from and how to
reinstall the set on a new machine.

### Shared material

`brain/skills/_shared/` holds voice and formatting files that about twenty
skills reference as `../_shared/voice.md`. It is not a skill, so it has no
`SKILL.md`. The installer links any directory whose name starts with an
underscore alongside the skills, which keeps those relative paths resolving
wherever the skills are read from.

### Not a skill

`claude/skills/i-have-adhd` is a git submodule holding a Claude Code plugin. Its
`SKILL.md` sits at `skills/i-have-adhd/` inside the submodule, so a flat skill
directory cannot hold it. It stays here and Claude Code loads it as the plugin
`i-have-adhd:i-have-adhd`.

## Linking

```bash
~/Developer/brain/scripts/link-skills.sh
```

Idempotent. A second run reports everything as unchanged. It will:

- discover and validate every skill in the canonical directory
- create any target directory that is missing
- create an absolute symlink for each valid skill in every target
- repoint its own links when a skill's real directory moves
- repair a broken link that points somewhere it manages
- delete its own links whose skill no longer exists
- recognise a skill already sitting in `~/.agents/skills` as being home, and
  leave it alone rather than link it to itself

It will never overwrite a real file or directory, and never replace a symlink
pointing outside the directories it manages. Those are reported as collisions
and skipped, and the script exits `1` so a collision does not pass unnoticed.

| Flag | Effect |
| --- | --- |
| `--dry-run` | report without writing |
| `--verbose` | also list unchanged links and per-skill validation notes |
| `--no-validate` | link whatever is there |
| `--target PATH` | add a destination, repeatable |
| `--only NAME` | act on a single skill, repeatable |

`scripts/sync-agent-skills.sh` in this repo is a forwarding shim to the same
installer, kept so old invocations keep working.

## Updating the skills that came from upstream

```bash
cd ~/Developer/brain
./scripts/update-upstream-skills.sh
```

It hashes every installed skill and compares against the tree hash the lock file
recorded at install time. A skill that still matches is safe to update. A skill
whose hash has drifted was edited locally, and `npx skills update` would
overwrite that edit silently, so it is left out and named in the report.

One skill is drifted today, and its change is sanctioned: a `.reapply` marker
in `scripts/upstream-patches/` tells the script to update the skill and then put
the change back. An unsanctioned drift is skipped instead, and named.

Six Stripe skills carry no upstream hash, so drift cannot be detected for them
and the CLI cannot update them either. Refresh those by hand with
`npx skills add https://docs.stripe.com -g -a codex -y`, which takes all six;
`-s` does not work on a well-known source.

The CLI has no dry-run mode. `--dry-run` reports what would be fetched and stops
before fetching.

## Validating

```bash
python3 ~/Developer/dotfiles/scripts/validate-agent-skills.py
```

Read-only. Uses the standard library, plus PyYAML when it happens to be
installed. It writes two reports and prints a summary:

- `reports/agent-skills-validation.json`, full machine-readable findings
- `reports/agent-skills-inventory.md`, a per-skill table of source,
  description, status, Claude-specific features, Codex concerns, and duplicate
  status

What it checks:

- directory naming, and whether the skill file is `SKILL.md` or `skill.md`
- YAML frontmatter parses, and carries `name` and `description`
- frontmatter `name` matches the directory name, which is what slash invocation
  uses
- Markdown links to local files resolve, and do not point outside the skill
- files named in backticks under a directory the skill ships actually exist
- absolute paths that would not survive being cloned to another machine
- credential-shaped files (`.env`, `*.pem`, `*.key`) and values that look like
  live keys or tokens. A suspected secret is reported by prefix, length, and a
  short hash. The value is never printed.

Exit codes: `0` clean, `1` errors or unresolved conflicts, `2` bad invocation.
Pass `--fail-on warn` to treat warnings as failures, or `--fail-on never` to
always exit `0`.

The installer runs a smaller check of its own before linking anything, so a
skill missing `SKILL.md`, frontmatter, `name`, or `description` never reaches a
target.

## Adding a new skill

1. Create `~/Developer/brain/skills/<skill-name>/SKILL.md`. Use lowercase
   kebab-case for the directory.
2. Give it frontmatter with at least `name` and `description`, where `name`
   matches the directory exactly. Quote a description containing a colon, or a
   strict YAML parser will skip the whole skill.
3. Keep every file the skill needs inside the skill directory, and reference
   those files by relative path.
4. Run the validator, then the installer's dry run, then the installer.

To add one from a public repository instead:

```bash
npx skills add <source> -g -a codex -s <skill> -y
```

then run the installer. Two flags matter. `-a codex` or the CLI picks agents by
what it finds installed, and one that cannot do a global install fails the whole
command. `-s` takes a single skill, so repeat the flag rather than passing a
comma-separated list: `-s a -s b`, never `-s a,b`. The full set of CLI
surprises is in `brain/scripts/skills-provenance/README.md`. It picks up the new directory in `~/.agents/skills` and
links it everywhere, including back into `brain/skills`.

## Invoking a skill

**Claude Code.** Skills with `user-invocable: true` in their frontmatter are
available as `/<skill-name>`. Others are picked up automatically when the
description matches what you are doing. Directory name wins over the frontmatter
`name`, which is why a mismatch is reported.

**Codex.** Skills are read from `~/.codex/skills`. Codex reads `name`,
`description`, and the Markdown body. It does not implement Claude Code's
frontmatter extensions.

## Claude-specific features

The validator reports these and never removes them. All are safe to leave in
place: Codex ignores frontmatter keys it does not recognise, so a skill carrying
them still works in both runtimes, just without the Claude-side behaviour.

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
| `brain/skills/` | the canonical directory, flat, one skill per child |
| `brain/scripts/link-skills.sh` | creates and repairs the symlinks |
| `brain/scripts/update-upstream-skills.sh` | updates the skills the CLI owns, refusing to clobber local edits |
| `brain/scripts/upstream-patches/` | local changes to upstream skills, one patch each |
| `brain/scripts/skills-provenance/` | lock file copies and rebuild instructions |
| `scripts/validate-agent-skills.py` | validates skills, writes both reports |
| `scripts/sync-agent-skills.sh` | forwarding shim to the installer |
| `reports/agent-skills-validation.json` | generated, do not edit |
| `reports/agent-skills-inventory.md` | generated, do not edit |
| `claude/setup.sh` | links the rest of `~/.claude`, then calls the installer |
| `claude/AGENT_SKILLS.md` | history of the third-party skills that used to live in this repo |
