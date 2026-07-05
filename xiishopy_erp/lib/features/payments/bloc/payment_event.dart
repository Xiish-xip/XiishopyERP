/// Xiishopy ERP - Payment Events
library;

import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override List<Object?> get props => [];
}

class WatchPayments extends PaymentEvent {
  const WatchPayments();
}