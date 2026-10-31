#!/usr/bin/env bash
set -e

ROOT_DIR="${1:-$(pwd)}"
cd "$ROOT_DIR"

echo "=== 🎨 Agent-Kit UI Token, Hook & Playground Auditor ==="
echo "Workspace: $ROOT_DIR"
echo ""

FRONTEND_DIR="src/app"
[ ! -d "$FRONTEND_DIR" ] && FRONTEND_DIR="src"

if [ ! -d "$FRONTEND_DIR" ]; then
  echo "No src/ or src/app/ directory found."
  exit 0
fi

echo "--- 1. Hardcoded Hex Colors in TSX/TS Files (Prefer CSS Tokens) ---"
HEX_MATCHES=$(grep -rnE '#[0-9a-fA-F]{6}\b' "$FRONTEND_DIR" --include="*.tsx" --include="*.ts" --exclude-dir="kitchen" 2>/dev/null || true)
if [ -n "$HEX_MATCHES" ]; then
  echo "$HEX_MATCHES" | head -n 20 | sed 's/^/  [!] /'
else
  echo "  [OK] Zero hardcoded 6-digit hex colors found outside playground."
fi

echo ""
echo "--- 2. Explicit 'any' Type Violations in TSX/TS Files ---"
ANY_MATCHES=$(grep -rnE ':\s*any\b|<any>|as\s+any\b' "$FRONTEND_DIR" --include="*.tsx" --include="*.ts" 2>/dev/null || true)
if [ -n "$ANY_MATCHES" ]; then
  echo "$ANY_MATCHES" | head -n 20 | sed 's/^/  [!] /'
else
  echo "  [OK] Zero explicit 'any' types found."
fi

echo ""
echo "--- 3. Component Library vs. Kitchen Playground Coverage ---"
if [ -d "src/app/components" ] && [ -d "src/app/kitchen" ]; then
  for comp in src/app/components/*.tsx; do
    [ -f "$comp" ] || continue
    base=$(basename "$comp" .tsx)
    # Skip providers/wrappers that aren't visual primitives
    case "$base" in
      ThemeProvider|SocketProvider) continue ;;
    esac
    if ! grep -rq "$base" src/app/kitchen/ 2>/dev/null; then
      echo "  [!] Component '$base' ($comp) is not referenced in src/app/kitchen/"
    fi
  done
else
  echo "  [i] Standard src/app/components + src/app/kitchen layout not detected."
fi
