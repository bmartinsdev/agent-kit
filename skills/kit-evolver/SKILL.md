---
name: kit-evolver
description: >-
  Evolves and updates the shared `agent-kit` ecosystem (`~/p/agent-kit`) or
  project-scoped `AGENTS.md` files whenever the user corrects the agent,
  establishes a new coding convention, or asks to save a lesson/rule/skill for
  future projects, and automatically opens a GitHub PR to `agent-kit`.
---

# Agent-Kit Self-Improvement & Automated PR Evolver

Use this skill whenever the user teaches a new preference, corrects a recurring mistake, or asks to update the shared agent workforce (`agent-kit`) while working in **any** project.

## Step 1: Inspect the Current `agent-kit` Inventory

Run the inventory script to see all existing rule modules, skills, and agents:
```bash
~/.gemini/config/plugins/agent-kit/skills/kit-evolver/scripts/inspect-kit.sh
```

## Step 2: Classify the Scope of the Lesson

Never dump project-specific file paths into global rules, and never trap universal engineering habits inside a single project's `.agents/AGENTS.md`. Route the update using this matrix:

| Type of Lesson / Correction | Target Destination | Opens PR to `agent-kit`? |
| :--- | :--- | :--- |
| **1. Project-Specific Context** *(A path, port, API quirk, or domain rule unique to the current repo)* | `<workspace>/.agents/AGENTS.md` or `<workspace>/src/<layer>/AGENTS.md` | No (lives in project repo) |
| **2. Stack-Conditional Rule** *(Applies to any project using TypeScript, React, Go, DB/ORM, Docker, etc.)* | `~/.gemini/config/plugins/agent-kit/rules-library/<stack>.md` | **Yes** |
| **3. Universal Workflow Rule** *(Applies to every project regardless of language or stack)* | `~/.gemini/config/plugins/agent-kit/rules/AGENTS.md` | **Yes** |
| **4. Automated Audit Check or Template** *(Can be grep-checked or templated inside a skill)* | `~/.gemini/config/plugins/agent-kit/skills/<skill>/scripts/*.sh` or `references/*.md` | **Yes** |
| **5. Hard Command Block** *(A command that must be blocked before execution)* | `~/.gemini/config/plugins/agent-kit/scripts/pre-tool-guard.sh` | **Yes** |

## Step 3: Generalize & Apply the Update

1. When writing to `~/.gemini/config/plugins/agent-kit/`, phrase rules and scripts in **stack-level, portable terms** (never hardcode user home paths like `/home/<user>`).
2. If you updated a rule in `rules-library/`, sync it into the current workspace's `.agents/rules-library/` immediately so the active project benefits right away:
   ```bash
   ~/.gemini/config/plugins/agent-kit/skills/project-onboarding-auditor/scripts/sync-project-rules.sh
   ```

## Step 4: Automatically Open a Pull Request to the `agent-kit` Repo

Whenever you modify files inside `~/.gemini/config/plugins/agent-kit/`:
1. Run `open-kit-pr.sh` (requires `BypassSandbox: true` for network/GitHub access and writing to `~/.gemini/config/plugins/agent-kit/.git`):
   ```bash
   ~/.gemini/config/plugins/agent-kit/skills/kit-evolver/scripts/open-kit-pr.sh "<short-slug>" "<feat/rules(kit): concise title>" "<markdown body explaining the rule/skill change and why it was added>"
   ```
2. Note: While raw `git add`/`git commit`/`git push` commands are blocked in user project repositories by `pre-tool-guard.sh`, `open-kit-pr.sh` is an authorized `agent-kit` script that scopes its git operations strictly to `~/.gemini/config/plugins/agent-kit`.
3. Share the created GitHub Pull Request link with the user so they can review and merge it on GitHub whenever they like.
