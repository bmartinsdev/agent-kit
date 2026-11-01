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

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "[!] No 'origin' remote configured in $KIT_DIR yet."
  echo "    Add your GitHub remote first:"
  echo "    git -C ~/.gemini/config/plugins/agent-kit remote add origin https://github.com/bmartinsdev/agent-kit.git"
  exit 1
fi

# Verify every agent, skill, and rule module on disk is documented in README.md
MISSING_IN_README=()
for agent_file in agents/*.md; do
  [ -e "$agent_file" ] || continue
  agent_name="$(basename "$agent_file" .md)"
  if ! grep -q "$agent_name" README.md; then
    MISSING_IN_README+=("agent:$agent_name")
  fi
done
for skill_dir in skills/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name="$(basename "$skill_dir")"
  if ! grep -q "$skill_name" README.md; then
    MISSING_IN_README+=("skill:$skill_name")
  fi
done
for rule_file in rules-library/*.md; do
  [ -e "$rule_file" ] || continue
  rule_name="$(basename "$rule_file" .md)"
  if ! grep -q "$rule_name" README.md; then
    MISSING_IN_README+=("rule:$rule_name")
  fi
done

if [ "${#MISSING_IN_README[@]}" -gt 0 ]; then
  echo "[!] Error: README.md is out of sync! The following items are missing from README.md:"
  for item in "${MISSING_IN_README[@]}"; do
    echo "    - $item"
  done
  echo "    Update README.md before running open-kit-pr.sh."
  exit 1
fi

DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# If we are already on an evolve/* branch, reuse it; otherwise create a new branch
if [[ "$CURRENT_BRANCH" == evolve/* ]]; then
  BRANCH_NAME="$CURRENT_BRANCH"
  echo "1. Reusing active evolution branch: $BRANCH_NAME"
else
  CLEAN_SLUG=$(echo "$SLUG" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
  TIMESTAMP=$(date +%Y%m%d-%H%M%S)
  BRANCH_NAME="evolve/${CLEAN_SLUG}-${TIMESTAMP}"
  echo "1. Creating branch: $BRANCH_NAME"
  git checkout -b "$BRANCH_NAME"
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "2. Staging & committing changes in agent-kit..."
  git add -A
  git commit -m "$TITLE"
else
  echo "2. Working tree clean on $BRANCH_NAME; proceeding to push unpushed commits..."
fi

echo "3. Pushing branch to origin..."
git -c credential.helper='!gh auth git-credential' push -u origin "$BRANCH_NAME"

echo "4. Opening or updating GitHub Pull Request..."
if command -v gh >/dev/null 2>&1; then
  EXISTING_PR=$(gh pr list --head "$BRANCH_NAME" --json url --jq '.[0].url' 2>/dev/null || true)
  if [ -n "$EXISTING_PR" ]; then
    gh pr edit "$EXISTING_PR" --title "$TITLE" --body "$BODY" >/dev/null 2>&1 || true
    echo "✅ Pull Request updated: $EXISTING_PR"
  else
    PR_URL=$(gh pr create --base "$DEFAULT_BRANCH" --head "$BRANCH_NAME" --title "$TITLE" --body "$BODY")
    echo "✅ Pull Request created: $PR_URL"
  fi
else
  REMOTE_URL=$(git remote get-url origin | sed -E 's/\.git$//')
  echo "✅ Branch pushed! Open PR at: ${REMOTE_URL}/compare/${DEFAULT_BRANCH}...${BRANCH_NAME}?expand=1"
fi
