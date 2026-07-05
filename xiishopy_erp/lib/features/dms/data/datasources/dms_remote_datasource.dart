/// Xiishopy ERP - DMS Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/document_model.dart';

class DmsRemoteDataSource {
  final FirebaseFirestore _firestore;

  DmsRemoteDataSource({required FirebaseFirestore firestore}) : _firestore = firestore;

  // ── Documents ──
  Stream<List<DocumentModel>> watchDocuments() {
    return _firestore
        .collection('documents')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DocumentModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createDocument(DocumentModel document) async {
    final doc = _firestore.collection('documents').doc();
    await doc.set(document.toFirestore());
  }

  Future<void> updateDocument(DocumentModel document) async {
    await _firestore.collection('documents').doc(document.id).update(document.toFirestore());
  }

  Future<void> archiveDocument(String id) async {
    await _firestore.collection('documents').doc(id).update({'status': 'Archived', 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> deleteDocument(String id) async {
    await _firestore.collection('documents').doc(id).update({'status': 'Deleted', 'updatedAt': FieldValue.serverTimestamp()});
  }

  // ── Templates ──
  Stream<List<DocumentTemplateModel>> watchTemplates() {
    return _firestore
        .collection('document_templates')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DocumentTemplateModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createTemplate(DocumentTemplateModel template) async {
    final doc = _firestore.collection('document_templates').doc();
    await doc.set(template.toFirestore());
  }

  Future<void> updateTemplate(DocumentTemplateModel template) async {
    await _firestore.collection('document_templates').doc(template.id).update(template.toFirestore());
  }
}