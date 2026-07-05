/// Xiishopy ERP - Application Entry Point
/// Adaptive configuration that points Firebase network clients to
/// localhost (Web/iOS) and 10.0.2.2 (Android Emulator proxy).
/// Data layer uses .snapshots() listeners for real-time updates.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/network/firebase_service.dart';
import 'core/di/service_locator.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait on mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase with emulator configuration
  final firebaseService = FirebaseService();
  await firebaseService.initialize();

  // Initialize dependency injection
  await initDependencies();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF1A1A2E),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const XiishopyERPApp());
}