/// Xiishopy ERP - Payment Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/payment_model.dart';
import '../domain/repositories/payment_repository.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _repository;
  StreamSubscription? _sub;

  PaymentBloc({required PaymentRepository repository})
      : _repository = repository,
        super(const PaymentsLoading()) {
    on<WatchPayments>(_onWatch);
  }

  Future<void> _onWatch(WatchPayments event, Emitter<PaymentState> emit) async {
    emit(const PaymentsLoading());
    await _sub?.cancel();
    if (emit.isDone) return;
    _sub = _repository.watchPayments().listen(
      (result) {
        if (emit.isDone) return;
        result.fold(
          (f) => emit(PaymentsError(message: f.message)),
          (p) => emit(PaymentsLoaded(payments: p)),
        );
      },
      onError: (e) {
        if (emit.isDone) return;
        emit(PaymentsError(message: e.toString()));
      },
    );
  }

  @override Future<void> close() { _sub?.cancel(); return super.close(); }
}