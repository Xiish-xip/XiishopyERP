/// Xiishopy ERP - CRM Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/lead_model.dart';
import '../data/models/opportunity_model.dart';
import '../data/repositories/crm_repository.dart';

// ── Events ──
abstract class CrmEvent extends Equatable {
  const CrmEvent();
  @override
  List<Object?> get props => [];
}

class WatchLeads extends CrmEvent { const WatchLeads(); }
class CreateLead extends CrmEvent { final LeadModel lead; const CreateLead({required this.lead}); @override List<Object?> get props => [lead]; }
class UpdateLead extends CrmEvent { final LeadModel lead; const UpdateLead({required this.lead}); @override List<Object?> get props => [lead]; }
class DeleteLead extends CrmEvent { final String leadId; const DeleteLead({required this.leadId}); @override List<Object?> get props => [leadId]; }

class WatchOpportunities extends CrmEvent { const WatchOpportunities(); }
class CreateOpportunity extends CrmEvent { final OpportunityModel opportunity; const CreateOpportunity({required this.opportunity}); @override List<Object?> get props => [opportunity]; }
class UpdateOpportunity extends CrmEvent { final OpportunityModel opportunity; const UpdateOpportunity({required this.opportunity}); @override List<Object?> get props => [opportunity]; }
class CloseOpportunity extends CrmEvent { final String id; final String stage; const CloseOpportunity({required this.id, required this.stage}); @override List<Object?> get props => [id, stage]; }

class WatchCampaigns extends CrmEvent { const WatchCampaigns(); }
class CreateCampaign extends CrmEvent { final CampaignModel campaign; const CreateCampaign({required this.campaign}); @override List<Object?> get props => [campaign]; }
class UpdateCampaign extends CrmEvent { final CampaignModel campaign; const UpdateCampaign({required this.campaign}); @override List<Object?> get props => [campaign]; }
class SwitchCrmTab extends CrmEvent { final int tabIndex; const SwitchCrmTab({required this.tabIndex}); @override List<Object?> get props => [tabIndex]; }
class CrmError extends CrmEvent { final String message; const CrmError({required this.message}); @override List<Object?> get props => [message]; }

// ── States ──
abstract class CrmState extends Equatable {
  final int selectedTab;
  const CrmState({this.selectedTab = 0});
  @override List<Object?> get props => [selectedTab];
}
class CrmInitial extends CrmState { const CrmInitial({super.selectedTab = 0}); }
class CrmLoading extends CrmState { const CrmLoading({super.selectedTab = 0}); }
class CrmLeadsLoaded extends CrmState {
  final List<LeadModel> leads;
  const CrmLeadsLoaded({required this.leads, super.selectedTab = 0});
  @override List<Object?> get props => [leads, selectedTab];
}
class CrmOpportunitiesLoaded extends CrmState {
  final List<OpportunityModel> opportunities;
  const CrmOpportunitiesLoaded({required this.opportunities, super.selectedTab = 1});
  @override List<Object?> get props => [opportunities, selectedTab];
}
class CrmCampaignsLoaded extends CrmState {
  final List<CampaignModel> campaigns;
  const CrmCampaignsLoaded({required this.campaigns, super.selectedTab = 2});
  @override List<Object?> get props => [campaigns, selectedTab];
}
class CrmErrorState extends CrmState {
  final String message;
  const CrmErrorState({required this.message, super.selectedTab = 0});
  @override List<Object?> get props => [message, selectedTab];
}

class CrmBloc extends Bloc<CrmEvent, CrmState> {
  final CrmRepository _repository;
  StreamSubscription? _leadsSub;
  StreamSubscription? _opportunitiesSub;
  StreamSubscription? _campaignsSub;

  CrmBloc({required CrmRepository repository})
      : _repository = repository,
        super(const CrmInitial()) {
    on<WatchLeads>(_onWatchLeads);
    on<CreateLead>(_onCreateLead);
    on<UpdateLead>(_onUpdateLead);
    on<DeleteLead>(_onDeleteLead);
    on<WatchOpportunities>(_onWatchOpportunities);
    on<CreateOpportunity>(_onCreateOpportunity);
    on<UpdateOpportunity>(_onUpdateOpportunity);
    on<CloseOpportunity>(_onCloseOpportunity);
    on<WatchCampaigns>(_onWatchCampaigns);
    on<CreateCampaign>(_onCreateCampaign);
    on<UpdateCampaign>(_onUpdateCampaign);
    on<SwitchCrmTab>(_onSwitchTab);
    on<CrmError>(_onError);
  }

