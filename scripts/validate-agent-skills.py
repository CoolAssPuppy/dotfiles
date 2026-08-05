#!/usr/bin/env python3
"""Validate agent skills in the canonical source directories.

Checks folder naming, YAML frontmatter, required metadata, referenced local
files, broken relative links, non-portable absolute paths, Claude-specific
features that Codex does not implement, and likely secrets.

Writes a JSON report and a Markdown inventory, and prints a terminal summary.
Read-only: this script never modifies a skill.

Usage:
    validate-agent-skills.py [--json PATH] [--inventory PATH] [--quiet]
                             [--source LABEL=PATH ...] [--fail-on {error,warn,never}]

Exit codes:
    0  no findings at or above the --fail-on threshold
    1  findings at or above the threshold
    2  bad invocation or an unreadable source directory
"""

from __future__ import annotations

import argparse
import datetime as _dt
import filecmp
import hashlib
import json
import os
import re
import subprocess
import sys

# ---------------------------------------------------------------------------
# YAML: use a real parser when one is already installed, otherwise fall back to
# a deliberately small line-oriented reader that handles the flat key/value and
# block-scalar frontmatter that skills actually use.
# ---------------------------------------------------------------------------

try:  # pragma: no cover - depends on the machine
    import yaml as _yaml
except ImportError:  # pragma: no cover
    _yaml = None

YAML_BACKEND = "pyyaml" if _yaml else "builtin"

# One canonical directory now. Entries are real directories for skills written
# locally, and symlinks into ~/.agents/skills for skills the skills CLI owns.
DEFAULT_SOURCES = [
    ("canonical", "~/Developer/brain/skills"),
]

REPORT_DIR = "~/Developer/dotfiles/reports"
DEFAULT_JSON = os.path.join(REPORT_DIR, "agent-skills-validation.json")
DEFAULT_INVENTORY = os.path.join(REPORT_DIR, "agent-skills-inventory.md")

SKILL_FILENAMES = ("SKILL.md", "skill.md")
REQUIRED_KEYS = ("name", "description")

# Directories that are support material rather than skills.
IGNORED_ENTRIES = {".DS_Store", "skills-lock.json", ".skill-lock.json"}

FRONTMATTER_RE = re.compile(r"\A---[ \t]*\r?\n(.*?)\r?\n---[ \t]*(?:\r?\n|\Z)", re.S)
DIRNAME_RE = re.compile(r"\A[a-z0-9]+(?:[-_][a-z0-9]+)*\Z")

# ---------------------------------------------------------------------------
# Claude-specific features. Codex reads name/description frontmatter and the
# Markdown body; everything below is either ignored or unsupported there.
# ---------------------------------------------------------------------------

CLAUDE_FRONTMATTER_KEYS = {
    "allowed-tools": (
        "Codex ignores per-skill tool allowlists; the skill runs with the "
        "session's tools instead of the narrower set."
    ),
    "disable-model-invocation": (
        "Codex has no model-invocation gate; the skill may be picked up "
        "automatically where Claude Code would require an explicit call."
    ),
    "user-invocable": (
        "Codex has no /slash invocation registry; the flag is inert."
    ),
    "context": ("Codex does not preload a context bundle from frontmatter."),
    "agent": ("Codex has no subagent binding in skill frontmatter."),
    "model": ("Codex does not honour a per-skill model pin."),
}

BODY_PATTERNS = [
    (
        "CLAUDE_SKILL_DIR",
        re.compile(r"\$\{?CLAUDE_SKILL_DIR\}?"),
        "Codex does not export CLAUDE_SKILL_DIR; the path expands to an empty string.",
    ),
    (
        "shell-interpolation",
        re.compile(r"(?m)^\s*(?:[-*+]\s+)?!(?:`|\s*[A-Za-z_./~][^\n]*)"),
        "Claude Code's `!command` interpolation has no Codex equivalent; the line is read as literal text.",
    ),
]

# ---------------------------------------------------------------------------
# Secret detection. Patterns are deliberately narrow so that prose about API
# keys does not trip them. Values are never printed in full.
# ---------------------------------------------------------------------------

SECRET_PATTERNS = [
    ("aws-access-key-id", re.compile(r"\b(?:AKIA|ASIA)[0-9A-Z]{16}\b")),
    ("github-token", re.compile(r"\bgh[pousr]_[A-Za-z0-9]{36,}\b")),
    ("slack-token", re.compile(r"\bxox[abposr]-[A-Za-z0-9-]{10,}\b")),
    ("stripe-secret-key", re.compile(r"\b[sr]k_(?:live|test)_[A-Za-z0-9]{16,}\b")),
    ("anthropic-key", re.compile(r"\bsk-ant-[A-Za-z0-9_-]{20,}\b")),
    ("openai-key", re.compile(r"\bsk-(?:proj-)?[A-Za-z0-9]{32,}\b")),
    ("google-api-key", re.compile(r"\bAIza[0-9A-Za-z_-]{35}\b")),
    ("supabase-service-key", re.compile(r"\bsb_secret_[A-Za-z0-9_-]{20,}\b")),
    ("jwt", re.compile(r"\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\b")),
    ("private-key-block", re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH |PGP )?PRIVATE KEY-----")),
    (
        "assigned-credential",
        re.compile(
            r"(?i)\b(?:api[_-]?key|secret[_-]?key|access[_-]?token|auth[_-]?token"
            r"|client[_-]?secret|password|passwd)\b\s*[:=]\s*"
            r"[\"']?([A-Za-z0-9/+_-]{16,})[\"']?"
        ),
    ),
]

