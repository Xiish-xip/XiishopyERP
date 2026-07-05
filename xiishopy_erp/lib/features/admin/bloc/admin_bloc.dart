/// Xiishopy ERP - Admin Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/admin_config_model.dart';
import '../data/repositories/admin_repository.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _repository;
  StreamSubscription? _configSubscription;

  AdminBloc({required AdminRepository repository})
      : _repository = repository,
        super(const AdminInitial()) {
    on<LoadAdminConfig>(_onLoadConfig);
    on<AdminConfigUpdated>(_onConfigUpdated);
    on<ToggleModule>(_onToggleModule);
    on<UpdateBusinessRules>(_onUpdateBusinessRules);
    on<LoadUsers>(_onLoadUsers);
    on<UpdateUserRole>(_onUpdateUserRole);
    on<ToggleUserBan>(_onToggleUserBan);
    on<DeleteUser>(_onDeleteUser);
    on<LoadAuditLogs>(_onLoadAuditLogs);
    on<AdminError>(_onAdminError);
  }

  void _onLoadConfig(LoadAdminConfig event, Emitter<AdminState> emit) {
    emit(const AdminLoading());
    _configSubscription?.cancel();
    _configSubscription = _repository.watchConfig().listen(
      (config) {
        add(AdminConfigUpdated(config: config));
      },
      onError: (error) {
        add(AdminError(message: error.toString()));
      },
    );
  }

  void _onConfigUpdated(AdminConfigUpdated event, Emitter<AdminState> emit) {
    emit(AdminConfigLoaded(config: event.config));
  }

  Future<void> _onToggleModule(ToggleModule event, Emitter<AdminState> emit) async {
    try {
      await _repository.updateModuleConfig(event.module, {
        'enabled': event.enabled,
        'features': event.features,
      });
    } catch (e) {
      add(AdminError(message: 'Failed to toggle module: $e'));
    }
  }

  Future<void> _onUpdateBusinessRules(UpdateBusinessRules event, Emitter<AdminState> emit) async {
    try {
      await _repository.updateBusinessRules(event.rules);
    } catch (e) {
      add(AdminError(message: 'Failed to update business rules: $e'));
    }
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<AdminState> emit) async {
    emit(const AdminLoading());
    try {
      final users = await _repository.getAllUsers();
      emit(UsersLoaded(users: users));
    } catch (e) {
      add(AdminError(message: 'Failed to load users: $e'));
    }
  }

  Future<void> _onUpdateUserRole(UpdateUserRole event, Emitter<AdminState> emit) async {
    try {
      await _repository.updateUserRole(event.userId, event.role);
      // Reload users
      final users = await _repository.getAllUsers();
      emit(UsersLoaded(users: users));
    } catch (e) {
      add(AdminError(message: 'Failed to update role: $e'));
    }
  }

  Future<void> _onToggleUserBan(ToggleUserBan event, Emitter<AdminState> emit) async {
    try {
      await _repository.toggleUserBan(event.userId, event.banned);
      final users = await _repository.getAllUsers();
      emit(UsersLoaded(users: users));
    } catch (e) {
      add(AdminError(message: 'Failed to toggle ban: $e'));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<AdminState> emit) async {
    try {
      await _repository.deleteUser(event.userId);
      final users = await _repository.getAllUsers();
      emit(UsersLoaded(users: users));
    } catch (e) {
      add(AdminError(message: 'Failed to delete user: $e'));
    }
  }

  Future<void> _onLoadAuditLogs(LoadAuditLogs event, Emitter<AdminState> emit) async {
    emit(const AdminLoading());
    _configSubscription?.cancel();
    _configSubscription = _repository.watchAuditLogs(limit: event.limit).listen(
      (logs) {
        emit(AuditLogsLoaded(logs: logs));
      },
      onError: (error) {
        add(AdminError(message: error.toString()));
      },
    );
  }

  void _onAdminError(AdminError event, Emitter<AdminState> emit) {
    emit(AdminConfigError(message: event.message));
  }

  @override
  Future<void> close() {
    _configSubscription?.cancel();
    return super.close();
  }
}