/// Xiishopy ERP - Manufacturing Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/manufacturing_model.dart';
import '../data/repositories/manufacturing_repository.dart';

abstract class ManufacturingEvent extends Equatable {
  const ManufacturingEvent();
  @override List<Object?> get props => [];
}
class WatchBoms extends ManufacturingEvent { const WatchBoms(); }
class CreateBom extends ManufacturingEvent { final BOMModel bom; const CreateBom({required this.bom}); @override List<Object?> get props => [bom]; }
class UpdateBom extends ManufacturingEvent { final BOMModel bom; const UpdateBom({required this.bom}); @override List<Object?> get props => [bom]; }
class WatchWorkOrders extends ManufacturingEvent { const WatchWorkOrders(); }
class CreateWorkOrder extends ManufacturingEvent { final WorkOrderModel order; const CreateWorkOrder({required this.order}); @override List<Object?> get props => [order]; }
class UpdateWorkOrderStatus extends ManufacturingEvent { final String id; final String status; const UpdateWorkOrderStatus({required this.id, required this.status}); @override List<Object?> get props => [id, status]; }
class WatchProductionPlans extends ManufacturingEvent { const WatchProductionPlans(); }
class CreateProductionPlan extends ManufacturingEvent { final ProductionPlanModel plan; const CreateProductionPlan({required this.plan}); @override List<Object?> get props => [plan]; }
class UpdateProductionPlan extends ManufacturingEvent { final ProductionPlanModel plan; const UpdateProductionPlan({required this.plan}); @override List<Object?> get props => [plan]; }
class SwitchMfgTab extends ManufacturingEvent { final int tabIndex; const SwitchMfgTab({required this.tabIndex}); @override List<Object?> get props => [tabIndex]; }
class ManufacturingError extends ManufacturingEvent { final String message; const ManufacturingError({required this.message}); @override List<Object?> get props => [message]; }

abstract class ManufacturingState extends Equatable {
  final int selectedTab;
  const ManufacturingState({this.selectedTab = 0});
  @override List<Object?> get props => [selectedTab];
}
class ManufacturingInitial extends ManufacturingState { const ManufacturingInitial({super.selectedTab = 0}); }
class ManufacturingLoading extends ManufacturingState { const ManufacturingLoading({super.selectedTab = 0}); }
class BomsLoaded extends ManufacturingState {
  final List<BOMModel> boms;
  const BomsLoaded({required this.boms, super.selectedTab = 0});
  @override List<Object?> get props => [boms, selectedTab];
}
class WorkOrdersLoaded extends ManufacturingState {
  final List<WorkOrderModel> orders;
  const WorkOrdersLoaded({required this.orders, super.selectedTab = 1});
  @override List<Object?> get props => [orders, selectedTab];
}
class ProductionPlansLoaded extends ManufacturingState {
  final List<ProductionPlanModel> plans;
  const ProductionPlansLoaded({required this.plans, super.selectedTab = 2});
  @override List<Object?> get props => [plans, selectedTab];
}
class ManufacturingErrorState extends ManufacturingState {
  final String message;
  const ManufacturingErrorState({required this.message, super.selectedTab = 0});
  @override List<Object?> get props => [message, selectedTab];
}

class ManufacturingBloc extends Bloc<ManufacturingEvent, ManufacturingState> {
  final ManufacturingRepository _repository;
  StreamSubscription? _bomsSub;
  StreamSubscription? _ordersSub;
  StreamSubscription? _plansSub;

  ManufacturingBloc({required ManufacturingRepository repository})
      : _repository = repository,
        super(const ManufacturingInitial()) {
    on<WatchBoms>(_onWatchBoms);
    on<CreateBom>(_onCreateBom);
    on<UpdateBom>(_onUpdateBom);
    on<WatchWorkOrders>(_onWatchWorkOrders);
    on<CreateWorkOrder>(_onCreateWorkOrder);
    on<UpdateWorkOrderStatus>(_onUpdateWorkOrderStatus);
    on<WatchProductionPlans>(_onWatchProductionPlans);
    on<CreateProductionPlan>(_onCreateProductionPlan);
    on<UpdateProductionPlan>(_onUpdateProductionPlan);
    on<SwitchMfgTab>(_onSwitchTab);
    on<ManufacturingError>(_onError);
  }

