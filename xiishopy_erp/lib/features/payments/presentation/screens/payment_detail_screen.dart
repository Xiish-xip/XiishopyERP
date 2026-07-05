/// Xiishopy ERP - Payment Detail Screen
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xiishopy_erp/core/di/service_locator.dart';
import 'package:xiishopy_erp/features/payments/domain/repositories/payment_repository.dart';
import 'package:xiishopy_erp/features/payments/data/models/payment_model.dart';
import 'package:xiishopy_erp/shared/widgets/status_badge.dart';

class PaymentDetailScreen extends StatefulWidget {
  final String paymentId;
  const PaymentDetailScreen({super.key, required this.paymentId});

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  PaymentModel? _payment;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPayment();
  }

  Future<void> _loadPayment() async {
    final repository = sl<PaymentRepository>();
    final result = await repository.getPayment(widget.paymentId);
    result.fold(
      (failure) => setState(() {
        _errorMessage = failure.message;
        _isLoading = false;
      }),
      (payment) => setState(() {
        _payment = payment;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _payment;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text(p?.transactionId ?? 'Payment #${widget.paymentId}',
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
                        onPressed: _loadPayment,
                        child: Text('Retry', style: GoogleFonts.poppins(color: const Color(0xFF0F3460))),
                      ),
                    ],
                  ),
                )
              : p == null
                  ? Center(child: Text('Payment not found', style: GoogleFonts.poppins(color: Colors.white70)))
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
                                Text('Payment Details',
                                    style: GoogleFonts.poppins(
                                        fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                                const SizedBox(height: 16),
                                _buildInfoRow('Amount', '\$${p.amountUSD.toStringAsFixed(2)} USD (${p.currency})'),
                                _buildInfoRow('Provider', p.provider.toUpperCase()),
                                _buildInfoRow('Status', p.status.toUpperCase(),
                                    color: p.isCompleted
                                        ? Colors.greenAccent
                                        : p.isFailed
                                            ? Colors.redAccent
                                            : Colors.orange),
                                _buildInfoRow('Transaction ID', p.transactionId ?? 'N/A'),
                                _buildInfoRow('Order ID', p.orderId),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (p.phoneNumber != null)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF16213E),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: _buildInfoRow('Phone', p.phoneNumber!),
                            ),
                          if (p.mpesaCode != null)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF16213E),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: _buildInfoRow('M-Pesa Code', p.mpesaCode!),
                            ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF16213E),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Timestamps',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.white54)),
                                const SizedBox(height: 8),
                                _buildInfoRow('Created', '${p.createdAt}'),
                                _buildInfoRow('Updated', '${p.updatedAt}'),
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
}