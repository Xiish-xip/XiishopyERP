/// Xiishopy ERP - Permission Constants
/// Granular permission definitions for RBAC system with 100+ permissions.
library;

class Permission {
  // Products (20 permissions)
  static const String productsView = 'products:view';
  static const String productsCreate = 'products:create';
  static const String productsEdit = 'products:edit';
  static const String productsDelete = 'products:delete';
  static const String productsImport = 'products:import';
  static const String productsExport = 'products:export';
  static const String productsBarcode = 'products:barcode';
  static const String productsCategories = 'products:categories';
  static const String productsVariants = 'products:variants';
  static const String productsBulkEdit = 'products:bulk_edit';
  static const String productsStockAdjust = 'products:stock_adjust';
  static const String productsPriceEdit = 'products:price_edit';
  static const String productsDiscount = 'products:discount';
  static const String productsBatchTrack = 'products:batch_track';
  static const String productsImages = 'products:images';
  static const String productsWholesale = 'products:wholesale';
  static const String productsReorder = 'products:reorder';
  static const String productsPublish = 'products:publish';
  static const String productsArchive = 'products:archive';
  static const String productsAudit = 'products:audit';

  // Orders (15 permissions)
  static const String ordersView = 'orders:view';
  static const String ordersCreate = 'orders:create';
  static const String ordersEdit = 'orders:edit';
  static const String ordersDelete = 'orders:delete';
  static const String ordersApprove = 'orders:approve';
  static const String ordersFulfill = 'orders:fulfill';
  static const String ordersCancel = 'orders:cancel';
  static const String ordersRefund = 'orders:refund';
  static const String ordersReturn = 'orders:return';
  static const String ordersTemplates = 'orders:templates';
  static const String ordersImport = 'orders:import';
  static const String ordersCredit = 'orders:credit';
  static const String ordersSplit = 'orders:split';
  static const String ordersNotes = 'orders:notes';
  static const String ordersExport = 'orders:export';

  // Payments (12 permissions)
  static const String paymentsView = 'payments:view';
  static const String paymentsProcess = 'payments:process';
  static const String paymentsRefund = 'payments:refund';
  static const String paymentsCancel = 'payments:cancel';
  static const String paymentsLinks = 'payments:links';
  static const String paymentsInstallments = 'payments:installments';
  static const String paymentsReminders = 'payments:reminders';
  static const String paymentsMultiCurrency = 'payments:multi_currency';
  static const String paymentsReceipts = 'payments:receipts';
  static const String paymentsAnalytics = 'payments:analytics';
  static const String paymentsSettings = 'payments:settings';
  static const String paymentsReconcile = 'payments:reconcile';

  // Admin (25 permissions)
  static const String adminAccess = 'admin:access';
  static const String adminUsers = 'admin:users';
  static const String adminSettings = 'admin:settings';
  static const String adminRoles = 'admin:roles';
  static const String adminPermissions = 'admin:permissions';
  static const String adminModules = 'admin:modules';
  static const String adminAuditLogs = 'admin:audit_logs';
  static const String adminBackup = 'admin:backup';
  static const String adminExport = 'admin:export';
  static const String adminImport = 'admin:import';
  static const String adminApiKeys = 'admin:api_keys';
  static const String adminSystemHealth = 'admin:system_health';
  static const String adminDataExplorer = 'admin:data_explorer';
  static const String adminFeatureFlags = 'admin:feature_flags';
  static const String adminBilling = 'admin:billing';
  static const String adminIntegrations = 'admin:integrations';
  static const String adminDeploy = 'admin:deploy';
  static const String adminAnalytics = 'admin:analytics';
  static const String adminLogs = 'admin:logs';
  static const String adminNotifications = 'admin:notifications';
  static const String adminTemplates = 'admin:templates';
  static const String adminLocalization = 'admin:localization';
  static const String adminSecurity = 'admin:security';
  static const String adminCompliance = 'admin:compliance';
  static const String adminMaintenance = 'admin:maintenance';

