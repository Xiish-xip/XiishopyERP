/// Xiishopy ERP - Tax Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tax_model.dart';

class TaxRemoteDataSource {
  final FirebaseFirestore _firestore;

  TaxRemoteDataSource({required FirebaseFirestore firestore}) : _firestore = firestore;

  Stream<List<TaxConfigModel>> watchTaxConfigs() {
    return _firestore
        .collection('tax_config')
        .orderBy('region')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaxConfigModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createTaxConfig(TaxConfigModel config) async {
    final doc = _firestore.collection('tax_config').doc();
    await doc.set(config.toFirestore());
  }

  Future<void> updateTaxConfig(TaxConfigModel config) async {
    await _firestore.collection('tax_config').doc(config.id).update(config.toFirestore());
  }

  Stream<List<TaxRateModel>> watchTaxRates() {
    return _firestore
        .collection('tax_rates')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaxRateModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createTaxRate(TaxRateModel rate) async {
    final doc = _firestore.collection('tax_rates').doc();
    await doc.set(rate.toFirestore());
  }

  Future<void> updateTaxRate(TaxRateModel rate) async {
    await _firestore.collection('tax_rates').doc(rate.id).update(rate.toFirestore());
  }
}