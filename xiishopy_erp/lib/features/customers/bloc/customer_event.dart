/// Xiishopy ERP - Customer Events
library;

import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();
  @override List<Object?> get props => [];
}

class WatchCustomers extends CustomerEvent {
  const WatchCustomers();
}