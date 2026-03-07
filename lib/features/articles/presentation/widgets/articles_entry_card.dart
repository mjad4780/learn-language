import 'package:flutter/material.dart';

import '../../../../core/theme.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../screens/articles_screen.dart';

class ArticlesEntryCard extends StatelessWidget {
  const ArticlesEntryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ArticlesScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.library_books_rounded,
                    color: AppTheme.accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Read English Articles',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Practice reading and discover new vocabulary',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white54,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
