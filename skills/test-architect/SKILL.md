---
name: test-architect
description: >-
  Designs, configures, and writes unit and integration tests across frontend
  (Vitest, React Testing Library) and backend (Go testing, API handlers) using
  automated coverage gap scanning and idiomatic test templates. Use when writing
  tests, fixing test configs, or verifying new features.
---

# Full-Stack Test Architect

Use this skill when adding test coverage, fixing broken test configurations, or verifying backend and frontend changes.

## Step 1: Scan for Coverage Gaps

Run the coverage gap scanner to see which backend handlers or frontend modules lack tests:
```bash
~/.gemini/config/plugins/agent-kit/skills/test-architect/scripts/check-coverage-gaps.sh
```
Consult [test-patterns.md](./references/test-patterns.md) for idiomatic Vitest and Go `httptest` patterns.

## Step 2: Frontend & Manifest Testing (Vitest)

1. Verify `vitest.config.ts` resolves `@` path aliases and includes `src/**/*.test.{ts,tsx}`.
2. **Never create standalone CLI test scripts** (`test-*.ts`, `verify-*.js`). Write all checks inside `*.test.ts` or `*.test.tsx` files.
3. Cover:
   - Pure utilities & data formatters (`it.each` tables).
   - Plugin manifest schema & file existence checks (`src/plugins/*.test.ts`).
   - Core UI primitives and context providers.

## Step 3: Backend Testing (Go Daemon / APIs)

1. Place tests alongside the implementation (`<module>_test.go`).
2. Always isolate SQLite state using `t.TempDir()` so test runs never touch development `.db` files.
3. Mock external HTTP services (`httptest.NewServer`) for deterministic CI and offline sandbox runs.

## Step 4: Targeted Execution Only

When verifying a test file you just wrote, run **only that targeted test file or package** (e.g., `npx vitest run src/app/utils/formatters.test.ts` or `cd src/daemon && go test -v -run TestName .`) rather than running full pre-commit test hooks after every small edit.
