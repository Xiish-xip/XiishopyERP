/// Xiishopy ERP - Dependency Injection
library;

import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/firebase_service.dart';
import '../network/api_client.dart';
import '../config/remote_config_service.dart';
import '../utils/local_db_service.dart';
import '../services/sync_service.dart';
import '../services/audit_service.dart';
import '../services/notification_service.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/bloc/auth_bloc.dart';

// Products
import '../../features/products/data/datasources/product_remote_datasource.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/bloc/product_bloc.dart';

// Orders
import '../../features/orders/data/datasources/order_remote_datasource.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/orders/bloc/order_bloc.dart';

// Payments
import '../../features/payments/data/datasources/payment_remote_datasource.dart';
import '../../features/payments/data/repositories/payment_repository_impl.dart';
import '../../features/payments/domain/repositories/payment_repository.dart';
import '../../features/payments/bloc/payment_bloc.dart';

// Logistics
import '../../features/logistics/data/datasources/logistics_remote_datasource.dart';
import '../../features/logistics/data/repositories/logistics_repository_impl.dart';
import '../../features/logistics/domain/repositories/logistics_repository.dart';
import '../../features/logistics/bloc/logistics_bloc.dart';

// Customers
import '../../features/customers/data/datasources/customer_remote_datasource.dart';
import '../../features/customers/data/repositories/customer_repository_impl.dart';
import '../../features/customers/domain/repositories/customer_repository.dart';
import '../../features/customers/bloc/customer_bloc.dart';

// Dashboard
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/bloc/dashboard_bloc.dart';

// Admin
import '../../features/admin/data/datasources/admin_remote_datasource.dart';
import '../../features/admin/data/repositories/admin_repository.dart';
import '../../features/admin/bloc/admin_bloc.dart';

// HR
import '../../features/hr/data/datasources/hr_remote_datasource.dart';
import '../../features/hr/data/repositories/hr_repository.dart';
import '../../features/hr/bloc/hr_bloc.dart';

// Suppliers
import '../../features/suppliers/data/datasources/supplier_remote_datasource.dart';
import '../../features/suppliers/data/repositories/supplier_repository.dart';
import '../../features/suppliers/bloc/supplier_bloc.dart';

// Purchases
import '../../features/purchases/data/datasources/purchase_remote_datasource.dart';
import '../../features/purchases/data/repositories/purchase_repository.dart';
import '../../features/purchases/bloc/purchase_bloc.dart';

// Expenses
import '../../features/expenses/data/datasources/expense_remote_datasource.dart';
import '../../features/expenses/data/repositories/expense_repository.dart';
import '../../features/expenses/bloc/expense_bloc.dart';

// Assets
import '../../features/assets/data/datasources/asset_remote_datasource.dart';
import '../../features/assets/data/repositories/asset_repository.dart';
import '../../features/assets/bloc/asset_bloc.dart';

// Projects
import '../../features/projects/data/datasources/project_remote_datasource.dart';
import '../../features/projects/data/repositories/project_repository.dart';
import '../../features/projects/bloc/project_bloc.dart';

// Settings
import '../../features/settings/data/datasources/settings_remote_datasource.dart';
import '../../features/settings/data/repositories/settings_repository.dart';
import '../../features/settings/bloc/settings_bloc.dart';

// CRM
import '../../features/crm/data/datasources/crm_remote_datasource.dart';
import '../../features/crm/data/repositories/crm_repository.dart';
import '../../features/crm/bloc/crm_bloc.dart';

// Accounting
import '../../features/accounting/data/datasources/accounting_remote_datasource.dart';
import '../../features/accounting/data/repositories/accounting_repository.dart';
import '../../features/accounting/bloc/accounting_bloc.dart';

// Tax
import '../../features/tax/data/datasources/tax_remote_datasource.dart';
import '../../features/tax/data/repositories/tax_repository.dart';
import '../../features/tax/bloc/tax_bloc.dart';

// Manufacturing
import '../../features/manufacturing/data/datasources/manufacturing_remote_datasource.dart';
import '../../features/manufacturing/data/repositories/manufacturing_repository.dart';
import '../../features/manufacturing/bloc/manufacturing_bloc.dart';

