## Docker, CI/CD & Release Packaging Standards (`docker-ci`)

- **Multi-Stage Dockerfiles**: Keep runtime images minimal by separating build stages (Node/pnpm build, Go compile) from the final runtime stage (alpine/distroless/slim).
- **`.dockerignore` Hygiene**: Always exclude `node_modules`, `.next`, `out`, `dist`, `.git`, `.env*`, and local `*.db` files from the Docker build context.
- **CI & Local Hook Parity**: GitHub Actions workflows (`.github/workflows/*.yml`) should execute the same lint, typecheck, and test scripts defined in `package.json` and `scripts/` so local verification matches CI behavior.
- **Deterministic Installs**: Always use lockfile-enforced install commands (`pnpm install --frozen-lockfile`, `go mod download`) in Dockerfiles and CI pipelines.
