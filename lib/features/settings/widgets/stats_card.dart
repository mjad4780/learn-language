import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/cubit/settings_cubit.dart';
import '../presentation/cubit/settings_state.dart';
import '../../../core/shared/widgets/glass_card.dart';

/// Stats card showing daily count, learned, and total sentences.
class StatsCard extends StatelessWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
                    color: Color(0xFF00D2FF),
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _Stat(
                    Icons.today_rounded,
                    'Today',
                    '${state.dailyCount}',
                    const Color(0xFF00E676),
                  ),
                  const SizedBox(width: 16),
                  _Stat(
                    Icons.school_rounded,
                    'Learned',
                    '${state.learnedCount}',
                    const Color(0xFFFFD740),
                  ),
                  const SizedBox(width: 16),
                  _Stat(
                    Icons.library_books_rounded,
                    'Total',
                    '${state.totalSentences}',
                    const Color(0xFF448AFF),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _Stat(this.icon, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
