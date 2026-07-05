/// Xiishopy ERP - Payment Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model.dart';

class PaymentRemoteDataSource {
  final FirebaseFirestore _firestore;

  PaymentRemoteDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Stream<List<PaymentModel>> watchPayments({String? userId}) {
    Query query = _firestore.collection('payments').orderBy('createdAt', descending: true);
    if (userId != null) {
      query = query.where('retailerId', isEqualTo: userId);
    }
    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => PaymentModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  Future<PaymentModel> getPayment(String id) async {
    final doc = await _firestore.collection('payments').doc(id).get();
    if (!doc.exists) throw Exception('Payment not found');
    return PaymentModel.fromFirestore(doc.data()!, doc.id);
  }
}