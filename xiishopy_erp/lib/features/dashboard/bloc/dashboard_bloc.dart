/// Xiishopy ERP - Dashboard Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;
  StreamSubscription? _sub;

  DashboardBloc({required this._repository})
      : super(const DashboardLoading()) {
    on<WatchDashboard>(_onWatch);
  }

  Future<void> _onWatch(WatchDashboard event, Emitter<DashboardState> emit) async {
    emit(const DashboardLoading());
    await _sub?.cancel();
    if (emit.isDone) return;
    _sub = _repository.watchDashboard().listen(
      (result) {
        if (emit.isDone) return;
        result.fold(
          (f) => emit(DashboardError(message: f.message)),
          (d) => emit(DashboardLoaded(data: d)),
        );
      },
      onError: (e) {
        if (emit.isDone) return;
        emit(DashboardError(message: e.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
