/// Xiishopy ERP - Tax Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/tax_model.dart';
import '../data/repositories/tax_repository.dart';

abstract class TaxEvent extends Equatable {
  const TaxEvent();
  @override List<Object?> get props => [];
}
class WatchTaxConfigs extends TaxEvent { const WatchTaxConfigs(); }
class CreateTaxConfig extends TaxEvent { final TaxConfigModel config; const CreateTaxConfig({required this.config}); @override List<Object?> get props => [config]; }
class UpdateTaxConfig extends TaxEvent { final TaxConfigModel config; const UpdateTaxConfig({required this.config}); @override List<Object?> get props => [config]; }
class WatchTaxRates extends TaxEvent { const WatchTaxRates(); }
class CreateTaxRate extends TaxEvent { final TaxRateModel rate; const CreateTaxRate({required this.rate}); @override List<Object?> get props => [rate]; }
class UpdateTaxRate extends TaxEvent { final TaxRateModel rate; const UpdateTaxRate({required this.rate}); @override List<Object?> get props => [rate]; }
class SwitchTaxTab extends TaxEvent { final int tabIndex; const SwitchTaxTab({required this.tabIndex}); @override List<Object?> get props => [tabIndex]; }
class TaxError extends TaxEvent { final String message; const TaxError({required this.message}); @override List<Object?> get props => [message]; }

abstract class TaxState extends Equatable {
  final int selectedTab;
  const TaxState({this.selectedTab = 0});
  @override List<Object?> get props => [selectedTab];
}
class TaxInitial extends TaxState { const TaxInitial({super.selectedTab = 0}); }
class TaxLoading extends TaxState { const TaxLoading({super.selectedTab = 0}); }
class TaxConfigsLoaded extends TaxState {
  final List<TaxConfigModel> configs;
  const TaxConfigsLoaded({required this.configs, super.selectedTab = 0});
  @override List<Object?> get props => [configs, selectedTab];
}
class TaxRatesLoaded extends TaxState {
  final List<TaxRateModel> rates;
  const TaxRatesLoaded({required this.rates, super.selectedTab = 1});
  @override List<Object?> get props => [rates, selectedTab];
}
class TaxErrorState extends TaxState {
  final String message;
  const TaxErrorState({required this.message, super.selectedTab = 0});
  @override List<Object?> get props => [message, selectedTab];
}

class TaxBloc extends Bloc<TaxEvent, TaxState> {
  final TaxRepository _repository;
  StreamSubscription? _configsSub;
  StreamSubscription? _ratesSub;

  TaxBloc({required TaxRepository repository})
      : _repository = repository,
        super(const TaxInitial()) {
    on<WatchTaxConfigs>(_onWatchConfigs);
    on<CreateTaxConfig>(_onCreateConfig);
    on<UpdateTaxConfig>(_onUpdateConfig);
    on<WatchTaxRates>(_onWatchRates);
    on<CreateTaxRate>(_onCreateRate);
    on<UpdateTaxRate>(_onUpdateRate);
    on<SwitchTaxTab>(_onSwitchTab);
    on<TaxError>(_onError);
  }

  void _onWatchConfigs(WatchTaxConfigs event, Emitter<TaxState> emit) {
    emit(TaxLoading(selectedTab: state.selectedTab));
    _configsSub?.cancel();
    _configsSub = _repository.watchTaxConfigs().listen(
      (configs) { if (!emit.isDone) emit(TaxConfigsLoaded(configs: configs, selectedTab: state.selectedTab)); },
      onError: (e) { if (!emit.isDone) add(TaxError(message: e.toString())); },
    );
  }

  Future<void> _onCreateConfig(CreateTaxConfig event, Emitter<TaxState> emit) async {
    try { await _repository.createTaxConfig(event.config); } catch (e) { add(TaxError(message: 'Failed to create tax config: $e')); }
  }

  Future<void> _onUpdateConfig(UpdateTaxConfig event, Emitter<TaxState> emit) async {
    try { await _repository.updateTaxConfig(event.config); } catch (e) { add(TaxError(message: 'Failed to update tax config: $e')); }
  }

  void _onWatchRates(WatchTaxRates event, Emitter<TaxState> emit) {
    emit(TaxLoading(selectedTab: state.selectedTab));
    _ratesSub?.cancel();
    _ratesSub = _repository.watchTaxRates().listen(
      (rates) { if (!emit.isDone) emit(TaxRatesLoaded(rates: rates, selectedTab: state.selectedTab)); },
      onError: (e) { if (!emit.isDone) add(TaxError(message: e.toString())); },
    );
  }

  Future<void> _onCreateRate(CreateTaxRate event, Emitter<TaxState> emit) async {
    try { await _repository.createTaxRate(event.rate); } catch (e) { add(TaxError(message: 'Failed to create tax rate: $e')); }
  }

  Future<void> _onUpdateRate(UpdateTaxRate event, Emitter<TaxState> emit) async {
    try { await _repository.updateTaxRate(event.rate); } catch (e) { add(TaxError(message: 'Failed to update tax rate: $e')); }
  }

  void _onSwitchTab(SwitchTaxTab event, Emitter<TaxState> emit) {
    emit(TaxLoading(selectedTab: event.tabIndex));
    switch (event.tabIndex) {
      case 0: add(const WatchTaxConfigs()); break;
      case 1: add(const WatchTaxRates()); break;
    }
  }

  void _onError(TaxError event, Emitter<TaxState> emit) {
    emit(TaxErrorState(message: event.message, selectedTab: state.selectedTab));
  }

  @override
  Future<void> close() {
    _configsSub?.cancel(); _ratesSub?.cancel();
    return super.close();
  }
}