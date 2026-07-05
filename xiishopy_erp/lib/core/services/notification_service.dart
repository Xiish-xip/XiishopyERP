/// Xiishopy ERP - Notification Service
/// Manages in-app notifications and push notification subscriptions.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;
  String? _fcmToken;
  bool _initialized = false;

  NotificationService({
    required FirebaseMessaging messaging,
    required FirebaseFirestore firestore,
  })  : _messaging = messaging,
        _firestore = firestore;

  Future<void> initialize() async {
    if (_initialized) return;

    // Request permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Get FCM token
      _fcmToken = await _messaging.getToken();
      _setupMessageHandlers();
      _initialized = true;
    }
  }

  String? get fcmToken => _fcmToken;

  /// Register device token for a user
  Future<void> registerDeviceToken(String userId) async {
    if (_fcmToken == null) return;

    await _firestore.collection('user_devices').doc(userId).set({
      'fcmToken': _fcmToken,
      'platform': defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Unregister device token
  Future<void> unregisterDeviceToken(String userId) async {
    await _firestore.collection('user_devices').doc(userId).delete();
  }

  /// Get in-app notifications stream for a user
  Stream<List<AppNotification>> watchNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppNotification.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'read': true,
      'readAt': FieldValue.serverTimestamp(),
    });
  }

  /// Mark all notifications as read for a user
  Future<void> markAllAsRead(String userId) async {
    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'read': true, 'readAt': FieldValue.serverTimestamp()});
    }
    await batch.commit();
  }

  /// Get unread count for a user
  Stream<int> watchUnreadCount(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('[Notification] Foreground message: ${message.notification?.title}');
    });

    // Handle when app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('[Notification] App opened from notification: ${message.notification?.title}');
    });

    // Handle token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
    });
  }
}

class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type;
  final String? entityType;
  final String? entityId;
  final bool read;
  final DateTime? createdAt;
  final DateTime? readAt;
  final Map<String, dynamic>? data;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.entityType,
    this.entityId,
    this.read = false,
    this.createdAt,
    this.readAt,
    this.data,
  });

  factory AppNotification.fromFirestore(Map<String, dynamic> json, String id) {
    return AppNotification(
      id: id,
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: json['type'] as String? ?? 'info',
      entityType: json['entityType'] as String?,
      entityId: json['entityId'] as String?,
      read: json['read'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      readAt: (json['readAt'] as Timestamp?)?.toDate(),
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}