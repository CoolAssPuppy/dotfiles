---
description: Comprehensive testing implementation guide for unit, integration, and E2E tests
tools:
  - Read
  - Write
  - MultiEdit
  - Glob
  - Grep
  - Bash
---

Implement comprehensive testing for this application following these exact patterns:

# Comprehensive Testing Implementation Guide

## Phase 1: Testing Infrastructure Setup

### 1.1 Testing Stack & Tools

**Required Dependencies:**

- **Unit/Integration**: Vitest (NOT Jest)
- **React Testing**: @testing-library/react, @testing-library/jest-dom
- **E2E Testing**: Playwright or Cypress
- **Mocking**: Vitest's vi.fn() and vi.mock()
- **Data Generation**: @faker-js/faker
- **DOM Testing**: happy-dom environment
- **API Testing**: Supertest for API routes
- **Database Testing**: Test database setup/teardown

### 1.2 Project Test Structure

```
src/__tests__/
├── unit/                    # Unit tests
│   ├── api/                # API route tests
│   ├── components/         # Component tests
│   ├── hooks/             # Hook tests
│   ├── utils/             # Utility tests
│   └── services/          # Service layer tests
├── integration/            # Integration tests
│   ├── api/               # API integration tests
│   ├── database/          # Database integration tests
│   └── auth/              # Authentication flow tests
├── e2e/                   # End-to-end tests
│   ├── critical-flows/    # Critical user journeys
│   ├── auth/              # Authentication scenarios
│   └── admin/             # Admin functionality
├── security/              # Security tests
├── performance/           # Performance tests
├── test-utils.ts          # Test factories and utilities
├── setup.ts              # Test setup configuration
└── fixtures/             # Test data fixtures
```

## Phase 2: Unit Testing Implementation

### 2.1 Test File Structure & Rules

**Import Structure (EXACT ORDER):**

```typescript
// 1. Testing framework
import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";

// 2. React testing (if needed)
import { render, screen, fireEvent, waitFor } from "@testing-library/react";

// 3. Source code
import { functionToTest } from "@/path/to/source";

// 4. Test utilities
import { createMockUser, mockSupabaseSuccess } from "@/__tests__/test-utils";
```

### 2.2 API Route Testing

**Location**: `src/__tests__/unit/api/`

**Required Test Structure:**

```typescript
describe("POST /api/route-name", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe("Authentication", () => {
    it("should return 401 if not authenticated", async () => {
      // Test unauthenticated request
    });

    it("should authenticate valid users", async () => {
      // Test authenticated request
    });
  });

  describe("Authorization", () => {
    it("should return 403 for insufficient permissions", async () => {
      // Test authorization
    });

    it("should allow authorized access", async () => {
      // Test authorized request
    });
  });

  describe("Input Validation", () => {
    it("should return 400 for invalid input", async () => {
      // Test validation errors
    });

    it("should validate required fields", async () => {
      // Test required field validation
    });
  });

  describe("Success Cases", () => {
    it("should process valid request successfully", async () => {
      // Test happy path
    });

    it("should return correct response format", async () => {
      // Test response structure
    });
  });

  describe("Error Handling", () => {
    it("should handle database errors gracefully", async () => {
      // Test database error handling
    });

    it("should handle network errors", async () => {
      // Test network error handling
    });
  });
});
```

### 2.3 Component Testing

**Location**: `src/__tests__/unit/components/`

**Required Test Coverage:**

- Rendering with different props
- User interactions (clicks, form submissions)
- Loading states
- Error states
- Accessibility features
- Conditional rendering

### 2.4 Hook Testing

**Location**: `src/__tests__/unit/hooks/`

**Required Test Coverage:**

- Initial state
- State updates
- Side effects
- Cleanup functions
- Error handling
- Dependencies

### 2.5 Utility Function Testing

**Location**: `src/__tests__/unit/utils/`

**Required Test Coverage:**

- Normal inputs
- Edge cases
- Error cases
- Type checking
- Boundary conditions

## Phase 3: Integration Testing Implementation

### 3.1 API Integration Tests

**Location**: `src/__tests__/integration/api/`

**Test Real API Endpoints:**

- Full request/response cycles
- Database interactions
- Authentication flows
- Error propagation
- Performance benchmarks

### 3.2 Database Integration Tests

**Location**: `src/__tests__/integration/database/`

