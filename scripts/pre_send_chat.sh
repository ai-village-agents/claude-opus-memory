#!/bin/bash
# pre_send_chat.sh - Gate before sending chat messages
# Checks for duplicates against public_comms.md log
# Usage: bash scripts/pre_send_chat.sh "message text" [--json]

set -uo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
PUBLIC_COMMS="$REPO/logs/public_comms.md"

MESSAGE="${1:-}"
JSON_MODE=false
if [[ "${2:-}" == "--json" ]]; then
  JSON_MODE=true
fi

if [[ -z "$MESSAGE" ]]; then
  echo "Usage: pre_send_chat.sh 'message text' [--json]"
  exit 1
fi

# Initialize check results
DUPLICATE=false
LENGTH_VALID=true
TOO_SHORT=false
TOO_LONG=false

# Check message length
MSG_LEN=${#MESSAGE}
if [[ $MSG_LEN -lt 10 ]]; then
  TOO_SHORT=true
  LENGTH_VALID=false
fi
if [[ $MSG_LEN -gt 500 ]]; then
  TOO_LONG=true
fi

# Check for duplicates - require 30+ char match for meaningful duplicate detection
if [[ -f "$PUBLIC_COMMS" ]] && [[ $MSG_LEN -ge 30 ]]; then
  # Extract first 30 chars of message for matching (meaningful snippet)
  MSG_SNIPPET=$(echo "$MESSAGE" | head -c 30 | tr -d '\n')
  if grep -qF "$MSG_SNIPPET" "$PUBLIC_COMMS" 2>/dev/null; then
    DUPLICATE=true
  fi
fi

# Determine overall status
STATUS="PASS"
if [[ "$DUPLICATE" == "true" ]]; then
  STATUS="FAIL"
fi
if [[ "$TOO_SHORT" == "true" ]]; then
  STATUS="FAIL"
fi

# Output
if [[ "$JSON_MODE" == "true" ]]; then
  cat << EOJSON
{
  "gate": "pre_send_chat",
  "status": "$STATUS",
  "checks": {
    "duplicate_detected": $DUPLICATE,
    "message_length_valid": $LENGTH_VALID,
    "char_count": $MSG_LEN
  },
  "timestamp": "$(date -Iseconds)"
}
EOJSON
else
  echo "[PRE-SEND-CHAT GATE]"
  echo "------------------------------------------------"
  if [[ "$DUPLICATE" == "true" ]]; then
    echo "⚠️  DUPLICATE DETECTED - similar message already sent"
    echo "❌ BLOCKED - Do not send duplicate"
  else
    echo "✓ No duplicate found"
  fi
  
  if [[ "$TOO_SHORT" == "true" ]]; then
    echo "⚠️  Message too short (<10 chars)"
  elif [[ "$TOO_LONG" == "true" ]]; then
    echo "⚠️  Message long (>500 chars) - consider breaking up"
  else
    echo "✓ Length OK ($MSG_LEN chars)"
  fi
  
  if [[ "$STATUS" == "PASS" ]]; then
    echo "✅ CLEARED TO SEND"
    echo "Preview: ${MESSAGE:0:60}..."
  fi
fi

if [[ "$STATUS" == "FAIL" ]]; then
  exit 1
fi
exit 0
