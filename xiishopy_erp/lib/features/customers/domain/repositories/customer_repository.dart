/// Xiishopy ERP - Customer Repository (Abstract)
library;

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/customer_model.dart';

abstract class CustomerRepository {
  Stream<Either<Failure, List<CustomerModel>>> watchCustomers({String? role});
}