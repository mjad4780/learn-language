/// State for the overlay Cubit.
class OverlayViewState {
  final int sentenceId;
  final String english;
  final String arabic;
  final bool isLoaded;

  const OverlayViewState({
    this.sentenceId = 0,
    this.english = 'Waiting for data...',
    this.arabic = '',
    this.isLoaded = false,
  });

  OverlayViewState copyWith({
    int? sentenceId,
    String? english,
    String? arabic,
    bool? isLoaded,
  }) {
    return OverlayViewState(
      sentenceId: sentenceId ?? this.sentenceId,
      english: english ?? this.english,
      arabic: arabic ?? this.arabic,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}
