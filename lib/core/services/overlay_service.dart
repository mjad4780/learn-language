import 'dart:developer' as dev;

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

/// Service for managing the system overlay window.
class OverlayService {
  /// Check if the overlay permission is granted.
  Future<bool> isPermissionGranted() async {
    try {
      return await FlutterOverlayWindow.isPermissionGranted();
    } catch (e) {
      dev.log('Error checking permission: $e');
      return false;
    }
  }

  /// Request overlay permission from the user.
  Future<bool> requestPermission() async {
    try {
      final result = await FlutterOverlayWindow.requestPermission();
      return result ?? false;
    } catch (e) {
      dev.log('Error requesting permission: $e');
      return false;
    }
  }

  /// Show the overlay window.
  Future<void> showOverlay({String? title}) async {
    // Check if it's already active to avoid duplicate.
    if (await isOverlayActive()) {
      dev.log('Overlay already active. Not showing again.');
      return;
    }

    try {
      await FlutterOverlayWindow.showOverlay(
        enableDrag: true,
        overlayTitle: title ?? 'Learn English',
        overlayContent: '',
        flag: OverlayFlag.defaultFlag,
        visibility: NotificationVisibility.visibilityPublic,
        positionGravity: PositionGravity.auto,
        height: 300,
        width: WindowSize.matchParent,
      );
    } catch (e) {
      dev.log('Error showing overlay: $e');
    }
  }

  /// Close the overlay window completely.
  Future<void> closeOverlay() async {
    try {
      await FlutterOverlayWindow.closeOverlay();
    } catch (e) {
      dev.log('Error closing overlay: $e');
    }
  }

  /// Check if overlay is currently active.
  Future<bool> isOverlayActive() async {
    try {
      return await FlutterOverlayWindow.isActive();
    } catch (e) {
      return false;
    }
  }

  /// Share data with overlay via messaging.
  Future<void> shareData(dynamic data) async {
    try {
      await FlutterOverlayWindow.shareData(data);
    } catch (e) {
      dev.log('Error sharing data: $e');
    }
  }
}
