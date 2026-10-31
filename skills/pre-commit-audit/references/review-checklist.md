# Pre-Commit Code Review Rubric

Evaluate every uncommitted change against these 4 dimensions before declaring a working tree ready to commit.

---

## 1. Security & Trust Boundaries (`[BLOCKER]`)
- **Path & Command Safety**: Any filesystem endpoint (`/api/fs/*`) or shell execution must sanitize inputs and prevent path traversal (`..`) or command injection.
- **Authentication & Localhost Guards**: Verify new backend routes apply the appropriate auth middleware or localhost check.
- **Secrets Hygiene**: Ensure zero API keys, tokens, or credentials are hardcoded or written to tracked `.env` files.

## 2. Frontend Quality & Playground Parity (`[BLOCKER]` / `[WARNING]`)
- **Strict TypeScript**: Zero `: any` or `as any` in changed `.ts`/`.tsx` files.
- **React Hook Safety**: No synchronous `setState` inside `useEffect` bodies; complete dependency arrays on `useEffect`, `useCallback`, and `useMemo`.
- **UI Playground Sync**: New or modified visual components must be showcased and up to date in the UI Playground (`/kitchen` or Storybook).
- **Complete UI States**: Async views must handle loading, empty, and error states gracefully using semantic CSS tokens (`globals.css`).

## 3. Backend Reliability & Test Isolation (`[BLOCKER]` / `[WARNING]`)
- **Error Handling**: Go/Node handlers must check errors explicitly, close resources (`defer resp.Body.Close()`, `defer rows.Close()`), and return structured JSON errors with appropriate HTTP status codes.
- **Test Isolation**: Unit tests touching SQLite/databases must use `t.TempDir()` or isolated test DBs—never the dev `.db` file.
- **Version & Changelog Sync**: If compiled Go daemon files changed, verify `package.json`, `src/daemon/main.go`, and `CHANGELOG.md` are bumped in lockstep.

## 4. Repository Hygiene (`[WARNING]` / `[NIT]`)
- **No Stray Artifacts**: Ensure untracked `.db`, `.log`, build outputs (`dist/`, `out/`), or ad-hoc `test-*.ts` files are cleaned up or ignored before the user runs `git add` / `git commit`.
- **Dead Code**: Remove unused imports, commented-out blocks, and leftover `console.log` statements.
