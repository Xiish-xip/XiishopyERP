/// Xiishopy ERP - Asset Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/asset_model.dart';
import '../data/repositories/asset_repository.dart';

class AssetBloc extends Bloc<AssetEvent, AssetState> {
  final AssetRepository _repository;
  StreamSubscription? _sub;

  AssetBloc({required AssetRepository repository})
      : _repository = repository,
        super(const AssetsLoading()) {
    on<WatchAssets>(_onWatch);
    on<CreateAsset>(_onCreate);
    on<UpdateAsset>(_onUpdate);
    on<DeleteAsset>(_onDelete);
  }

  void _onWatch(WatchAssets event, Emitter<AssetState> emit) {
    emit(const AssetsLoading());
    _sub?.cancel();
    _sub = _repository.watchAssets().listen(
      (list) => emit(AssetsLoaded(assets: list)),
      onError: (e) => emit(AssetsError(message: e.toString())),
    );
  }

  Future<void> _onCreate(CreateAsset event, Emitter<AssetState> emit) async {
    try { await _repository.createAsset(event.asset); }
    catch (e) { emit(AssetsError(message: e.toString())); }
  }

  Future<void> _onUpdate(UpdateAsset event, Emitter<AssetState> emit) async {
    try { await _repository.updateAsset(event.asset); }
    catch (e) { emit(AssetsError(message: e.toString())); }
  }

  Future<void> _onDelete(DeleteAsset event, Emitter<AssetState> emit) async {
    try { await _repository.deleteAsset(event.id); }
    catch (e) { emit(AssetsError(message: e.toString())); }
  }

  @override Future<void> close() { _sub?.cancel(); return super.close(); }
}

// Events
abstract class AssetEvent extends Equatable { const AssetEvent(); @override List<Object?> get props => []; }
class WatchAssets extends AssetEvent { const WatchAssets(); }
class CreateAsset extends AssetEvent { final AssetModel asset; const CreateAsset({required this.asset}); @override List<Object?> get props => [asset]; }
class UpdateAsset extends AssetEvent { final AssetModel asset; const UpdateAsset({required this.asset}); @override List<Object?> get props => [asset]; }
class DeleteAsset extends AssetEvent { final String id; const DeleteAsset({required this.id}); @override List<Object?> get props => [id]; }

// States
abstract class AssetState extends Equatable { const AssetState(); @override List<Object?> get props => []; }
class AssetsLoading extends AssetState { const AssetsLoading(); }
class AssetsLoaded extends AssetState { final List<AssetModel> assets; const AssetsLoaded({required this.assets}); @override List<Object?> get props => [assets]; }
class AssetsError extends AssetState { final String message; const AssetsError({required this.message}); @override List<Object?> get props => [message]; }