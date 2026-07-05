/**
 * Xiishopy ERP - Products Route Handler
 * /api/v1/products
 * Product catalog management with stock level tracking.
 */

import { Router, Response } from 'express';
import { AuthenticatedRequest } from '../middleware/auth-guard';
import { HTTP_STATUS } from '../config/constants';
import * as admin from 'firebase-admin';

const router = Router();

/**
 * GET /api/v1/products
 * List all products (with optional filters)
 */
router.get('/', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const db = admin.firestore();
    let query: admin.firestore.Query = db.collection('products');

    // Filter by category
    if (req.query.category) {
      query = query.where('category', '==', req.query.category);
    }

    // Filter low stock
    if (req.query.lowStock === 'true') {
      query = query.where('stockLevel', '<=', 10);
    }

    // Sort
    const sortBy = (req.query.sortBy as string) || 'name';
    const sortOrder = req.query.sortOrder === 'desc' ? 'desc' : 'asc';
    query = query.orderBy(sortBy, sortOrder);

    // Pagination
    const limit = Math.min(parseInt(req.query.limit as string) || 50, 100);
    query = query.limit(limit);

    const snapshot = await query.get();
    const products = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: products,
      count: products.length,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
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
router.get('/:id', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { id } = req.params;
    const db = admin.firestore();
    const doc = await db.collection('products').doc(id).get();

    if (!doc.exists) {
      res.status(HTTP_STATUS.NOT_FOUND).json({
        success: false,
        error: `Product with ID ${id} not found`,
        code: 'products/not-found',
      });
      return;
    }

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: { id: doc.id, ...doc.data() },
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
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
router.patch('/:id/stock', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { stockLevel } = req.body;

    if (stockLevel === undefined || typeof stockLevel !== 'number') {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
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

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: { id: updated.id, ...updated.data() },
      message: `Stock level updated to ${Math.max(0, Math.floor(stockLevel))}`,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to update stock',
      code: 'products/stock-update-error',
    });
  }
});

export default router;