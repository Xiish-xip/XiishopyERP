/// Xiishopy ERP - CRM Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lead_model.dart';
import '../models/opportunity_model.dart';

class CrmRemoteDataSource {
  final FirebaseFirestore _firestore;

  CrmRemoteDataSource({required FirebaseFirestore firestore}) : _firestore = firestore;

  // ── Leads ──
  Stream<List<LeadModel>> watchLeads() {
    return _firestore
        .collection('leads')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LeadModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createLead(LeadModel lead) async {
    final doc = _firestore.collection('leads').doc();
    await doc.set(lead.toFirestore());
  }

  Future<void> updateLead(LeadModel lead) async {
    await _firestore.collection('leads').doc(lead.id).update(lead.toFirestore());
  }

  Future<void> deleteLead(String id) async {
    await _firestore.collection('leads').doc(id).update({'status': 'Deleted', 'updatedAt': FieldValue.serverTimestamp()});
  }

  // ── Opportunities ──
  Stream<List<OpportunityModel>> watchOpportunities() {
    return _firestore
        .collection('opportunities')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OpportunityModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createOpportunity(OpportunityModel opportunity) async {
    final doc = _firestore.collection('opportunities').doc();
    await doc.set(opportunity.toFirestore());
  }

  Future<void> updateOpportunity(OpportunityModel opportunity) async {
    await _firestore.collection('opportunities').doc(opportunity.id).update(opportunity.toFirestore());
  }

  Future<void> closeOpportunity(String id, String stage) async {
    await _firestore.collection('opportunities').doc(id).update({
      'stage': stage,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Campaigns ──
  Stream<List<CampaignModel>> watchCampaigns() {
    return _firestore
        .collection('campaigns')
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CampaignModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> createCampaign(CampaignModel campaign) async {
    final doc = _firestore.collection('campaigns').doc();
    await doc.set(campaign.toFirestore());
  }

  Future<void> updateCampaign(CampaignModel campaign) async {
    await _firestore.collection('campaigns').doc(campaign.id).update(campaign.toFirestore());
  }
}