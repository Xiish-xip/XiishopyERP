/// Xiishopy ERP - Employee Model
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class EmployeeModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String department;
  final String position;
  final String status; // Active, On Leave, Inactive, Terminated
  final String? employeeId;
  final DateTime? dateOfBirth;
  final DateTime? dateOfJoining;
  final double salary;
  final String? emergencyContact;
  final String? emergencyPhone;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EmployeeModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.department,
    required this.position,
    this.status = 'Active',
    this.employeeId,
    this.dateOfBirth,
    this.dateOfJoining,
    this.salary = 0.0,
    this.emergencyContact,
    this.emergencyPhone,
    this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory EmployeeModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return EmployeeModel(
      id: docId,
      firstName: data['firstName'] as String? ?? '',
      lastName: data['lastName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      department: data['department'] as String? ?? '',
      position: data['position'] as String? ?? '',
      status: data['status'] as String? ?? 'Active',
      employeeId: data['employeeId'] as String?,
      dateOfBirth: safeToDate(data['dateOfBirth']),
      dateOfJoining: safeToDate(data['dateOfJoining']),
      salary: (data['salary'] as num?)?.toDouble() ?? 0.0,
      emergencyContact: data['emergencyContact'] as String?,
      emergencyPhone: data['emergencyPhone'] as String?,
      address: data['address'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'department': department,
    'position': position,
    'status': status,
    'employeeId': employeeId,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'dateOfJoining': dateOfJoining?.toIso8601String(),
    'salary': salary,
    'emergencyContact': emergencyContact,
    'emergencyPhone': emergencyPhone,
    'address': address,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  EmployeeModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? department,
    String? position,
    String? status,
    String? employeeId,
    DateTime? dateOfBirth,
    DateTime? dateOfJoining,
    double? salary,
    String? emergencyContact,
    String? emergencyPhone,
    String? address,
  }) {
    return EmployeeModel(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      position: position ?? this.position,
      status: status ?? this.status,
      employeeId: employeeId ?? this.employeeId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      dateOfJoining: dateOfJoining ?? this.dateOfJoining,
      salary: salary ?? this.salary,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      address: address ?? this.address,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, department, status];
}