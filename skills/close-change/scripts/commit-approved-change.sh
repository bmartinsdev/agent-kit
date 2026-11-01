#!/usr/bin/env bash
set -e

TITLE="${1:-}"
BODY="${2:-}"

if [ -z "$TITLE" ]; then
  echo "[!] Error: Commit title is required."
  echo "    Usage: commit-approved-change.sh \"<type(scope): summary>\" \"[optional body]\""
  exit 1
fi

WORKSPACE_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$WORKSPACE_ROOT"

echo "=== 🏁 Agent-Kit Close-Change Commit Runner ==="
echo "Workspace: $WORKSPACE_ROOT"

if [ -z "$(git status --porcelain)" ]; then
  echo "[i] Working tree is already clean. Nothing to commit."
  exit 0
fi

echo "1. Staging approved working tree changes..."
git add -A

echo "2. Creating commit (running repository pre-commit hooks)..."
if [ -n "$BODY" ]; then
  git commit -m "$TITLE" -m "$BODY"
else
  git commit -m "$TITLE"
fi

echo "3. Commit created successfully:"
git log -n 1 --stat

