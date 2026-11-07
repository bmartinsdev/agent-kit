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
| **Pre-Commit & Post-Pivot Critic Gate** *(Before handing back a multi-file change or after any mid-task requirement pivot)* | **Mandatory `code-reviewer` Subagent Gate** | Spawn **`code-reviewer`** (`invoke_subagent(TypeName: "code-reviewer", ...)`) to audit `git diff` across all layers for leftover/orphaned code, redundant wrappers, and unreferenced untracked files. |
| **Post-Approval Change Closure** *(User approves the completed work or asks to commit/close)* | **Close-Change Gate** | Run **`close-change`** (`commit-approved-change.sh`) to stage, run pre-commit hooks, and create the Conventional Commit. |
| **Rule / Workflow Correction** *(User teaches a new habit or rule)* | **Self-Improvement** | Run **`kit-evolver`** to route the lesson into `agent-kit` vs. project `AGENTS.md`. |

---

## 2. Mandatory Multi-Agent Task Re-Evaluation & Closure Lifecycle

Whenever starting a task or milestone from `tasks/`, execute this 4-phase lifecycle:

1. **Phase 1 — Parallel Specialist Task Audit (Read-Only)**:
   - Identify every specialist domain touched by the task (`backend-architect`, `ui-designer`, `qa-architect`, `docs-keeper`).
   - Invoke those specialists in parallel with a **Task Re-Evaluation Brief** (see [handoff-contracts.md](./references/handoff-contracts.md)). Instruct them **not** to modify files yet—only audit the `tasks/*.md` spec against the live codebase, flag stale assumptions or drift, and return 1–3 high-impact domain questions with a `(Recommended)` default.
2. **Phase 2 — Synthesized User Interview (`ask_question`)**:
   - Summarize what the specialists found (what's already built vs. what drifted in the spec).
   - Call `ask_question` with the consolidated questions from all required agents, prefixing each question with the agent tag (e.g., `[backend-architect]`, `[ui-designer]`, `[qa-architect]`, `[docs-keeper]`) and putting `(Recommended)` on the first option.
3. **Phase 3 — Spec Lock-In & Execution**:
   - Update the `tasks/*.md` spec(s) to reflect the user's answers so the spec is the single source of truth.
   - Proceed to implementation with the locked handoff contracts. Because plugin-bundled `agents/*.md` subagents (`TypeName: "<agent-name>"`) run with read-only tools (which enforces safety during Phase 1 audits and `code-reviewer` gates), spawn Phase 3 implementation specialists using `define_subagent(..., EnableWriteTools: true)` or `invoke_subagent(TypeName: "self", Role: "<Specialist Role>", ...)`.
4. **Phase 4 — Mandatory `code-reviewer` Gate, Manual Testing Guide & Post-Approval Change Closure (`close-change`)**:
   - Before presenting completed work to the user—and **especially after any mid-task requirement change or scope reduction**—spawn the **`code-reviewer`** subagent (`invoke_subagent(TypeName: "code-reviewer", ...)`) to run `audit-working-tree.sh` and inspect the full `git diff` across all layers for orphaned/leftover code from earlier iterations, redundant wrapper methods, and unreferenced untracked files.
   - Fix all `[BLOCKER]` and `[WARNING]` findings returned by `code-reviewer` and run `check-doc-drift.sh`.
   - Present the **Pre-Approval Summary of Changes & Manual Testing Guide** (see [handoff-contracts.md](./references/handoff-contracts.md)) to the user, detailing:
     1. **Summary of Changes** grouped by feature/layer with clickable file links.
     2. **How to Test Before Approving** with step-by-step manual verification flows (dev server startup command, UI Playground `/kitchen` checks, and main application end-to-end flows).
     3. **Automated Verification Status** (`code-reviewer` audit, ESLint, backend & frontend unit test results).
   - Once the user tests and explicitly approves the changes (or asks to close/commit the change), execute **`close-change`** (`commit-approved-change.sh`) to stage all files, trigger pre-commit hooks, and create the Conventional Commit.

---

## 3. Specialist Roster & Dynamic Model Routing (`agents/`)

All 6 specialist agents are natively registered by `agent-kit`. To optimize quota and speed without sacrificing code quality, **always set `Model` dynamically on every `invoke_subagent` call** using this matrix instead of defaulting everything to `'inherit'`:

| Subagent | Use `Model: "flash_lite"` | Use `Model: "flash"` | Escalate to `Model: "pro"` (or `"inherit"`) |
| :--- | :--- | :--- | :--- |
| **`code-reviewer`** | — | **Routine / Scoped Diffs**: `<= 5` files, UI/token polish, or clean features with no mid-task requirement pivot. | **High-Risk / Post-Pivot Diffs**: `> 5` files across Go + React, auth/SQL/filesystem security paths, or **after any mid-task requirement pivot** to hunt down orphaned code. |
| **`ui-designer`** | — | **Phase 1 Read-Only Audit** + **Targeted UI Edits**: Adding a variant, updating `/kitchen` states, or restyling a single component. | **Complex UI Architecture**: Multi-step wizards, complex async state/hooks, or full-screen Mobbin redesigns. |
| **`backend-architect`** | — | **Phase 1 Read-Only Audit** + **Simple Endpoints**: Adding a struct field or wiring a straightforward handler. | **Complex Backend Logic**: New SQLite tables/migrations, plugin interfaces, concurrency/goroutines, or external service integrations. |
| **`qa-architect`** | — | **Phase 1 Read-Only Audit** + **Standard Test Suites**: Writing Vitest (`*.test.tsx`) or Go (`*_test.go`) unit tests following existing patterns. | **Complex Test Debugging**: Diagnosing flaky async/network tests or designing a new mock harness from scratch. |
| **`docs-keeper`** | **Quick Syncs**: Single version bump or checking off a task item. | **Phase 1 Audit + Full Milestone Docs**: Updating `docs/api.md`, `CHANGELOG.md`, `roadmap.md`, and `tasks/*.md`. | — *(Never needs `'pro'`)* |
| **`change-closer`** | **Always**: Running `audit-working-tree.sh`, `check-doc-drift.sh`, and `commit-approved-change.sh`. | — | — *(Never needs `'pro'`)* |

Read [handoff-contracts.md](./references/handoff-contracts.md) for the exact Input Brief and Handoff Report format required for every subagent call.
