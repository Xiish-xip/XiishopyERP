/**
 * Xiishopy ERP - Instant Payment Engine
 * Handles real-time payment webhook processing for M-Pesa, Airtel Money, Selcom, Pesapal.
 * Simulates STK Push verification and instant order status updates.
 */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { v4 as uuidv4 } from 'uuid';
import {
  PaymentProvider,
  PaymentStatus,
  OrderStatus,
} from '../config/constants';

interface PaymentWebhookPayload {
  provider: PaymentProvider;
  transactionId: string;
  phoneNumber: string;
  amount: number;
  currency: string;
  orderId: string;
  status: PaymentStatus;
  metadata?: Record<string, unknown>;
}

interface PaymentResult {
  success: boolean;
  paymentId: string;
  transactionId: string;
  status: PaymentStatus;
  orderId: string;
  amount: number;
  currency: string;
  processedAt: string;
}

/**
 * Process an incoming payment webhook from any payment provider.
 * This is exported as a callable function and also used internally.
 */
export async function processPaymentWebhook(
  payload: PaymentWebhookPayload
): Promise<PaymentResult> {
  const db = admin.firestore();
  const paymentId = uuidv4();
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
  if (payload.status === PaymentStatus.COMPLETED) {
    const orderRef = db.collection('orders').doc(payload.orderId);
    const orderDoc = await orderRef.get();

    if (!orderDoc.exists) {
      functions.logger.warn(`Order ${payload.orderId} not found for payment update`);
    } else {
      await orderRef.update({
        status: OrderStatus.PAID,
        paymentId: paymentId,
        paidAt: timestamp,
        updatedAt: timestamp,
      });

      functions.logger.info(`Order ${payload.orderId} marked as PAID`);
    }
  }

  return {
    success: payload.status === PaymentStatus.COMPLETED,
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
export async function simulateMpesaPayment(phone: string, amount: number, orderId: string): Promise<PaymentResult> {
  return processPaymentWebhook({
    provider: PaymentProvider.MPESA,
    transactionId: `MPESA-${uuidv4().slice(0, 8).toUpperCase()}`,
    phoneNumber: phone,
    amount,
    currency: 'KES',
    orderId,
    status: PaymentStatus.COMPLETED,
    metadata: {
      simulated: true,
      providerRef: `SIM${Date.now()}`,
    },
  });
}