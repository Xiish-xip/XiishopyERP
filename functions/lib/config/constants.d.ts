/**
 * Xiishopy ERP - App-wide Constants & Enums
 * Defines all shared types, enums, and configuration constants.
 */
export declare enum UserRole {
    DISTRIBUTOR = "distributor",
    RETAILER = "retailer"
}
export declare enum Country {
    KENYA = "KE",
    TANZANIA = "TZ",
    UGANDA = "UG",
    RWANDA = "RW"
}
export declare enum Language {
    ENGLISH = "en",
    SWAHILI = "sw",
    LUGANDA = "lg",
    FRENCH = "fr"
}
export declare enum PaymentProvider {
    MPESA = "mpesa",
    AIRTEL_MONEY = "airtel_money",
    SELCOM = "selcom",
    PESAPAL = "pesapal"
}
export declare enum PaymentStatus {
    PENDING = "pending",
    PROCESSING = "processing",
    COMPLETED = "completed",
    FAILED = "failed",
    REFUNDED = "refunded"
}
export declare enum OrderStatus {
    PENDING = "pending",
    PAID = "paid",
    PROCESSING = "processing",
    SHIPPED = "shipped",
    DELIVERED = "delivered",
    CANCELLED = "cancelled"
}
export declare enum ShipmentStatus {
    PICKED_UP = "Picked up",
    IN_TRANSIT = "In Transit",
    OUT_FOR_DELIVERY = "Out for Delivery",
    DELIVERED = "Delivered",
    EXCEPTION = "Exception"
}
export declare enum Carrier {
    DHL_AFRICA = "dhl_africa",
    SENDY = "sendy",
    AMIT_TRUCKING = "amit_trucking"
}
export type CurrencyCode = 'USD' | 'KES' | 'TZS' | 'UGX' | 'RWF';
export declare const CURRENCY_SYMBOLS: Record<CurrencyCode, string>;
export declare const SUPPORTED_CURRENCIES: CurrencyCode[];
export declare const API_PREFIX = "/api/v1";
export declare const API_ROUTES: {
    readonly PAYMENTS: "/payments";
    readonly LOGISTICS: "/logistics";
    readonly FOREX: "/forex";
    readonly AI: "/ai";
    readonly PRODUCTS: "/products";
    readonly ORDERS: "/orders";
    readonly USERS: "/users";
};
export declare const HTTP_STATUS: {
    readonly OK: 200;
    readonly CREATED: 201;
    readonly ACCEPTED: 202;
    readonly NO_CONTENT: 204;
    readonly BAD_REQUEST: 400;
    readonly UNAUTHORIZED: 401;
    readonly FORBIDDEN: 403;
    readonly NOT_FOUND: 404;
    readonly CONFLICT: 409;
    readonly UNPROCESSABLE: 422;
    readonly TOO_MANY_REQUESTS: 429;
    readonly INTERNAL_ERROR: 500;
};
export declare const LOCALIZATION_MAP: Record<string, Record<string, string>>;
