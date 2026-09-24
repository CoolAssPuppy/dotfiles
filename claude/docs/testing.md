# Testing principles

The rules are in `~/.claude/rules/testing.md`. This file has the examples.

## End-to-end first

An E2E test runs the real system and checks what a user sees. It is the default
test for any feature. It is also the test an agent has the hardest time faking,
because it cannot pass by mocking the code under test.

### Web example (Playwright)

```typescript
import { expect, test } from "@playwright/test";

import { seedOrder } from "./fixtures/seed";

test("checkout charges the cart total plus shipping", async ({ page }) => {
  const order = await seedOrder({ items: [{ sku: "mug", price: 30 }], shipping: 5.99 });

  await page.goto(`/cart/${order.id}`);
  await page.getByRole("button", { name: "Pay now" }).click();

  await expect(page.getByTestId("receipt-total")).toHaveText("$35.99");
  await page.screenshot({ path: "artifacts/checkout-receipt.png", fullPage: true });
});
```

The screenshot is the artifact. The report names the command, the exit code,
and `artifacts/checkout-receipt.png`.

### Making runs repeatable

- Seed the database from a fixture at the start of each test. Never depend on data left by another test.
- Freeze the clock and pin random seeds.
- Wait for a visible condition (`toHaveText`, `toBeVisible`), never a fixed sleep.
- Write artifacts to one folder that is gitignored and cleared at the start of each run.

### iOS and macOS

Use XCUITest. Attach a screenshot with `XCTAttachment` at the end of each flow
and export it from the `.xcresult` bundle so the path can be reported.

### Command-line tools

Run the built binary against fixture input and compare its output file to a
checked-in expected file. The output file is the artifact.

## Isolated tests for logic with many cases

Use these for parsers, money, dates, permissions, and state machines, where an
E2E test per case would be too slow.

### Step 1: write the failure list

Before any code, list every way the function can go wrong:

```text
calculateShipping(order)
- empty cart
- total exactly at the free-shipping threshold ($50.00)
- total one cent below the threshold
- negative item price
- quantity zero
- currency other than USD
- rounding on a total like $49.995
```

### Step 2: turn the list into a table

```typescript
import { describe, expect, it } from "vitest";

import { calculateShipping } from "./shipping";
import { getMockOrder } from "./test-factories";

describe("calculateShipping", () => {
  it.each([
    { name: "empty cart", order: getMockOrder({ items: [] }), expected: { ok: false, error: "Empty cart" } },
    { name: "exactly $50", order: getMockOrder({ total: 50 }), expected: { ok: true, shipping: 0 } },
    { name: "one cent under", order: getMockOrder({ total: 49.99 }), expected: { ok: true, shipping: 5.99 } },
    { name: "negative price", order: getMockOrder({ total: -1 }), expected: { ok: false, error: "Invalid amount" } },
  ])("$name", ({ order, expected }) => {
    expect(calculateShipping(order)).toEqual(expected);
  });
});
```

### Step 3: watch it fail, then write the code

Run the table before `calculateShipping` exists or while it is a stub. Every
row should fail. Then write the code until every row passes.

## Test data

Use factory functions that return a complete object and accept overrides:

```typescript
const getMockOrder = (overrides?: Partial<Order>): Order => {
  return {
    id: "order_123",
    items: [{ sku: "mug", price: 30, quantity: 1 }],
    total: 30,
    currency: "USD",
    ...overrides,
  };
};
```

When a schema exists, parse the factory output with it so bad test data fails
at setup:

```typescript
const getMockOrder = (overrides?: Partial<Order>): Order =>
  OrderSchema.parse({ ...baseOrder, ...overrides });
```

## Tests to avoid

```typescript
// BAD: checks that an internal function was called
it("calls validateAmount", () => {
  const spy = vi.spyOn(validator, "validateAmount");
  processPayment(getMockPayment());
  expect(spy).toHaveBeenCalled();
});

// BAD: mocks the project's own database module
vi.mock("../db", () => ({ saveOrder: vi.fn().mockResolvedValue({ id: "1" }) }));

// BAD: shared mutable setup
let payment: Payment;
beforeEach(() => {
  payment = { amount: 100 };
});

// GOOD: checks the outcome through the public function
it("rejects negative amounts", () => {
  const result = processPayment(getMockPayment({ amount: -100 }));
  expect(result).toEqual({ ok: false, error: "Invalid amount" });
});
```
