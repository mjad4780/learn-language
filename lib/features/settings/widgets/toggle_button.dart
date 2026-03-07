import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/cubit/settings_cubit.dart';
import '../presentation/cubit/settings_state.dart';
import '../../../core/theme.dart';

/// Animated circular Start/Stop toggle button.
class ToggleButton extends StatelessWidget {
  final Animation<double> pulseAnimation;

  const ToggleButton({super.key, required this.pulseAnimation});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        log("sssssssssss${state.isRunning}");
        return AnimatedBuilder(
          animation: pulseAnimation,
          builder: (context, child) {
            final scale = state.isRunning ? pulseAnimation.value : 1.0;
            return Transform.scale(scale: scale, child: child);
          },
          child: GestureDetector(
            onTap: () => context.read<SettingsCubit>().toggleService(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: state.isRunning
                    ? const LinearGradient(
                        colors: [Color(0xFF00E676), Color(0xFF00C853)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withValues(alpha: 0.6),
                          AppTheme.secondaryColor.withValues(alpha: 0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: state.isRunning
                        ? const Color(0xFF00E676).withValues(alpha: 0.4)
                        : AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    state.isRunning
                        ? Icons.stop_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 56,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.isRunning ? 'STOP' : 'START',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
