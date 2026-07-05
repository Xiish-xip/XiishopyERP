/// Xiishopy ERP - Customer Repository Implementation
library;

import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_datasource.dart';
import '../models/customer_model.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource _remoteDataSource;

  CustomerRepositoryImpl({required CustomerRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Stream<Either<Failure, List<CustomerModel>>> watchCustomers({String? role}) {
    try {
      return _remoteDataSource.watchCustomers(role: role).map(
        (customers) => Right<Failure, List<CustomerModel>>(customers),
      );
    } on FirebaseException catch (e) {
      return Stream.value(Left(DatabaseFailure(message: e.message ?? 'Firebase error')));
    } catch (e) {
      return Stream.value(Left(ServerFailure(message: e.toString())));
    }
  }
}