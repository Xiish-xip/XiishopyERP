/**
 * Xiishopy ERP - Cloud Functions Entry Point
 * Express.js API Server with modular routing for the real-time backend.
 * Deployed as Firebase Cloud Functions for the local emulator suite.
 */
import * as functions from 'firebase-functions';
export declare const api: functions.HttpsFunction;
export { processPaymentWebhook } from './services/payment-engine';
export { updateShipmentStatus } from './services/logistics-engine';
export { streamForexRates } from './services/forex-engine';
export { translateText } from './services/localization-engine';
export { predictDemand } from './services/ai-inventory';
export { parseInvoice } from './services/ai-ocr';
