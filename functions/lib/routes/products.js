"use strict";
/**
 * Xiishopy ERP - Products Route Handler
 * /api/v1/products
 * Product catalog management with stock level tracking.
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
 * GET /api/v1/products
 * List all products (with optional filters)
 */
router.get('/', async (req, res) => {
    try {
        const db = admin.firestore();
        let query = db.collection('products');
        // Filter by category
        if (req.query.category) {
            query = query.where('category', '==', req.query.category);
        }
        // Filter low stock
        if (req.query.lowStock === 'true') {
            query = query.where('stockLevel', '<=', 10);
        }
        // Sort
        const sortBy = req.query.sortBy || 'name';
        const sortOrder = req.query.sortOrder === 'desc' ? 'desc' : 'asc';
        query = query.orderBy(sortBy, sortOrder);
        // Pagination
        const limit = Math.min(parseInt(req.query.limit) || 50, 100);
        query = query.limit(limit);
        const snapshot = await query.get();
        const products = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: products,
            count: products.length,
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
            success: false,
            error: 'Failed to fetch products',
            code: 'products/fetch-error',
        });
    }
});
/**
 * GET /api/v1/products/:id
 * Get a single product by ID
 */
router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const db = admin.firestore();
        const doc = await db.collection('products').doc(id).get();
        if (!doc.exists) {
            res.status(constants_1.HTTP_STATUS.NOT_FOUND).json({
                success: false,
                error: `Product with ID ${id} not found`,
                code: 'products/not-found',
            });
            return;
        }
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: { id: doc.id, ...doc.data() },
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
            success: false,
            error: 'Failed to fetch product',
            code: 'products/fetch-error',
        });
    }
});
/**
 * PATCH /api/v1/products/:id/stock
 * Update product stock level
 */
router.patch('/:id/stock', async (req, res) => {
    try {
        const { id } = req.params;
        const { stockLevel } = req.body;
        if (stockLevel === undefined || typeof stockLevel !== 'number') {
            res.status(constants_1.HTTP_STATUS.BAD_REQUEST).json({
                success: false,
                error: 'stockLevel must be a number',
                code: 'validation/invalid-stock',
            });
            return;
        }
        const db = admin.firestore();
        await db.collection('products').doc(id).update({
            stockLevel: Math.max(0, Math.floor(stockLevel)),
            updatedAt: new Date().toISOString(),
        });
        const updated = await db.collection('products').doc(id).get();
        res.status(constants_1.HTTP_STATUS.OK).json({
            success: true,
            data: { id: updated.id, ...updated.data() },
            message: `Stock level updated to ${Math.max(0, Math.floor(stockLevel))}`,
        });
    }
    catch (error) {
        res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
            success: false,
            error: 'Failed to update stock',
            code: 'products/stock-update-error',
        });
    }
});
exports.default = router;
//# sourceMappingURL=products.js.map