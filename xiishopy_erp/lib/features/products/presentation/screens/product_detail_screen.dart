/// Xiishopy ERP - Product Detail Screen
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xiishopy_erp/core/di/service_locator.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/models/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductModel? _product;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final repository = sl<ProductRepository>();
    final result = await repository.getProduct(widget.productId);
    result.fold(
      (failure) => setState(() {
        _errorMessage = failure.message;
        _isLoading = false;
      }),
      (product) => setState(() {
        _product = product;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _product;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text(p?.name ?? 'Product Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState()
              : p == null
                  ? Center(child: Text('Product not found', style: GoogleFonts.poppins(color: Colors.white70)))
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0F3460),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: p.imageUrl != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.network(p.imageUrl!, fit: BoxFit.cover),
                                            )
                                          : const Icon(Icons.inventory, size: 40, color: Colors.white70),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(p.name,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          const SizedBox(height: 8),
                                          Text('SKU: ${p.sku}',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13, color: Colors.white54)),
                                          const SizedBox(height: 4),
                                          Text('Category: ${p.category}',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13, color: Colors.white54)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                _buildInfoRow('Wholesale Price', '\$${p.wholesalePriceUSD.toStringAsFixed(2)} USD'),
                                if (p.retailPriceLocal != null)
                                  _buildInfoRow('Retail Price', '\$${p.retailPriceLocal!.toStringAsFixed(2)} Local'),
                                _buildInfoRow('Unit', p.unit),
                                _buildInfoRow('Stock Level', p.stockLevel.toString(),
                                    color: p.isLowStock ? Colors.redAccent : Colors.greenAccent),
                                _buildInfoRow('Reorder Level', p.reorderLevel.toString()),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (p.isLowStock)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE94560).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE94560).withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning_amber, color: Color(0xFFE94560)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Low stock alert! Current stock (${p.stockLevel}) is at or below reorder level (${p.reorderLevel})',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12, color: const Color(0xFFE94560)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF16213E),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Created', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                                Text('${p.createdAt}',
                                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
                                const SizedBox(height: 8),
                                Text('Last Updated',
                                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                                Text('${p.updatedAt}',
                                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit),
                                  label: Text('Edit Product',
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0F3460),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete),
                                  label: Text('Delete',
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE94560),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_errorMessage ?? 'An error occurred',
              style: GoogleFonts.poppins(color: Colors.redAccent)),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _loadProduct,
            child: Text('Retry', style: GoogleFonts.poppins(color: const Color(0xFF0F3460))),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w600, color: color ?? Colors.white)),
        ],
      ),
    );
  }
}