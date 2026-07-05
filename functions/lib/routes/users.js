"use strict";
/**
 * Xiishopy ERP - Users Route Handler
 * /api/v1/users
 * User profile management, registration, and preferences.
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
const admin = __importStar(require("firebase-admin"));
const router = (0, express_1.Router)();
/**
 * GET /api/v1/users/me
 * Get authenticated user's profile
 */
router.get('/me', async (req, res) => {
    try {
        const db = admin.firestore();
        const userDoc = await db.collection('users').doc(req.userId).get();
        if (!userDoc.exists) {
            res.status(constants_1.HTTP_STATUS.NOT_FOUND).json({
                success: false,
                error: 'User profile not found',
                code: 'users/not-found',
            });
            return;
        }
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: { uid: userDoc.id, ...userDoc.data() },
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
            success: false,
            error: 'Failed to fetch user profile',
            code: 'users/fetch-error',
        });
    }
});
/**
 * PUT /api/v1/users/me
 * Create or update authenticated user's profile
 */
router.put('/me', async (req, res) => {
    try {
        const { companyName, role, country, language, phoneNumber } = req.body;
        if (!companyName || !role) {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
                success: false,
                error: 'Missing required fields: companyName, role',
                code: 'validation/missing-fields',
            });
            return;
        }
        // Validate role
        const validRoles = Object.values(constants_1.UserRole);
        if (!validRoles.includes(role)) {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
                success: false,
                error: `Invalid role. Must be one of: ${validRoles.join(', ')}`,
                code: 'validation/invalid-role',
            });
            return;
        }
        // Validate country
        const validCountries = Object.values(constants_1.Country);
        if (country && !validCountries.includes(country)) {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
                success: false,
                error: `Invalid country. Must be one of: ${validCountries.join(', ')}`,
                code: 'validation/invalid-country',
            });
            return;
        }
        // Validate language
        const validLanguages = Object.values(constants_1.Language);
        if (language && !validLanguages.includes(language)) {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
                success: false,
                error: `Invalid language. Must be one of: ${validLanguages.join(', ')}`,
                code: 'validation/invalid-language',
            });
            return;
        }
        const db = admin.firestore();
        const userData = {
            uid: req.userId,
            companyName,
            role,
            country: country || constants_1.Country.KENYA,
            language: language || constants_1.Language.ENGLISH,
            phoneNumber: phoneNumber || '',
            balance: 0,
            updatedAt: new Date().toISOString(),
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        };
        await db.collection('users').doc(req.userId).set(userData, { merge: true });
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: userData,
            message: 'Profile updated successfully',
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
            success: false,
            error: 'Failed to update user profile',
            code: 'users/update-error',
        });
    }
});
/**
 * PATCH /api/v1/users/me/language
 * Update user's language preference (real-time localization)
 */
router.patch('/me/language', async (req, res) => {
    try {
        const { language } = req.body;
        const validLanguages = Object.values(constants_1.Language);
        if (!language || !validLanguages.includes(language)) {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
                success: false,
                error: `Invalid language. Must be one of: ${validLanguages.join(', ')}`,
                code: 'validation/invalid-language',
            });
            return;
        }
        const db = admin.firestore();
        await db.collection('users').doc(req.userId).update({
            language,
            updatedAt: new Date().toISOString(),
        });
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: { uid: req.userId, language },
            message: `Language preference updated to ${language}`,
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
            success: false,
            error: 'Failed to update language preference',
            code: 'users/language-update-error',
        });
    }
});
/**
 * GET /api/v1/users/distributors
 * Get list of distributors (for retailer onboarding)
 */
router.get('/distributors', async (_req, res) => {
    try {
        const db = admin.firestore();
        const snapshot = await db.collection('users')
            .where('role', '==', constants_1.UserRole.DISTRIBUTOR)
            .select('uid', 'companyName', 'country', 'language')
            .get();
        const distributors = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: distributors,
            count: distributors.length,
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
            success: false,
            error: 'Failed to fetch distributors',
            code: 'users/fetch-distributors-error',
        });
    }
});
exports.default = router;
//# sourceMappingURL=users.js.map