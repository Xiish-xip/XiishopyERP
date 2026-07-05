/// Xiishopy ERP - Manufacturing Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/manufacturing_bloc.dart';

class ManufacturingScreen extends StatefulWidget {
  const ManufacturingScreen({super.key});

  @override
  State<ManufacturingScreen> createState() => _ManufacturingScreenState();
}

class _ManufacturingScreenState extends State<ManufacturingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<ManufacturingBloc>().add(SwitchMfgTab(tabIndex: _tabController.index));
      }
    });
    context.read<ManufacturingBloc>().add(const WatchBoms());
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Manufacturing', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tabController, indicatorColor: const Color(0xFF0F3460),
          labelColor: Colors.white, unselectedLabelColor: Colors.white54,
          tabs: const [Tab(text: 'BOM'), Tab(text: 'Work Orders'), Tab(text: 'Production Plans')],
        ),
      ),
      body: BlocBuilder<ManufacturingBloc, ManufacturingState>(
        builder: (context, state) {
          if (state is ManufacturingLoading) return const Center(child: CircularProgressIndicator());
          if (state is ManufacturingErrorState) return Center(child: Text(state.message, style: GoogleFonts.poppins(color: Colors.white70)));
          return TabBarView(
            controller: _tabController,
            children: [_buildBomsTab(state), _buildWorkOrdersTab(state), _buildPlansTab(state)],
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

  Widget _buildBomsTab(ManufacturingState state) {
    if (state is! BomsLoaded) return const SizedBox.shrink();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.boms.length,
      itemBuilder: (context, index) {
        final b = state.boms[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF16213E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(b.productName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white))),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: b.status == 'Active' ? Colors.green.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: Text(b.status, style: TextStyle(fontSize: 11, color: b.status == 'Active' ? Colors.green : Colors.orange))),
            ]),
            const SizedBox(height: 4),
            Text('v${b.version} | ${b.components.length} components', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
            const SizedBox(height: 4),
            Text('Total Cost: \$${b.totalCost.toStringAsFixed(2)}', style: GoogleFonts.jetBrainsMono(fontSize: 12, color: Colors.greenAccent)),
          ]),
        );
      },
    );
  }

  Widget _buildWorkOrdersTab(ManufacturingState state) {
    if (state is! WorkOrdersLoaded) return const SizedBox.shrink();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.orders.length,
      itemBuilder: (context, index) {
        final o = state.orders[index];
        final statusColor = o.status == 'Completed' ? Colors.green : o.status == 'In Progress' ? Colors.blue : o.status == 'Cancelled' ? Colors.red : Colors.orange;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF16213E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(o.orderNumber, style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w600, color: Colors.white))),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: Text(o.status, style: TextStyle(fontSize: 11, color: statusColor))),
            ]),
            const SizedBox(height: 4),
            Text('${o.productName} x${o.quantity.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: o.quantity > 0 ? (o.producedQuantity / o.quantity).clamp(0.0, 1.0) : 0,
              backgroundColor: Colors.white12, color: Colors.blue,
            ),
          ]),
        );
      },
    );
  }

  Widget _buildPlansTab(ManufacturingState state) {
    if (state is! ProductionPlansLoaded) return const SizedBox.shrink();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.plans.length,
      itemBuilder: (context, index) {
        final p = state.plans[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF16213E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(p.planNumber, style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w600, color: Colors.white))),
              Text(p.period, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
            ]),
            const SizedBox(height: 4),
            Text('${p.productName}: ${p.plannedQuantity.toStringAsFixed(0)} units', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
          ]),
        );
      },
    );
  }
}