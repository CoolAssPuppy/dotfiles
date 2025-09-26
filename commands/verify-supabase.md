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

Perform a comprehensive security and best practices audit of this Supabase codebase following these guidelines:

# Supabase Security & Best Practices Verification Guide

## Phase 1: Security Audit

### 1.1 API Key Security

**Critical Issues to Detect:**

- Service role key exposed in client-side code
- API keys hardcoded in source files
- Keys committed to version control
- Missing environment variable usage

**Detection Instructions:**

1. Search the codebase for any hardcoded service role keys or API keys
2. Look for `createClient(url, key)` calls with hardcoded values
3. Check for exposed keys in client-side code (React components, browser code)
4. Verify all API keys are using environment variables
5. Check for keys committed to version control

**Red Flags:**

- `createClient(url, key)` with hardcoded values
- Service role key in browser code
- Keys in public repositories
- Missing `.env` files or `.env.example`

### 1.2 Row Level Security (RLS)

**Critical Issues to Detect:**

- Tables without RLS enabled
- Missing RLS policies
- Overly permissive policies
- Policies that don't validate user context

**Detection Instructions:**

1. Check if RLS is enabled on all user-facing tables
2. Verify that RLS policies exist for all tables
3. Review policy conditions to ensure they validate user context
4. Look for overly permissive policies (using `true` without conditions)
5. Check that policies match the application's access control requirements

**Red Flags:**

- Tables with `rowsecurity = false`
- Missing policies on user-facing tables
- Policies using `true` without proper conditions
- Policies without user context validation

### 1.3 Authentication & Authorization

**Critical Issues to Detect:**

- Missing authentication checks
- Admin functions called from client
- Insufficient role-based access control
- JWT token validation issues

**Detection Instructions:**

1. Search for admin function usage in client-side code
2. Look for `createAdminClient` calls in browser code
3. Check that all API routes have proper authentication checks
4. Verify that admin operations are only in server-side code or Edge Functions
5. Ensure user context is validated before data access

**Red Flags:**

- `createAdminClient` in browser code
- Missing `getUser()` checks before data access
- Direct database access without authentication
- Admin operations in client-side code

## Phase 2: API Usage & Platform Errors

### 2.1 Outdated Libraries

**Critical Issues to Detect:**

- Outdated Supabase client versions
- Deprecated API usage
- Incompatible library versions
- Missing security updates

**Detection Instructions:**

1. Check package.json for Supabase client version (should be >= 2.0.0)
2. Look for deprecated API usage patterns
3. Verify TypeScript types are up-to-date
4. Check for compatibility issues with React versions
5. Review for any deprecated import patterns

**Red Flags:**

- Supabase client version < 2.0.0
- Using deprecated `supabaseUrl` parameter
- Missing TypeScript types
- Incompatible React versions

### 2.2 Edge Functions & Server-Side Code

**Critical Issues to Detect:**

- Admin operations in client code
- Missing server-side validation
- Improper function deployment
- Security context issues

**Detection Instructions:**

1. Verify admin operations are only in server-side code or Edge Functions
2. Check Edge Functions have proper structure with Deno.serve
3. Ensure server-side validation is implemented
4. Look for admin client creation in browser code
5. Verify Edge Functions are properly deployed and configured

**Red Flags:**

- Admin client creation in browser code
- Missing Edge Function structure
- Client-side admin operations
- Missing server-side validation

### 2.3 Database Design Patterns

**Critical Issues to Detect:**

- Missing indexes on frequently queried columns
- Inefficient query patterns
- Missing foreign key constraints
- Poor schema design

**Detection Instructions:**

1. Review database schema for missing indexes on frequently queried columns
2. Check for proper foreign key relationships between tables
3. Look for inefficient query patterns in the codebase
4. Verify database normalization is appropriate
5. Check for missing constraints that could cause data integrity issues

**Red Flags:**

- Tables without proper indexes
- Missing foreign key relationships
- Inefficient query patterns
- Poor normalization

## Phase 3: Performance & Optimization

### 3.1 Query Optimization

**Critical Issues to Detect:**

- N+1 query problems
- Missing pagination
- Inefficient joins
- Large data transfers

**Detection Instructions:**

