#!/usr/bin/env bash
# Shared status output. Source this; do not execute it.

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  C_RESET=$'\033[0m'
  C_GREEN=$'\033[32m'
  C_RED=$'\033[31m'
  C_DIM=$'\033[2m'
  C_BOLD=$'\033[1m'
else
  C_RESET='' C_GREEN='' C_RED='' C_DIM='' C_BOLD=''
fi

CLEAR_LINE=$'\r\033[2K'

ok()   { printf '%s%s✓%s %s\n' "$CLEAR_LINE" "$C_GREEN" "$C_RESET" "$1"; }
fail() { printf '%s%s✗%s %s\n' "$CLEAR_LINE" "$C_RED" "$C_RESET" "$1"; }
note() { printf '%s%s%s\n' "$C_DIM" "$1" "$C_RESET"; }

# step "Label" cmd...
# Runs cmd silently. On success prints a green check. On failure prints a red
# cross, dumps everything cmd wrote to stdout and stderr, and exits.
step() {
  local label="$1"; shift
  local log code
  log="$(mktemp)"

  printf '%s%s·%s %s' "$CLEAR_LINE" "$C_DIM" "$C_RESET" "$label"

  if "$@" >"$log" 2>&1; then
    ok "$label"
    rm -f "$log"
    return 0
  else
    code=$?
    # A child that read a password (sudo) can leave the tty without newline
    # translation, which prints the error dump as a staircase.
    if [[ -t 1 ]]; then stty sane 2>/dev/null || true; fi
    fail "$label"
    printf '\n%s%sFailed: %s (exit %d)%s\n\n' "$C_RED" "$C_BOLD" "$label" "$code" "$C_RESET" >&2
    cat "$log" >&2
    printf '\n' >&2
    rm -f "$log"
    exit "$code"
  fi
}

# soft_step "Label" cmd...
# Like step, but a failure warns and continues instead of aborting the run.
# For things that are not worth failing a whole machine setup over.
soft_step() {
  local label="$1"; shift
  local log
  log="$(mktemp)"

  printf '%s%s·%s %s' "$CLEAR_LINE" "$C_DIM" "$C_RESET" "$label"

  if "$@" >"$log" 2>&1; then
    ok "$label"
    rm -f "$log"
    return 0
  fi

  if [[ -t 1 ]]; then stty sane 2>/dev/null || true; fi
  fail "$label"
  SOFT_FAILURES="${SOFT_FAILURES:-}${SOFT_FAILURES:+, }$label"
  sed 's/^/    /' "$log" >&2
  rm -f "$log"
  return 0
}

# version "Label" cmd...
# Prints a green check with the tool's version, or a red cross if it is missing.
version() {
  local label="$1"; shift
  local out
  if out="$("$@" 2>/dev/null | head -1)"; then
    ok "$label $C_DIM$out$C_RESET"
  else
    fail "$label $C_DIM not found$C_RESET"
  fi
}
