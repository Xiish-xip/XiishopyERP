"use strict";
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
exports.getStorage = exports.getAuth = exports.getFirestore = void 0;
exports.initializeFirebaseAdmin = initializeFirebaseAdmin;
const admin = __importStar(require("firebase-admin"));
const functions = __importStar(require("firebase-functions"));
/**
 * Xiishopy ERP - Firebase Admin SDK Initialization
 * Detects emulator environment and configures locally accordingly.
 */
function initializeFirebaseAdmin() {
    if (admin.apps.length > 0) {
        return; // Already initialized
    }
    const app = admin.initializeApp({
        projectId: 'demo-xiishopy-erp',
    });
    // Detect emulator environment from FIREBASE_EMULATOR_HUB or functions config
    const isEmulator = process.env.FIREBASE_EMULATOR_HUB !== undefined ||
        process.env.FUNCTIONS_EMULATOR === 'true' ||
        process.env.FIRESTORE_EMULATOR_HOST !== undefined;
    if (isEmulator) {
        functions.logger.info('🔥 Running in Firebase Emulator mode');
        // Firestore emulator
        if (process.env.FIRESTORE_EMULATOR_HOST) {
            // Already auto-configured by firebase-functions
        }
        // Auth emulator
        process.env.FIREBASE_AUTH_EMULATOR_HOST = '127.0.0.1:9099';
        // Storage emulator
        process.env.FIREBASE_STORAGE_EMULATOR_HOST = '127.0.0.1:9199';
    }
    // Enable logging
    functions.logger.info('✅ Firebase Admin SDK initialized', {
        projectId: app.options.projectId,
        isEmulator,
    });
}
// Singleton instances
const getFirestore = () => {
    return admin.firestore();
};
exports.getFirestore = getFirestore;
const getAuth = () => {
    return admin.auth();
};
exports.getAuth = getAuth;
const getStorage = () => {
    return admin.storage();
};
exports.getStorage = getStorage;
exports.default = admin;
//# sourceMappingURL=firebase-admin.js.map