"use strict";
/**
 * Xiishopy ERP - Forex Route Handler
 * /api/v1/forex
 * Manages live currency exchange rates, conversion, and rate history.
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
const forex_engine_1 = require("../services/forex-engine");
const admin = __importStar(require("firebase-admin"));
const router = (0, express_1.Router)();
/**
 * GET /api/v1/forex/rates
 * Get current live forex rates
 */
router.get('/rates', async (_req, res) => {
    try {
        const db = admin.firestore();
        const ratesDoc = await db.collection('forex_rates').doc('live').get();
        if (!ratesDoc.exists) {
            // Generate initial rates if none exist
            const rates = (0, forex_engine_1.generateSimulatedRates)();
            await db.collection('forex_rates').doc('live').set(rates);
            res.status(constants_1.HTTP_STATUS.OK).json({
                success: true,
                data: rates,
                message: 'Initial rates generated',
            });
            return;
        }
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: ratesDoc.data(),
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
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
router.post('/refresh', async (_req, res) => {
    try {
        const rates = await (0, forex_engine_1.streamForexRates)();
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: rates,
            message: 'Forex rates refreshed',
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
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
router.get('/convert', async (req, res) => {
    var _a;
    try {
        const amount = parseFloat(req.query.amount);
        const currency = (_a = req.query.currency) === null || _a === void 0 ? void 0 : _a.toUpperCase();
        if (!amount || isNaN(amount) || amount <= 0) {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
                success: false,
                error: 'Invalid amount. Must be a positive number.',
                code: 'validation/invalid-amount',
            });
            return;
        }
        if (!currency || !constants_1.CURRENCY_SYMBOLS[currency]) {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
                success: false,
                error: `Invalid currency. Supported: ${Object.keys(constants_1.CURRENCY_SYMBOLS).join(', ')}`,
                code: 'validation/invalid-currency',
            });
            return;
        }
        const result = await (0, forex_engine_1.convertCurrency)(amount, currency);
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: result,
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
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
router.get('/symbols', (_req, res) => {
    res.status(constants_1.HTTP_STATUS.OK).json({
        success: true,
        data: constants_1.CURRENCY_SYMBOLS,
    });
});
exports.default = router;
//# sourceMappingURL=forex.js.map