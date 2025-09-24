export default {
  name: 'test-all',
  description: 'Create comprehensive tests following project patterns',
  requiresArgs: false,
  enabled: true,

  async execute(args, { cwd, say, ask }) {
    say('🧪 Preparing comprehensive test creation guide...\\n');

    const testType = await ask('What would you like to test? (feature/api/component/security/all)');

    return {
      prompt: `Please create comprehensive tests for this codebase following these exact patterns:

# Comprehensive Testing Guide

## Testing Stack & Tools
- **Framework**: Vitest (NOT Jest)
- **React Testing**: @testing-library/react
- **Mocking**: Vitest's vi.fn() and vi.mock()
- **Data Generation**: @faker-js/faker
- **DOM Testing**: happy-dom environment

## Project Test Structure
src/__tests__/
├── unit/           # Unit tests
│   ├── api/        # API route tests
│   ├── hooks/      # Hook tests
│   └── utils/      # Utility tests
├── security/       # Security tests
├── validation/     # Validation tests
├── test-utils.ts   # Test factories
└── setup.ts        # Test setup

## Test File Rules

### Import Structure (EXACT ORDER)
1. Testing framework: import { describe, it, expect, vi, beforeEach } from 'vitest';
2. React testing (if needed): import { render, screen } from '@testing-library/react';
3. Source code: import { functionToTest } from '@/path/to/source';
4. Mock factories: import { createMockUser, mockSupabaseSuccess } from '@/__tests__/test-utils';

## Mock Patterns

### Supabase Mock
vi.mock('@/lib/supabase/server', () => ({
  createClient: vi.fn(),
  createAdminClient: vi.fn(),
}));

const mockSupabase = {
  auth: {
    getUser: vi.fn(),
    getSession: vi.fn(),
  },
  from: vi.fn(() => ({
    select: vi.fn().mockReturnThis(),
    insert: vi.fn().mockReturnThis(),
    update: vi.fn().mockReturnThis(),
    eq: vi.fn().mockReturnThis(),
    single: vi.fn(),
  })),
};

## Test Categories

### 1. API Route Tests
Location: src/__tests__/unit/api/

describe('POST /api/route-name', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe('Authentication', () => {
    it('should return 401 if not authenticated', async () => {
      // Test auth
    });
  });

  describe('Validation', () => {
    it('should return 400 for invalid input', async () => {
      // Test validation
    });
  });

  describe('Success', () => {
    it('should process valid request', async () => {
      // Test happy path
    });
  });

  describe('Error Handling', () => {
    it('should handle database errors', async () => {
      // Test errors
    });
  });
});

### 2. Security Tests
Location: src/__tests__/security/

- Authentication enforcement
- Authorization (RBAC)
- Input sanitization
- SQL injection prevention
- XSS prevention

### 3. Component Tests
Location: src/__tests__/unit/components/

- Rendering
- User interactions
- Loading states
- Error states
- Props handling

### 4. Hook Tests
Location: src/__tests__/unit/hooks/

- Initial state
- State updates
- Side effects
- Cleanup

### 5. Utility Tests
Location: src/__tests__/unit/utils/

- Normal inputs
- Edge cases
- Error cases
- Type checking

## Coverage Requirements
- Statements: 80%
- Branches: 75%
- Functions: 80%
- Lines: 80%

## What MUST Be Tested
1. All API routes
2. All user inputs
3. All error paths
4. All auth checks
5. All database operations

## Running Tests
npm test                 # Run all
npm run test:coverage    # With coverage
npm test -- --watch      # Watch mode

## Expected Output
✓ POST /api/admin/approve (12)
  ✓ Authentication (2)
    ✓ should return 401 if not authenticated
    ✓ should authenticate valid users
  ✓ Authorization (2)
    ✓ should return 403 for non-admin
    ✓ should allow admin access
  ✓ Success Cases (3)
    ✓ should approve application
  ✓ Error Handling (2)
    ✓ should handle database errors

Tests: 12 passed
Duration: 245ms

## Quality Checklist
- [ ] All tests pass
- [ ] Coverage meets requirements
- [ ] No console.log in tests
- [ ] Mocks cleared in beforeEach
- [ ] Tests are isolated
- [ ] Using test factories
- [ ] Descriptive error messages
- [ ] Happy path + error cases
- [ ] Security tests included

Remember: Tests are documentation. They should clearly show how code works.`
    };
  }
};
