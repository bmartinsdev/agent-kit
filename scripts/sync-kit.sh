#!/usr/bin/env bash
set -e

MODE="${1:---check}"
WORKSPACE_DIR="${2:-$(pwd)}"
KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== 🔄 Agent-Kit Update & Rule Synchronizer ==="
echo "Kit Location : $KIT_DIR"
echo "Workspace    : $WORKSPACE_DIR"
echo ""

if [ -d "$KIT_DIR/.git" ]; then
  if git -C "$KIT_DIR" remote get-url origin >/dev/null 2>&1; then
    echo "--- 1. Checking Remote Updates (origin) ---"
    git -C "$KIT_DIR" fetch origin --quiet || true
    BEHIND=$(git -C "$KIT_DIR" rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
    AHEAD=$(git -C "$KIT_DIR" rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
    echo "  Commits behind origin : $BEHIND"
    echo "  Commits ahead of origin: $AHEAD"

    if [ "$MODE" = "--pull" ] && [ "$BEHIND" -gt 0 ]; then
      echo "  Pulling latest agent-kit updates..."
      git -C "$KIT_DIR" pull --ff-only
      find "$KIT_DIR" \( -name "*.sh" -o -name "*.py" \) -exec chmod +x {} +
    fi
  else
    echo "--- 1. Remote Status ---"
    echo "  [i] No git remote 'origin' configured yet in $KIT_DIR."
    echo "      To link to GitHub, run: git -C ~/.gemini/config/plugins/agent-kit remote add origin https://github.com/bmartinsdev/agent-kit.git"
  fi

  echo ""
  echo "--- 2. Local Uncommitted Changes in agent-kit ---"
  DIRTY=$(git -C "$KIT_DIR" status --short)
  if [ -n "$DIRTY" ]; then
    echo "$DIRTY" | sed 's/^/  /'
  else
    echo "  [OK] Working tree is clean."
  fi
fi

echo ""
echo "--- 3. Workspace Conditional Rules Sync ---"
if [ -d "$WORKSPACE_DIR/.agents" ]; then
  "$KIT_DIR/skills/project-onboarding-auditor/scripts/sync-project-rules.sh" "$WORKSPACE_DIR"
else
  echo "  [!] Workspace $WORKSPACE_DIR has no .agents/ directory yet."
  echo "      Run: ~/.gemini/config/plugins/agent-kit/skills/project-onboarding-auditor/scripts/detect-stack.sh \"$WORKSPACE_DIR\""
fi
