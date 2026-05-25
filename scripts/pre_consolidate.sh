#!/bin/bash
# pre_consolidate.sh - Health check before consolidation
# Run this before calling the consolidate function
# Usage: bash scripts/pre_consolidate.sh [--json]
# Supports shared-gate-library interface spec (JSON output with --json flag)

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
  echo "=== PRE-CONSOLIDATION CHECK ==="
  echo
fi

# 1. Repository health
check "git_clean" "Git repo is clean (no uncommitted changes)" "[ -z \"\$(git status --porcelain)\" ]"
check "on_main_branch" "On main branch" "[ \"\$(git branch --show-current)\" = 'main' ]"
check "remote_up_to_date" "Remote is up to date" "git fetch && [ -z \"\$(git rev-list HEAD..origin/main)\" ]"

# 2. YAML validity
check "inventory_yaml_valid" "inventory.yaml is valid YAML" "python3 -c \"import yaml; yaml.safe_load(open('inventory.yaml'))\""

# 3. Key files exist
check "readme_exists" "README.md exists" "[ -f README.md ]"
check "session_logs_exist" "Session logs exist" "[ -f logs/session_logs.md ]"
check "public_comms_tracked" "Public comms tracked" "[ -f logs/public_comms.md ]"

# 4. Retrieval self-test
if bash scripts/retrieval_self_test.sh > /dev/null 2>&1; then
  CHECKS["retrieval_self_test"]=true
  if [[ "$JSON_MODE" == "false" ]]; then
    echo "✓ Retrieval self-test passed"
  fi
  PASS=$((PASS+1))
else
  CHECKS["retrieval_self_test"]=false
  if [[ "$JSON_MODE" == "false" ]]; then
    echo "✗ Retrieval self-test failed (run manually for details)"
  fi
  FAIL=$((FAIL+1))
fi

# Output results
if [[ "$JSON_MODE" == "true" ]]; then
  STATUS="PASS"
  if [[ $FAIL -gt 0 ]]; then
    STATUS="FAIL"
  fi
  
  # Build JSON output compatible with shared-gate-library interface
  cat << EOJSON
{
  "gate": "pre_consolidate",
  "status": "$STATUS",
  "checks": {
    "git_clean": ${CHECKS[git_clean]},
    "on_main_branch": ${CHECKS[on_main_branch]},
    "remote_up_to_date": ${CHECKS[remote_up_to_date]},
    "inventory_yaml_valid": ${CHECKS[inventory_yaml_valid]},
    "readme_exists": ${CHECKS[readme_exists]},
    "session_logs_exist": ${CHECKS[session_logs_exist]},
    "public_comms_tracked": ${CHECKS[public_comms_tracked]},
    "retrieval_self_test": ${CHECKS[retrieval_self_test]}
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
    echo "⚠️  CONSOLIDATION NOT RECOMMENDED - fix failures first"
    exit 1
  else
    echo "✅ READY TO CONSOLIDATE"
    exit 0
  fi
fi
