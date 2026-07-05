/// Xiishopy ERP - Payment Data Model
/// Matches backend PaymentProvider, PaymentStatus enums.
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class PaymentModel extends Equatable {
  final String id;
  final String orderId;
  final String retailerId;
  final String? distributorId;
  final double amountUSD;
  final double amountLocal;
  final String currency;
  final String provider;
  final String status;
  final String? transactionId;
  final String? phoneNumber;
  final String? mpesaCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentModel({
    required this.id,
    required this.orderId,
    required this.retailerId,
    this.distributorId,
    required this.amountUSD,
    required this.amountLocal,
    required this.currency,
    required this.provider,
    required this.status,
    this.transactionId,
    this.phoneNumber,
    this.mpesaCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return PaymentModel(
      id: docId,
      orderId: data['orderId'] as String? ?? '',
      retailerId: data['retailerId'] as String? ?? '',
      distributorId: data['distributorId'] as String?,
      amountUSD: (data['amountUSD'] as num?)?.toDouble() ?? 0.0,
      amountLocal: (data['amountLocal'] as num?)?.toDouble() ?? 0.0,
      currency: data['currency'] as String? ?? 'USD',
      provider: data['provider'] as String? ?? 'mpesa',
      status: data['status'] as String? ?? 'pending',
      transactionId: data['transactionId'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      mpesaCode: data['mpesaCode'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'orderId': orderId,
    'retailerId': retailerId,
    'distributorId': distributorId,
    'amountUSD': amountUSD,
    'amountLocal': amountLocal,
    'currency': currency,
    'provider': provider,
    'status': status,
    'transactionId': transactionId,
    'phoneNumber': phoneNumber,
    'mpesaCode': mpesaCode,
    'updatedAt': DateTime.now(),
  };

  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';
  bool get isPending => status == 'pending';

  @override
  List<Object?> get props =>
      [id, orderId, amountUSD, currency, provider, status];
}