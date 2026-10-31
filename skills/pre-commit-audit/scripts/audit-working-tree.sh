#!/usr/bin/env bash
set -e

ROOT_DIR="${1:-$(pwd)}"
cd "$ROOT_DIR"

echo "=== 🛡️ Agent-Kit Pre-Commit Working Tree Auditor ==="
echo "Workspace: $ROOT_DIR"
echo ""

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repository."
  exit 0
fi

echo "--- 1. Working Tree Status (git status --short) ---"
STATUS_OUT=$(git status --short)
if [ -z "$STATUS_OUT" ]; then
  echo "  Working tree is clean (no uncommitted changes)."
  exit 0
fi
echo "$STATUS_OUT" | sed 's/^/  /'

CHANGED_FILES=$(git status --porcelain | awk '{print $2}')

echo ""
echo "--- 2. Stray Artifacts & Untracked Temp Files Check ---"
STRAY=$(echo "$CHANGED_FILES" | grep -E '\.(db|db-shm|db-wal|log|tmp)$|(^|/)test-.*\.(ts|js)$' || true)
if [ -n "$STRAY" ]; then
  echo "$STRAY" | sed 's/^/  [BLOCKER] Stray/temp file in working tree: /'
else
  echo "  [OK] No stray .db, .log, or ad-hoc test-*.ts files."
fi

echo ""
echo "--- 3. Debug Logs & 'any' Types in Changed TS/TSX Files ---"
TS_CHANGED=$(echo "$CHANGED_FILES" | grep -E '\.(ts|tsx)$' || true)
if [ -n "$TS_CHANGED" ]; then
  for f in $TS_CHANGED; do
    [ -f "$f" ] || continue
    grep -nE ':\s*any\b|<any>|as\s+any\b' "$f" 2>/dev/null | sed "s|^|  [BLOCKER] 'any' in $f:|" || true
    grep -nE 'console\.log\(' "$f" 2>/dev/null | sed "s|^|  [WARNING] console.log in $f:|" || true
  done
else
  echo "  [i] No TS/TSX files modified."
fi

echo ""
echo "--- 4. Daemon Version & Changelog Sync Check ---"
GO_CHANGED=$(echo "$CHANGED_FILES" | grep -E '^src/daemon/.*\.go$' | grep -v '_test\.go$' || true)
if [ -n "$GO_CHANGED" ]; then
  echo "  Go daemon implementation files changed:"
  echo "$GO_CHANGED" | sed 's/^/    - /'
  if ! echo "$CHANGED_FILES" | grep -q '^CHANGELOG\.md$'; then
    echo "  [WARNING] Go daemon code changed, but CHANGELOG.md is not modified!"
  fi
  if ! echo "$CHANGED_FILES" | grep -q '^package\.json$'; then
    echo "  [WARNING] Go daemon code changed, but package.json version is not modified!"
  fi
else
  echo "  [OK] No non-test Go daemon files modified."
fi
