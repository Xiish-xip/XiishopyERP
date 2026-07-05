/// Xiishopy ERP - Leave Model
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class LeaveModel extends Equatable {
  final String id;
  final String employeeId;
  final String employeeName;
  final String leaveType; // Annual, Sick, Maternity, Emergency, Other
  final DateTime startDate;
  final DateTime endDate;
  final int days;
  final String reason;
  final String status; // Pending, Approved, Rejected, Cancelled
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LeaveModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.reason,
    this.status = 'Pending',
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeaveModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return LeaveModel(
      id: docId,
      employeeId: data['employeeId'] as String? ?? '',
      employeeName: data['employeeName'] as String? ?? '',
      leaveType: data['leaveType'] as String? ?? 'Annual',
      startDate: safeToDate(data['startDate']),
      endDate: safeToDate(data['endDate']),
      days: data['days'] as int? ?? 1,
      reason: data['reason'] as String? ?? '',
      status: data['status'] as String? ?? 'Pending',
      approvedBy: data['approvedBy'] as String?,
      approvedAt: safeToDate(data['approvedAt']),
      rejectionReason: data['rejectionReason'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'employeeId': employeeId,
    'employeeName': employeeName,
    'leaveType': leaveType,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'days': days,
    'reason': reason,
    'status': status,
    'approvedBy': approvedBy,
    'approvedAt': approvedAt?.toIso8601String(),
    'rejectionReason': rejectionReason,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, employeeId, leaveType, status];
}