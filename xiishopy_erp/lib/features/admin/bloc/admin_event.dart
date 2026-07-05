part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class LoadAdminConfig extends AdminEvent {
  const LoadAdminConfig();
}

class AdminConfigUpdated extends AdminEvent {
  final AdminConfigModel? config;

  const AdminConfigUpdated({this.config});

  @override
  List<Object?> get props => [config];
}

class ToggleModule extends AdminEvent {
  final String module;
  final bool enabled;
  final Map<String, dynamic> features;

  const ToggleModule({
    required this.module,
    required this.enabled,
    this.features = const {},
  });

  @override
  List<Object?> get props => [module, enabled, features];
}

class UpdateBusinessRules extends AdminEvent {
  final Map<String, dynamic> rules;

  const UpdateBusinessRules({required this.rules});

  @override
  List<Object?> get props => [rules];
}

class LoadUsers extends AdminEvent {
  const LoadUsers();
}

class UpdateUserRole extends AdminEvent {
  final String userId;
  final String role;

  const UpdateUserRole({required this.userId, required this.role});

  @override
  List<Object?> get props => [userId, role];
}

class ToggleUserBan extends AdminEvent {
  final String userId;
  final bool banned;

  const ToggleUserBan({required this.userId, required this.banned});

  @override
  List<Object?> get props => [userId, banned];
}

class DeleteUser extends AdminEvent {
  final String userId;

  const DeleteUser({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadAuditLogs extends AdminEvent {
  final int limit;

  const LoadAuditLogs({this.limit = 100});

  @override
  List<Object?> get props => [limit];
}

class AdminError extends AdminEvent {
  final String message;

  const AdminError({required this.message});

  @override
  List<Object?> get props => [message];
}