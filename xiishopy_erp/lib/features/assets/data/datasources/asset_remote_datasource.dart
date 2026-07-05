/// Xiishopy ERP - Assets Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/asset_model.dart';

class AssetRemoteDataSource {
  final FirebaseFirestore _firestore;
  AssetRemoteDataSource({required FirebaseFirestore firestore}) : _firestore = firestore;

  Stream<List<AssetModel>> watchAssets() {
    return _firestore.collection('assets').orderBy('createdAt', descending: true).snapshots()
        .map((s) => s.docs.map((d) => AssetModel.fromFirestore(d.data() as Map<String, dynamic>, d.id)).toList());
  }

  Future<void> createAsset(AssetModel asset) async {
    final doc = _firestore.collection('assets').doc();
    await doc.set(asset.toFirestore());
  }

  Future<void> updateAsset(AssetModel asset) async {
    await _firestore.collection('assets').doc(asset.id).update(asset.toFirestore());
  }

  Future<void> deleteAsset(String id) async {
    await _firestore.collection('assets').doc(id).update({'status': 'Disposed', 'updatedAt': FieldValue.serverTimestamp()});
  }
}