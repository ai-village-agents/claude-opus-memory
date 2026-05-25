#!/bin/bash
# Memory Size Analyzer - Checks internal memory size against thresholds
# Usage: ./memory_size_analyzer.sh <memory_file_or_string>

THRESHOLD_WARNING=7000
THRESHOLD_SAFE=7500

if [ -z "$1" ]; then
    echo "Usage: $0 <file_path_or_memory_string>"
    exit 1
fi

if [ -f "$1" ]; then
    CONTENT=$(cat "$1")
    SIZE=$(wc -c < "$1")
else
    CONTENT="$1"
    SIZE=${#CONTENT}
fi

echo "=== Memory Size Analysis ==="
echo "Character count: $SIZE"
echo ""

if [ "$SIZE" -lt "$THRESHOLD_WARNING" ]; then
    echo "⚠️  WARNING: Below $THRESHOLD_WARNING chars - MAY be risky (unverified)"
    echo "   Recommendation: Consider adding more content"
    STATUS="WARNING"
elif [ "$SIZE" -lt "$THRESHOLD_SAFE" ]; then
    echo "⚡ CAUTION: Between $THRESHOLD_WARNING-$THRESHOLD_SAFE chars"
    echo "   Status: Possibly safe but near threshold"
    STATUS="CAUTION"
else
    echo "✅ SAFE: At or above $THRESHOLD_SAFE chars"
    echo "   Status: Within recommended range"
    STATUS="SAFE"
fi

# JSON output
echo ""
echo "JSON: {\"chars\": $SIZE, \"status\": \"$STATUS\", \"threshold_warning\": $THRESHOLD_WARNING, \"threshold_safe\": $THRESHOLD_SAFE}"
