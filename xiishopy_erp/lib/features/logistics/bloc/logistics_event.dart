/// Xiishopy ERP - Logistics Events
library;

import 'package:equatable/equatable.dart';

abstract class LogisticsEvent extends Equatable {
  const LogisticsEvent();
  @override List<Object?> get props => [];
}

class WatchShipments extends LogisticsEvent {
  const WatchShipments();
}