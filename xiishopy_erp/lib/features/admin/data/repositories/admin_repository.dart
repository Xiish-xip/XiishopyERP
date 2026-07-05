/// Xiishopy ERP - Admin Repository
library;

import 'dart:async';
import '../datasources/admin_remote_datasource.dart';
import '../models/admin_config_model.dart';

class AdminRepository {
  final AdminRemoteDataSource _remoteDataSource;

  AdminRepository({required AdminRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Stream<AdminConfigModel?> watchConfig() => _remoteDataSource.watchConfig();

  Future<void> updateModuleConfig(String module, Map<String, dynamic> config) =>
      _remoteDataSource.updateModuleConfig(module, config);

  Future<void> updateBusinessRules(Map<String, dynamic> rules) =>
      _remoteDataSource.updateBusinessRules(rules);

  Future<List<Map<String, dynamic>>> getAllUsers() => _remoteDataSource.getAllUsers();

  Future<void> updateUserRole(String userId, String role) =>
      _remoteDataSource.updateUserRole(userId, role);

  Future<void> toggleUserBan(String userId, bool banned) =>
      _remoteDataSource.toggleUserBan(userId, banned);

  Future<void> deleteUser(String userId) => _remoteDataSource.deleteUser(userId);

  Stream<List<Map<String, dynamic>>> watchAuditLogs({int limit = 100}) =>
      _remoteDataSource.watchAuditLogs(limit: limit);
}