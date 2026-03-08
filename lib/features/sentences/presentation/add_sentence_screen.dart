import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme.dart';
import 'cubit/sentences_cubit.dart';
import 'cubit/sentences_state.dart';
import 'widgets/sentence_form.dart';

/// Screen for adding a new sentence or editing an existing one.
/// Expects a [SentencesCubit] to already be provided by the parent.
class AddSentenceScreen extends StatelessWidget {
  const AddSentenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SentencesCubit>();
    final isEditing = cubit.isEditing;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _AppBar(isEditing: isEditing),
              Expanded(
                child: BlocListener<SentencesCubit, SentencesState>(
                  listener: (context, state) {
                    if (state is SentencesSuccess &&
                        !context.read<SentencesCubit>().isEditing) {
                      // Submit was successful — pop back to list
                      Navigator.pop(context);
                    }
                    if (state is SentencesFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppTheme.errorColor.withValues(
                            alpha: 0.9,
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: BlocBuilder<SentencesCubit, SentencesState>(
                    builder: (context, state) {
                      final isSaving = state is SentencesLoading;
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: SentenceForm(
                          formKey: cubit.formKey,
                          englishController: cubit.englishController,
                          arabicController: cubit.arabicController,
                          isEditing: isEditing,
                          isSaving: isSaving,
                          onSubmit: () => cubit.submitForm(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final bool isEditing;
  const _AppBar({required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.read<SentencesCubit>().cancelEditing();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              isEditing ? 'Edit Sentence' : 'Add Sentence',
              textAlign: TextAlign.center,
              style: const TextStyle(
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
