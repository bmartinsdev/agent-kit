## Go Backend & Daemon Standards (`go-daemon`)

- **Handler & Package Structure**: Keep HTTP route handlers clean, validate request methods and JSON bodies, and separate external service integrations from transport handlers.
- **Table-Driven Unit Tests**: Pair handler and integration changes with `*_test.go` unit tests using `httptest.NewServer` / `httptest.NewRecorder` and isolated temporary SQLite databases where applicable.
- **Version & Changelog Synchronization**: Whenever changes affect the compiled daemon executable, bump the version string across all project version files declared in the project's `AGENTS.md` and add a concise entry under the corresponding version header in `CHANGELOG.md`.
