/// Xiishopy ERP - Order Repository Abstract
library;

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/order_model.dart';

abstract class OrderRepository {
  Stream<Either<Failure, List<OrderModel>>> watchOrders({String? userId});
  Future<Either<Failure, OrderModel>> getOrder(String id);
}