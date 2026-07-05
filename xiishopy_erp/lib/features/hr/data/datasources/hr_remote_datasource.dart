/// Xiishopy ERP - HR Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee_model.dart';
import '../models/attendance_model.dart';
import '../models/leave_model.dart';
import '../models/payroll_model.dart';

class HrRemoteDataSource {
  final FirebaseFirestore _firestore;

  HrRemoteDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // ── Employees ──
  Stream<List<EmployeeModel>> watchEmployees() {
    return _firestore
        .collection('employees')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EmployeeModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createEmployee(EmployeeModel employee) async {
    final doc = _firestore.collection('employees').doc();
    await doc.set(employee.toFirestore());
  }

  Future<void> updateEmployee(EmployeeModel employee) async {
    await _firestore.collection('employees').doc(employee.id).update(employee.toFirestore());
  }

  Future<void> deleteEmployee(String id) async {
    await _firestore.collection('employees').doc(id).update({'status': 'Terminated', 'updatedAt': FieldValue.serverTimestamp()});
  }

  // ── Attendance ──
  Stream<List<AttendanceModel>> watchAttendance() {
    return _firestore
        .collection('attendance')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AttendanceModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createAttendance(AttendanceModel attendance) async {
    final doc = _firestore.collection('attendance').doc();
    await doc.set(attendance.toFirestore());
  }

  // ── Leave ──
  Stream<List<LeaveModel>> watchLeaveRequests() {
    return _firestore
        .collection('leave_requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LeaveModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createLeaveRequest(LeaveModel leave) async {
    final doc = _firestore.collection('leave_requests').doc();
    await doc.set(leave.toFirestore());
  }

  Future<void> approveLeave(String id, String approvedBy) async {
    await _firestore.collection('leave_requests').doc(id).update({
      'status': 'Approved',
      'approvedBy': approvedBy,
      'approvedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> rejectLeave(String id, String reason) async {
    await _firestore.collection('leave_requests').doc(id).update({
      'status': 'Rejected',
      'rejectionReason': reason,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Payroll ──
  Stream<List<PayrollModel>> watchPayroll() {
    return _firestore
        .collection('payroll')
        .orderBy('period', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PayrollModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createPayroll(PayrollModel payroll) async {
    final doc = _firestore.collection('payroll').doc();
    await doc.set(payroll.toFirestore());
  }

  Future<void> markPayrollPaid(String id, String method) async {
    await _firestore.collection('payroll').doc(id).update({
      'status': 'Paid',
      'paymentMethod': method,
      'paidAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}