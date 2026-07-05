/**
 * Xiishopy ERP - App-wide Constants & Enums
 * Defines all shared types, enums, and configuration constants.
 */

// ============ Role & Region Enums ============
export enum UserRole {
  DISTRIBUTOR = 'distributor',
  RETAILER = 'retailer',
}

export enum Country {
  KENYA = 'KE',
  TANZANIA = 'TZ',
  UGANDA = 'UG',
  RWANDA = 'RW',
}

export enum Language {
  ENGLISH = 'en',
  SWAHILI = 'sw',
  LUGANDA = 'lg',
  FRENCH = 'fr',
}

// ============ Payment & Order Enums ============
export enum PaymentProvider {
  MPESA = 'mpesa',
  AIRTEL_MONEY = 'airtel_money',
  SELCOM = 'selcom',
  PESAPAL = 'pesapal',
}

export enum PaymentStatus {
  PENDING = 'pending',
  PROCESSING = 'processing',
  COMPLETED = 'completed',
  FAILED = 'failed',
  REFUNDED = 'refunded',
}

export enum OrderStatus {
  PENDING = 'pending',
  PAID = 'paid',
  PROCESSING = 'processing',
  SHIPPED = 'shipped',
  DELIVERED = 'delivered',
  CANCELLED = 'cancelled',
}

export enum ShipmentStatus {
  PICKED_UP = 'Picked up',
  IN_TRANSIT = 'In Transit',
  OUT_FOR_DELIVERY = 'Out for Delivery',
  DELIVERED = 'Delivered',
  EXCEPTION = 'Exception',
}

export enum Carrier {
  DHL_AFRICA = 'dhl_africa',
  SENDY = 'sendy',
  AMIT_TRUCKING = 'amit_trucking',
}

// ============ Currency Types ============
export type CurrencyCode = 'USD' | 'KES' | 'TZS' | 'UGX' | 'RWF';

export const CURRENCY_SYMBOLS: Record<CurrencyCode, string> = {
  USD: '$',
  KES: 'KSh',
  TZS: 'TSh',
  UGX: 'USh',
  RWF: 'FRw',
};

export const SUPPORTED_CURRENCIES: CurrencyCode[] = ['USD', 'KES', 'TZS', 'UGX', 'RWF'];

// ============ API Configuration ============
export const API_PREFIX = '/api/v1';

export const API_ROUTES = {
  PAYMENTS: '/payments',
  LOGISTICS: '/logistics',
  FOREX: '/forex',
  AI: '/ai',
  PRODUCTS: '/products',
  ORDERS: '/orders',
  USERS: '/users',
} as const;

export const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  ACCEPTED: 202,
  NO_CONTENT: 204,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  UNPROCESSABLE: 422,
  TOO_MANY_REQUESTS: 429,
  INTERNAL_ERROR: 500,
} as const;

// ============ Localization Map (English/Swahili/Luganda/French) ============
export const LOCALIZATION_MAP: Record<string, Record<string, string>> = {
  'app.name': {
    en: 'Xiishopy ERP',
    sw: 'Xiishopy ERP',
    lg: 'Xiishopy ERP',
    fr: 'Xiishopy ERP',
  },
  'order.status.pending': {
    en: 'Pending',
    sw: 'Inasubiri',
    lg: 'Ekuyimirira',
    fr: 'En attente',
  },
  'order.status.paid': {
    en: 'Paid',
    sw: 'Imelipwa',
    lg: 'Ekuguziddwa',
    fr: 'Payé',
  },
  'order.status.shipped': {
    en: 'Shipped',
    sw: 'Imesafirishwa',
    lg: 'Ekuyisibwa',
    fr: 'Expédié',
  },
  'order.status.delivered': {
    en: 'Delivered',
    sw: 'Imefikishwa',
    lg: 'Ekuweerezeddwa',
    fr: 'Livré',
  },
  'payment.status.completed': {
    en: 'Completed',
    sw: 'Imekamilika',
    lg: 'Ekumalirira',
    fr: 'Terminé',
  },
  'payment.status.failed': {
    en: 'Failed',
    sw: 'Imeshindwa',
    lg: 'Tekukola',
    fr: 'Échoué',
  },
  'product.stock.low': {
    en: 'Low Stock',
    sw: 'Hesabu Ndogo',
    lg: 'Ettaba Ntono',
    fr: 'Stock Faible',
  },
  'product.stock.out': {
    en: 'Out of Stock',
    sw: 'Hakuna Hisa',
    lg: 'Tebuliimu',
    fr: 'Rupture de Stock',
  },
  'tracking.in_transit': {
    en: 'In Transit',
    sw: 'Inasafiri',
    lg: 'Ekuyisiye',
    fr: 'En transit',
  },
  'tracking.out_for_delivery': {
    en: 'Out for Delivery',
    sw: 'Imetoka kufikishwa',
    lg: 'Ekuweerezebwa',
    fr: 'En cours de livraison',
  },
  'dashboard.revenue': {
    en: 'Revenue',
    sw: 'Mapato',
    lg: 'Enfuna',
    fr: 'Revenu',
  },
  'dashboard.orders': {
    en: 'Orders',
    sw: 'Maagizo',
    lg: 'Ebiragiro',
    fr: 'Commandes',
  },
  'dashboard.inventory': {
    en: 'Inventory',
    sw: 'Hesabu',
    lg: 'Ettaba',
    fr: 'Inventaire',
  },
  'dashboard.forex': {
    en: 'Exchange Rates',
    sw: 'Viwango vya Fedha',
    lg: 'Enkyusa y’Eby’obugagga',
    fr: 'Taux de change',
  },
};