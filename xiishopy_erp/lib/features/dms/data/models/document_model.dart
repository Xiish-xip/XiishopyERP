/// Xiishopy ERP - Document Management System Models
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class DocumentModel extends Equatable {
  final String id;
  final String title;
  final String fileName;
  final String fileType; // pdf, docx, xlsx, image, other
  final String fileUrl;
  final int fileSize; // bytes
  final String category; // Invoice, Contract, Report, Certificate, Other
  final String? description;
  final String uploadedBy;
  final List<String> tags;
  final String status; // Active, Archived, Deleted
  final String? version;
  final String? documentNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DocumentModel({
    required this.id,
    required this.title,
    required this.fileName,
    this.fileType = 'other',
    required this.fileUrl,
    this.fileSize = 0,
    this.category = 'Other',
    this.description,
    required this.uploadedBy,
    this.tags = const [],
    this.status = 'Active',
    this.version,
    this.documentNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocumentModel.fromFirestore(Map<String, dynamic> data, String docId) {
    final tagsData = data['tags'] as List<dynamic>? ?? [];
    return DocumentModel(
      id: docId,
      title: data['title'] as String? ?? '',
      fileName: data['fileName'] as String? ?? '',
      fileType: data['fileType'] as String? ?? 'other',
      fileUrl: data['fileUrl'] as String? ?? '',
      fileSize: (data['fileSize'] as num?)?.toInt() ?? 0,
      category: data['category'] as String? ?? 'Other',
      description: data['description'] as String?,
      uploadedBy: data['uploadedBy'] as String? ?? '',
      tags: tagsData.cast<String>(),
      status: data['status'] as String? ?? 'Active',
      version: data['version'] as String?,
      documentNumber: data['documentNumber'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'title': title,
    'fileName': fileName,
    'fileType': fileType,
    'fileUrl': fileUrl,
    'fileSize': fileSize,
    'category': category,
    'description': description,
    'uploadedBy': uploadedBy,
    'tags': tags,
    'status': status,
    'version': version,
    'documentNumber': documentNumber,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, title, fileName, category, status];
}

class DocumentTemplateModel extends Equatable {
  final String id;
  final String name;
  final String category;
  final String? description;
  final String fileUrl;
  final String fileType;
  final Map<String, dynamic> fields; // Template field definitions
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DocumentTemplateModel({
    required this.id,
    required this.name,
    this.category = 'Other',
    this.description,
    required this.fileUrl,
    this.fileType = 'pdf',
    this.fields = const {},
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocumentTemplateModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return DocumentTemplateModel(
      id: docId,
      name: data['name'] as String? ?? '',
      category: data['category'] as String? ?? 'Other',
      description: data['description'] as String?,
      fileUrl: data['fileUrl'] as String? ?? '',
      fileType: data['fileType'] as String? ?? 'pdf',
      fields: data['fields'] as Map<String, dynamic>? ?? {},
      isActive: data['isActive'] as bool? ?? true,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'category': category,
    'description': description,
    'fileUrl': fileUrl,
    'fileType': fileType,
    'fields': fields,
    'isActive': isActive,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, name, category, isActive];
}