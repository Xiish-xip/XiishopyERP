/**
 * Xiishopy ERP - Logistics Route Handler
 * /api/v1/logistics
 * Handles carrier tracking updates, shipment creation, and status queries.
 */

import { Router, Response } from 'express';
import { AuthenticatedRequest } from '../middleware/auth-guard';
import { HTTP_STATUS, Carrier, ShipmentStatus } from '../config/constants';
import { updateShipmentStatus, createShipment } from '../services/logistics-engine';
import * as admin from 'firebase-admin';

const router = Router();

/**
 * POST /api/v1/logistics/shipment
 * Create a new shipment for an order
 */
router.post('/shipment', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { orderId, carrier, trackingNumber } = req.body;

    if (!orderId) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: 'Missing required field: orderId',
        code: 'validation/missing-fields',
      });
      return;
    }

    const result = await createShipment(
      orderId,
      carrier || Carrier.SENDY,
      trackingNumber
    );

    res.status(HTTP_STATUS.CREATED).json({
      success: true,
      data: result,
      message: 'Shipment created successfully',
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to create shipment',
      code: 'logistics/create-error',
    });
  }
});

/**
 * POST /api/v1/logistics/tracking
 * Update shipment tracking status (carrier webhook simulation)
 */
router.post('/tracking', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { orderId, carrier, trackingNumber, currentStatus, location, description } = req.body;

    if (!orderId || !currentStatus) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: 'Missing required fields: orderId, currentStatus',
        code: 'validation/missing-fields',
      });
      return;
    }

    // Validate status
    const validStatuses = Object.values(ShipmentStatus);
    if (!validStatuses.includes(currentStatus)) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: `Invalid status. Must be one of: ${validStatuses.join(', ')}`,
        code: 'validation/invalid-status',
      });
      return;
    }

    const result = await updateShipmentStatus({
      orderId,
      carrier: carrier || Carrier.SENDY,
      trackingNumber: trackingNumber || `TRACK-${Date.now()}`,
      currentStatus,
      location,
      description,
    });

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: result,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to update tracking',
      code: 'logistics/tracking-error',
    });
  }
});

/**
 * GET /api/v1/logistics/:orderId
 * Get tracking history for an order
 */
router.get('/:orderId', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { orderId } = req.params;
    const db = admin.firestore();

    const shipmentsSnap = await db.collection('shipments')
      .where('orderId', '==', orderId)
      .orderBy('createdAt', 'desc')
      .get();

    const shipments = shipmentsSnap.docs.map((doc) => ({ id: doc.id, ...doc.data() }));

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: shipments,
      count: shipments.length,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to fetch tracking data',
      code: 'logistics/fetch-error',
    });
  }
});

export default router;