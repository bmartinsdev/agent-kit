## UI Playground-First Workflow (`ui-playground-first`)

- **Check Existing Components First**: Always check the project's component directory and UI playground (such as `src/app/kitchen/page.tsx` or Storybook, as specified in the project's `AGENTS.md`) before writing custom UI layouts or one-off styled elements.
- **Playground Before Pages**: Always add any new reusable UI component to the UI playground first before importing or assembling it into application pages. If a needed component does not exist yet, ask the user if it should be added to the playground first.
- **Keep Playground Synchronized**: Whenever a component showcased in the playground undergoes prop, variant, or visual changes, update its playground section immediately so the showcase remains a live, accurate source of truth.
- **Token Fidelity**: Use semantic CSS variables and theme tokens defined in the project's stylesheet (e.g. `globals.css`) rather than hardcoded hex colors or arbitrary spacing values.
