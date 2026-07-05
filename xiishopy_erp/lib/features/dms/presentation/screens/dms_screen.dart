/// Xiishopy ERP - DMS Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/dms_bloc.dart';

class DmsScreen extends StatefulWidget {
  const DmsScreen({super.key});

  @override
  State<DmsScreen> createState() => _DmsScreenState();
}

class _DmsScreenState extends State<DmsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<DmsBloc>().add(SwitchDmsTab(tabIndex: _tabController.index));
      }
    });
    context.read<DmsBloc>().add(const WatchDocuments());
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Documents', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tabController, indicatorColor: const Color(0xFF0F3460),
          labelColor: Colors.white, unselectedLabelColor: Colors.white54,
          tabs: const [Tab(text: 'Documents'), Tab(text: 'Templates')],
        ),
      ),
      body: BlocBuilder<DmsBloc, DmsState>(
        builder: (context, state) {
          if (state is DmsLoading) return const Center(child: CircularProgressIndicator());
          if (state is DmsErrorState) return Center(child: Text(state.message, style: GoogleFonts.poppins(color: Colors.white70)));
          return TabBarView(
            controller: _tabController,
            children: [_buildDocumentsTab(state), _buildTemplatesTab(state)],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F3460),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Document upload dialog opened'), backgroundColor: Colors.blue),
          );
        },
        child: const Icon(Icons.upload_file),
      ),
    );
  }

  Widget _buildDocumentsTab(DmsState state) {
    if (state is! DocumentsLoaded) return const SizedBox.shrink();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.documents.length,
      itemBuilder: (context, index) {
        final d = state.documents[index];
        final icon = d.fileType == 'pdf' ? Icons.picture_as_pdf :
            d.fileType == 'image' ? Icons.image : Icons.insert_drive_file;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF16213E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
          child: Row(children: [
            Icon(icon, color: d.fileType == 'pdf' ? Colors.redAccent : Colors.blueAccent, size: 32),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(d.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
              Text('${d.category} | ${(d.fileSize / 1024).toStringAsFixed(0)} KB', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: d.status == 'Active' ? Colors.green.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8)),
              child: Text(d.status, style: TextStyle(fontSize: 11, color: d.status == 'Active' ? Colors.green : Colors.grey))),
          ]),
        );
      },
    );
  }

  Widget _buildTemplatesTab(DmsState state) {
    if (state is! TemplatesLoaded) return const SizedBox.shrink();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.templates.length,
      itemBuilder: (context, index) {
        final t = state.templates[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF16213E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
          child: Row(children: [
            const Icon(Icons.description, color: Colors.white54, size: 28),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
              Text(t.category, style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
            ])),
            Icon(Icons.check_circle, size: 18, color: t.isActive ? Colors.green : Colors.grey),
          ]),
        );
      },
    );
  }
}