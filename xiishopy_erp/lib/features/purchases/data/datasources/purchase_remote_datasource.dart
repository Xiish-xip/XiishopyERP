/// Xiishopy ERP - Purchases Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/purchase_model.dart';

class PurchaseRemoteDataSource {
  final FirebaseFirestore _firestore;
  PurchaseRemoteDataSource({required FirebaseFirestore firestore}) : _firestore = firestore;

  Stream<List<PurchaseModel>> watchPurchases() {
    return _firestore.collection('purchases').orderBy('createdAt', descending: true).snapshots()
        .map((s) => s.docs.map((d) => PurchaseModel.fromFirestore(d.data() as Map<String, dynamic>, d.id)).toList());
  }

  Future<void> createPurchase(PurchaseModel purchase) async {
    final doc = _firestore.collection('purchases').doc();
    await doc.set(purchase.toFirestore());
  }

  Future<void> updatePurchase(PurchaseModel purchase) async {
    await _firestore.collection('purchases').doc(purchase.id).update(purchase.toFirestore());
  }

  Future<void> approvePurchase(String id, String approvedBy) async {
    await _firestore.collection('purchases').doc(id).update({
      'status': 'Approved', 'approvedBy': approvedBy, 'approvedAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> receivePurchase(String id) async {
    await _firestore.collection('purchases').doc(id).update({
      'status': 'Received', 'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletePurchase(String id) async {
    await _firestore.collection('purchases').doc(id).update({'status': 'Cancelled', 'updatedAt': FieldValue.serverTimestamp()});
  }
}