/// Xiishopy ERP - Order Data Model
/// Matches Firestore orders collection and backend OrderStatus enum.
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class OrderItem extends Equatable {
  final String productId;
  final String productName;
  final String sku;
  final int quantity;
  final double unitPriceUSD;
  final double totalPriceUSD;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.quantity,
    required this.unitPriceUSD,
    required this.totalPriceUSD,
  });

  factory OrderItem.fromFirestore(Map<String, dynamic> data) {
    return OrderItem(
      productId: data['productId'] as String? ?? '',
      productName: data['productName'] as String? ?? '',
      sku: data['sku'] as String? ?? '',
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      unitPriceUSD: (data['unitPriceUSD'] as num?)?.toDouble() ?? 0.0,
      totalPriceUSD: (data['totalPriceUSD'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'productId': productId,
    'productName': productName,
    'sku': sku,
    'quantity': quantity,
    'unitPriceUSD': unitPriceUSD,
    'totalPriceUSD': totalPriceUSD,
  };

  @override
  List<Object?> get props => [productId, sku, quantity, totalPriceUSD];
}

class OrderModel extends Equatable {
  final String id;
  final String orderNumber;
  final String retailerId;
  final String retailerName;
  final String? distributorId;
  final List<OrderItem> items;
  final double subtotalUSD;
  final double shippingUSD;
  final double taxUSD;
  final double totalUSD;
  final String status;
  final String? paymentId;
  final String? shipmentId;
  final String? notes;
  final String? deliveryAddress;
  final String? trackingNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.retailerId,
    required this.retailerName,
    this.distributorId,
    required this.items,
    required this.subtotalUSD,
    this.shippingUSD = 0.0,
    this.taxUSD = 0.0,
    required this.totalUSD,
    required this.status,
    this.paymentId,
    this.shipmentId,
    this.notes,
    this.deliveryAddress,
    this.trackingNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return OrderModel(
      id: docId,
      orderNumber: data['orderNumber'] as String? ?? docId,
      retailerId: data['retailerId'] as String? ?? '',
      retailerName: data['retailerName'] as String? ?? '',
      distributorId: data['distributorId'] as String?,
      items: (data['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromFirestore(e as Map<String, dynamic>))
              .toList() ??
          [],
      subtotalUSD: (data['subtotalUSD'] as num?)?.toDouble() ?? 0.0,
      shippingUSD: (data['shippingUSD'] as num?)?.toDouble() ?? 0.0,
      taxUSD: (data['taxUSD'] as num?)?.toDouble() ?? 0.0,
      totalUSD: (data['totalUSD'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] as String? ?? 'pending',
      paymentId: data['paymentId'] as String?,
      shipmentId: data['shipmentId'] as String?,
      notes: data['notes'] as String?,
      deliveryAddress: data['deliveryAddress'] as String?,
      trackingNumber: data['trackingNumber'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'orderNumber': orderNumber,
    'retailerId': retailerId,
    'retailerName': retailerName,
    'distributorId': distributorId,
    'items': items.map((e) => e.toFirestore()).toList(),
    'subtotalUSD': subtotalUSD,
    'shippingUSD': shippingUSD,
    'taxUSD': taxUSD,
    'totalUSD': totalUSD,
    'status': status,
    'paymentId': paymentId,
    'shipmentId': shipmentId,
    'notes': notes,
    'deliveryAddress': deliveryAddress,
    'trackingNumber': trackingNumber,
    'updatedAt': DateTime.now(),
  };

  @override
  List<Object?> get props =>
      [id, orderNumber, status, totalUSD, items];
}