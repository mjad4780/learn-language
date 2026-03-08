/// Sealed state hierarchy for the settings Cubit.
sealed class SettingsState {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final int intervalMinutes;
  final bool isRunning;
  final int dailyCount;
  final int learnedCount;
  final int totalSentences;
  final bool hasPermission;

  const SettingsLoaded({
    this.intervalMinutes = 15,
    this.isRunning = false,
    this.dailyCount = 0,
    this.learnedCount = 0,
    this.totalSentences = 0,
    this.hasPermission = false,
  });

  SettingsLoaded copyWith({
    int? intervalMinutes,
    bool? isRunning,
    int? dailyCount,
    int? learnedCount,
    int? totalSentences,
    bool? hasPermission,
  }) {
    return SettingsLoaded(
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      isRunning: isRunning ?? this.isRunning,
      dailyCount: dailyCount ?? this.dailyCount,
      learnedCount: learnedCount ?? this.learnedCount,
      totalSentences: totalSentences ?? this.totalSentences,
      hasPermission: hasPermission ?? this.hasPermission,
    );
  }
}

class SettingsFailure extends SettingsState {
  final String message;
  const SettingsFailure(this.message);
}
