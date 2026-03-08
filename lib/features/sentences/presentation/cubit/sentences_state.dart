/// Sealed state hierarchy for the sentences management Cubit.
sealed class SentencesState {
  const SentencesState();
}

class SentencesInitial extends SentencesState {
  const SentencesInitial();
}

class SentencesLoading extends SentencesState {
  const SentencesLoading();
}

class SentencesSuccess extends SentencesState {
  final List<Map<String, dynamic>> sentences;

  /// Index of the sentence currently being edited (null = add mode).
  final int? editingIndex;

  const SentencesSuccess(this.sentences, {this.editingIndex});
}

class SentencesFailure extends SentencesState {
  final String message;
  const SentencesFailure(this.message);
}
