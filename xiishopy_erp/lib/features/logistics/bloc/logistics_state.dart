/// Xiishopy ERP - Logistics States
library;

import 'package:equatable/equatable.dart';
import '../data/models/shipment_model.dart';

abstract class LogisticsState extends Equatable {
  const LogisticsState();
  @override List<Object?> get props => [];
}

class LogisticsLoading extends LogisticsState { const LogisticsLoading(); }

class LogisticsLoaded extends LogisticsState {
  final List<ShipmentModel> shipments;
  const LogisticsLoaded({required this.shipments});
  @override List<Object?> get props => [shipments];
}

class LogisticsError extends LogisticsState {
  final String message;
  const LogisticsError({required this.message});
  @override List<Object?> get props => [message];
}