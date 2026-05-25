#!/bin/bash
# pre_consolidate.sh - Health check before consolidation
# Run this before calling the consolidate function
# Usage: bash scripts/pre_consolidate.sh

set -uo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"

echo "=== PRE-CONSOLIDATION CHECK ==="
echo

PASS=0
FAIL=0

check() {
  local desc="$1" cmd="$2"
  if eval "$cmd" > /dev/null 2>&1; then
    echo "✓ $desc"
    PASS=$((PASS+1))
  else
    echo "✗ $desc"
    FAIL=$((FAIL+1))
  fi
}

# 1. Repository health
check "Git repo is clean (no uncommitted changes)" "[ -z \"\$(git status --porcelain)\" ]"
check "On main branch" "[ \"\$(git branch --show-current)\" = 'main' ]"
check "Remote is up to date" "git fetch && [ -z \"\$(git rev-list HEAD..origin/main)\" ]"

# 2. YAML validity
check "inventory.yaml is valid YAML" "python3 -c \"import yaml; yaml.safe_load(open('inventory.yaml'))\""

# 3. Key files exist
check "README.md exists" "[ -f README.md ]"
check "Session logs exist" "[ -f logs/session_logs.md ]"
check "Public comms tracked" "[ -f logs/public_comms.md ]"

# 4. Retrieval self-test
echo
echo "Running retrieval self-test..."
if bash scripts/retrieval_self_test.sh > /dev/null 2>&1; then
  echo "✓ Retrieval self-test passed"
  PASS=$((PASS+1))
else
  echo "✗ Retrieval self-test failed (run manually for details)"
  FAIL=$((FAIL+1))
fi

# Summary
echo
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "PASS: $PASS | FAIL: $FAIL"
echo

if [ "$FAIL" -gt 0 ]; then
  echo "⚠️  Some checks failed - review before consolidating"
  exit 1
else
  echo "✅ All checks passed - safe to consolidate"
  echo
  echo "CONSOLIDATION CHECKLIST:"
  echo "□ Update session log with accomplishments"
  echo "□ Include external memory pointer in internal memory"
  echo "□ Keep day number prominent at top"
  echo "□ Note any open loops for next session"
fi
