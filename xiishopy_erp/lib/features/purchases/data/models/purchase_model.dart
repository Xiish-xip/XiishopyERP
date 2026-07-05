/// Xiishopy ERP - Purchase Order Model
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class PurchaseModel extends Equatable {
  final String id;
  final String poNumber;
  final String supplierId;
  final String supplierName;
  final List<PurchaseItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final String status; // Draft, Pending, Approved, Ordered, Received, Cancelled
  final String? approvedBy;
  final DateTime? approvedAt;
  final DateTime? expectedDelivery;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PurchaseModel({
    required this.id,
    required this.poNumber,
    required this.supplierId,
    required this.supplierName,
    this.items = const [],
    this.subtotal = 0.0,
    this.tax = 0.0,
    this.total = 0.0,
    this.status = 'Draft',
    this.approvedBy,
    this.approvedAt,
    this.expectedDelivery,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PurchaseModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return PurchaseModel(
      id: docId,
      poNumber: data['poNumber'] as String? ?? '',
      supplierId: data['supplierId'] as String? ?? '',
      supplierName: data['supplierName'] as String? ?? '',
      items: (data['items'] as List<dynamic>?)
              ?.map((e) => PurchaseItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0.0,
      tax: (data['tax'] as num?)?.toDouble() ?? 0.0,
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] as String? ?? 'Draft',
      approvedBy: data['approvedBy'] as String?,
      approvedAt: safeToDate(data['approvedAt']),
      expectedDelivery: safeToDate(data['expectedDelivery']),
      notes: data['notes'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'poNumber': poNumber,
    'supplierId': supplierId,
    'supplierName': supplierName,
    'items': items.map((e) => e.toJson()).toList(),
    'subtotal': subtotal,
    'tax': tax,
    'total': total,
    'status': status,
    'approvedBy': approvedBy,
    'approvedAt': approvedAt?.toIso8601String(),
    'expectedDelivery': expectedDelivery?.toIso8601String(),
    'notes': notes,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, poNumber, status, total];
}

class PurchaseItem extends Equatable {
  final String productId;
  final String productName;
  final double quantity;
  final double unitPrice;
  final double totalPrice;

  const PurchaseItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.totalPrice = 0.0,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) => PurchaseItem(
    productId: json['productId'] as String? ?? '',
    productName: json['productName'] as String? ?? '',
    quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
    unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
    totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'totalPrice': totalPrice,
  };

  @override
  List<Object?> get props => [productId, productName, quantity, unitPrice];
}