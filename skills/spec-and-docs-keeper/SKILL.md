---
name: spec-and-docs-keeper
description: >-
  Maintains task specifications (`tasks/`), roadmaps (`roadmap.md`), technical
  documentation (`docs/`), API references, version synchronization, and
  changelogs (`CHANGELOG.md`). Use when planning new features, auditing doc
  drift, completing backlog tasks, or documenting API and architecture changes.
---

# Specification, Roadmap & Documentation Keeper

Use this skill to keep project planning (`tasks/`, `roadmap.md`), developer documentation (`docs/`), version numbers, and release history (`CHANGELOG.md`) synchronized with the codebase.

## Step 1: Run the Automated Drift Checker

Execute the bundled drift script first:
```bash
~/.gemini/config/plugins/agent-kit/skills/spec-and-docs-keeper/scripts/check-doc-drift.sh
```
Consult [doc-templates.md](./references/doc-templates.md) for API reference and changelog formatting standards.

## Step 2: Feature Specifications & Roadmaps (`tasks/` & `roadmap.md`)

1. Use `tasks/template.md` when authoring new feature specs.
2. Ensure every spec has realistic milestone priority (`P0`–`P3`), clear acceptance criteria checkboxes, and a Mermaid data-flow diagram.
3. Keep `tasks/README.md` and `roadmap.md` synchronized whenever a task's status transitions (`Planned` → `In Progress` → `Completed`).

## Step 3: Technical Documentation (`docs/`)

Maintain the 4 core documentation guides in `docs/`:
- `docs/architecture.md` — Single-binary / embedded SPA / SQLite / plugin architecture overview.
- `docs/getting-started.md` — Prerequisites, local dev (`pnpm run dev`), build (`pnpm run build`), and troubleshooting.
- `docs/api.md` — Complete REST API reference matching every route in the backend.
- `docs/plugins.md` — Plugin manifest schema (`plugin.json`), backend interfaces, and React UI registration guide.

## Step 4: Version & Changelog Synchronization

Whenever backend/daemon code changes, verify that `package.json`, `src/daemon/main.go` (`--version`), and `CHANGELOG.md` are all updated to the same new version string.
