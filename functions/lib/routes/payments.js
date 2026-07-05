"use strict";
/**
 * Xiishopy ERP - Payments Route Handler
 * /api/v1/payments
 * Handles payment webhooks, STK Push simulation, and transaction queries.
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
const payment_engine_1 = require("../services/payment-engine");
const admin = __importStar(require("firebase-admin"));
const router = (0, express_1.Router)();
/**
 * POST /api/v1/payments/webhook
 * Process incoming payment provider webhook
 */
router.post('/webhook', async (req, res) => {
    try {
        const { provider, transactionId, phoneNumber, amount, currency, orderId, status, metadata } = req.body;
        // Validate required fields
        if (!provider || !transactionId || !amount || !orderId || !status) {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
                success: false,
                error: 'Missing required fields: provider, transactionId, amount, orderId, status',
                code: 'validation/missing-fields',
            });
            return;
        }
        const result = await (0, payment_engine_1.processPaymentWebhook)({
            provider,
            transactionId,
            phoneNumber: phoneNumber || req.userId || 'unknown',
            amount,
            currency: currency || 'USD',
            orderId,
            status,
            metadata,
        });
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: result,
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
            success: false,
            error: 'Failed to process payment webhook',
            code: 'payments/webhook-error',
        });
    }
});
/**
 * POST /api/v1/payments/simulate-mpesa
 * Simulate an M-Pesa STK Push for testing
 */
router.post('/simulate-mpesa', async (req, res) => {
    try {
        const { phone, amount, orderId } = req.body;
        if (!phone || !amount || !orderId) {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
                success: false,
                error: 'Missing required fields: phone, amount, orderId',
                code: 'validation/missing-fields',
            });
            return;
        }
        const result = await (0, payment_engine_1.simulateMpesaPayment)(phone, amount, orderId);
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: result,
            message: 'M-Pesa payment simulated successfully',
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
            success: false,
            error: 'Failed to simulate M-Pesa payment',
            code: 'payments/simulation-error',
        });
    }
});
/**
 * GET /api/v1/payments/:orderId
 * Get payment history for an order
 */
router.get('/:orderId', async (req, res) => {
    try {
        const { orderId } = req.params;
        const db = admin.firestore();
        const paymentsSnap = await db.collection('payments')
            .where('orderId', '==', orderId)
            .orderBy('createdAt', 'desc')
            .get();
        const payments = paymentsSnap.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: payments,
            count: payments.length,
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
            success: false,
            error: 'Failed to fetch payments',
            code: 'payments/fetch-error',
        });
    }
});
exports.default = router;
//# sourceMappingURL=payments.js.map