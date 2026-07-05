# Xiishopy ERP — User Guide

> **Cross-platform ERP for East African Distributors & Retailers**  
> Built with Flutter + Firebase Emulator Suite

---

## 📋 Table of Contents

1. [Quick Start](#1-quick-start)
2. [Prerequisites](#2-prerequisites)
3. [Running the Project](#3-running-the-project)
4. [Seeded Test Credentials](#4-seeded-test-credentials)
5. [Features Overview](#5-features-overview)
6. [Architecture](#6-architecture)
7. [Project Structure](#7-project-structure)
8. [Customizations & Extensions](#8-customizations--extensions)
9. [Known Issues & Workarounds](#9-known-issues--workarounds)

---

## 1. Quick Start

```bash
# Clone and enter the project
cd /Users/abdirisaqahmed/Desktop/Marketo/XiishopyERP

# Start Firebase Emulators (Terminal 1)
./scripts/start-emulators.sh

# Seed test data (Terminal 2, emulators must be running)
cd functions && npx ts-node scripts/seed-firestore.ts

# Run Flutter Web (Terminal 3)
cd xiishopy_erp
flutter run -d chrome --web-port 8888
```

The app opens at **http://127.0.0.1:8888**

---

## 2. Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Flutter SDK | 3.44.0+ | Mobile/Web development |
| Firebase CLI | 13.x+ | Emulator suite |
| Node.js | 18.x+ | Cloud Functions |
| Xcode | 16.x | iOS builds (optional) |
| Android Studio | Latest | Android builds (optional) |

**Required Flutter packages:**
```yaml
dependencies:
  flutter_bloc: ^9.1.0
  go_router: ^14.0.0
  get_it: ^8.0.0
  firebase_core: ^3.12.0
  firebase_auth: ^5.5.0
  cloud_firestore: ^5.6.0
  fl_chart: ^0.69.2
  google_fonts: ^6.2.1
  dartz: ^0.10.1
```

---

## 3. Running the Project

### Terminal 1 — Start Firebase Emulators
```bash
cd /Users/abdirisaqahmed/Desktop/Marketo/XiishopyERP
./scripts/start-emulators.sh
```
This starts all Firebase services locally:
- Auth: `http://127.0.0.1:9099`
- Firestore: `http://127.0.0.1:8080`
- Storage: `http://127.0.0.1:9199`
- Functions: `http://127.0.0.1:5001`
- PubSub: `http://127.0.0.1:8085`

### Terminal 2 — Seed Test Data
```bash
cd functions
npx ts-node scripts/seed-firestore.ts
```
This populates Firestore with sample:
- Products (20+ items across categories)
- Orders (10+ orders with various statuses)
- Payments (completed, pending, failed)
- Shipments (in transit, delivered)
- Customers (distributors & retailers)

### Terminal 3 — Run Flutter
```bash
cd xiishopy_erp

# Web (recommended for development)
flutter run -d chrome --web-port 8888

# Android
flutter run -d android

# iOS Simulator (requires Xcode + project at path without spaces)
flutter run -d 034FD428-FB53-4CF6-B7B8-9302BB4BCA8D
```

**Important:** The iOS simulator build requires the project to be at a path without spaces (e.g. `XiishopyERP`, not `Xiishopy ERP`). Xcode SPM has a known bug resolving plugin paths that contain spaces.

---

## 4. Seeded Test Credentials

### Email/Password Authentication
| Email | Password | Role | Notes |
|-------|----------|------|-------|
| `distributor1@xiishopy.com` | `Test123!` | Distributor | Full access to dashboard, products, orders |
| `retailer1@xiishopy.com` | `Test123!` | Retailer | Can view products, place orders |
| `wholesaler1@xiishopy.com` | `Test123!` | Wholesaler | Can view inventory |

### API Testing (curl)
```bash
# Authenticate
curl -s -X POST "http://127.0.0.1:9099/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=fake-key" \
  -H "Content-Type: application/json" \
  -d '{"email":"distributor1@xiishopy.com","password":"Test123!","returnSecureToken":true}'
```

### Firebase Emulator UI
Access **http://127.0.0.1:4000** for the Firebase Emulator Suite dashboard to:
- View Firestore data
- Manage Authentication users
- Trigger Cloud Functions
- Test security rules

---

## 5. Features Overview

### 🏠 Dashboard
- **Revenue Chart**: 7-day bar chart from Firestore payments
- **Order Status PieChart**: Visual breakdown of order states
- **Stat Cards**: Real-time counts for Revenue, Orders, Products, Low Stock
- **Recent Orders**: Latest orders with total calculations

### 📦 Products
- **Product List**: Sortable, filterable by category
- **Product Detail**: Full info, stock levels, reorder threshold
- **Low Stock Alerts**: Auto-highlighted products
- **Stock Management**: Current stock vs reorder level

### 🛒 Orders
- **Order List**: Filter by status, date
- **Order Detail**: Items, payment summary, invoice generation
- **Create Order**: Product picker, quantity, delivery address
- **Status Tracking**: Real-time order lifecycle

### 💳 Payments
- **Payment List**: M-Pesa, Airtel Money, Card payments
- **Payment Detail**: Transaction info, provider, status
- **Multi-Currency**: USD, KES, TZS, UGX, RWF support
- **Status Badges**: Completed/Failed/Pending indicators

### 🚚 Logistics
- **Shipment List**: Carrier, tracking number, status
- **Shipment Detail**: Origin → Destination, tracking history
- **Carrier Support**: DHL, Sendy, Amit Trucking
- **Status Tracking**: Picked up → In Transit → Delivered

### 📊 Analytics
- **Revenue Analytics**: 7-day trend visualization
- **Product Stock Chart**: Top products by inventory
- **Order Distribution**: Status breakdown with legend
- **Key Metrics**: Total orders, revenue, products, low stock

### ⚙️ Settings
- **Profile Management**: User info display
- **Language Switcher**: Ready for i18n (EN/SW/LG/FR)
- **Theme Mode**: Light/Dark/System support

---

## 6. Architecture

### Clean Architecture Pattern
```
lib/features/{feature}/
├── bloc/           # State management (Bloc pattern)
├── data/           # Data layer (models, datasources, repositories)
└── presentation/   # UI layer (screens, widgets)
```

### State Management Flow
```
UI (BlocBuilder) → Bloc → Repository → DataSource → Firestore
                              ↓
                    Either<Failure, Data> ← Error Handling
```

### Dependency Injection
```dart
// GetIt registrations in service_locator.dart
sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(...));
sl.registerFactory<ProductBloc>(() => ProductBloc(...));
```

---

## 7. Project Structure

```
xiishopy_erp/
├── lib/
│   ├── main.dart              # Firebase init + DI init
│   ├── app.dart               # MultiBlocProvider + Dashboard
│   ├── core/
│   │   ├── config/
│   │   │   ├── routes.dart    # 20+ GoRouter routes
│   │   │   └── theme.dart     # Dark theme (#1A1A2E background)
│   │   ├── constants/enums.dart
│   │   ├── di/service_locator.dart
│   │   ├── errors/failures.dart
│   │   └── network/firebase_service.dart
│   ├── features/
│   │   ├── auth/
│   │   ├── products/
│   │   ├── orders/
│   │   ├── payments/
│   │   ├── logistics/
│   │   ├── customers/
│   │   ├── dashboard/
│   │   └── analytics/
│   └── shared/widgets/
│       ├── stat_card.dart
│       ├── status_badge.dart
│       └── ...
├── functions/                 # Firebase Cloud Functions
│   ├── src/routes/
│   ├── src/services/
│   └── scripts/seed-firestore.ts
└── scripts/
    └── start-emulators.sh
```

---

## 8. Customizations & Extensions

### Adding New Features
1. Create model in `lib/features/{feature}/data/models/`
2. Create datasource in `lib/features/{feature}/data/datasources/`
3. Create repository in `lib/features/{feature}/domain/repositories/`
4. Create repository impl in `lib/features/{feature}/data/repositories/`
5. Create bloc (event, state, bloc) in `lib/features/{feature}/bloc/`
6. Create screen in `lib/features/{feature}/presentation/screens/`
7. Register in `lib/core/di/service_locator.dart`
8. Add route in `lib/core/config/routes.dart`

### Localization Setup
The app uses `flutter_localizations` and `intl`. To add translations:
1. Create `lib/core/localization/` directory
2. Add `S.delegate` for each supported language
3. Wrap text in `S.of(context).keyName`
4. Supported languages: English (default), Swahili, Luganda, French

### Firebase Production Deployment
```bash
# Create production Firebase project
firebase projects:create xiishopy-erp-prod

# Register apps (iOS, Android, Web)
firebase apps:create ...

# Deploy
firebase deploy --only functions,firestore,storage,hosting
```

### Testing
```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widgets/

# Integration tests (requires emulators running)
flutter test test/integration/
```

### Build Commands
```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (requires path without spaces)
flutter build ios --release

# Web
flutter build web --release
```

---

## 9. Known Issues & Workarounds

### iOS Simulator — SPM Path Bug
**Issue:** `xcodebuild` fails with `fileNotFound` for `pubspec.yaml` when the project path contains spaces (e.g. `Xiishopy ERP`). This is a known Flutter + Xcode SPM integration bug affecting Firebase plugins.

**Fix:** Move or symlink the project to a path without spaces:
```bash
# Option A — Move (permanent)
mv "/path/to/Xiishopy ERP" /path/to/XiishopyERP

# Option B — Symlink (keeps original)
ln -s "/path/to/Xiishopy ERP" /path/to/XiishopyERP
```

Then run from the new path:
```bash
cd /path/to/XiishopyERP/xiishopy_erp
flutter clean && flutter pub get
flutter run -d <simulator-id>
```

### BLoC Emit-After-Completion Crash
**Issue:** In bloc 9.x, calling `emit()` inside a `.listen()` callback throws `emit was called after an event handler completed normally` if the event handler is not `async` and does not `await` the subscription.

**Fix:** Apply this pattern to all bloc event handlers that use `.listen()`:
```dart
Future<void> _onWatch(Event event, Emitter<State> emit) async {
  emit(Loading());
  await _sub?.cancel();
  if (emit.isDone) return;
  _sub = _repository.watch().listen(
    (result) {
      if (emit.isDone) return;
      result.fold(
        (f) => emit(Error(message: f.message)),
        (d) => emit(Loaded(data: d)),
      );
    },
    onError: (e) {
      if (emit.isDone) return;
      emit(Error(message: e.toString()));
    },
  );
}
```

**Fixed in these files:**
- `lib/features/dashboard/bloc/dashboard_bloc.dart`
- `lib/features/orders/bloc/order_bloc.dart`
- `lib/features/products/bloc/product_bloc.dart`
- `lib/features/payments/bloc/payment_bloc.dart`
- `lib/features/logistics/bloc/logistics_bloc.dart`
- `lib/features/customers/bloc/customer_bloc.dart`

### ListTile Background Ink Warning
**Issue:** `ListTile` wrapped in a `DecoratedBox`/`Container` with background color logs `ListTile background color or ink splashes may be invisible`.

**Fix:** Move the background color into a `Material` widget that wraps the `ListTile`:
```dart
Widget _buildNavItem(IconData icon, String label, bool selected, String route) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
    child: Material(
      color: selected ? const Color(0xFF0F3460) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: ListTile(
        leading: Icon(icon, ...),
        title: Text(label, ...),
        onTap: () => appRouter.go(route),
      ),
    ),
  );
}
```

### Firebase Project Deletion
**Issue:** `firebase deploy --only firestore:rules` returns `Project 'projects/demo-xiishopy-erp' not found or deleted`.

**Fix:** Re-create the Firebase project or update `firebase.json` / `.firebaserc` to point to a valid project ID. The local emulators will still work without a live project.

### Port Conflicts
**Issue:** Port 8888 already in use from previous Flutter run.

**Fix:**
```bash
lsof -ti:8888 2>/dev/null | xargs kill -9 2>/dev/null
flutter run -d chrome --web-port 8889
```