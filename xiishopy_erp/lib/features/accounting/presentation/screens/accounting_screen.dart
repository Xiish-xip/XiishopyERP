/// Xiishopy ERP - Accounting Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/accounting_bloc.dart';

class AccountingScreen extends StatefulWidget {
  const AccountingScreen({super.key});

  @override
  State<AccountingScreen> createState() => _AccountingScreenState();
}

class _AccountingScreenState extends State<AccountingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<AccountingBloc>().add(SwitchAccountingTab(tabIndex: _tabController.index));
      }
    });
    context.read<AccountingBloc>().add(const WatchAccounts());
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Accounting', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tabController, indicatorColor: const Color(0xFF0F3460),
          labelColor: Colors.white, unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Chart of Accounts'),
            Tab(text: 'Journal Entries'),
            Tab(text: 'General Ledger'),
          ],
        ),
      ),
      body: BlocBuilder<AccountingBloc, AccountingState>(
        builder: (context, state) {
          if (state is AccountingLoading) return const Center(child: CircularProgressIndicator());
          if (state is AccountingErrorState) return Center(child: Text(state.message, style: GoogleFonts.poppins(color: Colors.white70)));
          return TabBarView(
            controller: _tabController,
            children: [
              _buildAccountsTab(state),
              _buildJournalTab(state),
              _buildLedgerTab(state),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F3460),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: const Color(0xFF16213E),
              title: Text('Create Account', style: GoogleFonts.poppins(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(decoration: InputDecoration(labelText: 'Account Name', labelStyle: GoogleFonts.poppins(color: Colors.white54), filled: true, fillColor: const Color(0xFF0F3460).withValues(alpha: 0.3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)), style: GoogleFonts.poppins(color: Colors.white)),
                  const SizedBox(height: 12),
                  TextField(decoration: InputDecoration(labelText: 'Account Code', labelStyle: GoogleFonts.poppins(color: Colors.white54), filled: true, fillColor: const Color(0xFF0F3460).withValues(alpha: 0.3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)), style: GoogleFonts.poppins(color: Colors.white)),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white54))),
                ElevatedButton(onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created'), backgroundColor: Colors.green)); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F3460)), child: Text('Create', style: GoogleFonts.poppins(color: Colors.white))),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAccountsTab(AccountingState state) {
    if (state is! AccountsLoaded) return const SizedBox.shrink();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.accounts.length,
      itemBuilder: (context, index) {
        final a = state.accounts[index];
        final typeColor = a.type == 'Asset' ? Colors.green : a.type == 'Liability' ? Colors.orange : a.type == 'Equity' ? Colors.blue : Colors.purple;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF16213E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
          child: Row(children: [
            Container(width: 4, height: 40, decoration: BoxDecoration(color: typeColor, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${a.accountCode} - ${a.accountName}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
              Text('${a.type}${a.subtype.isNotEmpty ? ' / $a.subtype' : ''}', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
            ])),
            Text('\$${a.balance.toStringAsFixed(2)}', style: GoogleFonts.jetBrainsMono(fontSize: 13, color: Colors.white)),
          ]),
        );
      },
    );
  }

  Widget _buildJournalTab(AccountingState state) {
    if (state is! JournalEntriesLoaded) return const SizedBox.shrink();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.entries.length,
      itemBuilder: (context, index) {
        final e = state.entries[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF16213E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(e.entryNumber, style: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white))),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: e.status == 'Posted' ? Colors.green.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: Text(e.status, style: TextStyle(fontSize: 11, color: e.status == 'Posted' ? Colors.green : Colors.orange))),
            ]),
            const SizedBox(height: 4),
            Text(e.description, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
            const SizedBox(height: 8),
            Row(children: [
              Text('Dr: \$${e.totalDebit.toStringAsFixed(2)}', style: GoogleFonts.jetBrainsMono(fontSize: 12, color: Colors.greenAccent)),
              const SizedBox(width: 16),
              Text('Cr: \$${e.totalCredit.toStringAsFixed(2)}', style: GoogleFonts.jetBrainsMono(fontSize: 12, color: Colors.redAccent)),
            ]),
          ]),
        );
      },
    );
  }

  Widget _buildLedgerTab(AccountingState state) {
    if (state is! GeneralLedgerLoaded) return const SizedBox.shrink();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.ledger.length,
      itemBuilder: (context, index) {
        final l = state.ledger[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: const Color(0xFF16213E), borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            Expanded(flex: 2, child: Text(l.accountCode, style: GoogleFonts.jetBrainsMono(fontSize: 11, color: Colors.white54))),
            Expanded(flex: 3, child: Text(l.entryNumber, style: GoogleFonts.jetBrainsMono(fontSize: 11, color: Colors.white))),
            Expanded(child: Text('\$${l.debit.toStringAsFixed(0)}', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: Colors.greenAccent))),
            Expanded(child: Text('\$${l.credit.toStringAsFixed(0)}', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: Colors.redAccent))),
          ]),
        );
      },
    );
  }
}