/**
 * Xiishopy ERP - Forex Route Handler
 * /api/v1/forex
 * Manages live currency exchange rates, conversion, and rate history.
 */

import { Router, Response } from 'express';
import { AuthenticatedRequest } from '../middleware/auth-guard';
import { HTTP_STATUS, CurrencyCode, CURRENCY_SYMBOLS } from '../config/constants';
import { streamForexRates, convertCurrency, generateSimulatedRates } from '../services/forex-engine';
import * as admin from 'firebase-admin';

const router = Router();

/**
 * GET /api/v1/forex/rates
 * Get current live forex rates
 */
router.get('/rates', async (_req: AuthenticatedRequest, res: Response) => {
  try {
    const db = admin.firestore();
    const ratesDoc = await db.collection('forex_rates').doc('live').get();

    if (!ratesDoc.exists) {
      // Generate initial rates if none exist
      const rates = generateSimulatedRates();
      await db.collection('forex_rates').doc('live').set(rates);
      res.status(HTTP_STATUS.OK).json({
        success: true,
        data: rates,
        message: 'Initial rates generated',
      });
      return;
    }

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: ratesDoc.data(),
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to fetch forex rates',
      code: 'forex/fetch-error',
    });
  }
});

/**
 * POST /api/v1/forex/refresh
 * Manually trigger a forex rate refresh
 */
router.post('/refresh', async (_req: AuthenticatedRequest, res: Response) => {
  try {
    const rates = await streamForexRates();
    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: rates,
      message: 'Forex rates refreshed',
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to refresh forex rates',
      code: 'forex/refresh-error',
    });
  }
});

/**
 * GET /api/v1/forex/convert
 * Convert USD amount to a target currency
 * Query params: amount, currency
 */
router.get('/convert', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const amount = parseFloat(req.query.amount as string);
    const currency = (req.query.currency as string)?.toUpperCase() as CurrencyCode;

    if (!amount || isNaN(amount) || amount <= 0) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: 'Invalid amount. Must be a positive number.',
        code: 'validation/invalid-amount',
      });
      return;
    }

    if (!currency || !CURRENCY_SYMBOLS[currency]) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: `Invalid currency. Supported: ${Object.keys(CURRENCY_SYMBOLS).join(', ')}`,
        code: 'validation/invalid-currency',
      });
      return;
    }

    const result = await convertCurrency(amount, currency);
    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: result,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: error instanceof Error ? error.message : 'Conversion failed',
      code: 'forex/convert-error',
    });
  }
});

/**
 * GET /api/v1/forex/symbols
 * Get supported currency symbols
 */
router.get('/symbols', (_req: AuthenticatedRequest, res: Response) => {
  res.status(HTTP_STATUS.OK).json({
    success: true,
    data: CURRENCY_SYMBOLS,
  });
});

export default router;