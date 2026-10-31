## Database & ORM Standards (`database-orm`)

- **Schema & Migration Discipline**: Never modify production/local database tables manually without updating the canonical schema definition or migration runner (Prisma schema, Drizzle schema, or SQL migration scripts).
- **Query Safety & Parameterization**: Always use parameterized queries or typed ORM builders (`?`, `$1`, Prisma/Drizzle operators). Never interpolate raw strings into SQL statements.
- **Prevent N+1 Queries**: Avoid executing database queries inside loops. Use batch queries (`IN (...)`), joins, or eager relation loading.
- **Test Isolation**: Database unit and integration tests must always run against an isolated temporary SQLite file (`t.TempDir()` / `:memory:`) or dedicated test database so local development data is never mutated or wiped.
- **WSL2 SQLite Compatibility (Node/TS)**: In WSL2 environments lacking native C++ build chains (`make`, `node-gyp`), prefer `@libsql/client` (async `await` API) over native `better-sqlite3`.