  // HR (15 permissions)
  static const String hrView = 'hr:view';
  static const String hrEdit = 'hr:edit';
  static const String hrCreate = 'hr:create';
  static const String hrDelete = 'hr:delete';
  static const String hrPayroll = 'hr:payroll';
  static const String hrAttendance = 'hr:attendance';
  static const String hrLeave = 'hr:leave';
  static const String hrPerformance = 'hr:performance';
  static const String hrContracts = 'hr:contracts';
  static const String hrBenefits = 'hr:benefits';
  static const String hrRecruitment = 'hr:recruitment';
  static const String hrTraining = 'hr:training';
  static const String hrDisciplinary = 'hr:disciplinary';
  static const String hrReports = 'hr:reports';
  static const String hrSettings = 'hr:settings';

  // Suppliers (12 permissions)
  static const String suppliersView = 'suppliers:view';
  static const String suppliersCreate = 'suppliers:create';
  static const String suppliersEdit = 'suppliers:edit';
  static const String suppliersDelete = 'suppliers:delete';
  static const String suppliersPo = 'suppliers:po';
  static const String suppliersContracts = 'suppliers:contracts';
  static const String suppliersRating = 'suppliers:rating';
  static const String suppliersPerformance = 'suppliers:performance';
  static const String suppliersImport = 'suppliers:import';
  static const String suppliersExport = 'suppliers:export';
  static const String suppliersPayment = 'suppliers:payment';
  static const String suppliersSettings = 'suppliers:settings';

  // Purchases (15 permissions)
  static const String purchasesView = 'purchases:view';
  static const String purchasesCreate = 'purchases:create';
  static const String purchasesEdit = 'purchases:edit';
  static const String purchasesDelete = 'purchases:delete';
  static const String purchasesApprove = 'purchases:approve';
  static const String purchasesRfq = 'purchases:rfq';
  static const String purchasesReceive = 'purchases:receive';
  static const String purchasesReturn = 'purchases:return';
  static const String purchasesImport = 'purchases:import';
  static const String purchasesExport = 'purchases:export';
  static const String purchasesBudget = 'purchases:budget';
  static const String purchasesRequisition = 'purchases:requisition';
  static const String purchasesReconcile = 'purchases:reconcile';
  static const String purchasesReports = 'purchases:reports';
  static const String purchasesSettings = 'purchases:settings';

  // Expenses (12 permissions)
  static const String expensesView = 'expenses:view';
  static const String expensesCreate = 'expenses:create';
  static const String expensesEdit = 'expenses:edit';
  static const String expensesDelete = 'expenses:delete';
  static const String expensesApprove = 'expenses:approve';
  static const String expensesCategories = 'expenses:categories';
  static const String expensesReimburse = 'expenses:reimburse';
  static const String expensesBudget = 'expenses:budget';
  static const String expensesReports = 'expenses:reports';
  static const String expensesExport = 'expenses:export';
  static const String expensesAudit = 'expenses:audit';
  static const String expensesSettings = 'expenses:settings';

  // Projects (15 permissions)
  static const String projectsView = 'projects:view';
  static const String projectsCreate = 'projects:create';
  static const String projectsEdit = 'projects:edit';
  static const String projectsDelete = 'projects:delete';
  static const String projectsTrack = 'projects:track';
  static const String projectsBudget = 'projects:budget';
  static const String projectsTasks = 'projects:tasks';
  static const String projectsTime = 'projects:time';
  static const String projectsMilestones = 'projects:milestones';
  static const String projectsTeam = 'projects:team';
  static const String projectsDocuments = 'projects:documents';
  static const String projectsReports = 'projects:reports';
  static const String projectsProfitability = 'projects:profitability';
  static const String projectsExport = 'projects:export';
  static const String projectsSettings = 'projects:settings';

  // Assets (12 permissions)
  static const String assetsView = 'assets:view';
  static const String assetsCreate = 'assets:create';
  static const String assetsEdit = 'assets:edit';
  static const String assetsDelete = 'assets:delete';
  static const String assetsAssign = 'assets:assign';
  static const String assetsMaintenance = 'assets:maintenance';
  static const String assetsDepreciation = 'assets:depreciation';
  static const String assetsAudit = 'assets:audit';
  static const String assetsDispose = 'assets:dispose';
  static const String assetsReports = 'assets:reports';
  static const String assetsImport = 'assets:import';
  static const String assetsSettings = 'assets:settings';

  // Reports (10 permissions)
  static const String reportsView = 'reports:view';
  static const String reportsCreate = 'reports:create';
  static const String reportsExport = 'reports:export';
  static const String reportsSchedule = 'reports:schedule';
  static const String reportsShare = 'reports:share';
  static const String reportsDrillDown = 'reports:drill_down';
  static const String reportsCustom = 'reports:custom';
  static const String reportsTemplates = 'reports:templates';
  static const String reportsDelete = 'reports:delete';
  static const String reportsSettings = 'reports:settings';

