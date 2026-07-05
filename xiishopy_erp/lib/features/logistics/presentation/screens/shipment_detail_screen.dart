/// Xiishopy ERP - Shipment Detail Screen
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xiishopy_erp/core/di/service_locator.dart';
import 'package:xiishopy_erp/features/logistics/domain/repositories/logistics_repository.dart';
import 'package:xiishopy_erp/features/logistics/data/models/shipment_model.dart';
import 'package:xiishopy_erp/shared/widgets/status_badge.dart';

class ShipmentDetailScreen extends StatefulWidget {
  final String shipmentId;
  const ShipmentDetailScreen({super.key, required this.shipmentId});

  @override
  State<ShipmentDetailScreen> createState() => _ShipmentDetailScreenState();
}

class _ShipmentDetailScreenState extends State<ShipmentDetailScreen> {
  ShipmentModel? _shipment;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadShipment();
  }

  Future<void> _loadShipment() async {
    final repository = sl<LogisticsRepository>();
    final result = await repository.getShipment(widget.shipmentId);
    result.fold(
      (failure) => setState(() {
        _errorMessage = failure.message;
        _isLoading = false;
      }),
      (shipment) => setState(() {
        _shipment = shipment;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = _shipment;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text(s?.trackingNumber ?? 'Shipment #${widget.shipmentId}',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!,
                          style: GoogleFonts.poppins(color: Colors.redAccent)),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _loadShipment,
                        child: Text('Retry', style: GoogleFonts.poppins(color: const Color(0xFF0F3460))),
                      ),
                    ],
                  ),
                )
              : s == null
                  ? Center(child: Text('Shipment not found', style: GoogleFonts.poppins(color: Colors.white70)))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF16213E),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Shipment Details',
                                    style: GoogleFonts.poppins(
                                        fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                                const SizedBox(height: 16),
                                _buildInfoRow('Carrier', s.carrier),
                                _buildInfoRow('Order ID', s.orderId),
                                _buildInfoRow('Status', s.status,
                                    color: s.isDelivered
                                        ? Colors.greenAccent
                                        : s.isInTransit
                                            ? Colors.orange
                                            : Colors.blue),
                                if (s.origin != null) _buildInfoRow('Origin', s.origin!),
                                if (s.destination != null) _buildInfoRow('Destination', s.destination!),
                                if (s.estimatedDelivery != null)
                                  _buildInfoRow('Est. Delivery', '${s.estimatedDelivery}'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (s.trackingHistory.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF16213E),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tracking History',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                                  const SizedBox(height: 12),
                                  ...s.trackingHistory.map((event) => _buildTrackingEvent(event)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w600, color: color ?? Colors.white)),
        ],
      ),
    );
  }

  Widget _buildTrackingEvent(TrackingEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(event.status,
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
              Text('${event.timestamp}',
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 4),
          Text(event.location, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
          if (event.description.isNotEmpty)
            Text(event.description, style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
        ],
      ),
    );
  }
}