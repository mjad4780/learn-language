import 'package:flutter/material.dart';

import '../../../../core/theme.dart';
import 'sentence_item.dart';

/// Widget displaying the list of user-added sentences or empty state.
class SentenceList extends StatelessWidget {
  final List<Map<String, dynamic>> sentences;
  final void Function(int index) onDelete;
  final void Function(int index, String english, String arabic) onEdit;

  const SentenceList({
    super.key,
    required this.sentences,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (sentences.isEmpty) return const _EmptyState();
    return _SentenceListView(
      sentences: sentences,
      onDelete: onDelete,
      onEdit: onEdit,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.note_add_rounded,
            size: 56,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 12),
          Text(
            'No custom sentences yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add your first sentence above!',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _SentenceListView extends StatelessWidget {
  final List<Map<String, dynamic>> sentences;
  final void Function(int index) onDelete;
  final void Function(int index, String english, String arabic) onEdit;

  const _SentenceListView({
    required this.sentences,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.list_rounded,
              color: AppTheme.accentColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Your Sentences (${sentences.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sentences.length,
          itemBuilder: (context, i) {
            final s = sentences[i];
            final english = s['english'] ?? '';
            final arabic = s['arabic'] ?? '';
            return SentenceItem(
              english: english,
              arabic: arabic,
              onDelete: () => onDelete(i),
              onEdit: () => onEdit(i, english, arabic),
            );
          },
        ),
      ],
    );
  }
}
