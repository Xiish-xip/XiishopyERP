/// Xiishopy ERP - Project Bloc
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/project_model.dart';
import '../data/repositories/project_repository.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository _repository;
  StreamSubscription? _sub;

  ProjectBloc({required ProjectRepository repository})
      : _repository = repository,
        super(const ProjectsLoading()) {
    on<WatchProjects>(_onWatch);
    on<CreateProject>(_onCreate);
    on<UpdateProject>(_onUpdate);
    on<DeleteProject>(_onDelete);
  }

  void _onWatch(WatchProjects event, Emitter<ProjectState> emit) {
    emit(const ProjectsLoading());
    _sub?.cancel();
    _sub = _repository.watchProjects().listen(
      (list) => emit(ProjectsLoaded(projects: list)),
      onError: (e) => emit(ProjectsError(message: e.toString())),
    );
  }

  Future<void> _onCreate(CreateProject event, Emitter<ProjectState> emit) async {
    try { await _repository.createProject(event.project); }
    catch (e) { emit(ProjectsError(message: e.toString())); }
  }

  Future<void> _onUpdate(UpdateProject event, Emitter<ProjectState> emit) async {
    try { await _repository.updateProject(event.project); }
    catch (e) { emit(ProjectsError(message: e.toString())); }
  }

  Future<void> _onDelete(DeleteProject event, Emitter<ProjectState> emit) async {
    try { await _repository.deleteProject(event.id); }
    catch (e) { emit(ProjectsError(message: e.toString())); }
  }

  @override Future<void> close() { _sub?.cancel(); return super.close(); }
}

// Events
abstract class ProjectEvent extends Equatable { const ProjectEvent(); @override List<Object?> get props => []; }
class WatchProjects extends ProjectEvent { const WatchProjects(); }
class CreateProject extends ProjectEvent { final ProjectModel project; const CreateProject({required this.project}); @override List<Object?> get props => [project]; }
class UpdateProject extends ProjectEvent { final ProjectModel project; const UpdateProject({required this.project}); @override List<Object?> get props => [project]; }
class DeleteProject extends ProjectEvent { final String id; const DeleteProject({required this.id}); @override List<Object?> get props => [id]; }

// States
abstract class ProjectState extends Equatable { const ProjectState(); @override List<Object?> get props => []; }
class ProjectsLoading extends ProjectState { const ProjectsLoading(); }
class ProjectsLoaded extends ProjectState { final List<ProjectModel> projects; const ProjectsLoaded({required this.projects}); @override List<Object?> get props => [projects]; }
class ProjectsError extends ProjectState { final String message; const ProjectsError({required this.message}); @override List<Object?> get props => [message]; }