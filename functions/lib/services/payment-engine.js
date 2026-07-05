"use strict";
/**
 * Xiishopy ERP - Instant Payment Engine
 * Handles real-time payment webhook processing for M-Pesa, Airtel Money, Selcom, Pesapal.
 * Simulates STK Push verification and instant order status updates.
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
exports.processPaymentWebhook = processPaymentWebhook;
exports.simulateMpesaPayment = simulateMpesaPayment;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
const uuid_1 = require("uuid");
const constants_1 = require("../config/constants");
/**
 * Process an incoming payment webhook from any payment provider.
 * This is exported as a callable function and also used internally.
 */
async function processPaymentWebhook(payload) {
    const db = admin.firestore();
    const paymentId = (0, uuid_1.v4)();
    const timestamp = new Date().toISOString();
    functions.logger.info(`Processing payment webhook from ${payload.provider}`, {
        transactionId: payload.transactionId,
        orderId: payload.orderId,
        amount: payload.amount,
    });
    // 1. Create payment record
    const paymentRecord = {
        id: paymentId,
        provider: payload.provider,
        transactionId: payload.transactionId,
        phoneNumber: payload.phoneNumber,
        amount: payload.amount,
        currency: payload.currency,
        orderId: payload.orderId,
        status: payload.status,
        metadata: payload.metadata || {},
        createdAt: timestamp,
        updatedAt: timestamp,
    };
    await db.collection('payments').doc(paymentId).set(paymentRecord);
    // 2. If payment completed, update the order status
    if (payload.status === constants_1.PaymentStatus.COMPLETED) {
        const orderRef = db.collection('orders').doc(payload.orderId);
        const orderDoc = await orderRef.get();
        if (!orderDoc.exists) {
            functions.logger.warn(`Order ${payload.orderId} not found for payment update`);
        }
        else {
            await orderRef.update({
                status: constants_1.OrderStatus.PAID,
                paymentId: paymentId,
                paidAt: timestamp,
                updatedAt: timestamp,
            });
            functions.logger.info(`Order ${payload.orderId} marked as PAID`);
        }
    }
    return {
        success: payload.status === constants_1.PaymentStatus.COMPLETED,
        paymentId,
        transactionId: payload.transactionId,
        status: payload.status,
        orderId: payload.orderId,
        amount: payload.amount,
        currency: payload.currency,
        processedAt: timestamp,
    };
}
/**
 * Simulate an M-Pesa STK Push callback
 * Used by the mock traffic simulator to instantly move orders to 'Paid'
 */
async function simulateMpesaPayment(phone, amount, orderId) {
    return processPaymentWebhook({
        provider: constants_1.PaymentProvider.MPESA,
        transactionId: `MPESA-${(0, uuid_1.v4)().slice(0, 8).toUpperCase()}`,
        phoneNumber: phone,
        amount,
        currency: 'KES',
        orderId,
        status: constants_1.PaymentStatus.COMPLETED,
        metadata: {
            simulated: true,
            providerRef: `SIM${Date.now()}`,
        },
    });
}
//# sourceMappingURL=payment-engine.js.map