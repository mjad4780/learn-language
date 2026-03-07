import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import '../di/injection.dart';
import 'overlay_service.dart';
import '../../features/sentences/data/repo/sentence_repository.dart';
import 'storage_service.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      // When relying on the default foreground service without local notification plugins,
      // it uses a default notification or you can specify via strings.xml.
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DI for this background isolate
  await setupService();

  final storage = getIt<StorageService>();
  final sentenceRepo = getIt<SentenceRepository>();
  final overlayService = getIt<OverlayService>();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  bool isRunningMemory = storage.getIsRunning();

  service.on('updateConfig').listen((event) {
    if (event != null && event.containsKey('isRunning')) {
      isRunningMemory = event['isRunning'] as bool;
      if (!isRunningMemory) {
        // If turned off, hide the persistent notification if possible,
        // or just update it to reflect dormant state.
        if (service is AndroidServiceInstance) {
          service.setForegroundNotificationInfo(
            title: "Learn English Service",
            content: "Service paused",
          );
        }
      }
    }
  });

  // Simple 10-second timer for testing (can be replaced by user preference later)
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (!isRunningMemory) {
      return; // Stay dormant, do not cancel the timer or kill the service
    }

    try {
      // If overlay is already on screen, do nothing and wait for user to read/close it
      if (await overlayService.isOverlayActive()) {
        dev.log("Overlay is still active. Skipping this tick.");
        return;
      }

      // Time to show a new sentence!
      final sentence = sentenceRepo.getRandomSentence();
      await storage.incrementDailyCount();

      final data = json.encode({
        'id': sentence.id,
        'english': sentence.english,
        'arabic': sentence.arabic,
      });

      // Show the overlay window from scratch
      await overlayService.showOverlay();

      // Wait a moment for flutter UI engine to spin up inside the overlay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Send the sentence data to the overlay UI
      await FlutterOverlayWindow.shareData(data);

      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Learn English Service",
          content: "Showing new sentence...",
        );
      }
    } catch (e) {
      dev.log("Error in timer: $e");
    }
  });
}
