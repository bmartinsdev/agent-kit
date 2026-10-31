# Documentation & Specification Blueprints

Use these standardized templates when authoring or updating `docs/architecture.md`, `docs/api.md`, `docs/plugins.md`, `tasks/*.md`, and `CHANGELOG.md`.

---

## 1. `docs/api.md` Endpoint Section Blueprint

For every route registered in the backend, document:
```markdown
### `METHOD /api/path`

- **Auth Requirement**: `Localhost Bypass` | `PIN Session Cookie Required` | `Public`
- **Description**: One-sentence explanation of what the endpoint does.
- **Query / Request Body**:
  ```json
  {
    "field": "value"
  }
  ```
- **Success Response (`200 OK`)**:
  ```json
  {
    "success": true
  }
  ```
- **Error Responses**: `400 Bad Request`, `401 Unauthorized`, `500 Internal Server Error`
```

---

## 2. `CHANGELOG.md` Entry Blueprint

Whenever the daemon or application version is bumped, add a new top section:
```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- Concise summary of new features, endpoints, or UI components.

### Changed
- Updates to existing workflows, UI tokens, or plugin contracts.

### Fixed
- Bug fixes, diagnostic improvements, or test stability updates.
```
