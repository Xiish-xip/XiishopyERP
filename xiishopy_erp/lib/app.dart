/// Xiishopy ERP - Material Application Entry
/// Theming, routing, and responsive layout configuration.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'core/config/theme.dart';
import 'core/config/routes.dart';
import 'core/di/service_locator.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/dashboard/bloc/dashboard_bloc.dart';
import 'features/dashboard/bloc/dashboard_event.dart';
import 'features/dashboard/bloc/dashboard_state.dart';
import 'features/orders/bloc/order_bloc.dart';
import 'features/products/bloc/product_bloc.dart';
import 'features/payments/bloc/payment_bloc.dart';
import 'features/logistics/bloc/logistics_bloc.dart';
import 'features/customers/bloc/customer_bloc.dart';
import 'features/admin/bloc/admin_bloc.dart';

import 'shared/widgets/stat_card.dart';

class XiishopyERPApp extends StatelessWidget {
  const XiishopyERPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>()..add(const CheckAuthState()),
        ),
        BlocProvider<DashboardBloc>(
          create: (context) => sl<DashboardBloc>(),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => sl<OrderBloc>(),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => sl<ProductBloc>(),
        ),
        BlocProvider<PaymentBloc>(
          create: (context) => sl<PaymentBloc>(),
        ),
        BlocProvider<LogisticsBloc>(
          create: (context) => sl<LogisticsBloc>(),
        ),
        BlocProvider<CustomerBloc>(
          create: (context) => sl<CustomerBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Xiishopy ERP',
        debugShowCheckedModeBanner: false,
        theme: XiishopyTheme.lightTheme,
        darkTheme: XiishopyTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}

/// Splash screen that checks auth state and routes to appropriate dashboard
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.read<AuthBloc>().add(const CheckAuthState());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          appRouter.go(AppRoutes.dashboard);
        } else if (state is Unauthenticated) {
          appRouter.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.inventory_2_rounded,
                  size: 80,
                  color: Color(0xFF0F3460),
                ),
              ),
              const SizedBox(height: 24),
              Text('Xiishopy ERP',
                style: GoogleFonts.poppins(
                  fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
              const SizedBox(height: 8),
              Text('East African Commerce Platform',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70, letterSpacing: 0.5)),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F3460))),
            ],
          ),
        ),
      ),
    );
  }
}

/// Distributor Dashboard (Desktop dense view with real data + fl_chart)
class DistributorDashboard extends StatefulWidget {
  const DistributorDashboard({super.key});

  @override
  State<DistributorDashboard> createState() => _DistributorDashboardState();
}

