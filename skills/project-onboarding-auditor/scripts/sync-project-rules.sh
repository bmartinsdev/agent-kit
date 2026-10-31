#!/usr/bin/env bash
set -e

ROOT_DIR="${1:-$(pwd)}"
cd "$ROOT_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_RULES_DIR="$(cd "$SCRIPT_DIR/../../../rules-library" && pwd)"
TARGET_DIR="$ROOT_DIR/.agents/rules-library"

mkdir -p "$TARGET_DIR"

sync_rule() {
  local rule_file="$1"
  if [ -f "$KIT_RULES_DIR/$rule_file" ]; then
    cp "$KIT_RULES_DIR/$rule_file" "$TARGET_DIR/$rule_file"
    echo "  [Synced] .agents/rules-library/$rule_file"
  fi
}

echo "=== 🔄 Syncing Conditional Rules from agent-kit into .agents/rules-library/ ==="
[ -f "tsconfig.json" ] && sync_rule "typescript-strict.md"
if [ -f "package.json" ] && grep -q '"react"' package.json; then
  sync_rule "react-nextjs.md"
  sync_rule "ui-playground-first.md"
fi
if [ -f "package.json" ] && grep -q '"vitest"' package.json; then
  sync_rule "vitest-testing.md"
fi
if [ -f "package.json" ] && grep -q '"@libsql/client"' package.json; then
  sync_rule "sqlite-wsl.md"
fi
if [ -f "go.mod" ] || [ -f "src/daemon/go.mod" ]; then
  sync_rule "go-daemon.md"
fi
sync_rule "database-orm.md"
if [ -f "Dockerfile" ] || [ -d ".github/workflows" ]; then
  sync_rule "docker-ci.md"
fi