  void _onWatchLeads(WatchLeads event, Emitter<CrmState> emit) {
    emit(CrmLoading(selectedTab: state.selectedTab));
    _leadsSub?.cancel();
    _leadsSub = _repository.watchLeads().listen(
      (leads) { if (!emit.isDone) emit(CrmLeadsLoaded(leads: leads, selectedTab: state.selectedTab)); },
      onError: (e) { if (!emit.isDone) add(CrmError(message: e.toString())); },
    );
  }

  Future<void> _onCreateLead(CreateLead event, Emitter<CrmState> emit) async {
    try { await _repository.createLead(event.lead); } catch (e) { add(CrmError(message: 'Failed to create lead: $e')); }
  }

  Future<void> _onUpdateLead(UpdateLead event, Emitter<CrmState> emit) async {
    try { await _repository.updateLead(event.lead); } catch (e) { add(CrmError(message: 'Failed to update lead: $e')); }
  }

  Future<void> _onDeleteLead(DeleteLead event, Emitter<CrmState> emit) async {
    try { await _repository.deleteLead(event.leadId); } catch (e) { add(CrmError(message: 'Failed to delete lead: $e')); }
  }

  void _onWatchOpportunities(WatchOpportunities event, Emitter<CrmState> emit) {
    emit(CrmLoading(selectedTab: state.selectedTab));
    _opportunitiesSub?.cancel();
    _opportunitiesSub = _repository.watchOpportunities().listen(
      (opportunities) { if (!emit.isDone) emit(CrmOpportunitiesLoaded(opportunities: opportunities, selectedTab: state.selectedTab)); },
      onError: (e) { if (!emit.isDone) add(CrmError(message: e.toString())); },
    );
  }

  Future<void> _onCreateOpportunity(CreateOpportunity event, Emitter<CrmState> emit) async {
    try { await _repository.createOpportunity(event.opportunity); } catch (e) { add(CrmError(message: 'Failed to create opportunity: $e')); }
  }

  Future<void> _onUpdateOpportunity(UpdateOpportunity event, Emitter<CrmState> emit) async {
    try { await _repository.updateOpportunity(event.opportunity); } catch (e) { add(CrmError(message: 'Failed to update opportunity: $e')); }
  }

  Future<void> _onCloseOpportunity(CloseOpportunity event, Emitter<CrmState> emit) async {
    try { await _repository.closeOpportunity(event.id, event.stage); } catch (e) { add(CrmError(message: 'Failed to close opportunity: $e')); }
  }

  void _onWatchCampaigns(WatchCampaigns event, Emitter<CrmState> emit) {
    emit(CrmLoading(selectedTab: state.selectedTab));
    _campaignsSub?.cancel();
    _campaignsSub = _repository.watchCampaigns().listen(
      (campaigns) { if (!emit.isDone) emit(CrmCampaignsLoaded(campaigns: campaigns, selectedTab: state.selectedTab)); },
      onError: (e) { if (!emit.isDone) add(CrmError(message: e.toString())); },
    );
  }

  Future<void> _onCreateCampaign(CreateCampaign event, Emitter<CrmState> emit) async {
    try { await _repository.createCampaign(event.campaign); } catch (e) { add(CrmError(message: 'Failed to create campaign: $e')); }
  }

  Future<void> _onUpdateCampaign(UpdateCampaign event, Emitter<CrmState> emit) async {
    try { await _repository.updateCampaign(event.campaign); } catch (e) { add(CrmError(message: 'Failed to update campaign: $e')); }
  }

  void _onSwitchTab(SwitchCrmTab event, Emitter<CrmState> emit) {
    emit(CrmLoading(selectedTab: event.tabIndex));
    switch (event.tabIndex) {
      case 0: add(const WatchLeads()); break;
      case 1: add(const WatchOpportunities()); break;
      case 2: add(const WatchCampaigns()); break;
    }
  }

  void _onError(CrmError event, Emitter<CrmState> emit) {
    emit(CrmErrorState(message: event.message, selectedTab: state.selectedTab));
  }

  @override
  Future<void> close() {
    _leadsSub?.cancel(); _opportunitiesSub?.cancel(); _campaignsSub?.cancel();
    return super.close();
  }
}