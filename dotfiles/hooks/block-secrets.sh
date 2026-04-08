#!/usr/bin/env bash
# block-secrets.sh — PreToolUse hook
# Blocks Claude from reading or writing secret/credential files.
# Input: JSON on stdin with tool_name and tool_input fields.

set -euo pipefail

INPUT=$(cat)

# Extract the relevant path or command string from tool input
PAYLOAD=$(echo "$INPUT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
ti = d.get('tool_input', {})
# Read/Write/Edit pass file_path; Bash passes command
print(ti.get('file_path', '') + ' ' + ti.get('command', ''))
" 2>/dev/null || echo "")

# Patterns to block
BLOCKED_PATTERNS=(
  '\.env$'
  '\.env\.'
  '\.env\.local'
  '\.secret$'
  '\.secrets$'
  'id_rsa'
  'id_ed25519'
  '\.aws/credentials'
  '\.ssh/'
  'keychain'
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$PAYLOAD" | grep -qiE "$pattern"; then
    echo "{\"decision\": \"block\", \"reason\": \"Access to secret file pattern '$pattern' is blocked by security policy.\"}"
    exit 0
  fi
done

exit 0
