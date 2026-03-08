import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/cubit/settings_cubit.dart';
import '../presentation/cubit/settings_state.dart';
import '../../../core/theme.dart';
import '../../../core/shared/widgets/glass_card.dart';

/// Permission status card showing overlay permission state.
class PermissionCard extends StatelessWidget {
  const PermissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final hasPermission = state is SettingsLoaded
            ? state.hasPermission
            : false;

        return GlassCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: hasPermission
                      ? AppTheme.successColor.withValues(alpha: 0.15)
                      : AppTheme.errorColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  hasPermission
                      ? Icons.check_circle_rounded
                      : Icons.warning_rounded,
                  color: hasPermission
                      ? AppTheme.successColor
                      : AppTheme.errorColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overlay Permission',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasPermission ? 'Granted' : 'Required to show overlay',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              if (!hasPermission)
                TextButton(
                  onPressed: () => context.read<SettingsCubit>().startService(),
                  child: const Text(
                    'Grant',
                    style: TextStyle(
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
