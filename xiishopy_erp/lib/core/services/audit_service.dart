/// Xiishopy ERP - Audit Trail Service
/// Records all changes to tracked entities with before/after values.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuditService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const String _collection = 'audit_logs';
  bool _enabled = true;

  AuditService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  void setEnabled(bool enabled) => _enabled = enabled;

  /// Log a create action
  Future<void> logCreate({
    required String entityType,
    required String entityId,
    required Map<String, dynamic> newValues,
    String? description,
  }) async {
    if (!_enabled) return;
    await _log('create', entityType, entityId, null, newValues, description);
  }

  /// Log an update action with before/after snapshot
  Future<void> logUpdate({
    required String entityType,
    required String entityId,
    required Map<String, dynamic>? beforeValues,
    required Map<String, dynamic> afterValues,
    String? description,
  }) async {
    if (!_enabled) return;
    await _log('update', entityType, entityId, beforeValues, afterValues, description);
  }

  /// Log a delete action
  Future<void> logDelete({
    required String entityType,
    required String entityId,
    required Map<String, dynamic>? deletedValues,
    String? description,
  }) async {
    if (!_enabled) return;
    await _log('delete', entityType, entityId, deletedValues, null, description);
  }

  /// Log a custom action
  Future<void> logAction({
    required String action,
    required String entityType,
    required String entityId,
    Map<String, dynamic>? details,
    String? description,
  }) async {
    if (!_enabled) return;
    final user = _auth.currentUser;
    await _firestore.collection(_collection).add({
      'entityType': entityType,
      'entityId': entityId,
      'action': action,
      'userId': user?.uid ?? 'system',
      'userName': user?.displayName ?? 'System',
      'userEmail': user?.email ?? 'system@xiishopy.com',
      'details': details,
      'description': description ?? '$action $entityType $entityId',
      'timestamp': FieldValue.serverTimestamp(),
      'ipAddress': null, // Populated from client if available
    });
  }

  Future<void> _log(
    String action,
    String entityType,
    String entityId,
    Map<String, dynamic>? before,
    Map<String, dynamic>? after,
    String? description,
  ) async {
    final user = _auth.currentUser;
    try {
      await _firestore.collection(_collection).add({
        'entityType': entityType,
        'entityId': entityId,
        'action': action,
        'userId': user?.uid ?? 'system',
        'userName': user?.displayName ?? 'System',
        'userEmail': user?.email ?? 'system@xiishopy.com',
        'before': before,
        'after': after,
        'description': description ?? '$action $entityType $entityId',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Fail silently - audit logs should not break main flow
      print('[Audit] Failed to log $action for $entityType/$entityId: $e');
    }
  }

  /// Query audit logs with filters
  Stream<List<AuditLogEntry>> watchLogs({
    String? entityType,
    String? entityId,
    String? userId,
    int limit = 100,
  }) {
    Query query = _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (entityType != null) {
      query = query.where('entityType', isEqualTo: entityType);
    }
    if (entityId != null) {
      query = query.where('entityId', isEqualTo: entityId);
    }
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => AuditLogEntry.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  /// Get audit logs as a future (paginated)
  Future<List<AuditLogEntry>> getLogs({
    String? entityType,
    String? entityId,
    int limit = 100,
    DocumentSnapshot? startAfter,
  }) async {
    Query query = _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (entityType != null) {
      query = query.where('entityType', isEqualTo: entityType);
    }
    if (entityId != null) {
      query = query.where('entityId', isEqualTo: entityId);
    }
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => AuditLogEntry.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}

class AuditLogEntry {
  final String id;
  final String entityType;
  final String entityId;
  final String action;
  final String userId;
  final String userName;
  final String userEmail;
  final Map<String, dynamic>? before;
  final Map<String, dynamic>? after;
  final String? description;
  final DateTime? timestamp;

  AuditLogEntry({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.before,
    this.after,
    this.description,
    this.timestamp,
  });

  factory AuditLogEntry.fromFirestore(Map<String, dynamic> data, String id) {
    return AuditLogEntry(
      id: id,
      entityType: data['entityType'] as String? ?? '',
      entityId: data['entityId'] as String? ?? '',
      action: data['action'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      userName: data['userName'] as String? ?? '',
      userEmail: data['userEmail'] as String? ?? '',
      before: data['before'] as Map<String, dynamic>?,
      after: data['after'] as Map<String, dynamic>?,
      description: data['description'] as String?,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  String get actionLabel {
    switch (action) {
      case 'create':
        return 'Created';
      case 'update':
        return 'Updated';
      case 'delete':
        return 'Deleted';
      default:
        return action;
    }
  }
}