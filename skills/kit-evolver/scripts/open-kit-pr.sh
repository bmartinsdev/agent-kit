#!/usr/bin/env bash
set -e

SLUG="${1:-rule-update}"
TITLE="${2:-feat(kit): evolve agent-kit rules and skills}"
BODY="${3:-Automated improvement proposed by kit-evolver during a coding session.}"

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$KIT_DIR"

echo "=== 🚀 Agent-Kit Automated PR Opener ==="
echo "Kit Repository: $KIT_DIR"

if [ ! -d ".git" ]; then
  echo "[!] Error: $KIT_DIR is not a git repository."
  exit 1
fi

if [ -z "$(git status --porcelain)" ]; then
  echo "[i] No changes detected in $KIT_DIR to commit."
  exit 0
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "[!] No 'origin' remote configured in $KIT_DIR yet."
  echo "    Add your GitHub remote first:"
  echo "    git -C ~/.gemini/config/plugins/agent-kit remote add origin <https://github.com/you/agent-kit.git>"
  exit 1
fi

# Sanitize slug and build branch name
CLEAN_SLUG=$(echo "$SLUG" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BRANCH_NAME="evolve/${CLEAN_SLUG}-${TIMESTAMP}"

DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")

echo "1. Creating branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

echo "2. Staging & committing changes in agent-kit..."
git add -A
git commit -m "$TITLE"

echo "3. Pushing branch to origin..."
git push -u origin "$BRANCH_NAME"

echo "4. Opening GitHub Pull Request..."
if command -v gh >/dev/null 2>&1; then
  PR_URL=$(gh pr create --base "$DEFAULT_BRANCH" --head "$BRANCH_NAME" --title "$TITLE" --body "$BODY")
  echo "✅ Pull Request created: $PR_URL"
else
  REMOTE_URL=$(git remote get-url origin | sed -E 's/\.git$//')
  echo "✅ Branch pushed! Open PR at: ${REMOTE_URL}/compare/${DEFAULT_BRANCH}...${BRANCH_NAME}?expand=1"
fi