# Values that look like credentials but are placeholders.
PLACEHOLDER_RE = re.compile(
    r"(?i)\b(?:your|my|the|example|sample|placeholder|redacted|dummy|fake|test|xxx+|"
    r"insert|replace|todo|changeme|abc123|<[^>]+>|\{\{[^}]+\}\}|\$\{[^}]+\})"
)

SECRET_FILENAME_RE = re.compile(
    r"(?i)(?:\A|/)(?:\.env(?:\..+)?|.*\.(?:pem|p8|p12|pfx|key|keystore|jks)"
    r"|.*credentials.*|.*\.secrets?(?:\..+)?)\Z"
)

BINARY_EXTS = {
    ".png", ".jpg", ".jpeg", ".gif", ".webp", ".ico", ".pdf", ".mp4", ".mov",
    ".zip", ".gz", ".tgz", ".woff", ".woff2", ".ttf", ".otf", ".mp3", ".wav",
}

TEXT_EXTS = {
    ".md", ".markdown", ".txt", ".py", ".sh", ".bash", ".zsh", ".js", ".ts",
    ".tsx", ".jsx", ".json", ".yaml", ".yml", ".toml", ".cfg", ".ini", ".sql",
    ".rb", ".go", ".rs", ".html", ".css", "",
}

# Markdown links and images: ![alt](target) and [text](target).
MD_LINK_RE = re.compile(r"!?\[[^\]]*\]\(\s*<?([^)\s>]+)>?(?:\s+[\"'][^\"']*[\"'])?\s*\)")
# Backticked paths that look like files inside the skill, e.g. `scripts/run.py`.
BACKTICK_PATH_RE = re.compile(r"`([A-Za-z0-9_.][A-Za-z0-9_./-]*\.[A-Za-z0-9]{1,6})`")
ABS_PATH_RE = re.compile(r"(?<![\w`~])(/(?:Users|home|opt|var|private|tmp|usr/local)/[A-Za-z0-9._/-]+)")

EXTERNAL_SCHEMES = ("http://", "https://", "mailto:", "tel:", "ftp://", "data:")


# ---------------------------------------------------------------------------
# Findings
# ---------------------------------------------------------------------------

SEVERITIES = ("error", "warn", "info")


class Findings:
    """Ordered collection of findings for one skill."""

    def __init__(self) -> None:
        self.items: list[dict] = []

    def add(self, severity: str, code: str, message: str, **extra) -> None:
        entry = {"severity": severity, "code": code, "message": message}
        entry.update(extra)
        self.items.append(entry)

    def count(self, severity: str) -> int:
        return sum(1 for i in self.items if i["severity"] == severity)

    @property
    def status(self) -> str:
        if self.count("error"):
            return "fail"
        if self.count("warn"):
            return "warn"
        return "pass"


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def expand(path: str) -> str:
    return os.path.abspath(os.path.expanduser(os.path.expandvars(path)))


def redact(value: str) -> str:
    """Fingerprint a suspected secret without disclosing it."""
    value = value.strip()
    digest = hashlib.sha256(value.encode("utf-8", "replace")).hexdigest()[:8]
    head = value[:4] if len(value) > 12 else value[:2]
    return f"{head}… ({len(value)} chars, sha256:{digest})"


def find_skill_file(directory: str) -> str | None:
    for name in SKILL_FILENAMES:
        candidate = os.path.join(directory, name)
        if os.path.isfile(candidate):
            return candidate
    return None


def read_text(path: str) -> str | None:
    try:
        with open(path, "rb") as handle:
            raw = handle.read()
    except OSError:
        return None
    if b"\0" in raw[:8192]:
        return None
    return raw.decode("utf-8", "replace")


def parse_frontmatter(text: str) -> tuple[dict | None, str]:
    """Return (mapping, body). mapping is None when frontmatter is absent."""
    match = FRONTMATTER_RE.match(text)
    if not match:
        return None, text
    block = match.group(1)
    body = text[match.end():]

    if _yaml is not None:
        try:
            loaded = _yaml.safe_load(block)
        except Exception:
            loaded = None
        if isinstance(loaded, dict):
            return {str(k): loaded[k] for k in loaded}, body
        if loaded is not None:
            return {}, body
        # Fall through to the builtin reader on a parse failure so a malformed
        # document still yields whatever keys are recoverable.

    return _parse_frontmatter_builtin(block), body


