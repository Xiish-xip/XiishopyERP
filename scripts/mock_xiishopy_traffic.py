#!/usr/bin/env python3
"""
Xiishopy ERP - Multi-Threaded Live Traffic Simulator
====================================================
Simulates real-time ecosystem activity:
  1. Live forex fluctuations every 5 seconds
  2. Mock M-Pesa payment callbacks
  3. Progressive shipping status updates
  4. AI prediction demand generation
  5. Order lifecycle automation

Usage:
  python3 scripts/mock_xiishopy_traffic.py [--interval 5] [--firestore-host localhost:8080]
"""

import argparse
import json
import random
import sys
import threading
import time
import uuid
from datetime import datetime, timezone
from http.client import HTTPConnection, HTTPException
from urllib.parse import urlencode

# ========================
# Configuration
# ========================
FIREBASE_FUNCTIONS_HOST = "127.0.0.1"
FIREBASE_FUNCTIONS_PORT = 5001
FIRESTORE_HOST = "127.0.0.1"
FIRESTORE_PORT = 8080

BASE_RATES = {
    "KES": 150.0,
    "TZS": 2500.0,
    "UGX": 3700.0,
    "RWF": 1300.0,
}

SHIPMENT_STATUSES = [
    "Picked up",
    "In Transit",
    "Out for Delivery",
    "Delivered",
]

CARRIERS = ["dhl_africa", "sendy", "amit_trucking"]
LOCATIONS = [
    "Nairobi, KE",
    "Mombasa, KE",
    "Kampala, UG",
    "Dar es Salaam, TZ",
    "Kigali, RW",
    "Arusha, TZ",
    "Kisumu, KE",
    "Jinja, UG",
]

TEST_UID = "distributor-001"  # For API auth bypass header

stop_event = threading.Event()


# ========================
# HTTP Helper
# ========================
def make_request(method: str, path: str, body: dict = None, use_auth: bool = True) -> dict:
    """Make HTTP request to the local Firebase emulator."""
    conn = HTTPConnection(FIREBASE_FUNCTIONS_HOST, FIREBASE_FUNCTIONS_PORT, timeout=5)
    headers = {
        "Content-Type": "application/json",
    }
    if use_auth:
        headers["x-xiishopy-test-uid"] = TEST_UID

    body_bytes = json.dumps(body).encode("utf-8") if body else None

    try:
        conn.request(method, path, body=body_bytes, headers=headers)
        response = conn.getresponse()
        data = response.read().decode("utf-8")
        conn.close()
        return json.loads(data) if data else {"success": True}
    except (ConnectionRefusedError, HTTPException, TimeoutError) as e:
        return {"success": False, "error": str(e)}
    finally:
        conn.close()


def firestore_set(collection: str, doc_id: str, data: dict) -> dict:
    """Direct Firestore REST write (bypasses functions)."""
    conn = HTTPConnection(FIRESTORE_HOST, FIRESTORE_PORT, timeout=5)
    headers = {"Content-Type": "application/json"}
    
    path = f"/v1/projects/demo-xiishopy-erp/databases/(default)/documents/{collection}/{doc_id}"
    
    # Convert to Firestore document format
    fields = {}
    for key, value in data.items():
        if isinstance(value, str):
            fields[key] = {"stringValue": value}
        elif isinstance(value, (int, float)):
            if isinstance(value, bool):
                fields[key] = {"booleanValue": value}
            else:
                fields[key] = {"doubleValue": float(value)}
        elif isinstance(value, dict):
            fields[key] = {"mapValue": {"fields": {k: {"stringValue": str(v)} for k, v in value.items()}}}
        elif value is None:
            fields[key] = {"nullValue": None}
        else:
            fields[key] = {"stringValue": str(value)}
    
    firestore_doc = {"fields": fields}
    
    try:
        conn.request("PATCH", path, body=json.dumps(firestore_doc), headers=headers)
        response = conn.getresponse()
        data = response.read().decode("utf-8")
        conn.close()
        return {"success": response.status < 300}
    except Exception as e:
        return {"success": False, "error": str(e)}
    finally:
        conn.close()


# ========================
# Thread 1: Forex Fluctuator
# ========================
def forex_simulator(interval: int = 5):
    """Stream live currency fluctuations every N seconds."""
    print(f"[FOREX] Starting forex simulator (interval: {interval}s)")
    rates = dict(BASE_RATES)

    while not stop_event.is_set():
        # Modulate each rate by +/- 2%
        for currency in rates:
            change = random.uniform(-0.02, 0.02)
            rates[currency] = round(rates[currency] * (1 + change), 2)

        timestamp = datetime.now(timezone.utc).isoformat()
        
        # Write via Firestore REST API (direct write to trigger listeners)
        forex_data = {
            "base": "USD",
            "rates": {k: v for k, v in rates.items()},
            "lastUpdated": timestamp,
            "source": "simulated",
        }
        
        result = firestore_set("forex_rates", "live", forex_data)
        
        if result.get("success"):
            print(f"  [FOREX] 💰 Updated: KES={rates['KES']:.2f} TZS={rates['TZS']:.2f} UGX={rates['UGX']:.2f} RWF={rates['RWF']:.2f}")
        else:
            print(f"  [FOREX] ⚠️ Write failed: {result.get('error', 'unknown')}")

        stop_event.wait(interval)


