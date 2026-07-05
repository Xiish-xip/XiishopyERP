/// Xiishopy ERP - Accounting Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chart_of_accounts_model.dart';

class AccountingRemoteDataSource {
  final FirebaseFirestore _firestore;

  AccountingRemoteDataSource({required FirebaseFirestore firestore}) : _firestore = firestore;

  // ── Chart of Accounts ──
  Stream<List<ChartOfAccountsModel>> watchAccounts() {
    return _firestore
        .collection('chart_of_accounts')
        .orderBy('accountCode')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChartOfAccountsModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createAccount(ChartOfAccountsModel account) async {
    final doc = _firestore.collection('chart_of_accounts').doc();
    await doc.set(account.toFirestore());
  }

  Future<void> updateAccount(ChartOfAccountsModel account) async {
    await _firestore.collection('chart_of_accounts').doc(account.id).update(account.toFirestore());
  }

  // ── Journal Entries ──
  Stream<List<JournalEntryModel>> watchJournalEntries() {
    return _firestore
        .collection('journal_entries')
        .orderBy('entryDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => JournalEntryModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createJournalEntry(JournalEntryModel entry) async {
    final doc = _firestore.collection('journal_entries').doc();
    await doc.set(entry.toFirestore());
  }

  Future<void> postJournalEntry(String id, String postedBy) async {
    await _firestore.collection('journal_entries').doc(id).update({
      'status': 'Posted',
      'postedBy': postedBy,
      'postedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> reverseJournalEntry(String id) async {
    await _firestore.collection('journal_entries').doc(id).update({
      'status': 'Reversed',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── General Ledger ──
  Stream<List<GeneralLedgerModel>> watchGeneralLedger() {
    return _firestore
        .collection('general_ledger')
        .orderBy('entryDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GeneralLedgerModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }
}