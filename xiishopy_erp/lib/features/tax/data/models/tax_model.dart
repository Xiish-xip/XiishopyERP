/// Xiishopy ERP - Tax Engine Models
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class TaxConfigModel extends Equatable {
  final String id;
  final String name;
  final String region; // TZ, KE, UG, RW, BI, SS, Other
  final String taxType; // VAT, GST, Sales Tax, Withholding, Excise, Other
  final double rate; // Percentage
  final String? description;
  final bool isActive;
  final bool isCompound; // Tax on tax
  final String? recoveryType; // Input, Output, Non-Recoverable
  final String? reportingCategory;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaxConfigModel({
    required this.id,
    required this.name,
    required this.region,
    this.taxType = 'VAT',
    this.rate = 0.0,
    this.description,
    this.isActive = true,
    this.isCompound = false,
    this.recoveryType,
    this.reportingCategory,
    required this.effectiveFrom,
    this.effectiveTo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaxConfigModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return TaxConfigModel(
      id: docId,
      name: data['name'] as String? ?? '',
      region: data['region'] as String? ?? 'TZ',
      taxType: data['taxType'] as String? ?? 'VAT',
      rate: (data['rate'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] as String?,
      isActive: data['isActive'] as bool? ?? true,
      isCompound: data['isCompound'] as bool? ?? false,
      recoveryType: data['recoveryType'] as String?,
      reportingCategory: data['reportingCategory'] as String?,
      effectiveFrom: safeToDate(data['effectiveFrom']),
      effectiveTo: safeToDate(data['effectiveTo']),
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'region': region,
    'taxType': taxType,
    'rate': rate,
    'description': description,
    'isActive': isActive,
    'isCompound': isCompound,
    'recoveryType': recoveryType,
    'reportingCategory': reportingCategory,
    'effectiveFrom': effectiveFrom.toIso8601String(),
    'effectiveTo': effectiveTo?.toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
  };

  TaxConfigModel copyWith({
    String? name,
    String? region,
    String? taxType,
    double? rate,
    String? description,
    bool? isActive,
    bool? isCompound,
    String? recoveryType,
    String? reportingCategory,
    DateTime? effectiveFrom,
    DateTime? effectiveTo,
  }) {
    return TaxConfigModel(
      id: id,
      name: name ?? this.name,
      region: region ?? this.region,
      taxType: taxType ?? this.taxType,
      rate: rate ?? this.rate,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      isCompound: isCompound ?? this.isCompound,
      recoveryType: recoveryType ?? this.recoveryType,
      reportingCategory: reportingCategory ?? this.reportingCategory,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo ?? this.effectiveTo,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, name, region, taxType, rate, isActive];
}

class TaxRateModel extends Equatable {
  final String id;
  final String taxConfigId;
  final String name;
  final double minAmount;
  final double maxAmount;
  final double rate; // Percentage override if different from base
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaxRateModel({
    required this.id,
    required this.taxConfigId,
    required this.name,
    this.minAmount = 0.0,
    this.maxAmount = double.infinity,
    this.rate = 0.0,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaxRateModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return TaxRateModel(
      id: docId,
      taxConfigId: data['taxConfigId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      minAmount: (data['minAmount'] as num?)?.toDouble() ?? 0.0,
      maxAmount: (data['maxAmount'] as num?)?.toDouble() ?? double.infinity,
      rate: (data['rate'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'taxConfigId': taxConfigId,
    'name': name,
    'minAmount': minAmount,
    'maxAmount': maxAmount == double.infinity ? -1 : maxAmount,
    'rate': rate,
    'description': description,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, taxConfigId, name, rate];
}