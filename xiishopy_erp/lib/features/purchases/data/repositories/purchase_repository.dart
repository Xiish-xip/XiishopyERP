/// Xiishopy ERP - Purchases Repository
library;

import 'dart:async';
import '../datasources/purchase_remote_datasource.dart';
import '../models/purchase_model.dart';

class PurchaseRepository {
  final PurchaseRemoteDataSource _remoteDataSource;
  PurchaseRepository({required PurchaseRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  Stream<List<PurchaseModel>> watchPurchases() => _remoteDataSource.watchPurchases();
  Future<void> createPurchase(PurchaseModel purchase) => _remoteDataSource.createPurchase(purchase);
  Future<void> updatePurchase(PurchaseModel purchase) => _remoteDataSource.updatePurchase(purchase);
  Future<void> approvePurchase(String id, String approvedBy) => _remoteDataSource.approvePurchase(id, approvedBy);
  Future<void> receivePurchase(String id) => _remoteDataSource.receivePurchase(id);
  Future<void> deletePurchase(String id) => _remoteDataSource.deletePurchase(id);
}