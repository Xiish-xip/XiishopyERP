/// Xiishopy ERP - Expense Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/expense_model.dart';
import '../data/repositories/expense_repository.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository _repository;
  StreamSubscription? _sub;

  ExpenseBloc({required ExpenseRepository repository})
      : _repository = repository,
        super(const ExpensesLoading()) {
    on<WatchExpenses>(_onWatch);
    on<CreateExpense>(_onCreate);
    on<ApproveExpense>(_onApprove);
    on<RejectExpense>(_onReject);
    on<DeleteExpense>(_onDelete);
  }

  void _onWatch(WatchExpenses event, Emitter<ExpenseState> emit) {
    emit(const ExpensesLoading());
    _sub?.cancel();
    _sub = _repository.watchExpenses().listen(
      (list) => emit(ExpensesLoaded(expenses: list)),
      onError: (e) => emit(ExpensesError(message: e.toString())),
    );
  }

  Future<void> _onCreate(CreateExpense event, Emitter<ExpenseState> emit) async {
    try { await _repository.createExpense(event.expense); }
    catch (e) { emit(ExpensesError(message: e.toString())); }
  }

  Future<void> _onApprove(ApproveExpense event, Emitter<ExpenseState> emit) async {
    try { await _repository.approveExpense(event.id, event.approvedBy); }
    catch (e) { emit(ExpensesError(message: e.toString())); }
  }

  Future<void> _onReject(RejectExpense event, Emitter<ExpenseState> emit) async {
    try { await _repository.rejectExpense(event.id, event.reason); }
    catch (e) { emit(ExpensesError(message: e.toString())); }
  }

  Future<void> _onDelete(DeleteExpense event, Emitter<ExpenseState> emit) async {
    try { await _repository.deleteExpense(event.id); }
    catch (e) { emit(ExpensesError(message: e.toString())); }
  }

  @override Future<void> close() { _sub?.cancel(); return super.close(); }
}

// Events
abstract class ExpenseEvent extends Equatable { const ExpenseEvent(); @override List<Object?> get props => []; }
class WatchExpenses extends ExpenseEvent { const WatchExpenses(); }
class CreateExpense extends ExpenseEvent { final ExpenseModel expense; const CreateExpense({required this.expense}); @override List<Object?> get props => [expense]; }
class ApproveExpense extends ExpenseEvent { final String id; final String approvedBy; const ApproveExpense({required this.id, required this.approvedBy}); @override List<Object?> get props => [id, approvedBy]; }
class RejectExpense extends ExpenseEvent { final String id; final String reason; const RejectExpense({required this.id, required this.reason}); @override List<Object?> get props => [id, reason]; }
class DeleteExpense extends ExpenseEvent { final String id; const DeleteExpense({required this.id}); @override List<Object?> get props => [id]; }

// States
abstract class ExpenseState extends Equatable { const ExpenseState(); @override List<Object?> get props => []; }
class ExpensesLoading extends ExpenseState { const ExpensesLoading(); }
class ExpensesLoaded extends ExpenseState { final List<ExpenseModel> expenses; const ExpensesLoaded({required this.expenses}); @override List<Object?> get props => [expenses]; }
class ExpensesError extends ExpenseState { final String message; const ExpensesError({required this.message}); @override List<Object?> get props => [message]; }