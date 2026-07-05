/// Xiishopy ERP - Manufacturing Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/manufacturing_model.dart';

class ManufacturingRemoteDataSource {
  final FirebaseFirestore _firestore;

  ManufacturingRemoteDataSource({required FirebaseFirestore firestore}) : _firestore = firestore;

  // ── BOM ──
  Stream<List<BOMModel>> watchBoms() {
    return _firestore
        .collection('bom')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BOMModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createBom(BOMModel bom) async {
    final doc = _firestore.collection('bom').doc();
    await doc.set(bom.toFirestore());
  }

  Future<void> updateBom(BOMModel bom) async {
    await _firestore.collection('bom').doc(bom.id).update(bom.toFirestore());
  }

  // ── Work Orders ──
  Stream<List<WorkOrderModel>> watchWorkOrders() {
    return _firestore
        .collection('work_orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkOrderModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createWorkOrder(WorkOrderModel order) async {
    final doc = _firestore.collection('work_orders').doc();
    await doc.set(order.toFirestore());
  }

  Future<void> updateWorkOrderStatus(String id, String status) async {
    await _firestore.collection('work_orders').doc(id).update({
      'status': status,
      if (status == 'Completed') 'completedDate': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Production Plans ──
  Stream<List<ProductionPlanModel>> watchProductionPlans() {
    return _firestore
        .collection('production_plans')
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductionPlanModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createProductionPlan(ProductionPlanModel plan) async {
    final doc = _firestore.collection('production_plans').doc();
    await doc.set(plan.toFirestore());
  }

  Future<void> updateProductionPlan(ProductionPlanModel plan) async {
    await _firestore.collection('production_plans').doc(plan.id).update(plan.toFirestore());
  }
}