def _parse_frontmatter_builtin(block: str) -> dict:
    """Minimal reader for flat keys, block scalars, and simple lists."""
    data: dict[str, object] = {}
    key: str | None = None
    # "block" is an explicit | or > scalar, "list" a sequence, "pending" a key
    # whose value is empty so far: the next line decides between a sequence and
    # a plain scalar folded across indented continuation lines.
    mode: str | None = None
    buffer: list[str] = []
    indent = 0

    def flush() -> None:
        nonlocal key, mode, buffer
        if key is None:
            return
        if mode == "block":
            data[key] = "\n".join(buffer).strip()
        elif mode == "folded":
            data[key] = " ".join(" ".join(buffer).split())
        elif mode == "list":
            data[key] = list(buffer)
        elif mode == "pending":
            data[key] = ""
        key, mode, buffer = None, None, []

    for raw in block.splitlines():
        if mode == "block":
            if raw.strip() == "" or (len(raw) - len(raw.lstrip())) > indent:
                buffer.append(raw[indent + 1:] if len(raw) > indent else "")
                continue
            flush()
        if mode in ("pending", "list") and re.match(r"^\s*-\s+", raw):
            mode = "list"
            buffer.append(raw.split("-", 1)[1].strip().strip("'\""))
            continue
        if mode in ("pending", "folded"):
            # An indented line under a key with no inline value continues that
            # value, which is how a long description is usually wrapped.
            if raw.strip() and (len(raw) - len(raw.lstrip())) > indent:
                mode = "folded"
                buffer.append(raw.strip())
                continue
            flush()
        elif mode == "list":
            flush()

        stripped = raw.strip()
        if not stripped or stripped.startswith("#"):
            continue

        match = re.match(r"^([A-Za-z0-9_.-]+)\s*:\s*(.*)$", raw)
        if match:
            flush()
            key, value = match.group(1), match.group(2).strip()
            if value in ("|", ">", "|-", ">-", "|+", ">+"):
                mode, buffer = "block", []
                indent = len(raw) - len(raw.lstrip())
                continue
            if value == "":
                mode, buffer = "pending", []
                indent = len(raw) - len(raw.lstrip())
                continue
            if value.startswith("[") and value.endswith("]"):
                inner = value[1:-1].strip()
                data[key] = [p.strip().strip("'\"") for p in inner.split(",") if p.strip()]
                key, mode = None, None
                continue
            data[key] = value.strip("'\"")
            key, mode = None, None
            continue

        # Continuation of a plain scalar folded across lines.
        if key is not None and isinstance(data.get(key), str) and raw.startswith((" ", "\t")):
            data[key] = (str(data[key]) + " " + stripped).strip()

    flush()
    return data


def as_text(value: object) -> str:
    if value is None:
        return ""
    if isinstance(value, str):
        return value
    if isinstance(value, (list, tuple)):
        return ", ".join(str(v) for v in value)
    return str(value)


def iter_files(directory: str):
    for root, dirs, files in os.walk(directory):
        dirs[:] = sorted(d for d in dirs if d not in {".git", "node_modules", "__pycache__"})
        for name in sorted(files):
            if name == ".DS_Store":
                continue
            yield os.path.join(root, name)


def directory_digest(directory: str) -> str:
    digest = hashlib.sha256()
    for path in iter_files(directory):
        digest.update(os.path.relpath(path, directory).encode())
        try:
            with open(path, "rb") as handle:
                digest.update(handle.read())
        except OSError:
            digest.update(b"<unreadable>")
    return digest.hexdigest()


def newest_mtime(directory: str) -> float:
    newest = 0.0
    for path in iter_files(directory):
        try:
            newest = max(newest, os.stat(path).st_mtime)
        except OSError:
            pass
    return newest


def git_last_commit(path: str) -> str | None:
    repo = path
    while repo != os.path.dirname(repo):
        if os.path.exists(os.path.join(repo, ".git")):
            break
        repo = os.path.dirname(repo)
    else:
        return None
    try:
        result = subprocess.run(
            ["git", "-C", repo, "log", "-1", "--format=%cI", "--", path],
            capture_output=True, text=True, timeout=30, check=False,
        )
    except (OSError, subprocess.SubprocessError):
        return None
    return result.stdout.strip() or None


def is_scannable(path: str) -> bool:
    ext = os.path.splitext(path)[1].lower()
    if ext in BINARY_EXTS:
        return False
    if ext and ext not in TEXT_EXTS:
        # Unknown extension: let read_text decide via its NUL check.
        return True
    return True


# ---------------------------------------------------------------------------
# Per-skill checks
# ---------------------------------------------------------------------------


