/// Xiishopy ERP - Order Repository Implementation
library;

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;

  OrderRepositoryImpl({required OrderRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Stream<Either<Failure, List<OrderModel>>> watchOrders({String? userId}) {
    return _remoteDataSource.watchOrders(userId: userId).map(
      (orders) => Right<Failure, List<OrderModel>>(orders),
    ).handleError((Object error) {
      return Left<Failure, List<OrderModel>>(
        ServerFailure(message: error.toString()),
      );
    });
  }

  @override
  Future<Either<Failure, OrderModel>> getOrder(String id) async {
    try {
      final order = await _remoteDataSource.getOrder(id);
      return Right(order);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}