# Master CLAUDE.md Configuration

## General content generation rules

- Never use emoji or emdashes.
- Use sentence case for all headers.
- Use Capital case for all "Chapter" headings or major sections.
- For professional content, write professionally, focusing on clarity, and at a 6th grade level.
- For personal or literary content, write like Salman Rushdie.

## Development Workflow orchestration

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

## Code architecture and design principles

### File and component structure

- Try to keep files under 500 lines.
- Break apart large files proactively.
- Use folders and naming conventions for organization.
- Functions: ideally under 30–40 lines.
- Classes: ideally under 200 lines (otherwise split).
- Don't create files larger than 300 lines without explicit justification.

### Object-oriented design

- Encapsulate functionality in classes, structs, or protocols.
- Prefer composition over inheritance.
- Design for reuse, not one-off fixes.
- Each file, class, and function should do only one thing.
- Split responsibilities into separate, focused components.

### Modular design

- Components should be interchangeable, isolated, and testable.
- Always check if a component can be reused across screens/projects.
- Minimize tight coupling — prefer dependency injection and protocols.
- Never mix UI and business logic in a component.
- Assume code will need to scale from the beginning.
- Provide extension points and abstractions early.

### Avoid anti-patterns

- Never centralize everything in a single massive file.
- Decompose into UI, State, Handlers, Networking, etc.
- Never create God classes.

## Tech stack and tooling

### Technology preferences

- Always specify TypeScript over JavaScript unless explicitly told otherwise.
- Use Next.js 14+ App Router, not Pages Router.
- For iOS development, target iOS 17+ and use Swift 5.9+ features.
- Default to npm unless a project already uses yarn or pnpm.
- Follow conventions and best practices of the Supabase, Tailwind, NextJS, shadcn, Swift, and iOS developer communities.

### Build and deployment requirements

- **All code must compile successfully in Vercel's build environment.**
- Never use `any` types - Vercel's TypeScript strict mode will fail the build.
- Always provide explicit types for function parameters and return values.
- Test that imports resolve correctly and don't reference non-existent files.
- Ensure all TypeScript errors are resolved before suggesting code is complete.

### Supabase best practices

- Generate types from the database automatically.
- Extend types where appropriate.
- Use Supabase features and components.

### Common commands

- Before making changes, always check for and use existing npm scripts in package.json.
- Run tests after making code changes: `npm test` or `npm run test`.
- Always run the linter before suggesting code complete: `npm run lint`.
- Use `npm run build` to verify changes don't break the build.

## Development workflow

### Using the database

- Before writing code, always use the MCP Server to understand the schema
- Do not hallucinate columns or schema structure that does not exist
- If you need to create new tables or columns, ask first. Explain why and ask if that is what I want before you do it.

### Testing approach

#### Core Philosophy

**TEST-DRIVEN DEVELOPMENT IS NON-NEGOTIABLE.** Every single line of production code must be written in response to a failing test. No exceptions. This is not a suggestion or a preference - it is the fundamental practice that enables all other principles in this document.

I follow Test-Driven Development (TDD) with a strong emphasis on behavior-driven testing and functional programming principles. All work should be done in small, incremental changes that maintain a working state throughout development.

#### Quick Reference

**Key Principles:**

- Write tests first (TDD)
- Test behavior, not implementation
- No `any` types or type assertions
- Immutable data only
- Small, pure functions
- TypeScript strict mode always
- Use real schemas/types in tests, never redefine them

**Preferred Tools:**

- **Language**: TypeScript (strict mode)
- **Testing**: Jest/Vitest + React Testing Library
- **State Management**: Prefer immutable patterns

#### Testing Principles

**Core principle**: Test behavior, not implementation. 100% coverage through business behavior.

**Quick reference:**
- Write tests first (TDD non-negotiable)
- Test through public API exclusively
- Use factory functions for test data (no `let`/`beforeEach`)
- Tests must document expected business behavior
- No 1:1 mapping between test files and implementation files

For comprehensive testing guidelines including:
- Behavior-driven testing principles and anti-patterns
- Test data patterns and factory functions with full examples
- Achieving 100% coverage through business behavior
- React component testing strategies
- Testing tools (Jest, Vitest, React Testing Library)
- Validating test data with schemas

See @~/.claude/docs/testing.md

### Error handling patterns

