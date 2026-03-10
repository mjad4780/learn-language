import 'package:hive_flutter/hive_flutter.dart';

/// Service for persisting app settings and state using Hive.
class StorageService {
  static const String _settingsBoxName = 'settings';
  static const String _sentencesBoxName = 'user_sentences';
  static const String _articlesBoxName = 'custom_articles';
  static const String _intervalKey = 'interval_minutes';
  static const String _isRunningKey = 'is_running';
  static const String _learnedIdsKey = 'learned_ids';
  static const String _lastSentenceIdKey = 'last_sentence_id';
  static const String _dailyCountKey = 'daily_count';
  static const String _dailyDateKey = 'daily_date';

  late Box _settingsBox;
  late Box _sentencesBox;
  late Box _articlesBox;

  /// Initialize Hive and open the settings box.
  Future<void> init() async {
    await Hive.initFlutter();
    _settingsBox = await Hive.openBox(_settingsBoxName);
    _sentencesBox = await Hive.openBox(_sentencesBoxName);
    _articlesBox = await Hive.openBox(_articlesBoxName);
  }

  // -- Interval --
  int getInterval() => _settingsBox.get(_intervalKey, defaultValue: 15);
  Future<void> setInterval(int minutes) =>
      _settingsBox.put(_intervalKey, minutes);

  // -- Running state --
  bool getIsRunning() => _settingsBox.get(_isRunningKey, defaultValue: false);
  Future<void> setIsRunning(bool value) =>
      _settingsBox.put(_isRunningKey, value);

  // -- Learned sentence IDs --
  List<int> getLearnedIds() {
    final raw = _settingsBox.get(_learnedIdsKey, defaultValue: <int>[]);
    return List<int>.from(raw);
  }

  //

  // -- Last shown sentence (to avoid consecutive repeats) --
  int? getLastSentenceId() => _settingsBox.get(_lastSentenceIdKey);
  Future<void> setLastSentenceId(int id) =>
      _settingsBox.put(_lastSentenceIdKey, id);

  // -- Daily count --
  int getDailyCount() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = _settingsBox.get(_dailyDateKey, defaultValue: '');
    if (savedDate != today) {
      // Reset for new day
      _settingsBox.put(_dailyDateKey, today);
      _settingsBox.put(_dailyCountKey, 0);
      return 0;
    }
    return _settingsBox.get(_dailyCountKey, defaultValue: 0);
  }

  // Future<void> incrementDailyCount() async {
  //   final today = DateTime.now().toIso8601String().substring(0, 10);
  //   final savedDate = _settingsBox.get(_dailyDateKey, defaultValue: '');
  //   if (savedDate != today) {
  //     await _settingsBox.put(_dailyDateKey, today);
  //     await _settingsBox.put(_dailyCountKey, 1);
  //   } else {
  //     final count = _settingsBox.get(_dailyCountKey, defaultValue: 0) as int;
  //     await _settingsBox.put(_dailyCountKey, count + 1);
  //   }
  // }

  // -- User-added sentences --

  /// Get all user-added sentences as list of maps.
  List<Map<String, dynamic>> getUserSentences() {
    final List<Map<String, dynamic>> sentences = [];
    for (var i = 0; i < _sentencesBox.length; i++) {
      final raw = _sentencesBox.getAt(i);
      if (raw != null) {
        sentences.add(Map<String, dynamic>.from(raw));
      }
    }
    return sentences;
  }

  /// Add a new user sentence.
  Future<void> addUserSentence(String english, String arabic) async {
    // Generate an ID starting from 1000 to avoid conflicts with JSON sentences
    final id = 1000 + _sentencesBox.length;
    await _sentencesBox.add({'id': id, 'english': english, 'arabic': arabic});
  }

  /// Edit an existing user sentence.
  Future<void> editUserSentence(
    int index,
    String english,
    String arabic,
  ) async {
    final existing = _sentencesBox.getAt(index);
    if (existing != null) {
      final id = existing['id'];
      await _sentencesBox.putAt(index, {
        'id': id,
        'english': english,
        'arabic': arabic,
      });
    }
  }

  /// Delete a user sentence by its index in the box.
  Future<void> deleteUserSentence(int index) async {
    await _sentencesBox.deleteAt(index);
  }

  /// Get count of user-added sentences.
  int get userSentenceCount => _sentencesBox.length;

  // -- Custom Articles --

  /// Get all custom articles from storage.
  List<Map<String, dynamic>> getCustomArticles() {
    final List<Map<String, dynamic>> articles = [];
    for (var i = 0; i < _articlesBox.length; i++) {
      final raw = _articlesBox.getAt(i);
      if (raw != null) {
        articles.add(Map<String, dynamic>.from(raw));
      }
    }
    return articles;
  }

  /// Add a new custom article.
  Future<void> addCustomArticle(Map<String, dynamic> articleJson) async {
    // Generate an ID for the custom article
    articleJson['id'] = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    articleJson['isCustom'] = true;
    await _articlesBox.add(articleJson);
  }

  /// Edit an existing custom article.
  Future<void> editCustomArticle(
    int index,
    Map<String, dynamic> articleJson,
  ) async {
    final existing = _articlesBox.getAt(index);
    if (existing != null) {
      articleJson['id'] = existing['id'];
      articleJson['isCustom'] = true;
      await _articlesBox.putAt(index, articleJson);
    }
  }

  /// Delete a custom article by index.
  Future<void> deleteCustomArticle(int index) async {
    await _articlesBox.deleteAt(index);
  }
}
