/// Xiishopy ERP - Create Order Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xiishopy_erp/core/di/service_locator.dart';
import 'package:xiishopy_erp/shared/widgets/status_badge.dart';
import 'package:xiishopy_erp/features/products/domain/repositories/product_repository.dart';
import 'package:xiishopy_erp/features/products/data/models/product_model.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  String _selectedCustomerId = '';
  String _deliveryAddress = '';
  String _notes = '';
  List<OrderItemInput> _orderItems = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    // Would load from customer repository
  }

  void _addOrderItem(ProductModel product) {
    setState(() {
      _orderItems.add(OrderItemInput(product: product, quantity: 1));
    });
  }

  double get _subtotal => _orderItems.fold(0, (sum, item) => sum + (item.product.wholesalePriceUSD * item.quantity));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Create Order', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
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
                  Text('Customer & Delivery',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Delivery Address',
                      labelStyle: GoogleFonts.poppins(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF0F3460).withValues(alpha: 0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: GoogleFonts.poppins(color: Colors.white),
                    onChanged: (v) => _deliveryAddress = v,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Notes (optional)',
                      labelStyle: GoogleFonts.poppins(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF0F3460).withValues(alpha: 0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: GoogleFonts.poppins(color: Colors.white),
                    onChanged: (v) => _notes = v,
                  ),
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
                  Text('Order Items (${_orderItems.length})',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 12),
                  ..._orderItems.map((item) => _buildOrderItemInput(item)),
                  if (_orderItems.isEmpty)
                    Text('No items added yet',
                        style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
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
                  _buildInfoRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
                  _buildInfoRow('Shipping', '\$0.00'),
                  _buildInfoRow('Tax', '\$0.00'),
                  const Divider(color: Colors.white24, height: 24),
                  _buildInfoRow('Total', '\$${_subtotal.toStringAsFixed(2)}', color: Colors.greenAccent),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _createOrder,
              icon: const Icon(Icons.check),
              label: Text(_isSubmitting ? 'Creating...' : 'Create Order',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3460),
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F3460),
        onPressed: _selectProduct,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOrderItemInput(OrderItemInput item) {
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
                Text(item.product.name,
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                Text('\$${item.product.wholesalePriceUSD.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.white),
              controller: TextEditingController(text: item.quantity.toString()),
              onChanged: (v) {
                final q = int.tryParse(v) ?? 1;
                setState(() => item.quantity = q);
              },
            ),
          ),
          const SizedBox(width: 8),
          Text('\$${(item.product.wholesalePriceUSD * item.quantity).toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.greenAccent)),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: () => setState(() => _orderItems.remove(item)),
          ),
        ],
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

  Future<void> _selectProduct() async {
    // Would show product picker dialog
    final repository = sl<ProductRepository>();
    final result = await repository.watchProducts().first;
    result.fold((_) {}, (products) {
      if (products.isNotEmpty) {
        _addOrderItem(products.first);
      }
    });
  }

  Future<void> _createOrder() async {
    setState(() => _isSubmitting = true);
    // Would call order repository to create order
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isSubmitting = false);
    if (mounted) Navigator.of(context).pop();
  }
}

class OrderItemInput {
  final ProductModel product;
  int quantity;

  OrderItemInput({required this.product, required this.quantity});
}