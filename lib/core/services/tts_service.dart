// import 'package:flutter_tts/flutter_tts.dart';

// /// Service for text-to-speech pronunciation of English sentences.
// class TtsService {
//   final FlutterTts _tts = FlutterTts();
//   bool _isInitialized = false;

//   /// Initialize TTS engine with English language settings.
//   Future<void> init() async {
//     if (_isInitialized) return;
//     await _tts.setLanguage('en-US');
//     await _tts.setSpeechRate(0.45);
//     await _tts.setVolume(1.0);
//     await _tts.setPitch(1.0);
//     _isInitialized = true;
//   }

//   /// Speak the given text.
//   Future<void> speak(String text) async {
//     await init();
//     await _tts.stop();
//     await _tts.speak(text);
//   }

//   /// Stop any ongoing speech.
//   Future<void> stop() async {
//     await _tts.stop();
//   }

//   /// Dispose TTS resources.
//   Future<void> dispose() async {
//     await _tts.stop();
//   }
// }
