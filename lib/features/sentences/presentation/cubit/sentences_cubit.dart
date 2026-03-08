import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/sentence_repository.dart';
import '../../../../core/services/storage_service.dart';
import 'sentences_state.dart';

/// Cubit managing user-added sentences CRUD.
/// Owns the form controllers and editing index — no StatefulWidget needed.
class SentencesCubit extends Cubit<SentencesState> {
  final StorageService _storage;
  final SentenceRepository _sentenceRepo;

  final TextEditingController englishController = TextEditingController();
  final TextEditingController arabicController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  SentencesCubit(this._storage, this._sentenceRepo)
    : super(const SentencesInitial());

  @override
  Future<void> close() {
    englishController.dispose();
    arabicController.dispose();
    return super.close();
  }

  // ─── Queries ───────────────────────────────────────────────────────────────

  List<Map<String, dynamic>> get _sentences => _storage.getUserSentences();

  int? get editingIndex => state is SentencesSuccess
      ? (state as SentencesSuccess).editingIndex
      : null;

  bool get isEditing => editingIndex != null;

  // ─── Load ──────────────────────────────────────────────────────────────────

  void loadSentences() {
    emit(const SentencesLoading());
    try {
      emit(SentencesSuccess(_sentences));
    } catch (e) {
      emit(SentencesFailure(e.toString()));
    }
  }

  // ─── Edit mode ─────────────────────────────────────────────────────────────

  void startEditing(int index, String english, String arabic) {
    englishController.text = english;
    arabicController.text = arabic;
    final sentences = state is SentencesSuccess
        ? (state as SentencesSuccess).sentences
        : _sentences;
    emit(SentencesSuccess(sentences, editingIndex: index));
  }

  void cancelEditing() {
    englishController.clear();
    arabicController.clear();
    emit(SentencesSuccess(_sentences));
  }

  // ─── CRUD ──────────────────────────────────────────────────────────────────

  /// Add or update a sentence depending on whether [editingIndex] is set.
  Future<bool> submitForm() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;

    final english = englishController.text.trim();
    final arabic = arabicController.text.trim();
    final currentIndex = editingIndex; // Store here

    emit(const SentencesLoading());

    try {
      if (currentIndex != null) {
        await _storage.editUserSentence(currentIndex, english, arabic);
      } else {
        await _storage.addUserSentence(english, arabic);
      }
      await _sentenceRepo.reload();
    } catch (e) {
      emit(SentencesFailure(e.toString()));
      return false;
    }

    englishController.clear();
    arabicController.clear();
    emit(SentencesSuccess(_sentences));
    return true;
  }

  Future<void> deleteSentence(int index) async {
    emit(const SentencesLoading());
    await _storage.deleteUserSentence(index);
    await _sentenceRepo.reload();
    emit(SentencesSuccess(_sentences));
  }
}