1. Look for loops containing async operations (potential N+1 queries)
2. Check for missing pagination on large data queries
3. Review query patterns for efficiency
4. Look for missing `.limit()` or `.range()` on data fetching
5. Check for unnecessary data fetching in components

**Red Flags:**

- Loops with async operations
- Missing `.limit()` on queries
- Large data fetches without pagination
- Inefficient filtering

### 3.2 Caching & State Management

**Critical Issues to Detect:**

- Missing caching strategies
- Inefficient state updates
- Missing memoization
- Unnecessary re-renders

**Detection Instructions:**

1. Check for React optimization hooks (useMemo, useCallback, React.memo)
2. Look for caching strategies for expensive operations
3. Review state management for efficiency
4. Check for unnecessary re-renders
5. Look for missing memoization of expensive calculations

**Red Flags:**

- Missing React optimization hooks
- No caching for expensive operations
- Inefficient state management
- Missing memoization

## Phase 4: PostgREST Type Generation & Usage

### 4.1 Type Generation Setup

**Critical Issues to Detect:**

- Missing type generation command
- Outdated generated types
- Manual type definitions duplicating generated types
- Inconsistent type imports

**Detection Instructions:**

1. Check package.json for type generation script
2. Look for generated types file (database.types.ts or similar)
3. Search for manual type definitions that should use generated types
4. Verify type generation is set up correctly
5. Check that types are being imported consistently

**Required Setup:**

```json
// package.json scripts
{
  "scripts": {
    "types:generate": "supabase gen types typescript --local > src/types/database.types.ts",
    "types:check": "supabase gen types typescript --local > /tmp/current-types.ts && diff src/types/database.types.ts /tmp/current-types.ts"
  }
}
```

**Red Flags:**

- No type generation script in package.json
- Generated types file missing or outdated
- Manual type definitions for database entities
- Inconsistent type imports across files

### 4.2 Type Usage Patterns

**Critical Issues to Detect:**

- Using `any` types for database operations
- Manual type casting instead of generated types
- Missing type annotations on database queries
- Inconsistent type usage across components

**Detection Instructions:**

1. Look for proper usage of generated types (Database['public']['Tables'])
2. Check for `any` types in database operations
3. Search for manual type definitions that duplicate generated types
4. Verify typed Supabase client usage
5. Check for consistent type imports across the codebase

**Correct Usage Patterns:**

```typescript
// ✅ CORRECT: Using generated types
import { Database } from "@/types/database.types";

type User = Database["public"]["Tables"]["users"]["Row"];
type UserInsert = Database["public"]["Tables"]["users"]["Insert"];
type UserUpdate = Database["public"]["Tables"]["users"]["Update"];

// ✅ CORRECT: Typed Supabase client
const supabase = createClient<Database>(url, key);

// ✅ CORRECT: Typed queries
const { data: users } = await supabase
  .from("users")
  .select("*")
  .eq("active", true);
// users is automatically typed as User[]
```

**Incorrect Usage Patterns:**

```typescript
// ❌ WRONG: Manual type definitions
interface User {
  id: string;
  email: string;
  created_at: string;
}

// ❌ WRONG: Using any types
const { data } = await supabase.from("users").select("*"); // data is any

// ❌ WRONG: Manual type casting
const users = data as User[];
```

### 4.3 Type Consistency Enforcement

**Critical Issues to Detect:**

- Mixed type definitions (generated + manual)
- Inconsistent type imports
- Missing type annotations on database operations
- Type mismatches between components

**Detection Instructions:**

1. Check for consistent use of generated types across all files
2. Look for mixed type definitions (generated + manual)
3. Verify all database operations use generated types
4. Check for consistent type imports from the same source
5. Look for type mismatches between components

**Enforcement Rules:**

1. **Only use generated types** - No manual type definitions for database entities
2. **Consistent imports** - Always import from the same types file
3. **Type all database operations** - Every query should be properly typed
4. **No type casting** - Use generated types instead of manual casting

## Phase 5: Code Quality & Maintainability

### 4.1 TypeScript & Type Safety

**Critical Issues to Detect:**

- Missing PostgREST-generated database types
- Use of `any` types instead of generated types
- Manual type definitions that duplicate generated types
- Inconsistent type usage across the codebase
- Missing type generation setup