  // CRM (10 permissions)
  static const String crmView = 'crm:view';
  static const String crmCreate = 'crm:create';
  static const String crmEdit = 'crm:edit';
  static const String crmDelete = 'crm:delete';
  static const String crmLeads = 'crm:leads';
  static const String crmOpportunities = 'crm:opportunities';
  static const String crmFollowUps = 'crm:follow_ups';
  static const String crmCampaigns = 'crm:campaigns';
  static const String crmReports = 'crm:reports';
  static const String crmSettings = 'crm:settings';

  // Warehouse (10 permissions)
  static const String warehouseView = 'warehouse:view';
  static const String warehouseEdit = 'warehouse:edit';
  static const String warehouseReceive = 'warehouse:receive';
  static const String warehousePick = 'warehouse:pick';
  static const String warehousePack = 'warehouse:pack';
  static const String warehouseShip = 'warehouse:ship';
  static const String warehouseTransfer = 'warehouse:transfer';
  static const String warehouseInventory = 'warehouse:inventory';
  static const String warehouseReports = 'warehouse:reports';
  static const String warehouseSettings = 'warehouse:settings';
}

/// Permission level hierarchy for RBAC
class PermissionLevel {
  static const Map<String, int> levelMap = {
    'super_admin': 0,   // Developer access
    'admin': 1,         // Full business access
    'supervisor': 2,    // Management access
    'accountant': 3,    // Finance access
    'data_entry': 4,    // Staff access
    'viewer': 5,        // Read-only access
  };

  /// Check if role has sufficient level (lower number = more access)
  static bool hasLevel(String role, int requiredLevel) {
    final roleLevel = levelMap[role];
    if (roleLevel == null) return false;
    return roleLevel <= requiredLevel;
  }
}

