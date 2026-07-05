/// Xiishopy ERP - Product Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../domain/repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;
  StreamSubscription? _productSubscription;

  ProductBloc({required ProductRepository repository})
      : _repository = repository,
        super(const ProductInitial()) {
    on<WatchProducts>(_onWatchProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onWatchProducts(WatchProducts event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    await _productSubscription?.cancel();
    if (emit.isDone) return;
    _productSubscription = _repository.watchProducts().listen(
      (result) {
        if (emit.isDone) return;
        result.fold(
          (failure) => add(RefreshProducts()),
          (products) => emit(ProductsLoaded(products: products)),
        );
      },
      onError: (e) {
        if (emit.isDone) return;
        emit(ProductError(message: e.toString()));
      },
    );
  }

  Future<void> _onRefreshProducts(
      RefreshProducts event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    await _productSubscription?.cancel();
    if (emit.isDone) return;
    final result = await _repository.watchProducts().first;
    if (emit.isDone) return;
    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (products) => emit(ProductsLoaded(products: products)),
    );
  }

  @override
  Future<void> close() {
    _productSubscription?.cancel();
    return super.close();
  }
}