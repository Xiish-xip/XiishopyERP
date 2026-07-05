"use strict";
/**
 * Xiishopy ERP - App-wide Constants & Enums
 * Defines all shared types, enums, and configuration constants.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.LOCALIZATION_MAP = exports.HTTP_STATUS = exports.API_ROUTES = exports.API_PREFIX = exports.SUPPORTED_CURRENCIES = exports.CURRENCY_SYMBOLS = exports.Carrier = exports.ShipmentStatus = exports.OrderStatus = exports.PaymentStatus = exports.PaymentProvider = exports.Language = exports.Country = exports.UserRole = void 0;
// ============ Role & Region Enums ============
var UserRole;
(function (UserRole) {
    UserRole["DISTRIBUTOR"] = "distributor";
    UserRole["RETAILER"] = "retailer";
})(UserRole || (exports.UserRole = UserRole = {}));
var Country;
(function (Country) {
    Country["KENYA"] = "KE";
    Country["TANZANIA"] = "TZ";
    Country["UGANDA"] = "UG";
    Country["RWANDA"] = "RW";
})(Country || (exports.Country = Country = {}));
var Language;
(function (Language) {
    Language["ENGLISH"] = "en";
    Language["SWAHILI"] = "sw";
    Language["LUGANDA"] = "lg";
    Language["FRENCH"] = "fr";
})(Language || (exports.Language = Language = {}));
// ============ Payment & Order Enums ============
var PaymentProvider;
(function (PaymentProvider) {
    PaymentProvider["MPESA"] = "mpesa";
    PaymentProvider["AIRTEL_MONEY"] = "airtel_money";
    PaymentProvider["SELCOM"] = "selcom";
    PaymentProvider["PESAPAL"] = "pesapal";
})(PaymentProvider || (exports.PaymentProvider = PaymentProvider = {}));
var PaymentStatus;
(function (PaymentStatus) {
    PaymentStatus["PENDING"] = "pending";
    PaymentStatus["PROCESSING"] = "processing";
    PaymentStatus["COMPLETED"] = "completed";
    PaymentStatus["FAILED"] = "failed";
    PaymentStatus["REFUNDED"] = "refunded";
})(PaymentStatus || (exports.PaymentStatus = PaymentStatus = {}));
var OrderStatus;
(function (OrderStatus) {
    OrderStatus["PENDING"] = "pending";
    OrderStatus["PAID"] = "paid";
    OrderStatus["PROCESSING"] = "processing";
    OrderStatus["SHIPPED"] = "shipped";
    OrderStatus["DELIVERED"] = "delivered";
    OrderStatus["CANCELLED"] = "cancelled";
})(OrderStatus || (exports.OrderStatus = OrderStatus = {}));
var ShipmentStatus;
(function (ShipmentStatus) {
    ShipmentStatus["PICKED_UP"] = "Picked up";
    ShipmentStatus["IN_TRANSIT"] = "In Transit";
    ShipmentStatus["OUT_FOR_DELIVERY"] = "Out for Delivery";
    ShipmentStatus["DELIVERED"] = "Delivered";
    ShipmentStatus["EXCEPTION"] = "Exception";
})(ShipmentStatus || (exports.ShipmentStatus = ShipmentStatus = {}));
var Carrier;
(function (Carrier) {
    Carrier["DHL_AFRICA"] = "dhl_africa";
    Carrier["SENDY"] = "sendy";
    Carrier["AMIT_TRUCKING"] = "amit_trucking";
})(Carrier || (exports.Carrier = Carrier = {}));
exports.CURRENCY_SYMBOLS = {
    USD: '$',
    KES: 'KSh',
    TZS: 'TSh',
    UGX: 'USh',
    RWF: 'FRw',
};
exports.SUPPORTED_CURRENCIES = ['USD', 'KES', 'TZS', 'UGX', 'RWF'];
// ============ API Configuration ============
exports.API_PREFIX = '/api/v1';
exports.API_ROUTES = {
    PAYMENTS: '/payments',
    LOGISTICS: '/logistics',
    FOREX: '/forex',
    AI: '/ai',
    PRODUCTS: '/products',
    ORDERS: '/orders',
    USERS: '/users',
};
exports.HTTP_STATUS = {
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
};
// ============ Localization Map (English/Swahili/Luganda/French) ============
exports.LOCALIZATION_MAP = {
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
//# sourceMappingURL=constants.js.map