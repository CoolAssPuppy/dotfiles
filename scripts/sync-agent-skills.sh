#!/usr/bin/env bash
#
# sync-agent-skills.sh
#
# Publish the canonical agent skills to Claude Code and OpenAI Codex by
# symlink, so both runtimes read one copy of every skill.
#
#   canonical sources                       targets
#   ~/Developer/dotfiles/claude/skills  ->  ~/.claude/skills   (Claude Code)
#   ~/Developer/brain/.claude/skills    ->  ~/.agents/skills   (Codex)
#
# The script is idempotent and non-destructive. It creates absolute symlinks,
# repairs its own stale or broken ones, and refuses to touch anything else:
# real directories, real files, and symlinks pointing outside the canonical
# sources are reported and left alone.
#
# Usage:
#   sync-agent-skills.sh [--dry-run] [--verbose] [--adopt-identical]
#                        [--target-claude PATH] [--target-codex PATH]
#
#   --dry-run          report every action without changing the filesystem
#   --verbose          also list unchanged links and per-entry decisions
#   --adopt-identical  replace a real target directory with a symlink only when
#                      its contents are byte-for-byte identical to the canonical
#                      source, so nothing can be lost. Off by default.
#
# Exit codes:
#   0  everything linked or already correct
#   1  unresolved duplicate conflicts, or target collisions that need a decision
#   2  bad usage or a missing source directory
#
# Written for bash 3.2 so it runs against /bin/bash on stock macOS.

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

# Canonical sources, in precedence order. Labels are used in reporting only.
SOURCE_LABELS=("dotfiles" "brain")
SOURCE_PATHS=("$HOME/Developer/dotfiles/claude/skills" "$HOME/Developer/brain/.claude/skills")

TARGET_LABELS=("claude-code" "codex")
TARGET_PATHS=("$HOME/.claude/skills" "$HOME/.agents/skills")

# Entries that are never candidates for linking.
IGNORED_ENTRIES=".DS_Store skills-lock.json .skill-lock.json"

DRY_RUN=false
VERBOSE=false
ADOPT_IDENTICAL=false

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

usage() {
  sed -n '3,32p' "$0" | sed 's/^# \{0,1\}//'
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)         DRY_RUN=true ;;
    --verbose|-v)      VERBOSE=true ;;
    --adopt-identical) ADOPT_IDENTICAL=true ;;
    --target-claude)
      [ "$#" -ge 2 ] || { echo "error: --target-claude needs a path" >&2; exit 2; }
      TARGET_PATHS[0]="$2"; shift ;;
    --target-codex)
      [ "$#" -ge 2 ] || { echo "error: --target-codex needs a path" >&2; exit 2; }
      TARGET_PATHS[1]="$2"; shift ;;
    -h|--help)         usage; exit 0 ;;
    *) echo "error: unknown option '$1'" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

# ---------------------------------------------------------------------------
# Path helpers
#
# Home expansion happens through parameter expansion above rather than eval, so
# a path containing spaces or shell metacharacters stays intact.
# ---------------------------------------------------------------------------

# abspath DIR -> fully resolved physical path, or empty when it does not exist.
abspath() {
  [ -e "$1" ] || return 1
  ( cd -P -- "$1" 2>/dev/null && pwd -P ) || return 1
}

# Resolve every source to its physical path up front. Anything unreadable is
# fatal: silently syncing half the library would be worse than stopping.
SOURCE_REAL=()
i=0
while [ "$i" -lt "${#SOURCE_PATHS[@]}" ]; do
  src="${SOURCE_PATHS[$i]}"
  if [ ! -d "$src" ]; then
    echo "error: canonical source not found: $src" >&2
    exit 2
  fi
  real="$(abspath "$src")" || { echo "error: cannot resolve $src" >&2; exit 2; }
  SOURCE_REAL[$i]="$real"
  i=$((i + 1))
done

