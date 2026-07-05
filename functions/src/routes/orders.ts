/**
 * Xiishopy ERP - Orders Route Handler
 * /api/v1/orders
 * Order management with live tracking, payment status, and CRUD operations.
 */

import { Router, Response } from 'express';
import { AuthenticatedRequest } from '../middleware/auth-guard';
import { HTTP_STATUS, OrderStatus } from '../config/constants';
import * as admin from 'firebase-admin';
import { v4 as uuidv4 } from 'uuid';

const router = Router();

/**
 * GET /api/v1/orders
 * List orders for the authenticated user
 */
router.get('/', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const db = admin.firestore();
    const userId = req.userId!;
    let query: admin.firestore.Query = db.collection('orders');

    // Filter by user role context
    const role = req.query.role as string;
    if (role === 'distributor') {
      query = query.where('distributorId', '==', userId);
    } else {
      query = query.where('retailerId', '==', userId);
    }

    // Filter by status
    if (req.query.status) {
      query = query.where('status', '==', req.query.status);
    }

    query = query.orderBy('createdAt', 'desc');
    const limit = Math.min(parseInt(req.query.limit as string) || 50, 100);
    query = query.limit(limit);

    const snapshot = await query.get();
    const orders = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: orders,
      count: orders.length,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to fetch orders',
      code: 'orders/fetch-error',
    });
  }
});

/**
 * POST /api/v1/orders
 * Create a new order
 */
router.post('/', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { distributorId, items, totalAmountUSD, shippingAddress, notes } = req.body;

    if (!distributorId || !items || !totalAmountUSD) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: 'Missing required fields: distributorId, items, totalAmountUSD',
        code: 'validation/missing-fields',
      });
      return;
    }

    const db = admin.firestore();
    const orderId = uuidv4();
    const orderNumber = `XIISHOPY-${String(Date.now()).slice(-8)}`;
    const timestamp = new Date().toISOString();

    const order = {
      id: orderId,
      orderNumber,
      retailerId: req.userId,
      distributorId,
      items,
      totalAmountUSD,
      status: OrderStatus.PENDING,
      shippingAddress: shippingAddress || '',
      notes: notes || '',
      liveTracking: {
        carrier: null,
        currentStatus: null,
        lastUpdated: null,
        trackingNumber: null,
        location: null,
      },
      createdAt: timestamp,
      updatedAt: timestamp,
    };

    await db.collection('orders').doc(orderId).set(order);

    // Decrease product stock levels
    if (items && Array.isArray(items)) {
      for (const item of items) {
        if (item.productId) {
          try {
            const productRef = db.collection('products').doc(item.productId);
            await productRef.update({
              stockLevel: admin.firestore.FieldValue.increment(-(item.quantity || 1)),
              updatedAt: timestamp,
            });
          } catch (err) {
            console.error(`Failed to update stock for product ${item.productId}`);
          }
        }
      }
    }

    res.status(HTTP_STATUS.CREATED).json({
      success: true,
      data: order,
      message: `Order ${orderNumber} created successfully`,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to create order',
      code: 'orders/create-error',
    });
  }
});

/**
 * GET /api/v1/orders/:id
 * Get order details
 */
router.get('/:id', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { id } = req.params;
    const db = admin.firestore();
    const doc = await db.collection('orders').doc(id).get();

    if (!doc.exists) {
      res.status(HTTP_STATUS.NOT_FOUND).json({
        success: false,
        error: `Order ${id} not found`,
        code: 'orders/not-found',
      });
      return;
    }

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: { id: doc.id, ...doc.data() },
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to fetch order',
      code: 'orders/fetch-error',
    });
  }
});

/**
 * PATCH /api/v1/orders/:id/status
 * Update order status
 */
router.patch('/:id/status', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const validStatuses = Object.values(OrderStatus);
    if (!status || !validStatuses.includes(status)) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: `Invalid status. Must be one of: ${validStatuses.join(', ')}`,
        code: 'validation/invalid-status',
      });
      return;
    }

    const db = admin.firestore();
    await db.collection('orders').doc(id).update({
      status,
      updatedAt: new Date().toISOString(),
    });

    const updated = await db.collection('orders').doc(id).get();

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: { id: updated.id, ...updated.data() },
      message: `Order status updated to ${status}`,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to update order status',
      code: 'orders/status-update-error',
    });
  }
});

export default router;