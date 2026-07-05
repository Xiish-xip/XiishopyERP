/// Xiishopy ERP - Suppliers Repository
library;

import 'dart:async';
import '../datasources/supplier_remote_datasource.dart';
import '../models/supplier_model.dart';

class SupplierRepository {
  final SupplierRemoteDataSource _remoteDataSource;
  SupplierRepository({required SupplierRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Stream<List<SupplierModel>> watchSuppliers() => _remoteDataSource.watchSuppliers();
  Future<void> createSupplier(SupplierModel supplier) => _remoteDataSource.createSupplier(supplier);
  Future<void> updateSupplier(SupplierModel supplier) => _remoteDataSource.updateSupplier(supplier);
  Future<void> deleteSupplier(String id) => _remoteDataSource.deleteSupplier(id);
}