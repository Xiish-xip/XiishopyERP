/**
 * Xiishopy ERP - Cloud Functions Entry Point
 * Express.js API Server with modular routing for the real-time backend.
 * Deployed as Firebase Cloud Functions for the local emulator suite.
 */

import * as functions from 'firebase-functions';
import express from 'express';
import cors from 'cors';
import { initializeFirebaseAdmin } from './config/firebase-admin';
import { API_PREFIX, HTTP_STATUS } from './config/constants';
import { errorHandler } from './middleware/error-handler';
import { authGuard } from './middleware/auth-guard';

// ============ Initialize Firebase Admin SDK ============
initializeFirebaseAdmin();

// ============ Express Application Setup ============
const app = express();

// Global Middleware
app.use(cors({ origin: true }));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Health check endpoint (no auth required)
app.get('/health', (_req, res) => {
  res.status(HTTP_STATUS.OK).json({
    status: 'healthy',
    service: 'xiishopy-erp-api',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
    emulatorMode: process.env.FIREBASE_EMULATOR_HUB ? true : false,
  });
});

// API Status endpoint
app.get(`${API_PREFIX}/status`, (_req, res) => {
  res.status(HTTP_STATUS.OK).json({
    success: true,
    message: 'Xiishopy ERP API operational',
    version: '1.0.0',
    endpoints: {
      payments: `${API_PREFIX}/payments`,
      logistics: `${API_PREFIX}/logistics`,
      forex: `${API_PREFIX}/forex`,
      ai: `${API_PREFIX}/ai`,
      products: `${API_PREFIX}/products`,
      orders: `${API_PREFIX}/orders`,
      users: `${API_PREFIX}/users`,
    },
  });
});

// ============ Mount Routes (all protected by auth) ============
import paymentsRouter from './routes/payments';
import logisticsRouter from './routes/logistics';
import forexRouter from './routes/forex';
import aiRouter from './routes/ai';
import productsRouter from './routes/products';
import ordersRouter from './routes/orders';
import usersRouter from './routes/users';
import adminRouter from './routes/admin';

app.use(`${API_PREFIX}/payments`, authGuard, paymentsRouter);
app.use(`${API_PREFIX}/logistics`, authGuard, logisticsRouter);
app.use(`${API_PREFIX}/forex`, authGuard, forexRouter);
app.use(`${API_PREFIX}/ai`, authGuard, aiRouter);
app.use(`${API_PREFIX}/products`, authGuard, productsRouter);
app.use(`${API_PREFIX}/orders`, authGuard, ordersRouter);
app.use(`${API_PREFIX}/users`, authGuard, usersRouter);
app.use(`${API_PREFIX}/admin`, authGuard, adminRouter);

// ============ Global Error Handler ============
app.use(errorHandler);

// ============ Export as Firebase Cloud Function ============
export const api = functions.https.onRequest(app);

// Export individual callable functions for direct client SDK usage
export { processPaymentWebhook } from './services/payment-engine';
export { updateShipmentStatus } from './services/logistics-engine';
export { streamForexRates } from './services/forex-engine';
export { translateText } from './services/localization-engine';
export { predictDemand } from './services/ai-inventory';
export { parseInvoice } from './services/ai-ocr';