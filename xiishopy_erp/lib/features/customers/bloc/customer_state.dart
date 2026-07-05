/// Xiishopy ERP - Customer States
library;

import 'package:equatable/equatable.dart';
import '../data/models/customer_model.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();
  @override List<Object?> get props => [];
}

class CustomersLoading extends CustomerState { const CustomersLoading(); }

class CustomersLoaded extends CustomerState {
  final List<CustomerModel> customers;
  const CustomersLoaded({required this.customers});
  @override List<Object?> get props => [customers];
}

class CustomersError extends CustomerState {
  final String message;
  const CustomersError({required this.message});
  @override List<Object?> get props => [message];
}