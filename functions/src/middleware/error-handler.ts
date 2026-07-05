/**
 * Xiishopy ERP - Global Error Handler Middleware
 * Catches all unhandled errors and returns structured JSON responses.
 */

import { Request, Response, NextFunction } from 'express';
import { HTTP_STATUS } from '../config/constants';
import * as functions from 'firebase-functions';

export class AppError extends Error {
  public readonly statusCode: number;
  public readonly code: string;
  public readonly isOperational: boolean;

  constructor(message: string, statusCode: number, code: string = 'app/error') {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
    this.isOperational = true;
    Object.setPrototypeOf(this, AppError.prototype);
  }
}

export class ValidationError extends AppError {
  public readonly fields: Record<string, string[]>;

  constructor(message: string, fields: Record<string, string[]> = {}) {
    super(message, HTTP_STATUS.UNPROCESSABLE, 'validation/error');
    this.fields = fields;
    Object.setPrototypeOf(this, ValidationError.prototype);
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string) {
    super(`${resource} not found`, HTTP_STATUS.NOT_FOUND, 'resource/not-found');
    Object.setPrototypeOf(this, NotFoundError.prototype);
  }
}

export function errorHandler(
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction
): void {
  functions.logger.error('Unhandled error:', err);

  if (err instanceof AppError) {
    const response: Record<string, unknown> = {
      success: false,
      error: err.message,
      code: err.code,
    };
    if (err instanceof ValidationError && Object.keys(err.fields).length > 0) {
      response.fields = err.fields;
    }
    res.status(err.statusCode).json(response);
    return;
  }

  // Unknown errors
  res.status(HTTP_STATUS.INTERNAL_ERROR).json({
    success: false,
    error: 'An unexpected error occurred',
    code: 'server/internal-error',
  });
}