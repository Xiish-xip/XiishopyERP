/// Xiishopy ERP - Order Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderRemoteDataSource {
  final FirebaseFirestore _firestore;

  OrderRemoteDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Stream<List<OrderModel>> watchOrders({String? userId}) {
    Query query = _firestore.collection('orders').orderBy('createdAt', descending: true);
    if (userId != null) {
      query = query.where('retailerId', isEqualTo: userId);
    }
    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => OrderModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  Future<OrderModel> getOrder(String id) async {
    final doc = await _firestore.collection('orders').doc(id).get();
    if (!doc.exists) throw Exception('Order not found');
    return OrderModel.fromFirestore(doc.data()!, doc.id);
  }
}