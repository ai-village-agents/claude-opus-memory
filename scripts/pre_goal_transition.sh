#!/bin/bash
# pre_goal_transition.sh - Validates readiness before transitioning to a new goal
# Run when a new goal is announced (e.g., Day 420)
# Usage: bash scripts/pre_goal_transition.sh [--json]

set -uo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"

JSON_MODE=false
if [[ "${1:-}" == "--json" ]]; then
  JSON_MODE=true
fi

PASS=0
FAIL=0
declare -A CHECKS

check() {
  local key="$1" desc="$2" cmd="$3"
  if eval "$cmd" > /dev/null 2>&1; then
    CHECKS["$key"]=true
    if [[ "$JSON_MODE" == "false" ]]; then
      echo "✓ $desc"
    fi
    PASS=$((PASS+1))
  else
    CHECKS["$key"]=false
    if [[ "$JSON_MODE" == "false" ]]; then
      echo "✗ $desc"
    fi
    FAIL=$((FAIL+1))
  fi
}

if [[ "$JSON_MODE" == "false" ]]; then
  echo "=== PRE-GOAL-TRANSITION CHECK ==="
  echo
fi

# 1. Git state clean
check "git_clean" "Git repo is clean" "[ -z \"\$(git status --porcelain)\" ]"
check "git_pushed" "All commits pushed to remote" "git fetch && [ -z \"\$(git rev-list origin/main..HEAD)\" ]"

# 2. Current goal archived
check "projects_documented" "Active projects documented" "[ -f projects/memory_improvement.md ]"
check "session_logs_updated" "Session logs updated" "[ -f logs/session_logs.md ]"

# 3. External memory accessible
check "readme_exists" "README.md exists" "[ -f README.md ]"
check "inventory_valid" "Inventory is valid YAML" "python3 -c \"import yaml; yaml.safe_load(open('inventory.yaml'))\""

# 4. No critical open loops
check "public_comms_tracked" "Public comms tracked" "[ -f logs/public_comms.md ]"

# 5. Backup exists (at least recent commit)
RECENT_COMMIT=$(git log -1 --format="%H" 2>/dev/null || echo "")
if [[ -n "$RECENT_COMMIT" ]]; then
  CHECKS["backup_exists"]=true
  if [[ "$JSON_MODE" == "false" ]]; then
    echo "✓ Backup exists (commit: ${RECENT_COMMIT:0:7})"
  fi
  PASS=$((PASS+1))
else
  CHECKS["backup_exists"]=false
  if [[ "$JSON_MODE" == "false" ]]; then
    echo "✗ No backup (no commits found)"
  fi
  FAIL=$((FAIL+1))
fi

# Output results
if [[ "$JSON_MODE" == "true" ]]; then
  STATUS="PASS"
  if [[ $FAIL -gt 0 ]]; then
    STATUS="FAIL"
  fi
  
  cat << EOJSON
{
  "gate": "pre_goal_transition",
  "status": "$STATUS",
  "checks": {
    "git_clean": ${CHECKS[git_clean]},
    "git_pushed": ${CHECKS[git_pushed]},
    "projects_documented": ${CHECKS[projects_documented]},
    "session_logs_updated": ${CHECKS[session_logs_updated]},
    "readme_exists": ${CHECKS[readme_exists]},
    "inventory_valid": ${CHECKS[inventory_valid]},
    "public_comms_tracked": ${CHECKS[public_comms_tracked]},
    "backup_exists": ${CHECKS[backup_exists]}
  },
  "pass_count": $PASS,
  "fail_count": $FAIL,
  "timestamp": "$(date -Iseconds)"
}
EOJSON
  
  if [[ $FAIL -gt 0 ]]; then
    exit 1
  fi
  exit 0
else
  echo
  echo "=== SUMMARY: $PASS PASS, $FAIL FAIL ==="
  if [[ $FAIL -gt 0 ]]; then
    echo "⚠️  NOT READY FOR GOAL TRANSITION - fix failures first"
    exit 1
  else
    echo "✅ READY FOR NEW GOAL"
    exit 0
  fi
fi
