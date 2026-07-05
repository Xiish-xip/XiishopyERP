/// Xiishopy ERP - Admin Configuration Model
library;

import 'package:cloud_firestore/cloud_firestore.dart';

class AdminConfigModel {
  final Map<String, ModuleConfig> modules;
  final Map<String, dynamic> businessRules;
  final DateTime updatedAt;

  AdminConfigModel({
    required this.modules,
    required this.businessRules,
    required this.updatedAt,
  });

  factory AdminConfigModel.fromJson(Map<String, dynamic> json, String id) {
    final modulesJson = json['modules'] as Map<String, dynamic>? ?? {};
    final modules = modulesJson.map((key, value) =>
        MapEntry(key, ModuleConfig.fromJson(value as Map<String, dynamic>)));

    return AdminConfigModel(
      modules: modules,
      businessRules: json['businessRules'] as Map<String, dynamic>? ?? {},
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'modules': modules.map((key, value) => MapEntry(key, value.toJson())),
        'businessRules': businessRules,
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class ModuleConfig {
  final bool enabled;
  final Map<String, dynamic> features;

  ModuleConfig({required this.enabled, required this.features});

  factory ModuleConfig.fromJson(Map<String, dynamic> json) => ModuleConfig(
        enabled: json['enabled'] as bool? ?? false,
        features: json['features'] as Map<String, dynamic>? ?? {},
      );

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'features': features,
      };
}