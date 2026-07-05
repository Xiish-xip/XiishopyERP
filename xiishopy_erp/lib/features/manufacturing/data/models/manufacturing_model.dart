/// Xiishopy ERP - Manufacturing Models
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class BOMItem extends Equatable {
  final String productId;
  final String productName;
  final String sku;
  final double quantity;
  final String unit;
  final double unitCost;
  final bool isPurchased; // true = raw material, false = manufactured component

  const BOMItem({
    required this.productId,
    required this.productName,
    this.sku = '',
    this.quantity = 1,
    this.unit = 'pcs',
    this.unitCost = 0.0,
    this.isPurchased = true,
  });

  factory BOMItem.fromMap(Map<String, dynamic> data) {
    return BOMItem(
      productId: data['productId'] as String? ?? '',
      productName: data['productName'] as String? ?? '',
      sku: data['sku'] as String? ?? '',
      quantity: (data['quantity'] as num?)?.toDouble() ?? 1,
      unit: data['unit'] as String? ?? 'pcs',
      unitCost: (data['unitCost'] as num?)?.toDouble() ?? 0.0,
      isPurchased: data['isPurchased'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'productName': productName,
    'sku': sku,
    'quantity': quantity,
    'unit': unit,
    'unitCost': unitCost,
    'isPurchased': isPurchased,
  };

  @override
  List<Object?> get props => [productId, productName, quantity];
}

class BOMModel extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final String sku;
  final String version;
  final String status; // Draft, Active, Obsolete
  final List<BOMItem> components;
  final double totalCost;
  final double totalQuantity;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BOMModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.sku = '',
    this.version = '1.0',
    this.status = 'Draft',
    this.components = const [],
    this.totalCost = 0.0,
    this.totalQuantity = 0.0,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BOMModel.fromFirestore(Map<String, dynamic> data, String docId) {
    final comps = data['components'] as List<dynamic>? ?? [];
    return BOMModel(
      id: docId,
      productId: data['productId'] as String? ?? '',
      productName: data['productName'] as String? ?? '',
      sku: data['sku'] as String? ?? '',
      version: data['version'] as String? ?? '1.0',
      status: data['status'] as String? ?? 'Draft',
      components: comps.map((c) => BOMItem.fromMap(c as Map<String, dynamic>)).toList(),
      totalCost: (data['totalCost'] as num?)?.toDouble() ?? 0.0,
      totalQuantity: (data['totalQuantity'] as num?)?.toDouble() ?? 0.0,
      notes: data['notes'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'productId': productId,
    'productName': productName,
    'sku': sku,
    'version': version,
    'status': status,
    'components': components.map((c) => c.toMap()).toList(),
    'totalCost': totalCost,
    'totalQuantity': totalQuantity,
    'notes': notes,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, productId, version, status, totalCost];
}

class WorkOrderModel extends Equatable {
  final String id;
  final String orderNumber;
  final String bomId;
  final String productId;
  final String productName;
  final double quantity;
  final double producedQuantity;
  final double defectiveQuantity;
  final String status; // Planned, In Progress, Completed, Cancelled
  final String priority; // Low, Medium, High, Urgent
  final DateTime? startDate;
  final DateTime? dueDate;
  final DateTime? completedDate;
  final String? assignedTo;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkOrderModel({
    required this.id,
    required this.orderNumber,
    required this.bomId,
    required this.productId,
    this.productName = '',
    this.quantity = 1,
    this.producedQuantity = 0,
    this.defectiveQuantity = 0,
    this.status = 'Planned',
    this.priority = 'Medium',
    this.startDate,
    this.dueDate,
    this.completedDate,
    this.assignedTo,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkOrderModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return WorkOrderModel(
      id: docId,
      orderNumber: data['orderNumber'] as String? ?? '',
      bomId: data['bomId'] as String? ?? '',
      productId: data['productId'] as String? ?? '',
      productName: data['productName'] as String? ?? '',
      quantity: (data['quantity'] as num?)?.toDouble() ?? 1,
      producedQuantity: (data['producedQuantity'] as num?)?.toDouble() ?? 0,
      defectiveQuantity: (data['defectiveQuantity'] as num?)?.toDouble() ?? 0,
      status: data['status'] as String? ?? 'Planned',
      priority: data['priority'] as String? ?? 'Medium',
      startDate: safeToDate(data['startDate']),
      dueDate: safeToDate(data['dueDate']),
      completedDate: safeToDate(data['completedDate']),
      assignedTo: data['assignedTo'] as String?,
      notes: data['notes'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'orderNumber': orderNumber,
    'bomId': bomId,
    'productId': productId,
    'productName': productName,
    'quantity': quantity,
    'producedQuantity': producedQuantity,
    'defectiveQuantity': defectiveQuantity,
    'status': status,
    'priority': priority,
    'startDate': startDate?.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    'completedDate': completedDate?.toIso8601String(),
    'assignedTo': assignedTo,
    'notes': notes,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, orderNumber, status, priority];
}

class ProductionPlanModel extends Equatable {
  final String id;
  final String planNumber;
  final String productId;
  final String productName;
  final double plannedQuantity;
  final double scheduledQuantity;
  final String period; // Daily, Weekly, Monthly, Quarterly
  final DateTime startDate;
  final DateTime endDate;
  final String status; // Draft, Approved, In Progress, Completed
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductionPlanModel({
    required this.id,
    required this.planNumber,
    required this.productId,
    this.productName = '',
    this.plannedQuantity = 0,
    this.scheduledQuantity = 0,
    this.period = 'Monthly',
    required this.startDate,
    required this.endDate,
    this.status = 'Draft',
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductionPlanModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ProductionPlanModel(
      id: docId,
      planNumber: data['planNumber'] as String? ?? '',
      productId: data['productId'] as String? ?? '',
      productName: data['productName'] as String? ?? '',
      plannedQuantity: (data['plannedQuantity'] as num?)?.toDouble() ?? 0,
      scheduledQuantity: (data['scheduledQuantity'] as num?)?.toDouble() ?? 0,
      period: data['period'] as String? ?? 'Monthly',
      startDate: safeToDate(data['startDate']),
      endDate: safeToDate(data['endDate']),
      status: data['status'] as String? ?? 'Draft',
      notes: data['notes'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'planNumber': planNumber,
    'productId': productId,
    'productName': productName,
    'plannedQuantity': plannedQuantity,
    'scheduledQuantity': scheduledQuantity,
    'period': period,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'status': status,
    'notes': notes,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, planNumber, productId, status];
}