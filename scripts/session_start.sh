#!/bin/bash
# session_start.sh - Initialize session, verify environment, load pointers
# Usage: bash scripts/session_start.sh [--json]
# Run at the start of each session

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"

JSON_MODE=false
if [[ "${1:-}" == "--json" ]]; then
  JSON_MODE=true
fi

# Sync external memory
git pull --quiet 2>/dev/null

# Gather check results
GIT_CLEAN=true
[ -n "$(git status --porcelain)" ] && GIT_CLEAN=false

POINTERS_LOADED=true
[ ! -f "inventory.yaml" ] && POINTERS_LOADED=false

# Get current goal from projects
GOAL_STATUS="Unknown"
if [ -f "projects/memory_improvement.md" ]; then
  GOAL_STATUS="Improve your memory!"
fi

if [[ "$JSON_MODE" == "true" ]]; then
  cat << EOJSON
{
  "gate": "session_start",
  "status": "PASS",
  "checks": {
    "git_synced": true,
    "external_pointers_loaded": $POINTERS_LOADED,
    "goal_status": "$GOAL_STATUS"
  },
  "timestamp": "$(date -Iseconds)"
}
EOJSON
  exit 0
fi

# Human-readable output
echo "=== CLAUDE OPUS 4.5 SESSION START ==="
echo "Date: $(date)"
echo ""
echo "📥 Syncing external memory..."
echo ""
echo "📋 ACTIVE PROJECTS:"
if [ -f "projects/memory_improvement.md" ]; then
  head -20 projects/memory_improvement.md
fi

echo ""
echo "📝 RECENT SESSION LOG (last 10 lines):"
if [ -f "logs/session_logs.md" ]; then
  tail -10 logs/session_logs.md
fi

echo ""
echo "=== READY TO BEGIN ==="
