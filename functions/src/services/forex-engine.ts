/**
 * Xiishopy ERP - Dynamic Forex & Currency Matrix Engine
 * Streams live currency exchange rates to the forex_rates collection.
 * Clients listen to .snapshots() on forex_rates to update pricing in real-time.
 */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { CurrencyCode } from '../config/constants';

interface ForexRate {
  base: 'USD';
  rates: Record<CurrencyCode, number>;
  lastUpdated: string;
  source: string;
}

// Base rates (simulated) - these get modulated by the traffic simulator
const BASE_RATES: Record<CurrencyCode, number> = {
  USD: 1.0,
  KES: 150.0,
  TZS: 2500.0,
  UGX: 3700.0,
  RWF: 1300.0,
};

/**
 * Generate simulated live rates with slight random fluctuations.
 * Called by the traffic simulator or a scheduled cloud function.
 */
export function generateSimulatedRates(): ForexRate {
  const now = new Date().toISOString();

  const rates: Record<CurrencyCode, number> = {
    USD: 1.0,
    KES: modulateRate(BASE_RATES.KES, 0.02),
    TZS: modulateRate(BASE_RATES.TZS, 0.03),
    UGX: modulateRate(BASE_RATES.UGX, 0.025),
    RWF: modulateRate(BASE_RATES.RWF, 0.02),
  };

  return {
    base: 'USD',
    rates,
    lastUpdated: now,
    source: 'simulated',
  };
}

function modulateRate(base: number, volatility: number): number {
  const change = (Math.random() - 0.5) * 2 * volatility;
  return parseFloat((base * (1 + change)).toFixed(2));
}

/**
 * Write new rates to Firestore, triggering snapshot listeners.
 */
export async function streamForexRates(): Promise<ForexRate> {
  const db = admin.firestore();
  const rates = generateSimulatedRates();

  await db.collection('forex_rates').doc('live').set(rates);

  functions.logger.info('💰 Forex rates updated', {
    KES: rates.rates.KES,
    TZS: rates.rates.TZS,
    UGX: rates.rates.UGX,
    RWF: rates.rates.RWF,
  });

  return rates;
}

/**
 * Convert USD amount to target currency using current live rates.
 */
export async function convertCurrency(
  usdAmount: number,
  targetCurrency: CurrencyCode
): Promise<{ usdAmount: number; localAmount: number; currency: CurrencyCode; rate: number }> {
  const db = admin.firestore();
  const ratesDoc = await db.collection('forex_rates').doc('live').get();

  if (!ratesDoc.exists) {
    throw new Error('Forex rates not available. Ensure the forex stream is running.');
  }

  const forexData = ratesDoc.data() as ForexRate;
  const rate = forexData.rates[targetCurrency];

  if (!rate) {
    throw new Error(`Unsupported currency: ${targetCurrency}`);
  }

  return {
    usdAmount,
    localAmount: parseFloat((usdAmount * rate).toFixed(2)),
    currency: targetCurrency,
    rate,
  };
}