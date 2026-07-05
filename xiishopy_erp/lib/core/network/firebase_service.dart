/// Xiishopy ERP - Firebase Initialization & Emulator Connection
/// Configures Firebase to use local emulators with adaptive host detection.
library;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_config.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    final config = AppConfig.instance;

    await Firebase.initializeApp(
      options: FirebaseOptions(
        projectId: config.firebaseOptions['projectId'] as String,
        apiKey: config.firebaseOptions['apiKey'] as String,
        appId: config.firebaseOptions['appId'] as String,
        messagingSenderId: config.firebaseOptions['messagingSenderId'] as String,
        storageBucket: config.firebaseOptions['storageBucket'] as String,
      ),
    );

    if (config.isEmulatorMode) {
      FirebaseFirestore.instance.settings = Settings(
        host: '${config.firestoreHost}:${config.firestorePort}',
        sslEnabled: false,
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      await FirebaseAuth.instance.useAuthEmulator(
        config.authHost,
        config.authPort,
      );

      FirebaseFirestore.instance.enableNetwork();
    }

    _initialized = true;
  }

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
}