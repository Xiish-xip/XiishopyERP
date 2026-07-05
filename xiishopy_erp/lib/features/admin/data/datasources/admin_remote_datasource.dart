/// Xiishopy ERP - Admin Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin_config_model.dart';

class AdminRemoteDataSource {
  final FirebaseFirestore _firestore;

  AdminRemoteDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Stream<AdminConfigModel?> watchConfig() {
    return _firestore
        .collection('system_config')
        .doc('app_settings')
        .snapshots()
        .map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return AdminConfigModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    });
  }

  Future<void> updateModuleConfig(String module, Map<String, dynamic> config) async {
    await _firestore.collection('system_config').doc('app_settings').update({
      'modules.$module': config,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateBusinessRules(Map<String, dynamic> rules) async {
    await _firestore.collection('system_config').doc('app_settings').update({
      'businessRules': rules,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final snapshot = await _firestore.collection('users').orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  Future<void> updateUserRole(String userId, String role) async {
    await _firestore.collection('users').doc(userId).update({'role': role});
  }

  Future<void> toggleUserBan(String userId, bool banned) async {
    await _firestore.collection('users').doc(userId).update({
      'banned': banned,
      'bannedAt': banned ? FieldValue.serverTimestamp() : null,
    });
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'deleted': true,
      'deletedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> watchAuditLogs({int limit = 100}) {
    return _firestore
        .collection('audit_logs')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList());
  }
}