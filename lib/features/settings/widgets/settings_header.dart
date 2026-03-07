import 'package:flutter/material.dart';

import '../../../core/theme.dart';

/// App header with icon, title, and subtitle.
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_stories_rounded,
            color: Colors.white,
            size: 48,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Learn English',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Master English, one sentence at a time',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
