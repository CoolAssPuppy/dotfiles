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

Every entry is a real directory, committed to the brain repo. That includes
the 58 skills that came from other people's repositories;
`brain/scripts/skills-provenance/upstream.json` records where each came from.

Five agent directories read it, each holding one symlink per skill:

| Directory | Read by |
| --- | --- |
| `~/.claude/skills` | Claude Code, globally |
| `~/.agents/skills` | Amp, Cursor, Gemini CLI, and everything else that follows the `.agents` convention |
| `~/.codex/skills` | Codex |
| `~/Developer/brain/.claude/skills` | Claude Code, inside the brain repo |
| `~/Developer/dotfiles/claude/skills` | Claude Code, inside this repo |

Every link uses an absolute target and points at the real directory, never at
another symlink, so nothing resolves through a chain.

Nothing is ever copied. Edit a skill in `brain/skills` and every agent sees the
change immediately. There is no build step. Run the installer when a skill is
added, renamed, or removed.

### Skills from other repositories

They are committed copies like every other skill, so another machine gets them
with a pull and installs nothing. `brain/scripts/update-upstream-skills.sh`
refreshes them from upstream on one machine, and the commit carries the change
to the rest. The skills CLI only fetches, into a throwaway home directory, and
its lock at `~/.agents/.skill-lock.json` stays empty.

### Shared material

`brain/skills/_shared/` holds voice and formatting files that about twenty
skills reference as `../_shared/voice.md`. It is not a skill, so it has no
`SKILL.md`. The installer links any directory whose name starts with an
underscore alongside the skills, which keeps those relative paths resolving
wherever the skills are read from.

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
- convert a machine set up the old way: a skills-CLI copy in
  `~/.agents/skills`, or any real folder identical to brain's, moves to
  `~/.agents/skills-replaced-by-brain-<date>/` and becomes a link, and its
  CLI lock entry is removed
- report real skill folders that brain does not have as only on this machine,
  and leave them alone

Apart from that conversion, it never overwrites a real file or directory, and
never replaces a symlink pointing outside the directories it manages. Those are reported as collisions
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

Run it on one machine, read `git diff`, then commit and push brain:

```bash
~/Developer/brain/scripts/update-upstream-skills.sh --dry-run
~/Developer/brain/scripts/update-upstream-skills.sh
```

It fetches every source into a throwaway home directory and compares the tree
hash of each skill with the one recorded at import. A skill that brain has not
edited takes the new version. An edited skill is skipped and named, unless
`brain/scripts/upstream-patches/` holds a sanctioned patch for it, which is put
back on the new version. `--dry-run` fetches, compares, and tries each patch,
and writes nothing.

## Setting up another machine

```bash
git -C ~/Developer/brain pull
~/Developer/brain/scripts/link-skills.sh
```

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

To add one from someone else's repository instead:

```bash
~/Developer/brain/scripts/update-upstream-skills.sh --add <owner/repo> <skill>
```

It copies the skill into `brain/skills`, records its source in `upstream.json`,
and links it everywhere. Read the new files, then commit brain.

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
| `brain/scripts/update-upstream-skills.sh` | refreshes and adds skills from other repositories, keeping local edits |
| `brain/scripts/upstream-patches/` | local changes to upstream skills, one patch each |
| `brain/scripts/skills-provenance/` | `upstream.json`, the source and imported hash of each upstream skill |
| `scripts/validate-agent-skills.py` | validates skills, writes both reports |
| `scripts/sync-agent-skills.sh` | forwarding shim to the installer |
| `reports/agent-skills-validation.json` | generated, do not edit |
| `reports/agent-skills-inventory.md` | generated, do not edit |
| `claude/setup.sh` | links the rest of `~/.claude`, then calls the installer |
| `claude/AGENT_SKILLS.md` | history of the third-party skills that used to live in this repo |
