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

  SettingsCubit() : super(const SettingsInitial());

  // ─── Helpers ───────────────────────────────────────────────────────────────

  /// Returns the current loaded state, or a default one.
  SettingsLoaded get _loaded => state is SettingsLoaded
      ? state as SettingsLoaded
      : const SettingsLoaded();

  // ─── Init ──────────────────────────────────────────────────────────────────

  /// Initialize state from storage.
  Future<void> init() async {
    emit(const SettingsLoading());
    final hasPermission = await overlayService.isPermissionGranted();
    final isRunning = storage.getIsRunning();
    emit(
      SettingsLoaded(
        intervalMinutes: storage.getInterval(),
        isRunning: isRunning,
        dailyCount: storage.getDailyCount(),
        learnedCount: sentenceRepo.learnedCount,
        totalSentences: sentenceRepo.totalCount,
        hasPermission: hasPermission,
      ),
    );
  }

  // ─── Settings changes ──────────────────────────────────────────────────────

  Future<void> setInterval(int minutes) async {
    await storage.setInterval(minutes);
    emit(_loaded.copyWith(intervalMinutes: minutes));
  }

  /// Toggle the service on/off.
  void toggleService() {
    if (_loaded.isRunning) {
      log('Toggling off from cubit state stopService');
      stopService();
    } else {
      log('Toggling on from cubit state startService');
      startService();
    }
  }

  /// Start the overlay service.
  Future<void> startService() async {
    bool hasPermission = await overlayService.isPermissionGranted();
    if (!hasPermission) {
      hasPermission = await overlayService.requestPermission();
      emit(_loaded.copyWith(hasPermission: hasPermission));
      if (!hasPermission) return;
    }

    await storage.setIsRunning(true);
    emit(_loaded.copyWith(isRunning: true, hasPermission: true));

    final service = FlutterBackgroundService();
    service.isRunning().then((isRunning) async {
      if (!isRunning) {
        await service.startService();
      }
      service.invoke('updateConfig', {'isRunning': true});
    });
  }

  /// Stop the overlay service.
  Future<void> stopService() async {
    emit(_loaded.copyWith(isRunning: false));

    final service = FlutterBackgroundService();
    service.invoke('updateConfig', {'isRunning': false});
    await overlayService.closeOverlay();
    await storage.setIsRunning(false);
  }

  /// Refresh permission and stats state.
  Future<void> refreshState() async {
    final hasPermission = await overlayService.isPermissionGranted();
    emit(
      _loaded.copyWith(
        hasPermission: hasPermission,
        dailyCount: storage.getDailyCount(),
        learnedCount: sentenceRepo.learnedCount,
        totalSentences: sentenceRepo.totalCount,
      ),
    );
  }
}
