/**
 * Xiishopy ERP - AI Route Handler
 * /api/v1/ai
 * AI-powered endpoints for inventory prediction and invoice OCR parsing.
 */

import { Router, Response } from 'express';
import { AuthenticatedRequest } from '../middleware/auth-guard';
import { HTTP_STATUS } from '../config/constants';
import { predictDemand } from '../services/ai-inventory';
import { parseInvoice } from '../services/ai-ocr';

const router = Router();

/**
 * POST /api/v1/ai/predict-demand
 * AI Predictive Inventory Restocking
 */
router.post('/predict-demand', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { productId, productName, currentStock, historicalOrders } = req.body;

    if (!productId || currentStock === undefined) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: 'Missing required fields: productId, currentStock',
        code: 'validation/missing-fields',
      });
      return;
    }

    const prediction = await predictDemand({
      productId,
      productName: productName || `Product ${productId}`,
      currentStock: Number(currentStock),
      historicalOrders,
    });

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: prediction,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to generate demand prediction',
      code: 'ai/prediction-error',
    });
  }
});

/**
 * POST /api/v1/ai/parse-invoice
 * AI Smart Receipt OCR Parser
 */
router.post('/parse-invoice', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { imageBase64, fileName, mimeType } = req.body;

    if (!imageBase64) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: 'Missing required field: imageBase64',
        code: 'validation/missing-fields',
      });
      return;
    }

    if (typeof imageBase64 !== 'string' || imageBase64.length < 100) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: 'Invalid imageBase64. Must be a valid base64 string of sufficient length.',
        code: 'validation/invalid-base64',
      });
      return;
    }

    const result = await parseInvoice({
      imageBase64,
      fileName: fileName || 'invoice.png',
      mimeType: mimeType || 'image/png',
    });

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: result,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to parse invoice',
      code: 'ai/ocr-error',
    });
  }
});

/**
 * POST /api/v1/ai/batch-predict
 * Batch demand prediction for multiple products
 */
router.post('/batch-predict', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { products } = req.body;

    if (!products || !Array.isArray(products) || products.length === 0) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: 'Missing or invalid products array',
        code: 'validation/missing-products',
      });
      return;
    }

    const predictions = await Promise.all(
      products.map((product: { productId: string; productName: string; currentStock: number }) =>
        predictDemand({
          productId: product.productId,
          productName: product.productName,
          currentStock: product.currentStock,
        })
      )
    );

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: predictions,
      count: predictions.length,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to generate batch predictions',
      code: 'ai/batch-prediction-error',
    });
  }
});

export default router;