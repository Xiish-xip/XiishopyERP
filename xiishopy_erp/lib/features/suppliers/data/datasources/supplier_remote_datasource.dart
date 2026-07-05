/// Xiishopy ERP - Suppliers Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/supplier_model.dart';

class SupplierRemoteDataSource {
  final FirebaseFirestore _firestore;

  SupplierRemoteDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Stream<List<SupplierModel>> watchSuppliers() {
    return _firestore
        .collection('suppliers')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SupplierModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createSupplier(SupplierModel supplier) async {
    final doc = _firestore.collection('suppliers').doc();
    await doc.set(supplier.toFirestore());
  }

  Future<void> updateSupplier(SupplierModel supplier) async {
    await _firestore.collection('suppliers').doc(supplier.id).update(supplier.toFirestore());
  }

  Future<void> deleteSupplier(String id) async {
    await _firestore.collection('suppliers').doc(id).update({
      'status': 'Inactive',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}