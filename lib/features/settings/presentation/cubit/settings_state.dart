/// Immutable state for the settings Cubit.
class SettingsState {
  final int intervalMinutes;
  final bool isRunning;
  final int dailyCount;
  final int learnedCount;
  final int totalSentences;
  final bool hasPermission;

  const SettingsState({
    this.intervalMinutes = 15,
    this.isRunning = false,
    this.dailyCount = 0,
    this.learnedCount = 0,
    this.totalSentences = 0,
    this.hasPermission = false,
  });

  SettingsState copyWith({
    int? intervalMinutes,
    bool? isRunning,
    int? dailyCount,
    int? learnedCount,
    int? totalSentences,
    bool? hasPermission,
  }) {
    return SettingsState(
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      isRunning: isRunning ?? this.isRunning,
      dailyCount: dailyCount ?? this.dailyCount,
      learnedCount: learnedCount ?? this.learnedCount,
      totalSentences: totalSentences ?? this.totalSentences,
      hasPermission: hasPermission ?? this.hasPermission,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsState &&
          runtimeType == other.runtimeType &&
          intervalMinutes == other.intervalMinutes &&
          isRunning == other.isRunning &&
          dailyCount == other.dailyCount &&
          learnedCount == other.learnedCount &&
          totalSentences == other.totalSentences &&
          hasPermission == other.hasPermission;

  @override
  int get hashCode =>
      intervalMinutes.hashCode ^
      isRunning.hashCode ^
      dailyCount.hashCode ^
      learnedCount.hashCode ^
      totalSentences.hashCode ^
      hasPermission.hashCode;
}
