/// Xiishopy ERP - Dashboard Repository Implementation
library;

import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../products/data/models/product_model.dart';
import '../../../payments/data/models/payment_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl({required DashboardRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Stream<Either<Failure, DashboardData>> watchDashboard() {
    try {
      final ordersStream = _remoteDataSource.watchRecentOrders();
      final productsStream = _remoteDataSource.watchProducts();
      final paymentsStream = _remoteDataSource.watchPayments();

      return _combineStreams(ordersStream, productsStream, paymentsStream);
    } on FirebaseException catch (e) {
      return Stream.value(Left(DatabaseFailure(message: e.message ?? 'Firebase error')));
    } catch (e) {
      return Stream.value(Left(ServerFailure(message: e.toString())));
    }
  }

  Stream<Either<Failure, DashboardData>> _combineStreams(
    Stream<List<OrderModel>> ordersStream,
    Stream<List<ProductModel>> productsStream,
    Stream<List<PaymentModel>> paymentsStream,
  ) {
    List<OrderModel> latestOrders = [];
    List<ProductModel> latestProducts = [];
    List<PaymentModel> latestPayments = [];
    bool ordersReady = false, productsReady = false, paymentsReady = false;
    final controller = StreamController<Either<Failure, DashboardData>>();

    void tryEmit() {
      if (ordersReady && productsReady && paymentsReady) {
        controller.add(Right(_buildDashboardData(latestOrders, latestProducts, latestPayments)));
      }
    }

    ordersStream.listen((orders) {
      latestOrders = orders;
      ordersReady = true;
      tryEmit();
    }, onError: (e) => controller.addError(e));

    productsStream.listen((products) {
      latestProducts = products;
      productsReady = true;
      tryEmit();
    }, onError: (e) => controller.addError(e));

    paymentsStream.listen((payments) {
      latestPayments = payments;
      paymentsReady = true;
      tryEmit();
    }, onError: (e) => controller.addError(e));

    return controller.stream;
  }

  @override
  Future<Either<Failure, DashboardData>> getDashboardSnapshot() async {
    try {
      final orders = await _remoteDataSource.watchRecentOrders().first;
      final products = await _remoteDataSource.watchProducts().first;
      final payments = await _remoteDataSource.watchPayments().first;
      return Right(_buildDashboardData(orders, products, payments));
    } on FirebaseException catch (e) {
      return Left(DatabaseFailure(message: e.message ?? 'Firebase error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  DashboardData _buildDashboardData(
      List<OrderModel> orders, List<ProductModel> products, List<PaymentModel> payments) {
    final totalRevenue = payments
        .where((p) => p.isCompleted)
        .fold<double>(0, (sum, p) => sum + p.amountUSD);
    final lowStockCount = products.where((p) => p.isLowStock).length;

    return DashboardData(
      totalOrders: orders.length,
      totalCustomers: 0,
      totalProducts: products.length,
      lowStockCount: lowStockCount,
      totalRevenue: totalRevenue,
      recentOrders: orders,
      products: products,
      payments: payments,
    );
  }
}