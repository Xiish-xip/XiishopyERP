import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AssetsScreen extends StatelessWidget {
  const AssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assets = [
      {'name': 'Toyota Hilux - 2024', 'type': 'Vehicle', 'value': '\$45,000', 'status': 'In Use', 'assigned': 'David Kamau'},
      {'name': 'Warehouse Racking System', 'type': 'Equipment', 'value': '\$12,000', 'status': 'Active', 'assigned': 'Peter Ochieng'},
      {'name': 'HP LaserJet Printer', 'type': 'Office Equipment', 'value': '\$1,200', 'status': 'Active', 'assigned': 'Main Office'},
      {'name': 'Dell Server R740', 'type': 'IT Equipment', 'value': '\$8,500', 'status': 'Active', 'assigned': 'IT Dept'},
      {'name': 'Forklift - Toyota', 'type': 'Equipment', 'value': '\$22,000', 'status': 'Maintenance', 'assigned': 'Warehouse'},
      {'name': 'iPhone 15 (Sales Team)', 'type': 'Mobile Device', 'value': '\$4,500', 'status': 'Assigned', 'assigned': 'Sales Team'},
      {'name': 'Office Building - Dar', 'type': 'Property', 'value': '\$250,000', 'status': 'Owned', 'assigned': 'Company'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Asset Management',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: const Color(0xFF16213E),
                  title: Text('Add Asset', style: GoogleFonts.poppins(color: Colors.white)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(decoration: InputDecoration(labelText: 'Asset Name', labelStyle: GoogleFonts.poppins(color: Colors.white54), filled: true, fillColor: const Color(0xFF0F3460).withValues(alpha: 0.3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)), style: GoogleFonts.poppins(color: Colors.white)),
                      const SizedBox(height: 12),
                      TextField(decoration: InputDecoration(labelText: 'Value', labelStyle: GoogleFonts.poppins(color: Colors.white54), filled: true, fillColor: const Color(0xFF0F3460).withValues(alpha: 0.3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)), style: GoogleFonts.poppins(color: Colors.white)),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white54))),
                    ElevatedButton(onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Asset added'), backgroundColor: Colors.green)); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F3460)), child: Text('Add', style: GoogleFonts.poppins(color: Colors.white))),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR Scanner opened'), backgroundColor: Colors.blue),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildSummaryCard('Total Assets', '7', Icons.inventory, Colors.blue),
                const SizedBox(width: 8),
                _buildSummaryCard('Total Value', '\$343,200', Icons.attach_money, Colors.green),
                const SizedBox(width: 8),
                _buildSummaryCard('In Maintenance', '1', Icons.build, Colors.orange),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: assets.length,
              itemBuilder: (context, index) {
                final a = assets[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F3460),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.inventory_2, color: Colors.white54),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a['name']!,
                                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
                            Text('${a['type']} • ${a['assigned']}',
                                style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(a['value']!,
                              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text(a['status']!,
                              style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
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

  Widget _buildSummaryCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(label,
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}