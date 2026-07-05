/// Xiishopy ERP - Products List Screen with real Firestore data
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/product_bloc.dart';
import '../../bloc/product_event.dart';
import '../../bloc/product_state.dart';
import '../../../../core/config/routes.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/status_badge.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const WatchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Products', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductError) {
            return ErrorState(
              message: state.message,
              onRetry: () => context.read<ProductBloc>().add(const WatchProducts()),
            );
          }
          if (state is ProductsLoaded) {
            final products = state.products;
            if (products.isEmpty) {
              return const EmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'No Products Found',
                subtitle: 'Products will appear here once added.',
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: const Color(0xFF16213E),
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    onTap: () => appRouter.go('/products/${product.id}'),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F3460),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          product.sku.substring(0, product.sku.length > 4 ? 4 : product.sku.length),
                          style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Colors.white70),
                        ),
                      ),
                    ),
                    title: Text(product.name,
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    subtitle: Text('\$${product.wholesalePriceUSD.toStringAsFixed(2)} · ${product.category}',
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Stock: ${product.stockLevel}',
                          style: GoogleFonts.jetBrainsMono(fontSize: 12,
                            color: product.isLowStock ? const Color(0xFFE94560) : Colors.greenAccent)),
                        const SizedBox(width: 8),
                        if (product.isLowStock)
                          const StatusBadge(label: 'Low', type: StatusBadgeType.error),
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

// Separate file for ProductDetailScreen - see product_detail_screen.dart