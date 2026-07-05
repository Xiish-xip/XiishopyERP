/// Xiishopy ERP - Expense Model
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class ExpenseModel extends Equatable {
  final String id;
  final String description;
  final double amount;
  final String category; // Travel, Office, Utilities, Salary, Maintenance, Other
  final String? receiptUrl;
  final DateTime expenseDate;
  final String submittedBy;
  final String submittedByName;
  final String status; // Draft, Pending, Approved, Rejected, Paid
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExpenseModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    this.receiptUrl,
    required this.expenseDate,
    required this.submittedBy,
    required this.submittedByName,
    this.status = 'Pending',
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ExpenseModel(
      id: docId,
      description: data['description'] as String? ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      category: data['category'] as String? ?? 'Other',
      receiptUrl: data['receiptUrl'] as String?,
      expenseDate: safeToDate(data['expenseDate']),
      submittedBy: data['submittedBy'] as String? ?? '',
      submittedByName: data['submittedByName'] as String? ?? '',
      status: data['status'] as String? ?? 'Pending',
      approvedBy: data['approvedBy'] as String?,
      approvedAt: safeToDate(data['approvedAt']),
      rejectionReason: data['rejectionReason'] as String?,
      notes: data['notes'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'description': description,
    'amount': amount,
    'category': category,
    'receiptUrl': receiptUrl,
    'expenseDate': expenseDate.toIso8601String(),
    'submittedBy': submittedBy,
    'submittedByName': submittedByName,
    'status': status,
    'approvedBy': approvedBy,
    'approvedAt': approvedAt?.toIso8601String(),
    'rejectionReason': rejectionReason,
    'notes': notes,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, description, amount, category, status];
}