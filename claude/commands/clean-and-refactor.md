---
description: Comprehensive codebase cleanup and refactoring
tools:
  - Glob
  - Grep
  - Read
  - Edit
  - MultiEdit
  - Bash
---

Perform a comprehensive cleanup and refactoring of this codebase following these guidelines:

# Codebase Cleanup and Refactoring Guide

## Phase 1: Analysis and Discovery
1. Analyze the current codebase structure using Glob and grep
2. Check package.json for project type and dependencies
3. Review existing file naming patterns
4. Identify dominant conventions already in use

## Phase 2: File Organization and Naming

### File Naming Conventions
- Components: PascalCase (UserProfile.tsx, ErrorBoundary.tsx)
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
1. Group imports: external, internal (@/), relative, types
2. Convert relative imports to absolute with @ alias

### TypeScript Improvements
1. Eliminate all "any" types
2. Add proper type definitions everywhere
3. Fix all TypeScript errors

### Consolidation Tasks
1. Merge duplicate utilities
2. Remove unused code and dependencies
3. Combine related type definitions

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