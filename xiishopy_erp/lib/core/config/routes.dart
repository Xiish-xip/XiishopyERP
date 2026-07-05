/// Xiishopy ERP - Route Configuration
/// Centralized route definitions using GoRouter for declarative navigation.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Auth screens
import '../../app.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';

// Dashboard screens
// (Dashboard is in app.dart currently)

// Products screens
import '../../features/products/presentation/screens/products_list_screen.dart';
import '../../features/products/presentation/screens/product_detail_screen.dart';

// Orders screens
import '../../features/orders/presentation/screens/orders_list_screen.dart';
import '../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../features/orders/presentation/screens/create_order_screen.dart';

// Payments screens
import '../../features/payments/payments_screen.dart';
import '../../features/payments/presentation/screens/payment_detail_screen.dart';

// Logistics screens
import '../../features/logistics/logistics_screen.dart';
import '../../features/logistics/presentation/screens/shipment_detail_screen.dart';

// Customers
import '../../features/customers/customers_screen.dart';

// Analytics
import '../../features/analytics/analytics_screen.dart';

// Admin
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';

// HR
import '../../features/hr/presentation/screens/hr_screen.dart';

// Suppliers
import '../../features/suppliers/presentation/screens/suppliers_screen.dart';

// Purchases
import '../../features/purchases/presentation/screens/purchases_screen.dart';

// Expenses
import '../../features/expenses/presentation/screens/expenses_screen.dart';

// Assets
import '../../features/assets/presentation/screens/assets_screen.dart';

// Projects
import '../../features/projects/presentation/screens/projects_screen.dart';

// Settings
import '../../features/settings/presentation/screens/settings_screen.dart';

// CRM
import '../../features/crm/presentation/screens/crm_screen.dart';

// Accounting
import '../../features/accounting/presentation/screens/accounting_screen.dart';

// Tax
import '../../features/tax/presentation/screens/tax_screen.dart';

// Manufacturing
import '../../features/manufacturing/presentation/screens/manufacturing_screen.dart';

// DMS
import '../../features/dms/presentation/screens/dms_screen.dart';

/// Route path constants
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String createOrder = '/orders/create';
  static const String payments = '/payments';
  static const String paymentDetail = '/payments/:id';
  static const String logistics = '/logistics';
  static const String shipmentDetail = '/logistics/:id';
  static const String customers = '/customers';
  static const String analytics = '/analytics';
  static const String admin = '/admin';
  static const String hr = '/hr';
  static const String suppliers = '/suppliers';
  static const String purchases = '/purchases';
  static const String expenses = '/expenses';
  static const String assets = '/assets';
  static const String projects = '/projects';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String crm = '/crm';
  static const String accounting = '/accounting';
  static const String tax = '/tax';
  static const String manufacturing = '/manufacturing';
  static const String dms = '/dms';
}

/// GoRouter configuration
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const RegisterScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const DistributorDashboard(),
    ),
    GoRoute(
      path: AppRoutes.products,
      builder: (context, state) => const ProductsListScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) => ProductDetailScreen(
            productId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.orders,
      builder: (context, state) => const OrdersListScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) => OrderDetailScreen(
            orderId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: 'create',
          builder: (context, state) => const CreateOrderScreen(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.payments,
      builder: (context, state) => const PaymentsScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) => PaymentDetailScreen(
            paymentId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.logistics,
      builder: (context, state) => const LogisticsScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) => ShipmentDetailScreen(
            shipmentId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.customers,
      builder: (context, state) => const CustomersScreen(),
    ),
    GoRoute(
      path: AppRoutes.analytics,
      builder: (context, state) => const AnalyticsScreen(),
    ),
    GoRoute(
      path: AppRoutes.admin,
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.hr,
      builder: (context, state) => const HrScreen(),
    ),
    GoRoute(
      path: AppRoutes.suppliers,
      builder: (context, state) => const SuppliersScreen(),
    ),
    GoRoute(
      path: AppRoutes.purchases,
      builder: (context, state) => const PurchasesScreen(),
    ),
    GoRoute(
      path: AppRoutes.expenses,
      builder: (context, state) => const ExpensesScreen(),
    ),
    GoRoute(
      path: AppRoutes.assets,
      builder: (context, state) => const AssetsScreen(),
    ),
    GoRoute(
      path: AppRoutes.projects,
      builder: (context, state) => const ProjectsScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.crm,
      builder: (context, state) => const CrmScreen(),
    ),
    GoRoute(
      path: AppRoutes.accounting,
      builder: (context, state) => const AccountingScreen(),
    ),
    GoRoute(
      path: AppRoutes.tax,
      builder: (context, state) => const TaxScreen(),
    ),
    GoRoute(
      path: AppRoutes.manufacturing,
      builder: (context, state) => const ManufacturingScreen(),
    ),
    GoRoute(
      path: AppRoutes.dms,
      builder: (context, state) => const DmsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: const Color(0xFF1A1A2E),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            'Page Not Found',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            state.error?.message ?? 'The requested page does not exist',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.dashboard),
            child: const Text('Go to Dashboard'),
          ),
        ],
      ),
    ),
  ),
);

extension GoRouterExtension on GoRouter {
  /// Navigate to a route and replace
  void replace(String location) => go(location, extra: null);
}