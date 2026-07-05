#!/bin/bash
# ============================================================
# Xiishopy ERP - Stop All Emulators & Cleanup
# ============================================================
# Kills all running Firebase emulator processes
# and clears temporary files.
# ============================================================

echo ""
echo "🛑 Xiishopy ERP - Stopping all emulators..."
echo ""

# Kill by PID file if exists
if [ -f /tmp/xiishopy-emulator.pid ]; then
    PID=$(cat /tmp/xiishopy-emulator.pid)
    echo "  Stopping emulator process (PID: $PID)..."
    kill "$PID" 2>/dev/null && echo "  ✅ Emulator stopped" || echo "  ⚠️  Process not found"
    rm -f /tmp/xiishopy-emulator.pid
fi

# Kill any remaining Java (Firebase emulator) processes
echo "  Checking for remaining Java processes..."
JAVA_PIDS=$(ps aux | grep '[F]irebase' | awk '{print $2}' 2>/dev/null || true)
if [ -n "$JAVA_PIDS" ]; then
    for PID in $JAVA_PIDS; do
        echo "  Killing Firebase emulator Java PID: $PID"
        kill -9 "$PID" 2>/dev/null || true
    done
fi

# Kill processes on all emulator ports
echo "  Cleaning up ports..."
PORTS=(4000 5000 5001 8080 8085 9099 9199 9299)
for PORT in "${PORTS[@]}"; do
    PID=$(lsof -ti:$PORT 2>/dev/null || true)
    if [ -n "$PID" ]; then
        echo "  Killing process on port $PORT (PID: $PID)"
        kill -9 "$PID" 2>/dev/null || true
    fi
done

# Clean up temp files
echo "  Cleaning temporary files..."
rm -f /tmp/xiishopy-emulators.log 2>/dev/null || true

echo ""
echo "✅ All emulators stopped. Goodbye!"
echo ""