**Detection Instructions:**

1. Check for PostgREST type generation setup and usage
2. Look for manual type definitions that should use generated types
3. Search for `any` types in database operations
4. Verify proper type imports and usage
5. Check for missing type annotations on database queries

**Red Flags:**

- Manual type definitions for database entities
- Use of `any` types for database operations
- Missing `supabase gen types` command in package.json
- Inconsistent type usage across components
- TypeScript errors ignored with `@ts-ignore`

**Required Setup:**

```bash
# Check for type generation script
grep -A 3 -B 3 "gen types" package.json

# Verify types directory exists
ls -la src/types/ || ls -la types/ || ls -la lib/types/
```

### 4.2 Error Handling

**Critical Issues to Detect:**

- Missing error handling
- Generic error messages
- Missing validation
- Poor error recovery

**Detection Instructions:**

1. Look for proper error handling on all async operations
2. Check for user-friendly error messages
3. Verify error logging is implemented
4. Look for missing error boundaries in React components
5. Check for proper error recovery mechanisms

**Red Flags:**

- Missing `.catch()` on promises
- Generic error handling
- Missing input validation
- Poor error messages

## Phase 5: Security Checklist

### 5.1 Authentication Security

- [ ] All API routes have authentication checks
- [ ] Service role key never exposed to client
- [ ] JWT tokens properly validated
- [ ] Session management implemented correctly
- [ ] MFA enabled for admin accounts

### 5.2 Authorization Security

- [ ] RLS enabled on all tables
- [ ] Proper RLS policies implemented
- [ ] Role-based access control working
- [ ] Admin functions only in server-side code
- [ ] User context properly validated

### 5.3 Data Security

- [ ] Input validation on all endpoints
- [ ] SQL injection prevention
- [ ] XSS prevention measures
- [ ] CSRF protection implemented
- [ ] Sensitive data properly encrypted

### 5.4 Infrastructure Security

- [ ] Environment variables properly configured
- [ ] Secrets not committed to version control
- [ ] Network access properly restricted
- [ ] Regular security updates applied
- [ ] Monitoring and logging enabled

## Phase 6: Performance Checklist

### 6.1 Database Performance

- [ ] Proper indexes on frequently queried columns
- [ ] Pagination implemented for large datasets
- [ ] Query optimization applied
- [ ] Connection pooling configured
- [ ] Database monitoring enabled

### 6.2 Application Performance

- [ ] Caching strategies implemented
- [ ] React optimization hooks used
- [ ] Bundle size optimized
- [ ] Lazy loading implemented
- [ ] Performance monitoring enabled

## Phase 7: Code Quality Checklist

### 7.1 TypeScript Quality

- [ ] PostgREST types generated and up-to-date
- [ ] All database operations use generated types
- [ ] No manual type definitions for database entities
- [ ] Consistent type imports across codebase
- [ ] No `any` types used for database operations
- [ ] TypeScript strict mode enabled
- [ ] Type coverage > 90%
- [ ] Type generation script in package.json
- [ ] Generated types file exists and is current

### 7.2 Error Handling

- [ ] All async operations have error handling
- [ ] User-friendly error messages
- [ ] Proper error logging
- [ ] Error boundaries implemented
- [ ] Graceful degradation

### 7.3 Testing Coverage

- [ ] Unit tests for all utilities
- [ ] Integration tests for API routes
- [ ] Security tests for authentication
- [ ] Performance tests for critical paths
- [ ] Test coverage > 80%

## Phase 8: Comprehensive Analysis Instructions

### 8.1 Security Analysis

**Perform these checks systematically:**

1. **API Key Security Check**

   - Search for any hardcoded service role keys in the codebase
   - Verify all API keys are using environment variables
   - Check for exposed keys in client-side code
   - Look for keys committed to version control

2. **Authentication & Authorization Check**

   - Verify all API routes have proper authentication
   - Check that admin functions are only in server-side code
   - Ensure user context is validated before data access
   - Look for missing authentication guards

3. **Row Level Security Check**
   - Verify RLS is enabled on all user-facing tables
   - Check that appropriate RLS policies exist
   - Review policy conditions for proper user context validation
   - Look for overly permissive policies

### 8.2 Type Generation Analysis

