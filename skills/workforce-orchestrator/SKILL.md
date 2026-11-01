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
| **New Idea / Planned Task Spec (`tasks/*.md`)** | **Multi-Agent Re-Evaluation First** | Spawn all required specialists in read-only audit mode to compare the spec against the codebase, then interview the user via `ask_question` before coding. |
| **Single-Layer / Quick Task** *(1–2 files, bug fix, small tweak, question)* | **Direct Execution** | Handle directly in the main conversation using the relevant domain skill (`ui-design-system`, `test-architect`, etc.). |
| **Full-Stack Feature / Plugin** *(Backend API + Frontend UI + Tests + Docs)* | **Multi-Agent Pipeline** | After the Task Re-Evaluation Gate locks down the contract, spawn **`backend-architect`** and **`ui-designer`** in parallel, followed by **`qa-architect`**, **`docs-keeper`**, and **`code-reviewer`**. |
| **Multi-Screen UI Audit / Redesign** *(Auditing or restyling multiple screens/sections)* | **Subagent Delegation** | Run the Task Re-Evaluation Gate with **`ui-designer`**, then execute equipped with `ui-design-system` and Mobbin skills. |
| **Pre-Commit Quality Gate** *(Before handing back a multi-file change or when asked to review)* | **Critic Gate** | Run **`pre-commit-audit`** directly or spawn **`code-reviewer`** to verify the working tree and `git diff`. |
| **Rule / Workflow Correction** *(User teaches a new habit or rule)* | **Self-Improvement** | Run **`kit-evolver`** to route the lesson into `agent-kit` vs. project `AGENTS.md`. |

---

## 2. Mandatory Multi-Agent Task Re-Evaluation Gate

Whenever starting a task or milestone from `tasks/`, execute this 3-phase gate before writing implementation code:

1. **Phase 1 — Parallel Specialist Task Audit (Read-Only)**:
   - Identify every specialist domain touched by the task (`backend-architect`, `ui-designer`, `qa-architect`, `docs-keeper`).
   - Invoke those specialists in parallel with a **Task Re-Evaluation Brief** (see [handoff-contracts.md](./references/handoff-contracts.md)). Instruct them **not** to modify files yet—only audit the `tasks/*.md` spec against the live codebase, flag stale assumptions or drift, and return 1–3 high-impact domain questions with a `(Recommended)` default.
2. **Phase 2 — Synthesized User Interview (`ask_question`)**:
   - Summarize what the specialists found (what's already built vs. what drifted in the spec).
   - Call `ask_question` with the consolidated questions from all required agents, prefixing each question with the agent tag (e.g., `[backend-architect]`, `[ui-designer]`, `[qa-architect]`, `[docs-keeper]`) and putting `(Recommended)` on the first option.
3. **Phase 3 — Spec Lock-In & Execution**:
   - Update the `tasks/*.md` spec(s) to reflect the user's answers so the spec is the single source of truth.
   - Proceed to implementation with the locked handoff contracts.

---

## 3. Specialist Roster (`agents/`)

All 5 specialist agents are natively registered by `agent-kit` and can be invoked directly via `invoke_subagent(TypeName: "<agent-name>", Model: "inherit", ...)`:
- **`ui-designer`**: UI Playground (`/kitchen` / Storybook) first, semantic CSS tokens, Mobbin benchmarking.
- **`backend-architect`**: Go/Node HTTP routes, SQLite/ORM persistence, plugin registries, isolated `_test.go` suites.
- **`qa-architect`**: Vitest (`*.test.ts(x)`) + Go test coverage gap elimination.
- **`docs-keeper`**: `tasks/`, `roadmap.md`, `docs/api.md`, version parity, and `CHANGELOG.md`.
- **`code-reviewer`**: Independent critic auditing `git diff`, security boundaries, stray files, and playground/version sync.

Read [handoff-contracts.md](./references/handoff-contracts.md) for the exact Input Brief and Handoff Report format required for every subagent call.
