/// Xiishopy ERP - Payroll Model
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class PayrollModel extends Equatable {
  final String id;
  final String employeeId;
  final String employeeName;
  final String period; // e.g. "2026-06"
  final double basicSalary;
  final double allowances;
  final double deductions;
  final double tax;
  final double netPay;
  final String status; // Draft, Calculated, Paid, Cancelled
  final DateTime? paidAt;
  final String? paymentMethod;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PayrollModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.period,
    this.basicSalary = 0.0,
    this.allowances = 0.0,
    this.deductions = 0.0,
    this.tax = 0.0,
    this.netPay = 0.0,
    this.status = 'Draft',
    this.paidAt,
    this.paymentMethod,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  double get grossPay => basicSalary + allowances;

  factory PayrollModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return PayrollModel(
      id: docId,
      employeeId: data['employeeId'] as String? ?? '',
      employeeName: data['employeeName'] as String? ?? '',
      period: data['period'] as String? ?? '',
      basicSalary: (data['basicSalary'] as num?)?.toDouble() ?? 0.0,
      allowances: (data['allowances'] as num?)?.toDouble() ?? 0.0,
      deductions: (data['deductions'] as num?)?.toDouble() ?? 0.0,
      tax: (data['tax'] as num?)?.toDouble() ?? 0.0,
      netPay: (data['netPay'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] as String? ?? 'Draft',
      paidAt: safeToDate(data['paidAt']),
      paymentMethod: data['paymentMethod'] as String?,
      notes: data['notes'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'employeeId': employeeId,
    'employeeName': employeeName,
    'period': period,
    'basicSalary': basicSalary,
    'allowances': allowances,
    'deductions': deductions,
    'tax': tax,
    'netPay': netPay,
    'status': status,
    'paidAt': paidAt?.toIso8601String(),
    'paymentMethod': paymentMethod,
    'notes': notes,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, employeeId, period, status, netPay];
}