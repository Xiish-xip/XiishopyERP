/// Xiishopy ERP - Expenses Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense_model.dart';

class ExpenseRemoteDataSource {
  final FirebaseFirestore _firestore;
  ExpenseRemoteDataSource({required FirebaseFirestore firestore}) : _firestore = firestore;

  Stream<List<ExpenseModel>> watchExpenses() {
    return _firestore.collection('expenses').orderBy('createdAt', descending: true).snapshots()
        .map((s) => s.docs.map((d) => ExpenseModel.fromFirestore(d.data() as Map<String, dynamic>, d.id)).toList());
  }

  Future<void> createExpense(ExpenseModel expense) async {
    final doc = _firestore.collection('expenses').doc();
    await doc.set(expense.toFirestore());
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await _firestore.collection('expenses').doc(expense.id).update(expense.toFirestore());
  }

  Future<void> approveExpense(String id, String approvedBy) async {
    await _firestore.collection('expenses').doc(id).update({
      'status': 'Approved', 'approvedBy': approvedBy, 'approvedAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> rejectExpense(String id, String reason) async {
    await _firestore.collection('expenses').doc(id).update({
      'status': 'Rejected', 'rejectionReason': reason, 'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteExpense(String id) async {
    await _firestore.collection('expenses').doc(id).update({'status': 'Cancelled', 'updatedAt': FieldValue.serverTimestamp()});
  }
}