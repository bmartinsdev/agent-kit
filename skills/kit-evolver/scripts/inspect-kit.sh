#!/usr/bin/env bash
set -e

KIT_DIR="~/.gemini/config/plugins/agent-kit"

echo "=== 🧠 Agent-Kit Inventory Inspector ==="
echo "Kit Path: $KIT_DIR"
echo ""

echo "--- 1. Global Rules (rules/) ---"
ls -1 "$KIT_DIR/rules/" | sed 's/^/  - rules\//'

echo ""
echo "--- 2. Conditional Rule Modules (rules-library/) ---"
for f in "$KIT_DIR"/rules-library/*.md; do
  [ -f "$f" ] || continue
  title=$(head -n 1 "$f" | sed 's/^#* *//')
  echo "  - rules-library/$(basename "$f") : $title"
done

echo ""
echo "--- 3. Specialist Agents (agents/) ---"
for f in "$KIT_DIR"/agents/*.md; do
  [ -f "$f" ] || continue
  echo "  - agents/$(basename "$f")"
done

echo ""
echo "--- 4. Universal Skills (skills/) ---"
for d in "$KIT_DIR"/skills/*/; do
  [ -d "$d" ] || continue
  echo "  - skills/$(basename "$d")/"
done
