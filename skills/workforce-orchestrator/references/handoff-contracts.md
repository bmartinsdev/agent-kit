# Subagent Handoff Contracts & Prompts

When invoking a specialist subagent via `define_subagent` and `invoke_subagent`, always include a structured **Input Brief** and require a structured **Handoff Report** so the Lead Agent receives a high-signal summary without context bloat.

---

## 1. Phase 1: Task Re-Evaluation Audit Brief (Read-Only Gate)

Before implementing any task from `tasks/*.md`, spawn the required specialists in parallel in **Read-Only Audit Mode**:

### Audit Prompt Template (Lead Agent → Subagent)
1. **Mode**: `READ-ONLY TASK RE-EVALUATION AUDIT` (do not edit or create files).
2. **Target Spec(s)**: Path(s) to the `tasks/*.md` file(s) being evaluated.
3. **Domain Focus**: What this specialist (`backend-architect`, `ui-designer`, `qa-architect`, `docs-keeper`) must verify in the live codebase.
4. **Required Output**:
   - **Codebase Reality vs. Spec**: What is already implemented, partially implemented, or drifted from the spec.
   - **Domain Questions for User (1–3 max)**: Concrete multiple-choice questions where architectural, UX, testing, or documentation trade-offs exist, each with a `(Recommended)` first option and brief rationale.

---

## 2. Phase 2: Implementation Input Brief Template (Lead Agent → Subagent)

Every `Prompt` sent to `invoke_subagent` must include:
1. **Objective**: Clear 1–2 sentence goal.
2. **Workspace & Context Files**: Point the subagent to `.agents/AGENTS.md` and the relevant scoped `AGENTS.md` (e.g., `src/app/AGENTS.md` or `src/daemon/AGENTS.md`).
3. **Skill to Read First**: Explicit path to the `SKILL.md` in `~/.gemini/config/plugins/agent-kit/skills/<skill>/SKILL.md`.
4. **Agreed Contract**: Exact file paths, TypeScript interfaces, or JSON endpoint schemas to implement against.
5. **Boundaries**: Which files the subagent owns (so parallel subagents never edit the same file simultaneously).

---

## 2. Required Handoff Report (Subagent → Lead Agent)

Instruct every subagent to return its final message in this compact format:

```markdown
### Handoff Report: <Role Name>
- **Files Created / Modified**:
  - `path/to/file` — summary of change
- **Contract & Token Compliance**:
  - Interfaces / Endpoints: ...
  - Playground / Token Check: ...
- **Verification**:
  - Script / Test Run: `<command>` -> `PASS / FAIL`
- **Follow-Ups / Blockers**:
  - Any version bump, doc update, or open question for the Lead Agent.
```
