/// Xiishopy ERP - Dashboard Repository (Abstract)
library;

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../products/data/models/product_model.dart';
import '../../../payments/data/models/payment_model.dart';

class DashboardData {
  final int totalOrders;
  final int totalCustomers;
  final int totalProducts;
  final int lowStockCount;
  final double totalRevenue;
  final List<OrderModel> recentOrders;
  final List<ProductModel> products;
  final List<PaymentModel> payments;

  const DashboardData({
    required this.totalOrders,
    required this.totalCustomers,
    required this.totalProducts,
    required this.lowStockCount,
    required this.totalRevenue,
    required this.recentOrders,
    required this.products,
    required this.payments,
  });
}

abstract class DashboardRepository {
  Stream<Either<Failure, DashboardData>> watchDashboard();
  Future<Either<Failure, DashboardData>> getDashboardSnapshot();
}