// DMS
import '../../features/dms/data/datasources/dms_remote_datasource.dart';
import '../../features/dms/data/repositories/dms_repository.dart';
import '../../features/dms/bloc/dms_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core Services
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  sl.registerLazySingleton<FirebaseService>(() => FirebaseService());
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  sl.registerLazySingleton<FirebaseRemoteConfig>(() => FirebaseRemoteConfig.instance);
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Remote Config
  sl.registerLazySingleton<RemoteConfigService>(() => RemoteConfigService(
    remoteConfig: sl<FirebaseRemoteConfig>(),
  ));

  // Local DB
  final localDb = LocalDbService();
  await localDb.initialize();
  sl.registerLazySingleton<LocalDbService>(() => localDb);

  // API Client
  sl.registerLazySingleton<ApiClient>(() => ApiClient(
    secureStorage: sl<FlutterSecureStorage>(),
  ));

  // Sync Service
  sl.registerLazySingleton<SyncService>(() => SyncService(
    localDb: sl<LocalDbService>(),
    firestore: sl<FirebaseFirestore>(),
    connectivity: sl<Connectivity>(),
  ));

  // Audit Service
  sl.registerLazySingleton<AuditService>(() => AuditService(
    firestore: sl<FirebaseFirestore>(),
    auth: sl<FirebaseAuth>(),
  ));

  // Notification Service
  sl.registerLazySingleton<NotificationService>(() => NotificationService(
    messaging: sl<FirebaseMessaging>(),
    firestore: sl<FirebaseFirestore>(),
  ));

  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(
    auth: sl<FirebaseAuth>(), firestore: sl<FirebaseFirestore>(), storage: sl<FirebaseStorage>(),
  ));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()));
  sl.registerFactory<AuthBloc>(() => AuthBloc(authRepository: sl<AuthRepository>()));

  // Products
  sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(remoteDataSource: sl<ProductRemoteDataSource>()));
  sl.registerFactory<ProductBloc>(() => ProductBloc(repository: sl<ProductRepository>()));

  // Orders
  sl.registerLazySingleton<OrderRemoteDataSource>(() => OrderRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(remoteDataSource: sl<OrderRemoteDataSource>()));
  sl.registerFactory<OrderBloc>(() => OrderBloc(repository: sl<OrderRepository>()));

  // Payments
  sl.registerLazySingleton<PaymentRemoteDataSource>(() => PaymentRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<PaymentRepository>(() => PaymentRepositoryImpl(remoteDataSource: sl<PaymentRemoteDataSource>()));
  sl.registerFactory<PaymentBloc>(() => PaymentBloc(repository: sl<PaymentRepository>()));

  // Logistics
  sl.registerLazySingleton<LogisticsRemoteDataSource>(() => LogisticsRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<LogisticsRepository>(() => LogisticsRepositoryImpl(remoteDataSource: sl<LogisticsRemoteDataSource>()));
  sl.registerFactory<LogisticsBloc>(() => LogisticsBloc(repository: sl<LogisticsRepository>()));

  // Customers
  sl.registerLazySingleton<CustomerRemoteDataSource>(() => CustomerRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<CustomerRepository>(() => CustomerRepositoryImpl(remoteDataSource: sl<CustomerRemoteDataSource>()));
  sl.registerFactory<CustomerBloc>(() => CustomerBloc(repository: sl<CustomerRepository>()));

  // Dashboard
  sl.registerLazySingleton<DashboardRemoteDataSource>(() => DashboardRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(remoteDataSource: sl<DashboardRemoteDataSource>()));
  sl.registerFactory<DashboardBloc>(() => DashboardBloc(repository: sl<DashboardRepository>()));

  // Admin
  sl.registerLazySingleton<AdminRemoteDataSource>(() => AdminRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<AdminRepository>(() => AdminRepository(remoteDataSource: sl<AdminRemoteDataSource>()));
  sl.registerFactory<AdminBloc>(() => AdminBloc(repository: sl<AdminRepository>()));

  // HR
  sl.registerLazySingleton<HrRemoteDataSource>(() => HrRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<HrRepository>(() => HrRepository(remoteDataSource: sl<HrRemoteDataSource>()));
  sl.registerFactory<HrBloc>(() => HrBloc(repository: sl<HrRepository>()));

  // Suppliers
  sl.registerLazySingleton<SupplierRemoteDataSource>(() => SupplierRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<SupplierRepository>(() => SupplierRepository(remoteDataSource: sl<SupplierRemoteDataSource>()));
  sl.registerFactory<SupplierBloc>(() => SupplierBloc(repository: sl<SupplierRepository>()));

  // Purchases
  sl.registerLazySingleton<PurchaseRemoteDataSource>(() => PurchaseRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<PurchaseRepository>(() => PurchaseRepository(remoteDataSource: sl<PurchaseRemoteDataSource>()));
  sl.registerFactory<PurchaseBloc>(() => PurchaseBloc(repository: sl<PurchaseRepository>()));

  // Expenses
  sl.registerLazySingleton<ExpenseRemoteDataSource>(() => ExpenseRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<ExpenseRepository>(() => ExpenseRepository(remoteDataSource: sl<ExpenseRemoteDataSource>()));
  sl.registerFactory<ExpenseBloc>(() => ExpenseBloc(repository: sl<ExpenseRepository>()));

  // Assets
  sl.registerLazySingleton<AssetRemoteDataSource>(() => AssetRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<AssetRepository>(() => AssetRepository(remoteDataSource: sl<AssetRemoteDataSource>()));
  sl.registerFactory<AssetBloc>(() => AssetBloc(repository: sl<AssetRepository>()));

  // Projects
  sl.registerLazySingleton<ProjectRemoteDataSource>(() => ProjectRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<ProjectRepository>(() => ProjectRepository(remoteDataSource: sl<ProjectRemoteDataSource>()));
  sl.registerFactory<ProjectBloc>(() => ProjectBloc(repository: sl<ProjectRepository>()));

  // Settings
  sl.registerLazySingleton<SettingsRemoteDataSource>(() => SettingsRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepository(remoteDataSource: sl<SettingsRemoteDataSource>()));
  sl.registerFactory<SettingsBloc>(() => SettingsBloc(repository: sl<SettingsRepository>()));

  // CRM
  sl.registerLazySingleton<CrmRemoteDataSource>(() => CrmRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<CrmRepository>(() => CrmRepository(remoteDataSource: sl<CrmRemoteDataSource>()));
  sl.registerFactory<CrmBloc>(() => CrmBloc(repository: sl<CrmRepository>()));

  // Accounting
  sl.registerLazySingleton<AccountingRemoteDataSource>(() => AccountingRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<AccountingRepository>(() => AccountingRepository(remoteDataSource: sl<AccountingRemoteDataSource>()));
  sl.registerFactory<AccountingBloc>(() => AccountingBloc(repository: sl<AccountingRepository>()));

  // Tax
  sl.registerLazySingleton<TaxRemoteDataSource>(() => TaxRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<TaxRepository>(() => TaxRepository(remoteDataSource: sl<TaxRemoteDataSource>()));
  sl.registerFactory<TaxBloc>(() => TaxBloc(repository: sl<TaxRepository>()));

  // Manufacturing
  sl.registerLazySingleton<ManufacturingRemoteDataSource>(() => ManufacturingRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<ManufacturingRepository>(() => ManufacturingRepository(remoteDataSource: sl<ManufacturingRemoteDataSource>()));
  sl.registerFactory<ManufacturingBloc>(() => ManufacturingBloc(repository: sl<ManufacturingRepository>()));

  // DMS
  sl.registerLazySingleton<DmsRemoteDataSource>(() => DmsRemoteDataSource(firestore: sl<FirebaseFirestore>()));
  sl.registerLazySingleton<DmsRepository>(() => DmsRepository(remoteDataSource: sl<DmsRemoteDataSource>()));
  sl.registerFactory<DmsBloc>(() => DmsBloc(repository: sl<DmsRepository>()));
}
