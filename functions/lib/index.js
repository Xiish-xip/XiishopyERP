"use strict";
/**
 * Xiishopy ERP - Cloud Functions Entry Point
 * Express.js API Server with modular routing for the real-time backend.
 * Deployed as Firebase Cloud Functions for the local emulator suite.
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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseInvoice = exports.predictDemand = exports.translateText = exports.streamForexRates = exports.updateShipmentStatus = exports.processPaymentWebhook = exports.api = void 0;
const functions = __importStar(require("firebase-functions"));
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const firebase_admin_1 = require("./config/firebase-admin");
const constants_1 = require("./config/constants");
const error_handler_1 = require("./middleware/error-handler");
const auth_guard_1 = require("./middleware/auth-guard");
// ============ Initialize Firebase Admin SDK ============
(0, firebase_admin_1.initializeFirebaseAdmin)();
// ============ Express Application Setup ============
const app = (0, express_1.default)();
// Global Middleware
app.use((0, cors_1.default)({ origin: true }));
app.use(express_1.default.json({ limit: '10mb' }));
app.use(express_1.default.urlencoded({ extended: true }));
// Health check endpoint (no auth required)
app.get('/health', (_req, res) => {
    res.status(constants_1.HTTP_STATUS.OK).json({
        status: 'healthy',
        service: 'xiishopy-erp-api',
        version: '1.0.0',
        timestamp: new Date().toISOString(),
        environment: process.env.NODE_ENV || 'development',
        emulatorMode: process.env.FIREBASE_EMULATOR_HUB ? true : false,
    });
});
// API Status endpoint
app.get(`${constants_1.API_PREFIX}/status`, (_req, res) => {
    res.status(constants_1.HTTP_STATUS.OK).json({
        success: true,
        message: 'Xiishopy ERP API operational',
        version: '1.0.0',
        endpoints: {
            payments: `${constants_1.API_PREFIX}/payments`,
            logistics: `${constants_1.API_PREFIX}/logistics`,
            forex: `${constants_1.API_PREFIX}/forex`,
            ai: `${constants_1.API_PREFIX}/ai`,
            products: `${constants_1.API_PREFIX}/products`,
            orders: `${constants_1.API_PREFIX}/orders`,
            users: `${constants_1.API_PREFIX}/users`,
        },
    });
});
// ============ Mount Routes (all protected by auth) ============
const payments_1 = __importDefault(require("./routes/payments"));
const logistics_1 = __importDefault(require("./routes/logistics"));
const forex_1 = __importDefault(require("./routes/forex"));
const ai_1 = __importDefault(require("./routes/ai"));
const products_1 = __importDefault(require("./routes/products"));
const orders_1 = __importDefault(require("./routes/orders"));
const users_1 = __importDefault(require("./routes/users"));
app.use(`${constants_1.API_PREFIX}/payments`, auth_guard_1.authGuard, payments_1.default);
app.use(`${constants_1.API_PREFIX}/logistics`, auth_guard_1.authGuard, logistics_1.default);
app.use(`${constants_1.API_PREFIX}/forex`, auth_guard_1.authGuard, forex_1.default);
app.use(`${constants_1.API_PREFIX}/ai`, auth_guard_1.authGuard, ai_1.default);
app.use(`${constants_1.API_PREFIX}/products`, auth_guard_1.authGuard, products_1.default);
app.use(`${constants_1.API_PREFIX}/orders`, auth_guard_1.authGuard, orders_1.default);
app.use(`${constants_1.API_PREFIX}/users`, auth_guard_1.authGuard, users_1.default);
// ============ Global Error Handler ============
app.use(error_handler_1.errorHandler);
// ============ Export as Firebase Cloud Function ============
exports.api = functions.https.onRequest(app);
// Export individual callable functions for direct client SDK usage
var payment_engine_1 = require("./services/payment-engine");
Object.defineProperty(exports, "processPaymentWebhook", { enumerable: true, get: function () { return payment_engine_1.processPaymentWebhook; } });
var logistics_engine_1 = require("./services/logistics-engine");
Object.defineProperty(exports, "updateShipmentStatus", { enumerable: true, get: function () { return logistics_engine_1.updateShipmentStatus; } });
var forex_engine_1 = require("./services/forex-engine");
Object.defineProperty(exports, "streamForexRates", { enumerable: true, get: function () { return forex_engine_1.streamForexRates; } });
var localization_engine_1 = require("./services/localization-engine");
Object.defineProperty(exports, "translateText", { enumerable: true, get: function () { return localization_engine_1.translateText; } });
var ai_inventory_1 = require("./services/ai-inventory");
Object.defineProperty(exports, "predictDemand", { enumerable: true, get: function () { return ai_inventory_1.predictDemand; } });
var ai_ocr_1 = require("./services/ai-ocr");
Object.defineProperty(exports, "parseInvoice", { enumerable: true, get: function () { return ai_ocr_1.parseInvoice; } });
//# sourceMappingURL=index.js.map