# ========================
# Thread 2: Payment Simulator
# ========================
def payment_simulator(interval: int = 30):
    """Simulate M-Pesa payment callbacks for pending orders."""
    print(f"[PAYMENTS] Starting payment simulator (interval: {interval}s)")
    order_index = 0
    pending_orders = ["order-003"]

    while not stop_event.is_set():
        if not pending_orders:
            pending_orders.append(f"order-{random.randint(4, 10)}")
        
        order_id = pending_orders.pop(0)
        amount = round(random.uniform(50, 500), 2)
        phone = f"+2547{random.randint(10000000, 99999999)}"

        # Simulate M-Pesa STK Push callback
        result = make_request(
            "POST",
            "/xiishopy-erp/us-central1/api/api/v1/payments/simulate-mpesa",
            {
                "phone": phone,
                "amount": amount,
                "orderId": order_id,
            },
        )

        if result.get("success"):
            print(f"  [PAYMENTS] ✅ M-Pesa payment simulated for {order_id}: {amount} KES")
        else:
            print(f"  [PAYMENTS] ⚠️ Payment simulation failed: {result.get('error', 'unknown')}")
            # Re-queue for next cycle
            pending_orders.append(order_id)

        stop_event.wait(interval)


# ========================
# Thread 3: Shipping Tracker
# ========================
def logistics_simulator(interval: int = 15):
    """Progressive shipping status updates."""
    print(f"[LOGISTICS] Starting logistics simulator (interval: {interval}s)")
    active_shipments = {
        "order-001": {"status_index": 1, "carrier": "sendy", "tracking": "XIISHOPY-TRACK-001"},
        "order-002": {"status_index": 0, "carrier": "amit_trucking", "tracking": "XIISHOPY-TRACK-002"},
    }

    while not stop_event.is_set():
        for order_id, shipment in list(active_shipments.items()):
            idx = shipment["status_index"]
            if idx >= len(SHIPMENT_STATUSES):
                print(f"  [LOGISTICS] ✅ {order_id}: Delivery complete!")
                del active_shipments[order_id]
                continue

            status = SHIPMENT_STATUSES[idx]
            location = random.choice(LOCATIONS)
            carrier = shipment["carrier"]

            result = make_request(
                "POST",
                "/xiishopy-erp/us-central1/api/api/v1/logistics/tracking",
                {
                    "orderId": order_id,
                    "carrier": carrier,
                    "trackingNumber": shipment["tracking"],
                    "currentStatus": status,
                    "location": location,
                    "description": f"Package {status.lower()} at {location}",
                },
            )

            if result.get("success"):
                print(f"  [LOGISTICS] 📦 {order_id}: {status} @ {location}")
                shipment["status_index"] += 1
            else:
                print(f"  [LOGISTICS] ⚠️ Update failed for {order_id}: {result.get('error', 'unknown')}")

        # Occasionally add new shipments
        if random.random() < 0.2 and len(active_shipments) < 5:
            new_order_id = f"order-{random.randint(4, 10)}"
            carrier = random.choice(CARRIERS)
            tracking = f"XIISHOPY-TRACK-{uuid.uuid4().hex[:8].upper()}"
            active_shipments[new_order_id] = {
                "status_index": 0,
                "carrier": carrier,
                "tracking": tracking,
            }
            print(f"  [LOGISTICS] 🆕 New shipment: {new_order_id} via {carrier}")

        stop_event.wait(interval)


# ========================
# Thread 4: AI Demand Predictor
# ========================
def ai_simulator(interval: int = 45):
    """Periodically hit AI prediction endpoints to simulate usage."""
    print(f"[AI] Starting AI prediction simulator (interval: {interval}s)")
    product_ids = [
        ("prod-001", "Cooking Oil - 5L", 250),
        ("prod-002", "Maize Flour - 10kg", 500),
        ("prod-003", "Sugar - 2kg", 800),
        ("prod-005", "Cement - 50kg", 120),
        ("prod-010", "Paint - 4L", 45),
    ]

    while not stop_event.is_set():
        product_id, name, stock = random.choice(product_ids)

        # Demand prediction
        result = make_request(
            "POST",
            "/xiishopy-erp/us-central1/api/api/v1/ai/predict-demand",
            {
                "productId": product_id,
                "productName": name,
                "currentStock": stock,
            },
        )

        if result.get("success"):
            pred = result.get("data", {})
            print(f"  [AI] 🤖 {name}: stockout in {pred.get('daysUntilStockout', '?')} days, restock {pred.get('recommendedRestockQuantity', '?')}")
        else:
            print(f"  [AI] ⚠️ Prediction failed: {result.get('error', 'unknown')}")

        # Occasionally do invoice OCR simulation
        if random.random() < 0.3:
            base64_dummy = f"data:image/png;base64,{uuid.uuid4().hex * 20}"  # Simulated large base64
            result = make_request(
                "POST",
                "/xiishopy-erp/us-central1/api/api/v1/ai/parse-invoice",
                {
                    "imageBase64": base64_dummy,
                    "fileName": f"invoice_{uuid.uuid4().hex[:8]}.png",
                },
            )
            if result.get("success"):
                invoice = result.get("data", {})
                print(f"  [AI] 📄 OCR parsed: {invoice.get('invoiceNumber', '?')} ({invoice.get('items', [])} items) - {invoice.get('confidence', 0)*100:.0f}% confidence")

        stop_event.wait(interval)


