#!/usr/bin/env bash
set -e

ROOT_DIR="${1:-$(pwd)}"
cd "$ROOT_DIR"

echo "=== 📚 Agent-Kit Documentation, Version & Spec Drift Checker ==="
echo "Workspace: $ROOT_DIR"
echo ""

echo "--- 1. Version Synchronization Check ---"
PKG_VER="N/A"
GO_VER="N/A"
CL_VER="N/A"

if [ -f "package.json" ]; then
  PKG_VER=$(grep -m1 '"version"' package.json | sed -E 's/.*"version":\s*"([^"]+)".*/\1/')
fi
if [ -f "src/daemon/main.go" ]; then
  GO_VER=$(grep -A2 '\-\-version' src/daemon/main.go | grep 'Println' | sed -E 's/.*"([^"]+)".*/\1/' || echo "N/A")
fi
if [ -f "CHANGELOG.md" ]; then
  CL_VER=$(grep -m1 -E '^## \[?[0-9]+\.[0-9]+\.[0-9]+' CHANGELOG.md | sed -E 's/^## \[?([0-9]+\.[0-9]+\.[0-9]+).*/\1/' || echo "N/A")
fi

echo "  package.json version : $PKG_VER"
echo "  main.go --version    : $GO_VER"
echo "  CHANGELOG.md latest  : $CL_VER"

if [ "$PKG_VER" != "N/A" ] && [ "$GO_VER" != "N/A" ] && [ "$PKG_VER" != "$GO_VER" ]; then
  echo "  [!] DRIFT DETECTED: package.json ($PKG_VER) != main.go ($GO_VER)"
else
  echo "  [OK] package.json and main.go versions match."
fi

echo ""
echo "--- 2. Documentation Directory (docs/) Status ---"
if [ -d "docs" ]; then
  ls -la docs/
else
  echo "  [!] docs/ directory does not exist yet (expected architecture.md, api.md, plugins.md, getting-started.md)."
fi

echo ""
echo "--- 3. Daemon API Routes vs. docs/api.md ---"
if [ -f "src/daemon/main.go" ]; then
  ROUTE_COUNT=$(grep -c 'mux.HandleFunc("/api/' src/daemon/main.go || true)
  echo "  Registered /api/* routes in src/daemon/main.go: $ROUTE_COUNT"
  if [ -f "docs/api.md" ]; then
    for route in $(grep 'mux.HandleFunc("/api/' src/daemon/main.go | sed -E 's/.*"(\/api\/[^"]+)".*/\1/'); do
      if ! grep -Fq "$route" docs/api.md; then
        echo "  [!] Undocumented API route in docs/api.md: $route"
      fi
    done
  fi
fi
