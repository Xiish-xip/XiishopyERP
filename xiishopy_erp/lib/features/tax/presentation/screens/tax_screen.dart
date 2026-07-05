/// Xiishopy ERP - Tax Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/tax_bloc.dart';

class TaxScreen extends StatefulWidget {
  const TaxScreen({super.key});

  @override
  State<TaxScreen> createState() => _TaxScreenState();
}

class _TaxScreenState extends State<TaxScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<TaxBloc>().add(SwitchTaxTab(tabIndex: _tabController.index));
      }
    });
    context.read<TaxBloc>().add(const WatchTaxConfigs());
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Tax Engine', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tabController, indicatorColor: const Color(0xFF0F3460),
          labelColor: Colors.white, unselectedLabelColor: Colors.white54,
          tabs: const [Tab(text: 'Tax Configs'), Tab(text: 'Tax Rates')],
        ),
      ),
      body: BlocBuilder<TaxBloc, TaxState>(
        builder: (context, state) {
          if (state is TaxLoading) return const Center(child: CircularProgressIndicator());
          if (state is TaxErrorState) return Center(child: Text(state.message, style: GoogleFonts.poppins(color: Colors.white70)));
          return TabBarView(
            controller: _tabController,
            children: [_buildConfigsTab(state), _buildRatesTab(state)],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F3460),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildConfigsTab(TaxState state) {
    if (state is! TaxConfigsLoaded) return const SizedBox.shrink();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.configs.length,
      itemBuilder: (context, index) {
        final c = state.configs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF16213E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
              Text('${c.region} - ${c.taxType}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
            ])),
            Text('${c.rate.toStringAsFixed(1)}%', style: GoogleFonts.jetBrainsMono(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
          ]),
        );
      },
    );
  }

  Widget _buildRatesTab(TaxState state) {
    if (state is! TaxRatesLoaded) return const SizedBox.shrink();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.rates.length,
      itemBuilder: (context, index) {
        final r = state.rates[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF16213E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
              Text('Min: \$${r.minAmount.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
            ])),
            Text('${r.rate.toStringAsFixed(1)}%', style: GoogleFonts.jetBrainsMono(fontSize: 14, color: Colors.orangeAccent)),
          ]),
        );
      },
    );
  }
}