import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HrScreen extends StatefulWidget {
  const HrScreen({super.key});

  @override
  State<HrScreen> createState() => _HrScreenState();
}

class _HrScreenState extends State<HrScreen> {
  int _selectedTab = 0;

  final _tabs = ['Employees', 'Attendance', 'Leave', 'Payroll', 'Performance'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('HR Management',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: const Color(0xFF16213E),
                  title: Text('Add Employee', style: GoogleFonts.poppins(color: Colors.white)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(decoration: InputDecoration(labelText: 'Employee Name', labelStyle: GoogleFonts.poppins(color: Colors.white54), filled: true, fillColor: const Color(0xFF0F3460).withValues(alpha: 0.3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)), style: GoogleFonts.poppins(color: Colors.white)),
                      const SizedBox(height: 12),
                      TextField(decoration: InputDecoration(labelText: 'Department', labelStyle: GoogleFonts.poppins(color: Colors.white54), filled: true, fillColor: const Color(0xFF0F3460).withValues(alpha: 0.3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)), style: GoogleFonts.poppins(color: Colors.white)),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white54))),
                    ElevatedButton(onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Employee added'), backgroundColor: Colors.green)); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F3460)), child: Text('Add', style: GoogleFonts.poppins(color: Colors.white))),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting HR data...'), backgroundColor: Colors.blue),
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
                          color: _selectedTab == index
                              ? Colors.white
                              : Colors.white54,
                          fontWeight: _selectedTab == index
                              ? FontWeight.w600
                              : FontWeight.w400,
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
    switch (_selectedTab) {
      case 0:
        return _buildEmployeeList();
      case 1:
        return _buildAttendance();
      case 2:
        return _buildLeave();
      case 3:
        return _buildPayroll();
      case 4:
        return _buildPerformance();
      default:
        return _buildEmployeeList();
    }
  }

  Widget _buildEmployeeList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        final employees = [
          {'name': 'Sarah Johnson', 'role': 'Sales Manager', 'dept': 'Sales', 'status': 'Active'},
          {'name': 'John Mwangi', 'role': 'Accountant', 'dept': 'Finance', 'status': 'Active'},
          {'name': 'Grace Kimani', 'role': 'Logistics Coordinator', 'dept': 'Operations', 'status': 'Active'},
          {'name': 'Peter Ochieng', 'role': 'Warehouse Lead', 'dept': 'Warehouse', 'status': 'On Leave'},
          {'name': 'Mary Wanjiku', 'role': 'Customer Support', 'dept': 'Support', 'status': 'Active'},
          {'name': 'David Kamau', 'role': 'Driver', 'dept': 'Logistics', 'status': 'Active'},
          {'name': 'Jane Akinyi', 'role': 'HR Officer', 'dept': 'HR', 'status': 'Active'},
          {'name': 'Samuel Njoroge', 'role': 'Procurement Officer', 'dept': 'Procurement', 'status': 'Inactive'},
        ];
        final emp = employees[index];
        final isActive = emp['status'] == 'Active';
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF0F3460),
                child: Text(emp['name']![0],
                    style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(emp['name']!,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    Text('${emp['role']} • ${emp['dept']}',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.white54)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isActive ? Colors.green : Colors.orange).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(emp['status']!,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: isActive ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendance() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fingerprint, size: 64, color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('Attendance Tracking',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 24),
          _buildStatRow('Present Today', '6', Colors.green),
          _buildStatRow('On Leave', '1', Colors.orange),
          _buildStatRow('Absent', '1', Colors.red),
        ],
      ),
    );
  }

  Widget _buildLeave() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.beach_access, size: 64, color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('Leave Management',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 8),
          Text('2 pending requests, 1 approved this week',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _buildPayroll() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payroll Summary',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 16),
          _buildStatRow('Monthly Payroll', '\$45,230', Colors.green),
          _buildStatRow('Active Employees', '8', Colors.blue),
          _buildStatRow('Next Pay Date', 'Jul 5, 2026', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildPerformance() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.trending_up, size: 64, color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('Performance Reviews',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 8),
          Text('Q2 2026 reviews in progress',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
            ),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}