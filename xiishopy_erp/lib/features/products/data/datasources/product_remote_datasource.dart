/// Xiishopy ERP - Product Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductRemoteDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Stream<List<ProductModel>> watchProducts() {
    return _firestore
        .collection('products')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<ProductModel> getProduct(String id) async {
    final doc = await _firestore.collection('products').doc(id).get();
    if (!doc.exists) throw Exception('Product not found');
    return ProductModel.fromFirestore(doc.data()!, doc.id);
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _firestore.collection('products').doc(id).update(data);
  }
}