/// Xiishopy ERP - Customer Data Model
/// Retailer/distributor profile from Firestore users collection.
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class CustomerModel extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? companyName;
  final String role;
  final String? country;
  final String? phone;
  final String? photoUrl;
  final double balance;
  final String? language;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CustomerModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.companyName,
    required this.role,
    this.country,
    this.phone,
    this.photoUrl,
    this.balance = 0.0,
    this.language,
    this.emailVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return CustomerModel(
      id: docId,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      companyName: data['companyName'] as String?,
      role: data['role'] as String? ?? 'retailer',
      country: data['country'] as String?,
      phone: data['phoneNumber'] as String? ?? data['phone'] as String?,
      photoUrl: data['photoUrl'] as String?,
      balance: (data['balance'] as num?)?.toDouble() ?? 0.0,
      language: data['language'] as String?,
      emailVerified: data['emailVerified'] as bool? ?? false,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'email': email,
    'displayName': displayName,
    'companyName': companyName,
    'role': role,
    'country': country,
    'phone': phone,
    'photoUrl': photoUrl,
    'balance': balance,
    'language': language,
    'emailVerified': emailVerified,
    'updatedAt': DateTime.now(),
  };

  bool get isDistributor => role == 'distributor';
  bool get isRetailer => role == 'retailer';

  @override
  List<Object?> get props =>
      [id, email, displayName, role, country, balance];
}