/// Xiishopy ERP - Order Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/order_model.dart';
import '../domain/repositories/order_repository.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override List<Object?> get props => [];
}
class WatchOrders extends OrderEvent { const WatchOrders(); }

abstract class OrderState extends Equatable {
  const OrderState();
  @override List<Object?> get props => [];
}
class OrdersLoading extends OrderState { const OrdersLoading(); }
class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  const OrdersLoaded({required this.orders});
  @override List<Object?> get props => [orders];
}
class OrdersError extends OrderState {
  final String message;
  const OrdersError({required this.message});
  @override List<Object?> get props => [message];
}

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _repository;
  StreamSubscription? _sub;

  OrderBloc({required OrderRepository repository})
      : _repository = repository,
        super(const OrdersLoading()) {
    on<WatchOrders>(_onWatch);
  }

  Future<void> _onWatch(WatchOrders event, Emitter<OrderState> emit) async {
    emit(const OrdersLoading());
    await _sub?.cancel();
    if (emit.isDone) return;
    _sub = _repository.watchOrders().listen(
      (result) {
        if (emit.isDone) return;
        result.fold(
          (f) => emit(OrdersError(message: f.message)),
          (o) => emit(OrdersLoaded(orders: o)),
        );
      },
      onError: (e) {
        if (emit.isDone) return;
        emit(OrdersError(message: e.toString()));
      },
    );
  }

  @override Future<void> close() { _sub?.cancel(); return super.close(); }
}