/**
 * Xiishopy ERP - Global Error Handler Middleware
 * Catches all unhandled errors and returns structured JSON responses.
 */
import { Request, Response, NextFunction } from 'express';
export declare class AppError extends Error {
    readonly statusCode: number;
    readonly code: string;
    readonly isOperational: boolean;
    constructor(message: string, statusCode: number, code?: string);
}
export declare class ValidationError extends AppError {
    readonly fields: Record<string, string[]>;
    constructor(message: string, fields?: Record<string, string[]>);
}
export declare class NotFoundError extends AppError {
    constructor(resource: string);
}
export declare function errorHandler(err: Error, _req: Request, res: Response, _next: NextFunction): void;
