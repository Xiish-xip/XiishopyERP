/// Xiishopy ERP - Payments Screen with real Firestore data
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bloc/payment_event.dart';
import 'bloc/payment_state.dart';
import 'bloc/payment_bloc.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/status_badge.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentBloc>().add(const WatchPayments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Payments', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is PaymentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PaymentsError) {
            return ErrorState(
              message: state.message,
              onRetry: () => context.read<PaymentBloc>().add(const WatchPayments()),
            );
          }
          if (state is PaymentsLoaded) {
            final payments = state.payments;
            if (payments.isEmpty) {
              return const EmptyState(
                icon: Icons.payment_outlined,
                title: 'No Payments Found',
                subtitle: 'Payments will appear here once processed.',
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                return Card(
                  color: const Color(0xFF16213E),
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: payment.isCompleted ? const Color(0xFF1B5E20) : const Color(0xFF0F3460),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        payment.isCompleted ? Icons.check_circle : Icons.payment,
                        color: Colors.white70,
                      ),
                    ),
                    title: Text('\$${payment.amountUSD.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    subtitle: Text('${payment.provider.toUpperCase()} · ${payment.currency}',
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                    trailing: StatusBadge(
                      label: payment.status,
                      type: payment.isCompleted
                          ? StatusBadgeType.success
                          : payment.isFailed
                              ? StatusBadgeType.error
                              : StatusBadgeType.warning,
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