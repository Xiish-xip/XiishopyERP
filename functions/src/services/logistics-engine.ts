/**
 * Xiishopy ERP - Live Logistics & Dispatch Tracking Engine
 * Handles continuous shipment status updates from carriers.
 * Changes push instantly to Firestore, triggering .snapshots() listeners on clients.
 */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { v4 as uuidv4 } from 'uuid';
import { ShipmentStatus, Carrier, OrderStatus } from '../config/constants';

interface ShipmentUpdate {
  orderId: string;
  carrier: Carrier;
  trackingNumber: string;
  currentStatus: ShipmentStatus;
  location?: string;
  estimatedDelivery?: string;
  description?: string;
  metadata?: Record<string, unknown>;
}

interface ShipmentResult {
  success: boolean;
  shipmentId: string;
  orderId: string;
  trackingNumber: string;
  status: ShipmentStatus;
  lastUpdated: string;
}

/**
 * Update a shipment's status and propagate to the order's live tracking.
 * Called by carrier webhooks or internal simulation.
 */
export async function updateShipmentStatus(update: ShipmentUpdate): Promise<ShipmentResult> {
  const db = admin.firestore();
  const shipmentId = uuidv4();
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
    ...(update.currentStatus === ShipmentStatus.DELIVERED ? { status: OrderStatus.DELIVERED } : {}),
    ...(update.currentStatus === ShipmentStatus.IN_TRANSIT ? { status: OrderStatus.SHIPPED } : {}),
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
export async function createShipment(
  orderId: string,
  carrier: Carrier = Carrier.SENDY,
  trackingNumber?: string
): Promise<ShipmentResult> {
  const tn = trackingNumber || `XIISHOPY-${uuidv4().slice(0, 10).toUpperCase()}`;

  return updateShipmentStatus({
    orderId,
    carrier,
    trackingNumber: tn,
    currentStatus: ShipmentStatus.PICKED_UP,
    location: 'Warehouse - Nairobi, KE',
    description: 'Package picked up from distributor warehouse',
  });
}