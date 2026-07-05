"use strict";
/**
 * Xiishopy ERP - Live Logistics & Dispatch Tracking Engine
 * Handles continuous shipment status updates from carriers.
 * Changes push instantly to Firestore, triggering .snapshots() listeners on clients.
 */
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateShipmentStatus = updateShipmentStatus;
exports.createShipment = createShipment;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
const uuid_1 = require("uuid");
const constants_1 = require("../config/constants");
/**
 * Update a shipment's status and propagate to the order's live tracking.
 * Called by carrier webhooks or internal simulation.
 */
async function updateShipmentStatus(update) {
    const db = admin.firestore();
    const shipmentId = (0, uuid_1.v4)();
    const timestamp = new Date().toISOString();
    functions.logger.info(`📦 Shipment update for order ${update.orderId}`, {
        carrier: update.carrier,
        status: update.currentStatus,
        tracking: update.trackingNumber,
    });
    // 1. Create shipment event record
    const shipmentRecord = {
        id: shipmentId,
        orderId: update.orderId,
        carrier: update.carrier,
        trackingNumber: update.trackingNumber,
        currentStatus: update.currentStatus,
        location: update.location || null,
        estimatedDelivery: update.estimatedDelivery || null,
        description: update.description || '',
        metadata: update.metadata || {},
        lastUpdated: timestamp,
        createdAt: timestamp,
    };
    await db.collection('shipments').doc(shipmentId).set(shipmentRecord);
    // 2. Update order's liveTracking field for real-time UI consumption
    const orderRef = db.collection('orders').doc(update.orderId);
    const orderDoc = await orderRef.get();
    if (!orderDoc.exists) {
        functions.logger.warn(`Order ${update.orderId} not found for shipment update`);
        return {
            success: false,
            shipmentId,
            orderId: update.orderId,
            trackingNumber: update.trackingNumber,
            status: update.currentStatus,
            lastUpdated: timestamp,
        };
    }
    await orderRef.update({
        'liveTracking.carrier': update.carrier,
        'liveTracking.currentStatus': update.currentStatus,
        'liveTracking.lastUpdated': timestamp,
        'liveTracking.trackingNumber': update.trackingNumber,
        'liveTracking.location': update.location || null,
        'liveTracking.shipmentHistory': admin.firestore.FieldValue.arrayUnion({
            status: update.currentStatus,
            timestamp,
            location: update.location || null,
            description: update.description || '',
        }),
        updatedAt: timestamp,
        // Auto-advance order status when delivered
        ...(update.currentStatus === constants_1.ShipmentStatus.DELIVERED ? { status: constants_1.OrderStatus.DELIVERED } : {}),
        ...(update.currentStatus === constants_1.ShipmentStatus.IN_TRANSIT ? { status: constants_1.OrderStatus.SHIPPED } : {}),
    });
    functions.logger.info(`✅ Order ${update.orderId} tracking updated to ${update.currentStatus}`);
    return {
        success: true,
        shipmentId,
        orderId: update.orderId,
        trackingNumber: update.trackingNumber,
        status: update.currentStatus,
        lastUpdated: timestamp,
    };
}
/**
 * Simulate a progressive shipment lifecycle for testing.
 * Creates initial shipment record and fires first status.
 */
async function createShipment(orderId, carrier = constants_1.Carrier.SENDY, trackingNumber) {
    const tn = trackingNumber || `XIISHOPY-${(0, uuid_1.v4)().slice(0, 10).toUpperCase()}`;
    return updateShipmentStatus({
        orderId,
        carrier,
        trackingNumber: tn,
        currentStatus: constants_1.ShipmentStatus.PICKED_UP,
        location: 'Warehouse - Nairobi, KE',
        description: 'Package picked up from distributor warehouse',
    });
}
//# sourceMappingURL=logistics-engine.js.map