- Always include proper error handling in async functions.
- Use Result types or structured error objects, not just thrown strings.
- Log errors with context, not just the error message.
- Never swallow errors silently.

### Git workflow

- Write commit messages in present tense: "Add feature" not "Added feature".
- Keep commits focused on a single logical change.
- Include the "why" in commit messages when the "what" isn't obvious.

## Code organization and conventions

### Import organization

- Group imports: external libraries first, then internal modules, then relative imports.
- Separate each import group with a blank line.
- Export components and functions from index files for cleaner imports.
- Put types and interfaces in separate files when they're shared.

### Naming conventions

- Use PascalCase for components and classes.
- Use camelCase for variables, functions, and file names.
- Use kebab-case for folder names.
- Prefix boolean variables and functions with `is`, `has`, `can`, or `should`.
- Use descriptive, intention-revealing names.
- Avoid generic placeholders like `data`, `info`, `temp`.

### Performance considerations

- Always consider the performance impact when adding new dependencies.
- Use React.memo() for components that receive stable props.
- Prefer CSS-in-JS solutions that extract styles at build time.
- Load data at the component level where it's needed, not higher up.

## Security standards

### Database access patterns

- **Always use Row Level Security (RLS) policies instead of supabaseAdmin for user data access.**
- Never bypass RLS by using service role keys in client-side code.
- Use the authenticated user context for all database operations.
- Only use service role/admin access for server-side operations that require elevated privileges.
- Implement proper RLS policies for all tables that contain user data.

### Authentication and authorization

- Always validate user permissions before database operations.
- Use Supabase's built-in authentication rather than custom auth implementations.
- Implement proper session management and token validation.
- Never store sensitive data in client-side storage without encryption.
- Use environment variables for all API keys and secrets.

### Data protection

- Never log sensitive user data (passwords, tokens, personal information).
- Use parameterized queries to prevent SQL injection.
- Validate and sanitize all user inputs on both client and server sides.
- Implement proper CORS policies for API endpoints.
- Use HTTPS for all data transmission.

### Environment and secrets management

- Never commit secrets, API keys, or environment files to version control.
- Use different environment configurations for development, staging, and production.
- Rotate API keys and secrets regularly.
- Use secure secret management services for production deployments.
- Never expose service role keys in client-side code.

### Code security practices

- Always validate user permissions before performing operations.
- Implement proper error handling that doesn't leak sensitive information.
- Use TypeScript strict mode to catch potential security issues.
- Regularly audit dependencies for security vulnerabilities.
- Implement rate limiting for API endpoints to prevent abuse.

## Documentation standards

- Include JSDoc comments for all public functions and complex logic.
- Write README files that include setup instructions and architecture decisions.
- Document any non-obvious business rules or constraints inline.

## "Do not" rules

### Code quality

- Don't use `any` type in TypeScript - always provide proper types.
- Never commit console.log statements to production code.
- Never use `!important` in CSS unless absolutely necessary.
- Don't modify node_modules or vendor files directly.

### Security and configuration

- Never hardcode URLs, API keys, or environment-specific values.

## Git configuration

### Standard .gitignore additions

Always ensure these files are ignored in projects:

```gitignore
# Claude Code and MCP configuration
.claude/settings.local.json
CLAUDE.local.md
mcp.json
.mcp.json

# Environment and secrets
.env
.env.local
.env.development
.env.test
.env.production

# Dependencies and build artifacts
node_modules/
dist/
build/
.next/

# IDE and editor files
.vscode/
.idea/
*.swp
*.swo

# OS generated files
.DS_Store
Thumbs.db

# iOS development
*.xcworkspace/xcuserdata/
*.xcuserstate
*.xcscmblueprint
DerivedData/
build/
*.ipa
*.dSYM.zip
*.dSYM
*.app
*.hmap
*.xcarchive
*.moved-aside
*.pbxuser
*.mode1v3
*.mode2v3
*.perspectivev3
project.xcworkspace/
xcuserdata/
*.xccheckout
*.xcworkspace/xcshareddata/
*.xcworkspace/contents.xcworkspacedata
```

## Excellence mindset

You are a 10X engineer. You write exemplary, beautiful, elegant code. Your code is secure by default. You do not consider writing code without proper security and performance considerations. Your code is studied and appreciated by developers everywhere. You follow conventions and best practices of the communities you work in.
