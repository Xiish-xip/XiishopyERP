/// Xiishopy ERP - Accounting Repository
library;

import '../datasources/accounting_remote_datasource.dart';
import '../models/chart_of_accounts_model.dart';

class AccountingRepository {
  final AccountingRemoteDataSource _remoteDataSource;
  AccountingRepository({required AccountingRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  Stream<List<ChartOfAccountsModel>> watchAccounts() => _remoteDataSource.watchAccounts();
  Future<void> createAccount(ChartOfAccountsModel account) => _remoteDataSource.createAccount(account);
  Future<void> updateAccount(ChartOfAccountsModel account) => _remoteDataSource.updateAccount(account);

  Stream<List<JournalEntryModel>> watchJournalEntries() => _remoteDataSource.watchJournalEntries();
  Future<void> createJournalEntry(JournalEntryModel entry) => _remoteDataSource.createJournalEntry(entry);
  Future<void> postJournalEntry(String id, String postedBy) => _remoteDataSource.postJournalEntry(id, postedBy);
  Future<void> reverseJournalEntry(String id) => _remoteDataSource.reverseJournalEntry(id);

  Stream<List<GeneralLedgerModel>> watchGeneralLedger() => _remoteDataSource.watchGeneralLedger();
}