# ========================
# Thread 5: Order Lifecycle
# ========================
def order_lifecycle_simulator(interval: int = 60):
    """Create new orders and manage their lifecycle."""
    print(f"[ORDERS] Starting order lifecycle simulator (interval: {interval}s)")
    retailers = ["retailer-001", "retailer-002", "retailer-003"]
    distributors = ["distributor-001", "distributor-002"]

    while not stop_event.is_set():
        retailer = random.choice(retailers)
        distributor = random.choice(distributors)
        product_id = random.choice(["prod-001", "prod-002", "prod-005", "prod-009", "prod-010"])
        quantity = random.randint(5, 100)
        unit_price = random.uniform(2.0, 15.0)
        total = round(quantity * unit_price, 2)

        result = make_request(
            "POST",
            "/xiishopy-erp/us-central1/api/api/v1/orders",
            {
                "distributorId": distributor,
                "items": [{"productId": product_id, "quantity": quantity, "unitPriceUSD": unit_price}],
                "totalAmountUSD": total,
                "shippingAddress": f"{random.choice(LOCATIONS)} - Test Address",
            },
            use_auth=True,
        )

        if result.get("success"):
            order = result.get("data", {})
            print(f"  [ORDERS] 🆕 Order created: {order.get('orderNumber', '?')} (${total}) from {retailer} -> {distributor}")
        else:
            print(f"  [ORDERS] ⚠️ Order creation failed: {result.get('error', 'unknown')}")

        stop_event.wait(interval)


# ========================
# Main Orchestrator
# ========================
def main():
    parser = argparse.ArgumentParser(description="Xiishopy ERP - Live Traffic Simulator")
    parser.add_argument("--interval", type=int, default=5, help="Base interval in seconds (default: 5)")
    parser.add_argument("--no-forex", action="store_true", help="Disable forex simulator")
    parser.add_argument("--no-payments", action="store_true", help="Disable payment simulator")
    parser.add_argument("--no-logistics", action="store_true", help="Disable logistics simulator")
    parser.add_argument("--no-ai", action="store_true", help="Disable AI simulator")
    parser.add_argument("--no-orders", action="store_true", help="Disable order lifecycle simulator")
    args = parser.parse_args()

    print("""
╔══════════════════════════════════════════════════════╗
║           XIISHOPY ERP - TRAFFIC SIMULATOR           ║
║         Multi-Threaded Live Ecosystem Streamer        ║
╚══════════════════════════════════════════════════════╝

Starting simulated traffic for the East African market...
    """)

    threads = []

    if not args.no_forex:
        t = threading.Thread(target=forex_simulator, args=(max(5, args.interval),), daemon=True)
        threads.append(("Forex 💰", t))

    if not args.no_payments:
        t = threading.Thread(target=payment_simulator, args=(max(30, args.interval * 6),), daemon=True)
        threads.append(("Payments ✅", t))

    if not args.no_logistics:
        t = threading.Thread(target=logistics_simulator, args=(max(15, args.interval * 3),), daemon=True)
        threads.append(("Logistics 📦", t))

    if not args.no_ai:
        t = threading.Thread(target=ai_simulator, args=(max(45, args.interval * 9),), daemon=True)
        threads.append(("AI 🤖", t))

    if not args.no_orders:
        t = threading.Thread(target=order_lifecycle_simulator, args=(max(60, args.interval * 12),), daemon=True)
        threads.append(("Orders 📋", t))

    print("Active simulation threads:")
    for name, t in threads:
        print(f"  • {name}")
        t.start()

    print(f"\n{'='*50}")
    print("Simulators running. Press Ctrl+C to stop all threads.")
    print(f"{'='*50}\n")

    try:
        while not stop_event.is_set():
            stop_event.wait(1)
    except KeyboardInterrupt:
        print("\n\n🛑 Shutting down all simulators...")
        stop_event.set()
        for name, t in threads:
            t.join(timeout=2)
            print(f"  ✓ {name} stopped")
        print("\nSimulation ended. Goodbye! 👋\n")
        sys.exit(0)


if __name__ == "__main__":
    main()