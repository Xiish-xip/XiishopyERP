/// Xiishopy ERP - Logistics Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/shipment_model.dart';
import '../domain/repositories/logistics_repository.dart';
import 'logistics_event.dart';
import 'logistics_state.dart';

class LogisticsBloc extends Bloc<LogisticsEvent, LogisticsState> {
  final LogisticsRepository _repository;
  StreamSubscription? _sub;

  LogisticsBloc({required LogisticsRepository repository})
      : _repository = repository,
        super(const LogisticsLoading()) {
    on<WatchShipments>(_onWatch);
  }

  Future<void> _onWatch(WatchShipments event, Emitter<LogisticsState> emit) async {
    emit(const LogisticsLoading());
    await _sub?.cancel();
    if (emit.isDone) return;
    _sub = _repository.watchShipments().listen(
      (result) {
        if (emit.isDone) return;
        result.fold(
          (f) => emit(LogisticsError(message: f.message)),
          (s) => emit(LogisticsLoaded(shipments: s)),
        );
      },
      onError: (e) {
        if (emit.isDone) return;
        emit(LogisticsError(message: e.toString()));
      },
    );
  }

  @override Future<void> close() { _sub?.cancel(); return super.close(); }
}