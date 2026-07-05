#!/bin/bash
# ============================================================
# Xiishopy ERP - Reset & Re-Seed Emulator Data
# ============================================================
# Clears all emulator data and re-runs the seed script.
# Usage: ./scripts/reset-emulator-data.sh
# Must be run AFTER emulators are started.
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo ""
echo "🔄 Xiishopy ERP - Resetting Emulator Data"
echo ""

# Clear cache
echo "  Clearing local cache..."
rm -rf "$PROJECT_DIR/local_cache/firestore_export" "$PROJECT_DIR/local_cache/auth_export" 2>/dev/null || true
echo "  ✅ Cache cleared"

# Re-seed
echo ""
echo "  Re-seeding data..."
cd "$PROJECT_DIR/functions"
npx ts-node --project "$PROJECT_DIR/functions/tsconfig.json" -r tsconfig-paths/register "$PROJECT_DIR/seed/seed-firestore.ts" 2>&1
SEED_EXIT=$?
cd "$PROJECT_DIR"

if [ $SEED_EXIT -eq 0 ]; then
    echo ""
    echo "✅ Reset complete! Restart emulators to load fresh data."
else
    echo ""
    echo "⚠️  Seed encountered errors."
fi