def check_frontmatter(skill: dict, findings: Findings) -> None:
    meta = skill["frontmatter"]
    if meta is None:
        findings.add("error", "frontmatter-missing",
                     f"{skill['skill_file_name']} has no YAML frontmatter block")
        return
    if not meta:
        findings.add("error", "frontmatter-empty",
                     "frontmatter block is present but parsed to no keys")
        return

    for key in REQUIRED_KEYS:
        value = as_text(meta.get(key)).strip()
        if not value:
            findings.add("error", "frontmatter-required-key",
                         f"missing required frontmatter key: {key}")
        elif key == "description" and len(value) < 16:
            findings.add("warn", "description-too-short",
                         f"description is only {len(value)} characters; both runtimes "
                         "use it to decide relevance")

    declared = as_text(meta.get("name")).strip()
    if declared and declared != skill["name"]:
        findings.add("error", "name-mismatch",
                     f"frontmatter name '{declared}' does not match directory "
                     f"'{skill['name']}'; slash invocation resolves by directory")


def check_directory_name(skill: dict, findings: Findings) -> None:
    name = skill["name"]
    if not DIRNAME_RE.match(name):
        findings.add("warn", "dirname-nonstandard",
                     f"directory name '{name}' is not lowercase kebab-case; "
                     "some loaders reject it")
    if len(name) > 64:
        findings.add("warn", "dirname-too-long",
                     f"directory name is {len(name)} characters")
    if skill["skill_file_name"] != "SKILL.md":
        findings.add("warn", "skill-file-lowercase",
                     f"uses {skill['skill_file_name']}; Codex looks for SKILL.md "
                     "and is case-sensitive on Linux")


def check_claude_features(skill: dict, findings: Findings) -> list[str]:
    features: list[str] = []
    meta = skill["frontmatter"] or {}
    for key, note in CLAUDE_FRONTMATTER_KEYS.items():
        if key in meta:
            features.append(key)
            findings.add("info", "claude-only-frontmatter",
                         f"frontmatter key '{key}' is Claude-specific. {note}",
                         feature=key,
                         recommendation="Leave it in place. Codex ignores unknown keys, "
                                        "so no change is needed for compatibility.")
    text = skill["text"] or ""
    for name, pattern, note in BODY_PATTERNS:
        match = pattern.search(text)
        if not match:
            continue
        features.append(name)
        line = text[: match.start()].count("\n") + 1
        if name == "CLAUDE_SKILL_DIR":
            recommendation = ("Replace with a path relative to the skill directory, "
                              "which both runtimes resolve.")
        else:
            recommendation = ("Move the command into a fenced code block and tell the "
                              "agent to run it, rather than relying on interpolation.")
        findings.add("warn", "claude-only-body", f"{note} (line {line})",
                     feature=name, line=line, recommendation=recommendation)
    return features


def check_references(skill: dict, findings: Findings) -> None:
    """Resolve local file references and Markdown links inside the skill."""
    root = skill["path"]
    for path in iter_files(root):
        if os.path.splitext(path)[1].lower() not in {".md", ".markdown"}:
            continue
        text = read_text(path)
        if text is None:
            continue
        rel_doc = os.path.relpath(path, root)
        base = os.path.dirname(path)
        seen: set[str] = set()

        for match in MD_LINK_RE.finditer(text):
            target = match.group(1).strip()
            if not target or target in seen:
                continue
            seen.add(target)
            if target.startswith(EXTERNAL_SCHEMES) or target.startswith("#"):
                continue
            if target.startswith("~") or target.startswith("$"):
                findings.add("warn", "reference-non-portable",
                             f"{rel_doc}: link '{target}' depends on a home-relative "
                             "or environment path",
                             document=rel_doc, target=target)
                continue
            clean = target.split("#", 1)[0].split("?", 1)[0]
            if not clean:
                continue
            if os.path.isabs(clean):
                findings.add("error", "reference-absolute",
                             f"{rel_doc}: link '{clean}' is an absolute path and will "
                             "not survive being symlinked or cloned elsewhere",
                             document=rel_doc, target=clean)
                continue
            resolved = os.path.normpath(os.path.join(base, clean))
            if os.path.exists(resolved):
                if not resolved.startswith(root + os.sep) and resolved != root:
                    sibling = os.path.basename(os.path.dirname(resolved))
                    findings.add("warn", "reference-escapes-skill",
                                 f"{rel_doc}: link '{clean}' resolves outside the skill "
                                 f"directory to {resolved}; it does not follow the "
                                 "skill when symlinked",
                                 document=rel_doc, target=clean, resolved=resolved,
                                 recommendation=(
                                     f"link-skills.sh links the shared '{sibling}/' "
                                     "directory into both targets so this path still "
                                     "resolves. To make the skill self-contained, inline "
                                     "the shared content or copy it into the skill."
                                 ))
                continue
            # Documentation sites often link a Markdown page without its
            # extension. That works on the web and fails on disk, so report it
            # as a fixable warning rather than a dead reference.
            if not os.path.splitext(clean)[1] and os.path.exists(resolved + ".md"):
                findings.add("warn", "reference-missing-extension",
                             f"{rel_doc}: link '{clean}' resolves only once '.md' is "
                             "appended; on disk the link is dead",
                             document=rel_doc, target=clean,
                             recommendation=f"Write it as '{clean}.md'.")
                continue
            findings.add("error", "reference-broken",
                         f"{rel_doc}: link '{clean}' does not resolve to a file",
                         document=rel_doc, target=clean)

        for match in BACKTICK_PATH_RE.finditer(text):
            target = match.group(1)
            if target in seen or "/" not in target:
                continue
            seen.add(target)
            if target.startswith(EXTERNAL_SCHEMES) or os.path.isabs(target):
                continue
            relative = target[2:] if target.startswith("./") else target
            first = relative.split("/", 1)[0]
            # A skill may legitimately name a file it writes at run time, so only
            # look at paths rooted in a subdirectory the skill actually ships.
            if first in (".", "..", "") or not os.path.isdir(os.path.join(root, first)):
                continue
            if os.path.exists(os.path.normpath(os.path.join(root, relative))):
                continue
            findings.add("info", "asset-not-present",
                         f"{rel_doc}: names `{target}` under the shipped "
                         f"'{first}/' directory, but no such file is present",
                         document=rel_doc, target=target,
                         recommendation="Confirm the skill creates this at run time; "
                                        "otherwise add the file or correct the path.")


