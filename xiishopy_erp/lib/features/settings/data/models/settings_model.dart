/// Xiishopy ERP - Settings Model
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class SettingsModel extends Equatable {
  final Map<String, dynamic> companyProfile;
  final Map<String, dynamic> businessRules;
  final Map<String, dynamic> paymentConfig;
  final Map<String, dynamic> shippingConfig;
  final Map<String, dynamic> notificationRules;
  final Map<String, dynamic> taxConfig;
  final Map<String, dynamic> localization;
  final Map<String, dynamic> security;
  final Map<String, dynamic> uiTheme;
  final DateTime updatedAt;

  const SettingsModel({
    this.companyProfile = const {},
    this.businessRules = const {},
    this.paymentConfig = const {},
    this.shippingConfig = const {},
    this.notificationRules = const {},
    this.taxConfig = const {},
    this.localization = const {},
    this.security = const {},
    this.uiTheme = const {},
    required this.updatedAt,
  });

  factory SettingsModel.fromFirestore(Map<String, dynamic> data) {
    return SettingsModel(
      companyProfile: data['companyProfile'] as Map<String, dynamic>? ?? {},
      businessRules: data['businessRules'] as Map<String, dynamic>? ?? {},
      paymentConfig: data['paymentConfig'] as Map<String, dynamic>? ?? {},
      shippingConfig: data['shippingConfig'] as Map<String, dynamic>? ?? {},
      notificationRules: data['notificationRules'] as Map<String, dynamic>? ?? {},
      taxConfig: data['taxConfig'] as Map<String, dynamic>? ?? {},
      localization: data['localization'] as Map<String, dynamic>? ?? {},
      security: data['security'] as Map<String, dynamic>? ?? {},
      uiTheme: data['uiTheme'] as Map<String, dynamic>? ?? {},
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'companyProfile': companyProfile,
    'businessRules': businessRules,
    'paymentConfig': paymentConfig,
    'shippingConfig': shippingConfig,
    'notificationRules': notificationRules,
    'taxConfig': taxConfig,
    'localization': localization,
    'security': security,
    'uiTheme': uiTheme,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  SettingsModel copyWithCategory(String category, Map<String, dynamic> value) {
    final map = toFirestore();
    map[category] = value;
    return SettingsModel(
      companyProfile: category == 'companyProfile' ? value : companyProfile,
      businessRules: category == 'businessRules' ? value : businessRules,
      paymentConfig: category == 'paymentConfig' ? value : paymentConfig,
      shippingConfig: category == 'shippingConfig' ? value : shippingConfig,
      notificationRules: category == 'notificationRules' ? value : notificationRules,
      taxConfig: category == 'taxConfig' ? value : taxConfig,
      localization: category == 'localization' ? value : localization,
      security: category == 'security' ? value : security,
      uiTheme: category == 'uiTheme' ? value : uiTheme,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [companyProfile, businessRules, paymentConfig];
}