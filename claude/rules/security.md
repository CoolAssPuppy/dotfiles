# Security standards

## Database access patterns

- **Always use Row Level Security (RLS) policies instead of supabaseAdmin for user data access.**
- Never bypass RLS by using service role keys in client-side code.
- Use the authenticated user context for all database operations.
- Only use service role/admin access for server-side operations that require elevated privileges.
- Implement proper RLS policies for all tables that contain user data.

## Authentication and authorization

- Always validate user permissions before database operations.
- Use Supabase's built-in authentication rather than custom auth implementations.
- Implement proper session management and token validation.
- Never store sensitive data in client-side storage without encryption.
- Use environment variables for all API keys and secrets.

## Data protection

- Never log sensitive user data (passwords, tokens, personal information).
- Use parameterized queries to prevent SQL injection.
- Validate and sanitize all user inputs on both client and server sides.
- Implement proper CORS policies for API endpoints.
- Use HTTPS for all data transmission.

## Environment and secrets management

- Never commit secrets, API keys, or environment files to version control.
- Use different environment configurations for development, staging, and production.
- Rotate API keys and secrets regularly.
- Use secure secret management services for production deployments.
- Never expose service role keys in client-side code.

## Code security practices

- Always validate user permissions before performing operations.
- Implement proper error handling that doesn't leak sensitive information.
- Use TypeScript strict mode to catch potential security issues.
- Regularly audit dependencies for security vulnerabilities.
- Implement rate limiting for API endpoints to prevent abuse.
