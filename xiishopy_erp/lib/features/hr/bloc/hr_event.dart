/// Xiishopy ERP - HR Events
part of 'hr_bloc.dart';

abstract class HrEvent extends Equatable {
  const HrEvent();

  @override
  List<Object?> get props => [];
}

// ── Employees ──
class WatchEmployees extends HrEvent {
  const WatchEmployees();
}

class CreateEmployee extends HrEvent {
  final EmployeeModel employee;
  const CreateEmployee({required this.employee});
  @override
  List<Object?> get props => [employee];
}

class UpdateEmployee extends HrEvent {
  final EmployeeModel employee;
  const UpdateEmployee({required this.employee});
  @override
  List<Object?> get props => [employee];
}

class DeleteEmployee extends HrEvent {
  final String employeeId;
  const DeleteEmployee({required this.employeeId});
  @override
  List<Object?> get props => [employeeId];
}

// ── Attendance ──
class WatchAttendance extends HrEvent {
  const WatchAttendance();
}

class CreateAttendance extends HrEvent {
  final AttendanceModel attendance;
  const CreateAttendance({required this.attendance});
  @override
  List<Object?> get props => [attendance];
}

// ── Leave ──
class WatchLeaveRequests extends HrEvent {
  const WatchLeaveRequests();
}

class CreateLeaveRequest extends HrEvent {
  final LeaveModel leave;
  const CreateLeaveRequest({required this.leave});
  @override
  List<Object?> get props => [leave];
}

class ApproveLeave extends HrEvent {
  final String leaveId;
  final String approvedBy;
  const ApproveLeave({required this.leaveId, required this.approvedBy});
  @override
  List<Object?> get props => [leaveId, approvedBy];
}

class RejectLeave extends HrEvent {
  final String leaveId;
  final String reason;
  const RejectLeave({required this.leaveId, required this.reason});
  @override
  List<Object?> get props => [leaveId, reason];
}

// ── Payroll ──
class WatchPayroll extends HrEvent {
  const WatchPayroll();
}

class CreatePayroll extends HrEvent {
  final PayrollModel payroll;
  const CreatePayroll({required this.payroll});
  @override
  List<Object?> get props => [payroll];
}

class MarkPayrollPaid extends HrEvent {
  final String payrollId;
  final String method;
  const MarkPayrollPaid({required this.payrollId, required this.method});
  @override
  List<Object?> get props => [payrollId, method];
}

// ── Tab Switch ──
class SwitchHrTab extends HrEvent {
  final int tabIndex;
  const SwitchHrTab({required this.tabIndex});
  @override
  List<Object?> get props => [tabIndex];
}

class HrError extends HrEvent {
  final String message;
  const HrError({required this.message});
  @override
  List<Object?> get props => [message];
}