import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme.dart';

/// A single sentence item card in the list.
class SentenceItem extends StatelessWidget {
  final String english;
  final String arabic;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const SentenceItem({
    super.key,
    required this.english,
    required this.arabic,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        english,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        arabic,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit_rounded,
                    color: AppTheme.accentColor.withValues(alpha: 0.8),
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: AppTheme.errorColor.withValues(alpha: 0.7),
                    size: 20,
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
