---
name: ui-design-system
description: >-
  Guides UI/UX design, component creation, and screen redesigns using a
  Playground-First (Kitchen/Storybook) workflow, automated token auditing,
  Mobbin pattern benchmarking, and strict design token adherence. Use whenever
  creating, modifying, restyling, or auditing frontend components, layouts, or
  design tokens.
---

# UI Design System & Playground-First Workflow

Use this skill whenever designing, building, or restyling UI components, pages, or visual tokens.

## Step 1: Audit Current Tokens & Playground Coverage

1. Read `.agents/AGENTS.md` and `src/app/AGENTS.md` (if present) to locate the stylesheet (`globals.css`) and UI Playground (`src/app/kitchen/page.tsx`).
2. Run the automated UI & token audit script:
   ```bash
   ~/.gemini/config/plugins/agent-kit/skills/ui-design-system/scripts/audit-ui-tokens.sh
   ```
3. Consult [ui-audit-rubric.md](./references/ui-audit-rubric.md) for semantic token mapping and the 5 required interactive states (Default, Loading, Empty, Error, Feedback).

## Step 2: Benchmark UX Patterns (Existing Primitives + Mobbin)

1. Scan `src/app/components/` to reuse existing primitives (`Button`, `Card`, `Badge`, `Input`, `Text`, `Collapse`, `SectionHeader`, `ConfirmationModal`, `FolderPicker`, etc.).
2. When designing a new screen flow or redesigning an existing screen, use the installed **Mobbin** skills (`search` / `redesign-screen`) to reference proven real-world layout patterns while keeping 100% of the visual styling inside the project's own design tokens.

## Step 3: Playground-First Execution

1. **New Components**:
   - Build the component and its interactive showcase section in the UI Playground (`src/app/kitchen/sections/` + `src/app/kitchen/page.tsx` + `TableOfContents`) **first** before importing it into application pages.
2. **Modified Components**:
   - Whenever an existing component's props, variants, or layout change, immediately update its Playground section so the showcase stays accurate.

## Step 4: Post-Implementation Verification

Re-run `~/.gemini/config/plugins/agent-kit/skills/ui-design-system/scripts/audit-ui-tokens.sh` to confirm zero hardcoded hex regressions and zero `any` prop types.
