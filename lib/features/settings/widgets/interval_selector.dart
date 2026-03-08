import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/cubit/settings_cubit.dart';
import '../presentation/cubit/settings_state.dart';
import '../../../core/theme.dart';
import '../../../core/shared/widgets/glass_card.dart';

/// Interval selector card with 5/10/15 minute options.
class IntervalSelector extends StatelessWidget {
  static const List<int> _intervals = [5, 10, 15];

  const IntervalSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final intervalMinutes = state is SettingsLoaded
            ? state.intervalMinutes
            : 15;

        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IntervalHeader(intervalMinutes: intervalMinutes),
              const SizedBox(height: 20),
              _IntervalOptions(
                selectedMinutes: intervalMinutes,
                intervals: _intervals,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IntervalHeader extends StatelessWidget {
  final int intervalMinutes;

  const _IntervalHeader({required this.intervalMinutes});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.timer_outlined, color: AppTheme.accentColor, size: 22),
        const SizedBox(width: 10),
        const Text(
          'Interval',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Every $intervalMinutes min',
            style: const TextStyle(
              color: AppTheme.accentColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _IntervalOptions extends StatelessWidget {
  final int selectedMinutes;
  final List<int> intervals;

  const _IntervalOptions({
    required this.selectedMinutes,
    required this.intervals,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: intervals.map((m) {
        final selected = selectedMinutes == m;
        return GestureDetector(
          onTap: () => context.read<SettingsCubit>().setInterval(m),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: selected ? AppTheme.primaryGradient : null,
              color: selected ? null : Colors.white.withValues(alpha: 0.06),
              border: Border.all(
                color: selected
                    ? Colors.transparent
                    : Colors.white.withValues(alpha: 0.1),
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$m',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: selected ? Colors.white : Colors.white70,
                  ),
                ),
                Text(
                  'min',
                  style: TextStyle(
                    fontSize: 11,
                    color: selected ? Colors.white70 : Colors.white38,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
