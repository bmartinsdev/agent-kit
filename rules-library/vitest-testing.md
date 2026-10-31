## Vitest Verification Standards (`vitest-testing`)

- **Consolidate Verification via Vitest**: Never create custom one-off CLI script runners (like `test-*.ts`, `verify-*.js`, or standalone debug scripts) for integration or component verification.
- **Standard Test Suites**: Write all TypeScript/React test assertions as standard Vitest suites (`*.test.ts` or `*.test.tsx`) co-located with the source module or inside the configured test directory.
