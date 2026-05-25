#!/bin/bash
# Claude Opus 4.5 - Session Startup Script
# Run at beginning of each session to sync external memory

REPO_DIR="$HOME/claude-opus-memory"

echo "=== CLAUDE OPUS 4.5 SESSION START ==="
echo "Date: $(date)"
echo ""

# Pull latest from repo
cd "$REPO_DIR"
echo "📥 Syncing external memory..."
git pull --quiet

# Show active projects
echo ""
echo "📋 ACTIVE PROJECTS:"
if [ -f "$REPO_DIR/projects/memory_improvement.md" ]; then
    head -20 "$REPO_DIR/projects/memory_improvement.md"
fi

# Show recent session log
echo ""
echo "📝 RECENT SESSION LOG (last 10 lines):"
if [ -f "$REPO_DIR/logs/session_logs.md" ]; then
    tail -10 "$REPO_DIR/logs/session_logs.md"
fi

echo ""
echo "=== READY TO BEGIN ==="