/// Default permissions assigned to each role
class DefaultPermissions {
  static const Map<String, List<String>> rolePermissions = {
    'super_admin': [], // All permissions granted implicitly
    'admin': [
      Permission.productsView, Permission.productsCreate, Permission.productsEdit,
      Permission.productsDelete, Permission.productsImport, Permission.productsExport,
      Permission.productsBarcode, Permission.productsCategories, Permission.productsVariants,
      Permission.productsStockAdjust, Permission.productsPriceEdit, Permission.productsDiscount,
      Permission.productsBatchTrack, Permission.productsImages, Permission.productsWholesale,
      Permission.productsReorder, Permission.productsPublish, Permission.productsArchive,
      Permission.productsAudit,
      Permission.ordersView, Permission.ordersCreate, Permission.ordersEdit,
      Permission.ordersDelete, Permission.ordersApprove, Permission.ordersFulfill,
      Permission.ordersCancel, Permission.ordersRefund, Permission.ordersReturn,
      Permission.ordersTemplates, Permission.ordersImport, Permission.ordersCredit,
      Permission.ordersSplit, Permission.ordersNotes, Permission.ordersExport,
      Permission.paymentsView, Permission.paymentsProcess, Permission.paymentsRefund,
      Permission.paymentsCancel, Permission.paymentsLinks, Permission.paymentsInstallments,
      Permission.paymentsReminders, Permission.paymentsMultiCurrency, Permission.paymentsReceipts,
      Permission.paymentsAnalytics, Permission.paymentsSettings, Permission.paymentsReconcile,
      Permission.adminAccess, Permission.adminUsers, Permission.adminSettings,
      Permission.adminRoles, Permission.adminPermissions, Permission.adminModules,
      Permission.adminAuditLogs, Permission.adminBackup, Permission.adminExport,
      Permission.adminImport, Permission.adminApiKeys, Permission.adminSystemHealth,
      Permission.adminFeatureFlags, Permission.adminIntegrations,
      Permission.adminAnalytics, Permission.adminLogs, Permission.adminNotifications,
      Permission.adminTemplates, Permission.adminLocalization, Permission.adminSecurity,
      Permission.adminMaintenance,
      Permission.hrView, Permission.hrEdit, Permission.hrCreate, Permission.hrDelete,
      Permission.hrPayroll, Permission.hrAttendance, Permission.hrLeave, Permission.hrPerformance,
      Permission.hrContracts, Permission.hrBenefits, Permission.hrRecruitment,
      Permission.hrTraining, Permission.hrDisciplinary, Permission.hrReports, Permission.hrSettings,
      Permission.suppliersView, Permission.suppliersCreate, Permission.suppliersEdit,
      Permission.suppliersDelete, Permission.suppliersPo, Permission.suppliersContracts,
      Permission.suppliersRating, Permission.suppliersPerformance, Permission.suppliersImport,
      Permission.suppliersExport, Permission.suppliersPayment, Permission.suppliersSettings,
      Permission.purchasesView, Permission.purchasesCreate, Permission.purchasesEdit,
      Permission.purchasesDelete, Permission.purchasesApprove, Permission.purchasesRfq,
      Permission.purchasesReceive, Permission.purchasesReturn, Permission.purchasesImport,
      Permission.purchasesExport, Permission.purchasesBudget, Permission.purchasesRequisition,
      Permission.purchasesReconcile, Permission.purchasesReports, Permission.purchasesSettings,
      Permission.expensesView, Permission.expensesCreate, Permission.expensesEdit,
      Permission.expensesDelete, Permission.expensesApprove, Permission.expensesCategories,
      Permission.expensesReimburse, Permission.expensesBudget, Permission.expensesReports,
      Permission.expensesExport, Permission.expensesAudit, Permission.expensesSettings,
      Permission.projectsView, Permission.projectsCreate, Permission.projectsEdit,
      Permission.projectsDelete, Permission.projectsTrack, Permission.projectsBudget,
      Permission.projectsTasks, Permission.projectsTime, Permission.projectsMilestones,
      Permission.projectsTeam, Permission.projectsDocuments, Permission.projectsReports,
      Permission.projectsProfitability, Permission.projectsExport, Permission.projectsSettings,
      Permission.assetsView, Permission.assetsCreate, Permission.assetsEdit,
      Permission.assetsDelete, Permission.assetsAssign, Permission.assetsMaintenance,
      Permission.assetsDepreciation, Permission.assetsAudit, Permission.assetsDispose,
      Permission.assetsReports, Permission.assetsImport, Permission.assetsSettings,
      Permission.reportsView, Permission.reportsCreate, Permission.reportsExport,
      Permission.reportsSchedule, Permission.reportsShare, Permission.reportsDrillDown,
      Permission.reportsCustom, Permission.reportsTemplates, Permission.reportsDelete,
      Permission.reportsSettings,
      Permission.crmView, Permission.crmCreate, Permission.crmEdit, Permission.crmDelete,
      Permission.crmLeads, Permission.crmOpportunities, Permission.crmFollowUps,
      Permission.crmCampaigns, Permission.crmReports, Permission.crmSettings,
      Permission.warehouseView, Permission.warehouseEdit, Permission.warehouseReceive,
      Permission.warehousePick, Permission.warehousePack, Permission.warehouseShip,
      Permission.warehouseTransfer, Permission.warehouseInventory, Permission.warehouseReports,
      Permission.warehouseSettings,
    ],
    'supervisor': [
      Permission.productsView, Permission.productsEdit, Permission.productsStockAdjust,
      Permission.productsCategories, Permission.productsImages,
      Permission.ordersView, Permission.ordersCreate, Permission.ordersEdit,
      Permission.ordersApprove, Permission.ordersFulfill, Permission.ordersCancel,
      Permission.ordersRefund, Permission.ordersReturn, Permission.ordersNotes,
      Permission.paymentsView, Permission.paymentsProcess,
      Permission.hrView, Permission.hrEdit, Permission.hrAttendance, Permission.hrLeave,
      Permission.hrPerformance,
      Permission.suppliersView, Permission.suppliersEdit,
      Permission.purchasesView, Permission.purchasesCreate, Permission.purchasesApprove,
      Permission.expensesView, Permission.expensesCreate, Permission.expensesApprove,
      Permission.projectsView, Permission.projectsCreate, Permission.projectsTrack,
      Permission.projectsTasks, Permission.projectsTeam,
      Permission.assetsView, Permission.assetsEdit, Permission.assetsAssign,
      Permission.reportsView, Permission.reportsCreate, Permission.reportsExport,
      Permission.reportsDrillDown,
      Permission.crmView, Permission.crmCreate, Permission.crmEdit, Permission.crmLeads,
      Permission.crmOpportunities, Permission.crmFollowUps,
      Permission.warehouseView, Permission.warehouseEdit, Permission.warehouseReceive,
      Permission.warehousePick, Permission.warehousePack, Permission.warehouseShip,
      Permission.warehouseTransfer, Permission.warehouseInventory,
    ],
    'accountant': [
      Permission.productsView, Permission.productsPriceEdit, Permission.productsDiscount,
      Permission.productsAudit,
      Permission.ordersView, Permission.ordersRefund, Permission.ordersExport,
      Permission.paymentsView, Permission.paymentsProcess, Permission.paymentsRefund,
      Permission.paymentsCancel, Permission.paymentsReceipts, Permission.paymentsAnalytics,
      Permission.paymentsReconcile, Permission.paymentsSettings,
      Permission.expensesView, Permission.expensesCreate, Permission.expensesEdit,
      Permission.expensesApprove, Permission.expensesCategories, Permission.expensesReimburse,
      Permission.expensesBudget, Permission.expensesReports, Permission.expensesExport,
      Permission.expensesAudit, Permission.expensesSettings,
      Permission.hrPayroll,
      Permission.suppliersView, Permission.suppliersPayment,
      Permission.purchasesView, Permission.purchasesReconcile, Permission.purchasesBudget,
      Permission.projectsView, Permission.projectsBudget, Permission.projectsProfitability,
      Permission.assetsView, Permission.assetsDepreciation, Permission.assetsAudit,
      Permission.reportsView, Permission.reportsExport, Permission.reportsSchedule,
      Permission.reportsCustom, Permission.reportsTemplates,
    ],
    'data_entry': [
      Permission.productsView, Permission.productsCreate, Permission.productsEdit,
      Permission.productsBarcode, Permission.productsCategories, Permission.productsImages,
      Permission.productsImport, Permission.productsStockAdjust,
      Permission.ordersView, Permission.ordersCreate, Permission.ordersImport,
      Permission.ordersNotes,
      Permission.paymentsView,
      Permission.suppliersView, Permission.suppliersCreate, Permission.suppliersEdit,
      Permission.purchasesView, Permission.purchasesCreate, Permission.purchasesReceive,
      Permission.expensesView, Permission.expensesCreate,
      Permission.crmView, Permission.crmCreate, Permission.crmEdit, Permission.crmLeads,
      Permission.crmFollowUps,
      Permission.warehouseView, Permission.warehouseReceive, Permission.warehousePick,
      Permission.warehousePack, Permission.warehouseShip,
    ],
    'viewer': [
      Permission.productsView,
      Permission.ordersView,
      Permission.paymentsView,
      Permission.hrView,
      Permission.suppliersView,
      Permission.purchasesView,
      Permission.expensesView,
      Permission.projectsView,
      Permission.assetsView,
      Permission.reportsView,
      Permission.crmView,
      Permission.warehouseView,
    ],
  };