**Check for proper type generation and usage:**

1. **Type Generation Setup**

   - Verify type generation script exists in package.json
   - Check for generated types file (database.types.ts or similar)
   - Ensure types are up-to-date with current schema

2. **Type Usage Patterns**

   - Look for proper usage of generated types (Database['public']['Tables'])
   - Check for manual type definitions that should use generated types
   - Verify typed Supabase client usage
   - Look for consistent type imports across the codebase

3. **Type Safety Issues**
   - Search for `any` types in database operations
   - Check for missing type annotations on database queries
   - Look for manual type casting instead of generated types

### 8.3 Performance Analysis

**Check for performance issues:**

1. **Query Optimization**

   - Look for N+1 query patterns (loops with async operations)
   - Check for missing pagination on large data queries
   - Review query patterns for efficiency
   - Look for unnecessary data fetching

2. **Caching & State Management**
   - Check for React optimization hooks (useMemo, useCallback, React.memo)
   - Look for caching strategies for expensive operations
   - Review state management for efficiency
   - Check for unnecessary re-renders

### 8.4 Code Quality Analysis

**Check for code quality issues:**

1. **Error Handling**

   - Look for proper error handling on all async operations
   - Check for user-friendly error messages
   - Verify error logging is implemented
   - Look for missing error boundaries in React components

2. **TypeScript Quality**
   - Check for proper type coverage
   - Look for missing type annotations
   - Verify TypeScript strict mode is enabled
   - Check for type consistency across the codebase

## Phase 9: Remediation Guidelines

### 9.1 Critical Security Issues

1. **Exposed Service Role Key**

   - Move to server-side environment variables
   - Use Edge Functions for admin operations
   - Implement proper secret management

2. **Missing RLS**

   - Enable RLS on all tables
   - Create appropriate policies
   - Test policies thoroughly

3. **Admin Functions in Client**
   - Move to Edge Functions
   - Implement server-side validation
   - Use proper authentication

### 9.2 Performance Issues

1. **N+1 Query Problems**

   - Use batch operations
   - Implement proper joins
   - Use Supabase's batch features

2. **Missing Pagination**
   - Implement `.limit()` and `.range()`
   - Use cursor-based pagination
   - Add proper loading states

### 9.3 Code Quality Issues

1. **TypeScript Issues**

   - Generate Supabase types
   - Remove `any` types
   - Enable strict mode

2. **Error Handling**
   - Add proper error boundaries
   - Implement user-friendly messages
   - Add comprehensive logging

### 9.4 Type Generation Issues

1. **Missing Type Generation**

   - Add `supabase gen types` script to package.json
   - Generate types file: `supabase gen types typescript --local > src/types/database.types.ts`
   - Set up automated type generation in CI/CD

2. **Manual Type Definitions**

   - Remove manual interface/type definitions for database entities
   - Replace with generated types: `Database['public']['Tables']['table_name']['Row']`
   - Update all imports to use generated types

3. **Type Consistency**

   - Ensure all database operations use generated types
   - Remove manual type casting (`as User[]`)
   - Use typed Supabase client: `createClient<Database>(url, key)`

4. **Type Maintenance**
   - Set up automated type checking: `supabase gen types typescript --local > /tmp/current-types.ts && diff src/types/database.types.ts /tmp/current-types.ts`
   - Update types after schema changes
   - Version control generated types file

## Phase 10: Final Report

### 10.1 Security Score

- Critical Issues: [count]
- High Priority: [count]
- Medium Priority: [count]
- Low Priority: [count]

### 10.2 Performance Score

- Database Optimization: [score/10]
- Application Performance: [score/10]
- Caching Strategy: [score/10]

### 10.3 Code Quality Score

- TypeScript Coverage: [score/10]
- Error Handling: [score/10]
- Testing Coverage: [score/10]

### 10.4 Recommendations

1. **Immediate Actions** (Critical)
2. **Short-term Improvements** (High Priority)
3. **Long-term Optimizations** (Medium Priority)

Remember: Security is not optional. Every Supabase application must follow these guidelines to prevent data breaches and ensure user safety. Performance and code quality directly impact user experience and maintainability.

Start by running the security audit script and addressing all critical issues before proceeding with performance and code quality improvements.
