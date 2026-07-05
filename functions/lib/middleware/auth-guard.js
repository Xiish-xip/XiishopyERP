"use strict";
/**
 * Xiishopy ERP - Firebase Auth Verification Middleware
 * Validates Firebase ID tokens on protected routes.
 * In emulator mode, accepts the demo token or auto-generated test tokens.
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
exports.authGuard = authGuard;
const admin = __importStar(require("firebase-admin"));
const constants_1 = require("../config/constants");
async function authGuard(req, res, next) {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader) {
            res.status(constants_1.HTTP_STATUS.UNAUTHORIZED).json({
                success: false,
                error: 'Authorization header is required',
                code: 'auth/missing-token',
            });
            return;
        }
        const tokenParts = authHeader.split(' ');
        if (tokenParts.length !== 2 || tokenParts[0] !== 'Bearer') {
            res.status(constants_1.HTTP_STATUS.UNAUTHORIZED).json({
                success: false,
                error: 'Authorization header must be in format: Bearer <token>',
                code: 'auth/invalid-format',
            });
            return;
        }
        const idToken = tokenParts[1];
        // In emulator mode, also accept the demo project's auto-generated tokens
        try {
            const decodedToken = await admin.auth().verifyIdToken(idToken);
            req.user = decodedToken;
            req.userId = decodedToken.uid;
            next();
        }
        catch (verifyError) {
            // In emulator, allow bypass with specific header for testing
            const isEmulator = process.env.FIREBASE_EMULATOR_HUB !== undefined;
            if (isEmulator && req.headers['x-xiishopy-test-uid']) {
                const testUid = req.headers['x-xiishopy-test-uid'];
                req.userId = testUid;
                req.user = {
                    uid: testUid,
                    aud: 'demo-xiishopy-erp',
                    auth_time: Math.floor(Date.now() / 1000),
                    exp: Math.floor(Date.now() / 1000) + 3600,
                    firebase: { identities: {}, sign_in_provider: 'custom' },
                    iat: Math.floor(Date.now() / 1000),
                    iss: 'https://securetoken.google.com/demo-xiishopy-erp',
                    sub: testUid,
                };
                next();
                return;
            }
            res.status(constants_1.HTTP_STATUS.UNAUTHORIZED).json({
                success: false,
                error: 'Invalid or expired authentication token',
                code: 'auth/invalid-token',
                details: verifyError instanceof Error ? verifyError.message : 'Token verification failed',
            });
        }
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
            success: false,
            error: 'Authentication service error',
            code: 'auth/internal-error',
        });
    }
}
//# sourceMappingURL=auth-guard.js.map