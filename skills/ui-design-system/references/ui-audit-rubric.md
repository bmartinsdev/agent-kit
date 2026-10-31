# UI Design System & Playground Audit Rubric

Use this rubric before and after building or redesigning any UI component or screen.

---

## 1. Semantic Token Checklist (`globals.css` / Theme Variables)

Never hardcode raw palette hex codes in application components. Map every surface and element to semantic tokens:

| UI Element Role | Semantic Token / Utility | Notes |
| :--- | :--- | :--- |
| Page Canvas | `bg-background text-foreground` | Must switch cleanly between Light & Dark themes |
| Elevated Card / Panel | `bg-card text-card-foreground` | Pair with structural border token |
| Primary CTA / Accent | `bg-primary text-primary-foreground hover:bg-primary-hover` | High-contrast action focal point |
| Secondary / Info | `bg-secondary text-secondary-foreground` | Supporting badges, active tabs, secondary actions |
| Muted / Metadata Text | `text-muted-foreground` | Timestamps, subtitles, helper hints |
| Danger / Destructive | `bg-destructive text-white` / `text-destructive` | Delete actions, error banners |
| Heavy Tactile Border | `border-border-heavy` | Neo-brutalist / RetroUI structural framing & offset shadows |

---

## 2. Interactive States Matrix (Must Be Showcased in Playground)

Every interactive component or screen section must handle all 5 states gracefully:
1. **Default / Idle State**: Clean visual hierarchy, scannable typography (`font-head` for headings, `font-sans` for body, `font-mono` for metrics/badges/ports).
2. **Loading / Skeleton State**: Structured shimmer/skeleton placeholders or `Loader2` spinners on action buttons (disabling duplicate clicks).
3. **Empty State**: Helpful illustration/icon, clear explanation, and a primary CTA to resolve the empty state (e.g., "No active downloads — Search media to start").
4. **Error / Diagnostic State**: Actionable error message explaining *why* it failed and *how* to fix it, never a raw stack trace or silent failure.
5. **Success / Feedback State**: Immediate visual confirmation (Toast notification, checkmark badge, or optimistic state transition).

---

## 3. Responsive & Ergonomic Guardrails

- **Mobile Viewport (`< 640px`)**:
  - Avoid fixed multi-column grids without `grid-cols-1 sm:grid-cols-2 lg:grid-cols-...`.
  - Ensure modals and drawers scroll vertically (`overflow-y-auto max-h-[90vh]`) and never clip action buttons off-screen.
  - Keep touch targets at least `36px–44px` tall.
- **Keyboard & Focus**:
  - Modals must support Escape / backdrop close and clear focus rings (`focus-visible:ring-ring`).
