/// Xiishopy ERP - Payment Repository (Abstract)
library;

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/payment_model.dart';

abstract class PaymentRepository {
  Stream<Either<Failure, List<PaymentModel>>> watchPayments({String? userId});
  Future<Either<Failure, PaymentModel>> getPayment(String id);
}