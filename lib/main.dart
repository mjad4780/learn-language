import 'package:flutter/material.dart';

import 'core/app/learn_english_app.dart';
import 'core/di/injection.dart';
import 'core/services/background_service.dart';

import 'features/overlay/overlay_main.dart' as overlay;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dependency Injection
  await setupService();
  await initializeBackgroundService();

  runApp(const LearnEnglishApp());
}

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  overlay.overlayMain();
}
