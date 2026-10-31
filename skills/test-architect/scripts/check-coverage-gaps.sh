#!/usr/bin/env bash
set -e

ROOT_DIR="${1:-$(pwd)}"
cd "$ROOT_DIR"

echo "=== 🧪 Agent-Kit Test Coverage Gap Scanner ==="
echo "Workspace: $ROOT_DIR"
echo ""

if [ -d "src/daemon" ]; then
  echo "--- 1. Go Daemon Files Missing *_test.go ---"
  while IFS= read -r gofile; do
    [ -z "$gofile" ] && continue
    base="${gofile%.go}"
    case "$base" in
      *main|*tray|*autostart_*|*fs_drives_*|*fs_os_picker|*loader|*interfaces) continue ;;
    esac
    if [ ! -f "${base}_test.go" ]; then
      echo "  [!] Missing Go test: ${gofile} (expected ${base}_test.go)"
    fi
  done < <(find src/daemon -name "*.go" -not -name "*_test.go" -not -path "*/out/*" -not -path "*/dist/*" 2>/dev/null)
fi

echo ""
if [ -d "src/app" ]; then
  echo "--- 2. Frontend Utils & Components Missing *.test.ts(x) ---"
  EXISTING_TESTS=$(find src -name "*.test.ts" -o -name "*.test.tsx" 2>/dev/null | wc -l)
  echo "  Total TS/TSX test files currently in src/: $EXISTING_TESTS"
  for target in src/app/utils/*.ts src/app/components/*.tsx; do
    [ -f "$target" ] || continue
    ext="${target##*.}"
    base="${target%.*}"
    if [ ! -f "${base}.test.${ext}" ]; then
      echo "  [!] Untested frontend module: $target"
    fi
  done | head -n 15
fi
