import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../core/shared/widgets/glass_card.dart';

/// Info card explaining how the app works.
class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppTheme.accentColor,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                'How It Works',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          _InfoStep(number: '1', text: 'Select your preferred interval'),
          _InfoStep(number: '2', text: 'Tap START to begin learning'),
          _InfoStep(number: '3', text: 'Sentences appear over any app'),
          _InfoStep(number: '4', text: 'Tap 🔊 to hear pronunciation'),
        ],
      ),
    );
  }
}

class _InfoStep extends StatelessWidget {
  final String number;
  final String text;

  const _InfoStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
