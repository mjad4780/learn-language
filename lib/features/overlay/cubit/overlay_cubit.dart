import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
// import 'package:flutter_tts/flutter_tts.dart';

import 'overlay_state.dart';

class OverlayCubit extends Cubit<OverlayViewState> {
  OverlayCubit() : super(const OverlayViewState()) {
    _listenForData();
  }

  void _listenForData() {
    FlutterOverlayWindow.overlayListener.listen((data) {
      if (data != null && data is String) {
        dev.log("OverlayCubit received data: $data");
        try {
          final json = jsonDecode(data);
          int newId = json['id'] ?? 0;
          if (state.isLoaded && state.sentenceId == newId) {
            dev.log("OverlayCubit: Already loaded this sentence, ignore.");
            return;
          }
          dev.log("OverlayCubit: Emitting new state for ID $newId");
          emit(
            state.copyWith(
              sentenceId: newId,
              english: json['english'] ?? '',
              arabic: json['arabic'] ?? '',
              isLoaded: true,
            ),
          );
        } catch (e) {
          dev.log("OverlayCubit Error decoding data: $e");
        }
      }
    });
  }

  Future<void> markAsLearned() async {
    await FlutterOverlayWindow.shareData(
      jsonEncode({'action': 'learned', 'id': state.sentenceId}),
    );
    await closeOverlay();
  }

  /// Close the overlay window completely.
  Future<void> closeOverlay() async {
    await FlutterOverlayWindow.closeOverlay();
    emit(state.copyWith(isLoaded: false));
  }

  /// Request next sentence via swipe.
  Future<void> requestNext() async {
    await FlutterOverlayWindow.shareData(jsonEncode({'action': 'next'}));
  }
}
