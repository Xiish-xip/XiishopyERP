/// Xiishopy ERP - Supplier Model
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class SupplierModel extends Equatable {
  final String id;
  final String name;
  final String contactPerson;
  final String email;
  final String phone;
  final String category;
  final String? address;
  final String? taxId;
  final double rating;
  final String status; // Active, Inactive, Blacklisted
  final double totalPurchases;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SupplierModel({
    required this.id,
    required this.name,
    required this.contactPerson,
    required this.email,
    required this.phone,
    required this.category,
    this.address,
    this.taxId,
    this.rating = 0.0,
    this.status = 'Active',
    this.totalPurchases = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupplierModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return SupplierModel(
      id: docId,
      name: data['name'] as String? ?? '',
      contactPerson: data['contactPerson'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      category: data['category'] as String? ?? '',
      address: data['address'] as String?,
      taxId: data['taxId'] as String?,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] as String? ?? 'Active',
      totalPurchases: (data['totalPurchases'] as num?)?.toDouble() ?? 0.0,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'contactPerson': contactPerson,
    'email': email,
    'phone': phone,
    'category': category,
    'address': address,
    'taxId': taxId,
    'rating': rating,
    'status': status,
    'totalPurchases': totalPurchases,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, name, email, status, rating];
}