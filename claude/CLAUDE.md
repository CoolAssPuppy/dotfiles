# Global instructions

Rules for every project. A project CLAUDE.md adds to these and never replaces
them. The rule files listed at the bottom load with this file, so nothing in
them is repeated here.

## Plain English, always

Direct, straightforward answers. Say what the thing is. Do not reach for a word
that describes how something reads, sounds, or functions when a plain word for
the thing itself exists.

**Banned in anything I write.** Chat, files, docs, reports, agent prompts, and
rules alike:

register, load-bearing, lands / landing (figurative), seams, beat (as a craft
term), circuit (figurative), engine (figurative), spine (figurative), surface
(as a verb), texture, in service of, does the work / doing the work, muscle
(figurative), through-line, arc (as a verb), sits on top of, holds / holding
(figurative), earns / earned (figurative), carries (figurative).

Plus the full banned list in @rules/writing.md. Read that list rather than
trusting memory.

**His files may use any of these. Mine may not.** His bible, his notes, and his
drafts have their own vocabulary and it is not mine to strip. Quoting his word
back to him is fine. Naming a section he titled is fine. Adopting the vocabulary
into my own sentences is not.

**The test.** If the sentence explains how a thing reads instead of saying what
it is, rewrite it. "Isabella's jokes are what she does instead of hitting
someone" is the note. "The charm is the leash" is me admiring my own phrasing.

This is a repeat correction. If a message is about to use one of these words,
stop and write the plain sentence instead.

## Writing

Every content rule (no emoji, no em dashes, sentence case headers, the banned
phrase list, voice by audience) lives in @rules/writing.md. Use the `/writing`
skill for any drafting or editing task.

## Working efficiently

- Don't re-read a file immediately after editing it; the edit tool already confirms success.
- Don't run redundant verification steps after a tool call already confirmed success.
- Read targeted line ranges or use grep to locate code before reading a whole large file.
- Don't spawn a subagent for a task that fits in one or two direct tool calls.
- Batch independent tool calls into a single turn instead of one call per turn.
- Keep responses concise by default; don't restate what a diff or tool output already shows.

## Development workflow

Use this on every coding session.

### Plan first
- Enter plan mode for any non-trivial task (3+ steps or an architectural decision).
- Write detailed specs upfront to reduce ambiguity.
- Write the plan to `tasks/todo.md` as checkable items and check in before implementing.
- Mark items complete as you go, give a short summary at each step, and add a review section to `tasks/todo.md` when done.
- If something goes sideways, stop and re-plan. Don't keep pushing.

### Subagents
- Use subagents for research, exploration, and parallel analysis so the main context stays clean.
- One task per subagent. For hard problems, run more subagents in parallel.

### Bugs
- Given a bug report, fix it. Don't ask for hand-holding.
- Start from the logs, errors, and failing tests, then resolve them. Fix failing CI without being told how.

### Verify before done
- Never mark a task complete without proving it works. Run tests, check logs, demonstrate correctness.
- Diff behavior between main and your changes when relevant.
- Ask: "Would a staff engineer approve this?"

### Elegance, balanced
- For non-trivial changes, pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution."
- Skip this for simple, obvious fixes. Don't over-engineer.

### Learn from corrections
- After any correction from the user, add the pattern to `tasks/lessons.md` as a rule that prevents the repeat.
- Review `tasks/lessons.md` at the start of each session in that project.

### Core principles
- **Simplicity first.** Make every change as simple as possible and touch the minimum code.
- **No laziness.** Find root causes. No temporary fixes.
- **Minimal impact.** Change only what is necessary.
- **Secure and fast by default.** Security and performance are part of every change. Follow the conventions of the community you are working in.

## Commands

- Before making changes, check package.json for existing npm scripts and use them.
- After code changes, run `npm test`, then `npm run lint`, then `npm run build` before calling the work complete.

## Rules (loaded with this file)

- @rules/code-style.md - File structure, naming, imports, anti-patterns, OOP, modularity
- @rules/testing.md - TDD philosophy and quick reference
- @rules/security.md - RLS, auth, data protection, secrets, code security
- @rules/typescript.md - Strict mode, Vercel build, no `any`, tech stack preferences
- @rules/git.md - Commit style and .gitignore template
- @rules/supabase.md - Declarative schemas, types, MCP database usage
- @rules/writing.md - Content generation, voice guidelines, banned phrases

## Reference docs (read on demand)

Read these only when you need depth beyond the rules above:

- `~/.claude/docs/testing.md` - Full testing methodology with examples
- `~/.claude/docs/code-style.md` - Detailed code style guidelines
- `~/.claude/docs/typescript.md` - TypeScript guidelines
- `~/.claude/docs/workflow.md` - Development workflow (TDD playbook, refactoring, commits)
- `~/.claude/docs/working-with-claude.md` - Claude collaboration guide
