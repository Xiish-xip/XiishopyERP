"use strict";
/**
 * Xiishopy ERP - Global Error Handler Middleware
 * Catches all unhandled errors and returns structured JSON responses.
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
exports.NotFoundError = exports.ValidationError = exports.AppError = void 0;
exports.errorHandler = errorHandler;
const constants_1 = require("../config/constants");
const functions = __importStar(require("firebase-functions"));
class AppError extends Error {
    constructor(message, statusCode, code = 'app/error') {
        super(message);
        this.statusCode = statusCode;
        this.code = code;
        this.isOperational = true;
        Object.setPrototypeOf(this, AppError.prototype);
    }
}
exports.AppError = AppError;
class ValidationError extends AppError {
    constructor(message, fields = {}) {
        super(message, constants_1.HTTP_STATUS.UNPROCESSABLE, 'validation/error');
        this.fields = fields;
        Object.setPrototypeOf(this, ValidationError.prototype);
    }
}
exports.ValidationError = ValidationError;
class NotFoundError extends AppError {
    constructor(resource) {
        super(`${resource} not found`, constants_1.HTTP_STATUS.NOT_FOUND, 'resource/not-found');
        Object.setPrototypeOf(this, NotFoundError.prototype);
    }
}
exports.NotFoundError = NotFoundError;
function errorHandler(err, _req, res, _next) {
    functions.logger.error('Unhandled error:', err);
    if (err instanceof AppError) {
        const response = {
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
    res.status(constants_1.HTTP_STATUS.INTERNAL_ERROR).json({
        success: false,
        error: 'An unexpected error occurred',
        code: 'server/internal-error',
    });
}
//# sourceMappingURL=error-handler.js.map