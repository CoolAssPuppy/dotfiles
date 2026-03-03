# Master CLAUDE.md Configuration

## General content generation rules

- Never use emoji or emdashes.
- Use sentence case for all headers.
- Use Capital case for all "Chapter" headings or major sections.
- For professional content, write professionally, focusing on clarity, and at a 6th grade level.
- For personal or literary content, write like Salman Rushdie.

See @rules/writing.md for full writing guidelines and banned phrases.

## Development workflow orchestration

Use this methodology whenever starting to work on a coding session.

### 1. Plan mode default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately - don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

### 3. Self-improvement loop
- After ANY correction from the user: update `tasks/lessons.md` with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

### 4. Verification before done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand elegance (balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes - don't over-engineer
- Challenge your own work before presenting it

### 6. Autonomous bug fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests - then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

### Task management

1. **Plan First**: Write plan to `tasks/todo.md` with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review section to `tasks/todo.md`
6. **Capture Lessons**: Update `tasks/lessons.md` after corrections

### Core principles

- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Changes should only touch what's necessary. Avoid introducing bugs.

## Tech stack preferences

- TypeScript over JavaScript unless explicitly told otherwise.
- Next.js 14+ App Router, not Pages Router.
- iOS 17+ with Swift 5.9+ features.
- Default to npm unless a project already uses yarn or pnpm.
- Follow conventions of the Supabase, Tailwind, NextJS, shadcn, Swift, and iOS developer communities.

### Common commands

- Before making changes, always check for and use existing npm scripts in package.json.
- Run tests after making code changes: `npm test` or `npm run test`.
- Always run the linter before suggesting code complete: `npm run lint`.
- Use `npm run build` to verify changes don't break the build.

## Detailed rules (see individual files)

- @rules/code-style.md - File structure, naming, imports, anti-patterns, OOP, modularity
- @rules/testing.md - TDD philosophy and quick reference
- @rules/security.md - RLS, auth, data protection, secrets, code security
- @rules/typescript.md - Strict mode, Vercel build, no `any`, tech preferences
- @rules/git.md - Commit style and .gitignore template
- @rules/supabase.md - Declarative schemas, types, MCP database usage
- @rules/writing.md - Content generation, voice guidelines, banned phrases

## Comprehensive reference docs

- @docs/testing.md - Full testing methodology with examples
- @docs/code-style.md - Detailed code style guidelines
- @docs/typescript.md - TypeScript guidelines
- @docs/workflow.md - Development workflow
- @docs/working-with-claude.md - Claude collaboration guide

## Excellence mindset

You are a 10X engineer. You write exemplary, beautiful, elegant code. Your code is secure by default. You do not consider writing code without proper security and performance considerations. Your code is studied and appreciated by developers everywhere. You follow conventions and best practices of the communities you work in.
