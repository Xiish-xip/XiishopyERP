/// Xiishopy ERP - CRM Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/routes.dart';
import '../../../../core/di/service_locator.dart';
import '../../bloc/crm_bloc.dart';
import '../../data/models/lead_model.dart';

class CrmScreen extends StatefulWidget {
  const CrmScreen({super.key});

  @override
  State<CrmScreen> createState() => _CrmScreenState();
}

class _CrmScreenState extends State<CrmScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<CrmBloc>().add(SwitchCrmTab(tabIndex: _tabController.index));
      }
    });
    context.read<CrmBloc>().add(const WatchLeads());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('CRM', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF0F3460),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Leads'), Tab(text: 'Opportunities'), Tab(text: 'Campaigns'),
          ],
        ),
      ),
      body: BlocBuilder<CrmBloc, CrmState>(
        builder: (context, state) {
          if (state is CrmLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CrmErrorState) {
            return Center(child: Text(state.message, style: GoogleFonts.poppins(color: Colors.white70)));
          }
          return TabBarView(
            controller: _tabController,
            children: [
              _buildLeadsTab(state),
              _buildOpportunitiesTab(state),
              _buildCampaignsTab(state),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F3460),
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLeadsTab(CrmState state) {
    if (state is! CrmLeadsLoaded) return const SizedBox.shrink();
    final leads = state.leads;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: leads.length,
      itemBuilder: (context, index) {
        final lead = leads[index];
        final statusColor = lead.status == 'New' ? Colors.blue :
            lead.status == 'Contacted' ? Colors.orange :
            lead.status == 'Qualified' ? Colors.green :
            lead.status == 'Lost' ? Colors.red : Colors.grey;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(child: Text(lead.contactName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white))),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text(lead.status, style: TextStyle(fontSize: 11, color: statusColor))),
              ]),
              const SizedBox(height: 4),
              Text(lead.companyName, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54)),
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.email, size: 14, color: Colors.white38),
                const SizedBox(width: 4),
                Text(lead.email, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                const Spacer(),
                Text('\$${lead.estimatedValue.toStringAsFixed(0)}', style: GoogleFonts.jetBrainsMono(fontSize: 13, color: Colors.white)),
              ]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOpportunitiesTab(CrmState state) {
    if (state is! CrmOpportunitiesLoaded) return const SizedBox.shrink();
    final opportunities = state.opportunities;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: opportunities.length,
      itemBuilder: (context, index) {
        final opp = opportunities[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(child: Text(opp.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white))),
                Text('\$${opp.amount.toStringAsFixed(0)}', style: GoogleFonts.jetBrainsMono(fontSize: 14, color: Colors.greenAccent)),
              ]),
              const SizedBox(height: 4),
              Text('${opp.stage} | ${opp.probability.toStringAsFixed(0)}%', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: opp.probability / 100, backgroundColor: Colors.white12, color: Colors.blue),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCampaignsTab(CrmState state) {
    if (state is! CrmCampaignsLoaded) return const SizedBox.shrink();
    final campaigns = state.campaigns;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: campaigns.length,
      itemBuilder: (context, index) {
        final c = campaigns[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(child: Text(c.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white))),
                Text(c.status, style: GoogleFonts.poppins(fontSize: 12, color: c.status == 'Active' ? Colors.green : Colors.white54)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Text('Leads: ${c.leadsGenerated}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                const SizedBox(width: 16),
                Text('Conv: ${c.conversions}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                const Spacer(),
                Text('\$${c.budget.toStringAsFixed(0)}', style: GoogleFonts.jetBrainsMono(fontSize: 12, color: Colors.white)),
              ]),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: c.budget > 0 ? (c.spent / c.budget).clamp(0.0, 1.0) : 0,
                  backgroundColor: Colors.white12,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Create New', style: GoogleFonts.poppins(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.white54),
              title: Text('New Lead', style: GoogleFonts.poppins(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                final now = DateTime.now();
                context.read<CrmBloc>().add(CreateLead(
                  lead: LeadModel(
                    id: '',
                    companyName: 'New Company',
                    contactName: 'New Lead',
                    email: 'lead@example.com',
                    phone: '',
                    source: 'Manual',
                    status: 'New',
                    estimatedValue: 0.0,
                    createdAt: now,
                    updatedAt: now,
                  ),
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lead created'), backgroundColor: Colors.green),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.trending_up, color: Colors.white54),
              title: Text('New Opportunity', style: GoogleFonts.poppins(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opportunity creation started'), backgroundColor: Colors.blue),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}