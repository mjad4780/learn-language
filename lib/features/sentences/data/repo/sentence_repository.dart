import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../model/sentence.dart';
import '../../../../core/services/storage_service.dart';

/// Repository for loading and selecting random sentences.
class SentenceRepository {
  final StorageService _storage;
  List<Sentence> _sentences = [];
  final Random _random = Random();

  SentenceRepository(this._storage);

  /// Load sentences from the bundled JSON asset + user-added sentences from Hive.
  Future<void> loadSentences() async {
    final jsonString = await rootBundle.loadString('assets/sentences.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    final builtIn = jsonList.map((e) => Sentence.fromJson(e)).toList();

    // Load user-added sentences
    final userRaw = _storage.getUserSentences();
    final userSentences = userRaw.map((e) => Sentence.fromJson(e)).toList();

    _sentences = [...builtIn, ...userSentences];
  }

  /// Reload sentences (call after adding/deleting user sentences).
  Future<void> reload() async => await loadSentences();

  /// Get all sentences.
  List<Sentence> get allSentences => _sentences;

  /// Get a random sentence, avoiding consecutive repeats and learned sentences.
  Sentence getRandomSentence() {
    final learnedIds = _storage.getLearnedIds();
    final lastId = _storage.getLastSentenceId();

    // Filter out learned sentences
    var available = _sentences
        .where((s) => !learnedIds.contains(s.id))
        .toList();

    // If all sentences are learned, reset and use all
    if (available.isEmpty) {
      available = List.from(_sentences);
    }

    // Avoid consecutive repeat
    if (available.length > 1 && lastId != null) {
      available = available.where((s) => s.id != lastId).toList();
    }

    final sentence = available[_random.nextInt(available.length)];
    _storage.setLastSentenceId(sentence.id);
    return sentence;
  }

  /// Get the next sentence (for swipe action in overlay).
  Sentence getNextSentence() => getRandomSentence();

  /// Mark a sentence as learned.
  Future<void> markAsLearned(int id) async {
    await _storage.addLearnedId(id);
  }

  /// Get count of learned sentences.
  int get learnedCount => _storage.getLearnedIds().length;

  /// Get total sentence count.
  int get totalCount => _sentences.length;
}
