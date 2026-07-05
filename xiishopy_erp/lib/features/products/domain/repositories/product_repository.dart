/// Xiishopy ERP - Product Repository Abstract
library;

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Stream<Either<Failure, List<ProductModel>>> watchProducts();
  Future<Either<Failure, ProductModel>> getProduct(String id);
}