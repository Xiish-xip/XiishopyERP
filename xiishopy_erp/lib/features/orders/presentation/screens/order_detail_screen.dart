/// Xiishopy ERP - Order Detail Screen
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xiishopy_erp/core/di/service_locator.dart';
import 'package:xiishopy_erp/features/orders/domain/repositories/order_repository.dart';
import 'package:xiishopy_erp/features/orders/data/models/order_model.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderModel? _order;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    final repository = sl<OrderRepository>();
    final result = await repository.getOrder(widget.orderId);
    result.fold(
      (failure) => setState(() {
        _errorMessage = failure.message;
        _isLoading = false;
      }),
      (order) => setState(() {
        _order = order;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final o = _order;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text(o?.orderNumber ?? 'Order #${widget.orderId}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
                        onPressed: _loadOrder,
                        child: Text('Retry', style: GoogleFonts.poppins(color: const Color(0xFF0F3460))),
                      ),
                    ],
                  ),
                )
              : o == null
                  ? Center(child: Text('Order not found', style: GoogleFonts.poppins(color: Colors.white70)))
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
                                Text('Order Summary',
                                    style: GoogleFonts.poppins(
                                        fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                                const SizedBox(height: 16),
                                _buildInfoRow('Customer', o.retailerName),
                                _buildInfoRow('Customer ID', o.retailerId),
                                if (o.deliveryAddress != null)
                                  _buildInfoRow('Delivery', o.deliveryAddress!),
                                if (o.notes != null) _buildInfoRow('Notes', o.notes!),
                              ],
                            ),
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
                                Text('Order Items (${o.items.length})',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                                const SizedBox(height: 12),
                                ...o.items.map((item) => _buildOrderItem(item)),
                              ],
                            ),
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
                                Text('Payment Summary',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                                const SizedBox(height: 12),
                                _buildInfoRow('Subtotal', '\$${o.subtotalUSD.toStringAsFixed(2)}'),
                                _buildInfoRow('Shipping', '\$${o.shippingUSD.toStringAsFixed(2)}'),
                                _buildInfoRow('Tax', '\$${o.taxUSD.toStringAsFixed(2)}'),
                                const Divider(color: Colors.white24, height: 24),
                                _buildInfoRow('Total', '\$${o.totalUSD.toStringAsFixed(2)}',
                                    color: Colors.greenAccent),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invoice generated successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            icon: const Icon(Icons.receipt_long),
                            label: Text('Generate Invoice',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F3460),
                              minimumSize: const Size.fromHeight(48),
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

  Widget _buildOrderItem(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName,
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                Text('SKU: ${item.sku}',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
                Text('Qty: ${item.quantity}',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
              ],
            ),
          ),
          Text('\$${item.totalPriceUSD.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w600, color: Colors.greenAccent)),
        ],
      ),
    );
  }
}