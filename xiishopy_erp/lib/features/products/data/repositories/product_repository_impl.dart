/// Xiishopy ERP - Product Repository Implementation
library;

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl({required ProductRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Stream<Either<Failure, List<ProductModel>>> watchProducts() {
    return _remoteDataSource.watchProducts().map(
      (products) => Right<Failure, List<ProductModel>>(products),
    ).handleError((Object error) {
      return Left<Failure, List<ProductModel>>(
        ServerFailure(message: error.toString()),
      );
    });
  }

  @override
  Future<Either<Failure, ProductModel>> getProduct(String id) async {
    try {
      final product = await _remoteDataSource.getProduct(id);
      return Right(product);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}