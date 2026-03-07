import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/sentences_cubit.dart';
import 'cubit/sentences_state.dart';
import '../../../core/theme.dart';
import 'widgets/sentence_form.dart';
import 'widgets/sentence_list.dart';
import '../../../core/di/injection.dart';

/// Screen for managing user-added sentences. Uses SentencesCubit.
class AddSentencesScreen extends StatefulWidget {
  const AddSentencesScreen({super.key});

  @override
  State<AddSentencesScreen> createState() => _AddSentencesScreenState();
}

class _AddSentencesScreenState extends State<AddSentencesScreen> {
  final _englishController = TextEditingController();
  final _arabicController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int? _editingIndex;

  @override
  void dispose() {
    _englishController.dispose();
    _arabicController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(SentencesCubit cubit) async {
    if (!_formKey.currentState!.validate()) return;

    if (_editingIndex != null) {
      await cubit.editSentence(
        _editingIndex!,
        _englishController.text.trim(),
        _arabicController.text.trim(),
      );
    } else {
      await cubit.addSentence(
        _englishController.text.trim(),
        _arabicController.text.trim(),
      );
    }

    _englishController.clear();
    _arabicController.clear();
    setState(() {
      _editingIndex = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _editingIndex != null
                ? 'Sentence updated successfully!'
                : 'Sentence added successfully!',
          ),
          backgroundColor: AppTheme.successColor.withValues(alpha: 0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _onEdit(int index, String english, String arabic) {
    setState(() {
      _editingIndex = index;
      _englishController.text = english;
      _arabicController.text = arabic;
    });
  }

  Future<void> _onDelete(BuildContext ctx, int index) async {
    final cubit = ctx.read<SentencesCubit>();
    final confirmed = await showDialog<bool>(
      context: ctx,
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
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SentencesCubit>()..loadSentences(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                const _CustomAppBar(),
                Expanded(
                  child: _ScreenBody(
                    formKey: _formKey,
                    englishController: _englishController,
                    arabicController: _arabicController,
                    isEditing: _editingIndex != null,
                    onSubmit: _onSubmit,
                    onDelete: _onDelete,
                    onEdit: _onEdit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar();

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

class _ScreenBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController englishController;
  final TextEditingController arabicController;
  final bool isEditing;
  final Future<void> Function(SentencesCubit) onSubmit;
  final Future<void> Function(BuildContext, int) onDelete;
  final void Function(int, String, String) onEdit;

  const _ScreenBody({
    required this.formKey,
    required this.englishController,
    required this.arabicController,
    required this.isEditing,
    required this.onSubmit,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SentencesCubit, SentencesState>(
      builder: (context, state) {
        final cubit = context.read<SentencesCubit>();
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              SentenceForm(
                formKey: formKey,
                englishController: englishController,
                arabicController: arabicController,
                isEditing: isEditing,
                onSubmit: () => onSubmit(cubit),
              ),
              const SizedBox(height: 24),
              SentenceList(
                sentences: state.sentences,
                onDelete: (i) => onDelete(context, i),
                onEdit: onEdit,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
