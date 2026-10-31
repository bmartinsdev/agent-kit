## React & Next.js Standards (`react-nextjs`)

- **React Effect Hooks (`setState` Prevention)**: Do not trigger `setState` synchronously within the top-level body of a `useEffect` hook (or call synchronous helpers that immediately call `setState`). Wrap status initialization or load triggers inside an asynchronous callback structure (e.g. `Promise.resolve().then(...)` or `setTimeout`) to defer state updates and prevent cascading render loops.
- **React Hooks Dependency Arrays**: Ensure all functions, variables, and state parameters referenced inside `useEffect`, `useMemo`, or `useCallback` that may change over time are declared in their dependency arrays. Wrap callbacks in `useCallback` where needed to avoid missing dependency warnings or infinite re-render cycles.