  /// Get permissions for a specific role
  static List<String> getPermissionsForRole(String role) {
    if (role == 'super_admin') {
      // Super admin has all permissions - return full list
      return [
        Permission.productsView, Permission.productsCreate, Permission.productsEdit,
        Permission.productsDelete, Permission.productsImport, Permission.productsExport,
        Permission.productsBarcode, Permission.productsCategories, Permission.productsVariants,
        Permission.productsBulkEdit, Permission.productsStockAdjust, Permission.productsPriceEdit,
        Permission.productsDiscount, Permission.productsBatchTrack, Permission.productsImages,
        Permission.productsWholesale, Permission.productsReorder, Permission.productsPublish,
        Permission.productsArchive, Permission.productsAudit,
        Permission.ordersView, Permission.ordersCreate, Permission.ordersEdit,
        Permission.ordersDelete, Permission.ordersApprove, Permission.ordersFulfill,
        Permission.ordersCancel, Permission.ordersRefund, Permission.ordersReturn,
        Permission.ordersTemplates, Permission.ordersImport, Permission.ordersCredit,
        Permission.ordersSplit, Permission.ordersNotes, Permission.ordersExport,
        Permission.paymentsView, Permission.paymentsProcess, Permission.paymentsRefund,
        Permission.paymentsCancel, Permission.paymentsLinks, Permission.paymentsInstallments,
        Permission.paymentsReminders, Permission.paymentsMultiCurrency, Permission.paymentsReceipts,
        Permission.paymentsAnalytics, Permission.paymentsSettings, Permission.paymentsReconcile,
        Permission.adminAccess, Permission.adminUsers, Permission.adminSettings,
        Permission.adminRoles, Permission.adminPermissions, Permission.adminModules,
        Permission.adminAuditLogs, Permission.adminBackup, Permission.adminExport,
        Permission.adminImport, Permission.adminApiKeys, Permission.adminSystemHealth,
        Permission.adminDataExplorer, Permission.adminFeatureFlags, Permission.adminBilling,
        Permission.adminIntegrations, Permission.adminDeploy, Permission.adminAnalytics,
        Permission.adminLogs, Permission.adminNotifications, Permission.adminTemplates,
        Permission.adminLocalization, Permission.adminSecurity, Permission.adminCompliance,
        Permission.adminMaintenance,
        Permission.hrView, Permission.hrEdit, Permission.hrCreate, Permission.hrDelete,
        Permission.hrPayroll, Permission.hrAttendance, Permission.hrLeave, Permission.hrPerformance,
        Permission.hrContracts, Permission.hrBenefits, Permission.hrRecruitment,
        Permission.hrTraining, Permission.hrDisciplinary, Permission.hrReports, Permission.hrSettings,
        Permission.suppliersView, Permission.suppliersCreate, Permission.suppliersEdit,
        Permission.suppliersDelete, Permission.suppliersPo, Permission.suppliersContracts,
        Permission.suppliersRating, Permission.suppliersPerformance, Permission.suppliersImport,
        Permission.suppliersExport, Permission.suppliersPayment, Permission.suppliersSettings,
        Permission.purchasesView, Permission.purchasesCreate, Permission.purchasesEdit,
        Permission.purchasesDelete, Permission.purchasesApprove, Permission.purchasesRfq,
        Permission.purchasesReceive, Permission.purchasesReturn, Permission.purchasesImport,
        Permission.purchasesExport, Permission.purchasesBudget, Permission.purchasesRequisition,
        Permission.purchasesReconcile, Permission.purchasesReports, Permission.purchasesSettings,
        Permission.expensesView, Permission.expensesCreate, Permission.expensesEdit,
        Permission.expensesDelete, Permission.expensesApprove, Permission.expensesCategories,
        Permission.expensesReimburse, Permission.expensesBudget, Permission.expensesReports,
        Permission.expensesExport, Permission.expensesAudit, Permission.expensesSettings,
        Permission.projectsView, Permission.projectsCreate, Permission.projectsEdit,
        Permission.projectsDelete, Permission.projectsTrack, Permission.projectsBudget,
        Permission.projectsTasks, Permission.projectsTime, Permission.projectsMilestones,
        Permission.projectsTeam, Permission.projectsDocuments, Permission.projectsReports,
        Permission.projectsProfitability, Permission.projectsExport, Permission.projectsSettings,
        Permission.assetsView, Permission.assetsCreate, Permission.assetsEdit,
        Permission.assetsDelete, Permission.assetsAssign, Permission.assetsMaintenance,
        Permission.assetsDepreciation, Permission.assetsAudit, Permission.assetsDispose,
        Permission.assetsReports, Permission.assetsImport, Permission.assetsSettings,
        Permission.reportsView, Permission.reportsCreate, Permission.reportsExport,
        Permission.reportsSchedule, Permission.reportsShare, Permission.reportsDrillDown,
        Permission.reportsCustom, Permission.reportsTemplates, Permission.reportsDelete,
        Permission.reportsSettings,
        Permission.crmView, Permission.crmCreate, Permission.crmEdit, Permission.crmDelete,
        Permission.crmLeads, Permission.crmOpportunities, Permission.crmFollowUps,
        Permission.crmCampaigns, Permission.crmReports, Permission.crmSettings,
        Permission.warehouseView, Permission.warehouseEdit, Permission.warehouseReceive,
        Permission.warehousePick, Permission.warehousePack, Permission.warehouseShip,
        Permission.warehouseTransfer, Permission.warehouseInventory, Permission.warehouseReports,
        Permission.warehouseSettings,
      ];
    }
    return rolePermissions[role] ?? rolePermissions['viewer']!;
  }
}