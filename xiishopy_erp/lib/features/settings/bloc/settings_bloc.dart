/// Xiishopy ERP - Settings Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/settings_model.dart';
import '../data/repositories/settings_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;
  StreamSubscription? _sub;

  SettingsBloc({required SettingsRepository repository})
      : _repository = repository,
        super(const SettingsLoading()) {
    on<WatchSettings>(_onWatch);
    on<UpdateSettingsCategory>(_onUpdate);
  }

  void _onWatch(WatchSettings event, Emitter<SettingsState> emit) {
    emit(const SettingsLoading());
    _sub?.cancel();
    _sub = _repository.watchSettings().listen(
      (settings) => emit(SettingsLoaded(settings: settings ?? SettingsModel(updatedAt: DateTime.now()))),
      onError: (e) => emit(SettingsError(message: e.toString())),
    );
  }

  Future<void> _onUpdate(UpdateSettingsCategory event, Emitter<SettingsState> emit) async {
    try { await _repository.updateSettingsCategory(event.category, event.data); }
    catch (e) { emit(SettingsError(message: e.toString())); }
  }

  @override Future<void> close() { _sub?.cancel(); return super.close(); }
}

// Events
abstract class SettingsEvent extends Equatable { const SettingsEvent(); @override List<Object?> get props => []; }
class WatchSettings extends SettingsEvent { const WatchSettings(); }
class UpdateSettingsCategory extends SettingsEvent { final String category; final Map<String, dynamic> data; const UpdateSettingsCategory({required this.category, required this.data}); @override List<Object?> get props => [category, data]; }

// States
abstract class SettingsState extends Equatable { const SettingsState(); @override List<Object?> get props => []; }
class SettingsLoading extends SettingsState { const SettingsLoading(); }
class SettingsLoaded extends SettingsState { final SettingsModel settings; const SettingsLoaded({required this.settings}); @override List<Object?> get props => [settings]; }
class SettingsError extends SettingsState { final String message; const SettingsError({required this.message}); @override List<Object?> get props => [message]; }