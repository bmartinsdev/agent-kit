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

## Step 2: Parallel Specialist Re-Evaluation (For Planned Tasks or Multi-Layer Features)

When evaluating one or more task specifications in `tasks/` (or a feature spanning multiple layers):
1. Spawn the relevant specialist subagents (`backend-architect`, `ui-designer`, `qa-architect`, `docs-keeper`) in parallel in **Read-Only Audit Mode** (`workforce-orchestrator`).
2. Have each specialist compare the `tasks/*.md` spec against the actual repository state, identify spec drift or hidden edge cases, and formulate **1–3 multiple-choice questions** from their domain perspective.

## Step 3: Resolve Ambiguities via `ask_question`

Consolidate the findings and questions from all required specialists and present them to the user:
1. Formulate concise multiple-choice questions using the `ask_question` tool, prefixing each question with the specialist role tag (e.g., `[backend-architect]`, `[ui-designer]`, `[qa-architect]`, `[docs-keeper]`).
2. Put the recommended approach first, prefixed with `(Recommended)`, based on the codebase audit.
3. Focus questions on:
   - **Architecture & Contracts (`[backend-architect]`)**: Endpoints, schemas, plugin entrypoints, and state persistence.
   - **UX & Playground (`[ui-designer]`)**: Component placement, `/kitchen` showcase scope, and interaction details.
   - **Verification Scope (`[qa-architect]`)**: Test runner boundaries, fixtures, and edge-case assertions.
   - **Spec & Docs Alignment (`[docs-keeper]`)**: Doc structure, deprecations, and task checklist updates.

## Step 4: Lock In Spec & Launch Workforce

Once aligned with the user:
- Update the modular spec in `tasks/` (and `tasks/README.md` status) to lock in the user's answers.
- Hand the agreed contract directly to `workforce-orchestrator` (`fullstack-feature-scaffolder` / `ui-design-system`) for execution.
