import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme.dart';
import '../../../core/di/injection.dart';
import 'cubit/sentences_cubit.dart';
import 'cubit/sentences_state.dart';
import 'widgets/sentence_list.dart';
import 'add_sentence_screen.dart';

/// Screen showing the list of all user-added sentences.
/// Navigates to [AddSentenceScreen] for add/edit.
class MySentencesScreen extends StatelessWidget {
  const MySentencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SentencesCubit>()..loadSentences(),
      child: const _MySentencesView(),
    );
  }
}

class _MySentencesView extends StatelessWidget {
  const _MySentencesView();

  Future<void> _onDelete(BuildContext context, int index) async {
    final cubit = context.read<SentencesCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Sentence?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this sentence?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) await cubit.deleteSentence(index);
  }

  void _onEdit(BuildContext context, int index, String english, String arabic) {
    context.read<SentencesCubit>().startEditing(index, english, arabic);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<SentencesCubit>(),
          child: const AddSentenceScreen(),
        ),
      ),
    );
  }

  void _onAddTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<SentencesCubit>(),
          child: const AddSentenceScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _AppBar(),
              Expanded(
                child: BlocBuilder<SentencesCubit, SentencesState>(
                  builder: (context, state) {
                    if (state is SentencesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.accentColor,
                        ),
                      );
                    }
                    if (state is SentencesFailure) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: AppTheme.errorColor),
                        ),
                      );
                    }
                    final sentences = state is SentencesSuccess
                        ? state.sentences
                        : <Map<String, dynamic>>[];
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          SentenceList(
                            sentences: sentences,
                            onDelete: (i) => _onDelete(context, i),
                            onEdit: (i, en, ar) => _onEdit(context, i, en, ar),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton.extended(
          onPressed: () => _onAddTap(context),
          backgroundColor: AppTheme.primaryColor,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'Add Sentence',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          const Expanded(
            child: Text(
              'My Sentences',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
