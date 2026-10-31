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

## Step 2: Inspect the Diff Against the Review Rubric

1. Run `git diff` (and inspect any untracked source files) to review the logic changes.
2. Evaluate all changes against [review-checklist.md](./references/review-checklist.md) (Security, Frontend/Playground Parity, Backend/Test Isolation, and Repo Hygiene).

## Step 3: Fix Blockers or Report Readiness

- If you find `[BLOCKER]` issues caused by recent edits (such as an `: any` type, a stray `.db` file created by a test, or a missing version bump), fix them immediately and re-run Step 1.
- Present a concise **Pre-Commit Readiness Summary** listing:
  - Modified & untracked files ready for staging
  - Any `[BLOCKER]` / `[WARNING]` / `[NIT]` findings
  - Verification status (`READY TO COMMIT` vs `NEEDS ATTENTION`)
