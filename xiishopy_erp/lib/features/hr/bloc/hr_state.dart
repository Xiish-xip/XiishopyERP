/// Xiishopy ERP - HR States
part of 'hr_bloc.dart';

abstract class HrState extends Equatable {
  final int selectedTab;
  const HrState({this.selectedTab = 0});

  @override
  List<Object?> get props => [selectedTab];
}

class HrInitial extends HrState {
  const HrInitial({super.selectedTab = 0});
}

class HrLoading extends HrState {
  const HrLoading({super.selectedTab = 0});
}

class HrEmployeesLoaded extends HrState {
  final List<EmployeeModel> employees;
  const HrEmployeesLoaded({required this.employees, super.selectedTab = 0});
  @override
  List<Object?> get props => [employees, selectedTab];
}

class HrAttendanceLoaded extends HrState {
  final List<AttendanceModel> attendance;
  const HrAttendanceLoaded({required this.attendance, super.selectedTab = 1});
  @override
  List<Object?> get props => [attendance, selectedTab];
}

class HrLeaveLoaded extends HrState {
  final List<LeaveModel> leaveRequests;
  const HrLeaveLoaded({required this.leaveRequests, super.selectedTab = 2});
  @override
  List<Object?> get props => [leaveRequests, selectedTab];
}

class HrPayrollLoaded extends HrState {
  final List<PayrollModel> payrolls;
  const HrPayrollLoaded({required this.payrolls, super.selectedTab = 3});
  @override
  List<Object?> get props => [payrolls, selectedTab];
}

class HrErrorState extends HrState {
  final String message;
  const HrErrorState({required this.message, super.selectedTab = 0});
  @override
  List<Object?> get props => [message, selectedTab];
}