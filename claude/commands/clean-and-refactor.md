description: Comprehensive codebase cleanup and refactoring
tools:
  - Glob
  - Grep
  - Read
  - Edit
  - MultiEdit
  - Bash
---

Perform a **thorough, end-to-end cleanup, review, and refactoring** of this codebase, aiming for production-quality, senior-engineer-level code that will impress a Next.js team.

Goals for this pass:
- **AI slop removal**: Identify and eliminate AI-generated slop (verbose, redundant, non-idiomatic, or over-engineered code). Replace it with clear, minimal, well-structured, idiomatic code for this stack.
- **Dead and unused code**: Find and remove dead, unreachable, and unused code, obsolete abstractions, and leftover experiments.
- **Duplication and reuse**: Detect repeated patterns and logic and refactor them into well-named, reusable components, hooks, utilities, or helpers that follow common Next.js and React conventions.
- **Performance**: Surface and fix performance issues (unnecessary re-renders, heavy client bundles, blocking calls, inefficient data fetching, N+1 queries, etc.) using Next.js best practices.
- **Security**: Flag and fix potential security issues (XSS, unsafe data handling, auth/session problems, secrets exposure, unsafe redirects, etc.), explaining risks and mitigations at a high level.
- **Code style and conventions**: Enforce idiomatic Next.js and React patterns while respecting existing behavior and public APIs unless there is a clear, explained improvement.

After the main cleanup and refactor, go **beyond these requirements**: propose any additional architectural, DX, or testing improvements that would meaningfully increase long-term maintainability and robustness.

When applying naming or structural conventions, **respect the dominant conventions of the existing codebase** even if they differ from your defaults (for example, keep using kebab-case component files in a codebase that already uses them, instead of converting everything to PascalCase).

# Codebase Cleanup and Refactoring Guide

## Phase 1: Analysis and Discovery
1. Analyze the current codebase structure using Glob and grep
2. Check package.json for project type and dependencies
3. Review existing file naming patterns
4. Identify dominant conventions already in use

## Phase 2: File Organization and Naming

### File Naming Conventions
- Components: PascalCase (UserProfile.tsx, ErrorBoundary.tsx) for new code, unless the existing codebase clearly standardizes a different pattern (for example, kebab-case component files).
- Utilities/Hooks: camelCase (useAuth.ts, formatDate.ts)
- Type files: camelCase with clear purpose (userTypes.ts, apiTypes.ts)
- Test files: Match source file with .test.ts or .spec.ts
- Config files: kebab-case for configs (next-config.js)
- Feature folders: kebab-case (user-management/, auth-flow/)

### Directory Structure
Organize into feature-based structure:
```
src/
├── components/
│   ├── features/       # Feature-specific components
│   ├── shared/         # Shared/common components
│   └── ui/            # Pure UI components
├── hooks/             # Custom React hooks
├── lib/               # Core utilities and services
├── types/             # TypeScript type definitions
└── app/              # Next.js app directory
```

## Phase 3: Code Quality Improvements

### Import Organization
1. Group imports: external, internal (`@/`), relative, then types
2. Prefer absolute imports with the `@` alias instead of long relative paths

### TypeScript Improvements
1. Eliminate all `any` types
2. Add explicit, accurate type definitions for function inputs, outputs, and key objects
3. Fix all TypeScript errors in strict mode

### Consolidation Tasks
1. Merge duplicate utilities
2. Remove unused code and dependencies
3. Combine related type definitions

### React and Next.js patterns
1. Use idiomatic React patterns (hooks, composition, small focused components) and avoid over-abstracted AI-generated components.
2. Use the Next.js App Router patterns correctly (route segments, layout nesting, loading/error states).
3. Prefer server components and server-side data fetching where appropriate, and only mark components with `use client` when truly needed.
4. Keep client bundles lean by avoiding unnecessary client-side libraries and heavy, unused code paths.

### Performance and security
1. Identify and address obvious performance issues (unnecessary re-renders, N+1 data fetching, blocking operations on the main thread).
2. Ensure that data fetching is efficient and cached appropriately using Next.js and platform capabilities where available.
3. Review for common security pitfalls (XSS, unsafe HTML, secrets exposure, insecure redirects, and weak auth/session handling) and tighten them following best practices.

## Phase 4: Quality Assurance

### During Changes
1. Make incremental changes
2. Test after each major change
3. Update imports immediately after moving files

### After Changes
1. Run linters: npm run lint
2. Fix TypeScript: npm run type-check
3. Run tests: npm test
4. Verify build: npm run build

## Phase 5: Final Checklist
- All files follow naming conventions
- No TypeScript errors
- No linting errors
- All tests pass
- Build succeeds
- No console.log in production
- All imports resolved correctly

Remember: Make changes incrementally and test frequently. Keep the codebase functional throughout the refactoring process.