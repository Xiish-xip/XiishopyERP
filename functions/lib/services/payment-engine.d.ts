/**
 * Xiishopy ERP - Instant Payment Engine
 * Handles real-time payment webhook processing for M-Pesa, Airtel Money, Selcom, Pesapal.
 * Simulates STK Push verification and instant order status updates.
 */
import { PaymentProvider, PaymentStatus } from '../config/constants';
interface PaymentWebhookPayload {
    provider: PaymentProvider;
    transactionId: string;
    phoneNumber: string;
    amount: number;
    currency: string;
    orderId: string;
    status: PaymentStatus;
    metadata?: Record<string, unknown>;
}
interface PaymentResult {
    success: boolean;
    paymentId: string;
    transactionId: string;
    status: PaymentStatus;
    orderId: string;
    amount: number;
    currency: string;
    processedAt: string;
}
/**
 * Process an incoming payment webhook from any payment provider.
 * This is exported as a callable function and also used internally.
 */
export declare function processPaymentWebhook(payload: PaymentWebhookPayload): Promise<PaymentResult>;
/**
 * Simulate an M-Pesa STK Push callback
 * Used by the mock traffic simulator to instantly move orders to 'Paid'
 */
export declare function simulateMpesaPayment(phone: string, amount: number, orderId: string): Promise<PaymentResult>;
export {};
