/// Xiishopy ERP - Local Database Service (Hive)
/// Provides offline-first local storage for POS, product cache, and pending sync queue.
library;

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

/// Local sale stored offline before sync to Firebase
class LocalSale {
  final String id;
  final List<LocalSaleItem> items;
  final double totalAmount;
  final String paymentMethod;
  final DateTime createdAt;
  bool synced;
  String? firebaseOrderId;

  LocalSale({
    String? id,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    DateTime? createdAt,
    this.synced = false,
    this.firebaseOrderId,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((i) => i.toJson()).toList(),
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
        'createdAt': createdAt.toIso8601String(),
        'synced': synced,
        'firebaseOrderId': firebaseOrderId,
      };

  factory LocalSale.fromJson(Map<String, dynamic> json) => LocalSale(
        id: json['id'] as String,
        items: (json['items'] as List).map((i) => LocalSaleItem.fromJson(i)).toList(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        paymentMethod: json['paymentMethod'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        synced: json['synced'] as bool? ?? false,
        firebaseOrderId: json['firebaseOrderId'] as String?,
      );
}

class LocalSaleItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;

  LocalSaleItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'price': price,
        'quantity': quantity,
      };

  factory LocalSaleItem.fromJson(Map<String, dynamic> json) => LocalSaleItem(
        productId: json['productId'] as String,
        productName: json['productName'] as String,
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'] as int,
      );
}

/// Cached product for offline access
class LocalProduct {
  final String id;
  final String name;
  final double price;
  final int stockLevel;
  final String category;
  final DateTime lastSync;

  LocalProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.stockLevel,
    required this.category,
    DateTime? lastSync,
  }) : lastSync = lastSync ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'stockLevel': stockLevel,
        'category': category,
        'lastSync': lastSync.toIso8601String(),
      };

  factory LocalProduct.fromJson(Map<String, dynamic> json) => LocalProduct(
        id: json['id'] as String,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        stockLevel: json['stockLevel'] as int,
        category: json['category'] as String,
        lastSync: DateTime.parse(json['lastSync'] as String),
      );
}

/// Pending sync operation queued when offline
class PendingSyncOperation {
  final String id;
  final String operation;
  final String collection;
  final String documentId;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  int retryCount;

  PendingSyncOperation({
    String? id,
    required this.operation,
    required this.collection,
    required this.documentId,
    required this.data,
    DateTime? createdAt,
    this.retryCount = 0,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'operation': operation,
        'collection': collection,
        'documentId': documentId,
        'data': data,
        'createdAt': createdAt.toIso8601String(),
        'retryCount': retryCount,
      };

  factory PendingSyncOperation.fromJson(Map<String, dynamic> json) => PendingSyncOperation(
        id: json['id'] as String,
        operation: json['operation'] as String,
        collection: json['collection'] as String,
        documentId: json['documentId'] as String,
        data: json['data'] as Map<String, dynamic>,
        createdAt: DateTime.parse(json['createdAt'] as String),
        retryCount: json['retryCount'] as int? ?? 0,
      );
}

class LocalDbService {
  static final LocalDbService _instance = LocalDbService._internal();
  factory LocalDbService() => _instance;
  LocalDbService._internal();

  bool _initialized = false;
  late Box<String> _salesBx;
  late Box<String> _productsBx;
  late Box<String> _pendingSyncBx;
  late Box<String> _settingsBx;

  Future<void> initialize() async {
    if (_initialized) return;
    await Hive.initFlutter();
    _salesBx = await Hive.openBox<String>('local_sales');
    _productsBx = await Hive.openBox<String>('local_products');
    _pendingSyncBx = await Hive.openBox<String>('pending_sync');
    _settingsBx = await Hive.openBox<String>('local_settings');
    _initialized = true;
  }

  bool get isInitialized => _initialized;
  int get pendingSyncCount => _pendingSyncBx.length;

  // === Sales (Local POS) ===
  Future<String> saveSale(LocalSale sale) async {
    _salesBx.put(sale.id, sale.toJson().toString());
    return sale.id;
  }

  LocalSale? getSale(String id) {
    final data = _salesBx.get(id);
    if (data == null) return null;
    return LocalSale.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  List<LocalSale> getUnsyncedSales() {
    return _salesBx.values
        .map((e) => LocalSale.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .where((s) => !s.synced)
        .toList();
  }

  List<LocalSale> getAllSales() {
    return _salesBx.values
        .map((e) => LocalSale.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  Future<void> markSaleSynced(String id, String firebaseOrderId) async {
    final sale = getSale(id);
    if (sale != null) {
      sale.synced = true;
      sale.firebaseOrderId = firebaseOrderId;
      _salesBx.put(id, sale.toJson().toString());
    }
  }

  // === Products Cache ===
  Future<void> cacheProduct(LocalProduct product) async {
    _productsBx.put(product.id, product.toJson().toString());
  }

  Future<void> cacheProducts(List<LocalProduct> products) async {
    for (final product in products) {
      _productsBx.put(product.id, product.toJson().toString());
    }
  }

  LocalProduct? getCachedProduct(String id) {
    final data = _productsBx.get(id);
    if (data == null) return null;
    return LocalProduct.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  List<LocalProduct> getCachedProducts() {
    return _productsBx.values
        .map((e) => LocalProduct.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  // === Pending Sync Queue ===
  Future<String> addPendingSync(PendingSyncOperation operation) async {
    _pendingSyncBx.put(operation.id, operation.toJson().toString());
    return operation.id;
  }

  List<PendingSyncOperation> getPendingSyncs() {
    return _pendingSyncBx.values
        .map((e) => PendingSyncOperation.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  Future<void> removePendingSync(String id) async {
    await _pendingSyncBx.delete(id);
  }

  Future<void> incrementRetry(String id) async {
    final data = _pendingSyncBx.get(id);
    if (data != null) {
      final op = PendingSyncOperation.fromJson(jsonDecode(data) as Map<String, dynamic>);
      op.retryCount++;
      _pendingSyncBx.put(id, op.toJson().toString());
    }
  }

  Future<void> clearAllPendingSyncs() async {
    await _pendingSyncBx.clear();
  }

  // === Settings ===
  Future<void> setSetting(String key, String value) async {
    await _settingsBx.put(key, value);
  }

  String? getSetting(String key) => _settingsBx.get(key);

  // === Cleanup ===
  Future<void> clearAll() async {
    await _salesBx.clear();
    await _productsBx.clear();
    await _pendingSyncBx.clear();
  }
}