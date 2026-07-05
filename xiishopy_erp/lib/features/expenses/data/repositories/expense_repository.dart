/// Xiishopy ERP - Expenses Repository
library;

import 'dart:async';
import '../datasources/expense_remote_datasource.dart';
import '../models/expense_model.dart';

class ExpenseRepository {
  final ExpenseRemoteDataSource _remoteDataSource;
  ExpenseRepository({required ExpenseRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  Stream<List<ExpenseModel>> watchExpenses() => _remoteDataSource.watchExpenses();
  Future<void> createExpense(ExpenseModel expense) => _remoteDataSource.createExpense(expense);
  Future<void> updateExpense(ExpenseModel expense) => _remoteDataSource.updateExpense(expense);
  Future<void> approveExpense(String id, String approvedBy) => _remoteDataSource.approveExpense(id, approvedBy);
  Future<void> rejectExpense(String id, String reason) => _remoteDataSource.rejectExpense(id, reason);
  Future<void> deleteExpense(String id) => _remoteDataSource.deleteExpense(id);
}