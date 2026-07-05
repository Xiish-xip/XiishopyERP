/// Xiishopy ERP - DMS Repository
library;

import '../datasources/dms_remote_datasource.dart';
import '../models/document_model.dart';

class DmsRepository {
  final DmsRemoteDataSource _remoteDataSource;
  DmsRepository({required DmsRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  Stream<List<DocumentModel>> watchDocuments() => _remoteDataSource.watchDocuments();
  Future<void> createDocument(DocumentModel document) => _remoteDataSource.createDocument(document);
  Future<void> updateDocument(DocumentModel document) => _remoteDataSource.updateDocument(document);
  Future<void> archiveDocument(String id) => _remoteDataSource.archiveDocument(id);
  Future<void> deleteDocument(String id) => _remoteDataSource.deleteDocument(id);

  Stream<List<DocumentTemplateModel>> watchTemplates() => _remoteDataSource.watchTemplates();
  Future<void> createTemplate(DocumentTemplateModel template) => _remoteDataSource.createTemplate(template);
  Future<void> updateTemplate(DocumentTemplateModel template) => _remoteDataSource.updateTemplate(template);
}