/// Xiishopy ERP - Projects Remote Data Source
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';

class ProjectRemoteDataSource {
  final FirebaseFirestore _firestore;
  ProjectRemoteDataSource({required FirebaseFirestore firestore}) : _firestore = firestore;

  Stream<List<ProjectModel>> watchProjects() {
    return _firestore.collection('projects').orderBy('createdAt', descending: true).snapshots()
        .map((s) => s.docs.map((d) => ProjectModel.fromFirestore(d.data() as Map<String, dynamic>, d.id)).toList());
  }

  Future<void> createProject(ProjectModel project) async {
    final doc = _firestore.collection('projects').doc();
    await doc.set(project.toFirestore());
  }

  Future<void> updateProject(ProjectModel project) async {
    await _firestore.collection('projects').doc(project.id).update(project.toFirestore());
  }

  Future<void> deleteProject(String id) async {
    await _firestore.collection('projects').doc(id).update({'status': 'Cancelled', 'updatedAt': FieldValue.serverTimestamp()});
  }
}