class _DistributorDashboardState extends State<DistributorDashboard> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const WatchDashboard());
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Xiishopy ERP - Dashboard',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          _buildForexTicker(),
          const SizedBox(width: 16),
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.language), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () => appRouter.go(AppRoutes.settings)),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final initials = state is Authenticated
                  ? state.user.displayName.isNotEmpty
                      ? state.user.displayName.split(' ').map((s) => s[0]).take(2).join()
                      : state.user.email[0].toUpperCase()
                  : 'U';
              return PopupMenuButton<String>(
                offset: const Offset(0, 48),
                onSelected: (value) {
                  if (value == 'logout') {
                    context.read<AuthBloc>().add(const SignOutRequested());
                  } else if (value == 'profile') {
                    appRouter.go(AppRoutes.profile);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'profile', child: Text('Profile')),
                  const PopupMenuItem(value: 'logout', child: Text('Sign Out')),
                ],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF0F3460),
                    child: Text(initials, style: const TextStyle(fontSize: 12)),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isWide ? _buildWideLayout(context) : _buildNarrowLayout(context),
    );
  }

  Widget _buildForexTicker() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.trending_up, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Text('USD/KES',
            style: GoogleFonts.jetBrainsMono(fontSize: 12, color: Colors.greenAccent)),
          const Text(' 150.23', style: TextStyle(fontSize: 12, color: Colors.greenAccent)),
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      children: [
        // Side navigation - wrap each ListTile in a Material widget
        Container(
          width: 240,
          color: const Color(0xFF16213E),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.dashboard, 'Dashboard', true, AppRoutes.dashboard),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.inventory, 'Inventory', false, AppRoutes.products),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.receipt_long, 'Orders', false, AppRoutes.orders),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.people, 'Customers', false, AppRoutes.customers),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.payment, 'Payments', false, AppRoutes.payments),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.local_shipping, 'Logistics', false, AppRoutes.logistics),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.admin_panel_settings, 'Admin', false, AppRoutes.admin),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.people_alt, 'HR', false, AppRoutes.hr),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.factory, 'Suppliers', false, AppRoutes.suppliers),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.shopping_cart, 'Purchases', false, AppRoutes.purchases),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.receipt, 'Expenses', false, AppRoutes.expenses),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.inventory_2, 'Assets', false, AppRoutes.assets),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.assignment, 'Projects', false, AppRoutes.projects),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.trending_up, 'Analytics', false, AppRoutes.analytics),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.people, 'CRM', false, AppRoutes.crm),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.account_balance, 'Accounting', false, AppRoutes.accounting),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.local_atm, 'Tax', false, AppRoutes.tax),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.precision_manufacturing, 'Manufacturing', false, AppRoutes.manufacturing),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.folder, 'Documents', false, AppRoutes.dms),
              ),
              Material(
                color: Colors.transparent,
                child: _buildNavItem(Icons.settings, 'Settings', false, AppRoutes.settings),
              ),
            ],
          ),
        ),
        // Main content area
        Expanded(
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is DashboardError) {
                return Center(
                  child: Text(state.message, style: GoogleFonts.poppins(color: Colors.white70)),
                );
              }
              if (state is DashboardLoaded) {
                final d = state.data;
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stat cards
                      Row(
                        children: [
                          Expanded(child: StatCard(
                            title: 'Revenue',
                            value: '\$${d.totalRevenue.toStringAsFixed(0)}',
                            icon: Icons.trending_up,
                            color: Colors.green,
                          )),
                          const SizedBox(width: 16),
                          Expanded(child: StatCard(
                            title: 'Orders',
                            value: d.totalOrders.toString(),
                            icon: Icons.receipt_long,
                            color: Colors.blue,
                          )),
                          const SizedBox(width: 16),
                          Expanded(child: StatCard(
                            title: 'Products',
                            value: d.totalProducts.toString(),
                            icon: Icons.inventory,
                            color: Colors.orange,
                          )),
                          const SizedBox(width: 16),
                          Expanded(child: StatCard(
                            title: 'Low Stock',
                            value: d.lowStockCount.toString(),
                            icon: Icons.warning_amber,
                            color: Colors.red,
                          )),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // fl_chart revenue chart
                      Row(
                        children: [
                          Expanded(flex: 3, child: _buildRevenueChart(d.payments)),
                          const SizedBox(width: 16),
                          Expanded(flex: 1, child: _buildStatusPieChart(d.recentOrders)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('Recent Orders',
                        style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: d.recentOrders.length,
                          itemBuilder: (context, index) {
                            final order = d.recentOrders[index];
                            final total = order.items
                                .fold<double>(0, (sum, item) => sum + (item.unitPriceUSD * item.quantity));
                            return _buildOrderCard(
                              order.orderNumber.isNotEmpty ? order.orderNumber : order.id,
                              order.retailerId,
                              '\$${total.toStringAsFixed(2)}',
                              order.status,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueChart(List payments) {
    // Aggregate payments by day for last 7 days
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Revenue (7 days)', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
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
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '\$${value.toInt()}',
                        style: const TextStyle(fontSize: 10, color: Colors.white38),
                      ),
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false,
                  horizontalInterval: dailyRevenue.reduce((a, b) => a > b ? a : b) / 4),
                borderData: FlBorderData(show: false),
                barGroups: dailyRevenue.asMap().entries.map((e) {
                  return BarChartGroupData(x: e.key, barRods: [
                    BarChartRodData(
                      toY: e.value,
                      color: const Color(0xFF0F3460),
                      width: 16,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4), topRight: Radius.circular(4)),
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

  Widget _buildStatusPieChart(List orders) {
    // Count by status
    int completed = 0, pending = 0, others = 0;
    for (final o in orders) {
      if (o.status == 'completed') completed++;
      else if (o.status == 'pending') pending++;
      else others++;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Text('Order Status', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(value: completed.toDouble(), color: Colors.green,
                    title: '$completed', radius: 30, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
                  PieChartSectionData(value: pending.toDouble(), color: Colors.orange,
                    title: '$pending', radius: 30, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
                  PieChartSectionData(value: others.toDouble(), color: Colors.blue,
                    title: '$others', radius: 30, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 20,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(Colors.green, 'Done'),
              const SizedBox(width: 8),
              _legendDot(Colors.orange, 'Pending'),
              const SizedBox(width: 8),
              _legendDot(Colors.blue, 'Other'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DashboardError) {
          return Center(
            child: Text(state.message, style: GoogleFonts.poppins(color: Colors.white70)),
          );
        }
        if (state is DashboardLoaded) {
          final d = state.data;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(spacing: 12, runSpacing: 12, children: [
                  StatCard(title: 'Revenue', value: '\$${d.totalRevenue.toStringAsFixed(0)}',
                    icon: Icons.trending_up, color: Colors.green),
                  StatCard(title: 'Orders', value: d.totalOrders.toString(),
                    icon: Icons.receipt_long, color: Colors.blue),
                  StatCard(title: 'Products', value: d.totalProducts.toString(),
                    icon: Icons.inventory, color: Colors.orange),
                  StatCard(title: 'Low Stock', value: d.lowStockCount.toString(),
                    icon: Icons.warning_amber, color: Colors.red),
                ]),
                const SizedBox(height: 20),
                SizedBox(height: 160, child: _buildRevenueChart(d.payments)),
                const SizedBox(height: 20),
                Text('Recent Orders', style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: d.recentOrders.length,
                    itemBuilder: (context, index) {
                      final order = d.recentOrders[index];
                      final total = order.items
                          .fold<double>(0, (sum, item) => sum + (item.unitPriceUSD * item.quantity));
                      return _buildOrderCard(
                        order.orderNumber.isNotEmpty ? order.orderNumber : order.id,
                        order.retailerId,
                        '\$${total.toStringAsFixed(2)}',
                        order.status,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool selected, String route) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: selected ? const Color(0xFF0F3460) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          leading: Icon(icon, color: selected ? Colors.white : Colors.white54, size: 20),
          title: Text(label,
            style: GoogleFonts.poppins(fontSize: 13, color: selected ? Colors.white : Colors.white54)),
          onTap: () => appRouter.go(route),
        ),
      ),
    );
  }

  Widget _buildOrderCard(String number, String customer, String amount, String status) {
    final statusColor = status == 'In Transit' ? Colors.blue :
        status == 'Picked up' ? Colors.orange :
        status == 'completed' ? Colors.green :
        status == 'pending' ? Colors.yellow :
        Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(number,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(customer,
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
            child: Text(status,
              style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 16),
          Text(amount,
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}