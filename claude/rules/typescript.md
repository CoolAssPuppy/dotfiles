# TypeScript and build requirements

## Technology preferences

- Always specify TypeScript over JavaScript unless explicitly told otherwise.
- Use Next.js 14+ App Router, not Pages Router.
- For iOS development, target iOS 17+ and use Swift 5.9+ features.
- Default to npm unless a project already uses yarn or pnpm.
- Follow conventions and best practices of the Supabase, Tailwind, NextJS, shadcn, Swift, and iOS developer communities.

## Build and deployment

- **All code must compile successfully in Vercel's build environment.**
- Never use `any` types. Vercel's TypeScript strict mode will fail the build.
- Always provide explicit types for function parameters and return values.
- Test that imports resolve correctly and don't reference non-existent files.
- Ensure all TypeScript errors are resolved before suggesting code is complete.
