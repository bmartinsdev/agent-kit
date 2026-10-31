# Scoped `AGENTS.md` Templates (100% Portable Relative Paths)

Always use **repository-relative paths** inside committed `AGENTS.md` files—never hardcode user home directories (`/home/...` or `/Users/...`).

---

## 1. Root `.agents/AGENTS.md` Template

```markdown
# <Project Name> — Architecture & Agent Context Map

<1–2 sentence overview of the project and how its layers fit together.>

---

## 🗺️ Repository Structure & Key Paths

- **Frontend Application (`src/app/`)**: <Framework>. Scoped frontend rules live in [`src/app/AGENTS.md`](../src/app/AGENTS.md).
- **UI Playground (`src/app/kitchen/page.tsx`)**: Interactive component workbench. All UI components are built and validated here first.
- **Design Tokens (`src/app/globals.css`)**: <Palette & aesthetic summary>.
- **Backend / API (`src/daemon/`)**: <Stack, DB, and port>. Scoped backend rules live in [`src/daemon/AGENTS.md`](../src/daemon/AGENTS.md).
- **Planning & Specs (`tasks/` & `roadmap.md`)**: Tracked in [`tasks/README.md`](../tasks/README.md).
- **Release History (`CHANGELOG.md`)**: Versioned changelog.

---

## 🔗 Conditional Rules (Synced via `agent-kit`)

@[TypeScript Strict](./rules-library/typescript-strict.md)
@[Vitest Verification](./rules-library/vitest-testing.md)
@[Docker & CI Standards](./rules-library/docker-ci.md)
```

---

## 2. Frontend Directory `AGENTS.md` Template (e.g., `src/app/AGENTS.md`)

```markdown
# <Project Name> Frontend & UI Playground Rules

These rules apply whenever reading, creating, or modifying frontend code inside this directory.

## 🎨 UI & Design System Context

- **Component Playground**: [`src/app/kitchen/page.tsx`](./kitchen/page.tsx)
- **Reusable Primitives**: `src/app/components/`
- **Visual Identity & Tokens ([`src/app/globals.css`](./globals.css))**:
  - Light / Dark surface, primary, secondary, and border tokens.

## 🔗 Conditional Rules (Synced via `agent-kit`)

@[TypeScript Strict](../../.agents/rules-library/typescript-strict.md)
@[React & Next.js Standards](../../.agents/rules-library/react-nextjs.md)
@[UI Playground First](../../.agents/rules-library/ui-playground-first.md)
@[Vitest Verification](../../.agents/rules-library/vitest-testing.md)
```

---

## 3. Backend Directory `AGENTS.md` Template (e.g., `src/daemon/AGENTS.md`)

```markdown
# <Project Name> Backend & Database Rules

These rules apply whenever reading, creating, or modifying backend or database code inside this directory.

## ⚙️ Project Backend Specifics

- **Version Bump Targets**: <List relative paths that must be bumped together + CHANGELOG.md>
- **Database Layer**: <Driver/ORM and test isolation instructions>
- **Service Quirks**: <Any auth or integration invariants>

## 🔗 Conditional Rules (Synced via `agent-kit`)

@[Go Daemon Standards](../../.agents/rules-library/go-daemon.md)
@[Database & ORM Standards](../../.agents/rules-library/database-orm.md)
```
