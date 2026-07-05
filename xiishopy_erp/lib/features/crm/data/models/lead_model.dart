/// Xiishopy ERP - Lead Model (CRM)
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class LeadModel extends Equatable {
  final String id;
  final String companyName;
  final String contactName;
  final String email;
  final String phone;
  final String source; // Website, Referral, Cold Call, Social Media, Other
  final String status; // New, Contacted, Qualified, Lost, Converted
  final String priority; // Low, Medium, High, Critical
  final String? assignedTo;
  final String? industry;
  final String? notes;
  final double estimatedValue;
  final DateTime? followUpDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LeadModel({
    required this.id,
    required this.companyName,
    required this.contactName,
    required this.email,
    required this.phone,
    this.source = 'Website',
    this.status = 'New',
    this.priority = 'Medium',
    this.assignedTo,
    this.industry,
    this.notes,
    this.estimatedValue = 0.0,
    this.followUpDate,
    required this.createdAt,
    required this.updatedAt,
  });

  String get displayName => '$contactName ($companyName)';

  factory LeadModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return LeadModel(
      id: docId,
      companyName: data['companyName'] as String? ?? '',
      contactName: data['contactName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      source: data['source'] as String? ?? 'Website',
      status: data['status'] as String? ?? 'New',
      priority: data['priority'] as String? ?? 'Medium',
      assignedTo: data['assignedTo'] as String?,
      industry: data['industry'] as String?,
      notes: data['notes'] as String?,
      estimatedValue: (data['estimatedValue'] as num?)?.toDouble() ?? 0.0,
      followUpDate: safeToDate(data['followUpDate']),
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'companyName': companyName,
    'contactName': contactName,
    'email': email,
    'phone': phone,
    'source': source,
    'status': status,
    'priority': priority,
    'assignedTo': assignedTo,
    'industry': industry,
    'notes': notes,
    'estimatedValue': estimatedValue,
    'followUpDate': followUpDate?.toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
  };

  LeadModel copyWith({
    String? companyName,
    String? contactName,
    String? email,
    String? phone,
    String? source,
    String? status,
    String? priority,
    String? assignedTo,
    String? industry,
    String? notes,
    double? estimatedValue,
    DateTime? followUpDate,
  }) {
    return LeadModel(
      id: id,
      companyName: companyName ?? this.companyName,
      contactName: contactName ?? this.contactName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      source: source ?? this.source,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assignedTo: assignedTo ?? this.assignedTo,
      industry: industry ?? this.industry,
      notes: notes ?? this.notes,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      followUpDate: followUpDate ?? this.followUpDate,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, email, contactName, status, priority];
}