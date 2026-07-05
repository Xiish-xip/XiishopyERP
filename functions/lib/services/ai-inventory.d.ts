/**
 * Xiishopy ERP - AI Predictive Inventory Restocking
 * Endpoint: /api/v1/ai/predict-demand
 * Simulates a lightweight linear regression algorithm to predict stock depletion
 * based on historical order trends.
 */
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
export declare function predictDemand(input: PredictionInput): Promise<DemandPrediction>;
export {};
