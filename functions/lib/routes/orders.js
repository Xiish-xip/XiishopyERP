"use strict";
/**
 * Xiishopy ERP - Orders Route Handler
 * /api/v1/orders
 * Order management with live tracking, payment status, and CRUD operations.
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
const express_1 = require("express");
const constants_1 = require("../config/constants");
const admin = __importStar(require("firebase-admin"));
const uuid_1 = require("uuid");
const router = (0, express_1.Router)();
/**
 * GET /api/v1/orders
 * List orders for the authenticated user
 */
router.get('/', async (req, res) => {
    try {
        const db = admin.firestore();
        const userId = req.userId;
        let query = db.collection('orders');
        // Filter by user role context
        const role = req.query.role;
        if (role === 'distributor') {
            query = query.where('distributorId', '==', userId);
        }
        else {
            query = query.where('retailerId', '==', userId);
        }
        // Filter by status
        if (req.query.status) {
            query = query.where('status', '==', req.query.status);
        }
        query = query.orderBy('createdAt', 'desc');
        const limit = Math.min(parseInt(req.query.limit) || 50, 100);
        query = query.limit(limit);
        const snapshot = await query.get();
        const orders = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: orders,
            count: orders.length,
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
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
router.post('/', async (req, res) => {
    try {
        const { distributorId, items, totalAmountUSD, shippingAddress, notes } = req.body;
        if (!distributorId || !items || !totalAmountUSD) {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
                success: false,
                error: 'Missing required fields: distributorId, items, totalAmountUSD',
                code: 'validation/missing-fields',
            });
            return;
        }
        const db = admin.firestore();
        const orderId = (0, uuid_1.v4)();
        const orderNumber = `XIISHOPY-${String(Date.now()).slice(-8)}`;
        const timestamp = new Date().toISOString();
        const order = {
            id: orderId,
            orderNumber,
            retailerId: req.userId,
            distributorId,
            items,
            totalAmountUSD,
            status: constants_1.OrderStatus.PENDING,
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
                    }
                    catch (err) {
                        console.error(`Failed to update stock for product ${item.productId}`);
                    }
                }
            }
        }
        res.status(constants_1.HTTP_STATUS.CREATED).json({
            success: true,
            data: order,
            message: `Order ${orderNumber} created successfully`,
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
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
router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const db = admin.firestore();
        const doc = await db.collection('orders').doc(id).get();
        if (!doc.exists) {
            res.status(constants_1.HTTP_STATUS.NOT_FOUND).json({
                success: false,
                error: `Order ${id} not found`,
                code: 'orders/not-found',
            });
            return;
        }
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: { id: doc.id, ...doc.data() },
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
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
router.patch('/:id/status', async (req, res) => {
    try {
        const { id } = req.params;
        const { status } = req.body;
        const validStatuses = Object.values(constants_1.OrderStatus);
        if (!status || !validStatuses.includes(status)) {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
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
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: { id: updated.id, ...updated.data() },
            message: `Order status updated to ${status}`,
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
            success: false,
            error: 'Failed to update order status',
            code: 'orders/status-update-error',
        });
    }
});
exports.default = router;
//# sourceMappingURL=orders.js.map