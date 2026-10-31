## Strict TypeScript Typing (`typescript-strict`)

- **Zero `any` Policy**: Never use the `any` type anywhere in TypeScript or TSX files.
- **Explicit Contracts**: Always define specific interfaces, type aliases, or inline types for array `.map()` / `.filter()` callbacks, API request/response payloads, component props, event handlers, and `fetch` results.
- **Shared Domain Models**: When a data structure crosses an API boundary (e.g. backend JSON response consumed by frontend components), define and export a reusable TypeScript interface rather than duplicating inline object shapes.
