#!/usr/bin/env bash
set -e

ROOT_DIR="${1:-$(pwd)}"
cd "$ROOT_DIR"

echo "=== 🔍 Agent-Kit Stack & Workspace Detector ==="
echo "Workspace: $ROOT_DIR"
echo ""

echo "--- 1. Detected Stack & Manifests ---"
[ -f "package.json" ] && echo "  [x] Node / JS / TS (package.json)"
[ -f "tsconfig.json" ] && echo "  [x] TypeScript (tsconfig.json)"
if [ -f "package.json" ]; then
  grep -q '"next"' package.json && echo "  [x] Next.js" || true
  grep -q '"react"' package.json && echo "  [x] React" || true
  grep -q '"tailwindcss"' package.json && echo "  [x] Tailwind CSS" || true
  grep -q '"vitest"' package.json && echo "  [x] Vitest" || true
  grep -q '"@libsql/client"' package.json && echo "  [x] @libsql/client (SQLite)" || true
  grep -qE '"(drizzle-orm|prisma|@prisma/client)"' package.json && echo "  [x] ORM (Drizzle / Prisma)" || true
fi
if [ -f "go.mod" ] || [ -f "src/daemon/go.mod" ]; then
  echo "  [x] Go Backend (go.mod)"
fi
[ -f "Dockerfile" ] || [ -f "docker-compose.yml" ] && echo "  [x] Docker (Dockerfile / docker-compose.yml)" || true
[ -d ".github/workflows" ] && echo "  [x] GitHub Actions CI (.github/workflows)" || true

echo ""
echo "--- 2. Detected UI Playgrounds & Token Files ---"
find . -maxdepth 4 -not -path '*/.*' -not -path './node_modules*' -not -path './out*' -not -path './dist*' \
  \( -path "*kitchen*" -o -path "*stories*" -o -path "*playground*" -o -name "globals.css" -o -name "tailwind.config.*" \) 2>/dev/null | sed 's/^/  - /'

echo ""
echo "--- 3. Existing AGENTS.md / GEMINI.md Rules ---"
find . -maxdepth 4 -not -path './node_modules*' -not -path './out*' \
  \( -name "AGENTS.md" -o -name "GEMINI.md" \) 2>/dev/null | sed 's/^/  - /'

echo ""
echo "--- 4. Recommended Relative Rule Includes (from .agents/AGENTS.md) ---"
[ -f "tsconfig.json" ] && echo "  - @[TypeScript Strict](./rules-library/typescript-strict.md)"
if [ -f "package.json" ] && grep -q '"react"' package.json; then
  echo "  - @[React & Next.js Standards](./rules-library/react-nextjs.md)"
  echo "  - @[UI Playground First](./rules-library/ui-playground-first.md)"
fi
if [ -f "package.json" ] && grep -q '"vitest"' package.json; then
  echo "  - @[Vitest Verification](./rules-library/vitest-testing.md)"
fi
if [ -f "go.mod" ] || [ -f "src/daemon/go.mod" ]; then
  echo "  - @[Go Daemon Standards](./rules-library/go-daemon.md)"
fi
echo "  - @[Database & ORM Standards](./rules-library/database-orm.md)"
if [ -f "Dockerfile" ] || [ -d ".github/workflows" ]; then
  echo "  - @[Docker & CI Standards](./rules-library/docker-ci.md)"
fi
