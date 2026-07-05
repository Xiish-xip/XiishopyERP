/**
 * Xiishopy ERP - Payments Route Handler
 * /api/v1/payments
 * Handles payment webhooks, STK Push simulation, and transaction queries.
 */

import { Router, Response } from 'express';
import { AuthenticatedRequest } from '../middleware/auth-guard';
import { HTTP_STATUS } from '../config/constants';
import { processPaymentWebhook, simulateMpesaPayment } from '../services/payment-engine';
import * as admin from 'firebase-admin';

const router = Router();

/**
 * POST /api/v1/payments/webhook
 * Process incoming payment provider webhook
 */
router.post('/webhook', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { provider, transactionId, phoneNumber, amount, currency, orderId, status, metadata } = req.body;

    // Validate required fields
    if (!provider || !transactionId || !amount || !orderId || !status) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: 'Missing required fields: provider, transactionId, amount, orderId, status',
        code: 'validation/missing-fields',
      });
      return;
    }

    const result = await processPaymentWebhook({
      provider,
      transactionId,
      phoneNumber: phoneNumber || req.userId || 'unknown',
      amount,
      currency: currency || 'USD',
      orderId,
      status,
      metadata,
    });

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: result,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
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
router.post('/simulate-mpesa', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { phone, amount, orderId } = req.body;

    if (!phone || !amount || !orderId) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: 'Missing required fields: phone, amount, orderId',
        code: 'validation/missing-fields',
      });
      return;
    }

    const result = await simulateMpesaPayment(phone, amount, orderId);

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: result,
      message: 'M-Pesa payment simulated successfully',
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
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
router.get('/:orderId', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { orderId } = req.params;
    const db = admin.firestore();

    const paymentsSnap = await db.collection('payments')
      .where('orderId', '==', orderId)
      .orderBy('createdAt', 'desc')
      .get();

    const payments = paymentsSnap.docs.map((doc) => ({ id: doc.id, ...doc.data() }));

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: payments,
      count: payments.length,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to fetch payments',
      code: 'payments/fetch-error',
    });
  }
});

export default router;