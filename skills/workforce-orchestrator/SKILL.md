---
name: workforce-orchestrator
description: >-
  Hybrid multi-agent orchestrator that coordinates specialist subagents
  (ui-designer, backend-architect, qa-architect, docs-keeper, code-reviewer)
  across multi-step features, UI redesigns, QA sweeps, and pre-commit audits.
  Activate when a task spans multiple layers or benefits from parallel
  specialist execution.
---

# Hybrid Workforce Orchestrator

Use this skill to decide when to execute directly vs. when to delegate to specialist subagents, and to enforce clean **Handoff Contracts** between agents.

## 1. Decision Matrix: Direct vs. Subagent Delegation

| Task Complexity | Execution Mode | How to Execute |
| :--- | :--- | :--- |
| **New Idea / Ambiguous Feature** | **Discovery First** | Run **`feature-discovery`** (`scan-existing-capabilities.sh` + `ask_question`) to lock down scope before coding. |
| **Single-Layer / Quick Task** *(1–2 files, bug fix, small tweak, question)* | **Direct Execution** | Handle directly in the main conversation using the relevant domain skill (`ui-design-system`, `test-architect`, etc.). |
| **Full-Stack Feature / Plugin** *(Backend API + Frontend UI + Tests + Docs)* | **Multi-Agent Pipeline** | Lock down the API/TypeScript contract first, then spawn **`backend-architect`** and **`ui-designer`** in parallel, followed by **`qa-architect`**, **`docs-keeper`**, and **`code-reviewer`**. |
| **Multi-Screen UI Audit / Redesign** *(Auditing or restyling multiple screens/sections)* | **Subagent Delegation** | Spawn **`ui-designer`** equipped with `ui-design-system` and Mobbin skills. |
| **Pre-Commit Quality Gate** *(Before handing back a multi-file change or when asked to review)* | **Critic Gate** | Run **`pre-commit-audit`** directly or spawn **`code-reviewer`** to verify the working tree and `git diff`. |
| **Rule / Workflow Correction** *(User teaches a new habit or rule)* | **Self-Improvement** | Run **`kit-evolver`** to route the lesson into `agent-kit` vs. project `AGENTS.md`. |

---

## 2. Specialist Roster (`agents/`)

All 5 specialist agents are natively registered by `agent-kit` and can be invoked directly via `invoke_subagent(TypeName: "<agent-name>", Model: "inherit", ...)`:
- **`ui-designer`**: UI Playground (`/kitchen` / Storybook) first, semantic CSS tokens, Mobbin benchmarking.
- **`backend-architect`**: Go/Node HTTP routes, SQLite/ORM persistence, plugin registries, isolated `_test.go` suites.
- **`qa-architect`**: Vitest (`*.test.ts(x)`) + Go test coverage gap elimination.
- **`docs-keeper`**: `tasks/`, `roadmap.md`, `docs/api.md`, version parity, and `CHANGELOG.md`.
- **`code-reviewer`**: Independent critic auditing `git diff`, security boundaries, stray files, and playground/version sync.

Read [handoff-contracts.md](./references/handoff-contracts.md) for the exact Input Brief and Handoff Report format required for every subagent call.