def check_portability(skill: dict, findings: Findings) -> None:
    root = skill["path"]
    home = os.path.expanduser("~")
    for path in iter_files(root):
        if not is_scannable(path):
            continue
        text = read_text(path)
        if text is None:
            continue
        rel_doc = os.path.relpath(path, root)
        reported: set[str] = set()
        for match in ABS_PATH_RE.finditer(text):
            found = match.group(1)
            if found in reported:
                continue
            reported.add(found)
            line = text[: match.start()].count("\n") + 1
            scope = "machine-specific" if found.startswith(home) else "system"
            findings.add("warn", "absolute-path",
                         f"{rel_doc}:{line} contains a {scope} absolute path "
                         f"'{found}'",
                         document=rel_doc, line=line, path=found,
                         recommendation="Use a path relative to the skill directory, "
                                        "or describe the location instead of hardcoding it.")
            if len(reported) >= 5:
                findings.add("info", "absolute-path-truncated",
                             f"{rel_doc}: further absolute paths not listed",
                             document=rel_doc)
                break


def check_secrets(skill: dict, findings: Findings) -> None:
    root = skill["path"]
    for path in iter_files(root):
        rel_doc = os.path.relpath(path, root)
        if SECRET_FILENAME_RE.search(rel_doc):
            findings.add("error", "secret-file",
                         f"{rel_doc} is a credential-shaped file and must not ship "
                         "inside a skill",
                         document=rel_doc,
                         recommendation="Move it out of the skill directory and read the "
                                        "value from the environment at run time.")
            continue
        if not is_scannable(path):
            continue
        text = read_text(path)
        if text is None:
            continue
        for label, pattern in SECRET_PATTERNS:
            for match in pattern.finditer(text):
                value = match.group(1) if match.groups() else match.group(0)
                if PLACEHOLDER_RE.search(value) or PLACEHOLDER_RE.search(
                    text[max(0, match.start() - 40): match.start()]
                ):
                    continue
                if label == "assigned-credential" and len(set(value)) < 8:
                    continue
                line = text[: match.start()].count("\n") + 1
                severity = "error" if label != "assigned-credential" else "warn"
                findings.add(severity, "secret-suspected",
                             f"{rel_doc}:{line} looks like a {label}: {redact(value)}",
                             document=rel_doc, line=line, kind=label,
                             fingerprint=redact(value),
                             recommendation="Confirm, then rotate the credential and "
                                            "replace it with an environment lookup.")
                break  # one report per pattern per file is enough


# ---------------------------------------------------------------------------
# Discovery
# ---------------------------------------------------------------------------


