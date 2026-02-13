#!/bin/bash

REQUESTS=${1:-100}
DELAY=${2:-0.1}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Generating Load on Demo Application"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "   Configuration:"
echo "   Requests: $REQUESTS"
echo "   Delay: ${DELAY}s"
echo ""
echo "   Press Ctrl+C to stop"
echo ""

SUCCESS=0
FAILED=0

for i in $(seq 1 $REQUESTS); do
    if curl -s -H "Host: demo.local" http://localhost:30521 > /dev/null 2>&1; then
        SUCCESS=$((SUCCESS + 1))
        echo "Request $i/$REQUESTS - Success"
    else
        FAILED=$((FAILED + 1))
        echo "Request $i/$REQUESTS - Failed"
    fi
    sleep $DELAY
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "          Load Test Results"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Total Requests: $REQUESTS"
echo "Successful: $SUCCESS"
echo "Failed: $FAILED"
echo "Success Rate: $(echo "scale=2; $SUCCESS * 100 / $REQUESTS" | bc)%"
echo ""
