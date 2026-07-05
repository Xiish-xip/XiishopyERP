/// Xiishopy ERP - API Endpoint Definitions
library;

class ApiEndpoints {
  static const String apiPrefix = '/api/v1';
  static const String adminPrefix = '$apiPrefix/admin';
  static const String analyticsPrefix = '$apiPrefix/analytics';

  // Health & Status
  static const String health = '/health';
  static const String status = '$apiPrefix/status';

  // Auth
  static const String login = '$apiPrefix/auth/login';
  static const String register = '$apiPrefix/auth/register';
  static const String logout = '$apiPrefix/auth/logout';
  static const String refreshToken = '$apiPrefix/auth/refresh';
  static const String forgotPassword = '$apiPrefix/auth/forgot-password';
  static const String resetPassword = '$apiPrefix/auth/reset-password';
  static const String profile = '$apiPrefix/auth/profile';

  // Products
  static const String products = '$apiPrefix/products';
  static String productDetail(String id) => '$apiPrefix/products/$id';
  static const String productsImport = '$apiPrefix/products/import';
  static const String productsExport = '$apiPrefix/products/export';
  static const String productsBarcodes = '$apiPrefix/products/barcodes';

  // Orders
  static const String orders = '$apiPrefix/orders';
  static String orderDetail(String id) => '$apiPrefix/orders/$id';
  static const String ordersCreate = '$apiPrefix/orders/create';
  static const String ordersImport = '$apiPrefix/orders/import';

  // Payments
  static const String payments = '$apiPrefix/payments';
  static String paymentDetail(String id) => '$apiPrefix/payments/$id';
  static const String paymentsProcess = '$apiPrefix/payments/process';
  static const String paymentsRefund = '$apiPrefix/payments/refund';
  static const String paymentLinks = '$apiPrefix/payments/links';

  // Logistics
  static const String logistics = '$apiPrefix/logistics';
  static String logisticsDetail(String id) => '$apiPrefix/logistics/$id';
  static const String logisticsTrack = '$apiPrefix/logistics/track';

  // Forex
  static const String forex = '$apiPrefix/forex';
  static const String forexRates = '$apiPrefix/forex/rates';
  static const String forexConvert = '$apiPrefix/forex/convert';

  // AI
  static const String ai = '$apiPrefix/ai';
  static const String aiPredictDemand = '$apiPrefix/ai/predict-demand';
  static const String aiParseInvoice = '$apiPrefix/ai/parse-invoice';
  static const String aiTranslate = '$apiPrefix/ai/translate';

  // Users
  static const String users = '$apiPrefix/users';
  static String userDetail(String id) => '$apiPrefix/users/$id';

  // Admin
  static const String adminConfig = '$adminPrefix/config';
  static String adminModule(String module) => '$adminPrefix/modules/$module';
  static const String adminUsers = '$adminPrefix/users';
  static String adminUserDetail(String id) => '$adminPrefix/users/$id';
  static String adminUserRole(String id) => '$adminPrefix/users/$id/role';
  static String adminUserBan(String id) => '$adminPrefix/users/$id/ban';
  static const String adminAuditLogs = '$adminPrefix/audit-logs';
  static const String adminSettings = '$adminPrefix/settings';
  static const String adminBackupExport = '$adminPrefix/backup/export';
  static const String adminBackupImport = '$adminPrefix/backup/import';
  static const String adminAnalyticsSummary = '$adminPrefix/analytics/summary';
  static const String adminPermissionsMatrix = '$adminPrefix/permissions/matrix';

  // Analytics
  static const String analyticsDashboard = '$analyticsPrefix/dashboard';
  static const String analyticsSalesTrend = '$analyticsPrefix/sales/trend';
  static const String analyticsTopProducts = '$analyticsPrefix/products/top';
  static const String analyticsCustomers = '$analyticsPrefix/customers';
  static const String analyticsInventory = '$analyticsPrefix/inventory';
  static const String analyticsPayments = '$analyticsPrefix/payments';
  static const String analyticsShipments = '$analyticsPrefix/shipments';
  static const String analyticsExport = '$analyticsPrefix/export';
}