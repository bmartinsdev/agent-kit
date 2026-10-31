# 🛠️ Shared Agent & Skill Workforce (`agent-kit`)

A portable, cross-project Antigravity plugin providing a **5-Agent Specialist Workforce**, **9 Universal Skills with Executable Scripts**, **`SessionStart` & `PreToolUse` Hooks**, and an **8-Module Conditional Rule Library** across all workspaces.

- **Global Plugin Mount**: `~/.gemini/config/plugins/agent-kit`
- **Optional Project Shortcut**: `~/p/agent-kit` (symlinked to `~/.gemini/config/plugins/agent-kit`)

---

## 🤖 Instructions for AI Agents (One-Prompt Setup & Updates)

> **If a user tells you: *"Setup `<git-repo-url>`"* or *"Update `agent-kit` and onboard this project"*, follow these exact steps:**

### Step 1: Install or Update `agent-kit` Globally
- **Fresh Install (when `~/.gemini/config/plugins/agent-kit` does not exist)**:
  ```bash
  git clone <git-repo-url> ~/.gemini/config/plugins/agent-kit
  ~/.gemini/config/plugins/agent-kit/scripts/install.sh
  ```
- **Update Existing Install**:
  ```bash
  ~/.gemini/config/plugins/agent-kit/scripts/sync-kit.sh --pull
  ```

### Step 2: Onboard the Active Workspace
1. Detect the current project's stack and sync matching conditional rule modules into `.agents/rules-library/`:
   ```bash
   ~/.gemini/config/plugins/agent-kit/skills/project-onboarding-auditor/scripts/detect-stack.sh
   ~/.gemini/config/plugins/agent-kit/skills/project-onboarding-auditor/scripts/sync-project-rules.sh
   ```
2. Read `~/.gemini/config/plugins/agent-kit/skills/project-onboarding-auditor/SKILL.md` and generate:
   - `.agents/AGENTS.md` (Project architecture map + repo-wide `@[...](./rules-library/<module>.md)` includes)
   - Directory-scoped `AGENTS.md` files (e.g. `src/app/AGENTS.md`, `src/daemon/AGENTS.md`) using **portable relative paths** (`@[...](../../.agents/rules-library/<module>.md)`).
   - **Never** hardcode user home paths (`/home/<user>/...`) inside repository markdown files.

---

## 🔄 Automatic New-Project & Update Detection (`SessionStart` Hook)

Whenever a new chat starts in any workspace, [`scripts/session-start.py`](./scripts/session-start.py) runs automatically via [`hooks.json`](./hooks.json):
1. **Unconfigured Project Detection**: If the active workspace does not have `.agents/AGENTS.md` yet, the agent automatically offers to run `project-onboarding-auditor`.
2. **Cross-Project Rule Drift Detection**: If a rule in `agent-kit/rules-library/` was updated while working in Project A, opening Project B detects that `.agents/rules-library/` has newer versions available and asks the user if they want to sync them.
3. **Remote GitHub Update Detection**: If `~/.gemini/config/plugins/agent-kit` is behind `origin/main`, the agent notifies the user and offers to pull the latest updates via `scripts/sync-kit.sh --pull`.
4. **Silent When Clean**: Outputs `{}` with zero token overhead when the project is already configured and up to date.

---

## 💬 Everyday Prompt Cheatsheet

| Goal | What to Say in Any Project | Skill / Agent Triggered |
| :--- | :--- | :--- |
| **Onboard a new or existing repo** | *"Onboard this project and wire up conditional rules"* | `project-onboarding-auditor` |
| **Brainstorm / spec a new feature** | *"Let's plan `<feature>` — scan existing capabilities first"* | `feature-discovery` + `spec-and-docs-keeper` |
| **Build or redesign UI screens** | *"Redesign `<screen>` using our Playground-first workflow"* | `ui-design-system` + `ui-designer` agent |
| **Build a full-stack feature/plugin** | *"Build `<feature>` end-to-end across backend and UI"* | `workforce-orchestrator` + `fullstack-feature-scaffolder` |
| **Fill test coverage gaps** | *"Scan for coverage gaps and add unit tests for `<module>`"* | `test-architect` + `qa-architect` agent |
| **Review changes before committing** | *"Run a pre-commit audit on my current changes"* | `pre-commit-audit` + `code-reviewer` agent |
| **Save a new rule/lesson to the kit** | *"Save this rule to `agent-kit` and open a PR"* | `kit-evolver` (`scripts/open-kit-pr.sh`) |
| **Check / pull `agent-kit` updates** | *"Check for `agent-kit` updates and sync rules"* | `scripts/sync-kit.sh` |

---

## 📂 Complete Architecture

```text
~/.gemini/config/plugins/agent-kit/
├── plugin.json                           # Antigravity plugin manifest
├── hooks.json                            # SessionStart (auto-onboard/update check) & PreToolUse (safety guard)
├── scripts/
│   ├── session-start.py                  # Auto-detects unconfigured projects & rule/remote updates
│   ├── pre-tool-guard.sh                 # Blocks git commit/push/add & ad-hoc test-*.ts scripts
│   ├── install.sh                        # Portable one-step installer for any machine
│   └── sync-kit.sh                       # Checks/pulls GitHub updates & syncs project rules
├── rules/
│   └── AGENTS.md                         # Always-on global rules & Hybrid Workforce protocol
├── rules-library/                        # 8 Conditional Rule Modules (synced into .agents/rules-library/)
│   ├── typescript-strict.md              # Zero `any`, explicit interfaces & shared domain types
│   ├── react-nextjs.md                   # Async setState in useEffect & complete hook dependency arrays
│   ├── ui-playground-first.md            # Playground/Kitchen-first UI workflow & semantic tokens
│   ├── go-daemon.md                      # Go HTTP handler standards, isolated DB tests & version sync
│   ├── vitest-testing.md                 # Vitest suite standards (no standalone test-*.ts scripts)
│   ├── sqlite-wsl.md                     # Async @libsql/client usage on WSL2
│   ├── database-orm.md                   # Schema migrations, parameterized queries, N+1 & test isolation
│   └── docker-ci.md                      # Multi-stage Dockerfiles, .dockerignore & CI/local parity
├── agents/                               # 5 Specialist Subagent Personas
│   ├── ui-designer.md                    # Design System, Playground & Mobbin UX Specialist
│   ├── backend-architect.md              # Backend, API, Database & Plugin Systems Specialist
│   ├── qa-architect.md                   # Full-Stack Vitest & Go Test Verification Specialist
│   ├── docs-keeper.md                    # Specifications, Roadmaps, API Docs & Changelog Specialist
│   └── code-reviewer.md                  # Pre-Commit Critic, Security & Diff Auditor
└── skills/                               # 9 Universal Skills with Executable Scripts & References
    ├── workforce-orchestrator/           # Hybrid orchestrator & subagent handoff contracts
    ├── feature-discovery/                # Pre-code capability scanner & user interview gate
    ├── project-onboarding-auditor/       # Stack scanner, rule sync & relative AGENTS.md generator
    ├── ui-design-system/                 # Token auditor, Playground-first workflow & UI rubric
    ├── fullstack-feature-scaffolder/     # End-to-end Backend + Plugin + UI + Test synchronizer
    ├── test-architect/                   # Coverage gap scanner & Vitest/Go test templates
    ├── spec-and-docs-keeper/             # Doc/version drift checker & API/Changelog blueprints
    ├── pre-commit-audit/                 # Working tree & git diff quality gate before commit
    └── kit-evolver/                      # Self-improving router for adding rules/checks from any repo
```
