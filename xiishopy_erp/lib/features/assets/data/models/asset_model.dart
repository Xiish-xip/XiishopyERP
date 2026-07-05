/// Xiishopy ERP - Asset Model
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class AssetModel extends Equatable {
  final String id;
  final String name;
  final String category; // Computer, Furniture, Vehicle, Machinery, Building, Other
  final String? serialNumber;
  final double purchasePrice;
  final DateTime purchaseDate;
  final double currentValue;
  final double? salvageValue;
  final int? usefulLifeYears;
  final String status; // Active, Under Maintenance, Retired, Disposed
  final String? assignedTo;
  final String? assignedToName;
  final String? location;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AssetModel({
    required this.id,
    required this.name,
    required this.category,
    this.serialNumber,
    this.purchasePrice = 0.0,
    required this.purchaseDate,
    this.currentValue = 0.0,
    this.salvageValue,
    this.usefulLifeYears,
    this.status = 'Active',
    this.assignedTo,
    this.assignedToName,
    this.location,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssetModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return AssetModel(
      id: docId,
      name: data['name'] as String? ?? '',
      category: data['category'] as String? ?? 'Other',
      serialNumber: data['serialNumber'] as String?,
      purchasePrice: (data['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      purchaseDate: safeToDate(data['purchaseDate']),
      currentValue: (data['currentValue'] as num?)?.toDouble() ?? 0.0,
      salvageValue: (data['salvageValue'] as num?)?.toDouble(),
      usefulLifeYears: data['usefulLifeYears'] as int?,
      status: data['status'] as String? ?? 'Active',
      assignedTo: data['assignedTo'] as String?,
      assignedToName: data['assignedToName'] as String?,
      location: data['location'] as String?,
      notes: data['notes'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'category': category,
    'serialNumber': serialNumber,
    'purchasePrice': purchasePrice,
    'purchaseDate': purchaseDate.toIso8601String(),
    'currentValue': currentValue,
    'salvageValue': salvageValue,
    'usefulLifeYears': usefulLifeYears,
    'status': status,
    'assignedTo': assignedTo,
    'assignedToName': assignedToName,
    'location': location,
    'notes': notes,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, name, category, status, currentValue];
}