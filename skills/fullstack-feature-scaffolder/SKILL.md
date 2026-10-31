---
name: fullstack-feature-scaffolder
description: >-
  Coordinates end-to-end feature and plugin development across backend routes,
  service integrations, shared TypeScript contracts, UI playground showcases,
  and page integration. Use when building a feature or plugin that spans
  both backend and frontend layers.
---

# Full-Stack Feature & Plugin Scaffolder

Use this skill when implementing features or plugins that span backend APIs/daemons and frontend React UI so that no layer is left out of sync.

## Step 1: Lock Down the End-to-End Contract

Read `.agents/AGENTS.md` and [contract-checklist.md](./references/contract-checklist.md) to map every layer touched by the feature:
1. **JSON API Contract**: Define the exact endpoint path, HTTP method, request body, response JSON schema, and TypeScript interfaces first.
2. **File Ownership Boundaries**: Decide whether to execute sequentially or delegate to `backend-architect` and `ui-designer` in parallel via **`workforce-orchestrator`**.

## Step 2: Execute in Dependency Order

1. **Backend + Unit Test (`backend-architect`)**:
   - Implement DB/integration/plugin logic and HTTP handler.
   - Write isolated unit tests (`*_test.go`).
2. **Playground UI (`ui-design-system` / `ui-designer`)**:
   - Build or update the UI component and its interactive states in the UI Playground (`src/app/kitchen/page.tsx`) first.
   - Register plugin UI settings in `pluginComponentRegistry` if building a plugin.
3. **Application Page Assembly**:
   - Connect the component to the live API route in the target page (`src/app/.../page.tsx`).
4. **Verification & Closeout (`test-architect` & `spec-and-docs-keeper`)**:
   - Verify all items in [contract-checklist.md](./references/contract-checklist.md), run targeted tests, and sync version/changelog/docs.
