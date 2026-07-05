/// Xiishopy ERP - DMS Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/document_model.dart';
import '../data/repositories/dms_repository.dart';

abstract class DmsEvent extends Equatable {
  const DmsEvent();
  @override List<Object?> get props => [];
}
class WatchDocuments extends DmsEvent { const WatchDocuments(); }
class CreateDocument extends DmsEvent { final DocumentModel document; const CreateDocument({required this.document}); @override List<Object?> get props => [document]; }
class UpdateDocument extends DmsEvent { final DocumentModel document; const UpdateDocument({required this.document}); @override List<Object?> get props => [document]; }
class ArchiveDocument extends DmsEvent { final String id; const ArchiveDocument({required this.id}); @override List<Object?> get props => [id]; }
class DeleteDocument extends DmsEvent { final String id; const DeleteDocument({required this.id}); @override List<Object?> get props => [id]; }
class WatchTemplates extends DmsEvent { const WatchTemplates(); }
class CreateTemplate extends DmsEvent { final DocumentTemplateModel template; const CreateTemplate({required this.template}); @override List<Object?> get props => [template]; }
class UpdateTemplate extends DmsEvent { final DocumentTemplateModel template; const UpdateTemplate({required this.template}); @override List<Object?> get props => [template]; }
class SwitchDmsTab extends DmsEvent { final int tabIndex; const SwitchDmsTab({required this.tabIndex}); @override List<Object?> get props => [tabIndex]; }
class DmsError extends DmsEvent { final String message; const DmsError({required this.message}); @override List<Object?> get props => [message]; }

abstract class DmsState extends Equatable {
  final int selectedTab;
  const DmsState({this.selectedTab = 0});
  @override List<Object?> get props => [selectedTab];
}
class DmsInitial extends DmsState { const DmsInitial({super.selectedTab = 0}); }
class DmsLoading extends DmsState { const DmsLoading({super.selectedTab = 0}); }
class DocumentsLoaded extends DmsState {
  final List<DocumentModel> documents;
  const DocumentsLoaded({required this.documents, super.selectedTab = 0});
  @override List<Object?> get props => [documents, selectedTab];
}
class TemplatesLoaded extends DmsState {
  final List<DocumentTemplateModel> templates;
  const TemplatesLoaded({required this.templates, super.selectedTab = 1});
  @override List<Object?> get props => [templates, selectedTab];
}
class DmsErrorState extends DmsState {
  final String message;
  const DmsErrorState({required this.message, super.selectedTab = 0});
  @override List<Object?> get props => [message, selectedTab];
}

class DmsBloc extends Bloc<DmsEvent, DmsState> {
  final DmsRepository _repository;
  StreamSubscription? _docsSub;
  StreamSubscription? _templatesSub;

  DmsBloc({required DmsRepository repository})
      : _repository = repository,
        super(const DmsInitial()) {
    on<WatchDocuments>(_onWatchDocuments);
    on<CreateDocument>(_onCreateDocument);
    on<UpdateDocument>(_onUpdateDocument);
    on<ArchiveDocument>(_onArchiveDocument);
    on<DeleteDocument>(_onDeleteDocument);
    on<WatchTemplates>(_onWatchTemplates);
    on<CreateTemplate>(_onCreateTemplate);
    on<UpdateTemplate>(_onUpdateTemplate);
    on<SwitchDmsTab>(_onSwitchTab);
    on<DmsError>(_onError);
  }

  void _onWatchDocuments(WatchDocuments event, Emitter<DmsState> emit) {
    emit(DmsLoading(selectedTab: state.selectedTab));
    _docsSub?.cancel();
    _docsSub = _repository.watchDocuments().listen(
      (documents) { if (!emit.isDone) emit(DocumentsLoaded(documents: documents, selectedTab: state.selectedTab)); },
      onError: (e) { if (!emit.isDone) add(DmsError(message: e.toString())); },
    );
  }

  Future<void> _onCreateDocument(CreateDocument event, Emitter<DmsState> emit) async {
    try { await _repository.createDocument(event.document); } catch (e) { add(DmsError(message: 'Failed to create document: $e')); }
  }

  Future<void> _onUpdateDocument(UpdateDocument event, Emitter<DmsState> emit) async {
    try { await _repository.updateDocument(event.document); } catch (e) { add(DmsError(message: 'Failed to update document: $e')); }
  }

  Future<void> _onArchiveDocument(ArchiveDocument event, Emitter<DmsState> emit) async {
    try { await _repository.archiveDocument(event.id); } catch (e) { add(DmsError(message: 'Failed to archive document: $e')); }
  }

  Future<void> _onDeleteDocument(DeleteDocument event, Emitter<DmsState> emit) async {
    try { await _repository.deleteDocument(event.id); } catch (e) { add(DmsError(message: 'Failed to delete document: $e')); }
  }

  void _onWatchTemplates(WatchTemplates event, Emitter<DmsState> emit) {
    emit(DmsLoading(selectedTab: state.selectedTab));
    _templatesSub?.cancel();
    _templatesSub = _repository.watchTemplates().listen(
      (templates) { if (!emit.isDone) emit(TemplatesLoaded(templates: templates, selectedTab: state.selectedTab)); },
      onError: (e) { if (!emit.isDone) add(DmsError(message: e.toString())); },
    );
  }

  Future<void> _onCreateTemplate(CreateTemplate event, Emitter<DmsState> emit) async {
    try { await _repository.createTemplate(event.template); } catch (e) { add(DmsError(message: 'Failed to create template: $e')); }
  }

  Future<void> _onUpdateTemplate(UpdateTemplate event, Emitter<DmsState> emit) async {
    try { await _repository.updateTemplate(event.template); } catch (e) { add(DmsError(message: 'Failed to update template: $e')); }
  }

  void _onSwitchTab(SwitchDmsTab event, Emitter<DmsState> emit) {
    emit(DmsLoading(selectedTab: event.tabIndex));
    switch (event.tabIndex) {
      case 0: add(const WatchDocuments()); break;
      case 1: add(const WatchTemplates()); break;
    }
  }

  void _onError(DmsError event, Emitter<DmsState> emit) {
    emit(DmsErrorState(message: event.message, selectedTab: state.selectedTab));
  }

  @override
  Future<void> close() {
    _docsSub?.cancel(); _templatesSub?.cancel();
    return super.close();
  }
}