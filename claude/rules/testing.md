# Testing approach

## Core rule

Test at the highest level that is still fast and reliable. For most work that
means end-to-end tests that run the real system the way a user does.

Never write tests after the code. A test written after the code copies the
implementation and checks that the code does what the code does.

## Which test to write

| What you are building | Test | When you write it |
| --- | --- | --- |
| A feature or user flow | End-to-end | Before or alongside the code, and it must pass before the work is done |
| Logic with many cases (parsers, money, dates, permissions, state machines) | Isolated, table-driven | First list every way it can fail, then write the tests from that list, then the code |
| Glue code, wiring, simple CRUD | None beyond the E2E test that runs through it | n/a |

## End-to-end tests

- Run the real app, real database, and real UI. Use Playwright for web, XCUITest for iOS and macOS, and the CLI itself for command-line tools.
- Every run ends by producing an artifact: a screenshot, a recording, a log, or an output file. Save it to a known path and name it in your report so a person can check it.
- The same run on the same inputs produces the same artifact. Seed data, fix clocks, and pin random values.
- Name the E2E command in the report, with the exit code and the artifact path.

## Isolated tests

- Write the failure list before any code: bad input, empty input, boundaries, off-by-one, overflow, time zones, rounding, missing permissions, concurrent writes. The list becomes the test table.
- Watch each test fail before writing the code that makes it pass.
- Test through the public function only. Never test private helpers or check that a method was called.
- Use factory functions with optional overrides for test data. No `let` or `beforeEach`.

## Mocks

- Mock only what you do not control: payment providers, third-party APIs, email, the system clock.
- Never mock the project's own modules or database. If the database is too slow, run a local one.

## What not to do

- No coverage targets. Coverage percentages reward tests that exercise code without checking anything.
- No test that only proves a function exists or returns without throwing.
- No snapshot of an entire page or object as the only assertion.

Examples and patterns: `~/.claude/docs/testing.md`.
