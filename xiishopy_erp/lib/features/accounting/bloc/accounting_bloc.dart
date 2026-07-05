/// Xiishopy ERP - Accounting Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/chart_of_accounts_model.dart';
import '../data/repositories/accounting_repository.dart';

// ── Events ──
abstract class AccountingEvent extends Equatable {
  const AccountingEvent();
  @override List<Object?> get props => [];
}
class WatchAccounts extends AccountingEvent { const WatchAccounts(); }
class CreateAccount extends AccountingEvent { final ChartOfAccountsModel account; const CreateAccount({required this.account}); @override List<Object?> get props => [account]; }
class UpdateAccount extends AccountingEvent { final ChartOfAccountsModel account; const UpdateAccount({required this.account}); @override List<Object?> get props => [account]; }
class WatchJournalEntries extends AccountingEvent { const WatchJournalEntries(); }
class CreateJournalEntry extends AccountingEvent { final JournalEntryModel entry; const CreateJournalEntry({required this.entry}); @override List<Object?> get props => [entry]; }
class PostJournalEntry extends AccountingEvent { final String id; final String postedBy; const PostJournalEntry({required this.id, required this.postedBy}); @override List<Object?> get props => [id, postedBy]; }
class ReverseJournalEntry extends AccountingEvent { final String id; const ReverseJournalEntry({required this.id}); @override List<Object?> get props => [id]; }
class WatchGeneralLedger extends AccountingEvent { const WatchGeneralLedger(); }
class SwitchAccountingTab extends AccountingEvent { final int tabIndex; const SwitchAccountingTab({required this.tabIndex}); @override List<Object?> get props => [tabIndex]; }
class AccountingError extends AccountingEvent { final String message; const AccountingError({required this.message}); @override List<Object?> get props => [message]; }

// ── States ──
abstract class AccountingState extends Equatable {
  final int selectedTab;
  const AccountingState({this.selectedTab = 0});
  @override List<Object?> get props => [selectedTab];
}
class AccountingInitial extends AccountingState { const AccountingInitial({super.selectedTab = 0}); }
class AccountingLoading extends AccountingState { const AccountingLoading({super.selectedTab = 0}); }
class AccountsLoaded extends AccountingState {
  final List<ChartOfAccountsModel> accounts;
  const AccountsLoaded({required this.accounts, super.selectedTab = 0});
  @override List<Object?> get props => [accounts, selectedTab];
}
class JournalEntriesLoaded extends AccountingState {
  final List<JournalEntryModel> entries;
  const JournalEntriesLoaded({required this.entries, super.selectedTab = 1});
  @override List<Object?> get props => [entries, selectedTab];
}
class GeneralLedgerLoaded extends AccountingState {
  final List<GeneralLedgerModel> ledger;
  const GeneralLedgerLoaded({required this.ledger, super.selectedTab = 2});
  @override List<Object?> get props => [ledger, selectedTab];
}
class AccountingErrorState extends AccountingState {
  final String message;
  const AccountingErrorState({required this.message, super.selectedTab = 0});
  @override List<Object?> get props => [message, selectedTab];
}

class AccountingBloc extends Bloc<AccountingEvent, AccountingState> {
  final AccountingRepository _repository;
  StreamSubscription? _accountsSub;
  StreamSubscription? _entriesSub;
  StreamSubscription? _ledgerSub;

  AccountingBloc({required AccountingRepository repository})
      : _repository = repository,
        super(const AccountingInitial()) {
    on<WatchAccounts>(_onWatchAccounts);
    on<CreateAccount>(_onCreateAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<WatchJournalEntries>(_onWatchJournalEntries);
    on<CreateJournalEntry>(_onCreateJournalEntry);
    on<PostJournalEntry>(_onPostJournalEntry);
    on<ReverseJournalEntry>(_onReverseJournalEntry);
    on<WatchGeneralLedger>(_onWatchGeneralLedger);
    on<SwitchAccountingTab>(_onSwitchTab);
    on<AccountingError>(_onError);
  }

  void _onWatchAccounts(WatchAccounts event, Emitter<AccountingState> emit) {
    emit(AccountingLoading(selectedTab: state.selectedTab));
    _accountsSub?.cancel();
    _accountsSub = _repository.watchAccounts().listen(
      (accounts) { if (!emit.isDone) emit(AccountsLoaded(accounts: accounts, selectedTab: state.selectedTab)); },
      onError: (e) { if (!emit.isDone) add(AccountingError(message: e.toString())); },
    );
  }

  Future<void> _onCreateAccount(CreateAccount event, Emitter<AccountingState> emit) async {
    try { await _repository.createAccount(event.account); } catch (e) { add(AccountingError(message: 'Failed to create account: $e')); }
  }

  Future<void> _onUpdateAccount(UpdateAccount event, Emitter<AccountingState> emit) async {
    try { await _repository.updateAccount(event.account); } catch (e) { add(AccountingError(message: 'Failed to update account: $e')); }
  }

  void _onWatchJournalEntries(WatchJournalEntries event, Emitter<AccountingState> emit) {
    emit(AccountingLoading(selectedTab: state.selectedTab));
    _entriesSub?.cancel();
    _entriesSub = _repository.watchJournalEntries().listen(
      (entries) { if (!emit.isDone) emit(JournalEntriesLoaded(entries: entries, selectedTab: state.selectedTab)); },
      onError: (e) { if (!emit.isDone) add(AccountingError(message: e.toString())); },
    );
  }

  Future<void> _onCreateJournalEntry(CreateJournalEntry event, Emitter<AccountingState> emit) async {
    try { await _repository.createJournalEntry(event.entry); } catch (e) { add(AccountingError(message: 'Failed to create journal entry: $e')); }
  }

  Future<void> _onPostJournalEntry(PostJournalEntry event, Emitter<AccountingState> emit) async {
    try { await _repository.postJournalEntry(event.id, event.postedBy); } catch (e) { add(AccountingError(message: 'Failed to post entry: $e')); }
  }

  Future<void> _onReverseJournalEntry(ReverseJournalEntry event, Emitter<AccountingState> emit) async {
    try { await _repository.reverseJournalEntry(event.id); } catch (e) { add(AccountingError(message: 'Failed to reverse entry: $e')); }
  }

  void _onWatchGeneralLedger(WatchGeneralLedger event, Emitter<AccountingState> emit) {
    emit(AccountingLoading(selectedTab: state.selectedTab));
    _ledgerSub?.cancel();
    _ledgerSub = _repository.watchGeneralLedger().listen(
      (ledger) { if (!emit.isDone) emit(GeneralLedgerLoaded(ledger: ledger, selectedTab: state.selectedTab)); },
      onError: (e) { if (!emit.isDone) add(AccountingError(message: e.toString())); },
    );
  }

  void _onSwitchTab(SwitchAccountingTab event, Emitter<AccountingState> emit) {
    emit(AccountingLoading(selectedTab: event.tabIndex));
    switch (event.tabIndex) {
      case 0: add(const WatchAccounts()); break;
      case 1: add(const WatchJournalEntries()); break;
      case 2: add(const WatchGeneralLedger()); break;
    }
  }

  void _onError(AccountingError event, Emitter<AccountingState> emit) {
    emit(AccountingErrorState(message: event.message, selectedTab: state.selectedTab));
  }

  @override
  Future<void> close() {
    _accountsSub?.cancel(); _entriesSub?.cancel(); _ledgerSub?.cancel();
    return super.close();
  }
}