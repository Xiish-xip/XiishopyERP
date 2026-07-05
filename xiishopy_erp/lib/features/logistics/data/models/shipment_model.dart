/// Xiishopy ERP - Shipment/Logistics Data Model
/// Matches backend ShipmentStatus, Carrier enums.
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class TrackingEvent extends Equatable {
  final String status;
  final String location;
  final String description;
  final DateTime timestamp;

  const TrackingEvent({
    required this.status,
    required this.location,
    required this.description,
    required this.timestamp,
  });

  factory TrackingEvent.fromFirestore(Map<String, dynamic> data) {
    return TrackingEvent(
      status: data['status'] as String? ?? '',
      location: data['location'] as String? ?? '',
      description: data['description'] as String? ?? '',
      timestamp: safeToDate(data['timestamp']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'status': status,
    'location': location,
    'description': description,
    'timestamp': timestamp,
  };

  @override
  List<Object?> get props => [status, location, timestamp];
}

class ShipmentModel extends Equatable {
  final String id;
  final String orderId;
  final String retailerId;
  final String? distributorId;
  final String carrier;
  final String status;
  final String? trackingNumber;
  final String? origin;
  final String? destination;
  final DateTime? estimatedDelivery;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final List<TrackingEvent> trackingHistory;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ShipmentModel({
    required this.id,
    required this.orderId,
    required this.retailerId,
    this.distributorId,
    required this.carrier,
    required this.status,
    this.trackingNumber,
    this.origin,
    this.destination,
    this.estimatedDelivery,
    this.pickedUpAt,
    this.deliveredAt,
    this.trackingHistory = const [],
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShipmentModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ShipmentModel(
      id: docId,
      orderId: data['orderId'] as String? ?? '',
      retailerId: data['retailerId'] as String? ?? '',
      distributorId: data['distributorId'] as String?,
      carrier: data['carrier'] as String? ?? '',
      status: data['status'] as String? ?? 'Picked up',
      trackingNumber: data['trackingNumber'] as String?,
      origin: data['origin'] as String?,
      destination: data['destination'] as String?,
      estimatedDelivery: data['estimatedDelivery'] != null ? safeToDate(data['estimatedDelivery']) : null,
      pickedUpAt: data['pickedUpAt'] != null ? safeToDate(data['pickedUpAt']) : null,
      deliveredAt: data['deliveredAt'] != null ? safeToDate(data['deliveredAt']) : null,
      trackingHistory: (data['trackingHistory'] as List<dynamic>?)
              ?.map((e) => TrackingEvent.fromFirestore(e as Map<String, dynamic>))
              .toList() ??
          [],
      notes: data['notes'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'orderId': orderId,
    'retailerId': retailerId,
    'distributorId': distributorId,
    'carrier': carrier,
    'status': status,
    'trackingNumber': trackingNumber,
    'origin': origin,
    'destination': destination,
    'estimatedDelivery': estimatedDelivery,
    'pickedUpAt': pickedUpAt,
    'deliveredAt': deliveredAt,
    'trackingHistory': trackingHistory.map((e) => e.toFirestore()).toList(),
    'notes': notes,
    'updatedAt': DateTime.now(),
  };

  bool get isDelivered => status == 'Delivered';
  bool get isInTransit => status == 'In Transit';

  @override
  List<Object?> get props =>
      [id, orderId, carrier, status, trackingNumber];
}