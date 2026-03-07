import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';

import '../../data/repo/sentence_repository.dart';
import '../../../../core/services/storage_service.dart';
import 'sentences_state.dart';

/// Cubit managing user-added sentences CRUD.
class SentencesCubit extends Cubit<SentencesState> {
  final StorageService _storage = getIt<StorageService>();
  final SentenceRepository _sentenceRepo = getIt<SentenceRepository>();

  SentencesCubit() : super(const SentencesState());

  /// Load user sentences from storage.
  void loadSentences() {
    emit(state.copyWith(sentences: _storage.getUserSentences()));
  }

  /// Add a new sentence.
  Future<void> addSentence(String english, String arabic) async {
    emit(state.copyWith(isSaving: true));
    await _storage.addUserSentence(english, arabic);
    await _sentenceRepo.reload();
    emit(
      state.copyWith(sentences: _storage.getUserSentences(), isSaving: false),
    );
  }

  /// Edit an existing sentence.
  Future<void> editSentence(int index, String english, String arabic) async {
    emit(state.copyWith(isSaving: true));
    await _storage.editUserSentence(index, english, arabic);
    await _sentenceRepo.reload();
    emit(
      state.copyWith(sentences: _storage.getUserSentences(), isSaving: false),
    );
  }

  /// Delete a sentence by index.
  Future<void> deleteSentence(int index) async {
    await _storage.deleteUserSentence(index);
    await _sentenceRepo.reload();
    emit(state.copyWith(sentences: _storage.getUserSentences()));
  }
}
