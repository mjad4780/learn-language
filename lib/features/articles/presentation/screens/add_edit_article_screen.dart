import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme.dart';
import '../../data/models/article_model.dart';
import '../cubit/articles_cubit.dart';

class AddEditArticleScreen extends StatefulWidget {
  final ArticleModel? article;

  const AddEditArticleScreen({super.key, this.article});

  @override
  State<AddEditArticleScreen> createState() => _AddEditArticleScreenState();
}

class _AddEditArticleScreenState extends State<AddEditArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _translationController;
  String _difficulty = 'Beginner';

  bool get isEditing => widget.article != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article?.title ?? '');
    _contentController = TextEditingController(
      text: widget.article?.content ?? '',
    );
    _translationController = TextEditingController(
      text: widget.article?.translation ?? '',
    );
    _difficulty = widget.article?.difficulty ?? 'Beginner';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final article = ArticleModel(
        id: widget.article?.id ?? '',
        title: _titleController.text,
        content: _contentController.text,
        translation: _translationController.text.isEmpty
            ? null
            : _translationController.text,
        difficulty: _difficulty,
        isCustom: true,
      );

      if (isEditing) {
        context.read<ArticlesCubit>().editArticle(article);
      } else {
        context.read<ArticlesCubit>().addArticle(article);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _AppBar(isEditing: isEditing, onSave: _save),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Label(text: 'Article Title'),
                        _TextField(
                          controller: _titleController,
                          hint: 'Enter article title',
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        const SizedBox(height: 24),
                        _Label(text: 'Content (English)'),
                        _TextField(
                          controller: _contentController,
                          hint: 'Enter English text',
                          maxLines: 10,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        const SizedBox(height: 24),
                        _Label(text: 'Translation (Arabic - Optional)'),
                        _TextField(
                          controller: _translationController,
                          hint: 'Enter Arabic translation',
                          maxLines: 10,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 24),
                        _Label(text: 'Difficulty'),
                        _DifficultySelector(
                          value: _difficulty,
                          onChanged: (v) => setState(() => _difficulty = v!),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
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
  final VoidCallback onSave;

  const _AppBar({required this.isEditing, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
          Expanded(
            child: Text(
              isEditing ? 'Edit Article' : 'New Article',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: onSave,
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextAlign textAlign;
  final TextDirection? textDirection;

  const _TextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.validator,
    this.textAlign = TextAlign.left,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      textAlign: textAlign,
      textDirection: textDirection,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.accentColor, width: 1.5),
        ),
      ),
    );
  }
}

class _DifficultySelector extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const _DifficultySelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF1E1E1E),
          style: const TextStyle(color: Colors.white, fontSize: 15),
          items: [
            'Beginner',
            'Intermediate',
            'Advanced',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
