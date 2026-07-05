/// Xiishopy ERP - Manufacturing Repository
library;

import '../datasources/manufacturing_remote_datasource.dart';
import '../models/manufacturing_model.dart';

class ManufacturingRepository {
  final ManufacturingRemoteDataSource _remoteDataSource;
  ManufacturingRepository({required ManufacturingRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  Stream<List<BOMModel>> watchBoms() => _remoteDataSource.watchBoms();
  Future<void> createBom(BOMModel bom) => _remoteDataSource.createBom(bom);
  Future<void> updateBom(BOMModel bom) => _remoteDataSource.updateBom(bom);

  Stream<List<WorkOrderModel>> watchWorkOrders() => _remoteDataSource.watchWorkOrders();
  Future<void> createWorkOrder(WorkOrderModel order) => _remoteDataSource.createWorkOrder(order);
  Future<void> updateWorkOrderStatus(String id, String status) => _remoteDataSource.updateWorkOrderStatus(id, status);

  Stream<List<ProductionPlanModel>> watchProductionPlans() => _remoteDataSource.watchProductionPlans();
  Future<void> createProductionPlan(ProductionPlanModel plan) => _remoteDataSource.createProductionPlan(plan);
  Future<void> updateProductionPlan(ProductionPlanModel plan) => _remoteDataSource.updateProductionPlan(plan);
}