**Test Database Operations:**

- CRUD operations
- Transactions
- Constraints
- Indexes
- Performance

### 3.3 Authentication Integration Tests

**Location**: `src/__tests__/integration/auth/`

**Test Auth Flows:**

- Login/logout cycles
- Token refresh
- Session management
- Role-based access
- Password reset

## Phase 4: End-to-End Testing Implementation

### 4.1 E2E Testing Setup

**Choose Framework:**

- **Playwright** (recommended for modern apps)
- **Cypress** (good for React apps)

### 4.2 Critical User Journey Tests

**Location**: `src/__tests__/e2e/critical-flows/`

**Required Test Scenarios:**

1. **User Registration & Login Flow**
2. **Core Application Functionality**
3. **Admin Operations**
4. **Payment/Subscription Flows**
5. **Data Export/Import**

### 4.3 E2E Test Structure

```typescript
import { test, expect } from "@playwright/test";

test.describe("Critical User Journey: User Registration", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/");
  });

  test("should complete full user registration flow", async ({ page }) => {
    // Step 1: Navigate to registration
    await page.click('[data-testid="register-button"]');
    await expect(page).toHaveURL("/register");

    // Step 2: Fill registration form
    await page.fill('[data-testid="email-input"]', "test@example.com");
    await page.fill('[data-testid="password-input"]', "SecurePassword123!");
    await page.fill(
      '[data-testid="confirm-password-input"]',
      "SecurePassword123!"
    );

    // Step 3: Submit form
    await page.click('[data-testid="submit-button"]');

    // Step 4: Verify email confirmation
    await expect(
      page.locator('[data-testid="confirmation-message"]')
    ).toBeVisible();

    // Step 5: Check redirect to dashboard
    await expect(page).toHaveURL("/dashboard");
  });

  test("should handle registration errors gracefully", async ({ page }) => {
    // Test error scenarios
  });
});
```

## Phase 5: Security Testing Implementation

### 5.1 Security Test Categories

**Location**: `src/__tests__/security/`

**Required Security Tests:**

- Authentication bypass attempts
- Authorization escalation
- Input sanitization
- SQL injection prevention
- XSS prevention
- CSRF protection
- Rate limiting
- Data validation

### 5.2 Security Test Examples

```typescript
describe("Security: Authentication", () => {
  it("should prevent authentication bypass", async () => {
    // Test various bypass attempts
  });

  it("should validate JWT tokens properly", async () => {
    // Test token validation
  });

  it("should prevent session hijacking", async () => {
    // Test session security
  });
});
```

## Phase 6: Performance Testing Implementation

### 6.1 Performance Test Categories

**Location**: `src/__tests__/performance/`

**Required Performance Tests:**

- API response times
- Database query performance
- Component render performance
- Memory usage
- Load testing

### 6.2 Performance Test Examples

```typescript
describe("Performance: API Endpoints", () => {
  it("should respond within acceptable time limits", async () => {
    const start = Date.now();
    const response = await request(app).get("/api/users");
    const duration = Date.now() - start;

    expect(duration).toBeLessThan(1000); // 1 second
    expect(response.status).toBe(200);
  });
});
```

## Phase 7: Test Data Management

### 7.1 Test Factories

**Location**: `src/__tests__/test-utils.ts`

**Required Factory Functions:**

```typescript
import { faker } from "@faker-js/faker";

export const createMockUser = (overrides = {}) => ({
  id: faker.string.uuid(),
  email: faker.internet.email(),
  name: faker.person.fullName(),
  created_at: faker.date.past().toISOString(),
  ...overrides,
});

export const createMockSupabaseResponse = (data, error = null) => ({
  data,
  error,
  status: error ? 400 : 200,
  statusText: error ? "Bad Request" : "OK",
});

export const mockSupabaseSuccess = (data) => createMockSupabaseResponse(data);

export const mockSupabaseError = (message) =>
  createMockSupabaseResponse(null, { message });
```

### 7.2 Test Fixtures

**Location**: `src/__tests__/fixtures/`

**Required Fixture Files:**

- `users.json` - User test data
- `products.json` - Product test data
- `orders.json` - Order test data
- `admin-users.json` - Admin user data

## Phase 8: CI/CD Integration

### 8.1 GitHub Actions Workflow

**File**: `.github/workflows/test.yml`

