import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  int _selectedTab = 0;
  final _tabs = ['Active', 'Completed', 'On Hold', 'Planning'];

  @override
  Widget build(BuildContext context) {
    final projects = [
      {'name': 'Warehouse Expansion', 'lead': 'Peter Ochieng', 'deadline': 'Aug 15, 2026', 'progress': '65%', 'status': 'Active'},
      {'name': 'Mobile App v2.0', 'lead': 'IT Team', 'deadline': 'Sep 1, 2026', 'progress': '30%', 'status': 'Active'},
      {'name': 'Supplier Portal', 'lead': 'Jane Akinyi', 'deadline': 'Jul 30, 2026', 'progress': '80%', 'status': 'Active'},
      {'name': 'Inventory Audit Q3', 'lead': 'John Mwangi', 'deadline': 'Jul 15, 2026', 'progress': '45%', 'status': 'Active'},
      {'name': 'New Branch Setup - Mwanza', 'lead': 'Sarah Johnson', 'deadline': 'Oct 1, 2026', 'progress': '10%', 'status': 'Planning'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Project Tracking',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: const Color(0xFF16213E),
                  title: Text('Create Project', style: GoogleFonts.poppins(color: Colors.white)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(decoration: InputDecoration(labelText: 'Project Name', labelStyle: GoogleFonts.poppins(color: Colors.white54), filled: true, fillColor: const Color(0xFF0F3460).withValues(alpha: 0.3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)), style: GoogleFonts.poppins(color: Colors.white)),
                      const SizedBox(height: 12),
                      TextField(decoration: InputDecoration(labelText: 'Lead', labelStyle: GoogleFonts.poppins(color: Colors.white54), filled: true, fillColor: const Color(0xFF0F3460).withValues(alpha: 0.3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)), style: GoogleFonts.poppins(color: Colors.white)),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white54))),
                    ElevatedButton(onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Project created'), backgroundColor: Colors.green)); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F3460)), child: Text('Create', style: GoogleFonts.poppins(color: Colors.white))),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime(2030),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 48,
            color: const Color(0xFF16213E),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tabs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedTab = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _selectedTab == index ? const Color(0xFF0F3460) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(_tabs[index],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: _selectedTab == index ? Colors.white : Colors.white54,
                          fontWeight: _selectedTab == index ? FontWeight.w600 : FontWeight.w400,
                        )),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final p = projects[index];
                final progress = int.tryParse(p['progress']!.replaceAll('%', '')) ?? 0;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(p['name']!,
                                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F3460).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(p['status']!,
                                style: GoogleFonts.poppins(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.person, size: 14, color: Colors.white38),
                          const SizedBox(width: 4),
                          Text(p['lead']!,
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                          const Spacer(),
                          Icon(Icons.calendar_today, size: 14, color: Colors.white38),
                          const SizedBox(width: 4),
                          Text(p['deadline']!,
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress / 100,
                                backgroundColor: Colors.white.withValues(alpha: 0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  progress > 60 ? Colors.green : progress > 30 ? Colors.orange : Colors.red,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(p['progress']!,
                              style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}