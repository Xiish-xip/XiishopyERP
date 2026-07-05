# 🚀 Xiishopy ERP — Full Enterprise Upgrade Roadmap (v2.0)

> **Current Status:** Phase 1-6 base implementation complete (UI screens + Core infrastructure)  
> **Target:** Full industrial-grade ERP with all modules, real-time data, offline-first sync, advanced analytics  
> **Date:** June 28, 2026  
> **Actual Completion:** ~35% of total target features

---

## 📋 Table of Contents

1. [Honest Assessment: What's Done vs What's Missing](#1-honest-assessment-whats-done-vs-whats-missing)
2. [Phase 7: Deep Module Integration & Real Data](#2-phase-7-deep-module-integration--real-data)
3. [Phase 8: Missing Core Modules](#3-phase-8-missing-core-modules)
4. [Phase 9: Advanced ERP Modules](#4-phase-9-advanced-erp-modules)
5. [Phase 10: Communication & Collaboration](#5-phase-10-communication--collaboration)
6. [Phase 11: Platform Expansion](#6-phase-11-platform-expansion)
7. [Phase 12: Production Hardening](#7-phase-12-production-hardening)
8. [Phase 13: AI & Intelligence Layer](#8-phase-13-ai--intelligence-layer)
9. [Phase 14: Multi-Tenant & Marketplace](#9-phase-14-multi-tenant--marketplace)
10. [Complete Firebase Security Rules](#10-complete-firebase-security-rules)
11. [Cloud Functions Enhancement Plan](#11-cloud-functions-enhancement-plan)
12. [Testing & Quality Gates](#12-testing--quality-gates)
13. [CI/CD Pipeline](#13-cicd-pipeline)
14. [Deployment Architecture](#14-deployment-architecture)
15. [Implementation Timeline: 90-Day Plan](#15-implementation-timeline-90-day-plan)

---

## 1. Honest Assessment: What's Done vs What's Missing

### ✅ Fully Implemented (Working Features)
| Feature | Status | Details |
|---------|--------|---------|
| Firebase Auth | ✅ Complete | Email/password, auth bloc |
| Firestore CRUD | ✅ Complete | Products, Orders, Payments, Customers |
| Cloud Functions API | ✅ Complete | 7 route modules with auth guard |
| Payments Engine | ✅ Complete | M-Pesa, Airtel Money, Selcom, Pesapal |
| Logistics Engine | ✅ Complete | Shipment tracking |
| Forex Engine | ✅ Complete | Real-time FX rates |
| AI Inventory | ✅ Complete | Demand prediction, OCR |
| Admin Dashboard | ✅ Complete | UI with module manager, user mgmt, permissions, audit logs |
| RBAC System | ✅ Complete | 150+ permissions, 6 roles, permission matrix |
| Settings UI | ✅ Complete | 9 categories, full form UI |
| Hive Offline DB | ✅ Complete | LocalSale, LocalProduct, PendingSync |
| Sync Service | ✅ Complete | Connectivity-aware sync with retry |
| Audit Service | ✅ Complete | Before/after change tracking |
| Notification Service | ✅ Complete | FCM integration |
| Permission Guard | ✅ Complete | UI-level RBAC widget |
| API Client | ✅ Complete | Dio with auth interceptor |
| Remote Config | ✅ Complete | Firebase Remote Config service |
| Routing | ✅ Complete | 15 routes with GoRouter |
| Sidebar Navigation | ✅ Complete | 15 navigation items |
| Firestore Indexes | ✅ Complete | 11 composite indexes |

### ⚠️ Partially Implemented (UI only, no real data/backend)
| Feature | Status | What's Missing |
|---------|--------|----------------|
| HR Module | ⚠️ UI Only | No BLoC, no Firestore datasource, no real CRUD, no payroll calc |
| Suppliers Module | ⚠️ UI Only | No BLoC, no Firestore datasource, no PO generation |
| Purchases Module | ⚠️ UI Only | No BLoC, no Firestore, no approval workflow |
| Expenses Module | ⚠️ UI Only | No BLoC, no Firestore, no approval flow |
| Assets Module | ⚠️ UI Only | No BLoC, no Firestore, no depreciation calc |
| Projects Module | ⚠️ UI Only | No BLoC, no Firestore, no time tracking |
| Analytics Screen | ⚠️ Basic | Reuses dashboard data, no dedicated analytics endpoints |
| Admin Audit Logs | ⚠️ UI reads logs | No audit log export, no filtering UI |
| Settings Persistence | ⚠️ UI Only | No Firestore write, no remote config sync |
| Local DB Service | ⚠️ Core only | No encryption, no migration, no Hive TypeAdapters |

### ❌ Entirely Missing (Not Started)
| Category | Count | Modules |
|----------|-------|---------|
| **Core Architecture** | 12 | app_bootstrap, validators, exceptions, currency_formatter, enums, app_constants, responsive_builder, offline_service, context_extensions, data_table_widget, admin_card, permission_manager |
| **ERP Modules** | 12 | POS (Point of Sale), CRM, Manufacturing, Multi-Company, Tax Engine, Document Management, E-Commerce, Booking/Scheduling, Fleet Management, Quality Control, Accounting/GL, Contract Management |
| **Collaboration** | 6 | Chat/Messaging, Help Desk/Ticketing, Knowledge Base, Comments/Mentions, Activity Feed, Team Tasks |
| **Platform** | 8 | Customer Portal (web), Supplier Portal (web), Driver App, PWA Support, Desktop UI, Mobile Responsive, Web Optimizations, Keyboard Shortcuts |
| **Integration** | 8 | WhatsApp, Telegram, Slack, Email Service, SMS Service, Webhooks, API Versioning, Rate Limiting |
| **Infrastructure** | 12 | Tests (unit/widget/integration), CI/CD Pipeline, Docker, Kubernetes, Monitoring Dashboards, Backup/Restore, Data Retention, GDPR Compliance, Onboarding Flow, Accessibility, Dark/Light Theme Persistence, Multi-Language Translations |
| **Security** | 8 | 2FA, IP Whitelist, Field-Level Encryption, Session Timeout Hardware, Rate Limiting, API Key Rotation, Audit Log Export, Compliance Reporting |

---

## 2. Phase 7: Deep Module Integration & Real Data

### 2.1 HR Module — Full Implementation
```dart
// Missing: Complete BLoC + Firestore + Real CRUD
hr/
├── bloc/                          // ❌ MISSING
│   ├── hr_bloc.dart
│   ├── hr_event.dart
│   └── hr_state.dart
├── data/
│   ├── models/
│   │   ├── employee_model.dart     // ❌ MISSING
│   │   ├── attendance_model.dart   // ❌ MISSING
│   │   ├── leave_model.dart        // ❌ MISSING
│   │   └── payroll_model.dart      // ❌ MISSING
│   ├── repositories/
│   │   └── hr_repository.dart      // ❌ MISSING
│   └── datasources/
│       ├── hr_remote_datasource.dart // ❌ MISSING
│       └── hr_local_datasource.dart  // ❌ MISSING
├── domain/
│   ├── entities/                   // ❌ MISSING
│   └── usecases/                   // ❌ MISSING
└── presentation/
    ├── screens/
    │   └── hr_screen.dart          // ✅ EXISTS (UI only)
    └── widgets/                    // ❌ MISSING
```

### 2.2 POI (Point of Sale) — Full Module
```dart
// MISSING: Complete POS with offline sync
pos/
├── bloc/
│   ├── pos_bloc.dart               // ❌ MISSING
│   ├── pos_event.dart              // ❌ MISSING
│   └── pos_state.dart              // ❌ MISSING
├── data/
│   ├── models/
│   │   ├── cart_item.dart          // ❌ MISSING
│   │   └── transaction.dart        // ❌ MISSING
│   ├── repositories/
│   │   └── pos_repository.dart     // ❌ MISSING
│   └── datasources/
│       ├── local_pos_datasource.dart // Uses LocalDbService (exists)
│       └── remote_pos_datasource.dart // ❌ MISSING
├── domain/
│   └── usecases/                   // ❌ MISSING
└── presentation/
    ├── screens/
    │   ├── pos_terminal_screen.dart // ❌ MISSING
    │   ├── cart_screen.dart         // ❌ MISSING
    │   └── receipt_screen.dart      // ❌ MISSING
    └── widgets/                    // ❌ MISSING
```

### 2.3 Each Module Must Have Full BLoC Pattern

For **every** module (HR, Suppliers, Purchases, Expenses, Assets, Projects, POS, CRM, Manufacturing), implement:

```dart
// Standard module architecture pattern - 14 files per module
module/
├── bloc/
│   ├── module_bloc.dart
│   ├── module_event.dart
│   └── module_state.dart
├── data/
│   ├── models/
│   │   └── module_model.dart
│   ├── repositories/
│   │   └── module_repository.dart
│   └── datasources/
│       ├── module_remote_datasource.dart
│       └── module_local_datasource.dart
├── domain/
│   ├── entities/
│   │   └── module_entity.dart
│   └── usecases/
│       ├── get_modules.dart
│       ├── create_module.dart
│       ├── update_module.dart
│       └── delete_module.dart
└── presentation/
    ├── screens/
    │   └── module_screen.dart       // ✅ EXISTS for some
    └── widgets/                    // ❌ MISSING
```

---

## 3. Phase 8: Missing Core Modules

### 3.1 CRM (Customer Relationship Management)
| Feature | Priority | Effort | Description |
|---------|----------|--------|-------------|
| Lead Management | 🔴 HIGH | 3 days | Capture, qualify, convert leads |
| Opportunity Tracking | 🔴 HIGH | 2 days | Sales pipeline with stages |
| Follow-up Scheduling | 🔴 HIGH | 2 days | Automated reminders |
| Campaign Management | 🟡 MED | 3 days | Email/SMS campaigns |
| Customer Segmentation | 🟡 MED | 2 days | Tag-based grouping |
| Communication History | 🟡 MED | 2 days | Call/email/meeting logs |
| Loyalty Programs | 🟢 LOW | 3 days | Points, rewards, tiers |
| Customer 360 View | 🔴 HIGH | 4 days | Complete customer profile |

### 3.2 Accounting / General Ledger
| Feature | Priority | Effort | Description |
|---------|----------|--------|-------------|
| Chart of Accounts | 🔴 HIGH | 3 days | Account hierarchy setup |
| Journal Entries | 🔴 HIGH | 3 days | Double-entry bookkeeping |
| General Ledger | 🔴 HIGH | 2 days | Transaction register |
| Accounts Receivable | 🔴 HIGH | 3 days | Customer invoices, aging |
| Accounts Payable | 🔴 HIGH | 3 days | Vendor bills, payment tracking |
| Trial Balance | 🟡 MED | 2 days | Period-end balancing |
| Balance Sheet | 🟡 MED | 2 days | Asset/Liability/Equity report |
| Income Statement | 🟡 MED | 2 days | P&L by period |
| Cash Flow Statement | 🟡 MED | 2 days | Operating/Investing/Financing |
| Budget Management | 🟡 MED | 3 days | Budget vs actuals |
| Fiscal Year Management | 🟢 LOW | 1 day | Year-end close process |
| Tax Reporting | 🟢 LOW | 3 days | VAT/GST/Payroll tax forms |

### 3.3 Tax Engine
| Feature | Priority | Effort | Description |
|---------|----------|--------|-------------|
| Tax Rate Configuration | 🔴 HIGH | 1 day | Per-region tax rates |
| VAT/GST Calculation | 🔴 HIGH | 2 days | Automatic tax on transactions |
| Tax Exemption Handling | 🟡 MED | 2 days | Exempt customers/items |
| Tax Reporting | 🟡 MED | 3 days | VAT returns, GST filing |
| Multi-Region Tax | 🟡 MED | 3 days | EAC tax harmonization |
| Withholding Tax | 🟢 LOW | 2 days | TDS/WHT calculation |

### 3.4 Manufacturing Module
| Feature | Priority | Effort | Description |
|---------|----------|--------|-------------|
| Bill of Materials (BOM) | 🔴 HIGH | 4 days | Product structure definition |
| Work Orders | 🔴 HIGH | 3 days | Production orders |
| Production Planning | 🟡 MED | 3 days | Capacity planning, scheduling |
| Quality Control | 🟡 MED | 3 days | Inspection checklists, QC passes |
| Material Requirements (MRP) | 🟡 MED | 4 days | Auto-purchase from BOM |
| Shop Floor Control | 🟢 LOW | 3 days | Real-time production tracking |
| Production Costing | 🟢 LOW | 3 days | Actual vs standard costing |

### 3.5 Multi-Company / Multi-Branch
| Feature | Priority | Effort | Description |
|---------|----------|--------|-------------|
| Company Entity Management | 🔴 HIGH | 2 days | Separate legal entities |
| Inter-Company Transactions | 🔴 HIGH | 3 days | Transfer pricing, eliminations |
| Consolidated Reporting | 🟡 MED | 3 days | Roll-up financials |
| Branch Management | 🟡 MED | 2 days | Multi-location inventory |
| Cross-Company Permissions | 🟡 MED | 2 days | Per-company access control |
| Separate Books | 🟢 LOW | 3 days | Independent accounting per entity |

### 3.6 Document Management System (DMS)
| Feature | Priority | Effort | Description |
|---------|----------|--------|-------------|
| File Upload/Storage | 🔴 HIGH | 2 days | Firebase Storage integration |
| Folder Organization | 🔴 HIGH | 2 days | Hierarchical folders |
| Document Templates | 🟡 MED | 3 days | Word/PDF templates with variables |
| Version Control | 🟡 MED | 3 days | Document version history |
| Digital Signatures | 🟡 MED | 4 days | E-signature workflow |
| Document Sharing | 🟢 LOW | 2 days | Expiring links, access control |
| OCR Search | 🟢 LOW | 3 days | Search within scanned documents |

---

## 4. Phase 9: Advanced ERP Modules

### 4.1 E-Commerce / Marketplace
| Feature | Priority | Effort | Description |
|---------|----------|--------|-------------|
| Product Catalog API | 🔴 HIGH | 3 days | REST API for web storefront |
| Shopping Cart Sync | 🔴 HIGH | 3 days | Cross-device cart persistence |
| Order Sync (Web → ERP) | 🔴 HIGH | 2 days | Auto-create orders in ERP |
| Inventory Sync (Real-time) | 🔴 HIGH | 3 days | Stock levels to storefront |
| Pricing Rules Engine | 🟡 MED | 4 days | Tiered pricing, promotions |
| Customer Portal Auth | 🟡 MED | 2 days | SSO between portal and ERP |
| Wishlist / Favorites | 🟢 LOW | 1 day | Customer saved items |
| Reviews & Ratings | 🟢 LOW | 2 days | Product feedback system |

### 4.2 Booking & Scheduling
| Feature | Priority | Effort | Description |
|---------|----------|--------|-------------|
| Resource Calendar | 🔴 HIGH | 3 days | Availability management |
| Appointment Booking | 🔴 HIGH | 3 days | Customer-facing booking |
| Staff Scheduling | 🟡 MED | 3 days | Shift management |
| Resource Allocation | 🟡 MED | 2 days | Assign resources to bookings |
| Recurring Bookings | 🟢 LOW | 2 days | Subscription schedules |
| Calendar Integration | 🟢 LOW | 3 days | Google/Outlook calendar sync |

### 4.3 Fleet Management
| Feature | Priority | Effort | Description |
|---------|----------|--------|-------------|
| Vehicle Registry | 🔴 HIGH | 2 days | Vehicle database with docs |
| Maintenance Scheduling | 🔴 HIGH | 3 days | Service reminders, logs |
| Fuel Tracking | 🟡 MED | 2 days | Fuel consumption analytics |
| Driver Assignment | 🟡 MED | 2 days | Driver-vehicle linking |
| GPS Tracking | 🟡 MED | 4 days | Real-time location, geofencing |
| Trip Logs | 🟢 LOW | 3 days | Trip costing, route optimization |
| Insurance Management | 🟢 LOW | 2 days | Policy renewal tracking |

### 4.4 Quality Control (QC)
| Feature | Priority | Effort | Description |
|---------|----------|--------|-------------|
| Inspection Checklists | 🔴 HIGH | 3 days | Configurable QC templates |
| QC Pass/Fail Tracking | 🔴 HIGH | 2 days | Lot/batch QC results |
| Non-Conformance Reports | 🟡 MED | 2 days | NCR workflow |
| Corrective Actions (CAPA) | 🟡 MED | 3 days | Root cause + action plan |
| Supplier Quality Score | 🟢 LOW | 2 days | Supplier performance metrics |
| Expiry/Recall Management | 🟢 LOW | 3 days | Batch recall capability |

---

## 5. Phase 10: Communication & Collaboration

### 5.1 Internal Chat & Messaging
| Feature | Priority | Effort | Description |
|---------|----------|--------|-------------|
| Direct Messages | 🔴 HIGH | 3 days | 1-on-1 chat |
| Group Chat | 🔴 HIGH | 3 days | Department/Project groups |
| Message Threads | 🟡 MED | 2 days | Threaded conversations |
| File Sharing in Chat | 🟡 MED | 2 days | Attach files to messages |
| Read Receipts | 🟢 LOW | 1 day | Seen/delivered indicators |
| Push Notifications | 🟢 LOW | 2 days | New message alerts |

### 5.2 Help Desk / Ticketing
| Feature | Priority | Effort | Description |
|---------|----------|--------|-------------|
| Ticket Creation | 🔴 HIGH | 2 days | Internal + customer tickets |
| Priority & SLA | 🔴 HIGH | 3 days | Response/resolution SLAs |
| Assignment & Escalation | 🔴 HIGH | 2 days | Auto-assign rules |
| Knowledge Base Integration | 🟡 MED | 2 days | Suggest articles from tickets |
| Ticket Analytics | 🟡 MED | 3 days | Volume, resolution time trends |
| Satisfaction Surveys | 🟢 LOW | 2 days | Post-ticket CSAT/NPS |

### 5.3 Knowledge Base / Wiki
| Feature | Priority | Effort | Description |
|---------|----------|--------|-------------|
| Article Management | 🔴 HIGH | 3 days | Rich text articles |
| Categories & Tags | 🔴 HIGH | 2 days | Taxonomy management |
| Search | 🟡 MED | 3 days | Full-text search |
| Version History | 🟡 MED | 2 days | Track article changes |
| Employee Training Modules | 🟢 LOW | 4 days | LMS-type courses |
| Feedback & Rating | 🟢 LOW | 1 day | Article usefulness rating |

### 5.4 External Integrations
| Platform | Feature | Effort | Description |
|----------|---------|--------|-------------|
| **WhatsApp** | Order notifications, chat support | 4 days | Business API integration |
| **Telegram** | Bot notifications, reports | 2 days | Bot API |
| **Slack** | ERP alerts, approval requests | 3 days | Webhook integration |
| **Email (SMTP)** | Invoices, reports, marketing | 3 days | Transactional email engine |
| **SMS (Twilio)** | Payment confirmations, alerts | 2 days | SMS notifications |
| **Zapier** | 5000+ app integration | 3 days | Webhook triggers/actions |

---

## 6. Phase 11: Platform Expansion

### 6.1 Customer Portal (Separate Web App)
```dart
// Separate Flutter Web project or Vue/React SPA
customer-portal/
├── features/
│   ├── auth/                       // SSO with main ERP
│   ├── orders/                     // View order history
│   ├── products/                   // Browse catalog
│   ├── quotes/                     // Request quotes
│   ├── invoices/                   // View/pay invoices
│   ├── support/                    // Create tickets
│   └── profile/                    // Manage account
```

### 6.2 Supplier Portal (Separate Web App)
```dart
supplier-portal/
├── features/
│   ├── auth/
│   ├── purchase-orders/            // View/receive POs
│   ├── invoices/                   // Submit invoices
│   ├── shipments/                  // Track deliveries
│   ├── catalog/                    // Manage product listings
│   ├── contracts/                  // View agreements
│   └── performance/                // View ratings
```

### 6.3 Driver Mobile App
```dart
driver-app/
├── features/
│   ├── auth/
│   ├── deliveries/                 // Assigned delivery list
│   ├── navigation/                 // GPS turn-by-turn
│   ├── proof-of-delivery/          // Photo + signature capture
│   ├── routes/                     // Optimized route view
│   └── earnings/                   // Delivery earnings
```

### 6.4 Web-Specific Enhancements
| Feature | Description |
|---------|-------------|
| PWA Support | Offline web app, install prompt |
| Desktop Layout | Full sidebar, multi-pane views |
| Keyboard Shortcuts | `Ctrl+N` new order, `Ctrl+F` search |
| Multi-Tab Support | Open orders/products in separate tabs |
| Drag & Drop | Reorder columns, upload files |
| Right-Click Context | Quick actions on data rows |
| Browser Notifications | Web push notifications |

### 6.5 Mobile-Specific Enhancements
| Feature | Description |
|---------|-------------|
| Bottom Navigation | 5-tab bottom bar for mobile |
| Swipe Gestures | Swipe to delete/approve/complete |
| Pull to Refresh | Refresh all data lists |
| Local Biometric Auth | Fingerprint/FaceID for app unlock |
| Camera QR/Barcode | Built-in scanner |
| Offline-First | Full offline capability |
| Push Notifications | FCM for all alerts |

---

## 7. Phase 12: Production Hardening

### 7.1 Comprehensive Testing
```dart
tests/
├── unit/                           // ❌ 0% coverage
│   ├── bloc/
│   │   ├── auth_bloc_test.dart     // Test all auth states
│   │   ├── admin_bloc_test.dart    // Test admin operations
│   │   ├── product_bloc_test.dart  // Test CRUD, validation
│   │   └── order_bloc_test.dart    // Test order lifecycle
│   ├── models/
│   │   ├── user_model_test.dart
│   │   ├── product_model_test.dart
│   │   └── local_sale_test.dart
│   ├── repositories/
│   │   └── auth_repository_test.dart
│   └── usecases/
│       └── create_order_test.dart
├── widget/
│   ├── auth/
│   │   ├── login_screen_test.dart
│   │   └── register_screen_test.dart
│   ├── admin/
│   │   └── admin_dashboard_test.dart
│   ├── dashboard/
│   │   └── stat_card_test.dart
│   ├── settings/
│   │   └── settings_screen_test.dart
│   └── shared/
│       ├── app_button_test.dart
│       └── permission_guard_test.dart
├── integration/
│   ├── auth_flow_test.dart
│   ├── product_crud_test.dart
│   ├── order_flow_test.dart
│   ├── admin_flow_test.dart
│   ├── offline_sync_test.dart
│   └── permission_flow_test.dart
└── mocks/
    ├── mock_firestore.dart
    ├── mock_auth.dart
    └── mock_repositories.dart
```

**Test Targets:**
- Unit Tests: 80% coverage (target 200+ tests)
- Widget Tests: 70% coverage (target 150+ tests)
- Integration Tests: 60% coverage (target 50+ tests)
- E2E Tests: 50% coverage (target 20+ flows)

### 7.2 Security Hardening
| Feature | Status | Action |
|---------|--------|--------|
| Firestore Security Rules | ⚠️ Basic | Write comprehensive rules for all collections |
| Field-Level Encryption | ❌ | Encrypt PII, payment data client-side |
| Two-Factor Auth | ❌ | TOTP via authenticator app |
| Biometric Login | ❌ | Fingerprint/FaceID on mobile |
| Session Management | ❌ | Token refresh, session timeout enforcement |
| IP Whitelist | ❌ | Restrict admin access by IP |
| Rate Limiting | ❌ | Prevent brute force, API abuse |
| CORS Configuration | ⚠️ Basic | Restrict to known origins |
| Audit Log Integrity | ❌ | Immutable audit logs |
| Data Retention Policies | ❌ | Auto-delete old data per policy |
| GDPR Compliance | ❌ | Data export, right to deletion |
| Penetration Testing | ❌ | Third-party security audit |

### 7.3 Performance Optimization
| Area | Current | Target | Action |
|------|---------|--------|--------|
| Cold Start | ~5s | <2s | Deferred loading, code splitting |
| Screen Load | ~1.5s | <300ms | Prefetch data, cache responses |
| List Scroll | 30fps | 60fps | ListView.builder, itemExtent |
| Image Load | ~2s | <500ms | CachedNetworkImage, preload |
| Bundle Size (APK) | ~80MB | <40MB | Tree shaking, code splitting |
| API Latency | ~500ms | <100ms | CDN, edge functions |
| Firebase Reads | 100/doc | 1-2/doc | Denormalization, subcollections |
| Memory Usage | ~200MB | <100MB | Dispose controllers, lazy load |

### 7.4 Monitoring & Observability
```yaml
Monitoring Stack:
  - Firebase Crashlytics: ✅ Installed
  - Firebase Analytics: ✅ Installed
  - Firebase Performance: ❌ Not configured
  - Custom Logger: ⚠️ print() statements only
  - Error Boundaries: ❌ Not implemented
  - Uptime Monitoring: ❌ Not configured
  - Alerting: ❌ No alert rules
  - Dashboard: ❌ No Grafana/Datadog

Required:
  - Centralized logging service (replaces print())
  - Performance tracing for all screens
  - Error boundary widgets at route level
  - Alert channels (Email, Slack, PagerDuty)
  - Weekly health report email
```

---

## 8. Phase 13: AI & Intelligence Layer

### 8.1 AI Features (Expand Existing)
| Feature | Status | Enhancement |
|---------|--------|-------------|
| Demand Prediction | ✅ Basic | Add seasonality, promotions model |
| Invoice OCR | ✅ Basic | Add multi-language, handwriting |
| **Chat Assistant** | ❌ | ERP assistant for queries, navigation |
| **Anomaly Detection** | ❌ | Fraud detection in payments, orders |
| **Smart Recommendations** | ❌ | Cross-sell, up-sell product suggestions |
| **Auto-Categorization** | ❌ | Auto-sort expenses, transactions |
| **Sentiment Analysis** | ❌ | Customer feedback, ticket sentiment |
| **Predictive Maintenance** | ❌ | Equipment failure prediction |
| **Price Optimization** | ❌ | Dynamic pricing based on demand |
| **Credit Scoring** | ❌ | Customer credit risk assessment |

### 8.2 AI Chat Assistant Architecture
```dart
// Natural language ERP assistant
ai/
├── assistant/
│   ├── intent_classifier.dart      // Identify user intent
│   ├── entity_extractor.dart       // Extract entities from query
│   ├── response_generator.dart     // Generate human-like response
│   └── context_manager.dart        // Conversation context
├── models/
│   ├── chat_message.dart
│   └── conversation.dart
└── presentation/
    ├── screens/
    │   └── ai_chat_screen.dart     // Chat UI
    └── widgets/
        ├── chat_bubble.dart
        └── quick_actions.dart
```

---

## 9. Phase 14: Multi-Tenant & Marketplace

### 9.1 Multi-Tenant Architecture
```dart
// Each tenant = separate customer company
tenancy/
├── tenant_manager.dart             // Tenant isolation logic
├── tenant_config.dart              // Per-tenant settings
├── tenant_database.dart            // Separate DB/prefix per tenant
└── tenant_migration.dart           // Schema migration per tenant

// Data isolation strategies
Strategy 1: Collection Prefix   -> companies/{companyId}/products/...
Strategy 2: Document Field      -> products/{id} with companyId field
Strategy 3: Separate Projects   -> One Firebase project per tenant
```

### 9.2 ERP App Marketplace
```dart
marketplace/
├── app_registry.dart               // All available modules
├── app_installer.dart              // Module installation process
├── app_licensing.dart              // License key validation
├── app_updater.dart                // Module update mechanism
└── presentation/
    ├── screens/
    │   └── marketplace_screen.dart
    └── widgets/
        ├── app_card.dart
        └── app_detail.dart

// Revenue Models
- Per-module licensing (monthly/annual)
- Usage-based pricing (transactions, users)
- Enterprise bundle (all modules)
- Custom development (bespoke modules)
```

---

## 10. Complete Firebase Security Rules

### 10.1 Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function hasRole(role) {
      return isAuthenticated() 
        && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == role;
    }
    
    function hasRoleIn(roles) {
      return isAuthenticated() 
        && roles.hasAny([get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role]);
    }
    
    function isAdmin() {
      return hasRoleIn(['super_admin', 'admin']);
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    // User profiles - owner read, admin write
    match /users/{userId} {
      allow read: if isAuthenticated() && (isOwner(userId) || isAdmin());
      allow create: if isAuthenticated();
      allow update: if isOwner(userId) || isAdmin();
      allow delete: if isAdmin();
    }

    // Products - authenticated users
    match /products/{productId} {
      allow read: if isAuthenticated();
      allow create: if hasRoleIn(['super_admin', 'admin', 'data_entry']);
      allow update: if hasRoleIn(['super_admin', 'admin', 'supervisor', 'data_entry']);
      allow delete: if isAdmin();
    }

    // Orders - role-based access
    match /orders/{orderId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if hasRoleIn(['super_admin', 'admin', 'supervisor']);
      allow delete: if isAdmin();
    }

    // Payments - finance + admin
    match /payments/{paymentId} {
      allow read: if isAuthenticated();
      allow create, update: if hasRoleIn(['super_admin', 'admin', 'accountant']);
      allow delete: if isAdmin();
    }

    // Admin-only collections
    match /system_config/{docId} {
      allow read: if hasRoleIn(['super_admin', 'admin']);
      allow write: if isAdmin();
    }

    match /audit_logs/{logId} {
      allow read: if hasRoleIn(['super_admin', 'admin']);
      allow create: if isAuthenticated();
      allow delete: if false;  // Immutable
    }

    match /notifications/{notificationId} {
      allow read: if isAuthenticated() 
        && request.auth.uid == resource.data.userId;
      allow update: if isAuthenticated()
        && request.auth.uid == resource.data.userId;
    }

    // HR data - admin + supervisor
    match /employees/{employeeId} {
      allow read: if hasRoleIn(['super_admin', 'admin', 'supervisor']);
      allow write: if hasRoleIn(['super_admin', 'admin']);
    }

    // Suppliers
    match /suppliers/{supplierId} {
      allow read: if isAuthenticated();
      allow write: if hasRoleIn(['super_admin', 'admin', 'data_entry']);
    }

    // Purchases
    match /purchases/{purchaseId} {
      allow read: if isAuthenticated();
      allow write: if hasRoleIn(['super_admin', 'admin', 'supervisor']);
    }

    // Expenses
    match /expenses/{expenseId} {
      allow read: if isAuthenticated();
      allow write: if hasRoleIn(['super_admin', 'admin', 'accountant', 'supervisor']);
    }

    // Assets
    match /assets/{assetId} {
      allow read: if isAuthenticated();
      allow write: if hasRoleIn(['super_admin', 'admin']);
    }

    // Projects
    match /projects/{projectId} {
      allow read: if isAuthenticated();
      allow write: if hasRoleIn(['super_admin', 'admin', 'supervisor']);
    }

    // All other collections - deny by default
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

### 10.2 Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Product images
    match /products/{productId}/{fileName} {
      allow read: if true;  // Public read for product images
      allow write: if request.auth != null
        && request.resource.size < 5 * 1024 * 1024  // 5MB limit
        && request.resource.contentType.matches('image/.*');
      allow delete: if request.auth != null;
    }

    // Company documents
    match /documents/{documentId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
        && request.resource.size < 10 * 1024 * 1024  // 10MB limit
        && request.resource.contentType.matches('application/pdf|image/.*|text/.*|application/vnd.openxmlformats-officedocument.*');
      allow delete: if request.auth != null;
    }

    // User avatars
    match /avatars/{userId}/{fileName} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
      allow delete: if request.auth != null && request.auth.uid == userId;
    }

    // Receipts / invoices (PDF)
    match /receipts/{orderId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
        && (request.resource.contentType == 'application/pdf' || request.resource.contentType.matches('image/.*'));
    }
  }
}
```

---

## 11. Cloud Functions Enhancement Plan

### 11.1 Admin Route Module
```javascript
// /api/v1/admin/* - 12 endpoints (MISSING)
routes/
├── admin.ts                         // ❌ MISSING - All admin endpoints
├── analytics.ts                     // ❌ MISSING - Analytics aggregation
├── reports.ts                       // ❌ MISSING - Report generation
├── webhooks.ts                      // ❌ MISSING - External integrations
└── notifications.ts                 // ❌ MISSING - Notification dispatch
```

### 11.2 Scheduled Functions
```javascript
// Background tasks (MISSING)
scheduled/
├── daily_backup.ts                  // ❌ MISSING - Nightly Firestore backup
├── weekly_report.ts                 // ❌ MISSING - Email weekly reports
├── invoice_reminders.ts             // ❌ MISSING - Overdue payment notices
├── stock_alerts.ts                  // ❌ MISSING - Low stock notifications
├── data_cleanup.ts                  // ❌ MISSING - Archive old records
├── sync_forex_rates.ts             // ❌ MISSING - Update currency rates
└── generate_sitemap.ts             // ❌ MISSING - SEO for web portal
```

### 11.3 Webhook Handlers
```javascript
// External service webhooks (MISSING)
webhooks/
├── payment_gateway.ts               // ❌ MISSING - Payment status updates
├── shipping_carrier.ts              // ❌ MISSING - Shipment tracking updates
├── sms_status.ts                    // ❌ MISSING - SMS delivery reports
├── email_bounce.ts                  // ❌ MISSING - Email bounce handling
└── zapier_trigger.ts                // ❌ MISSING - Zapier integration
```

---

## 12. Testing & Quality Gates

### 12.1 Unit Test Files Needed
```dart
// Minimum 200 unit tests across:
- models/ (30 tests) - Serialization, validation, equality
- blocs/ (80 tests) - State transitions, event handling
- repositories/ (30 tests) - Data source mocking
- usecases/ (30 tests) - Business logic validation
- services/ (30 tests) - Sync, audit, notification logic
```

### 12.2 Widget Test Files Needed
```dart
// Minimum 150 widget tests across:
- shared/widgets/ (30 tests) - All shared UI components
- auth/ (15 tests) - Login, register, forgot password
- admin/ (20 tests) - Dashboard, module, user, permission screens
- dashboard/ (10 tests) - Stat cards, charts, order cards
- products/ (15 tests) - List, detail, create product
- orders/ (15 tests) - List, detail, create order
- settings/ (10 tests) - Settings form interactions
- new modules/ (35 tests) - HR, Suppliers, Purchases, etc.
```

### 12.3 Integration Test Flows
```dart
// Minimum 50 integration tests:
1. Auth Flow: Register → Login → Logout → Re-login
2. Product CRUD: Create → Read → Update → Delete
3. Order Flow: Create order → Process payment → Update status → Complete
4. Admin Flow: Load config → Toggle module → Verify user list
5. Offline Sync: Go offline → Create sale → Go online → Verify sync
6. Permission Flow: Login as viewer → Attempt admin → Verify blocked
7. Settings Flow: Load settings → Change value → Verify persisted
8. Multi-module: Create product → Create PO → Receive → Update inventory
```

### 12.4 Quality Gates (CI Pipeline)
```yaml
quality_gates:
  - name: "Static Analysis"
    command: "flutter analyze"
    threshold: "0 errors, 0 warnings"
    fail: true

  - name: "Unit Tests"
    command: "flutter test --coverage test/unit/"
    threshold: "80% minimum"
    fail: true

  - name: "Widget Tests"
    command: "flutter test --coverage test/widget/"
    threshold: "70% minimum"
    fail: true

  - name: "Integration Tests"
    command: "flutter test test/integration/"
    threshold: "60% minimum"
    fail: false

  - name: "Code Formatting"
    command: "dart format --set-exit-if-changed lib/"
    fail: true

  - name: "Dependency Check"
    command: "flutter pub outdated --no-dev-dependencies"
    threshold: "0 major outdated"
    fail: false

  - name: "Bundle Size"
    command: "flutter build apk --target-platform android-arm64 --analyze-size"
    threshold: "< 40MB"
    fail: false
```

---

## 13. CI/CD Pipeline

### 13.1 Full GitHub Actions Workflow
```yaml
name: Xiishopy ERP | Build + Test + Deploy
on:
  push:
    branches: [main, develop, staging]
  pull_request:
    branches: [main, develop]
  schedule:
    - cron: '0 2 * * 0'  # Weekly security scan

env:
  FLUTTER_VERSION: '3.24.0'
  JAVA_VERSION: '17'

jobs:
  # ============================
  # 1. ANALYSIS & QUALITY CHECKS
  # ============================
  analyze:
    name: 🔍 Static Analysis
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
      - run: flutter pub get
      - run: flutter analyze --fatal-infos
      - run: dart format --set-exit-if-changed lib/
      - run: flutter pub outdated --no-dev-dependencies || true

  # ============================
  # 2. UNIT & WIDGET TESTS
  # ============================
  test:
    name: 🧪 Unit + Widget Tests
    needs: analyze
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
      - run: flutter pub get
      - run: flutter test --coverage --machine > test-results.json
      - uses: dorny/test-reporter@v1
        with:
          name: 'Test Results'
          path: test-results.json
          reporter: 'flutter-json'
      - uses: codecov/codecov-action@v4
        with:
          file: coverage/lcov.info
          fail_ci_if_error: true

  # ============================
  # 3. SECURITY SCAN
  # ============================
  security:
    name: 🔒 Security Scan
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run dependency vulnerability scan
        run: |
          npx audit-ci --high
      - name: Run SAST scan
        uses: github/codeql-action/analyze@v3
        with:
          languages: javascript, typescript, dart
          queries: security-extended

  # ============================
  # 4. BUILD &ROID
  # ============================
  build-android:
    name: 📱 Build Android
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
      - run: flutter pub get
      - run: flutter build apk --release
      - run: flutter build appbundle --release
      - uses: actions/upload-artifact@v4
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/app-release.apk
      - uses: actions/upload-artifact@v4
        with:
          name: android-aab
          path: build/app/outputs/bundle/release/app-release.aab

  # ============================
  # 5. BUILD iOS
  # ============================
  build-ios:
    name: 📱 Build iOS
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
      - run: flutter pub get
      - run: flutter build ios --release --no-codesign
      - uses: actions/upload-artifact@v4
        with:
          name: ios-build
          path: build/ios/iphoneos/Runner.app

  # ============================
  # 6. BUILD WEB
  # ============================
  build-web:
    name: 🌐 Build Web
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
      - run: flutter pub get
      - run: flutter build web --release
      - uses: actions/upload-pages-artifact@v3
        with:
          path: build/web

  # ============================
  # 7. DEPLOY CLOUD FUNCTIONS
  # ============================
  deploy-functions:
    name: ☁️ Deploy Cloud Functions
    needs: [build-android, build-ios]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
      - run: cd functions && npm ci
      - run: cd functions && npm run build
      - uses: w9jds/firebase-action@v13
        with:
          args: deploy --only functions
        env:
          GCP_SA_KEY: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}

  # ============================
  # 8. DEPLOY WEB
  # ============================
  deploy-web:
    name: 🌐 Deploy Web to Firebase Hosting
    needs: build-web
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: w9jds/firebase-action@v13
        with:
          args: deploy --only hosting
        env:
          GCP_SA_KEY: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}

  # ============================
  # 9. DEPLOY TO APP STORES
  # ============================
  deploy-android:
    name: 🚀 Deploy Android
    needs: build-android
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: android-aab
      - uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJson: ${{ secrets.PLAY_CONSOLE_SA }}
          packageName: com.xiishopy.erp
          releaseFiles: app-release.aab
          track: production

  deploy-ios:
    name: 🚀 Deploy iOS
    needs: build-ios
    runs-on: macos-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: ios-build
      - name: Upload to TestFlight
        uses: apple-actions/upload-testflight-build@v1
        with:
          ipa-path: Runner.ipa
          issuer-id: ${{ secrets.APPSTORE_ISSUER_ID }}
          key-id: ${{ secrets.APPSTORE_KEY_ID }}
          private-key: ${{ secrets.APPSTORE_PRIVATE_KEY }}

  # ============================
  # 10. FIRESTORE BACKUP
  # ============================
  backup:
    name: 💾 Firestore Backup
    needs: deploy-functions
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: google-github-actions/auth@v2
        with:
          credentials_json: ${{ secrets.GCP_SA_KEY }}
      - name: Export Firestore
        run: |
          gcloud firestore export gs://xiishopy-erp-backups/$(date +%Y-%m-%d) \
            --project=${{ secrets.FIREBASE_PROJECT_ID }}
```

---

## 14. Deployment Architecture

### 14.1 Environment Matrix
```yaml
environments:
  development:
    firebase_project: demo-xiishopy-erp
    api_url: http://localhost:5001
    emulator: true
    features:
      - Debug logging
      - Dev tools enabled
      - Performance monitoring off
  
  staging:
    firebase_project: staging-xiishopy-erp
    api_url: https://staging-api.xiishopy.com
    emulator: false
    features:
      - Error tracking on
      - Analytics on
      - Performance monitoring on
  
  production:
    firebase_project: xiishopy-erp-prod
    api_url: https://api.xiishopy.com
    emulator: false
    features:
      - All features on
      - Rate limiting on
      - SSL pinning on
      - Crash reporting on
```

### 14.2 Infrastructure as Code (Terraform)
```hcl
// MISSING: Infrastructure provisioning
resource "google_project" "xiishopy" {
  name       = "Xiishopy ERP"
  project_id = "xiishopy-erp-prod"
}

resource "google_firestore_database" "default" {
  project     = google_project.xiishopy.project_id
  name        = "(default)"
  location_id = "europe-west1"
  type        = "FIRESTORE_NATIVE"
}

resource "google_storage_bucket" "backups" {
  name          = "xiishopy-erp-backups"
  location      = "EU"
  force_destroy = false
  versioning {
    enabled = true
  }
  lifecycle_rule {
    condition { age = 90 }
    action { type = "Delete" }
  }
}
```

### 14.3 Docker Configuration
```dockerfile
# Dockerfile (MISSING)
FROM node:18-alpine AS functions-build
WORKDIR /app
COPY functions/package*.json ./
RUN npm ci
COPY functions/ ./
RUN npm run build

FROM scratch AS functions
COPY --from=functions-build /app/lib /lib

# Flutter web build
FROM flutter:3.24 AS web-build
WORKDIR /app
COPY xiishopy_erp/ ./
RUN flutter pub get && flutter build web --release

FROM nginx:alpine AS web
COPY --from=web-build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
```

---

## 15. Implementation Timeline: 90-Day Plan

```yaml
sprint_1: "Deep Integration (Days 1-14)"
  phase_7_hr_full:
    effort: 3 days
    depends_on: []
  phase_7_suppliers_full:
    effort: 2 days
    depends_on: []
  phase_7_purchases_full:
    effort: 3 days
    depends_on: []
  phase_7_expenses_full:
    effort: 2 days
    depends_on: []
  phase_7_assets_full:
    effort: 2 days
    depends_on: []
  phase_7_projects_full:
    effort: 2 days
    depends_on: []

sprint_2: "Core Missing Modules (Days 15-28)"
  phase_8_crm:
    effort: 7 days
    depends_on: [sprint_1]
  phase_8_accounting:
    effort: 7 days
    depends_on: [sprint_1]

sprint_3: "Advanced Modules (Days 29-42)"
  phase_8_tax_engine:
    effort: 4 days
    depends_on: [sprint_2]
  phase_8_manufacturing:
    effort: 7 days
    depends_on: [sprint_1]
  phase_8_dms:
    effort: 4 days
    depends_on: []

sprint_4: "Platform Expansion (Days 43-56)"
  phase_9_ecommerce:
    effort: 7 days
    depends_on: [sprint_1]
  phase_9_booking:
    effort: 5 days
    depends_on: []
  phase_9_fleet:
    effort: 5 days
    depends_on: []
  phase_10_helpdesk:
    effort: 5 days
    depends_on: []

sprint_5: "Integration & Communication (Days 57-70)"
  phase_10_chat:
    effort: 5 days
    depends_on: [sprint_4]
  phase_10_knowledge_base:
    effort: 4 days
    depends_on: []
  phase_10_integrations:
    effort: 7 days
    depends_on: [sprint_4]
  phase_11_customer_portal:
    effort: 7 days
    depends_on: [sprint_2]

sprint_6: "Hardening & Launch (Days 71-90)"
  phase_7_tests:
    effort: 10 days
    depends_on: [sprint_1, sprint_2, sprint_3]
  phase_12_security:
    effort: 5 days
    depends_on: [sprint_5]
  phase_13_ai:
    effort: 7 days
    depends_on: [sprint_5]
  phase_12_ci_cd:
    effort: 3 days
    depends_on: []
  phase_12_performance:
    effort: 3 days
    depends_on: [sprint_5]
  phase_12_monitoring:
    effort: 2 days
    depends_on: []
```

---

## 📊 Summary Dashboard

### Current Completion: ~35%
```text
Phase 1-6 (Base) ████████████████████░░░░░░░░  65% done  (mostly UI, missing backend)
Phase 7 (Integration) ██░░░░░░░░░░░░░░░░░░░░  10% done
Phase 8 (Core Modules) ░░░░░░░░░░░░░░░░░░░░░  0% done
Phase 9 (Advanced) ░░░░░░░░░░░░░░░░░░░░░  0% done
Phase 10 (Collaboration) ░░░░░░░░░░░░░░░░░░░░░  0% done
Phase 11 (Platform) ░░░░░░░░░░░░░░░░░░░░░  0% done
Phase 12 (Hardening) ░░░░░░░░░░░░░░░░░░░░░  5% done
Phase 13 (AI) ░░░░░░░░░░░░░░░░░░░░░  5% done (basic AI only)
Phase 14 (Multi-Tenant) ░░░░░░░░░░░░░░░░░░░░░  0% done
Overall: ███████░░░░░░░░░░░░░░░░░░░░  35%
```

### Lines of Code
| Component | Lines | Status |
|-----------|-------|--------|
| Flutter/Dart UI Screens | ~8,500 | ✅ Done |
| Core Infrastructure | ~2,300 | ✅ Done |
| BLoC + State Management | ~1,200 | ⚠️ Admin only |
| Firestore Indexes | 49 lines | ✅ Done |
| Cloud Functions (TS) | ~3,200 | ✅ Existing, needs admin endpoints |
| **Total Implemented** | **~15,249** | |
| **Estimated Total (Target)** | **~45,000** | |
| Remaining to Build | ~29,751 | 65% left |

### Priority Ranking for Next Sprint
| # | Task | Effort | Impact | Risk |
|---|------|--------|--------|------|
| 1 | Full BLoC for HR module | 3 days | 🔴 HIGH | Low |
| 2 | Full BLoC for Suppliers | 2 days | 🔴 HIGH | Low |
| 3 | Full BLoC for Purchases | 3 days | 🔴 HIGH | Low |
| 4 | Full BLoC for Expenses | 2 days | 🔴 HIGH | Low |
| 5 | Full BLoC for Assets | 2 days | 🔴 HIGH | Low |
| 6 | Full BLoC for Projects | 2 days | 🔴 HIGH | Low |
| 7 | POS Terminal Screen | 5 days | 🟡 MED | Medium |
| 8 | Admin Cloud Functions | 3 days | 🔴 HIGH | Low |
| 9 | Firestore Security Rules | 2 days | 🔴 HIGH | Low |
| 10 | Unit Tests for existing code | 5 days | 🟡 MED | Low |

---

*Last updated: June 28, 2026 | Next review: July 5, 2026*