---
name: project-onboarding-auditor
description: >-
  Scans a new or existing repository to detect its tech stack, architecture, UI
  playground, database/ORM, Docker/CI, and testing setup, syncs matching rule
  modules into `.agents/rules-library/`, and generates portable, relative-path
  `.agents/AGENTS.md` and directory-scoped `AGENTS.md` files. Use when setting
  up a project, auditing workflow drift, or updating project rules.
---

# Project Onboarding & Conditional Rules Auditor

Use this skill to bootstrap or refresh any project's agent configuration using **100% portable relative paths** (zero hardcoded machine/user paths).

## Step 1: Detect Stack & Sync Conditional Rules into `.agents/rules-library/`

1. Run the stack detector and rule sync scripts against the workspace root:
   ```bash
   ~/.gemini/config/plugins/agent-kit/skills/project-onboarding-auditor/scripts/detect-stack.sh
   ~/.gemini/config/plugins/agent-kit/skills/project-onboarding-auditor/scripts/sync-project-rules.sh
   ```
2. This populates `.agents/rules-library/*.md` with only the rule modules that match the repository's tech stack.

## Step 2: Generate Scoped `AGENTS.md` Files with Relative Paths

Read [agents-md-templates.md](./references/agents-md-templates.md) and write:
1. **Root `.agents/AGENTS.md`**: Project architecture map + relative `@[...](./rules-library/<module>.md)` includes.
2. **Frontend `AGENTS.md`** (e.g., `src/app/AGENTS.md`): Playground path, token summary, and relative `@[...](../../.agents/rules-library/<module>.md)` includes.
3. **Backend `AGENTS.md`** (e.g., `src/daemon/AGENTS.md`): Version bump targets, DB isolation rules, and relative `@[...](../../.agents/rules-library/<module>.md)` includes.

**Important Guardrail**: Never write absolute user paths (`/home/<user>/...` or `file:///home/...`) into any repository markdown file. Always use relative paths so the repository works across any machine, OS, or contributor environment.