def discover(label: str, root: str) -> tuple[list[dict], list[dict]]:
    """Return (skills, anomalies) for one source directory."""
    skills: list[dict] = []
    anomalies: list[dict] = []

    for entry in sorted(os.listdir(root)):
        if entry.startswith(".") or entry in IGNORED_ENTRIES:
            continue
        path = os.path.join(root, entry)

        if os.path.islink(path) and not os.path.exists(path):
            anomalies.append({
                "source": label, "name": entry, "path": path,
                "kind": "broken-symlink", "target": os.readlink(path),
                "detail": f"symlink target '{os.readlink(path)}' does not resolve",
            })
            continue
        if not os.path.isdir(path):
            anomalies.append({
                "source": label, "name": entry, "path": path,
                "kind": "not-a-directory",
                "detail": "entry is a file, not a skill directory",
            })
            continue

        skill_file = find_skill_file(path)
        if skill_file is None:
            anomalies.append({
                "source": label, "name": entry, "path": path,
                "kind": "no-skill-file",
                "detail": "directory contains neither SKILL.md nor skill.md",
            })
            continue

        text = read_text(skill_file) or ""
        meta, body = parse_frontmatter(text)
        skills.append({
            "name": entry,
            "source": label,
            "path": path,
            "skill_file": skill_file,
            "skill_file_name": os.path.basename(skill_file),
            "frontmatter": meta,
            "text": text,
            "body": body,
            "digest": directory_digest(path),
            "mtime": newest_mtime(path),
            "git_last_commit": git_last_commit(path),
        })

    return skills, anomalies


def analyse_duplicates(by_name: dict[str, list[dict]]) -> list[dict]:
    conflicts: list[dict] = []
    for name in sorted(by_name):
        entries = by_name[name]
        if len(entries) < 2:
            continue
        first, second = entries[0], entries[1]
        identical = first["digest"] == second["digest"]

        files_a = {os.path.relpath(p, first["path"]) for p in iter_files(first["path"])}
        files_b = {os.path.relpath(p, second["path"]) for p in iter_files(second["path"])}
        differing = sorted(
            f for f in (files_a & files_b)
            if not filecmp.cmp(os.path.join(first["path"], f),
                               os.path.join(second["path"], f), shallow=False)
        )

        def newer_by(key):
            a, b = first.get(key), second.get(key)
            if a == b or a is None and b is None:
                return None
            if a is None:
                return second["source"]
            if b is None:
                return first["source"]
            return first["source"] if a > b else second["source"]

        conflicts.append({
            "name": name,
            "identical": identical,
            "sources": [
                {
                    "source": e["source"], "path": e["path"],
                    "digest": e["digest"],
                    "git_last_commit": e["git_last_commit"],
                    "mtime": _dt.datetime.fromtimestamp(e["mtime"]).isoformat(timespec="seconds"),
                }
                for e in entries
            ],
            "only_in": {
                first["source"]: sorted(files_a - files_b),
                second["source"]: sorted(files_b - files_a),
            },
            "differing_files": differing,
            "newer_by_git": newer_by("git_last_commit"),
            "newer_by_mtime": newer_by("mtime"),
            "resolution": "skipped-pending-manual-resolution" if not identical else "identical",
        })
    return conflicts


# ---------------------------------------------------------------------------
# Reporting
# ---------------------------------------------------------------------------


def build_report(sources: list[tuple[str, str]]) -> dict:
    all_skills: list[dict] = []
    anomalies: list[dict] = []
    source_summary = []

    for label, raw_root in sources:
        root = expand(raw_root)
        if not os.path.isdir(root):
            print(f"error: source directory not found: {root}", file=sys.stderr)
            raise SystemExit(2)
        skills, source_anomalies = discover(label, root)
        all_skills.extend(skills)
        anomalies.extend(source_anomalies)
        source_summary.append({
            "label": label,
            "path": root,
            "skill_count": len(skills),
            "anomaly_count": len(source_anomalies),
        })

    by_name: dict[str, list[dict]] = {}
    for skill in all_skills:
        by_name.setdefault(skill["name"], []).append(skill)
    conflicts = analyse_duplicates(by_name)
    conflicted_names = {c["name"] for c in conflicts if not c["identical"]}

    results = []
    for skill in all_skills:
        findings = Findings()
        check_directory_name(skill, findings)
        check_frontmatter(skill, findings)
        features = check_claude_features(skill, findings)
        check_references(skill, findings)
        check_portability(skill, findings)
        check_secrets(skill, findings)

        meta = skill["frontmatter"] or {}
        codex_notes = [
            f["message"] for f in findings.items
            if f["code"] in {"claude-only-body", "reference-absolute",
                             "reference-escapes-skill", "reference-non-portable",
                             "skill-file-lowercase"}
        ]
        results.append({
            "name": skill["name"],
            "source": skill["source"],
            "path": skill["path"],
            "skill_file": os.path.basename(skill["skill_file"]),
            "description": as_text(meta.get("description")).strip(),
            "status": findings.status,
            "errors": findings.count("error"),
            "warnings": findings.count("warn"),
            "notes": findings.count("info"),
            "claude_features": sorted(set(features)),
            "codex_concerns": codex_notes,
            "duplicate": skill["name"] in by_name and len(by_name[skill["name"]]) > 1,
            "conflict": skill["name"] in conflicted_names,
            "findings": findings.items,
            "digest": skill["digest"],
            "git_last_commit": skill["git_last_commit"],
        })

    results.sort(key=lambda r: (r["name"], r["source"]))

    return {
        "generated_at": _dt.datetime.now().astimezone().isoformat(timespec="seconds"),
        "yaml_backend": YAML_BACKEND,
        "sources": source_summary,
        "totals": {
            "skills": len(results),
            "unique_names": len(by_name),
            "duplicate_names": len([n for n, v in by_name.items() if len(v) > 1]),
            "unresolved_conflicts": len(conflicted_names),
            "failing": sum(1 for r in results if r["status"] == "fail"),
            "warning": sum(1 for r in results if r["status"] == "warn"),
            "passing": sum(1 for r in results if r["status"] == "pass"),
            "anomalies": len(anomalies),
        },
        "anomalies": anomalies,
        "conflicts": conflicts,
        "skills": results,
    }


