#!/bin/bash
# ============================================================
# Xiishopy ERP - Local Emulator Orchestration Launcher
# ============================================================
# Requirements: Java 21+ (check with: /usr/local/Cellar/openjdk@21/21.0.11/libexec/openjdk.jdk/Contents/Home/bin/java --version)
# ============================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# Set Java 21 path explicitly (Firebase emulator requires JDK 21+)
JAVA_HOME="/usr/local/Cellar/openjdk@21/21.0.11/libexec/openjdk.jdk/Contents/Home"
export JAVA_HOME
PATH="$JAVA_HOME/bin:$PATH"

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║        XIISHOPY ERP - EMULATOR ORCHESTRATOR         ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

echo "  Java version: $(java --version 2>&1 | head -1)"
echo ""

# Step 1: Kill background processes on required ports
echo "[1/7] 🧹 Clearing ports..."
PORTS=(4000 4400 4401 4500 4501 5000 5001 8080 8085 9099 9150 9199 9299)
for PORT in "${PORTS[@]}"; do
    PID=$(lsof -ti:$PORT 2>/dev/null || true)
    [ -n "$PID" ] && kill -9 "$PID" 2>/dev/null || true
done
echo "  ✅ Ports cleared"

# Step 2: Build TypeScript functions
echo ""
echo "[2/7] 🔧 Building TypeScript functions..."
cd "$PROJECT_DIR/functions"
npm run build 2>&1 | tail -3
cd "$PROJECT_DIR"
echo "  ✅ Functions built"

# Step 3: Clear previous cache for fresh seed
echo ""
echo "[3/7] 🗑️  Clearing emulator cache..."
rm -rf "$PROJECT_DIR/local_cache" 2>/dev/null || true
mkdir -p "$PROJECT_DIR/local_cache"
echo "  ✅ Cache cleared"

# Step 4: Start ALL emulators in background with EXPLICIT JAVA_HOME
echo ""
echo "[4/7] 🔥 Starting ALL Firebase Emulators..."
echo "  Services: Auth:9099, Functions:5001, Firestore:8080,"
echo "  Hosting:5000, PubSub:8085, Storage:9199, EventArc:9299"
echo ""
JAVA_HOME="$JAVA_HOME" firebase emulators:start \
    --import=./local_cache \
    --export-on-exit=./local_cache \
    > /tmp/xiishopy-emulators.log 2>&1 &
EMULATOR_PID=$!
echo "  Emulator PID: $EMULATOR_PID"
echo "  Logs: tail -f /tmp/xiishopy-emulators.log"

# Wait for Firestore (port 8080)
echo "  Waiting for Firestore (port 8080)..."
FIRESTORE_READY=false
for i in {1..30}; do
    if curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8080/ --connect-timeout 2 2>/dev/null | grep -q 200; then
        echo "  ✅ Firestore emulator ready (attempt $i)"
        FIRESTORE_READY=true
        break
    fi
    sleep 2
done

if [ "$FIRESTORE_READY" = false ]; then
    echo "  ⚠️  Firestore not reachable. Check logs:"
    tail -5 /tmp/xiishopy-emulators.log
fi

# Wait for Auth (port 9099)
echo "  Waiting for Auth (port 9099)..."
AUTH_READY=false
for i in {1..20}; do
    if lsof -ti:9099 2>/dev/null | grep -q .; then
        echo "  ✅ Auth emulator ready (PID $(lsof -ti:9099))"
        AUTH_READY=true
        break
    fi
    sleep 2
done

if [ "$AUTH_READY" = false ]; then
    echo "  ⚠️  Auth not reachable. Check logs."
    tail -5 /tmp/xiishopy-emulators.log
fi

# Step 5: Seed data from within functions/ directory
echo ""
echo "[5/7] 🌱 Seeding initial data..."
cd "$PROJECT_DIR/functions"
npx ts-node scripts/seed-firestore.ts 2>&1
SEED_EXIT=$?
cd "$PROJECT_DIR"

if [ $SEED_EXIT -ne 0 ]; then
    echo "  ⚠️  Seed encountered errors."
    echo "  Manual: cd functions && npx ts-node scripts/seed-firestore.ts"
else
    echo "  ✅ Data seeded successfully"
fi

# Step 6: Verify all services
echo ""
echo "[6/7] 🔍 Service verification..."
for SERVICE in "Firestore:8080" "Auth:9099" "EmulatorUI:4000"; do
    NAME="${SERVICE%%:*}"
    PORT="${SERVICE##*:}"
    if curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/" --connect-timeout 2 2>/dev/null | grep -qv '000'; then
        echo "  ✅ $NAME on $PORT — reachable"
    else
        echo "  ❌ $NAME on $PORT — NOT reachable"
    fi
done

# Step 7: Print status
echo ""
echo "[7/7] 🚀 Xiishopy ERP Environment Ready!"
echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║           XIISHOPY ERP - READY 🚀                   ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║  Emulator UI:  http://127.0.0.1:4000               ║"
echo "║  Functions:    http://127.0.0.1:5001               ║"
echo "║  Firestore:    http://127.0.0.1:8080               ║"
echo "║  Auth:         http://127.0.0.1:9099               ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║  Demo Login:                                       ║"
echo "║  distributor1@xiishopy.com / Test123!               ║"
echo "║  retailer1@xiishopy.com / Test123!                  ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║  Terminal 2: Traffic Simulator                      ║"
echo "║  python3 scripts/mock_xiishopy_traffic.py            ║"
echo "║                                                     ║"
echo "║  Terminal 3: Flutter Client                         ║"
echo "║  cd xiishopy_erp && flutter run                      ║"
echo "║                                                     ║"
echo "║  Stop: ./scripts/stop-emulators.sh                  ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

echo "$EMULATOR_PID" > /tmp/xiishopy-emulator.pid
wait $EMULATOR_PID