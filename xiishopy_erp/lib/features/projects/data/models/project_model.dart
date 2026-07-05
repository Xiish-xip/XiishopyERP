/// Xiishopy ERP - Project Model
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class ProjectModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String status; // Planning, In Progress, On Hold, Completed, Cancelled
  final String priority; // Low, Medium, High, Critical
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? deadline;
  final double budget;
  final double spent;
  final String? assignedTo;
  final String? assignedToName;
  final List<String> teamMembers;
  final List<ProjectTask> tasks;
  final double progress; // 0.0 - 100.0
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    this.status = 'Planning',
    this.priority = 'Medium',
    required this.startDate,
    this.endDate,
    this.deadline,
    this.budget = 0.0,
    this.spent = 0.0,
    this.assignedTo,
    this.assignedToName,
    this.teamMembers = const [],
    this.tasks = const [],
    this.progress = 0.0,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ProjectModel(
      id: docId,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      status: data['status'] as String? ?? 'Planning',
      priority: data['priority'] as String? ?? 'Medium',
      startDate: safeToDate(data['startDate']),
      endDate: safeToDate(data['endDate']),
      deadline: safeToDate(data['deadline']),
      budget: (data['budget'] as num?)?.toDouble() ?? 0.0,
      spent: (data['spent'] as num?)?.toDouble() ?? 0.0,
      assignedTo: data['assignedTo'] as String?,
      assignedToName: data['assignedToName'] as String?,
      teamMembers: (data['teamMembers'] as List<dynamic>?)?.cast<String>() ?? [],
      tasks: (data['tasks'] as List<dynamic>?)
              ?.map((e) => ProjectTask.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      progress: (data['progress'] as num?)?.toDouble() ?? 0.0,
      notes: data['notes'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'description': description,
    'status': status,
    'priority': priority,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'deadline': deadline?.toIso8601String(),
    'budget': budget,
    'spent': spent,
    'assignedTo': assignedTo,
    'assignedToName': assignedToName,
    'teamMembers': teamMembers,
    'tasks': tasks.map((e) => e.toJson()).toList(),
    'progress': progress,
    'notes': notes,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, name, status, priority, progress];
}

class ProjectTask extends Equatable {
  final String id;
  final String title;
  final String? assignedTo;
  final String status; // Todo, In Progress, Done
  final String priority;
  final DateTime? dueDate;

  const ProjectTask({
    this.id = '',
    required this.title,
    this.assignedTo,
    this.status = 'Todo',
    this.priority = 'Medium',
    this.dueDate,
  });

  factory ProjectTask.fromJson(Map<String, dynamic> json) => ProjectTask(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    assignedTo: json['assignedTo'] as String?,
    status: json['status'] as String? ?? 'Todo',
    priority: json['priority'] as String? ?? 'Medium',
    dueDate: safeToDate(json['dueDate']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'assignedTo': assignedTo,
    'status': status,
    'priority': priority,
    'dueDate': dueDate?.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, title, status];
}