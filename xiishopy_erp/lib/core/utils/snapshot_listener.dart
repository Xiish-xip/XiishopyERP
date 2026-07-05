/// Xiishopy ERP - Real-time Firestore Snapshot Listener Wrapper
/// CRUCIAL: Uses .snapshots() instead of .get() to ensure real-time updates
/// from emulator changes (forex, payments, logistics) reflect instantly in UI.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

/// Real-time stream of a single document
Stream<DocumentSnapshot> listenToDocument(String collection, String docId) {
  return FirebaseFirestore.instance
      .collection(collection)
      .doc(docId)
      .snapshots();
}

/// Real-time stream of a collection with optional query filters
Stream<QuerySnapshot> listenToCollection(
  String collection, {
  String? whereField,
  dynamic whereValue,
  String? orderByField,
  bool descending = true,
  int? limit,
}) {
  Query query = FirebaseFirestore.instance.collection(collection);

  if (whereField != null && whereValue != null) {
    query = query.where(whereField, isEqualTo: whereValue);
  }

  if (orderByField != null) {
    query = query.orderBy(orderByField, descending: descending);
  }

  if (limit != null) {
    query = query.limit(limit);
  }

  return query.snapshots();
}

/// Stream for forex rates (single document listener)
Stream<Map<String, dynamic>?> streamForexRates() {
  return FirebaseFirestore.instance
      .collection('forex_rates')
      .doc('live')
      .snapshots()
      .map((doc) => doc.data());
}

/// Stream for user's orders
Stream<QuerySnapshot> streamUserOrders(String userId, {String? status}) {
  Query query = FirebaseFirestore.instance
      .collection('orders')
      .where('retailerId', isEqualTo: userId)
      .orderBy('createdAt', descending: true);

  if (status != null) {
    query = query.where('status', isEqualTo: status);
  }

  return query.snapshots();
}

/// Stream for distributor's orders
Stream<QuerySnapshot> streamDistributorOrders(String distributorId, {String? status}) {
  Query query = FirebaseFirestore.instance
      .collection('orders')
      .where('distributorId', isEqualTo: distributorId)
      .orderBy('createdAt', descending: true);

  if (status != null) {
    query = query.where('status', isEqualTo: status);
  }

  return query.snapshots();
}

/// Stream for all products (with stock alerts)
Stream<QuerySnapshot> streamProducts({bool lowStockOnly = false}) {
  Query query = FirebaseFirestore.instance.collection('products');

  if (lowStockOnly) {
    query = query.where('stockLevel', isLessThanOrEqualTo: 10);
  }

  return query.orderBy('name').snapshots();
}

/// Convert a DocumentSnapshot to a Map with ID included
Map<String, dynamic>? docToMap(DocumentSnapshot doc) {
  if (!doc.exists) return null;
  final data = doc.data() as Map<String, dynamic>?;
  if (data == null) return null;
  return {'id': doc.id, ...data};
}

/// Convert a QuerySnapshot to a List<Map> with IDs included
List<Map<String, dynamic>> queryToList(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    return {'id': doc.id, ...data};
  }).toList();
}