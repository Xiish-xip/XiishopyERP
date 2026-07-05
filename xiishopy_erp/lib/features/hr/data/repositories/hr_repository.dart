/// Xiishopy ERP - HR Repository
library;

import 'dart:async';
import '../datasources/hr_remote_datasource.dart';
import '../models/employee_model.dart';
import '../models/attendance_model.dart';
import '../models/leave_model.dart';
import '../models/payroll_model.dart';

class HrRepository {
  final HrRemoteDataSource _remoteDataSource;

  HrRepository({required HrRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  // Employees
  Stream<List<EmployeeModel>> watchEmployees() => _remoteDataSource.watchEmployees();
  Future<void> createEmployee(EmployeeModel employee) => _remoteDataSource.createEmployee(employee);
  Future<void> updateEmployee(EmployeeModel employee) => _remoteDataSource.updateEmployee(employee);
  Future<void> deleteEmployee(String id) => _remoteDataSource.deleteEmployee(id);

  // Attendance
  Stream<List<AttendanceModel>> watchAttendance() => _remoteDataSource.watchAttendance();
  Future<void> createAttendance(AttendanceModel attendance) => _remoteDataSource.createAttendance(attendance);

  // Leave
  Stream<List<LeaveModel>> watchLeaveRequests() => _remoteDataSource.watchLeaveRequests();
  Future<void> createLeaveRequest(LeaveModel leave) => _remoteDataSource.createLeaveRequest(leave);
  Future<void> approveLeave(String id, String approvedBy) => _remoteDataSource.approveLeave(id, approvedBy);
  Future<void> rejectLeave(String id, String reason) => _remoteDataSource.rejectLeave(id, reason);

  // Payroll
  Stream<List<PayrollModel>> watchPayroll() => _remoteDataSource.watchPayroll();
  Future<void> createPayroll(PayrollModel payroll) => _remoteDataSource.createPayroll(payroll);
  Future<void> markPayrollPaid(String id, String method) => _remoteDataSource.markPayrollPaid(id, method);
}