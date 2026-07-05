/// Xiishopy ERP - Firebase ↔ Local Sync Orchestration Service
/// Handles offline-first data synchronization with conflict resolution.
library;

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utils/local_db_service.dart';

class SyncService {
  final LocalDbService _localDb;
  final FirebaseFirestore _firestore;
  final Connectivity _connectivity;
  StreamSubscription? _connectivitySubscription;
  bool _isSyncing = false;
  bool _isOnline = true;
  static const int _maxRetries = 5;

  SyncService({
    required LocalDbService localDb,
    required FirebaseFirestore firestore,
    Connectivity? connectivity,
  })  : _localDb = localDb,
        _firestore = firestore,
        _connectivity = connectivity ?? Connectivity();

  Future<void> initialize() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _isOnline = !result.contains(ConnectivityResult.none);

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      final wasOnline = _isOnline;
      _isOnline = !result.contains(ConnectivityResult.none);

      // Auto-sync when coming back online
      if (!wasOnline && _isOnline) {
        syncPendingOperations();
      }
    });

    // Initial sync if online
    if (_isOnline) {
      await syncPendingOperations();
    }
  }

  bool get isOnline => _isOnline;
  bool get isSyncing => _isSyncing;
  int get pendingCount => _localDb.pendingSyncCount;

  /// Queue a local change for sync when online
  Future<void> queueForSync(PendingSyncOperation operation) async {
    await _localDb.addPendingSync(operation);
    if (_isOnline) {
      await syncPendingOperations();
    }
  }

  /// Sync all pending operations to Firebase
  Future<SyncResult> syncPendingOperations() async {
    if (_isSyncing || !_isOnline) {
      return SyncResult(synced: 0, failed: 0, errors: []);
    }

    _isSyncing = true;
    int synced = 0;
    int failed = 0;
    final List<String> errors = [];

    try {
      final pendingOps = _localDb.getPendingSyncs();
      pendingOps.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      for (final op in pendingOps) {
        if (op.retryCount >= _maxRetries) {
          await _localDb.removePendingSync(op.id);
          errors.add('Max retries exceeded for ${op.collection}/${op.documentId}');
          failed++;
          continue;
        }

        try {
          await _executeSyncOperation(op);
          await _localDb.removePendingSync(op.id);
          synced++;
        } catch (e) {
          await _localDb.incrementRetry(op.id);
          errors.add('Failed ${op.collection}/${op.documentId}: $e');
          failed++;
        }
      }

      // Sync unsynced local sales
      final unsyncedSales = _localDb.getUnsyncedSales();
      for (final sale in unsyncedSales) {
        try {
          final docRef = await _firestore.collection('orders').add({
            'items': sale.items.map((i) => i.toJson()).toList(),
            'totalAmount': sale.totalAmount,
            'paymentMethod': sale.paymentMethod,
            'createdAt': sale.createdAt.toIso8601String(),
            'status': 'pending',
            'syncedFromLocal': true,
            'syncedAt': FieldValue.serverTimestamp(),
          });
          await _localDb.markSaleSynced(sale.id, docRef.id);
          synced++;
        } catch (e) {
          errors.add('Failed to sync sale ${sale.id}: $e');
          failed++;
        }
      }
    } finally {
      _isSyncing = false;
    }

    return SyncResult(synced: synced, failed: failed, errors: errors);
  }

  Future<void> _executeSyncOperation(PendingSyncOperation op) async {
    final collection = _firestore.collection(op.collection);

    switch (op.operation) {
      case 'create':
        final docRef = collection.doc(op.documentId);
        await docRef.set({
          ...op.data,
          'syncedAt': FieldValue.serverTimestamp(),
        });
        break;
      case 'update':
        await collection.doc(op.documentId).update({
          ...op.data,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        break;
      case 'delete':
        await collection.doc(op.documentId).delete();
        break;
      default:
        throw Exception('Unknown sync operation: ${op.operation}');
    }
  }

  /// Sync products from Firebase to local cache
  Future<int> syncProductsToLocal() async {
    if (!_isOnline) return 0;

    try {
      final snapshot = await _firestore
          .collection('products')
          .orderBy('name')
          .get();

      final products = snapshot.docs.map((doc) {
        final data = doc.data();
        return LocalProduct(
          id: doc.id,
          name: data['name'] as String? ?? '',
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          stockLevel: data['stockLevel'] as int? ?? 0,
          category: data['category'] as String? ?? '',
          lastSync: DateTime.now(),
        );
      }).toList();

      await _localDb.cacheProducts(products);
      return products.length;
    } catch (e) {
      return 0;
    }
  }

  /// Dispose subscription
  void dispose() {
    _connectivitySubscription?.cancel();
  }
}

class SyncResult {
  final int synced;
  final int failed;
  final List<String> errors;

  SyncResult({required this.synced, required this.failed, required this.errors});

  bool get hasErrors => errors.isNotEmpty;
  int get total => synced + failed;
}