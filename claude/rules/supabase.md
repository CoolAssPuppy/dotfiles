# Supabase best practices

## Schema and types

- Always use declarative schemas if working with local Supabase.
- Generate types from the database automatically.
- Extend types where appropriate.
- Use Supabase features and components.

## Using the database

- Before writing code, always use the MCP Server to understand the schema.
- Do not hallucinate columns or schema structure that does not exist.
- If you need to create new tables or columns, ask first. Explain why and ask if that is what I want before you do it.
