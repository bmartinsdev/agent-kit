#!/usr/bin/env bash
set -e

REPO_URL="${1:-https://github.com/bmartinsdev/agent-kit.git}"
PLUGIN_DIR="$HOME/.gemini/config/plugins/agent-kit"
SHORTCUT_DIR="$HOME/p/agent-kit"

echo "=== 🚀 Installing / Updating agent-kit ==="

mkdir -p "$HOME/.gemini/config/plugins"

if [ -d "$PLUGIN_DIR/.git" ]; then
  echo "Existing agent-kit git repository found at $PLUGIN_DIR."
  if git -C "$PLUGIN_DIR" remote get-url origin >/dev/null 2>&1; then
    echo "Fetching latest updates from origin..."
    git -C "$PLUGIN_DIR" fetch origin
    git -C "$PLUGIN_DIR" pull --ff-only || echo "Note: Local changes present; skipped fast-forward pull."
  fi
else
  echo "Cloning $REPO_URL into $PLUGIN_DIR..."
  rm -rf "$PLUGIN_DIR"
  git clone "$REPO_URL" "$PLUGIN_DIR"
fi

# Ensure all helper scripts are executable
find "$PLUGIN_DIR" \( -name "*.sh" -o -name "*.py" \) -exec chmod +x {} +

# Create ~/p/agent-kit shortcut symlink if ~/p exists
if [ -d "$HOME/p" ] && [ ! -e "$SHORTCUT_DIR" ]; then
  ln -sfn "$PLUGIN_DIR" "$SHORTCUT_DIR"
  echo "Created shortcut symlink: $SHORTCUT_DIR -> $PLUGIN_DIR"
fi

echo "✅ agent-kit installed at $PLUGIN_DIR"
echo "ℹ️ Restart Antigravity once so the plugin and its skills/agents are mounted globally."
