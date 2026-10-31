# Full-Stack Feature & Plugin Synchronization Checklist

Before marking any multi-layer feature or plugin complete, verify all 7 touchpoints:

## 1. API & Type Contract
- [ ] Request query/body fields and HTTP status codes are explicitly defined.
- [ ] Shared TypeScript interfaces match the exact JSON serialization names (`camelCase` / `snake_case`) returned by the backend.
- [ ] Zero `any` types in frontend or backend boundary handlers.

## 2. Backend & Persistence Layer
- [ ] Database schema / settings keys initialized cleanly.
- [ ] Service integration (`src/daemon/integrations/`) separates transport from business logic.
- [ ] HTTP handler (`src/daemon/*_handlers.go`) validates methods/inputs and is registered in `main.go`.
- [ ] Unit test (`*_test.go`) verifies happy path + error responses using an isolated temporary DB.

## 3. Plugin Layer (If Building/Updating a Plugin)
- [ ] `src/plugins/<id>/plugin.json` manifest exists with valid `id`, `name`, `version`, `type`, and `entry`.
- [ ] Go plugin struct implements `BasePlugin` + domain interface (`IndexerPlugin`, `TorrentClientPlugin`, `MediaServerPlugin`, `MetadataPlugin`, `TunnelPlugin`) and is registered in `InitPlugins()`.
- [ ] React settings UI (`src/plugins/<id>/ui/`) is registered in `pluginComponentRegistry`.

## 4. UI Playground & Application Layer
- [ ] Reusable component is showcased in the UI Playground (`src/app/kitchen/page.tsx`) with Default, Loading, Empty, and Error states.
- [ ] Component uses semantic CSS tokens (`globals.css`) and works in both Light and Dark themes.
- [ ] Application page wires the component to the backend route cleanly without synchronous `setState` in `useEffect`.

## 5. Closeout & Release Sync
- [ ] Frontend Vitest suite (`*.test.ts(x)`) added or updated.
- [ ] Daemon version bumped in `package.json`, `src/daemon/main.go`, and `CHANGELOG.md` (if Go daemon code changed).
- [ ] Task status updated in `tasks/` and `docs/api.md`.
