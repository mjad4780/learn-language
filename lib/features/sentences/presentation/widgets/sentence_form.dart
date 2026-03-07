import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme.dart';

/// Form widget for adding a new English/Arabic sentence.
class SentenceForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController englishController;
  final TextEditingController arabicController;
  final bool isEditing;
  final VoidCallback onSubmit;

  const SentenceForm({
    super.key,
    required this.formKey,
    required this.englishController,
    required this.arabicController,
    required this.isEditing,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.03),
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FormHeader(isEditing: isEditing),
                const SizedBox(height: 20),
                _EnglishField(controller: englishController),
                const SizedBox(height: 14),
                _ArabicField(controller: arabicController),
                const SizedBox(height: 18),
                _SubmitButton(isEditing: isEditing, onSubmit: onSubmit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormHeader extends StatelessWidget {
  final bool isEditing;
  const _FormHeader({required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.add_circle_outline_rounded,
          color: AppTheme.accentColor,
          size: 22,
        ),
        SizedBox(width: 10),
        Text(
          isEditing ? 'Edit Sentence' : 'Add New Sentence',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _EnglishField extends StatelessWidget {
  final TextEditingController controller;

  const _EnglishField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: _decoration(
        'English Sentence',
        'e.g. Hello, how are you?',
        Icons.language_rounded,
      ),
      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
    );
  }
}

class _ArabicField extends StatelessWidget {
  final TextEditingController controller;

  const _ArabicField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      textDirection: TextDirection.rtl,
      decoration: _decoration(
        'Arabic Translation',
        'مثال: مرحباً، كيف حالك؟',
        Icons.translate_rounded,
      ),
      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onSubmit;

  const _SubmitButton({required this.isEditing, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onSubmit,
          icon: Icon(isEditing ? Icons.check_rounded : Icons.add_rounded),
          label: Text(isEditing ? 'Update Sentence' : 'Add Sentence'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _decoration(String label, String hint, IconData icon) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
    prefixIcon: Icon(icon, color: AppTheme.accentColor, size: 20),
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.06),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppTheme.accentColor, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppTheme.errorColor),
    ),
  );
}
