part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {
  const AdminInitial();
}

class AdminLoading extends AdminState {
  const AdminLoading();
}

class AdminConfigLoaded extends AdminState {
  final AdminConfigModel? config;

  const AdminConfigLoaded({this.config});

  @override
  List<Object?> get props => [config];
}

class AdminConfigError extends AdminState {
  final String message;

  const AdminConfigError({required this.message});

  @override
  List<Object?> get props => [message];
}

class UsersLoaded extends AdminState {
  final List<Map<String, dynamic>> users;

  const UsersLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

class AuditLogsLoaded extends AdminState {
  final List<Map<String, dynamic>> logs;

  const AuditLogsLoaded({required this.logs});

  @override
  List<Object?> get props => [logs];
}