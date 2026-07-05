import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  int _selectedTab = 0;
  final _tabs = ['Purchase Orders', 'RFQs', 'Receiving', 'Returns'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Purchase Management',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
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
                          color: _selectedTab == index
                              ? const Color(0xFF0F3460)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(_tabs[index],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: _selectedTab == index ? Colors.white : Colors.white54,
                          fontWeight:
                              _selectedTab == index ? FontWeight.w600 : FontWeight.w400,
                        )),
                  ),
                );
              },
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedTab == 0) return _buildPurchaseOrders();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(_tabs[_selectedTab],
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildPurchaseOrders() {
    final pos = [
      {'po': 'PO-2026-001', 'supplier': 'Tanga Cement Co.', 'amount': '\$12,450', 'status': 'Pending', 'date': 'Jun 25'},
      {'po': 'PO-2026-002', 'supplier': 'East African Suppliers', 'amount': '\$8,200', 'status': 'Approved', 'date': 'Jun 24'},
      {'po': 'PO-2026-003', 'supplier': 'Kilimanjaro Foods Ltd', 'amount': '\$5,600', 'status': 'Received', 'date': 'Jun 22'},
      {'po': 'PO-2026-004', 'supplier': 'Dar Es Salaam Logistics', 'amount': '\$3,400', 'status': 'Pending', 'date': 'Jun 20'},
      {'po': 'PO-2026-005', 'supplier': 'Zanzibar Spices Export', 'amount': '\$2,150', 'status': 'Cancelled', 'date': 'Jun 18'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _buildSummaryCard('Total POs', '${pos.length}', Colors.blue),
              const SizedBox(width: 8),
              _buildSummaryCard('Pending', '2', Colors.orange),
              const SizedBox(width: 8),
              _buildSummaryCard('Total Value', '\$31,800', Colors.green),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: pos.length,
              itemBuilder: (context, index) {
                final po = pos[index];
                final statusColor = po['status'] == 'Pending'
                    ? Colors.orange
                    : po['status'] == 'Approved'
                        ? Colors.blue
                        : po['status'] == 'Received'
                            ? Colors.green
                            : Colors.red;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(po['po']!,
                                style: GoogleFonts.jetBrainsMono(
                                    fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 4),
                            Text('${po['supplier']} • ${po['date']}',
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(po['status']!,
                            style: GoogleFonts.poppins(
                                fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 12),
                      Text(po['amount']!,
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
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

  Widget _buildSummaryCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            Text(label,
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}