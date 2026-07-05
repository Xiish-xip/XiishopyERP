/// Xiishopy ERP - HR Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/employee_model.dart';
import '../data/models/attendance_model.dart';
import '../data/models/leave_model.dart';
import '../data/models/payroll_model.dart';
import '../data/repositories/hr_repository.dart';

part 'hr_event.dart';
part 'hr_state.dart';

class HrBloc extends Bloc<HrEvent, HrState> {
  final HrRepository _repository;
  StreamSubscription? _employeesSub;
  StreamSubscription? _attendanceSub;
  StreamSubscription? _leaveSub;
  StreamSubscription? _payrollSub;

  HrBloc({required HrRepository repository})
      : _repository = repository,
        super(const HrInitial()) {
    on<WatchEmployees>(_onWatchEmployees);
    on<CreateEmployee>(_onCreateEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
    on<WatchAttendance>(_onWatchAttendance);
    on<CreateAttendance>(_onCreateAttendance);
    on<WatchLeaveRequests>(_onWatchLeaveRequests);
    on<CreateLeaveRequest>(_onCreateLeaveRequest);
    on<ApproveLeave>(_onApproveLeave);
    on<RejectLeave>(_onRejectLeave);
    on<WatchPayroll>(_onWatchPayroll);
    on<CreatePayroll>(_onCreatePayroll);
    on<MarkPayrollPaid>(_onMarkPayrollPaid);
    on<SwitchHrTab>(_onSwitchTab);
    on<HrError>(_onError);
  }

  void _onWatchEmployees(WatchEmployees event, Emitter<HrState> emit) {
    emit(HrLoading(selectedTab: state.selectedTab));
    _employeesSub?.cancel();
    _employeesSub = _repository.watchEmployees().listen(
      (employees) {
        if (emit.isDone) return;
        emit(HrEmployeesLoaded(employees: employees, selectedTab: state.selectedTab));
      },
      onError: (e) {
        if (emit.isDone) return;
        add(HrError(message: e.toString()));
      },
    );
  }

  Future<void> _onCreateEmployee(CreateEmployee event, Emitter<HrState> emit) async {
    try {
      await _repository.createEmployee(event.employee);
    } catch (e) {
      add(HrError(message: 'Failed to create employee: $e'));
    }
  }

  Future<void> _onUpdateEmployee(UpdateEmployee event, Emitter<HrState> emit) async {
    try {
      await _repository.updateEmployee(event.employee);
    } catch (e) {
      add(HrError(message: 'Failed to update employee: $e'));
    }
  }

  Future<void> _onDeleteEmployee(DeleteEmployee event, Emitter<HrState> emit) async {
    try {
      await _repository.deleteEmployee(event.employeeId);
    } catch (e) {
      add(HrError(message: 'Failed to delete employee: $e'));
    }
  }

  void _onWatchAttendance(WatchAttendance event, Emitter<HrState> emit) {
    emit(HrLoading(selectedTab: state.selectedTab));
    _attendanceSub?.cancel();
    _attendanceSub = _repository.watchAttendance().listen(
      (attendance) {
        if (emit.isDone) return;
        emit(HrAttendanceLoaded(attendance: attendance, selectedTab: state.selectedTab));
      },
      onError: (e) {
        if (emit.isDone) return;
        add(HrError(message: e.toString()));
      },
    );
  }

  Future<void> _onCreateAttendance(CreateAttendance event, Emitter<HrState> emit) async {
    try {
      await _repository.createAttendance(event.attendance);
    } catch (e) {
      add(HrError(message: 'Failed to create attendance: $e'));
    }
  }

  void _onWatchLeaveRequests(WatchLeaveRequests event, Emitter<HrState> emit) {
    emit(HrLoading(selectedTab: state.selectedTab));
    _leaveSub?.cancel();
    _leaveSub = _repository.watchLeaveRequests().listen(
      (leaveRequests) {
        if (emit.isDone) return;
        emit(HrLeaveLoaded(leaveRequests: leaveRequests, selectedTab: state.selectedTab));
      },
      onError: (e) {
        if (emit.isDone) return;
        add(HrError(message: e.toString()));
      },
    );
  }

  Future<void> _onCreateLeaveRequest(CreateLeaveRequest event, Emitter<HrState> emit) async {
    try {
      await _repository.createLeaveRequest(event.leave);
    } catch (e) {
      add(HrError(message: 'Failed to create leave: $e'));
    }
  }

  Future<void> _onApproveLeave(ApproveLeave event, Emitter<HrState> emit) async {
    try {
      await _repository.approveLeave(event.leaveId, event.approvedBy);
    } catch (e) {
      add(HrError(message: 'Failed to approve leave: $e'));
    }
  }

  Future<void> _onRejectLeave(RejectLeave event, Emitter<HrState> emit) async {
    try {
      await _repository.rejectLeave(event.leaveId, event.reason);
    } catch (e) {
      add(HrError(message: 'Failed to reject leave: $e'));
    }
  }

  void _onWatchPayroll(WatchPayroll event, Emitter<HrState> emit) {
    emit(HrLoading(selectedTab: state.selectedTab));
    _payrollSub?.cancel();
    _payrollSub = _repository.watchPayroll().listen(
      (payrolls) {
        if (emit.isDone) return;
        emit(HrPayrollLoaded(payrolls: payrolls, selectedTab: state.selectedTab));
      },
      onError: (e) {
        if (emit.isDone) return;
        add(HrError(message: e.toString()));
      },
    );
  }

  Future<void> _onCreatePayroll(CreatePayroll event, Emitter<HrState> emit) async {
    try {
      await _repository.createPayroll(event.payroll);
    } catch (e) {
      add(HrError(message: 'Failed to create payroll: $e'));
    }
  }

  Future<void> _onMarkPayrollPaid(MarkPayrollPaid event, Emitter<HrState> emit) async {
    try {
      await _repository.markPayrollPaid(event.payrollId, event.method);
    } catch (e) {
      add(HrError(message: 'Failed to mark payroll paid: $e'));
    }
  }

  void _onSwitchTab(SwitchHrTab event, Emitter<HrState> emit) {
    emit(HrLoading(selectedTab: event.tabIndex));
    switch (event.tabIndex) {
      case 0:
        add(const WatchEmployees());
        break;
      case 1:
        add(const WatchAttendance());
        break;
      case 2:
        add(const WatchLeaveRequests());
        break;
      case 3:
        add(const WatchPayroll());
        break;
    }
  }

  void _onError(HrError event, Emitter<HrState> emit) {
    emit(HrErrorState(message: event.message, selectedTab: state.selectedTab));
  }

  @override
  Future<void> close() {
    _employeesSub?.cancel();
    _attendanceSub?.cancel();
    _leaveSub?.cancel();
    _payrollSub?.cancel();
    return super.close();
  }
}