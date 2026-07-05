/// Xiishopy ERP - Projects Repository
library;

import 'dart:async';
import '../datasources/project_remote_datasource.dart';
import '../models/project_model.dart';

class ProjectRepository {
  final ProjectRemoteDataSource _remoteDataSource;
  ProjectRepository({required ProjectRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  Stream<List<ProjectModel>> watchProjects() => _remoteDataSource.watchProjects();
  Future<void> createProject(ProjectModel project) => _remoteDataSource.createProject(project);
  Future<void> updateProject(ProjectModel project) => _remoteDataSource.updateProject(project);
  Future<void> deleteProject(String id) => _remoteDataSource.deleteProject(id);
}