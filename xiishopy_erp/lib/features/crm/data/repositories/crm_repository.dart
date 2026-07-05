/// Xiishopy ERP - CRM Repository
library;

import '../datasources/crm_remote_datasource.dart';
import '../models/lead_model.dart';
import '../models/opportunity_model.dart';

class CrmRepository {
  final CrmRemoteDataSource _remoteDataSource;

  CrmRepository({required CrmRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Stream<List<LeadModel>> watchLeads() => _remoteDataSource.watchLeads();
  Future<void> createLead(LeadModel lead) => _remoteDataSource.createLead(lead);
  Future<void> updateLead(LeadModel lead) => _remoteDataSource.updateLead(lead);
  Future<void> deleteLead(String id) => _remoteDataSource.deleteLead(id);

  Stream<List<OpportunityModel>> watchOpportunities() => _remoteDataSource.watchOpportunities();
  Future<void> createOpportunity(OpportunityModel opportunity) => _remoteDataSource.createOpportunity(opportunity);
  Future<void> updateOpportunity(OpportunityModel opportunity) => _remoteDataSource.updateOpportunity(opportunity);
  Future<void> closeOpportunity(String id, String stage) => _remoteDataSource.closeOpportunity(id, stage);

  Stream<List<CampaignModel>> watchCampaigns() => _remoteDataSource.watchCampaigns();
  Future<void> createCampaign(CampaignModel campaign) => _remoteDataSource.createCampaign(campaign);
  Future<void> updateCampaign(CampaignModel campaign) => _remoteDataSource.updateCampaign(campaign);
}