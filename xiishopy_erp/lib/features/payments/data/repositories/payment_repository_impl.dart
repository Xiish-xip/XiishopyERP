/// Xiishopy ERP - Payment Repository Implementation
library;

import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource _remoteDataSource;

  PaymentRepositoryImpl({required PaymentRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Stream<Either<Failure, List<PaymentModel>>> watchPayments({String? userId}) {
    try {
      return _remoteDataSource.watchPayments(userId: userId).map(
        (payments) => Right<Failure, List<PaymentModel>>(payments),
      );
    } on FirebaseException catch (e) {
      return Stream.value(Left(DatabaseFailure(message: e.message ?? 'Firebase error')));
    } catch (e) {
      return Stream.value(Left(ServerFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, PaymentModel>> getPayment(String id) async {
    try {
      final payment = await _remoteDataSource.getPayment(id);
      return Right(payment);
    } on FirebaseException catch (e) {
      return Left(DatabaseFailure(message: e.message ?? 'Firebase error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}