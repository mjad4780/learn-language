import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../sentences/presentation/add_sentences_screen.dart';

/// Card that navigates to the Add Sentences screen.
class AddSentencesCard extends StatelessWidget {
  const AddSentencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddSentencesScreen()),
        );
      },
      child: GlassCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.edit_note_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Sentences',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Add, view, or delete custom sentences',
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white38,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
