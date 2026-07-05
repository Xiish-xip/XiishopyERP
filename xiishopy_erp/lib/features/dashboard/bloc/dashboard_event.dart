/// Xiishopy ERP - Dashboard Events
library;

import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override List<Object?> get props => [];
}

class WatchDashboard extends DashboardEvent {
  const WatchDashboard();
}