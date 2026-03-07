import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
// import 'package:flutter_tts/flutter_tts.dart';

import 'overlay_state.dart';

/// Cubit managing the overlay sentence data and actions.
class OverlayCubit extends Cubit<OverlayViewState> {
  // final FlutterTts _tts = FlutterTts();

  OverlayCubit() : super(const OverlayViewState()) {
    // _initTts();
    _listenForData();
  }

  // Future<void> _initTts() async {
  //   await _tts.setLanguage('en-US');
  //   await _tts.setSpeechRate(0.45);
  //   await _tts.setVolume(1.0);
  // }

  void _listenForData() {
    FlutterOverlayWindow.overlayListener.listen((data) {
      if (data != null && data is String) {
        try {
          final json = jsonDecode(data);
          emit(
            state.copyWith(
              sentenceId: json['id'] ?? 0,
              english: json['english'] ?? '',
              arabic: json['arabic'] ?? '',
              isLoaded: true,
            ),
          );
        } catch (_) {}
      }
    });
  }

  // /// Speak the current English sentence.
  // Future<void> speak() async {
  //   await _tts.stop();
  //   await _tts.speak(state.english);
  // }

  /// Mark current sentence as learned and close overlay.
  Future<void> markAsLearned() async {
    await FlutterOverlayWindow.shareData(
      jsonEncode({'action': 'learned', 'id': state.sentenceId}),
    );
    await closeOverlay();
  }

  /// Close the overlay window completely.
  Future<void> closeOverlay() async {
    await FlutterOverlayWindow.closeOverlay();
    // Reset state so next open triggers BlocListener again
    emit(state.copyWith(isLoaded: false));
  }

  /// Request next sentence via swipe.
  Future<void> requestNext() async {
    await FlutterOverlayWindow.shareData(jsonEncode({'action': 'next'}));
  }

  @override
  Future<void> close() {
    // _tts.stop();
    return super.close();
  }
}
