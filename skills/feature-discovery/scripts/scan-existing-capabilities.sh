#!/usr/bin/env bash
set -e

ROOT_DIR="${1:-$(pwd)}"
cd "$ROOT_DIR"

echo "=== 🧭 Agent-Kit Existing Capabilities Scanner ==="
echo "Workspace: $ROOT_DIR"
echo ""

echo "--- 1. Existing Frontend Pages (src/app/**/page.tsx) ---"
find src/app -name "page.tsx" 2>/dev/null | sort | sed 's/^/  - /' || true

echo ""
echo "--- 2. Existing UI Components (src/app/components/) ---"
find src/app/components -maxdepth 2 -name "*.tsx" 2>/dev/null | sort | sed 's/^/  - /' || true

echo ""
echo "--- 3. Existing Backend API Routes ---"
if [ -f "src/daemon/main.go" ]; then
  grep -n 'mux.HandleFunc(' src/daemon/main.go | sed 's/^/  - /' || true
fi
find src/app/api -name "route.ts" 2>/dev/null | sort | sed 's/^/  - /' || true

echo ""
echo "--- 4. Existing Plugins (src/plugins/) ---"
find src/plugins -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sort | sed 's/^/  - /' || true

echo ""
echo "--- 5. Existing Task Specifications (tasks/) ---"
find tasks -name "*.md" -not -name "template.md" -not -name "README.md" 2>/dev/null | sort | sed 's/^/  - /' || true
