#!/usr/bin/env python3
import json
import re
import sys

def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        print(json.dumps({"decision": "allow"}))
        return

    tool_call = payload.get("toolCall", {})
    args = tool_call.get("args", {})
    cmd = args.get("CommandLine", "")
    bypass = bool(args.get("BypassSandbox", False))

    # 1. Hard-block git commit, git push, git add
    git_write_pattern = r"(?:^|[;&|\n]\s*)\bgit\s+(commit|push|add)\b"
    if re.search(git_write_pattern, cmd):
        print(json.dumps({
            "decision": "deny",
            "reason": "Blocked by agent-kit safety guard: Never run git add, git commit, or git push. The user manages git staging and commits manually."
        }))
        return

    # 2. Hard-block ad-hoc CLI test scripts (e.g. tsx test-*.ts or node test-*.js)
    adhoc_test_pattern = r"\b(tsx|ts-node|node)\s+([./]*test-[a-zA-Z0-9_-]+\.(ts|js))\b"
    if re.search(adhoc_test_pattern, cmd):
        print(json.dumps({
            "decision": "deny",
            "reason": "Blocked by agent-kit safety guard: Do not run ad-hoc test-*.ts scripts. Consolidate verification into standard Vitest (*.test.ts) or Go (*_test.go) suites."
        }))
        return

    # 3. Preserve standard sandbox vs unsandboxed permission semantics
    if bypass:
        print(json.dumps({
            "decision": "ask",
            "reason": "Command requests execution outside the sandbox."
        }))
    else:
        print(json.dumps({"decision": "allow"}))

if __name__ == "__main__":
    main()
