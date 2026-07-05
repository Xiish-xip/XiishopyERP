/**
 * Xiishopy ERP - Firebase Auth Verification Middleware
 * Validates Firebase ID tokens on protected routes.
 * In emulator mode, accepts the demo token or auto-generated test tokens.
 */
import { Request, Response, NextFunction } from 'express';
import * as admin from 'firebase-admin';
export interface AuthenticatedRequest extends Request {
    user?: admin.auth.DecodedIdToken;
    userId?: string;
}
export declare function authGuard(req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void>;