```yaml
name: Test Suite

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [18.x, 20.x]

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: "npm"

      - name: Install dependencies
        run: npm ci

      - name: Run unit tests
        run: npm run test:unit

      - name: Run integration tests
        run: npm run test:integration

      - name: Run E2E tests
        run: npm run test:e2e

      - name: Generate coverage report
        run: npm run test:coverage

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
```

### 8.2 Package.json Scripts

```json
{
  "scripts": {
    "test": "vitest",
    "test:unit": "vitest run src/__tests__/unit",
    "test:integration": "vitest run src/__tests__/integration",
    "test:e2e": "playwright test",
    "test:security": "vitest run src/__tests__/security",
    "test:performance": "vitest run src/__tests__/performance",
    "test:coverage": "vitest run --coverage",
    "test:watch": "vitest --watch",
    "test:ci": "vitest run --reporter=verbose --coverage"
  }
}
```

## Phase 9: Coverage Requirements

### 9.1 Coverage Targets

- **Statements**: 85%
- **Branches**: 80%
- **Functions**: 85%
- **Lines**: 85%

### 9.2 Coverage Configuration

**File**: `vitest.config.ts`

```typescript
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    coverage: {
      provider: "v8",
      reporter: ["text", "json", "html"],
      thresholds: {
        statements: 85,
        branches: 80,
        functions: 85,
        lines: 85,
      },
      exclude: [
        "node_modules/",
        "src/__tests__/",
        "**/*.d.ts",
        "**/*.config.*",
      ],
    },
  },
});
```

## Phase 10: Test Execution & Reporting

### 10.1 Running Tests

```bash
# Run all tests
npm test

# Run specific test types
npm run test:unit
npm run test:integration
npm run test:e2e

# Run with coverage
npm run test:coverage

# Run in watch mode
npm run test:watch

# Run for CI
npm run test:ci
```

### 10.2 Expected Output Format

```
✓ Unit Tests (45)
  ✓ API Routes (12)
    ✓ POST /api/users (4)
    ✓ GET /api/users (4)
    ✓ PUT /api/users/:id (4)
  ✓ Components (18)
    ✓ UserProfile (6)
    ✓ UserList (6)
    ✓ UserForm (6)
  ✓ Hooks (8)
    ✓ useAuth (4)
    ✓ useUsers (4)
  ✓ Utils (7)
    ✓ formatDate (3)
    ✓ validateEmail (4)

✓ Integration Tests (15)
  ✓ API Integration (8)
  ✓ Database Integration (4)
  ✓ Auth Integration (3)

✓ E2E Tests (8)
  ✓ Critical Flows (5)
  ✓ Auth Scenarios (3)

✓ Security Tests (6)
  ✓ Authentication (3)
  ✓ Authorization (3)

✓ Performance Tests (4)
  ✓ API Performance (2)
  ✓ Component Performance (2)

Tests: 84 passed
Duration: 2.3s
Coverage: 87.2%
```

## Phase 11: Quality Checklist

### 11.1 Pre-Implementation Checklist

- [ ] Testing framework configured
- [ ] Test structure created
- [ ] Mock utilities implemented
- [ ] Test data factories created
- [ ] CI/CD pipeline configured

### 11.2 Implementation Checklist

- [ ] All API routes tested
- [ ] All components tested
- [ ] All hooks tested
- [ ] All utilities tested
- [ ] Critical user journeys tested
- [ ] Security scenarios tested
- [ ] Performance benchmarks tested

### 11.3 Quality Assurance Checklist

- [ ] All tests pass
- [ ] Coverage meets requirements
- [ ] No console.log in tests
- [ ] Mocks cleared in beforeEach
- [ ] Tests are isolated
- [ ] Using test factories
- [ ] Descriptive error messages
- [ ] Happy path + error cases
- [ ] Security tests included
- [ ] Performance tests included

## Phase 12: Maintenance & Updates

### 12.1 Test Maintenance

- Update tests when features change
- Refactor tests for better readability
- Add new tests for new features
- Remove obsolete tests
- Update test data regularly

### 12.2 Test Documentation

- Document test patterns and conventions
- Create testing guidelines for team
- Maintain test coverage reports
- Document E2E test scenarios
- Create troubleshooting guides

Remember: Tests are living documentation. They should clearly show how the application works and provide confidence in code changes. Focus on testing behavior, not implementation details.
