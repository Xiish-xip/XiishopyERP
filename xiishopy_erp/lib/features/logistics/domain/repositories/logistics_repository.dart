/// Xiishopy ERP - Logistics Repository (Abstract)
library;

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/shipment_model.dart';

abstract class LogisticsRepository {
  Stream<Either<Failure, List<ShipmentModel>>> watchShipments({String? userId});
  Future<Either<Failure, ShipmentModel>> getShipment(String id);
}