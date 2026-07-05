/**
 * Xiishopy ERP - Dynamic Forex & Currency Matrix Engine
 * Streams live currency exchange rates to the forex_rates collection.
 * Clients listen to .snapshots() on forex_rates to update pricing in real-time.
 */
import { CurrencyCode } from '../config/constants';
interface ForexRate {
    base: 'USD';
    rates: Record<CurrencyCode, number>;
    lastUpdated: string;
    source: string;
}
/**
 * Generate simulated live rates with slight random fluctuations.
 * Called by the traffic simulator or a scheduled cloud function.
 */
export declare function generateSimulatedRates(): ForexRate;
/**
 * Write new rates to Firestore, triggering snapshot listeners.
 */
export declare function streamForexRates(): Promise<ForexRate>;
/**
 * Convert USD amount to target currency using current live rates.
 */
export declare function convertCurrency(usdAmount: number, targetCurrency: CurrencyCode): Promise<{
    usdAmount: number;
    localAmount: number;
    currency: CurrencyCode;
    rate: number;
}>;
export {};
