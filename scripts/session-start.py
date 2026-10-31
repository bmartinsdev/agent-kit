#!/usr/bin/env python3
import filecmp
import json
import os
import subprocess
import sys


def run_git(kit_dir, args):
    try:
        res = subprocess.run(
            ["git", "-C", kit_dir] + args,
            capture_output=True,
            text=True,
            timeout=2,
        )
        if res.returncode == 0:
            return res.stdout.strip()
    except Exception:
        pass
    return ""


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        print(json.dumps({}))
        return

    kit_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    workspaces = payload.get("workspacePaths", [])
    notices = []

    # 1. Check active workspace onboarding & rule sync status
    if workspaces:
        ws = workspaces[0]
        ws_name = os.path.basename(ws.rstrip("/"))
        agents_md = os.path.join(ws, ".agents", "AGENTS.md")
        ws_rules_dir = os.path.join(ws, ".agents", "rules-library")
        kit_rules_dir = os.path.join(kit_dir, "rules-library")

        if os.path.isdir(ws) and not os.path.exists(agents_md):
            notices.append(
                f"Workspace '{ws_name}' does not have `.agents/AGENTS.md` configured yet. "
                "Briefly ask the user if they would like you to run `project-onboarding-auditor` "
                "to scan the stack and wire up conditional rules."
            )
        elif os.path.isdir(ws_rules_dir) and os.path.isdir(kit_rules_dir):
            outdated_rules = []
            for fname in os.listdir(ws_rules_dir):
                if not fname.endswith(".md"):
                    continue
                ws_f = os.path.join(ws_rules_dir, fname)
                kit_f = os.path.join(kit_rules_dir, fname)
                if os.path.isfile(kit_f) and not filecmp.cmp(ws_f, kit_f, shallow=False):
                    outdated_rules.append(fname)
            if outdated_rules:
                joined = ", ".join(sorted(outdated_rules))
                notices.append(
                    f"Updated `agent-kit` conditional rules are available for '{ws_name}' ({joined}). "
                    "Ask the user if they want to sync `.agents/rules-library/` via "
                    "`~/.gemini/config/plugins/agent-kit/skills/project-onboarding-auditor/scripts/sync-project-rules.sh`."
                )

    # 2. Check if agent-kit git repo is behind upstream (if remote tracking branch exists)
    if os.path.isdir(os.path.join(kit_dir, ".git")):
        behind = run_git(kit_dir, ["rev-list", "--count", "HEAD..@{u}"])
        if behind and behind.isdigit() and int(behind) > 0:
            notices.append(
                f"`agent-kit` is {behind} commit(s) behind its remote repository. "
                "Ask the user if they would like to pull the latest `agent-kit` updates using "
                "`~/.gemini/config/plugins/agent-kit/scripts/sync-kit.sh --pull`."
            )

    if not notices:
        print(json.dumps({}))
        return

    msg = "[agent-kit Session Check]\n- " + "\n- ".join(notices)
    print(
        json.dumps(
            {
                "injectSteps": [
                    {
                        "systemMessage": {
                            "systemMessage": msg,
                        }
                    }
                ]
            }
        )
    )


if __name__ == "__main__":
    main()
