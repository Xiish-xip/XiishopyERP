/// Xiishopy ERP - Supplier Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/supplier_model.dart';
import '../data/repositories/supplier_repository.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final SupplierRepository _repository;
  StreamSubscription? _sub;

  SupplierBloc({required SupplierRepository repository})
      : _repository = repository,
        super(const SuppliersLoading()) {
    on<WatchSuppliers>(_onWatch);
    on<CreateSupplier>(_onCreate);
    on<UpdateSupplier>(_onUpdate);
    on<DeleteSupplier>(_onDelete);
  }

  void _onWatch(WatchSuppliers event, Emitter<SupplierState> emit) {
    emit(const SuppliersLoading());
    _sub?.cancel();
    _sub = _repository.watchSuppliers().listen(
      (list) => emit(SuppliersLoaded(suppliers: list)),
      onError: (e) => emit(SuppliersError(message: e.toString())),
    );
  }

  Future<void> _onCreate(CreateSupplier event, Emitter<SupplierState> emit) async {
    try { await _repository.createSupplier(event.supplier); }
    catch (e) { emit(SuppliersError(message: e.toString())); }
  }

  Future<void> _onUpdate(UpdateSupplier event, Emitter<SupplierState> emit) async {
    try { await _repository.updateSupplier(event.supplier); }
    catch (e) { emit(SuppliersError(message: e.toString())); }
  }

  Future<void> _onDelete(DeleteSupplier event, Emitter<SupplierState> emit) async {
    try { await _repository.deleteSupplier(event.id); }
    catch (e) { emit(SuppliersError(message: e.toString())); }
  }

  @override Future<void> close() { _sub?.cancel(); return super.close(); }
}

// Events
abstract class SupplierEvent extends Equatable {
  const SupplierEvent();
  @override List<Object?> get props => [];
}
class WatchSuppliers extends SupplierEvent { const WatchSuppliers(); }
class CreateSupplier extends SupplierEvent { final SupplierModel supplier; const CreateSupplier({required this.supplier}); @override List<Object?> get props => [supplier]; }
class UpdateSupplier extends SupplierEvent { final SupplierModel supplier; const UpdateSupplier({required this.supplier}); @override List<Object?> get props => [supplier]; }
class DeleteSupplier extends SupplierEvent { final String id; const DeleteSupplier({required this.id}); @override List<Object?> get props => [id]; }

// States
abstract class SupplierState extends Equatable {
  const SupplierState();
  @override List<Object?> get props => [];
}
class SuppliersLoading extends SupplierState { const SuppliersLoading(); }
class SuppliersLoaded extends SupplierState { final List<SupplierModel> suppliers; const SuppliersLoaded({required this.suppliers}); @override List<Object?> get props => [suppliers]; }
class SuppliersError extends SupplierState { final String message; const SuppliersError({required this.message}); @override List<Object?> get props => [message]; }