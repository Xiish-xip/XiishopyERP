/**
 * Xiishopy ERP - Live Logistics & Dispatch Tracking Engine
 * Handles continuous shipment status updates from carriers.
 * Changes push instantly to Firestore, triggering .snapshots() listeners on clients.
 */
import { ShipmentStatus, Carrier } from '../config/constants';
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
export declare function updateShipmentStatus(update: ShipmentUpdate): Promise<ShipmentResult>;
/**
 * Simulate a progressive shipment lifecycle for testing.
 * Creates initial shipment record and fires first status.
 */
export declare function createShipment(orderId: string, carrier?: Carrier, trackingNumber?: string): Promise<ShipmentResult>;
export {};
