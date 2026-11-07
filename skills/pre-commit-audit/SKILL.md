---
name: pre-commit-audit
description: >-
  Audits uncommitted git changes for bugs, security risks, leftover debug logs,
  stray artifacts, UI playground drift, and version/changelog mismatches before
  the user commits. Use when wrapping up a task or when asked to review changes.
---

# Pre-Commit Audit & Quality Gate

Use this skill before handing completed multi-file work back to the user or whenever the user asks to review current changes before committing.

## Step 1: Run the Working Tree Audit Script

Execute the automated working tree check:
```bash
~/.gemini/config/plugins/agent-kit/skills/pre-commit-audit/scripts/audit-working-tree.sh
```

## Step 2: Spawn `code-reviewer` or Inspect the Diff Against the Review Rubric

1. For multi-file tasks or after any mid-task requirement change/pivot, spawn the **`code-reviewer`** subagent (`invoke_subagent(TypeName: "code-reviewer", ...)`) to independently audit `git diff` and all untracked files across every layer (Backend interfaces/handlers, Frontend components/providers, Tests, and Docs).
2. Evaluate all changes against [review-checklist.md](./references/review-checklist.md) (Security, Frontend/Playground Parity, Backend/Test Isolation, Orphaned Code / Mid-Task Pivot Cleanup, and Repo Hygiene).

## Step 3: Fix Blockers & Orphaned Code Before Reporting Readiness

- If `code-reviewer` or `audit-working-tree.sh` finds `[BLOCKER]` or `[WARNING]` issues (such as leftover structs/params from a discarded feature iteration, redundant wrapper functions, unreferenced untracked files, an `: any` type, a stray `.db` file, or a missing version bump), fix them immediately and re-run Step 1.
- Present a concise **Pre-Commit Readiness Summary** listing:
  - Modified & untracked files ready for staging
  - Any `[BLOCKER]` / `[WARNING]` / `[NIT]` findings
  - Verification status (`READY TO COMMIT` vs `NEEDS ATTENTION`)
