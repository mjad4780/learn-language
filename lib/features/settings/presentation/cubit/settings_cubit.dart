import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../sentences/data/repo/sentence_repository.dart';
import '../../../../core/services/overlay_service.dart';
import '../../../../core/services/storage_service.dart';
import 'settings_state.dart';

import '../../../../core/di/injection.dart';

import 'package:flutter_background_service/flutter_background_service.dart';

/// Cubit managing the app settings and overlay scheduling.
class SettingsCubit extends Cubit<SettingsState> {
  final StorageService storage = getIt<StorageService>();
  final OverlayService overlayService = getIt<OverlayService>();
  final SentenceRepository sentenceRepo = getIt<SentenceRepository>();

  SettingsCubit() : super(const SettingsState());

  /// Initialize state from storage.
  Future<void> init() async {
    final hasPermission = await overlayService.isPermissionGranted();
    final isRunning = await FlutterBackgroundService().isRunning();

    emit(
      state.copyWith(
        intervalMinutes: storage.getInterval(),
        isRunning: isRunning,
        dailyCount: storage.getDailyCount(),
        learnedCount: sentenceRepo.learnedCount,
        totalSentences: sentenceRepo.totalCount,
        hasPermission: hasPermission,
      ),
    );
  }

  Future<void> setInterval(int minutes) async {
    await storage.setInterval(minutes);
    emit(state.copyWith(intervalMinutes: minutes));
    // The background service checks storage automatically every tick.
  }

  /// Toggle the service on/off.
  void toggleService() {
    if (state.isRunning) {
      log('Toggling off from cubit state');
      stopService();
    } else {
      log('Toggling on from cubit state');
      startService();
    }
  }

  /// Start the overlay service.
  Future<void> startService() async {
    // Check/request permission first
    bool hasPermission = await overlayService.isPermissionGranted();
    if (!hasPermission) {
      hasPermission = await overlayService.requestPermission();
      emit(state.copyWith(hasPermission: hasPermission));
      if (!hasPermission) return;
    }

    await storage.setIsRunning(true);
    emit(state.copyWith(isRunning: true, hasPermission: true));

    final service = FlutterBackgroundService();
    service.isRunning().then((isRunning) async {
      if (!isRunning) {
        await service.startService();
      }
      // Force background to update its internal flag
      service.invoke('updateConfig', {'isRunning': true});
    });
  }

  /// Stop the overlay service.
  Future<void> stopService() async {
    emit(state.copyWith(isRunning: false));

    final service = FlutterBackgroundService();
    // We just tell the background service to go dormant, instead of killing it
    service.invoke('updateConfig', {'isRunning': false});
    await overlayService.closeOverlay();
    await storage.setIsRunning(false);
  }

  /// Refresh permission and stats state.
  Future<void> refreshState() async {
    final hasPermission = await overlayService.isPermissionGranted();
    emit(
      state.copyWith(
        hasPermission: hasPermission,
        dailyCount: storage.getDailyCount(),
        learnedCount: sentenceRepo.learnedCount,
      ),
    );
  }
}
