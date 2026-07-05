/// Xiishopy ERP - Dashboard States
library;

import 'package:equatable/equatable.dart';
import '../domain/repositories/dashboard_repository.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override List<Object?> get props => [];
}

class DashboardLoading extends DashboardState { const DashboardLoading(); }

class DashboardLoaded extends DashboardState {
  final DashboardData data;
  const DashboardLoaded({required this.data});
  @override List<Object?> get props => [data];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError({required this.message});
  @override List<Object?> get props => [message];
}