/**
 * Xiishopy ERP - Firebase Auth Verification Middleware
 * Validates Firebase ID tokens on protected routes.
 * In emulator mode, accepts the demo token or auto-generated test tokens.
 */

import { Request, Response, NextFunction } from 'express';
import * as admin from 'firebase-admin';
import { HTTP_STATUS } from '../config/constants';

export interface AuthenticatedRequest extends Request {
  user?: admin.auth.DecodedIdToken;
  userId?: string;
}

export async function authGuard(
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
): Promise<void> {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader) {
      res.status(HTTP_STATUS.UNAUTHORIZED).json({
        success: false,
        error: 'Authorization header is required',
        code: 'auth/missing-token',
      });
      return;
    }

    const tokenParts = authHeader.split(' ');
    if (tokenParts.length !== 2 || tokenParts[0] !== 'Bearer') {
      res.status(HTTP_STATUS.UNAUTHORIZED).json({
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
    } catch (verifyError) {
      // In emulator, allow bypass with specific header for testing
      const isEmulator = process.env.FIREBASE_EMULATOR_HUB !== undefined;

      if (isEmulator && req.headers['x-xiishopy-test-uid']) {
        const testUid = req.headers['x-xiishopy-test-uid'] as string;
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
        } as admin.auth.DecodedIdToken;
        next();
        return;
      }

      res.status(HTTP_STATUS.UNAUTHORIZED).json({
        success: false,
        error: 'Invalid or expired authentication token',
        code: 'auth/invalid-token',
        details: verifyError instanceof Error ? verifyError.message : 'Token verification failed',
      });
    }
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({
      success: false,
      error: 'Authentication service error',
      code: 'auth/internal-error',
    });
  }
}