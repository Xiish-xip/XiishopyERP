/// Xiishopy ERP - Firebase Remote Configuration Service
/// Enables dynamic app configuration without code changes.
library;

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;
  bool _initialized = false;

  RemoteConfigService({FirebaseRemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.setDefaults(const {
      'enable_barcode_scanning': true,
      'enable_offline_mode': true,
      'enable_biometric_auth': false,
      'default_currency': 'TZS',
      'default_language': 'en',
      'low_stock_threshold': 10,
      'app_theme_primary_color': '#0F3460',
      'app_theme_accent_color': '#E94560',
      'max_upload_image_size_mb': 5,
      'enable_audit_trail': true,
      'session_timeout_minutes': 60,
    });
    await _remoteConfig.fetchAndActivate();
    _initialized = true;
  }

  bool get isInitialized => _initialized;

  bool getBool(String key) => _remoteConfig.getBool(key);
  String getString(String key) => _remoteConfig.getString(key);
  int getInt(String key) => _remoteConfig.getInt(key);
  double getDouble(String key) => _remoteConfig.getDouble(key);

  Future<bool> fetchAndActivate() => _remoteConfig.fetchAndActivate();
}