#!/bin/bash
# retrieval_self_test.sh - validates memory retrieval capabilities
# Inspired by Claude Opus 4.7's approach
# Usage: bash scripts/retrieval_self_test.sh

set -uo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"

PASS=0
FAIL=0
RESULTS=()

run_test() {
  local tool="$1" query="$2" expect="$3" desc="$4"
  local out
  case "$tool" in
    retrieve) out=$(bash scripts/retrieve.sh "$query" 2>&1 || true) ;;
    cat)      out=$(cat "$query" 2>&1 || true) ;;
    grep)     out=$(grep -r "$query" . 2>&1 || true) ;;
  esac
  if echo "$out" | grep -qF "$expect"; then
    PASS=$((PASS+1))
    RESULTS+=("✓ PASS: [$tool] $desc")
  else
    FAIL=$((FAIL+1))
    RESULTS+=("✗ FAIL: [$tool] $desc — expected '$expect'")
  fi
}

echo "=== Claude Opus 4.5 Retrieval Self-Test ==="
echo

# === Core identity checks ===
run_test cat "identity/core.md" "claude-opus-4.5@agentvillage.org" "identity contains email"
run_test cat "identity/core.md" "ai-village-agents" "identity references GitHub org"

# === Principles/lessons retrieval ===
run_test cat "principles/core_principles.md" "Temporal" "principles mention temporal anchoring"
run_test cat "lessons/lessons_learned.md" "temporal" "lessons contain temporal anchoring insight"

# === Active project state ===
run_test cat "projects/memory_improvement.md" "ACTIVE" "memory project is active"
run_test cat "projects/youtube_channel.md" "COMPLETED" "youtube project is completed"

# === Procedural memory (scripts work) ===
run_test retrieve "session" "session_start" "retrieve finds session script"
run_test retrieve "identity" "core.md" "retrieve finds identity file"

# === Inventory validity ===
run_test cat "inventory.yaml" "items:" "inventory has items section"
run_test cat "inventory.yaml" "kind:" "inventory items have kind field"
run_test cat "inventory.yaml" "last_verified" "inventory has verification dates"

# === Session logs ===
run_test cat "logs/session_logs.md" "Session" "session logs exist"
run_test cat "logs/public_comms.md" "Day 419" "public comms tracked"

# === Architecture docs ===
run_test cat "memory_architecture.md" "TIER" "architecture describes tiers"
run_test cat "README.md" "claude-opus-memory" "README identifies repo"

# === Print results ===
echo
for r in "${RESULTS[@]}"; do echo "$r"; done
echo
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "PASS: $PASS | FAIL: $FAIL"
if [ "$FAIL" -gt 0 ]; then 
  echo "STATUS: Some tests failed"
  exit 1
else
  echo "STATUS: All tests passed ✓"
fi
