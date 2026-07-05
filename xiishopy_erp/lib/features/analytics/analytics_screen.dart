/// Xiishopy ERP - Analytics Screen with fl_chart charts
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../dashboard/bloc/dashboard_bloc.dart';
import '../dashboard/bloc/dashboard_event.dart';
import '../dashboard/bloc/dashboard_state.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const WatchDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Analytics', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardError) {
            return Center(
              child: Text(state.message, style: GoogleFonts.poppins(color: Colors.redAccent)),
            );
          }
          if (state is DashboardLoaded) {
            final d = state.data;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Revenue Analytics',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 16),
                  _buildRevenueChart(d.payments),
                  const SizedBox(height: 24),
                  Text('Top Products by Stock',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 16),
                  _buildProductStockChart(d.products),
                  const SizedBox(height: 24),
                  Text('Order Status Distribution',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 16),
                  _buildOrderStatusChart(d.recentOrders),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16213E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Key Metrics',
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                        const SizedBox(height: 16),
                        _buildMetricRow('Total Orders', d.totalOrders.toString()),
                        _buildMetricRow('Total Revenue', '\$${d.totalRevenue.toStringAsFixed(2)}'),
                        _buildMetricRow('Total Products', d.totalProducts.toString()),
                        _buildMetricRow('Low Stock Items', d.lowStockCount.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildRevenueChart(List payments) {
    final now = DateTime.now();
    final dailyRevenue = <double>[0, 0, 0, 0, 0, 0, 0];
    for (final p in payments) {
      final pDate = p.createdAt;
      final daysDiff = now.difference(pDate).inDays;
      if (daysDiff >= 0 && daysDiff < 7) {
        dailyRevenue[6 - daysDiff] += p.amountUSD;
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Revenue (Last 7 Days)',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: dailyRevenue.reduce((a, b) => a > b ? a : b) * 1.2 + 1,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        final idx = value.toInt();
                        return Text(
                          idx >= 0 && idx < days.length ? days[idx] : '',
                          style: const TextStyle(fontSize: 10, color: Colors.white54),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                              '\$${value.toInt()}',
                              style: const TextStyle(fontSize: 10, color: Colors.white38),
                            )),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
                barGroups: dailyRevenue.asMap().entries.map((e) {
                  return BarChartGroupData(x: e.key, barRods: [
                    BarChartRodData(
                      toY: e.value,
                      color: const Color(0xFF0F3460),
                      width: 16,
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductStockChart(List products) {
    final topProducts = products.take(5).toList();
    final stockValues = topProducts.map((p) => p.stockLevel.toDouble()).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Products by Stock',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (stockValues.isNotEmpty ? stockValues.reduce((a, b) => a > b ? a : b) : 0) + 10,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < topProducts.length) {
                          return Text(
                            topProducts[idx].name.length > 8
                                ? topProducts[idx].name.substring(0, 8)
                                : topProducts[idx].name,
                            style: const TextStyle(fontSize: 9, color: Colors.white54),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10, color: Colors.white38),
                            )),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
                barGroups: stockValues.asMap().entries.map((e) {
                  return BarChartGroupData(x: e.key, barRods: [
                    BarChartRodData(
                      toY: e.value,
                      color: const Color(0xFF0F3460),
                      width: 24,
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusChart(List orders) {
    int completed = 0, pending = 0, processing = 0;
    for (final o in orders) {
      if (o.status == 'completed') completed++;
      else if (o.status == 'pending') pending++;
      else processing++;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Status Distribution',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(value: completed.toDouble(), color: Colors.green,
                          title: '$completed', radius: 30, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
                        PieChartSectionData(value: pending.toDouble(), color: Colors.orange,
                          title: '$pending', radius: 30, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
                        PieChartSectionData(value: processing.toDouble(), color: Colors.blue,
                          title: '$processing', radius: 30, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 20,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendDot(Colors.green, 'Completed'),
                    const SizedBox(height: 8),
                    _buildLegendDot(Colors.orange, 'Pending'),
                    const SizedBox(height: 8),
                    _buildLegendDot(Colors.blue, 'Processing'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
        ],
      ),
    );
  }
}