# is_under_source PATH -> 0 when PATH lies inside a canonical source.
is_under_source() {
  local candidate="$1" root
  for root in "${SOURCE_REAL[@]}"; do
    case "$candidate" in
      "$root"|"$root"/*) return 0 ;;
    esac
  done
  return 1
}

is_ignored() {
  local entry="$1" skip
  for skip in $IGNORED_ENTRIES; do
    [ "$entry" = "$skip" ] && return 0
  done
  return 1
}

# ---------------------------------------------------------------------------
# Reporting
# ---------------------------------------------------------------------------

LINKED=0
REPAIRED=0
UNCHANGED=0
ADOPTED=0
SKIPPED_COLLISION=0
SKIPPED_CONFLICT=0
INVALID=0
CONFLICT_NAMES=()
COLLISION_LINES=()
INVALID_LINES=()
ACTION_LINES=()

note()    { [ "$VERBOSE" = true ] && printf '  %s\n' "$1" || true; }
say()     { printf '%s\n' "$1"; }
record()  { ACTION_LINES[${#ACTION_LINES[@]}]="$1"; }

collision() {
  COLLISION_LINES[${#COLLISION_LINES[@]}]="$1"
  SKIPPED_COLLISION=$((SKIPPED_COLLISION + 1))
}

invalid() {
  INVALID_LINES[${#INVALID_LINES[@]}]="$1"
  INVALID=$((INVALID + 1))
}

# ---------------------------------------------------------------------------
# Discovery
#
# A directory is a skill when it holds SKILL.md or skill.md. A directory whose
# name starts with an underscore is shared material that skills reference by a
# relative path such as ../_shared/voice.md; it is linked alongside the skills
# so those references keep resolving in the target directories.
# ---------------------------------------------------------------------------

NAMES=()
PATHS=()
ORIGINS=()
KINDS=()

index_of() {
  local needle="$1" n=0
  while [ "$n" -lt "${#NAMES[@]}" ]; do
    [ "${NAMES[$n]}" = "$needle" ] && { printf '%s' "$n"; return 0; }
    n=$((n + 1))
  done
  return 1
}

add_entry() {
  local name="$1" path="$2" origin="$3" kind="$4" n
  NAMES[${#NAMES[@]}]="$name"
  PATHS[${#PATHS[@]}]="$path"
  ORIGINS[${#ORIGINS[@]}]="$origin"
  KINDS[${#KINDS[@]}]="$kind"
}

mark_conflict() {
  local name="$1" n
  for n in ${CONFLICT_NAMES[@]+"${CONFLICT_NAMES[@]}"}; do
    [ "$n" = "$name" ] && return 0
  done
  CONFLICT_NAMES[${#CONFLICT_NAMES[@]}]="$name"
}

is_conflicted() {
  local name="$1" n
  for n in ${CONFLICT_NAMES[@]+"${CONFLICT_NAMES[@]}"}; do
    [ "$n" = "$name" ] && return 0
  done
  return 1
}

say "Agent skill sync"
say "----------------------------------------------------------------------------"
[ "$DRY_RUN" = true ] && say "DRY RUN. Nothing will be written."

i=0
while [ "$i" -lt "${#SOURCE_REAL[@]}" ]; do
  label="${SOURCE_LABELS[$i]}"
  root="${SOURCE_REAL[$i]}"
  found=0

  # -print0 plus a null-delimited read keeps names with spaces intact.
  while IFS= read -r -d '' entry; do
    name="$(basename -- "$entry")"
    case "$name" in .*) continue ;; esac
    is_ignored "$name" && continue

    if [ -L "$entry" ] && [ ! -e "$entry" ]; then
      invalid "$label/$name: broken symlink -> $(readlink -- "$entry")"
      continue
    fi
    if [ ! -d "$entry" ]; then
      continue
    fi

    kind="skill"
    if [ ! -f "$entry/SKILL.md" ] && [ ! -f "$entry/skill.md" ]; then
      case "$name" in
        _*) kind="support" ;;
        *)  invalid "$label/$name: directory has neither SKILL.md nor skill.md"
            continue ;;
      esac
    fi

    real="$(abspath "$entry")" || { invalid "$label/$name: unresolvable"; continue; }

    if existing="$(index_of "$name")"; then
      prior="${PATHS[$existing]}"
      if diff -r -q -- "$prior" "$real" >/dev/null 2>&1; then
        note "duplicate $name: identical in ${ORIGINS[$existing]} and $label, linking ${ORIGINS[$existing]}"
      else
        mark_conflict "$name"
      fi
    else
      add_entry "$name" "$real" "$label" "$kind"
    fi
    found=$((found + 1))
  done < <(find "$root" -mindepth 1 -maxdepth 1 -print0 | sort -z)

  say "  source $label: $found entries under $root"
  i=$((i + 1))
done

SKILL_COUNT=0
SUPPORT_COUNT=0
n=0
while [ "$n" -lt "${#NAMES[@]}" ]; do
  if [ "${KINDS[$n]}" = "skill" ]; then
    SKILL_COUNT=$((SKILL_COUNT + 1))
  else
    SUPPORT_COUNT=$((SUPPORT_COUNT + 1))
  fi
  n=$((n + 1))
done

say "  discovered: $SKILL_COUNT unique skill names, $SUPPORT_COUNT shared directories"
say "              ${#CONFLICT_NAMES[@]} of those names conflict and will be skipped"

if [ "${#CONFLICT_NAMES[@]}" -gt 0 ]; then
  say ""
  say "Conflicts (same name, different contents). Skipped in both targets."
  for name in "${CONFLICT_NAMES[@]}"; do
    say "  $name"
    i=0
    while [ "$i" -lt "${#SOURCE_REAL[@]}" ]; do
      candidate="${SOURCE_REAL[$i]}/$name"
      if [ -d "$candidate" ]; then
        stamp="$(find "$candidate" -type f -not -name .DS_Store -exec stat -f '%Sm' -t '%Y-%m-%dT%H:%M:%S' {} + 2>/dev/null | sort | tail -1)"
        [ -n "$stamp" ] || stamp="unknown"
        say "      ${SOURCE_LABELS[$i]}: $candidate  (newest file $stamp)"
      fi
      i=$((i + 1))
    done
    say "      resolve with: scripts/validate-agent-skills.py, then keep one copy"
    SKIPPED_CONFLICT=$((SKIPPED_CONFLICT + 1))
  done
fi

# ---------------------------------------------------------------------------
# Target preparation
#
# A target directory that is itself a symlink into a canonical source cannot
# hold links to both sources. That layout is migrated to a real directory,
# which loses nothing: every skill it exposed gets relinked below.
# ---------------------------------------------------------------------------

# Set by prepare_target when a dry run cannot inspect the post-migration state,
# so the link loop reports intent instead of comparing against the old layout.
TARGET_ASSUME_EMPTY=false

prepare_target() {
  local target="$1" label="$2" real
  TARGET_ASSUME_EMPTY=false

  if [ -L "$target" ]; then
    real="$(abspath "$target" 2>/dev/null || true)"
    if [ -n "$real" ] && is_under_source "$real"; then
      say "  $label: target is a symlink into a canonical source ($real)"
      say "         migrating to a real directory so both sources can be linked"
      if [ "$DRY_RUN" = true ]; then
        record "would replace symlink $target with a directory"
        TARGET_ASSUME_EMPTY=true
      else
        rm -- "$target"
        mkdir -p -- "$target"
        record "replaced symlink $target with a directory"
      fi
      return 0
    fi
    say "  $label: target is a symlink to ${real:-an unresolvable path}, outside the"
    say "         canonical sources. Leaving it alone; nothing is linked here."
    return 1
  fi

  if [ ! -d "$target" ]; then
    if [ "$DRY_RUN" = true ]; then
      say "  $label: would create $target"
      TARGET_ASSUME_EMPTY=true
    else
      mkdir -p -- "$target"
      say "  $label: created $target"
    fi
    return 0
  fi

  return 0
}

# link_one TARGET_DIR LABEL NAME SOURCE_PATH
link_one() {
  local target_dir="$1" label="$2" name="$3" source="$4"
  local dest="$target_dir/$name" current

  if [ -L "$dest" ]; then
    current="$(readlink -- "$dest")"
    if [ "$current" = "$source" ]; then
      UNCHANGED=$((UNCHANGED + 1))
      note "$label/$name: unchanged"
      return 0
    fi

    # Replace a link only when it refers to a canonical source, whether it
    # currently resolves or not. Anything else belongs to another tool.
    local resolved=""
    [ -e "$dest" ] && resolved="$(abspath "$dest" 2>/dev/null || true)"
    if { [ -n "$resolved" ] && is_under_source "$resolved"; } || is_under_source "$current"; then
      if [ "$DRY_RUN" = true ]; then
        record "$label/$name: would repoint $current -> $source"
      else
        rm -- "$dest"
        ln -s -- "$source" "$dest"
        record "$label/$name: repointed to $source"
      fi
      REPAIRED=$((REPAIRED + 1))
      return 0
    fi

    if [ -e "$dest" ]; then
      collision "$label/$name: symlink to $current lies outside the canonical sources"
    else
      collision "$label/$name: broken symlink to $current, not ours to repair"
    fi
    return 0
  fi

  if [ -e "$dest" ]; then
    if [ -d "$dest" ] && diff -r -q -- "$dest" "$source" >/dev/null 2>&1; then
      if [ "$ADOPT_IDENTICAL" = true ]; then
        if [ "$DRY_RUN" = true ]; then
          record "$label/$name: would adopt identical copy as a symlink"
        else
          rm -rf -- "$dest"
          ln -s -- "$source" "$dest"
          record "$label/$name: adopted identical copy as a symlink"
        fi
        ADOPTED=$((ADOPTED + 1))
      else
        collision "$label/$name: real directory, byte-identical to $source (rerun with --adopt-identical to replace it with a link)"
      fi
      return 0
    fi
    if [ -d "$dest" ]; then
      collision "$label/$name: real directory whose contents differ from $source"
    else
      collision "$label/$name: real file occupies the name"
    fi
    return 0
  fi

  if [ "$DRY_RUN" = true ]; then
    record "$label/$name: would link -> $source"
  else
    ln -s -- "$source" "$dest"
    record "$label/$name: linked -> $source"
  fi
  LINKED=$((LINKED + 1))
}

say ""
say "Targets"
t=0
while [ "$t" -lt "${#TARGET_PATHS[@]}" ]; do
  target="${TARGET_PATHS[$t]}"
  label="${TARGET_LABELS[$t]}"

  if ! prepare_target "$target" "$label"; then
    t=$((t + 1))
    continue
  fi

  n=0
  while [ "$n" -lt "${#NAMES[@]}" ]; do
    name="${NAMES[$n]}"
    if is_conflicted "$name"; then
      # The name is skipped, but something may already sit there from before.
      # A stale copy under a conflicted name is the easiest thing to miss.
      if [ "$TARGET_ASSUME_EMPTY" = false ] && { [ -e "$target/$name" ] || [ -L "$target/$name" ]; }; then
        collision "$label/$name: conflicted name is already occupied here; the sync neither created nor touched it"
      fi
      n=$((n + 1))
      continue
    fi
    # During a dry run the directory the links would land in may not exist yet,
    # so report the intent rather than inspecting the pre-migration layout.
    if [ "$TARGET_ASSUME_EMPTY" = true ]; then
      record "$label/$name: would link -> ${PATHS[$n]}"
      LINKED=$((LINKED + 1))
    else
      link_one "$target" "$label" "$name" "${PATHS[$n]}"
    fi
    n=$((n + 1))
  done

  # Clear out links this script previously created for names that are no longer
  # present in any canonical source. Only self-created links qualify.
  if [ "$TARGET_ASSUME_EMPTY" = false ] && [ -d "$target" ] && [ ! -L "$target" ]; then
    while IFS= read -r -d '' dead; do
      dname="$(basename -- "$dead")"
      dtarget="$(readlink -- "$dead")"
      is_under_source "$dtarget" || continue
      [ -e "$dead" ] && continue
      if index_of "$dname" >/dev/null 2>&1; then continue; fi
      if [ "$DRY_RUN" = true ]; then
        record "$label/$dname: would remove stale link -> $dtarget"
      else
        rm -- "$dead"
        record "$label/$dname: removed stale link -> $dtarget"
      fi
      REPAIRED=$((REPAIRED + 1))
    done < <(find "$target" -mindepth 1 -maxdepth 1 -type l -print0 | sort -z)
  fi

  t=$((t + 1))
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

if [ "${#ACTION_LINES[@]}" -gt 0 ] && { [ "$VERBOSE" = true ] || [ "$DRY_RUN" = true ]; }; then
  say ""
  say "Actions"
  for line in "${ACTION_LINES[@]}"; do
    say "  $line"
  done
fi

if [ "${#INVALID_LINES[@]}" -gt 0 ]; then
  say ""
  say "Invalid entries in the canonical sources (not linked)"
  for line in "${INVALID_LINES[@]}"; do
    say "  $line"
  done
fi

if [ "${#COLLISION_LINES[@]}" -gt 0 ]; then
  say ""
  say "Target collisions (left untouched, needs a decision)"
  for line in "${COLLISION_LINES[@]}"; do
    say "  $line"
  done
fi

say ""
say "----------------------------------------------------------------------------"
say "Summary"
say "  linked      $LINKED"
say "  repaired    $REPAIRED"
say "  adopted     $ADOPTED"
say "  unchanged   $UNCHANGED"
say "  conflicts   $SKIPPED_CONFLICT   (duplicate names with different contents)"
say "  collisions  $SKIPPED_COLLISION   (target names already taken)"
say "  invalid     $INVALID   (entries in the sources that are not usable skills)"
[ "$DRY_RUN" = true ] && say "  dry run: no changes were written"

status=0
if [ "$SKIPPED_CONFLICT" -gt 0 ] || [ "$SKIPPED_COLLISION" -gt 0 ]; then
  status=1
  say ""
  say "Exiting 1: unresolved conflicts or target collisions remain."
fi
exit "$status"
