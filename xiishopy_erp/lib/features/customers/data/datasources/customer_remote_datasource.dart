/// Xiishopy ERP - Customer Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer_model.dart';

class CustomerRemoteDataSource {
  final FirebaseFirestore _firestore;

  CustomerRemoteDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Stream<List<CustomerModel>> watchCustomers({String? role}) {
    Query query = _firestore.collection('users').orderBy('displayName');
    if (role != null) {
      query = query.where('role', isEqualTo: role);
    }
    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => CustomerModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }
}