  void _onWatchBoms(WatchBoms event, Emitter<ManufacturingState> emit) {
    emit(ManufacturingLoading(selectedTab: state.selectedTab));
    _bomsSub?.cancel();
    _bomsSub = _repository.watchBoms().listen(
      (boms) { if (!emit.isDone) emit(BomsLoaded(boms: boms, selectedTab: state.selectedTab)); },
      onError: (e) { if (!emit.isDone) add(ManufacturingError(message: e.toString())); },
    );
  }

  Future<void> _onCreateBom(CreateBom event, Emitter<ManufacturingState> emit) async {
    try { await _repository.createBom(event.bom); } catch (e) { add(ManufacturingError(message: 'Failed to create BOM: $e')); }
  }

  Future<void> _onUpdateBom(UpdateBom event, Emitter<ManufacturingState> emit) async {
    try { await _repository.updateBom(event.bom); } catch (e) { add(ManufacturingError(message: 'Failed to update BOM: $e')); }
  }

  void _onWatchWorkOrders(WatchWorkOrders event, Emitter<ManufacturingState> emit) {
    emit(ManufacturingLoading(selectedTab: state.selectedTab));
    _ordersSub?.cancel();
    _ordersSub = _repository.watchWorkOrders().listen(
      (orders) { if (!emit.isDone) emit(WorkOrdersLoaded(orders: orders, selectedTab: state.selectedTab)); },
      onError: (e) { if (!emit.isDone) add(ManufacturingError(message: e.toString())); },
    );
  }

  Future<void> _onCreateWorkOrder(CreateWorkOrder event, Emitter<ManufacturingState> emit) async {
    try { await _repository.createWorkOrder(event.order); } catch (e) { add(ManufacturingError(message: 'Failed to create work order: $e')); }
  }

  Future<void> _onUpdateWorkOrderStatus(UpdateWorkOrderStatus event, Emitter<ManufacturingState> emit) async {
    try { await _repository.updateWorkOrderStatus(event.id, event.status); } catch (e) { add(ManufacturingError(message: 'Failed to update work order: $e')); }
  }

  void _onWatchProductionPlans(WatchProductionPlans event, Emitter<ManufacturingState> emit) {
    emit(ManufacturingLoading(selectedTab: state.selectedTab));
    _plansSub?.cancel();
    _plansSub = _repository.watchProductionPlans().listen(
      (plans) { if (!emit.isDone) emit(ProductionPlansLoaded(plans: plans, selectedTab: state.selectedTab)); },
      onError: (e) { if (!emit.isDone) add(ManufacturingError(message: e.toString())); },
    );
  }

  Future<void> _onCreateProductionPlan(CreateProductionPlan event, Emitter<ManufacturingState> emit) async {
    try { await _repository.createProductionPlan(event.plan); } catch (e) { add(ManufacturingError(message: 'Failed to create production plan: $e')); }
  }

  Future<void> _onUpdateProductionPlan(UpdateProductionPlan event, Emitter<ManufacturingState> emit) async {
    try { await _repository.updateProductionPlan(event.plan); } catch (e) { add(ManufacturingError(message: 'Failed to update production plan: $e')); }
  }

  void _onSwitchTab(SwitchMfgTab event, Emitter<ManufacturingState> emit) {
    emit(ManufacturingLoading(selectedTab: event.tabIndex));
    switch (event.tabIndex) {
      case 0: add(const WatchBoms()); break;
      case 1: add(const WatchWorkOrders()); break;
      case 2: add(const WatchProductionPlans()); break;
    }
  }

  void _onError(ManufacturingError event, Emitter<ManufacturingState> emit) {
    emit(ManufacturingErrorState(message: event.message, selectedTab: state.selectedTab));
  }

  @override
  Future<void> close() {
    _bomsSub?.cancel(); _ordersSub?.cancel(); _plansSub?.cancel();
    return super.close();
  }
}