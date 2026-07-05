/// Xiishopy ERP - Customer Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/customer_model.dart';
import '../domain/repositories/customer_repository.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository _repository;
  StreamSubscription? _sub;

  CustomerBloc({required CustomerRepository repository})
      : _repository = repository,
        super(const CustomersLoading()) {
    on<WatchCustomers>(_onWatch);
  }

  Future<void> _onWatch(WatchCustomers event, Emitter<CustomerState> emit) async {
    emit(const CustomersLoading());
    await _sub?.cancel();
    if (emit.isDone) return;
    _sub = _repository.watchCustomers().listen(
      (result) {
        if (emit.isDone) return;
        result.fold(
          (f) => emit(CustomersError(message: f.message)),
          (c) => emit(CustomersLoaded(customers: c)),
        );
      },
      onError: (e) {
        if (emit.isDone) return;
        emit(CustomersError(message: e.toString()));
      },
    );
  }

  @override Future<void> close() { _sub?.cancel(); return super.close(); }
}