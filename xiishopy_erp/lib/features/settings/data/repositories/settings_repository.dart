/// Xiishopy ERP - Settings Repository
library;

import 'dart:async';
import '../datasources/settings_remote_datasource.dart';
import '../models/settings_model.dart';

class SettingsRepository {
  final SettingsRemoteDataSource _remoteDataSource;
  SettingsRepository({required SettingsRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  Stream<SettingsModel?> watchSettings() => _remoteDataSource.watchSettings();
  Future<void> updateSettingsCategory(String category, Map<String, dynamic> data) => _remoteDataSource.updateSettingsCategory(category, data);
}