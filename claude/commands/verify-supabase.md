---
description: Comprehensive Supabase security and best practices verification
tools:
  - Glob
  - Grep
  - Read
  - Edit
  - MultiEdit
  - Bash
---

Audit this Supabase codebase for security, API usage, performance, and code quality, then report findings by severity.

Load the `supabase` skill first for current API guidance on key types, auth helpers, and SSR clients. If the Supabase MCP server is connected, run `get_advisors` for the security and performance lints and include its results. Use the code review below for what the advisors cannot see.

## What to check

- **Keys and secrets.** Secret or service role keys anywhere a browser can reach them: client components, `NEXT_PUBLIC_` variables, committed files. Keys hardcoded instead of read from environment variables.
- **Row Level Security.** Tables in exposed schemas without RLS, tables with RLS but no policies, and policies that pass `true` or never check the user.
- **Auth and admin access.** Admin or secret-key clients created in browser code. Server routes and Edge Functions that read or write user data without verifying the user first.
- **Library versions and deprecated APIs.** Installed `@supabase/*` versions and call patterns compared against current docs.
- **Queries.** Queries inside loops (N+1), unbounded selects without `.limit()` or `.range()`, missing indexes on filtered or joined columns, missing foreign keys.
- **Types.** Whether types are generated with `supabase gen types`, whether the client is typed with `createClient<Database>`, and where hand-written interfaces, `any`, or `as` casts duplicate generated types.
- **Rendering.** Components that refetch Supabase data or recompute expensive results on every render.
- **Error handling.** Supabase calls whose `error` result is ignored.

## Report

Group findings as critical, high, medium, and low. For each finding give the file and line, what is wrong, and the fix. End with immediate actions (critical), short-term fixes (high), and later improvements (medium and low).
