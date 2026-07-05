/// Xiishopy ERP - Customers Screen with real Firestore data
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bloc/customer_event.dart';
import 'bloc/customer_state.dart';
import 'bloc/customer_bloc.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/status_badge.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(const WatchCustomers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Customers', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          if (state is CustomersLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CustomersError) {
            return ErrorState(
              message: state.message,
              onRetry: () => context.read<CustomerBloc>().add(const WatchCustomers()),
            );
          }
          if (state is CustomersLoaded) {
            final customers = state.customers;
            if (customers.isEmpty) {
              return const EmptyState(
                icon: Icons.people_outline,
                title: 'No Customers Found',
                subtitle: 'Customers will appear here once they register.',
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Card(
                  color: const Color(0xFF16213E),
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF0F3460),
                      child: Text(
                        customer.displayName.isNotEmpty
                            ? customer.displayName[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                    ),
                    title: Text(customer.displayName,
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    subtitle: Text(customer.email,
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(customer.role,
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                        const SizedBox(width: 8),
                        StatusBadge(
                          label: customer.emailVerified ? 'Verified' : 'Pending',
                          type: customer.emailVerified ? StatusBadgeType.success : StatusBadgeType.warning,
                        ),
                      ],
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