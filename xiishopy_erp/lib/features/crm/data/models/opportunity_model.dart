/// Xiishopy ERP - Opportunity Model (CRM)
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class OpportunityModel extends Equatable {
  final String id;
  final String title;
  final String leadId;
  final String leadName;
  final String stage; // Prospecting, Negotiation, Proposal, Closed Won, Closed Lost
  final double amount;
  final double probability; // 0-100
  final String? assignedTo;
  final DateTime? expectedCloseDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OpportunityModel({
    required this.id,
    required this.title,
    required this.leadId,
    required this.leadName,
    this.stage = 'Prospecting',
    this.amount = 0.0,
    this.probability = 10,
    this.assignedTo,
    this.expectedCloseDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OpportunityModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return OpportunityModel(
      id: docId,
      title: data['title'] as String? ?? '',
      leadId: data['leadId'] as String? ?? '',
      leadName: data['leadName'] as String? ?? '',
      stage: data['stage'] as String? ?? 'Prospecting',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      probability: (data['probability'] as num?)?.toDouble() ?? 10,
      assignedTo: data['assignedTo'] as String?,
      expectedCloseDate: safeToDate(data['expectedCloseDate']),
      notes: data['notes'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'title': title,
    'leadId': leadId,
    'leadName': leadName,
    'stage': stage,
    'amount': amount,
    'probability': probability,
    'assignedTo': assignedTo,
    'expectedCloseDate': expectedCloseDate?.toIso8601String(),
    'notes': notes,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  OpportunityModel copyWith({
    String? title,
    String? leadId,
    String? leadName,
    String? stage,
    double? amount,
    double? probability,
    String? assignedTo,
    DateTime? expectedCloseDate,
    String? notes,
  }) {
    return OpportunityModel(
      id: id,
      title: title ?? this.title,
      leadId: leadId ?? this.leadId,
      leadName: leadName ?? this.leadName,
      stage: stage ?? this.stage,
      amount: amount ?? this.amount,
      probability: probability ?? this.probability,
      assignedTo: assignedTo ?? this.assignedTo,
      expectedCloseDate: expectedCloseDate ?? this.expectedCloseDate,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, title, stage, amount];
}

class CampaignModel extends Equatable {
  final String id;
  final String name;
  final String type; // Email, Social, Event, Referral, Other
  final String status; // Planning, Active, Paused, Completed
  final double budget;
  final double spent;
  final DateTime startDate;
  final DateTime? endDate;
  final String? description;
  final int leadsGenerated;
  final int conversions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CampaignModel({
    required this.id,
    required this.name,
    this.type = 'Email',
    this.status = 'Planning',
    this.budget = 0.0,
    this.spent = 0.0,
    required this.startDate,
    this.endDate,
    this.description,
    this.leadsGenerated = 0,
    this.conversions = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CampaignModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return CampaignModel(
      id: docId,
      name: data['name'] as String? ?? '',
      type: data['type'] as String? ?? 'Email',
      status: data['status'] as String? ?? 'Planning',
      budget: (data['budget'] as num?)?.toDouble() ?? 0.0,
      spent: (data['spent'] as num?)?.toDouble() ?? 0.0,
      startDate: safeToDate(data['startDate']),
      endDate: safeToDate(data['endDate']),
      description: data['description'] as String?,
      leadsGenerated: (data['leadsGenerated'] as num?)?.toInt() ?? 0,
      conversions: (data['conversions'] as num?)?.toInt() ?? 0,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'type': type,
    'status': status,
    'budget': budget,
    'spent': spent,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'description': description,
    'leadsGenerated': leadsGenerated,
    'conversions': conversions,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, name, status, type];
}