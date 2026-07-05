/// Xiishopy ERP - Logistics Shipment Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shipment_model.dart';

class LogisticsRemoteDataSource {
  final FirebaseFirestore _firestore;

  LogisticsRemoteDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Stream<List<ShipmentModel>> watchShipments({String? userId}) {
    Query query = _firestore.collection('shipments').orderBy('createdAt', descending: true);
    if (userId != null) {
      query = query.where('retailerId', isEqualTo: userId);
    }
    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ShipmentModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  Future<ShipmentModel> getShipment(String id) async {
    final doc = await _firestore.collection('shipments').doc(id).get();
    if (!doc.exists) throw Exception('Shipment not found');
    return ShipmentModel.fromFirestore(doc.data()!, doc.id);
  }
}