/// State for the sentences management Cubit.
class SentencesState {
  final List<Map<String, dynamic>> sentences;
  final bool isSaving;

  const SentencesState({this.sentences = const [], this.isSaving = false});

  SentencesState copyWith({
    List<Map<String, dynamic>>? sentences,
    bool? isSaving,
  }) {
    return SentencesState(
      sentences: sentences ?? this.sentences,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
