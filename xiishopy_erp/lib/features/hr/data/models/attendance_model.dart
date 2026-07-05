/// Xiishopy ERP - Attendance Model
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class AttendanceModel extends Equatable {
  final String id;
  final String employeeId;
  final String employeeName;
  final DateTime date;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final String status; // Present, Late, Absent, Half-Day
  final double? hoursWorked;
  final String? notes;
  final DateTime createdAt;

  const AttendanceModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    this.clockIn,
    this.clockOut,
    this.status = 'Present',
    this.hoursWorked,
    this.notes,
    required this.createdAt,
  });

  factory AttendanceModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return AttendanceModel(
      id: docId,
      employeeId: data['employeeId'] as String? ?? '',
      employeeName: data['employeeName'] as String? ?? '',
      date: safeToDate(data['date']),
      clockIn: safeToDate(data['clockIn']),
      clockOut: safeToDate(data['clockOut']),
      status: data['status'] as String? ?? 'Present',
      hoursWorked: (data['hoursWorked'] as num?)?.toDouble(),
      notes: data['notes'] as String?,
      createdAt: safeToDate(data['createdAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'employeeId': employeeId,
    'employeeName': employeeName,
    'date': date.toIso8601String(),
    'clockIn': clockIn?.toIso8601String(),
    'clockOut': clockOut?.toIso8601String(),
    'status': status,
    'hoursWorked': hoursWorked,
    'notes': notes,
    'createdAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, employeeId, date, status];
}