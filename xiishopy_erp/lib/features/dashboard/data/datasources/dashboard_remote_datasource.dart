/// Xiishopy ERP - Dashboard Remote Data Source
/// Aggregates data from orders, products, and payments collections.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../products/data/models/product_model.dart';
import '../../../payments/data/models/payment_model.dart';

class DashboardRemoteDataSource {
  final FirebaseFirestore _firestore;

  DashboardRemoteDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Stream<List<OrderModel>> watchRecentOrders({int limit = 10}) {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Stream<List<ProductModel>> watchProducts() {
    return _firestore
        .collection('products')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Stream<List<PaymentModel>> watchPayments() {
    return _firestore
        .collection('payments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PaymentModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<int> getTotalOrders() async {
    final snap = await _firestore.collection('orders').count().get();
    return snap.count ?? 0;
  }

  Future<int> getTotalCustomers() async {
    final snap = await _firestore.collection('users').count().get();
    return snap.count ?? 0;
  }
}