def print_terminal(report: dict) -> None:
    line = "-" * 76
    print("Agent skills validation")
    print(f"generated {report['generated_at']}   yaml backend: {report['yaml_backend']}")
    print(line)
    for source in report["sources"]:
        print(f"  {source['label']:10s} {source['skill_count']:3d} skills, "
              f"{source['anomaly_count']} anomalies   {source['path']}")

    totals = report["totals"]
    print(line)
    print(f"  {totals['skills']} skills   "
          f"pass {totals['passing']}   warn {totals['warning']}   fail {totals['failing']}")
    print(f"  {totals['duplicate_names']} duplicate names, "
          f"{totals['unresolved_conflicts']} unresolved conflicts")

    if report["anomalies"]:
        print(line)
        print("Anomalies (skipped, not skills)")
        for item in report["anomalies"]:
            print(f"  [{item['source']}] {item['name']}: {item['detail']}")

    if report["conflicts"]:
        print(line)
        print("Duplicate names")
        for conflict in report["conflicts"]:
            verdict = "identical" if conflict["identical"] else "CONFLICT"
            print(f"  {conflict['name']}  ({verdict})")
            for entry in conflict["sources"]:
                print(f"      {entry['source']:10s} git {entry['git_last_commit'] or '-'}"
                      f"   mtime {entry['mtime']}")
            if not conflict["identical"]:
                print(f"      differing files : {', '.join(conflict['differing_files']) or '-'}")
                for src, only in conflict["only_in"].items():
                    if only:
                        print(f"      only in {src}: {', '.join(only)}")
                print(f"      newer by git {conflict['newer_by_git'] or '-'}, "
                      f"by mtime {conflict['newer_by_mtime'] or '-'}")
                print("      resolution: skipped until resolved by hand")

    flagged = [r for r in report["skills"] if r["errors"] or r["warnings"]]
    if flagged:
        print(line)
        print("Findings")
        for result in flagged:
            print(f"  {result['name']} [{result['source']}] "
                  f"{result['errors']} error(s), {result['warnings']} warning(s)")
            for finding in result["findings"]:
                if finding["severity"] == "info":
                    continue
                print(f"      {finding['severity']:5s} {finding['code']}: {finding['message']}")
                if finding.get("recommendation"):
                    print(f"            fix: {finding['recommendation']}")

    info_only = [r for r in report["skills"] if r["claude_features"]]
    if info_only:
        print(line)
        print(f"Claude-specific features present in {len(info_only)} skills "
              "(reported, never stripped)")
        buckets: dict[str, list[str]] = {}
        for result in info_only:
            for feature in result["claude_features"]:
                buckets.setdefault(feature, []).append(result["name"])
        for feature in sorted(buckets):
            names = buckets[feature]
            shown = ", ".join(names[:6])
            more = f", +{len(names) - 6} more" if len(names) > 6 else ""
            print(f"  {feature:26s} {len(names):3d}  {shown}{more}")
    print(line)


INVENTORY_STATUS = {"pass": "pass", "warn": "warn", "fail": "fail"}


