import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final suppliers = [
      {'name': 'Tanga Cement Co.', 'contact': '+255 712 111 222', 'category': 'Building Materials', 'rating': '4.5'},
      {'name': 'East African Suppliers', 'contact': '+255 713 333 444', 'category': 'General Goods', 'rating': '4.2'},
      {'name': 'Dar Es Salaam Logistics', 'contact': '+255 714 555 666', 'category': 'Logistics', 'rating': '3.8'},
      {'name': 'Kilimanjaro Foods Ltd', 'contact': '+255 715 777 888', 'category': 'Food & Beverage', 'rating': '4.7'},
      {'name': 'Zanzibar Spices Export', 'contact': '+255 716 999 000', 'category': 'Agricultural', 'rating': '4.0'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Supplier Management',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: suppliers.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  _buildMetricChip('Total', '${suppliers.length}', Colors.blue),
                  const SizedBox(width: 12),
                  _buildMetricChip('Active', '4', Colors.green),
                  const SizedBox(width: 12),
                  _buildMetricChip('Avg Rating', '4.2', Colors.orange),
                ],
              ),
            );
          }
          final s = suppliers[index - 1];
          final rating = double.tryParse(s['rating']!) ?? 0;
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
                  child: const Icon(Icons.business, color: Colors.white54),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s['name']!,
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                      Text('${s['contact']} • ${s['category']}',
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(s['rating']!,
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w600, color: Colors.amber)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}