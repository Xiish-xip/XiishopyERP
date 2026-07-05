/// Xiishopy ERP - Settings Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/settings_model.dart';

class SettingsRemoteDataSource {
  final FirebaseFirestore _firestore;
  SettingsRemoteDataSource({required FirebaseFirestore firestore}) : _firestore = firestore;

  Stream<SettingsModel?> watchSettings() {
    return _firestore.collection('system_config').doc('app_settings').snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return SettingsModel.fromFirestore(doc.data() as Map<String, dynamic>);
    });
  }

  Future<void> updateSettingsCategory(String category, Map<String, dynamic> data) async {
    await _firestore.collection('system_config').doc('app_settings').update({
      category: data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}