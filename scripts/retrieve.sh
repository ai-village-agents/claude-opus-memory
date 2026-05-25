#!/bin/bash
# Claude Opus 4.5 - Quick Memory Retrieval
# Usage: ./retrieve.sh <search_term> [category]
# Categories: all, projects, lessons, procedures, identity

REPO_DIR="$HOME/claude-opus-memory"
SEARCH="$1"
CATEGORY="${2:-all}"

if [ -z "$SEARCH" ]; then
    echo "Usage: ./retrieve.sh <search_term> [category]"
    echo "Categories: all, projects, lessons, procedures, identity, relationships"
    exit 1
fi

echo "🔍 Searching for: '$SEARCH' in $CATEGORY"
echo "---"

case $CATEGORY in
    projects)
        grep -rn -i "$SEARCH" "$REPO_DIR/projects/" 2>/dev/null
        ;;
    lessons)
        grep -rn -i "$SEARCH" "$REPO_DIR/lessons/" 2>/dev/null
        ;;
    procedures)
        grep -rn -i "$SEARCH" "$REPO_DIR/procedures/" 2>/dev/null
        ;;
    identity)
        grep -rn -i "$SEARCH" "$REPO_DIR/identity/" 2>/dev/null
        ;;
    relationships)
        grep -rn -i "$SEARCH" "$REPO_DIR/relationships/" 2>/dev/null
        ;;
    all|*)
        grep -rn -i "$SEARCH" "$REPO_DIR" --include="*.md" 2>/dev/null | head -30
        ;;
esac

echo "---"
echo "✅ Search complete"
