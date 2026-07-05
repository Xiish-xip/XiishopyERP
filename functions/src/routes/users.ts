/**
 * Xiishopy ERP - Users Route Handler
 * /api/v1/users
 * User profile management, registration, and preferences.
 */

import { Router, Response } from 'express';
import { AuthenticatedRequest } from '../middleware/auth-guard';
import { HTTP_STATUS, UserRole, Country, Language } from '../config/constants';
import * as admin from 'firebase-admin';

const router = Router();

/**
 * GET /api/v1/users/me
 * Get authenticated user's profile
 */
router.get('/me', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const db = admin.firestore();
    const userDoc = await db.collection('users').doc(req.userId!).get();

    if (!userDoc.exists) {
      res.status(HTTP_STATUS.NOT_FOUND).json({
        success: false,
        error: 'User profile not found',
        code: 'users/not-found',
      });
      return;
    }

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: { uid: userDoc.id, ...userDoc.data() },
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
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
router.put('/me', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { companyName, role, country, language, phoneNumber } = req.body;

    if (!companyName || !role) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: 'Missing required fields: companyName, role',
        code: 'validation/missing-fields',
      });
      return;
    }

    // Validate role
    const validRoles = Object.values(UserRole);
    if (!validRoles.includes(role)) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: `Invalid role. Must be one of: ${validRoles.join(', ')}`,
        code: 'validation/invalid-role',
      });
      return;
    }

    // Validate country
    const validCountries = Object.values(Country);
    if (country && !validCountries.includes(country)) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: `Invalid country. Must be one of: ${validCountries.join(', ')}`,
        code: 'validation/invalid-country',
      });
      return;
    }

    // Validate language
    const validLanguages = Object.values(Language);
    if (language && !validLanguages.includes(language)) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
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
      country: country || Country.KENYA,
      language: language || Language.ENGLISH,
      phoneNumber: phoneNumber || '',
      balance: 0,
      updatedAt: new Date().toISOString(),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await db.collection('users').doc(req.userId!).set(userData, { merge: true });

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: userData,
      message: 'Profile updated successfully',
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
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
router.patch('/me/language', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { language } = req.body;

    const validLanguages = Object.values(Language);
    if (!language || !validLanguages.includes(language)) {
      res.status(HTTP_STATUS.BAD_REQUEST).json({
        success: false,
        error: `Invalid language. Must be one of: ${validLanguages.join(', ')}`,
        code: 'validation/invalid-language',
      });
      return;
    }

    const db = admin.firestore();
    await db.collection('users').doc(req.userId!).update({
      language,
      updatedAt: new Date().toISOString(),
    });

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: { uid: req.userId, language },
      message: `Language preference updated to ${language}`,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
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
router.get('/distributors', async (_req: AuthenticatedRequest, res: Response) => {
  try {
    const db = admin.firestore();
    const snapshot = await db.collection('users')
      .where('role', '==', UserRole.DISTRIBUTOR)
      .select('uid', 'companyName', 'country', 'language')
      .get();

    const distributors = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: distributors,
      count: distributors.length,
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Failed to fetch distributors',
      code: 'users/fetch-distributors-error',
    });
  }
});

export default router;