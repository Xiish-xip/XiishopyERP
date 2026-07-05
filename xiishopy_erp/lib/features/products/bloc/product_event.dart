/// Xiishopy ERP - Product Bloc Events
library;

import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class WatchProducts extends ProductEvent {
  const WatchProducts();
}

class RefreshProducts extends ProductEvent {
  const RefreshProducts();
}