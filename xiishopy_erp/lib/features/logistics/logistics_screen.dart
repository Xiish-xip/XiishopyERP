/// Xiishopy ERP - Logistics Screen with real Firestore data
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bloc/logistics_event.dart';
import 'bloc/logistics_state.dart';
import 'bloc/logistics_bloc.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/status_badge.dart';

class LogisticsScreen extends StatefulWidget {
  const LogisticsScreen({super.key});

  @override
  State<LogisticsScreen> createState() => _LogisticsScreenState();
}

class _LogisticsScreenState extends State<LogisticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LogisticsBloc>().add(const WatchShipments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Logistics', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: BlocBuilder<LogisticsBloc, LogisticsState>(
        builder: (context, state) {
          if (state is LogisticsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LogisticsError) {
            return ErrorState(
              message: state.message,
              onRetry: () => context.read<LogisticsBloc>().add(const WatchShipments()),
            );
          }
          if (state is LogisticsLoaded) {
            final shipments = state.shipments;
            if (shipments.isEmpty) {
              return const EmptyState(
                icon: Icons.local_shipping_outlined,
                title: 'No Shipments Found',
                subtitle: 'Shipments will appear here once created.',
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: shipments.length,
              itemBuilder: (context, index) {
                final shipment = shipments[index];
                return Card(
                  color: const Color(0xFF16213E),
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: shipment.isDelivered ? const Color(0xFF1B5E20) : const Color(0xFF0F3460),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        shipment.isDelivered ? Icons.check_circle : Icons.local_shipping,
                        color: Colors.white70,
                      ),
                    ),
                    title: Text('${shipment.carrier} · ${shipment.trackingNumber ?? 'N/A'}',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    subtitle: Text('${shipment.origin ?? '?'} → ${shipment.destination ?? '?'}',
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                    trailing: StatusBadge(
                      label: shipment.status,
                      type: shipment.isDelivered
                          ? StatusBadgeType.success
                          : shipment.isInTransit
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