def write_inventory(report: dict, path: str) -> None:
    def cell(value: str, limit: int = 160) -> str:
        value = " ".join(str(value).split())
        value = value.replace("|", "\\|")
        if len(value) > limit:
            value = value[: limit - 1].rstrip() + "…"
        return value or "-"

    lines = [
        "# Agent skills inventory",
        "",
        f"Generated {report['generated_at']} by `scripts/validate-agent-skills.py`.",
        "Do not edit by hand. Regenerate instead.",
        "",
        "## Sources",
        "",
        "| Source | Path | Skills | Anomalies |",
        "| --- | --- | --- | --- |",
    ]
    for source in report["sources"]:
        lines.append(f"| {source['label']} | `{source['path']}` | "
                     f"{source['skill_count']} | {source['anomaly_count']} |")

    totals = report["totals"]
    lines += [
        "",
        "## Totals",
        "",
        f"- {totals['skills']} skills across {totals['unique_names']} unique names",
        f"- {totals['passing']} pass, {totals['warning']} warn, {totals['failing']} fail",
        f"- {totals['duplicate_names']} duplicate names, "
        f"{totals['unresolved_conflicts']} unresolved conflicts",
        f"- {totals['anomalies']} anomalies in the source directories",
        "",
        "## Skills",
        "",
        "| Skill | Source | Description | Status | Claude-specific features | "
        "Codex concerns | Duplicate / conflict |",
        "| --- | --- | --- | --- | --- | --- | --- |",
    ]

    for result in report["skills"]:
        if result["conflict"]:
            dup = "conflict, skipped"
        elif result["duplicate"]:
            dup = "duplicate, identical"
        else:
            dup = "unique"
        features = ", ".join(result["claude_features"]) or "none"
        concerns = "; ".join(result["codex_concerns"]) or "none"
        status = INVENTORY_STATUS[result["status"]]
        if result["errors"] or result["warnings"]:
            status += f" ({result['errors']}E/{result['warnings']}W)"
        lines.append(
            f"| `{result['name']}` | {result['source']} | {cell(result['description'])} "
            f"| {status} | {cell(features, 80)} | {cell(concerns, 200)} | {dup} |"
        )

    if report["conflicts"]:
        lines += ["", "## Duplicate names", ""]
        for conflict in report["conflicts"]:
            lines.append(f"### `{conflict['name']}`")
            lines.append("")
            lines.append("Identical in both sources."
                         if conflict["identical"]
                         else "**Conflict. Skipped by the sync script until resolved by hand.**")
            lines.append("")
            lines.append("| Source | Path | Last commit | Newest mtime |")
            lines.append("| --- | --- | --- | --- |")
            for entry in conflict["sources"]:
                lines.append(f"| {entry['source']} | `{entry['path']}` | "
                             f"{entry['git_last_commit'] or '-'} | {entry['mtime']} |")
            if not conflict["identical"]:
                lines += [
                    "",
                    f"- Differing files: {', '.join(f'`{f}`' for f in conflict['differing_files']) or 'none'}",
                ]
                for src, only in conflict["only_in"].items():
                    if only:
                        lines.append(f"- Only in {src}: "
                                     + ", ".join(f"`{f}`" for f in only))
                lines += [
                    f"- Newer by git history: {conflict['newer_by_git'] or 'undetermined'}",
                    f"- Newer by file mtime: {conflict['newer_by_mtime'] or 'undetermined'}",
                ]
            lines.append("")

    if report["anomalies"]:
        lines += ["", "## Anomalies", "",
                  "| Source | Entry | Kind | Detail |", "| --- | --- | --- | --- |"]
        for item in report["anomalies"]:
            lines.append(f"| {item['source']} | `{item['name']}` | {item['kind']} | "
                         f"{cell(item['detail'])} |")

    flagged = [r for r in report["skills"] if r["errors"] or r["warnings"]]
    if flagged:
        lines += ["", "## Findings", ""]
        for result in flagged:
            lines.append(f"### `{result['name']}` ({result['source']})")
            lines.append("")
            for finding in result["findings"]:
                if finding["severity"] == "info":
                    continue
                lines.append(f"- **{finding['severity']}** `{finding['code']}` "
                             f"{cell(finding['message'], 400)}")
                if finding.get("recommendation"):
                    lines.append(f"  - Smallest fix: {cell(finding['recommendation'], 400)}")
            lines.append("")

    lines.append("")
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as handle:
        handle.write("\n".join(lines))


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--json", default=DEFAULT_JSON, help="path for the JSON report")
    parser.add_argument("--inventory", default=DEFAULT_INVENTORY,
                        help="path for the Markdown inventory")
    parser.add_argument("--quiet", action="store_true", help="suppress the terminal report")
    parser.add_argument("--source", action="append", metavar="LABEL=PATH",
                        help="override the source directories (repeatable)")
    parser.add_argument("--fail-on", choices=("error", "warn", "never"), default="error",
                        help="exit nonzero at this severity or above (default: error)")
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)

    sources = DEFAULT_SOURCES
    if args.source:
        sources = []
        for item in args.source:
            if "=" not in item:
                print(f"error: --source expects LABEL=PATH, got '{item}'", file=sys.stderr)
                return 2
            label, path = item.split("=", 1)
            sources.append((label, path))

    report = build_report(sources)

    json_path = expand(args.json)
    os.makedirs(os.path.dirname(json_path), exist_ok=True)
    with open(json_path, "w", encoding="utf-8") as handle:
        json.dump(report, handle, indent=2, sort_keys=False)
        handle.write("\n")

    inventory_path = expand(args.inventory)
    write_inventory(report, inventory_path)

    if not args.quiet:
        print_terminal(report)
        print(f"JSON report : {json_path}")
        print(f"Inventory   : {inventory_path}")

    totals = report["totals"]
    if args.fail_on == "never":
        return 0
    if totals["failing"] or totals["unresolved_conflicts"]:
        return 1
    if args.fail_on == "warn" and totals["warning"]:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
