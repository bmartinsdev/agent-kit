## SQLite & WSL2 Database Standards (`sqlite-wsl`)

- **Use `@libsql/client` Instead of `better-sqlite3` (Node/TS)**: The WSL2 environment lacks native C/C++ build dependencies (`make`, `node-gyp`), causing from-source compilation of `better-sqlite3` to fail. Always use `@libsql/client` for Node/TypeScript SQLite interfaces.
- **Asynchronous Database Queries**: Unlike synchronous `better-sqlite3` APIs, all `@libsql/client` and Drizzle queries are asynchronous. Always `await` query operations (e.g. `await db.select(...)`).
