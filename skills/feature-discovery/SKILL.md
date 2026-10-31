---
name: feature-discovery
description: >-
  Pre-code feature discovery and requirement alignment skill. Scans existing
  routes, components, plugins, and task specs first to prevent duplicate work,
  then interviews the user with targeted multiple-choice questions before
  writing a spec or launching implementation.
---

# Feature Discovery & Pre-Code Alignment

Use this skill whenever the user proposes a new feature, asks to plan an enhancement, or starts a non-trivial task with open design decisions.

## Step 1: Scan Existing Codebase Capabilities First

Before proposing any new API route, UI component, or task spec, run the capability scanner so you never propose duplicating something that already exists:
```bash
~/.gemini/config/plugins/agent-kit/skills/feature-discovery/scripts/scan-existing-capabilities.sh
```
Check if an existing route (e.g., `/api/search`), component (e.g., `FolderPicker`, `ConfirmationModal`), or task spec in `tasks/` already partially implements the feature.

## Step 2: Resolve Ambiguities via `ask_question`

If the feature has meaningful UX, architectural, or scope trade-offs:
1. Formulate **1 to 3 concise multiple-choice questions** using the `ask_question` tool.
2. Put your recommended approach first, prefixed with `(Recommended)`, based on what you found in Step 1.
3. Focus questions on:
   - **UX Placement**: Modal vs. dedicated route vs. inline drawer/section.
   - **Data & Persistence**: Where state lives (SQLite settings/tables, plugin config, or client state).
   - **Scope Boundaries**: Minimum viable slice vs. full automation.

## Step 3: Output Conflict-Free Spec or Launch Workforce

Once aligned with the user:
- If the user wants a **Specification / Plan first**: Use `spec-and-docs-keeper` to write or update the modular spec in `tasks/` (extending existing routes/components discovered in Step 1) and index it in `tasks/README.md`.
- If the user wants **Immediate Implementation**: Hand the agreed contract directly to `workforce-orchestrator` (`fullstack-feature-scaffolder` / `ui-design-system`).
