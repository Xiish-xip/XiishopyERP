/// Xiishopy ERP - Logistics Repository Implementation
library;

import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/logistics_repository.dart';
import '../datasources/logistics_remote_datasource.dart';
import '../models/shipment_model.dart';

class LogisticsRepositoryImpl implements LogisticsRepository {
  final LogisticsRemoteDataSource _remoteDataSource;

  LogisticsRepositoryImpl({required LogisticsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Stream<Either<Failure, List<ShipmentModel>>> watchShipments({String? userId}) {
    try {
      return _remoteDataSource.watchShipments(userId: userId).map(
        (shipments) => Right<Failure, List<ShipmentModel>>(shipments),
      );
    } on FirebaseException catch (e) {
      return Stream.value(Left(DatabaseFailure(message: e.message ?? 'Firebase error')));
    } catch (e) {
      return Stream.value(Left(ServerFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, ShipmentModel>> getShipment(String id) async {
    try {
      final shipment = await _remoteDataSource.getShipment(id);
      return Right(shipment);
    } on FirebaseException catch (e) {
      return Left(DatabaseFailure(message: e.message ?? 'Firebase error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}