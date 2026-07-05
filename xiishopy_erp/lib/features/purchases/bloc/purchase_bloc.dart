/// Xiishopy ERP - Purchase Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/purchase_model.dart';
import '../data/repositories/purchase_repository.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchaseRepository _repository;
  StreamSubscription? _sub;

  PurchaseBloc({required PurchaseRepository repository})
      : _repository = repository,
        super(const PurchasesLoading()) {
    on<WatchPurchases>(_onWatch);
    on<CreatePurchase>(_onCreate);
    on<ApprovePurchase>(_onApprove);
    on<ReceivePurchase>(_onReceive);
    on<DeletePurchase>(_onDelete);
  }

  void _onWatch(WatchPurchases event, Emitter<PurchaseState> emit) {
    emit(const PurchasesLoading());
    _sub?.cancel();
    _sub = _repository.watchPurchases().listen(
      (list) => emit(PurchasesLoaded(purchases: list)),
      onError: (e) => emit(PurchasesError(message: e.toString())),
    );
  }

  Future<void> _onCreate(CreatePurchase event, Emitter<PurchaseState> emit) async {
    try { await _repository.createPurchase(event.purchase); }
    catch (e) { emit(PurchasesError(message: e.toString())); }
  }

  Future<void> _onApprove(ApprovePurchase event, Emitter<PurchaseState> emit) async {
    try { await _repository.approvePurchase(event.id, event.approvedBy); }
    catch (e) { emit(PurchasesError(message: e.toString())); }
  }

  Future<void> _onReceive(ReceivePurchase event, Emitter<PurchaseState> emit) async {
    try { await _repository.receivePurchase(event.id); }
    catch (e) { emit(PurchasesError(message: e.toString())); }
  }

  Future<void> _onDelete(DeletePurchase event, Emitter<PurchaseState> emit) async {
    try { await _repository.deletePurchase(event.id); }
    catch (e) { emit(PurchasesError(message: e.toString())); }
  }

  @override Future<void> close() { _sub?.cancel(); return super.close(); }
}

// Events
abstract class PurchaseEvent extends Equatable { const PurchaseEvent(); @override List<Object?> get props => []; }
class WatchPurchases extends PurchaseEvent { const WatchPurchases(); }
class CreatePurchase extends PurchaseEvent { final PurchaseModel purchase; const CreatePurchase({required this.purchase}); @override List<Object?> get props => [purchase]; }
class ApprovePurchase extends PurchaseEvent { final String id; final String approvedBy; const ApprovePurchase({required this.id, required this.approvedBy}); @override List<Object?> get props => [id, approvedBy]; }
class ReceivePurchase extends PurchaseEvent { final String id; const ReceivePurchase({required this.id}); @override List<Object?> get props => [id]; }
class DeletePurchase extends PurchaseEvent { final String id; const DeletePurchase({required this.id}); @override List<Object?> get props => [id]; }

// States
abstract class PurchaseState extends Equatable { const PurchaseState(); @override List<Object?> get props => []; }
class PurchasesLoading extends PurchaseState { const PurchasesLoading(); }
class PurchasesLoaded extends PurchaseState { final List<PurchaseModel> purchases; const PurchasesLoaded({required this.purchases}); @override List<Object?> get props => [purchases]; }
class PurchasesError extends PurchaseState { final String message; const PurchasesError({required this.message}); @override List<Object?> get props => [message]; }