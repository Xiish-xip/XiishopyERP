/// Xiishopy ERP - Assets Repository
library;

import 'dart:async';
import '../datasources/asset_remote_datasource.dart';
import '../models/asset_model.dart';

class AssetRepository {
  final AssetRemoteDataSource _remoteDataSource;
  AssetRepository({required AssetRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  Stream<List<AssetModel>> watchAssets() => _remoteDataSource.watchAssets();
  Future<void> createAsset(AssetModel asset) => _remoteDataSource.createAsset(asset);
  Future<void> updateAsset(AssetModel asset) => _remoteDataSource.updateAsset(asset);
  Future<void> deleteAsset(String id) => _remoteDataSource.deleteAsset(id);
}