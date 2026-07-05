"use strict";
/**
 * Xiishopy ERP - Logistics Route Handler
 * /api/v1/logistics
 * Handles carrier tracking updates, shipment creation, and status queries.
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
const logistics_engine_1 = require("../services/logistics-engine");
const admin = __importStar(require("firebase-admin"));
const router = (0, express_1.Router)();
/**
 * POST /api/v1/logistics/shipment
 * Create a new shipment for an order
 */
router.post('/shipment', async (req, res) => {
    try {
        const { orderId, carrier, trackingNumber } = req.body;
        if (!orderId) {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
                success: false,
                error: 'Missing required field: orderId',
                code: 'validation/missing-fields',
            });
            return;
        }
        const result = await (0, logistics_engine_1.createShipment)(orderId, carrier || constants_1.Carrier.SENDY, trackingNumber);
        res.status(constants_1.HTTP_STATUS.CREATED).json({
            success: true,
            data: result,
            message: 'Shipment created successfully',
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
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
router.post('/tracking', async (req, res) => {
    try {
        const { orderId, carrier, trackingNumber, currentStatus, location, description } = req.body;
        if (!orderId || !currentStatus) {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
                success: false,
                error: 'Missing required fields: orderId, currentStatus',
                code: 'validation/missing-fields',
            });
            return;
        }
        // Validate status
        const validStatuses = Object.values(constants_1.ShipmentStatus);
        if (!validStatuses.includes(currentStatus)) {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
                success: false,
                error: `Invalid status. Must be one of: ${validStatuses.join(', ')}`,
                code: 'validation/invalid-status',
            });
            return;
        }
        const result = await (0, logistics_engine_1.updateShipmentStatus)({
            orderId,
            carrier: carrier || constants_1.Carrier.SENDY,
            trackingNumber: trackingNumber || `TRACK-${Date.now()}`,
            currentStatus,
            location,
            description,
        });
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: result,
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
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
router.get('/:orderId', async (req, res) => {
    try {
        const { orderId } = req.params;
        const db = admin.firestore();
        const shipmentsSnap = await db.collection('shipments')
            .where('orderId', '==', orderId)
            .orderBy('createdAt', 'desc')
            .get();
        const shipments = shipmentsSnap.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: shipments,
            count: shipments.length,
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
            success: false,
            error: 'Failed to fetch tracking data',
            code: 'logistics/fetch-error',
        });
    }
});
exports.default = router;
//# sourceMappingURL=logistics.js.map