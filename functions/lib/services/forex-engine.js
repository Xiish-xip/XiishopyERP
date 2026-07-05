"use strict";
/**
 * Xiishopy ERP - Dynamic Forex & Currency Matrix Engine
 * Streams live currency exchange rates to the forex_rates collection.
 * Clients listen to .snapshots() on forex_rates to update pricing in real-time.
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
exports.generateSimulatedRates = generateSimulatedRates;
exports.streamForexRates = streamForexRates;
exports.convertCurrency = convertCurrency;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
// Base rates (simulated) - these get modulated by the traffic simulator
const BASE_RATES = {
    USD: 1.0,
    KES: 150.0,
    TZS: 2500.0,
    UGX: 3700.0,
    RWF: 1300.0,
};
/**
 * Generate simulated live rates with slight random fluctuations.
 * Called by the traffic simulator or a scheduled cloud function.
 */
function generateSimulatedRates() {
    const now = new Date().toISOString();
    const rates = {
        USD: 1.0,
        KES: modulateRate(BASE_RATES.KES, 0.02),
        TZS: modulateRate(BASE_RATES.TZS, 0.03),
        UGX: modulateRate(BASE_RATES.UGX, 0.025),
        RWF: modulateRate(BASE_RATES.RWF, 0.02),
    };
    return {
        base: 'USD',
        rates,
        lastUpdated: now,
        source: 'simulated',
    };
}
function modulateRate(base, volatility) {
    const change = (Math.random() - 0.5) * 2 * volatility;
    return parseFloat((base * (1 + change)).toFixed(2));
}
/**
 * Write new rates to Firestore, triggering snapshot listeners.
 */
async function streamForexRates() {
    const db = admin.firestore();
    const rates = generateSimulatedRates();
    await db.collection('forex_rates').doc('live').set(rates);
    functions.logger.info('💰 Forex rates updated', {
        KES: rates.rates.KES,
        TZS: rates.rates.TZS,
        UGX: rates.rates.UGX,
        RWF: rates.rates.RWF,
    });
    return rates;
}
/**
 * Convert USD amount to target currency using current live rates.
 */
async function convertCurrency(usdAmount, targetCurrency) {
    const db = admin.firestore();
    const ratesDoc = await db.collection('forex_rates').doc('live').get();
    if (!ratesDoc.exists) {
        throw new Error('Forex rates not available. Ensure the forex stream is running.');
    }
    const forexData = ratesDoc.data();
    const rate = forexData.rates[targetCurrency];
    if (!rate) {
        throw new Error(`Unsupported currency: ${targetCurrency}`);
    }
    return {
        usdAmount,
        localAmount: parseFloat((usdAmount * rate).toFixed(2)),
        currency: targetCurrency,
        rate,
    };
}
//# sourceMappingURL=forex-engine.js.map