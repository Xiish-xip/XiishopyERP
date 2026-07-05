/**
 * Xiishopy ERP - AI Predictive Inventory Restocking
 * Endpoint: /api/v1/ai/predict-demand
 * Simulates a lightweight linear regression algorithm to predict stock depletion
 * based on historical order trends.
 */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

interface HistoricalOrder {
  date: string;
  quantity: number;
  productId: string;
}

interface DemandPrediction {
  productId: string;
  productName: string;
  currentStock: number;
  predictedDailyDemand: number;
  daysUntilStockout: number;
  recommendedRestockQuantity: number;
  confidence: number;
  forecastDays: {
    day: number;
    predictedQuantity: number;
  }[];
  generatedAt: string;
}

interface PredictionInput {
  productId: string;
  productName: string;
  currentStock: number;
  historicalOrders?: HistoricalOrder[];
}

/**
 * Simulated linear regression for demand prediction.
 * Uses weighted moving average to predict daily demand, then computes stockout timeline.
 */
export async function predictDemand(input: PredictionInput): Promise<DemandPrediction> {
  const db = admin.firestore();
  const { productId, productName, currentStock, historicalOrders } = input;

  functions.logger.info(`🤖 AI Demand Prediction for ${productName}`, {
    productId,
    currentStock,
  });

  // If no historical data provided, fetch from Firestore
  let orderData = historicalOrders;

  if (!orderData || orderData.length === 0) {
    const ordersSnap = await db.collection('orders')
      .where('status', 'in', ['paid', 'shipped', 'delivered'])
      .get();

    // Extract product quantities from orders (simplified simulation)
    // In production, this would parse order line items
    orderData = [];
    ordersSnap.forEach((doc) => {
      const data = doc.data();
      if (data.totalAmountUSD) {
        // Simulate historical demand correlation
        orderData!.push({
          date: data.createdAt || data.updatedAt || new Date().toISOString(),
          quantity: Math.round(data.totalAmountUSD / 50), // Assume ~$50 per unit
          productId: data.productId || productId,
        });
      }
    });
  }

  // SIMULATED LINEAR REGRESSION:
  // Use historical data to calculate a trend, with noise for realism
  const weightedSum = orderData.reduce((sum, order) => sum + order.quantity, 0);
  const totalOrders = Math.max(orderData.length, 1);

  // Predicted daily demand (weighted moving average with trend adjustment)
  const baseDemand = weightedSum / totalOrders;
  const trendFactor = 0.95 + (Math.random() * 0.1); // Slight random trend
  const predictedDailyDemand = parseFloat((baseDemand * trendFactor).toFixed(1));

  // Days until stock runs out
  const daysUntilStockout = predictedDailyDemand > 0
    ? Math.max(0, Math.floor(currentStock / predictedDailyDemand))
    : 30;

  // Recommended restock (30-day supply with safety buffer)
  const recommendedRestockQuantity = Math.ceil(predictedDailyDemand * 30 * 1.15);

  // Generate forecast for next 7 days
  const forecastDays = [];
  for (let day = 1; day <= 7; day++) {
    const dailyVariation = 0.9 + (Math.random() * 0.2);
    forecastDays.push({
      day,
      predictedQuantity: parseFloat((predictedDailyDemand * dailyVariation).toFixed(1)),
    });
  }

  // Confidence: higher with more historical data
  const confidence = parseFloat(Math.min(0.95, Math.max(0.3, orderData.length / 20)).toFixed(2));

  const prediction: DemandPrediction = {
    productId,
    productName,
    currentStock,
    predictedDailyDemand,
    daysUntilStockout,
    recommendedRestockQuantity,
    confidence,
    forecastDays,
    generatedAt: new Date().toISOString(),
  };

  functions.logger.info(`✅ Prediction complete for ${productName}`, {
    daysUntilStockout: prediction.daysUntilStockout,
    dailyDemand: prediction.predictedDailyDemand,
    confidence: prediction.confidence,
  });

  return prediction;
}

