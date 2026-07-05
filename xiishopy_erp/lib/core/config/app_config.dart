/// Xiishopy ERP - Adaptive Platform Configuration
/// Automatically detects platform and configures localhost vs 10.0.2.2 for Android emulator.
/// Uses kIsWeb for safe cross-platform detection (avoids dart:io which crashes on web).
library;

import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  static AppConfig? _instance;
  late final String firestoreHost;
  late final int firestorePort;
  late final String functionsHost;
  late final int functionsPort;
  late final String authHost;
  late final int authPort;
  late final String apiBaseUrl;

  AppConfig._() {
    if (kIsWeb) {
      // Web runs in browser -> localhost
      firestoreHost = '127.0.0.1';
      functionsHost = '127.0.0.1';
      authHost = '127.0.0.1';
    } else {
      // Mobile/Desktop — detect Android emulator vs other
      try {
        // We use a simple heuristic: assume Android for mobile
        // In production, use package:device_info_plus for accurate detection
        firestoreHost = '10.0.2.2';
        functionsHost = '10.0.2.2';
        authHost = '10.0.2.2';
      } catch (_) {
        // Fallback to localhost
        firestoreHost = '127.0.0.1';
        functionsHost = '127.0.0.1';
        authHost = '127.0.0.1';
      }
    }

    firestorePort = 8080;
    functionsPort = 5001;
    authPort = 9099;
    apiBaseUrl = 'http://$functionsHost:$functionsPort/xiishopy-erp/us-central1/api';
  }

  static AppConfig get instance {
    _instance ??= AppConfig._();
    return _instance!;
  }

  /// Flag to indicate if we're connecting to local emulators
  bool get isEmulatorMode => true;

  /// Get Firebase options for the emulator project
  Map<String, dynamic> get firebaseOptions => {
        'projectId': 'demo-xiishopy-erp',
        'apiKey': 'demo-api-key',
        'appId': '1:demo:web:demo-app-id',
        'messagingSenderId': 'demo-sender-id',
        'storageBucket': 'demo-xiishopy-erp.appspot.com',
      };
}
