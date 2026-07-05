/// Xiishopy ERP - Orders List Screen with real Firestore data
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/order_bloc.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/status_badge.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(const WatchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Orders', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrdersError) {
            return ErrorState(
              message: state.message,
              onRetry: () => context.read<OrderBloc>().add(const WatchOrders()),
            );
          }
          if (state is OrdersLoaded) {
            final orders = state.orders;
            if (orders.isEmpty) {
              return const EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'No Orders Found',
                subtitle: 'Orders will appear here once created.',
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final totalUSD = order.items
                    .fold<double>(0, (sum, item) => sum + (item.unitPriceUSD * item.quantity));
                return Card(
                  color: const Color(0xFF16213E),
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F3460),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          order.orderNumber.isNotEmpty
                              ? order.orderNumber.substring(0, 4)
                              : order.id.substring(0, 4),
                          style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Colors.white70),
                        ),
                      ),
                    ),
                    title: Text(order.orderNumber.isNotEmpty ? order.orderNumber : order.id,
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    subtitle: Text('\$${totalUSD.toStringAsFixed(2)} · ${order.items.length} items',
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                    trailing: StatusBadge(
                      label: order.status,
                      type: order.status == 'completed'
                          ? StatusBadgeType.success
                          : order.status == 'pending'
                              ? StatusBadgeType.warning
                              : StatusBadgeType.info,
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}