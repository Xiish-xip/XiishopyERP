/// Xiishopy ERP - Payment States
library;

import 'package:equatable/equatable.dart';
import '../data/models/payment_model.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
  @override List<Object?> get props => [];
}

class PaymentsLoading extends PaymentState { const PaymentsLoading(); }

class PaymentsLoaded extends PaymentState {
  final List<PaymentModel> payments;
  const PaymentsLoaded({required this.payments});
  @override List<Object?> get props => [payments];
}

class PaymentsError extends PaymentState {
  final String message;
  const PaymentsError({required this.message});
  @override List<Object?> get props => [message];
}