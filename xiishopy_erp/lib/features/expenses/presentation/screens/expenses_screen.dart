import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final _categories = ['All', 'Travel', 'Office', 'Utilities', 'Maintenance', 'Salaries', 'Marketing'];
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Expense Tracking',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: const Color(0xFF16213E),
                  title: Text('Add Expense', style: GoogleFonts.poppins(color: Colors.white)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDialogField('Description'),
                      const SizedBox(height: 12),
                      _buildDialogField('Amount'),
                      const SizedBox(height: 12),
                      _buildDialogField('Category'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white54)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Expense submitted'), backgroundColor: Colors.green),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F3460)),
                      child: Text('Submit', style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: const Color(0xFF16213E),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (ctx) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Filter Expenses', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _categories.map((c) => ActionChip(
                          label: Text(c, style: GoogleFonts.poppins(color: Colors.white)),
                          backgroundColor: const Color(0xFF0F3460),
                          onPressed: () {
                            setState(() => _selectedCategory = _categories.indexOf(c));
                            Navigator.pop(ctx);
                          },
                        )).toList(),
                      ),
                    ],
                  ),
                ),
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
                _buildMetricCard('This Month', '\$12,450', Colors.blue, Icons.account_balance_wallet),
                const SizedBox(width: 12),
                _buildMetricCard('Budget', '\$50,000', Colors.green, Icons.pie_chart),
                const SizedBox(width: 12),
                _buildMetricCard('Remaining', '\$37,550', Colors.orange, Icons.trending_up),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final selected = _selectedCategory == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF0F3460) : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_categories[index],
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: selected ? Colors.white : Colors.white54,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: _buildExpenseList()),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color, IconData icon) {
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
            const SizedBox(height: 8),
            Text(value,
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(label,
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF0F3460).withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: GoogleFonts.poppins(color: Colors.white),
    );
  }

  Widget _buildExpenseList() {
    final expenses = [
      {'desc': 'Office Rent - June', 'cat': 'Office', 'amount': '\$3,500', 'date': 'Jun 1', 'status': 'Paid'},
      {'desc': 'Electricity Bill', 'cat': 'Utilities', 'amount': '\$850', 'date': 'Jun 5', 'status': 'Paid'},
      {'desc': 'Staff Salaries', 'cat': 'Salaries', 'amount': '\$5,200', 'date': 'Jun 28', 'status': 'Pending'},
      {'desc': 'Marketing Campaign', 'cat': 'Marketing', 'amount': '\$1,200', 'date': 'Jun 15', 'status': 'Approved'},
      {'desc': 'Travel - Client Visit', 'cat': 'Travel', 'amount': '\$600', 'date': 'Jun 12', 'status': 'Paid'},
      {'desc': 'Office Supplies', 'cat': 'Office', 'amount': '\$350', 'date': 'Jun 8', 'status': 'Paid'},
      {'desc': 'Equipment Maintenance', 'cat': 'Maintenance', 'amount': '\$750', 'date': 'Jun 20', 'status': 'Pending'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final e = expenses[index];
        final statusColor = e['status'] == 'Paid'
            ? Colors.green
            : e['status'] == 'Pending'
                ? Colors.orange
                : Colors.blue;
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
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('\$${(e['amount'] as String).replaceAll('\$', '')[0]}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white54)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e['desc']!,
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
                    Text('${e['cat']} • ${e['date']}',
                        style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(e['amount']!,
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(e['status']!,
                        style: GoogleFonts.poppins(fontSize: 10, color: statusColor, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}