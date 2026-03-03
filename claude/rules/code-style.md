# Code style and architecture

## File and component structure

- Try to keep files under 500 lines.
- Break apart large files proactively.
- Use folders and naming conventions for organization.
- Functions: ideally under 30-40 lines.
- Classes: ideally under 200 lines (otherwise split).
- Don't create files larger than 300 lines without explicit justification.

## Object-oriented design

- Encapsulate functionality in classes, structs, or protocols.
- Prefer composition over inheritance.
- Design for reuse, not one-off fixes.
- Each file, class, and function should do only one thing.
- Split responsibilities into separate, focused components.

## Modular design

- Components should be interchangeable, isolated, and testable.
- Always check if a component can be reused across screens/projects.
- Minimize tight coupling. Prefer dependency injection and protocols.
- Never mix UI and business logic in a component.
- Assume code will need to scale from the beginning.
- Provide extension points and abstractions early.

## Avoid anti-patterns

- Never centralize everything in a single massive file.
- Decompose into UI, State, Handlers, Networking, etc.
- Never create God classes.

## Import organization

- Group imports: external libraries first, then internal modules, then relative imports.
- Separate each import group with a blank line.
- Export components and functions from index files for cleaner imports.
- Put types and interfaces in separate files when they're shared.

## Naming conventions

- Use PascalCase for components and classes.
- Use camelCase for variables, functions, and file names.
- Use kebab-case for folder names.
- Prefix boolean variables and functions with `is`, `has`, `can`, or `should`.
- Use descriptive, intention-revealing names.
- Avoid generic placeholders like `data`, `info`, `temp`.

## Performance considerations

- Always consider the performance impact when adding new dependencies.
- Use React.memo() for components that receive stable props.
- Prefer CSS-in-JS solutions that extract styles at build time.
- Load data at the component level where it's needed, not higher up.

## Error handling patterns

- Always include proper error handling in async functions.
- Use Result types or structured error objects, not just thrown strings.
- Log errors with context, not just the error message.
- Never swallow errors silently.

## Documentation standards

- Include JSDoc comments for all public functions and complex logic.
- Write README files that include setup instructions and architecture decisions.
- Document any non-obvious business rules or constraints inline.

## "Do not" rules

- Don't use `any` type in TypeScript. Always provide proper types.
- Never commit console.log statements to production code.
- Never use `!important` in CSS unless absolutely necessary.
- Don't modify node_modules or vendor files directly.
- Never hardcode URLs, API keys, or environment-specific values.
