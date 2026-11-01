---
name: close-change
description: >-
  Finalizes and commits an approved task after the user reviews and approves the
  changes. Runs pre-commit working tree and doc-drift audits, crafts a
  Conventional Commit message, and executes the sanctioned commit script (which
  triggers lint-staged and test:changed hooks).
---

# Close Change & Approved Commit Workflow

Use this skill **only** after the user has reviewed the completed work and explicitly approved it (or asked to close/commit the change). Raw `git add`, `git commit`, and `git push` commands remain hard-blocked by `pre-tool-guard.sh` to prevent unapproved commits.

## Step 1: Verify Zero Pre-Commit Blockers

Run the working tree and documentation drift auditors first:
```bash
~/.gemini/config/plugins/agent-kit/skills/pre-commit-audit/scripts/audit-working-tree.sh && ~/.gemini/config/plugins/agent-kit/skills/spec-and-docs-keeper/scripts/check-doc-drift.sh
```
If any `[BLOCKER]` or version/changelog warning is reported, fix it before proceeding.

## Step 2: Confirm User Approval (If Not Already Given)

- If the user already said "commit", "close the change", or approved the commit in their message, proceed directly to Step 3.
- Otherwise, present the proposed Conventional Commit title and summary and ask for confirmation first.

## Step 3: Execute the Sanctioned Commit Script

Run `commit-approved-change.sh` from the project workspace root:
```bash
~/.gemini/config/plugins/agent-kit/skills/close-change/scripts/commit-approved-change.sh "<type(scope): concise summary>" "<optional multi-line bulleted body>"
```
This script stages the working tree (`git add -A`), runs `git commit` (triggering the repository's `simple-git-hooks` / `lint-staged` / `pnpm run test:changed` pipeline), and outputs the resulting commit hash and diffstat.

